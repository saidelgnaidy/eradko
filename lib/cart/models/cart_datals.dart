
class CartDetails {
  CartDetails({
    required this.id,
    required this.userId,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.items,
  });

  int id;
  int userId;
  double subtotal;
  double tax;
  double total;
  List<Item> items;

  factory CartDetails.fromJson(Map<String, dynamic> json) => CartDetails(
    id: json["id"],
    userId: json["user_id"],
    subtotal:double. parse( json["subtotal"].toString()),
    tax: double.parse(json["tax"].toString()),
    total: double.parse(json["total"].toString()),
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
  );
}

class Item {
  Item({
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

  int id;
  int productId;
  int quantity;
  String productName;
  String image;
  double subtotal;
  double tax;
  double total;
  double offer;
  double price;
  double offerPrice;
  int min;
  int max;
  int stock;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    productId: json["product_id"],
    productName: json["product_name"],
    quantity: json["quantity"],
    image: json["image"],
    subtotal: double.parse('${json["subtotal"]}'),
    tax: double.parse('${json["tax"]}'),
    total: double.parse('${json["total"]}'),
    offer: double.parse('${json["offer"]}'),
    price: double.parse('${json["price"]}'),
    offerPrice: double.parse('${json["offer_price"]}'),
    min: int.parse('${json["min"]}'),
    max: int.parse('${json["max"]}'),
    stock: int.parse('${json["stock"]}'),
  );


}

