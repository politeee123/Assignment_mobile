// To parse this JSON data, do
//
//     final customerRegisterPostResponse = customerRegisterPostResponseFromJson(jsonString);

import 'dart:convert';

CustomerRegisterPostResponse customerRegisterPostResponseFromJson(String str) => CustomerRegisterPostResponse.fromJson(json.decode(str));

String customerRegisterPostResponseToJson(CustomerRegisterPostResponse data) => json.encode(data.toJson());

class CustomerRegisterPostResponse {
    String fullname;
    String phone;
    String email;
    String image;
    String password;

    CustomerRegisterPostResponse({
        required this.fullname,
        required this.phone,
        required this.email,
        required this.image,
        required this.password,
    });

    factory CustomerRegisterPostResponse.fromJson(Map<String, dynamic> json) => CustomerRegisterPostResponse(
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