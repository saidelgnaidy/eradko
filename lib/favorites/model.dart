class FavoriteList {
  int id;
  String name;
  String price;
  String offerPrice;
  int? min;
  int? max;
  int? stock;
  String image;

  FavoriteList(
      {required this.id,
      required this.name,
      required this.price,
      required this.offerPrice,
      this.min,
      this.max,
      this.stock,
      required this.image});

  factory FavoriteList.fromJson(Map<String, dynamic> json) {
    return FavoriteList(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        offerPrice: json['offer_price'],
        min: json['min'],
        max: json['max'],
        stock: json['stock'],
        image: json['image'],
      );}
}
