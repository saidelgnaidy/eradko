
class MyNotification {
  MyNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.seen,
    required this.time,
    required this.type,
    required this.typeId,
  });

  final int id;
  final String title;
  final String body;
  final int seen;
  final String time;
  final String type;
  final int typeId;

  factory MyNotification.fromJson(Map<String, dynamic> json) => MyNotification(
    id: json["id"],
    title: json["title"],
    body: json["body"],
    seen: json["seen"],
    time: json["time"],
    type: json["type"],
    typeId: json["type_id"],
  );

}
