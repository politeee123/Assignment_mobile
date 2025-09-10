// To parse this JSON data, do
//
//     final customerRegisterPostResquest = customerRegisterPostResquestFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CustomerRegisterPostResquest customerRegisterPostResquestFromJson(String str) => CustomerRegisterPostResquest.fromJson(json.decode(str));

String customerRegisterPostResquestToJson(CustomerRegisterPostResquest data) => json.encode(data.toJson());

class CustomerRegisterPostResquest {
    String fullname;
    String phone;
    String email;
    String image;
    String password;

    CustomerRegisterPostResquest({
        required this.fullname,
        required this.phone,
        required this.email,
        required this.image,
        required this.password,
    });

    factory CustomerRegisterPostResquest.fromJson(Map<String, dynamic> json) => CustomerRegisterPostResquest(
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "fullname": fullname,
        "phone": phone,
        "email": email,
        "image": image,
        "password": password,
    };
}
