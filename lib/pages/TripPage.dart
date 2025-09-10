import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/trippage_get_res.dart';

class TripPage extends StatefulWidget {
  int idx = 0;
  TripPage({super.key, required this.idx});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  String url = '';
  // Create late variables
  late TripIdxGetResponse tripIdxGetResponse;
  late Future<void> loadData;

  @override
  void initState() {
    super.initState();
    // Call async function
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      // Loding data with FutureBuilder
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          // Loading...
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          // Load Done
          //return Text(tripIdxGetResponse.name);
          return SingleChildScrollView(
            child: Column(
              // The padding is usually best applied to the parent ScrollView.
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display Trip Name
                Text(
                  tripIdxGetResponse.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                // Display Country
                Text(
                  tripIdxGetResponse.country,
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                // Display Cover Image with rounded corners
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    tripIdxGetResponse.coverimage,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 250,
                    // Show a loading indicator while the image loads
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    // Show an error icon if the image fails to load
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.broken_image,
                        size: 100,
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Display Price and Destination Zone in a row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ราคา ${tripIdxGetResponse.price} บาท', // "Price ... Baht"
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'โซน${tripIdxGetResponse.destinationZone}', // "Zone..."
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Display Trip Details
                Text(
                  tripIdxGetResponse.detail,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5, // Adjust line spacing for readability
                  ),
                ),
                const SizedBox(height: 24),
                // "Book Now" Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your booking logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('จองเลย!!'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Async function for api call
  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];
    var res = await http.get(Uri.parse('$url/trips/${widget.idx}'));
    log(res.body);
    tripIdxGetResponse = tripIdxGetResponseFromJson(res.body);
  }
}
