import 'dart:convert';
import 'dart:core';
import 'package:eradko/auth/city_roles_provider.dart';
import 'package:eradko/provider/app_url.dart';
import 'package:eradko/provider/models.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum Status { notLoggedIn, notRegistered, loggedIn, registered, authenticating, registering, added, notAdded }

class AuthProvider extends ChangeNotifier {
  Status authStatus = Status.notLoggedIn;
  Status get authStatusGetter => authStatus;
  Status addedStatus = Status.notAdded;
  Status get addedStatusGetter => addedStatus;
  late LatLng selectedPosition;
  selectedPositionSetter(LatLng latLng) {
    selectedPosition = latLng;
    notifyListeners();
    if (kDebugMode) {
      print(selectedPosition);
    }
  }

  bool isLoadingAddresses = false;
  bool get addressesStatus => isLoadingAddresses;
  authStateSetter(Status val) {
    authStatus = val;
    notifyListeners();
  }

  addedStateSetter(Status val) {
    addedStatus = val;
    notifyListeners();
  }

  List<UserAddress> userAddresses = [];
  List<UserAddress> get userAddressesGitter => userAddresses;

  String profileDataErrorMsg = '';
  String get profileDataError => profileDataErrorMsg;

  String _token = 'null';
  String get token => _token;

  LocaleUser get userInfo => user;
  LocaleUser user = LocaleUser(
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
  Future<String> get bearerToken async {
    var bearer = await getToken().then((value) {
      return 'Bearer $value';
    });
    return bearer;
  }

  Future<http.Response> register(
      {required String email,
      required String name,
      required String password,
      required String phone,
      required String passwordConfirmation,
      required int cityId,
      required String locale,
      required int role}) async {
    authStateSetter(Status.registering);
    return await http
        .post(Uri.parse(AppUrl.register),
            body: json.encode(
              {
                'email': email,
                'password': password,
                'password_confirmation': passwordConfirmation,
                'name': name,
                'phone': phone,
                'city_id': cityId,
                'user_role_id': role,
              },
            ),
            headers: {
              'Content-Type': 'application/json',
              'locale': locale,
            })
        .then(onValue)
        .catchError(onError);
  }

  Future onValue(http.Response response) async {
    Map<String, Object>? result;

    final Map<String, dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      AuthProvider().saveUserData(responseData['token'], LocaleUser.fromJson(responseData['data']));
      authStateSetter(Status.registered);
      result = responseData.cast<String, Object>();
    } else {
      result = responseData.cast<String, Object>();
      authStateSetter(Status.notRegistered);
    }
    if (kDebugMode) {
      print(result);
    }
    return response;
  }

  Future<http.Response> login({required String email, required String password, required String locale}) async {
    authStateSetter(Status.authenticating);

    http.Response response = await http.post(
      Uri.parse(AppUrl.login),
      body: json.encode({'email': email, 'password': password}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Authorization',
        'X-ApiKey': 'ZGlzIzEyMw==',
        'locale': locale,
      },
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      AuthProvider().saveUserData(responseData['token'], LocaleUser.fromJson(responseData['data']));
      authStateSetter(Status.loggedIn);
    } else {
      authStateSetter(Status.notLoggedIn);
    }
    return response;
  }

  onError(error) {
    authStateSetter(Status.notLoggedIn);
    if (kDebugMode) {
      print('On Error .........$error ');
    }
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? 'null';
    return _token;
  }

  Future saveUserData(String token, LocaleUser user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token.split('|').last);
    prefs.setString('name', user.name);
    prefs.setString('email', user.email);
    prefs.setString('phone', user.phone);
    prefs.setInt('roleId', user.role.id);
    prefs.setString('role', user.role.name);
    prefs.setString('image', '${user.image}');
  }

  void logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  //***********  getting user info ********************

  Future<http.Response> addEmailToSendCode({required String email, required String locale}) async {
    final http.Response response = await http.post(
      Uri.parse(AppUrl.addEmailToSendCode),
      body: {
        'email': email,
      },
      headers: {
        'accept': 'application/json',
        'locale': locale,
      },
    );
    return response;
  }

  Future<http.Response> verifyResetCode({required String email, required String resetCode, required String locale}) async {
    final http.Response response = await http.post(
      Uri.parse(AppUrl.verifyResetCode),
      body: {
        'email': email,
        'reset_code': resetCode,
      },
      headers: {
        'accept': 'application/json',
        'locale': locale,
      },
    );
    return response;
  }

  Future<http.Response> updatePasswordWithCode(
      {required String email, required String locale, required String code, required String password, required String configPassword}) async {
    final http.Response response = await http.post(
      Uri.parse(AppUrl.resetCode),
      body: {
        'email': email,
        'reset_code': code,
        'password': password,
        'password_confirmation': configPassword,
      },
      headers: {
        'accept': 'application/json',
        'locale': locale,
      },
    );
    return response;
  }
}
