import 'dart:convert';

PaymentMethodsList paymentMethodsFromJson(String str) => PaymentMethodsList.fromJson(json.decode(str));


class PaymentMethodsList {
  PaymentMethodsList({
    required this.data,
  });

  final List<PaymentMethod> data;

  factory PaymentMethodsList.fromJson(Map<String, dynamic> json) => PaymentMethodsList(
    data: List<PaymentMethod>.from(json["data"].map((x) => PaymentMethod.fromJson(x))),
  );
}

class PaymentMethod {
  PaymentMethod({
    required this.name,
    required this.image,
    required this.isDirectPayment,
    required this.paymentMethodId,
  });

  final String name;
  final String image;
  final int isDirectPayment;
  final int paymentMethodId;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
    name: json["name"],
    image: json["image"],
    isDirectPayment: json["IsDirectPayment"],
    paymentMethodId: json["PaymentMethodId"],
  );

}
