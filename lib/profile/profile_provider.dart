import 'dart:convert';
import 'dart:core';
import 'package:eradko/auth/auth_provider.dart';
import 'package:eradko/auth/city_roles_provider.dart';
import 'package:eradko/provider/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:eradko/provider/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider{

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  Future<String> get bearerToken async {
    var bearer = await getToken().then((value) {
      return 'Bearer ${value!}';
    });
    return bearer;
  }

  Future<LocaleUser> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    LocaleUser user = LocaleUser(
      email: prefs.getString('email') ?? 'email@clint.com',
      name: prefs.getString('name') ?? 'Guest',
      phone: prefs.getString('phone') ?? 'phone',
      userRoleId: prefs.getInt('roleId') ?? 0,
      id: 0,
      role: Role(id: prefs.getInt('roleId') ?? 0,name:prefs.getString('role') ?? 'personal' ),
      image: prefs.getString('image')??'null',
      commercialApproved: prefs.getBool('commercialApproved')?? false,
      commercialRegister: prefs.getString('commercialRegister')?? 'null',
      hasCommercial: prefs.getBool('hasCommercial')?? false,
    );
    return user ;
  }



  Future<String> updateProfileData({
    required String name,
    required String email,
    required String phone,
    required String img,
    required Role role,
  }) async {
    try {
      var request =
      http.MultipartRequest('POST', Uri.parse(AppUrl.updateProfileData));
      if (img != '') {
        request.files.add(await http.MultipartFile.fromPath('image', img));
      }
      request.headers.addAll({
        'accept': 'multipart/form-data',
        'Authorization': await bearerToken
      });
      request.fields.addAll({
        'name': name,
        'email': email,
        'user_role_id': '${role.id}',
        'phone': phone,
      });

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final respStr =await  response.stream.bytesToString();
        var decoded = jsonDecode( respStr)['user'];
        AuthProvider().saveUserData(await bearerToken , LocaleUser.fromJson(decoded) );
        return 'تم تحديث بياناتك ';
      } else {
        return 'تأكد من بياناتك';
      }
    } catch (e) {
      return 'تأكد من اتصالك';
    }
  }

  Future<http.Response> changePassword(
      {required String oldPass,
        required String newPass,
        required String newPassConfirm}) async {
    http.Response response = await http.post(
      Uri.parse(AppUrl.updatePassword),
      body: {
        'password': oldPass,
        'new_password': newPass,
        'new_password_confirmation': newPassConfirm,
      },
      headers: {
        'accept': 'application/json',
        'Authorization': await bearerToken,
      },
    );
    return response;
  }



}