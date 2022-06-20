import 'dart:convert';

import 'package:eradko/orders/order_details_model.dart';
import 'package:eradko/orders/orders_list_model.dart';
import 'package:eradko/provider/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class OrdersProvider  {

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

  Future<GetOrdersList> getOrdersList({required String locale})async {
    GetOrdersList ordersList = GetOrdersList(data: []) ;
    try{
      http.Response response = await http.get(Uri.parse(AppUrl.orders),
        headers: {
          'accept': 'application/json',
          'locale': locale,
          'Authorization': await bearerToken,
        },
      );
      if(response.statusCode == 200){
        ordersList =  ordersListFromJson(response.body);
      }else{
        return ordersList ;
      }

    }catch(e){
      return ordersList ;
    }
    return ordersList ;
  }

  Future<OrderDetailsModel?> getOrderDetails({required String locale , required int id })async {
    OrderDetailsModel? orderDetailsModel ;
    try{
      http.Response response = await http.get(Uri.parse('${AppUrl.orders}/$id'),
        headers: {
          'accept': 'application/json',
          'locale': locale,
          'Authorization': await bearerToken,
        },
      );
      if(response.statusCode == 200){
        orderDetailsModel =  orderDetailsFromJson(response.body);
      }

    }catch(e){
      return orderDetailsModel ;
    }
    return orderDetailsModel ;
  }

  Future<String> cancelOrder({ required int id })async {
    try{
      http.Response response = await http.post(Uri.parse('${AppUrl.orders}/$id/canceled'),
        headers: {
          'accept': 'application/json',
          'Authorization': await bearerToken,
        },
      );
      return  jsonDecode(response.body)['message'];


    }catch(e){
      return 'Something went Wrong' ;
    }
  }



}