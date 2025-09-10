import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/config.dart';
import 'package:flutter_application_1/models/trip_get_res.dart';
import 'package:flutter_application_1/pages/ProfilePage.dart';
import 'package:flutter_application_1/pages/TripPage.dart';
import 'package:http/http.dart' as http;

class ShowTripPage extends StatefulWidget {
  int cid = 0;
  ShowTripPage({super.key, required this.cid});

  @override
  State<ShowTripPage> createState() => ShowTripPageState();
}

class ShowTripPageState extends State<ShowTripPage> {
  String url = '';
  List<TripGetResponse> _allTrips = [];
  List<TripGetResponse> _displayedTrips = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
      getTrips();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการทริป'),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              log(value);
              if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(idx: widget.cid)),
                );
              } else if (value == 'logout') {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('ข้อมูลส่วนตัว'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('ออกจากระบบ'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('รายละเอียดการเดินทาง'),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilledButton(
                    onPressed: _showAllTrips,
                    child: const Text('ทั้งหมด'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () => filterTripsByZone('เอเชีย'),
                    child: const Text('เอเชีย'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () => filterTripsByZone('ยุโรป'),
                    child: const Text('ยุโรป'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () => filterTripsByZone('เอเชียตะวันออกเฉียงใต้'),
                    child: const Text('เอเชียตะวันออกเฉียงใต้'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _displayedTrips.isEmpty
                      ? const Center(child: Text('ไม่พบรายการทริป'))
                      : ListView.builder(
                          itemCount: _displayedTrips.length,
                          itemBuilder: (context, index) {
                            final trip = _displayedTrips[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  trip.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.only(bottom: 16.0),
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8),
                                        child: Image.network(
                                          trip.coverimage,
                                          width: 200,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 8),
                                            Text("ประเทศ: ${trip.country}"),
                                            Text(
                                                "ระยะเวลา: ${trip.duration} วัน"),
                                            Text("ราคา: ${trip.price} บาท"),
                                            const SizedBox(height: 12),
                                            Align(
                                              alignment:
                                                  Alignment.centerRight,
                                              child: FilledButton(
                                                onPressed: () =>
                                                    gototrip(trip.idx),
                                                child: const Text(
                                                  'รายละเอียดเพิ่มเติม',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getTrips() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var res = await http.get(Uri.parse('$url/trips'));
      if (res.statusCode == 200) {
        final tripGetResponses = tripGetResponseFromJson(res.body);
        setState(() {
          _allTrips = tripGetResponses;
          _displayedTrips = _allTrips;
          _isLoading = false;
        });
      }
    } catch (e) {
      log('Error fetching trips: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void filterTripsByZone(String zone) {
    final filteredList = _allTrips.where((trip) {
      return trip.destinationZone == zone;
    }).toList();

    setState(() {
      _displayedTrips = filteredList;
    });
  }

  void _showAllTrips() {
    setState(() {
      _displayedTrips = _allTrips;
    });
  }

  void gototrip(int idx) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TripPage(idx: idx)),
    );
  }
}