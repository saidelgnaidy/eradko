import 'dart:convert';

SearchResult searchResultFromJson(String str) => SearchResult.fromJson(json.decode(str));

class SearchResult {
  SearchResult({
    required this.searchItem,
    required this.meta,
  });

  List<SearchItem> searchItem;
  Meta meta;

  factory SearchResult.fromJson(Map<String, dynamic> json) => SearchResult(
    searchItem: List<SearchItem>.from(json["data"].map((x) => SearchItem.fromJson(x))),
    meta: Meta.fromJson(json["meta"]),
  );

}

class SearchItem {
  SearchItem({
    required this.id,
    required this.name,
    required this.image,
    required this.type,
  });

  int id;
  String name;
  String image;
  String type;

  factory SearchItem.fromJson(Map<String, dynamic> json) => SearchItem(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    type: json["type"],
  );
}

class Meta {
  Meta({
    required this.from,
    required this.perPage,
    required this.to,
    required this.total,
  });

  int from;
  int perPage;
  int to;
  int total;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    from: json["from"],
    perPage: json["per_page"],
    to: json["to"],
    total: json["total"],
  );
}

class SearchTypes{
  static String product = 'Product' ;
  static String release = 'Release' ;
  static String post = 'Post' ;
}

class SearchResultMap {
  final bool state ;
  final SearchResult? searchResult ;
  final String error ;
  SearchResultMap({required this.error, required this.state, required this.searchResult});
}
