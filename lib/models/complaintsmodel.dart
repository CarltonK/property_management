import 'dart:convert';

Complaints complaintsFromJson(String str) =>
    Complaints.fromJson(json.decode(str));

String complaintsToJson(Complaints data) => json.encode(data.toJson());

class Complaints {
  DateTime postingDate;
  String title;
  String description;
  bool fixed = false;
  //The landlord to which the complaint is made
  String to;

  Complaints(
      {this.postingDate, this.title, this.description, this.fixed, this.to});

  factory Complaints.fromJson(Map<String, dynamic> json) => Complaints(
      postingDate: json["postingDate"],
      title: json["title"],
      description: json["description"],
      fixed: json["fixed"],
      to: json["to"]);

  Map<String, dynamic> toJson() => {
        "postingDate": postingDate,
        "title": title,
        "description": description,
        "fixed": fixed,
        "to": to
      };
}
