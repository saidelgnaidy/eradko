// ignore_for_file: prefer_const_constructors, unused_field, import_of_legacy_library_into_null_safe, avoid_print
import 'dart:convert';
import 'package:eradko/auth/auth_provider.dart';
import 'package:eradko/auth/reser_password/change_password.dart';
import 'package:provider/provider.dart';
import 'package:eradko/auth/widget/error_snack.dart';
import 'package:eradko/auth/widget/heder.dart';
import 'package:eradko/auth/widget/my_text_form_filed.dart';
import 'package:eradko/const.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../city_roles_provider.dart';

class SentVerifyCodeAndEmailState extends StatefulWidget {
  final String initEmail;

  const SentVerifyCodeAndEmailState({Key? key, required this.initEmail}) : super(key: key);

  @override
  State<SentVerifyCodeAndEmailState> createState() => _SentVerifyCodeAndEmailStateState();
}

class _SentVerifyCodeAndEmailStateState extends State<SentVerifyCodeAndEmailState> {
  String email = '';
  String _resetCode = '';
  List<String> errors = [];
  bool _isLoading = false;
  late TextEditingController _emailCtrl;
  Roles? roles;

  @override
  void initState() {
    _emailCtrl = TextEditingController(text: widget.initEmail);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getRoles(locale: AppLocalizations.of(context)!.localeName);
    });

    super.initState();
  }

  //----------------------
  getRoles({String? locale}) async {
    try {
      RolesProvider().roles(locale: locale ?? "ar").then((value) {
        if (mounted) {
          setState(() {
            roles = value;
          });
        }
      });
    } catch (e) {
      showSnackError(context, msg: AppLocalizations.of(context)!.conectApp);
    }
  }

  //----------------------------
  Future<bool> _verifyCode({required AuthProvider auth}) async {
    setState(() {
      errors = [];
      _isLoading = true;
    });
    if (_emailCtrl.text != '' && _resetCode != '') {
      Response response = await auth.verifyResetCode(email: _emailCtrl.text, resetCode: _resetCode, locale: AppLocalizations.of(context)!.localeName);
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ChangePasswordForget(
                      initEmail: email,
                      initCode: _resetCode,
                    ))).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              AppLocalizations.of(context)!.confairmMsEmail,
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 2),
          ));
        });
        return true;
      } else {
        showSnackError(context, msg: AppLocalizations.of(context)!.msNoEmail);
        List decodedErrors = jsonDecode(response.body)['message'];
        for (var element in decodedErrors) {
          setState(() {
            errors.add(element['message']);
            _isLoading = false;
          });
        }
        return false;
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      showSnackError(context, msg: AppLocalizations.of(context)!.msErrorEmail);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    return GestureDetector(
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: const Header(txt: ''),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Text(
                    AppLocalizations.of(context)!.enterCode,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                // CustomTextField(
                //   hintText:  AppLocalizations.of(context)!.email,
                //   textEditingController: _emailCtrl,
                //   warning: errors.contains('email'),
                //   onChanged: (val) {
                //     setState(() {
                //       errors.remove('email');
                //     });
                //     _email = val;
                //   },
                //   obscureText: false,
                // ),
                SizedBox(height: 20),

                CustomTextField(
                  hintText: AppLocalizations.of(context)!.confirmCode,
                  warning: errors.contains('reset_code '),
                  onChanged: (val) {
                    setState(() {
                      errors.remove('reset_code ');
                    });
                    _resetCode = val;
                  },
                  obscureText: false,
                ),
                SizedBox(height: 30),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  width: double.infinity,
                  height: 50,
                  child: RawMaterialButton(
                    onPressed: () => _isLoading ? null : _verifyCode(auth: auth),
                    fillColor: accentColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ))
                        : Text(
                            AppLocalizations.of(context)!.send,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
