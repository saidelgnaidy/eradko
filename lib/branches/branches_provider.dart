import 'dart:convert';
import 'package:eradko/provider/app_url.dart';
import 'package:eradko/provider/models.dart';
import 'package:http/http.dart'as http;
 class BranchesProvider{

  Future < List<Branches>> getBranches({ required String  locale}) async {
   List<Branches> branchesList = [] ;
   http.Response  response = await http.get(
       Uri.parse(AppUrl.getBranches) ,
       headers: {
        'accept': 'application/json',
        'locale': locale,
       });
   if(response.statusCode == 200 || response.statusCode == 201 ){
    var branchesListRes = json.decode(response.body) ;
    List list =  List.from(branchesListRes['data']).toList();
    for (var branch in list) {
     branchesList.add(
      Branches.fromJson(branch),
     );
    }
   }
   return branchesList ;
  }


 }