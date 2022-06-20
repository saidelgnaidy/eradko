

class ProductTileDetails {
  late int id, min, max, stock;
  late String name, image;
  late String price,  offerPrice  ;
  late double? offerPercentage  ;
  late bool securityClearance ;
  ProductTileDetails({
    required this.id,
    required this.min,
    required this.max,
    required this.stock,
    required this.price,
    required this.offerPrice,
    required this.name,
    required this.image,
    this.offerPercentage,
    required this.securityClearance,

  });
  factory ProductTileDetails.fromJson(Map<String, dynamic> product) {
    return ProductTileDetails(
      id: product['id'],
      name: product['name'],
      price: product['price'],
      offerPrice: product['offer_price'],
      min: product['min'],
      max: product['max'],
      stock: product['stock'],
      image: product['image'],
      securityClearance: product['security_clearance'] == 1 ? true : false,
      offerPercentage: product['offer_percentage'] == null ?
      ( 100 - ( double.parse(product['offer_price']) / double.parse(product['price']) * 100 ))
          : double.parse(product['offer_percentage'].toString()),
    );
  }
}

class Product {
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.offerPrice,
    required this.min,
    required this.max,
    required this.stock,
    required this.image,
    required this.description,
    this.properties,
    required this.videoLink,
    required this.sellingAt,
    required this.gallery,
    required this.productAttachments,
    required this.offerPercentage,
    required this.securityClearance,
  });

  int id;
  String name;
  String price;
  String offerPrice;
  double offerPercentage;
  int min;
  int max;
  int stock;
  String image;
  String description;
  List<Property>? properties;
  String videoLink;
  String sellingAt;
  List<Gallery> gallery;
  List<ProductAttachment> productAttachments;
  late bool securityClearance ;


  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      name: json["name"],
      price: json["price"],
      offerPercentage:  json['offer_percentage'] == null ?
      ( 100 - ( double.parse(json['offer_price']) / double.parse(json['price']) * 100 ))
          : double.parse(json['offer_percentage'].toString()),
      offerPrice: json["offer_price"] ?? '0.0',
      min: json["min"] ?? 0,
      max: json["max"] ?? 0,
      stock: json["stock"] ?? 0,
      image: json["image"] ?? 'https://eradico.murabba.dev/storage/products/product20/product1638738684.jpg',
      description: json["description"],
      properties: json["properties"] == null ? [] : List<Property>.from(json["properties"].map((x) => Property.fromJson(x))),
      videoLink: json["video_link"] ?? '',
      sellingAt: json["selling_at"] ?? '',
      gallery: [Gallery(image: json["image"])] + List<Gallery>.from(json["gallery"].map((x) => Gallery.fromJson(x))) ,
      securityClearance: json['security_clearance'] == 1 ? true : false,
      productAttachments: json["product_attachments"] == null ?[]: List<ProductAttachment>.from(json["product_attachments"].map((x) => ProductAttachment.fromJson(x))),
    );

  }
}

class Gallery {
  Gallery({required this.image,});
  String image;

  factory Gallery.fromJson(Map<String, dynamic> json) => Gallery(
    image: json["image"],
  );

}

class ProductAttachment {
  ProductAttachment({required this.file,});
  String file;

  factory ProductAttachment.fromJson(Map<String, dynamic> json) => ProductAttachment(
    file: json["file"],
  );

}

class Property {
  Property({
    required this.titleAr,
    required this.valueAr,
    required this.titleEn,
    required this.valueEn,
  });

  String titleAr;
  String valueAr;
  String titleEn;
  String valueEn;

  factory Property.fromJson(Map<String, dynamic> json) => Property(
    titleAr: json["title_ar"],
    valueAr: json["value_ar"],
    titleEn: json["title_en"],
    valueEn: json["value_en"],
  );
}