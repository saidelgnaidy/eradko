// ignore_for_file: prefer_const_constructors, unused_field, import_of_legacy_library_into_null_safe, avoid_print
import 'dart:convert';
import 'package:eradko/auth/auth_provider.dart';
import 'package:eradko/auth/reser_password/veritivy_reset_code.dart';
import 'package:provider/provider.dart';
import 'package:eradko/auth/widget/error_snack.dart';
import 'package:eradko/auth/widget/heder.dart';
import 'package:eradko/auth/widget/my_text_form_filed.dart';
import 'package:eradko/const.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
class SentResetCode extends StatefulWidget {
  const SentResetCode({Key? key}) : super(key: key);

  @override
  State<SentResetCode> createState() => _SentResetCodeState();
}

class _SentResetCodeState extends State<SentResetCode> {
  String _email = '';
  List<String> errors = [];
  bool _isLoading = false;


  Future<bool> _addEmailToSendCode({required AuthProvider auth}) async {
    setState(() {
      errors = [];
      _isLoading = true ;
    });
    if (_email.trim() != '') {

      Response response =
          await auth.addEmailToSendCode(email: _email, locale:  AppLocalizations.of(context)!.localeName);
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _isLoading = false ;
        });
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SentVerifyCodeAndEmailState(initEmail: _email,))).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.confairmMsEmail,
                textAlign: TextAlign.center,
              ),
            duration: Duration(seconds: 2),
          ));
        });
        return true;
      } else {
        showSnackError(context, msg: AppLocalizations.of(context)!.msNoEmail );
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
        _isLoading = false ;
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
                      AppLocalizations.of(context)!.enterEmail,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                CustomTextField(
                  hintText:  AppLocalizations.of(context)!.email,
                  warning: errors.contains('email'),
                  onChanged: (val) {
                    setState(() {
                      errors.remove('email');
                    });
                    _email = val;
                  },
                  obscureText: false,
                ),
                SizedBox(height: 40),

                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  width: double.infinity,
                  height: 50,
                  child: RawMaterialButton(
                    onPressed: ()=> _isLoading ? null : _addEmailToSendCode(auth: auth) ,
                    fillColor: accentColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: _isLoading ?
                    Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white),)) :
                    Text(AppLocalizations.of(context)!.send,
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
