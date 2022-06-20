import 'dart:convert';

import 'package:eradko/category_page_view/models/product_model.dart';
import 'package:eradko/provider/app_url.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class ProductsProvider {
  List<ProductTileDetails> allProducts = [];
  List<ProductTileDetails> allOffers = [];
  int totalProductsPages = 0;
  int totalOffersPages = 0;
  late Map allProductsMap = {};
  late Map allOffersMap = {};
  late Product productsDetails;

  //***************************  all products
  getAllProducts({required String categoryId, String? subCategoryId, String? typeId, String? supType, String? page, required String locale}) async {
    String endPoint =
        'category_id=$categoryId${page == '' ? '' : '&page=$page'}${subCategoryId == '' ? '' : '&sub_category_id=$subCategoryId'}${typeId == '' ? '' : '&type_id=$typeId'}${supType == '' ? '' : '&status=$supType'}';
    try {
      Response response = await get(Uri.parse(AppUrl.getAllProduct + endPoint), headers: {
        'accept': 'application/json',
        'locale': locale,
      });
      if (response.statusCode == 200) {
        totalProductsPages = jsonDecode(response.body)['meta']['last_page'];
        var allProduct = json.decode(response.body)['data'];
        for (var product in allProduct) {
          allProducts.add(ProductTileDetails.fromJson(product));
        }
      } else {
        if (kDebugMode) {
          print('all products error : response =   ${response.body}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('all products error :  $e');
      }
    }
    return allProductsMap = {
      'pages': totalProductsPages,
      'product_List': allProducts,
    };
  }

  // get all offers ....................
  getAllOffers({String? count, required String locale, int? page}) async {
    String endPoint = (count == null ? '' : '?items=$count') + (page == null ? '' : '?page=$page');
    try {
      Response response = await get(Uri.parse(AppUrl.getAllOffers + endPoint), headers: {
        'accept': 'application/json',
        'locale': locale,
      });
      if (response.statusCode == 200) {
        totalOffersPages = jsonDecode(response.body)['meta']['last_page'];
        List allProduct = json.decode(response.body)['data'];
        for (var product in allProduct) {
          allOffers.add(ProductTileDetails.fromJson(product));
        }
      } else {
        if (kDebugMode) {
          print('all Offers error : response =   ${response.body}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('all Offers error :  $e');
      }
    }

    return allOffersMap = {
      'pages': totalOffersPages,
      'product_List': allOffers,
    };
  }

  //******************* get product Details
  Future<Product> getProductDetails({required int id, required String locale}) async {
    try {
      Response response = await get(Uri.parse('${AppUrl.getProductDetails}/$id'), headers: {
        'accept': 'application/json',
        'locale': locale,
      });
      var product = json.decode(response.body)['data'];
      if (response.statusCode == 200) {
        productsDetails = Product.fromJson(product);
      } else {
        return productsDetails;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Product details error :  $e');
      }
      return productsDetails;
    }
    return productsDetails;
  }
}
