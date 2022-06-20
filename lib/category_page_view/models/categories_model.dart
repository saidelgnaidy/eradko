
class Category {
  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.subCategories,
  });

  int id;
  String name;
  String image ;
  List<SubCategory> subCategories;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    image: json["image"] ?? '',
    subCategories: List<SubCategory>.from(json["sub_categories"].map((x) => SubCategory.fromJson(x))),
  );
}

class SubCategory {
  SubCategory({
    required this.id,
    required this.name,
    required this.types,
    required this.image
  });

  int id;
  String name;
  String image ;
  List<Type> types;

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
    id: json["id"],
    name: json["name"],
    types: List<Type>.from(json["types"].map((x) => Type.fromJson(x))),
    image: json["image"] ?? '',
  );
}

class Type {
  Type({
    required this.id,
    required this.name,
    required this.image,
    required this.subTypes
  });

  int id;
  String name;
  String image ;
  final List<SubType> subTypes;

  factory Type.fromJson(Map<String, dynamic> json) => Type(
    id: json["id"],
    name: json["name"],
    image: json["image"] ?? '',
    subTypes: List<SubType>.from(json["sub_types"].map((x) => SubType.fromJson(x))),

  );
}

class CategoryPath {

 final String categoryName , supCatName , typeName , supTypeName;

 CategoryPath({
   required this.categoryName,
   required this.supCatName,
   required this.typeName,
   required this.supTypeName,
 });
}




class SubType {
  SubType({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory SubType.fromJson(Map<String, dynamic> json) => SubType(
    id: json["id"],
    name: json["name"],
  );
}

enum SupTypeState {
  protected  ,
  public  ,
  all ,
  none,
}
