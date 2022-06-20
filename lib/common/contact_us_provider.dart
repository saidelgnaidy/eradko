import 'dart:convert';
import 'package:eradko/provider/app_url.dart';
import 'package:http/http.dart' as http;

class ContactUsProvider {


  Future<List<String>> sendMassage({required String locale ,required String phone ,required String name , required String email , required String msg}) async {
    List<String> res = [];
    if(phone != '' && name != '' && email != '' && msg != ''){
      try {
        http.Response response = await http.post(Uri.parse(AppUrl.contactUs),
          headers: {'accept': 'application/json', 'locale': locale},
          body: {
            'phone':phone ,
            'name':name ,
            'email':email ,
            'message':msg ,
          },
        );
        var decoded = jsonDecode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          res.add(decoded['message']);
        }else{
          List list =  decoded['errors'];
          for (var element in list) {
            res.add(element['field']);
          }
        }
      } catch (e) {
        res.add('فشل الارسال');
      }
    }else{
      res.add('أكمل جميع الحقول');
    }
    return res ;
  }
}
