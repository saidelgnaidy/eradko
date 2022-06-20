
import 'dart:convert';
import 'dart:io';
import 'package:eradko/cart/models/cart_datals.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eradko/provider/app_url.dart';
import 'package:http/http.dart' as http;

class CartProvider  extends ChangeNotifier{
  late CartDetails cartDetails ;
  late Map cartDataMap ;

  Future<String> getToken() async {
    final  prefs = await SharedPreferences.getInstance() ;
    var token = prefs.getString('token')! ;
    return token;
  }

  Future<String> get bearerToken  async {
    var bearer =  await getToken().then((value) {
      return 'Bearer $value';
    });
    return bearer ;
  }


  Future<Map> getCartData() async {

    try{
      http.Response response = await http.get(
        Uri.parse(AppUrl.getCartData),
        headers:{
          'accept': 'application/json',
          'X-CSRF-TOKEN': '',
          'Authorization': await bearerToken,
        }
      ) ;
      if(response.statusCode == 200) {
        var json = jsonDecode(response.body)['data'];
        cartDetails = CartDetails.fromJson(json);
        cartDataMap = {
          'status' : true ,
          'data' : cartDetails ,
        };
      } else{
        cartDataMap = {
          'status' : false ,
          'data' : jsonDecode(response.body)['error']['message'] ,
        };
      }
    } on SocketException {
      cartDataMap = {
        'status' : false ,
        'data' : 'SocketException' ,
      };
    }catch(e){
      cartDataMap = {
        'status' : false ,
        'data' : e ,
      };
    }
    return cartDataMap ;
  }

  Future<bool> addToCart({required int productId , required int quantity }) async {
    try{
      http.Response response = await http.post(
        Uri.parse(AppUrl.addToCart),
        headers:{
          'accept': 'application/json',
          'Authorization': await bearerToken,
        },
        body: {
          'product_id': productId.toString(),
          'quantity': quantity.toString(),
        },
      ) ;
      if(response.statusCode == 200 || response.statusCode == 201){
        return true ;
      }
      else{
        return false ;
      }
    }catch(e){
      return false ;
    }
  }

  Future<Map<String , dynamic>> deleteItem({required int productIdInCart }) async {
    late Map<String , dynamic> cartAfterDeletion ;
    try{
      http.Response response = await http.delete(
        Uri.parse(AppUrl.deleteCartItem + productIdInCart.toString()),
        headers:{
          'accept': 'application/json',
          'Authorization': await bearerToken,
        },
      ) ;
      if(response.statusCode == 200 ){
        var json = jsonDecode(response.body)['data'];
        CartDetails cartFromJson = CartDetails.fromJson(json);
        cartAfterDeletion = {
          'state': true,
          'msg':'item Deleted Successfully',
          'data': cartFromJson,
        };
      }else{
        cartAfterDeletion = {
          'state': true,
          'msg':'Something went wrong',
        };
      }
    } on SocketException {
      cartAfterDeletion = {
        'state': true,
        'msg':'SocketException',
      };
    }catch(e){
      cartAfterDeletion = {
        'state': true,
        'msg':e.toString(),
      };
    }
    return cartAfterDeletion ;
  }

  Future<Map<String , dynamic>> updateItemQuantity({required int productIdInCart ,required int quantity }) async {
    late Map<String , dynamic> cartAfterDeletion ;
    try{
      http.Response response = await http.patch(
        Uri.parse('${AppUrl.updateCartItemQuantity}$productIdInCart/'),
        headers:{
          'accept': 'application/json',
          'Authorization': await bearerToken,
        },
        body: {
          'quantity': quantity.toString(),
          '_method':'PATCH'
        },
      ) ;
      if(response.statusCode == 200 ){
        var json = jsonDecode(response.body)['data'];
        CartDetails cartFromJson = CartDetails.fromJson(json);
        cartAfterDeletion = {
          'state': true,
          'msg':'Item Quantity updated Successfully',
          'data': cartFromJson,
        };
      }else{
        cartAfterDeletion = {
          'state': true,
          'msg':'Something went wrong',
        };
      }
    } on SocketException {
      cartAfterDeletion = {
        'state': true,
        'msg':'SocketException',
      };
    }catch(e){
      cartAfterDeletion = {
        'state': true,
        'msg':e.toString(),
      };
    }
    return cartAfterDeletion ;
  }




}