import 'package:flutter/material.dart';
import 'dart:convert';

Payload payloadFromJson(String str) => Payload.fromJson(json.decode(str));

String payloadToJson(Payload data) => json.encode(data.toJson());

class Payload {
  Payload(
      {required this.profilename,
      required this.name,
      required this.image,
      required this.number,
      required this.email,
      required this.birthday,
      required this.website});

  String name;
  String number;
  String email;
  String birthday;
  String website;
  String image;
  String profilename;

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        profilename: json["profilename"],
        name: json["name"],
        number: json["number"],
        image: json["image"],
        birthday: json["birthday"],
        website: json["website"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "profilename": profilename,
        "name": name,
        "number": number,
        "image": image,
        "birthday": birthday,
        "website": website,
        "email": email,
      };
}
