// ไฟล์ models/trip_get_res.dart

import 'dart:convert';

// แก้ไขฟังก์ชันนี้ ให้สามารถรับ JSON Array (List) ได้
List<TripGetResponse> tripGetResponseFromJson(String str) => List<TripGetResponse>.from(json.decode(str).map((x) => TripGetResponse.fromJson(x)));

// ฟังก์ชันนี้ไม่ค่อยได้ใช้ แต่แก้เผื่อไว้
String tripGetResponseToJson(List<TripGetResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class TripGetResponse {
  // ... โค้ดที่เหลือในคลาสนี้ไม่ต้องแก้ไขอะไรเลย ...
  // factory TripGetResponse.fromJson(...) ก็ใช้ของเดิมได้เลย
    int idx;
    String name;
    String country;
    String coverimage;
    String detail;
    int price;
    int duration;
    String destinationZone;

    TripGetResponse({
        required this.idx,
        required this.name,
        required this.country,
        required this.coverimage,
        required this.detail,
        required this.price,
        required this.duration,
        required this.destinationZone,
    });

    factory TripGetResponse.fromJson(Map<String, dynamic> json) => TripGetResponse(
        idx: json["idx"],
        name: json["name"],
        country: json["country"],
        coverimage: json["coverimage"],
        detail: json["detail"],
        price: json["price"],
        duration: json["duration"],
        destinationZone: json["destination_zone"],
    );

    Map<String, dynamic> toJson() => {
        "idx": idx,
        "name": name,
        "country": country,
        "coverimage": coverimage,
        "detail": detail,
        "price": price,
        "duration": duration,
        "destination_zone": destinationZone,
    };
}