import 'package:eradko/auth/city_roles_provider.dart';

class OffersSlider {
  final String image;
  final int id, priority;

  OffersSlider({required this.id, required this.priority, required this.image});

  factory OffersSlider.formJson(Map<String, dynamic> map) {
    return OffersSlider(
        id: map['id'], image: map['image'], priority: map['priority']);
  }
}

class Section {
  final String name, image;
  final int id;

  Section({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Section.formJson(Map<String, dynamic> ar) {
    return Section(
      id: ar['id'],
      name: ar['name'],
      image: ar['image'],
    );
  }
}


class LocaleUser {
  LocaleUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.userRoleId,
    required this.role,
    required this.hasCommercial,
    required this.commercialApproved,
    required this.commercialRegister,
    this.image,
  });

  int id;
  String name;
  String email;
  String phone;
  int userRoleId;
  Role role;
  bool hasCommercial ,commercialApproved ;
  dynamic image , commercialRegister;

  factory LocaleUser.fromJson(Map<String, dynamic> json) => LocaleUser(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    userRoleId: json["user_role_id"],
    role: Role.fromJson(json["type"]),
    image: json["image"],
    commercialRegister: json["commercial_register"],
    commercialApproved: json["commercial_approved"]== 1 ? true : false,
    hasCommercial: json["has_commercial"] == 1 ? true : false ,
  );
}

class UserAddress {
  int id, cityId;
  String phone, street, area, nearestPlace, city, lang, lat;

  UserAddress({
    required this.id,
    required this.phone,
    required this.street,
    required this.area,
    required this.nearestPlace,
    required this.cityId,
    required this.city,
    required this.lang,
    required this.lat,
  });
  factory UserAddress.fromJson(Map<String, dynamic> address) {
    return UserAddress(
      id: address['id'],
      phone: address['phone'],
      street: address['street'],
      area: address['area'],
      nearestPlace: address['nearest_place'],
      cityId: address['city_id'],
      city: address['city'],
      lang: address['longitude'],
      lat: address['latitude'],
    );
  }
}

//*******************media
class Article {
  final int id;
  final String image;
  final String title;
  final String? description, date;

  Article(
      {this.description,
      required this.id,
      required this.image,
      required this.title,
      this.date});
  factory Article.fromJson(Map<String, dynamic> ar) {
    return Article(
      image: ar['image'],
      id: ar['id'],
      title: ar['title'],
      description: ar['description'],
      date: ar['date'],
    );
  }
}

class MediaPhoto {
  final int id;
  final String image;
  final String title;
  final List? images;

  MediaPhoto(
      {required this.id,
      required this.image,
      required this.title,
      this.images});
  factory MediaPhoto.fromJson(Map<String, dynamic> photo) {
    return MediaPhoto(
      image: photo['image'],
      id: photo['id'],
      title: photo['name'],
      images: photo['images'],
    );
  }
}

class MediaVideo {
  final int id;
  final String title;
  final String link;

  MediaVideo({required this.id, required this.title, required this.link});
  factory MediaVideo.fromJson(Map<String, dynamic> photo) {
    return MediaVideo(
      link: photo['link'],
      id: photo['id'],
      title: photo['title'],
    );
  }
}

class Releases {
  final int id;
  final String image;
  final String title;
  final String? attachment;
  final List? properties;

  Releases(
      {this.properties,
      required this.id,
      required this.image,
      required this.title,
      this.attachment});
  factory Releases.fromJson(Map<String, dynamic> release) {
    return Releases(
      image: release['image'],
      id: release['id'],
      title: release['title'],
      properties: release['properties'] ?? [],
      attachment: release['attachment'] ,
    );
  }
}

class Branches {
  final int id;
  final String address;
  final String title;
  final String phone;
  final String fax;
  final String email;
  final String long;
  final String lat;

  Branches(
      {required this.id,
      required this.address,
      required this.title,
      required this.phone,
      required this.fax,
      required this.email,
      required this.long,
      required this.lat});

  factory Branches.fromJson(Map<String, dynamic> ar) {
    return Branches(
      id: ar['id'],
      address: ar['address'],
      title: ar['title'],
      phone: ar['phone'],
      fax: ar['fax'],
      email: ar['email'],
      long: ar['longitude'],
      lat: ar['latitude'],
    );
  }
}

class Gallery {
  Gallery({
    required this.id,
    required this.name,
    required this.image,
    required this.images,
  });

  int id;
  String name;
  String image;
  List<String> images;

  factory Gallery.fromJson(Map<String, dynamic> json) => Gallery(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    images: List<String>.from(json["images"].map((img)=>img['image'])),
  );
}



