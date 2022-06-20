import 'package:eradko/auth/city_roles_provider.dart';
import 'package:eradko/auth/singin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:eradko/auth/widget/error_snack.dart';
import 'package:eradko/auth/widget/heder.dart';
import 'package:eradko/auth/widget/my_text_form_filed.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:eradko/auth/auth_provider.dart';

import '../../const.dart';

class ChangePasswordForget extends StatefulWidget {
  final String initEmail, initCode;
  const ChangePasswordForget({Key? key, required this.initEmail, required this.initCode}) : super(key: key);

  @override
  State<ChangePasswordForget> createState() => _ChangePasswordForget();
}

class _ChangePasswordForget extends State<ChangePasswordForget> {
  late TextEditingController _emailCtrl;
  late TextEditingController _codeCtrl;
  Roles? roles;
  final bool _isLoading = false;
  List<String> errors = [];
  String email = '', _password = '', _confirmPassword = '';

  Future<bool> _resetCode({required AuthProvider auth}) async {
    setState(() {
      errors = [];
    });
    if (_emailCtrl.text != '' && _codeCtrl.text != '' && _password != '' && _confirmPassword != '') {
      Response response = await auth.updatePasswordWithCode(
        email: _emailCtrl.text,
        code: _codeCtrl.text,
        password: _password,
        configPassword: _confirmPassword,
        locale: AppLocalizations.of(context)!.localeName,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            AppLocalizations.of(context)!.passwordUpdated,
            textAlign: TextAlign.center,
          ),
          duration: const Duration(seconds: 2),
        ));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn(initEmail: email, initPassword: _password)));
        return true;
      } else {
        showSnackError(context, msg: AppLocalizations.of(context)!.confairmData);
        List decodedErrors = jsonDecode(response.body)['errors'];
        for (var error in decodedErrors) {
          setState(() {
            errors.add(error['field']);
            if (kDebugMode) {
              print(error);
            }
          });
        }
        return false;
      }
    } else {
      showSnackError(context, msg: AppLocalizations.of(context)!.confairmData);
      return false;
    }
  }

  @override
  void initState() {
    _emailCtrl = TextEditingController(text: widget.initEmail);
    _codeCtrl = TextEditingController(text: widget.initCode);
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

//---------------------------

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Header(txt: ''),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  AppLocalizations.of(context)!.newPasswordInForget,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              // CustomTextField(
              //   textEditingController: _emailCtrl,
              //   hintText: AppLocalizations.of(context)!.email,
              //   warning: errors.contains('email'),
              //   onChanged: (email) {
              //     _email = email;
              //   },
              //   obscureText: false,
              // ),
              // const SizedBox(height: 10),
              // CustomTextField(
              //   textEditingController: _codeCtrl,
              //   hintText: AppLocalizations.of(context)!.confirmCode,
              //   warning: errors.contains('code'),
              //   onChanged: (code) {
              //     setState(() {
              //       errors = [];
              //     });
              //     _code = code;
              //   },
              //   obscureText: false,
              // ),
              CustomTextField(
                hintText: AppLocalizations.of(context)!.password,
                warning: errors.contains('password'),
                onChanged: (password) {
                  setState(() {
                    errors = [];
                  });
                  _password = password;
                },
                obscureText: true,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hintText: AppLocalizations.of(context)!.passwordConf,
                warning: errors.contains('password'),
                onChanged: (confirm) {
                  setState(() {
                    errors = [];
                  });
                  _confirmPassword = confirm;
                },
                obscureText: true,
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 40),
              RawMaterialButton(
                disabledElevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                fillColor: Colors.green,
                onPressed: () {
                  _isLoading ? const CircularProgressIndicator() : _resetCode(auth: auth);
                },
                child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.save,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
