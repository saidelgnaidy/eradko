import 'dart:convert';

PagesList pagesListFromJson(String str) => PagesList.fromJson(json.decode(str));

class PagesList {
  PagesList({
    required this.data,
  });

  List<PagesModel> data;

  factory PagesList.fromJson(Map<String, dynamic> json) => PagesList(
    data: List<PagesModel>.from(json["data"].map((x) => PagesModel.fromJson(x))),
  );
}


class PagesModel {
  PagesModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.sample,
    required this.content,
  });

  int id;
  String name;
  String slug;
  String sample;
  String content;

  factory PagesModel.fromJson(Map<String, dynamic> json) => PagesModel(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    sample: json["sample"],
    content: json["content"],
  );
}
