import 'dart:convert';
import 'package:eradko/provider/app_url.dart';
import 'package:http/http.dart' as http;

class RolesProvider {
  Future<Roles> roles({required String locale}) async {
    Roles roles = Roles(data: []);

    http.Response response = await http.get(Uri.parse(AppUrl.getRoles), headers: {
      'accept': 'application/json',
      'locale': locale,
    });
    if (response.statusCode == 200) {
      roles = roleFromJson(response.body);
    }
    return roles;
  }
}

Roles roleFromJson(String str) => Roles.fromJson(json.decode(str));

class Roles {
  Roles({
    required this.data,
  });

  List<Role> data;

  factory Roles.fromJson(Map<String, dynamic> json) => Roles(
        data: List<Role>.from(json["data"].map((x) => Role.fromJson(x))),
      );
}

class Role {
  Role({required this.id, required this.name});
  int id;
  String name;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        name: json["name"],
      );
}
