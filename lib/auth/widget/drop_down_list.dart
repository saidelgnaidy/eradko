import 'package:eradko/auth/city_roles_provider.dart';
import 'package:eradko/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
class AccTypeList extends StatelessWidget {
  final String dropValue ;
  final Roles? roles  ;
  final Function(String?) onChanged ;
  const AccTypeList({Key? key, required this.dropValue, required this.roles, required this.onChanged}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    citiesList(context);

    final Size size = MediaQuery.of(context).size ;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color:accentColor.withOpacity(.5), width: 1.5),
        ),
        child: DropdownButton<String>(
          hint: Text(dropValue,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          underline: Container(color: Colors.white),
          onChanged: onChanged ,
          items: roles!.data.map<DropdownMenuItem<String>>((Role value) {
            return DropdownMenuItem<String>(
              value: value.name,
              child: SizedBox(
                width: size.width - 80,
                child: Text(value.name ,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}



class CityIdList extends StatelessWidget {
  final CityId dropValue ;
  final Function(String?) onChanged ;
  const CityIdList({Key? key, required this.dropValue, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size ;

    return FutureBuilder<List<CityId>>(
      future: citiesList(context),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return SizedBox(
            width: double.infinity,
            height: 50,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color:accentColor, width: 1.5),
              ),
              child: DropdownButton<String>(
                hint: Text(dropValue.arName,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                underline: Container(color: Colors.white),
                onChanged: onChanged,
                items: snapshot.data!.map<DropdownMenuItem<String>>((CityId value) {
                  return DropdownMenuItem<String>(
                    value: value.arName,
                    child: SizedBox(
                      width: size.width - 80,
                      child: Text(AppLocalizations.of(context)!.localeName == 'ar' ? value.arName : value.enName,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        }else {
          return const SizedBox(
            height: 50,
          ) ;
        }
      }
    );
  }
}