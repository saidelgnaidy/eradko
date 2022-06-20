import 'dart:convert';
import 'dart:core';
import 'package:another_flushbar/flushbar.dart';
import 'package:eradko/auth/widget/my_text_form_filed.dart';
import 'package:eradko/const.dart';
import 'package:eradko/profile/profile_edit.dart';
import 'package:eradko/profile/profile_provider.dart';
import 'package:eradko/profile/info_field.dart';
import 'package:eradko/provider/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class UserInformation extends StatefulWidget {
  const UserInformation({Key? key}) : super(key: key);

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> with AutomaticKeepAliveClientMixin {
  final ProfileProvider _profileProvider = ProfileProvider();

  showPasswordDialog(BuildContext context) {
    String oldPass = '', newPass = '', newPassConfirm = '';
    List<String> errors = [];
    bool loading = false;

    _updatePass(void Function(void Function()) setState) async {
      setState.call(() {
        errors = [];
        loading = true;
      });
      if (oldPass != '' && newPass != '' && newPassConfirm != '') {
        try {
          Response response = await ProfileProvider().changePassword(
              oldPass: oldPass,
              newPass: newPass,
              newPassConfirm: newPassConfirm);
          Map<String, dynamic> res = json.decode(response.body);
          if (response.statusCode == 200 || response.statusCode == 201) {
            Flushbar(
              message: AppLocalizations.of(context)!.passwordChanged,
              duration: const Duration(seconds: 5),
            ).show(context);
            setState.call(() {
              loading = false;
            });
          } else {
            setState.call(() {
              var list = List.from(res['errors']);
              for (var element in list) {
                List listE = element['message'];
                for (var e in listE) {
                  errors.add(e);
                }
              }
              loading = false;
            });
          }
        } catch (e) {
          setState.call(() {
            loading = false;
          });
          Flushbar(
            message: AppLocalizations.of(context)!.passwordChangeFailed,
            duration: const Duration(seconds: 5),
          ).show(context);
        }
      } else {
        setState.call(() {
          loading = false;
        });
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return Center(
              child: Material(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 30,
                  height: MediaQuery.of(context).size.height / 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        Text(
                          AppLocalizations.of(context)!.changePassword,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          hintText: AppLocalizations.of(context)!.oldPassword,
                          onChanged: (val) {
                            oldPass = val;
                          },
                          obscureText: true,
                        ),
                        CustomTextField(
                          hintText: AppLocalizations.of(context)!.newPassword,
                          onChanged: (val) {
                            newPass = val;
                          },
                          obscureText: true,
                        ),
                        CustomTextField(
                          hintText:
                              AppLocalizations.of(context)!.newPasswordConf,
                          onChanged: (val) {
                            newPassConfirm = val;
                          },
                          obscureText: true,
                        ),
                        Column(
                          children: errors.map((error) {
                            return Text(
                              error,
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                child: RawMaterialButton(
                                  onPressed: () {
                                    _updatePass(setState);
                                  },
                                  fillColor: accentColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  child: loading
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(
                                                Colors.white),
                                          ),
                                        )
                                      : Text(
                                          AppLocalizations.of(context)!.save,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                child: RawMaterialButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  fillColor: accentColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Text(
                                    AppLocalizations.of(context)!.close,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: FutureBuilder<LocaleUser>(
          future: _profileProvider.getUserData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  snapshot.data!.image == 'null' ?
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: Image.asset("assets/image/user (1).png"),
                  ) :
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          snapshot.data!.image,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  InfoField(info: snapshot.data!.name),
                  InfoField(info: snapshot.data!.email),
                  InfoField(info: snapshot.data!.phone),
                  InfoField(info: snapshot.data!.role.name),
                  const SizedBox(height: 50),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    width: double.infinity,
                    height: 45,
                    child: RawMaterialButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile(localeUser: snapshot.data!)));
                      },
                      fillColor: accentColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        AppLocalizations.of(context)!.updateProfile,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    width: double.infinity,
                    height: 45,
                    child: RawMaterialButton(
                      onPressed: () {
                        showPasswordDialog(context);
                      },
                      fillColor: accentColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        AppLocalizations.of(context)!.changePassword,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
