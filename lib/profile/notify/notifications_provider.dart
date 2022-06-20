import 'dart:convert';
import 'package:eradko/profile/notify/notify_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:eradko/provider/app_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsProvider extends ChangeNotifier {
  List<MyNotification> notifications = [];
  int totalPages = 1, currentPage = 1;
  bool allSeen = true;

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

  Future<Map> getNotifications({required String locale, String? page = ''}) async {
    Map map = {"notifications": notifications, "totalPages": totalPages};

    try {
      Response response = await get(
        Uri.parse(AppUrl.notifications + (page == '' ? '' : '&page=$page')),
        headers: {
          'accept': 'application/json',
          'locale': locale,
          'Authorization': await bearerToken,
        },
      );

      if (response.statusCode == 200) {
        totalPages = jsonDecode(response.body)['meta']['last_page'];
        List result = List.from(json.decode(response.body)['data']);
        for (var noti in result) {
          notifications.add(
            MyNotification.fromJson(noti),
          );
        }
        if (notifications.isNotEmpty) {
          allSeen = notifications.where((element) => element.seen == 0).isEmpty ? true : false;
        } else {
          allSeen = true;
        }

        notifyListeners();
      } else {}
    } catch (e) {
      return map;
    }
    return map = {"notifications": notifications, "totalPages": totalPages};
  }

  Future markSeen({required int id}) async {
    allSeen = true;
    notifyListeners();
    try {
      await post(
        Uri.parse('${AppUrl.notifications}/$id/seen'),
        headers: {
          'accept': 'application/json',
          'Authorization': await bearerToken,
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
