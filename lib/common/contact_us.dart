import 'package:eradko/auth/widget/my_text_form_filed.dart';
import 'package:eradko/common/contact_us_provider.dart';
import 'package:eradko/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';


showContactUsDialog(BuildContext context) {
  List<String> errors = [];
  bool loading = false;
  String name = '', phone = '', email = '', msg = '' ;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) {
          return Center(
            child: Material(
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 15),
                    Text(
                      AppLocalizations.of(context)!.callUs,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      hintText: AppLocalizations.of(context)!.name,
                      onChanged: (val) {
                        name = val ;
                      },
                      obscureText: false,
                      warning: errors.contains('name'),
                    ),
                    CustomTextField(
                      hintText: AppLocalizations.of(context)!.email,
                      onChanged: (val) {
                        email = val ;
                      },
                      obscureText: false,
                      warning: errors.contains('email'),
                    ),
                    CustomTextField(
                      hintText: AppLocalizations.of(context)!.phone,
                      onChanged: (val) {
                        phone = val ;
                      },
                      obscureText: false,
                      warning: errors.contains('phone'),
                    ),
                    Container(
                      height: 200,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      margin: const EdgeInsets.symmetric( vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: accentColor.withOpacity(.6)  , width: 1.5 ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        onChanged:  (val){
                          msg = val ;
                        },
                        cursorColor: textColor,
                        maxLines: 10,
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          border: InputBorder.none,
                          hintText:AppLocalizations.of(context)!.localeName == 'ar' ? 'رسالتك' :'message',
                          hintStyle: TextStyle(
                            color: textColor.withOpacity(.6),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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
                                setState.call((){
                                  loading = true ;
                                  errors = [] ;
                                } );
                                ContactUsProvider().sendMassage(locale: AppLocalizations.of(context)!.localeName, phone: phone, name: name, email: email, msg: msg ).then((value) {
                                  setState.call((){
                                    errors = value ;
                                    loading = false ;
                                  });
                                });
                              },
                              fillColor: accentColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              child: loading ? const Center(
                                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white),),) :
                              Text(
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
          );
        },
      );
    },
  );
}