import 'dart:convert';
import 'dart:core';
import 'package:eradko/provider/app_url.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:eradko/provider/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressesProvider extends ChangeNotifier {
  List<UserAddress> _userAddressList = [];
  List<UserAddress> get getUserAddresses => _userAddressList;

  bool loadingAddresses = false;

  Future<String> get bearerToken async {
    var bearer = await getToken().then((value) {
      return 'Bearer ${value!}';
    });
    return bearer;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<UserAddress>> getAddresses({required bool notify}) async {
    List<UserAddress> userAddressList = [];
    loadingAddresses = true;
    http.Response response = await http.get(Uri.parse(AppUrl.getAddresses), headers: {
      'accept': 'application/json',
      'Authorization': await bearerToken,
    });
    var addressesListRes = json.decode(response.body);
    loadingAddresses = false;
    if (notify) notifyListeners();
    if (response.statusCode == 200 || response.statusCode == 201) {
      List list = List.from(addressesListRes['data']).toList();
      for (var address in list) {
        userAddressList.add(
          UserAddress.fromJson(address),
        );
      }
    } else {
      Map<String, dynamic> res = json.decode(response.body);
      if (kDebugMode) {
        print('get addresses error $res');
      }
    }
    _userAddressList = userAddressList;
    if (notify) notifyListeners();

    return userAddressList;
  }

  Future<List<String>> addNewAddress(
      {int? id,
      required String street,
      required String phone,
      required String area,
      required String nearestPlace,
      required int cityId,
      required String lang,
      required String lat}) async {
    List<String> errors = [];
    try {
      http.Response response;
      if (id == null) {
        response = await http.post(
          Uri.parse(AppUrl.getAddresses),
          body: {
            'city_id': cityId.toString(),
            'area': area,
            'nearest_place': nearestPlace,
            'street': street,
            'phone': phone,
            'longitude': lang,
            'latitude': lat,
          },
          headers: {
            'accept': 'application/json',
            'Authorization': await bearerToken,
          },
        );
      } else {
        response = await http.patch(
          Uri.parse('${AppUrl.updateAddress}$id'),
          body: {
            'city_id': cityId.toString(),
            'area': area,
            'nearest_place': nearestPlace,
            'street': street,
            'phone': phone,
            'longitude': lang,
            'latitude': lat,
          },
          headers: {
            'accept': 'application/json',
            'Authorization': await bearerToken,
          },
        );
      }

      var decoded = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        errors = [];
        errors.add(decoded['message']);
        getAddresses(notify: true);
      } else {
        List list = List.from(decoded['errors']);
        for (var error in list) {
          List<String> errorList = List.from(error['message']);
          for (var element in errorList) {
            errors.add(element);
          }
        }
      }
    } catch (e) {
      errors.add('فشل تحديث العنوان');
    }
    return errors;
  }

  Future<String> deleteAddress(String id) async {
    try {
      final http.Response response = await http.delete(
        Uri.parse('${AppUrl.getAddresses}/$id'),
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': await bearerToken,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return 'تم حذف العنوان';
      } else {
        return 'حدثت مشكلة .. حاول مجددا';
      }
    } catch (e) {
      return 'تأكد من اتصالك';
    }
  }
}
