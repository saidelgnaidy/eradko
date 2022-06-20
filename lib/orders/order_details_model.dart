import 'dart:convert';

OrderDetailsModel orderDetailsFromJson(String str) => OrderDetailsModel.fromJson(json.decode(str)['data']) ;

class OrderDetailsModel {
  OrderDetailsModel({
    required this.id,
    required this.receipt,
    required this.date,
    required this.items,
    required this.paymentMethod,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.address,
  });

  final int id;
  final String receipt;
  final String date;
  final List<OrderItem> items;
  final String paymentMethod;
  final int subtotal;
  final double tax;
  final double total;
  final OrderAddress address;

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) => OrderDetailsModel(
    id: json["id"],
    receipt: json["receipt"],
    date: json["date"],
    items: List<OrderItem>.from(json["items"].map((x) => OrderItem.fromJson(x))),
    paymentMethod: json["payment_method"],
    subtotal: json["subtotal"],
    tax: json["tax"].toDouble(),
    total: json["total"].toDouble(),
    address: OrderAddress.fromJson(json["address"]),
  );
  
}

class OrderAddress {
  OrderAddress({
    required this.id,
    required this.phone,
    required this.street,
    required this.area,
    required this.nearestPlace,
    required this.cityId,
    required this.city,
    required this.latitude,
    required this.longitude,
  });

  final int id;
  final String phone;
  final String street;
  final String area;
  final String nearestPlace;
  final int cityId;
  final String city;
  final String latitude;
  final String longitude;

  factory OrderAddress.fromJson(Map<String, dynamic> json) => OrderAddress(
    id: json["id"],
    phone: json["phone"],
    street: json["street"],
    area: json["area"],
    nearestPlace: json["nearest_place"],
    cityId: json["city_id"],
    city: json["city"],
    latitude: json["latitude"],
    longitude: json["longitude"],
  );
  
}

class OrderItem {
  OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.image,
    required this.subtotal,
    required this.quantity,
    required this.tax,
    required this.total,
    required this.offer,
    required this.price,
    required this.offerPrice,
    required this.min,
    required this.max,
    required this.stock,
  });

  final int id;
  final int productId;
  final String productName;
  final String image;
  final int subtotal;
  final int quantity;
  final double tax;
  final double total;
  final int offer;
  final int price;
  final int offerPrice;
  final int min;
  final int max;
  final int stock;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    id: json["id"],
    productId: json["product_id"],
    productName: json["product_name"],
    image: json["image"],
    subtotal: json["subtotal"],
    quantity: json["quantity"],
    tax: json["tax"].toDouble(),
    total: json["total"].toDouble(),
    offer: json["offer"],
    price: json["price"],
    offerPrice: json["offer_price"],
    min: json["min"],
    max: json["max"],
    stock: json["stock"],
  );
  
}
