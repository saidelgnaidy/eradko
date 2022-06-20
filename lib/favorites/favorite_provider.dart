import 'dart:convert';
import 'dart:io';
import 'package:eradko/favorites/model.dart';
import 'package:eradko/provider/app_url.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteProvider extends ChangeNotifier {
  List<FavoriteList> favoriteList = [];
  List<FavoriteList> get favoriteListGitter => favoriteList;
  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token')!;
    return token;
  }

  Future<String> get bearerToken async {
    var bearer = await getToken().then((value) {
      return 'Bearer $value';
    });
    return bearer;
  }

  Future<String> addToFavorite({required int productId}) async {
    try {
      http.Response response = await http.post(
        Uri.parse(AppUrl.addToFavorite),
        headers: {
          'accept': 'application/json',
          'Authorization': await bearerToken,
        },
        body: {
          'product_id': productId.toString(),
        },
      );
      if (response.statusCode == 200) {
        return 'item Added Successfully';
      } else {
        return 'Something went wrong';
      }
    } on SocketException {
      return 'SocketException';
    } catch (e) {
      return e.toString();
    }
  }

  Future getFavorite({required String locale}) async {
    List<FavoriteList> favoriteList = [];
    http.Response response =
        await http.get(Uri.parse(AppUrl.addToFavorite), headers: {'accept': 'application/json', 'Authorization': await bearerToken, 'locale': locale});
    if (response.statusCode == 200 || response.statusCode == 201) {
      var favoriteListRes = json.decode(response.body);
      List list = List.from(favoriteListRes['data']).toList();
      for (var favorite in list) {
        favoriteList.add(
          FavoriteList.fromJson(favorite),
        );
      }
    } else {
      Map<String, dynamic> res = json.decode(response.body);
      if (kDebugMode) {
        print(res);
      }
    }
    return favoriteList = favoriteList;
  }

  Future<String> deleteFavorite(String id) async {
    try {
      final http.Response response = await http.delete(
        Uri.parse('${AppUrl.addToFavorite}/$id'),
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': await bearerToken,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return 'تم الحذف من المفضلة';
      } else {
        return 'حدثت مشكلة .. حاول مجددا';
      }
    } catch (e) {
      return 'تأكد من اتصالك';
    }
  }
}
