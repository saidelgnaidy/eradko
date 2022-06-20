// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:eradko/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:eradko/auth/reser_password/write_email.dart';
import 'package:eradko/auth/singup.dart';
import 'package:eradko/auth/widget/error_snack.dart';
import 'package:eradko/auth/widget/heder.dart';
import 'package:eradko/auth/widget/my_text_form_filed.dart';
import 'package:eradko/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:auth_buttons/auth_buttons.dart';
//import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';

class SignIn extends StatefulWidget {
  final String? initPassword, initEmail;

  const SignIn({Key? key, this.initPassword, this.initEmail}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late String _email = '', _password = '';
  List<String> errors = [];
  late TextEditingController _passwordCtrl, _emailCtrl;
  bool socialAuth = false;
  bool normalLoading = false;

  @override
  void initState() {
    _emailCtrl = TextEditingController(text: widget.initEmail ?? '');
    _passwordCtrl = TextEditingController(text: widget.initPassword ?? '');
    super.initState();
  }

  Future<bool> _logIn({required bool isSocial}) async {
    setState(() {
      errors = [];
      isSocial ? normalLoading = false : normalLoading = true;
    });
    if (_email.trim() != '' && _password != '') {
      Response response = await AuthProvider().login(locale: AppLocalizations.of(context)!.localeName, email: _email, password: _password);
      setState(() {
        normalLoading = false;
        socialAuth = false;
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MyApp()), (route) => false);
        return true;
      } else if (isSocial) {
        return false;
      } else {
        showSnackError(context, msg: AppLocalizations.of(context)!.confairmData);
      }
    } else {
      setState(() {
        normalLoading = false;
        socialAuth = false;
      });
      showSnackError(context, msg: AppLocalizations.of(context)!.completFiled);
    }
    return false;
  }

  Future signInWithGoogle() async {
    setState(() => socialAuth = true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      setState(() => socialAuth = false);
      if (googleUser != null) {
        _email = googleUser.email;
        _password = googleUser.email;
        bool googleSignIn = await _logIn(isSocial: true);
        if (!googleSignIn) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SingUp(
                initName: googleUser.displayName ?? '',
                initEmail: _email,
                initPass: _password,
              ),
            ),
          );
        } else {
          showSnackError(context, msg: AppLocalizations.of(context)!.confairmData);
        }
      }
    } catch (e) {
      setState(() => socialAuth = false);
      if (kDebugMode) {
        print(e);
      }
      showSnackError(context, msg: AppLocalizations.of(context)!.conectApp);
    }
  }

  Future signInWithFacebook() async {
    setState(() => socialAuth = true);
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );
      setState(() => socialAuth = false);

      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.i.getUserData(fields: "name,email,id");
        _email = userData['email'];
        _password = userData['email'];
        bool facebookSignIn = await _logIn(isSocial: true);
        if (!facebookSignIn) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SingUp(
                initPass: _password,
                initName: userData['name'],
                initEmail: _email,
              ),
            ),
          );
        } else {
          showSnackError(context, msg: AppLocalizations.of(context)!.confairmData);
        }
      }
    } catch (e) {
      setState(() => socialAuth = false);
      showSnackError(context, msg: AppLocalizations.of(context)!.conectApp);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Header(txt: AppLocalizations.of(context)!.singIn),
                    const SizedBox(height: 20),
                    CustomTextField(
                      hintText: AppLocalizations.of(context)!.email,
                      warning: errors.contains('email'),
                      textEditingController: _emailCtrl,
                      onChanged: (val) {
                        setState(() {
                          errors.remove('email');
                        });
                        _email = val;
                      },
                      obscureText: false,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      hintText: AppLocalizations.of(context)!.password,
                      textEditingController: _passwordCtrl,
                      warning: errors.contains('password'),
                      onChanged: (val) {
                        setState(() {
                          errors.remove('password');
                        });
                        _password = val;
                      },
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    RawMaterialButton(
                      disabledElevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fillColor: Colors.green,
                      onPressed: normalLoading ? null : () => _logIn(isSocial: false),
                      child: SizedBox(
                        height: 50,
                        child: Center(
                          child: normalLoading
                              ? JumpingDotsProgressIndicator(
                                  fontSize: 40.0,
                                  dotSpacing: 5,
                                  color: Colors.white,
                                  numberOfDots: 4,
                                  milliseconds: 100,
                                )
                              : Text(
                                  AppLocalizations.of(context)!.singIn,
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
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SentResetCode()));
                      },
                      child: Text(
                        AppLocalizations.of(context)!.forgetPass,
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                flex: 1,
                                child: GoogleAuthButton(
                                  onPressed: () {
                                    signInWithGoogle();
                                  },
                                  text: 'Google',
                                  darkMode: false,
                                  style: const AuthButtonStyle(
                                    buttonType: AuthButtonType.icon,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 1,
                                child: AppleAuthButton(
                                  onPressed: () {},
                                  text: 'Apple',
                                  darkMode: false,
                                  style: const AuthButtonStyle(
                                    buttonType: AuthButtonType.icon,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 1,
                                child: FacebookAuthButton(
                                  text: 'Facebook',
                                  onPressed: () {
                                    signInWithFacebook();
                                  },
                                  darkMode: false,
                                  style: const AuthButtonStyle(
                                    buttonType: AuthButtonType.icon,
                                    iconType: AuthIconType.secondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.doyouRegister,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 15),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SingUp(
                                          initEmail: '',
                                          initName: '',
                                          initPass: '',
                                        )),
                              );
                            },
                            child: Text(
                              AppLocalizations.of(context)!.register,
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            socialAuth
                ? Container(
                    color: Colors.black12,
                    width: size.width,
                    height: size.height,
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
