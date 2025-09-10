import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/config.dart';
import 'package:flutter_application_1/models/customer_login_post_res.dart';
import 'package:flutter_application_1/models/customers_register_post_req.dart';
import 'package:flutter_application_1/models/customers_register_post_res.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class registers extends StatefulWidget {
  const registers({super.key});

  @override
  State<registers> createState() => _registerState();
}

class _registerState extends State<registers> {
  var name = TextEditingController();
  var phone = TextEditingController();
  var email = TextEditingController();
  var image = TextEditingController();
  var password = TextEditingController();
  var password_con = TextEditingController();

  var data = {
    "fullname": "ผู้ใช้ ทดสอบ 2",
    "phone": "0822222222",
    "email": "user2@gmail.com",
    "image":
        "http://202.28.34.197:8888/contents/4a00cead-afb3-45db-a37a-c8bebe08fe0d.png",
    "password": "22222",
  };
  String url = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          child: Column(
            children: [
              AppBar(title: const Text('สมัครสมาชิก')),
              // const SizedBox(height: 6),
              //       ElevatedButton(
              //         onPressed: BackButton,
              //         child: const Text('ย้อนกลับ'),
              //       ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Text('ชื่อ นามสกุล'),
                    TextField(
                      controller: name,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 24),
                    Text('หมายเลขโทรศัพท์'),
                    TextField(
                      controller: phone,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 24),
                    Text('อีเมล'),
                    TextField(
                      controller: email,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 24),
                    Text('รหัสผ่าน'),
                    TextField(
                      controller: password,
                      obscureText: true, // Hide password text
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 24),
                    Text('ยืนยันรหัสผ่าน'),
                    TextField(
                      controller: password_con,
                      obscureText: true,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: FilledButton(
                        onPressed: Register,
                        child: const Text('สมัครสมาชิก'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('หากมีบัญชีอยู่แล้ว?'),
                        ElevatedButton(
                          onPressed: login,
                          child: const Text('เข้าสู่ระบบ'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void BackButton() {
    Navigator.pop(context);
  }

  void Register() {
    CustomerRegisterPostResquest req = CustomerRegisterPostResquest(
      fullname: name.text,
      phone: phone.text,
      email: email.text,
      image: image.text,
      password: password.text,
    );

    if (name.text == '' ||
        phone.text == '' ||
        email.text == '' ||
        password.text == '' ||
        password_con.text == '') {
      return;
    }
    if (password.text != password_con.text) {
      return;
    }

    http
        .post(
          Uri.parse("$url/customers"),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: jsonEncode(req),
        )
        .then((value) {
          CustomerRegisterPostResponse customerRegisterPostResponse =
              customerRegisterPostResponseFromJson(value.body);
          log(customerRegisterPostResponse.message);
        })
        .catchError((error) {
          log('Error $error');
        });
    login();
  }

  void login() {
    Navigator.pop(context);
  }
}
