import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/config.dart';
import 'package:flutter_application_1/models/customerIdx_get_res.dart';
import 'package:http/http.dart' as http;
import '';

class ProfilePage extends StatefulWidget {
  int idx = 0;
  ProfilePage({super.key, required this.idx});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<void> loadData;
  late CustomerIdxGetResponse customerIdxGetResponse;
  TextEditingController nameCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();
  TextEditingController imageCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: const Text('ข้อมูลส่วนตัว'),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                  title: Text(
                    'ยืนยันการลบข้อมูลหรือไม่',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  children: [
                    Text('จะลบแล้วนะไม่ได้กดผิดใช่ไหม'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('ไม่'),
                        ),
                        FilledButton(
                          onPressed: delete,
                          child: Text('ถูกต้องนะ'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            itemBuilder: (context) => [
              PopupMenuItem(child: Text('ยกเลิกสมาชิก'), value: 'Delete'),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 8),
                    child: Image.network(
                      customerIdxGetResponse.image,
                      width: 150,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('ชื่อ-นามสกุล'),
                        TextField(controller: nameCtl),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('หมายเลขโทรศัพท์'),
                        TextField(controller: phoneCtl),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('email'),
                        TextField(controller: emailCtl),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('รูปภาพ'),
                        TextField(controller: imageCtl),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FilledButton(
                          onPressed: update,
                          child: Text('บันทึกข้อมูล'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void delete() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];
    var res = await http.delete(Uri.parse('$url/customers/${widget.idx}'));
    log(res.statusCode.toString());
    if (res.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('สำเร็จ'),
          content: Text('ลบข้อมูลสำเร็จ'),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('ปิด'),
            ),
          ],
        ),
      ).then((s) {
        Navigator.popUntil(context, (route) => route.isFirst);
      });
    } else {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('ผิดพลาด'),
          content: Text('ลบข้อมูลไม่สำเร็จ'),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('ปิด'),
            ),
          ],
        ),
      );
    }
  }

  void update() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];

    var json = {
      "fullname": nameCtl.text,
      "phone": phoneCtl.text,
      "email": emailCtl.text,
      "image": imageCtl.text,
    };
    try {
      var res = await http.put(
        Uri.parse('$url/customers/${widget.idx}'),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: jsonEncode(json),
      );
      log(res.body);
      var result = jsonDecode(res.body);
      log(result['message']);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('สำเร็จ'),
          content: Text('บันทึกข้อความสำเร็จ'),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('ปิด'),
            ),
          ],
        ),
      );
    } catch (err) {}
  }

  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];

    var res = await http.get(Uri.parse('$url/customers/${widget.idx}'));
    log(res.body);
    customerIdxGetResponse = customerIdxGetResponseFromJson(res.body);
    log(jsonEncode(customerIdxGetResponse));
    nameCtl.text = customerIdxGetResponse.fullname;
    phoneCtl.text = customerIdxGetResponse.phone;
    emailCtl.text = customerIdxGetResponse.email;
    imageCtl.text = customerIdxGetResponse.image;
  }
}