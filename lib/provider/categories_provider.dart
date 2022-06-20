import 'dart:convert';
import 'package:eradko/category_page_view/models/categories_model.dart';
import 'package:eradko/provider/app_url.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class CategoriesProvider extends ChangeNotifier {
  CategoryPath categoryPath = CategoryPath(categoryName: '', supCatName: '', typeName: '', supTypeName: '');

  categoryPathSetter(CategoryPath path) {
    categoryPath = path;
    notifyListeners();
  }

  CategoryPath get categoryPathGetter => categoryPath;

  Future<List<Category>> getMainCategory({required int id, required String locale}) async {
    List<Category> mainCategoryList = [];
    try {
      Response response = await get(Uri.parse('${AppUrl.getMainCategory}/$id'), headers: {
        'accept': 'application/json',
        'locale': locale,
      });

      if (response.statusCode == 200) {
        var mainCategory = json.decode(response.body)['data'];
        for (var mainCat in mainCategory) {
          mainCategoryList.add(Category.fromJson(mainCat));
        }
      } else {}
    } catch (e) {
      return mainCategoryList;
    }
    return mainCategoryList;
  }
}
