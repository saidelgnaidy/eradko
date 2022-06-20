// ignore_for_file: prefer_const_constructors, import_of_legacy_library_into_null_safe, unused_field, avoid_print
import 'dart:convert';
import 'package:eradko/main.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:eradko/auth/city_roles_provider.dart';
import 'package:eradko/auth/singin.dart';
import 'package:eradko/auth/widget/drop_down_list.dart';
import 'package:eradko/auth/widget/error_snack.dart';
import 'package:eradko/auth/widget/heder.dart';
import 'package:eradko/auth/widget/my_text_form_filed.dart';
import 'package:eradko/const.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart';

class SingUp extends StatefulWidget {

  final String initName,initEmail , initPass ;

  const SingUp({Key? key, required this.initName, required this.initEmail, required this.initPass}) : super(key: key);




  @override
  _SingUpState createState() => _SingUpState();
}

class _SingUpState extends State<SingUp> {

  String  _selectedRole = 'نوع الحساب' ,_selectedCity = 'المنطقة'  ;
  late int _cityId   ;
  int? _roleId ;
  late TextEditingController _nameCtrl ,_passwordCtrl,_emailCtrl,_rePasswordCtrl , _phoneCtrl;
  static Roles? roles ;
  List<String> errors  = [] ;


  _register({required AuthProvider auth}) async {
    setState(() {
      errors = [];
    });
      if (_nameCtrl.text != '' && _phoneCtrl.text != '' && _emailCtrl.text != '' && _roleId != null
          && _selectedCity != 'المنطقة' &&  _passwordCtrl.text != '' && _rePasswordCtrl.text != '' ) {
        try{
          Response response = await auth.register(
            locale:  AppLocalizations.of(context)!.localeName,
            role: _roleId ?? 1 , email: _emailCtrl.text, cityId: _cityId ,name: _nameCtrl.text ,
            password: _passwordCtrl.text , passwordConfirmation: _rePasswordCtrl.text, phone: _phoneCtrl.text,
          );
          if(response.statusCode == 200 || response.statusCode ==  201){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp() )) ;
          }else {
            showSnackError(context, msg: AppLocalizations.of(context)!.confairmData);
            List decodedErrors = jsonDecode(response.body)['errors'] ;
            for (var element in decodedErrors) {
              setState(() {
                errors.add(element['field']);
              });
            }
          }
        }catch(e){
          showSnackError(context, msg: AppLocalizations.of(context)!.conectApp);
        }
      } else {
        showSnackError(context, msg: AppLocalizations.of(context)!.completFiled);
      }
    }

  @override
  void initState() {
    _nameCtrl = TextEditingController(text: widget.initName );
    _emailCtrl = TextEditingController(text: widget.initEmail );
    _passwordCtrl = TextEditingController(text: widget.initPass );
    _rePasswordCtrl = TextEditingController(text: widget.initPass );
    _phoneCtrl = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) async => getRoles(locale: AppLocalizations.of(context)?.localeName));
    super.initState();
  }
  getRoles({String? locale})async{
    try{
      RolesProvider().roles(locale: locale ??  'ar').then((value) {
        if(mounted){
          setState(() {
            roles = value ;
          });
        }
      });
    }catch(e){
      showSnackError(context, msg: AppLocalizations.of(context)!.conectApp);
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child:  Header(txt:  widget.initName == '' ? AppLocalizations.of(context)!.registerNew : AppLocalizations.of(context)!.completedData),
              ),
              SizedBox(height: 10),
              widget.initName == '' ?
              CustomTextField(
                hintText: AppLocalizations.of(context)!.name,
                warning: errors.contains('name'),
                textEditingController: _nameCtrl,
                onChanged: (name) {
                },
                obscureText: false,
              ):SizedBox(),
              CustomTextField(
                hintText:  AppLocalizations.of(context)!.phone,
                warning: errors.contains('phone'),
                textEditingController: _phoneCtrl,
                onChanged: (phone) {
                },
                obscureText: false,
              ),
              widget.initName == '' ?
              CustomTextField(
                hintText:  AppLocalizations.of(context)!.email,
                warning: errors.contains('email'),
                textEditingController: _emailCtrl,
                onChanged: (email) {
                },
                obscureText: false,
              ):SizedBox(),
              SizedBox(height: 5),
              AccTypeList(
                roles: roles ?? Roles(data: []),
                onChanged: (String? val ) {
                  setState(() {
                    _selectedRole = val! ;
                    for (var acc in roles!.data) {
                      if(acc.name == val ) _roleId = acc.id ;
                    }
                  });
                },
                dropValue: roles == null ?  AppLocalizations.of(context)!.loading :  _selectedRole,
              ),
              SizedBox(height: 10),
              FutureBuilder<List<CityId>>(
                future: citiesList(context),
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    return  SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color:accentColor, width: 1.5),
                          ),
                          child: DropdownButton<String>(
                            hint: Text(_selectedCity,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            underline: Container(color: Colors.white),
                            onChanged: (val){
                              setState(() {
                                _selectedCity = val! ;
                              });
                              for (var element in snapshot.data!) {
                                if(element.arName == _selectedCity || element.enName == _selectedCity ){
                                  setState(() {
                                    _cityId = element.id ;
                                  });
                                }
                              }
                            },
                            items: snapshot.data!.map<DropdownMenuItem<String>>((CityId value) {
                              return DropdownMenuItem<String>(
                                value: value.arName,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 80,
                                  child: Text(value.arName ,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                    );
                  }else {
                    return const SizedBox(height: 50) ;
                  }
                },
              ),
              SizedBox(height: 5),
              widget.initName == '' ?
              CustomTextField(
                hintText:  AppLocalizations.of(context)!.password,
                warning: errors.contains('password'),
                textEditingController: _passwordCtrl,
                onChanged: (password) {
                },
                obscureText: true,
              ):SizedBox(),
              widget.initName == '' ?
              CustomTextField(
                hintText:  AppLocalizations.of(context)!.passwordConf,
                warning: errors.contains('password'),
                textEditingController: _rePasswordCtrl,
                onChanged: (confirm) {
                },
                obscureText: true,
              ):SizedBox(),
              SizedBox(height: 20),
              RawMaterialButton(
                disabledElevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                fillColor:  Colors.green,
                onPressed: auth.authStatusGetter == Status.registering ? null :() {
                  _register(auth: auth);
                },
                child:
                SizedBox(
                  height: 50,
                  child:  Center(
                    child: auth.authStatusGetter == Status.registering ?
                    JumpingDotsProgressIndicator(
                      fontSize: 40.0,
                      dotSpacing: 5,
                      color: Colors.white,
                      numberOfDots: 4,
                      milliseconds: 100,
                    ):
                    Text( AppLocalizations.of(context)!.create,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Text(
                      AppLocalizations.of(context)!.doHaveAccount ,
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const SignIn()),
                      );
                    },
                    child:   Text(
                      AppLocalizations.of(context)!.singInNew,
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
