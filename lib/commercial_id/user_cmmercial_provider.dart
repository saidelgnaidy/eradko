
// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:convert';
import 'package:eradko/auth/city_roles_provider.dart';
import 'package:eradko/profile/profile_provider.dart';
import 'package:eradko/provider/app_url.dart';
import 'package:eradko/provider/models.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class UserCommercialProvider with ChangeNotifier {


  LocaleUser get userInfo => _user;
  LocaleUser _user = LocaleUser(
    name: 'null',
    userRoleId: 0,
    role: Role(id: 0, name: 'null'),
    phone: 'null',
    email: 'null',
    id: 0,
    commercialRegister: null,
    hasCommercial: false,
    commercialApproved: false,
  );


  bool isLoading = false ;
  toggleLoading(){
    isLoading = !isLoading ;
    notifyListeners();
  }

  String uploadMsg = '' ;
  setUploadMsg(String msg){
    uploadMsg = msg ;
    notifyListeners();
  }


  Future<LocaleUser> getUserData() async {
    try{
      http.Response  response = await http.get(Uri.parse(AppUrl.profileData),headers: {
        'accept': 'multipart/form-data',
        'Authorization': await ProfileProvider().bearerToken
      });
      var decoded = jsonDecode(response.body)['data'];
      if(response.statusCode == 200 || response.statusCode == 201){
        _user = LocaleUser.fromJson(decoded);
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }

    return _user;
  }

  Future uploadId() async {
    toggleLoading();
    setUploadMsg('');
    XFile? img = await ImagePicker().pickImage(source: ImageSource.gallery , imageQuality: 75);
    if(img != null ){
      try {
        setUploadMsg('Uploading...');
        var request = http.MultipartRequest('POST', Uri.parse(AppUrl.commercialRegister));

        request.files.add(await http.MultipartFile.fromPath('image', img.path));

        request.headers.addAll({
          'accept': 'multipart/form-data',
          'Authorization': await ProfileProvider().bearerToken
        });

        http.StreamedResponse response = await request.send();
        toggleLoading();
        if (response.statusCode == 200) {
          final respStr =await  response.stream.bytesToString();
          var decoded = jsonDecode( respStr);
         _user = LocaleUser.fromJson(decoded['user']);
          setUploadMsg('${decoded['message']}');
        } else {
          setUploadMsg( 'تأكد من اتصالك');
        }
      } catch (e) {
        toggleLoading();
        setUploadMsg( 'تأكد من اتصالك');
      }
    }else {
      toggleLoading();
      setUploadMsg( 'لم يتم اختيار ملف');
    }
  }

}