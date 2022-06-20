import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class Lang {
  static  AppLocalizations of(context){
    return AppLocalizations.of(context)! ;
  }
}



Color textColor = const Color(0xff6D6D6D);
Color accentColor = const Color(0xff0E9E59);
Color accentDeActive = const Color(0xff878787);

TextStyle textStyle = TextStyle(color: textColor , overflow: TextOverflow.ellipsis , fontSize: 12) ;

class CityId {
   String arName , enName  ;
   int id ;
  CityId({required this.id, required this.arName, required this.enName}) ;

  CityId.fromJson(Map<String , dynamic> arCityInfo , enCityInfo, this.arName, this.enName, this.id){
    arName = arCityInfo['name'];
    id = arCityInfo['id'];
    enName = enCityInfo['name'];

  }

}

showToastMag({required String msg}){

  return Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: accentColor,
    textColor: Colors.white,
    fontSize: 12.0,
  );
}


Future<List<CityId>> citiesList(BuildContext context) async {
  List<CityId> cityList = [] ;

  var arCity = await  DefaultAssetBundle.of(context).loadString('assets/jsons/city_ar.json') ;
  var enCity = await  DefaultAssetBundle.of(context).loadString('assets/jsons/city_en.json') ;
  var arDecoded = json.decode(arCity);
  var enDecoded = json.decode(enCity);
  var arList = List.from(arDecoded);
  var enList = List.from(enDecoded);
  int index = 0 ;
  for (var map in arList) {
    cityList.add(
      CityId(arName :map['name'], id: map['id'], enName : enList[index]['name'],)
    );
    index++ ;
  }
  return cityList ;
}

Widget categoryPlaceholder(BuildContext context){
  return Shimmer.fromColors(
    baseColor: Colors.white,
    highlightColor: Colors.grey[300] ?? Colors.grey,
    child: AspectRatio(
      aspectRatio: 2.15,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
  );
}

