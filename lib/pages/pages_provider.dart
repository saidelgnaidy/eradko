import 'package:eradko/pages/models.dart';
import 'package:eradko/provider/app_url.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PagesProvider extends ChangeNotifier {
  PagesList _pages = PagesList(data: []);
  PagesList get pages => _pages;

  Future<PagesList> getPages({required String locale}) async {

    try {
      http.Response response = await http.get(Uri.parse(AppUrl.getPages),
          headers: {'accept': 'application/json', 'locale': locale});
      if (response.statusCode == 200 || response.statusCode == 201) {
        _pages = pagesListFromJson(response.body);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return _pages;
  }
}
