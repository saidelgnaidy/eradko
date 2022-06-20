import 'dart:convert';


GetOrdersList ordersListFromJson(String str) => GetOrdersList.fromJson(json.decode(str));


class GetOrdersList {
  GetOrdersList({
    required this.data,
  });

  final List<OrderModel> data;

  factory GetOrdersList.fromJson(Map<String, dynamic> json) => GetOrdersList(
    data: List<OrderModel>.from(json["data"].map((x) => OrderModel.fromJson(x))),
  );
}

class OrderModel {
  OrderModel({
    required this.id,
    required this.receipt,
    required this.date,
  });

  final int id;
  final String receipt;
  final String date;

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    id: json["id"],
    receipt: json["receipt"],
    date: json["date"],
  );

}
