import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('ar') ;

  Locale get locale =>  _locale ;
  void switchLang(){
    String locale ;
    if(_locale ==  const Locale('ar')){
      _locale =  const Locale('en') ;
      locale = 'en' ;
    }else{
      _locale = const Locale('ar');
      locale = 'ar';
    }
    notifyListeners();
    saveLocale(locale);
  }

  void setLocale(String locale){
    _locale = Locale(locale) ;
  }

  Future<String> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    var locale = prefs.getString('locale') ?? 'ar';
    _locale = Locale(locale) ;
    return locale ;
  }

  Future<bool> saveLocale(String locale) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('locale', locale);
  }

}