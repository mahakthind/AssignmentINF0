import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiScreen extends StatefulWidget {
  @override
  _ApiScreenState createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> {
  List<dynamic> apiData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('http://api.citybik.es/v2/networks'));
      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        setState(() {
          apiData = decodedData['networks'];
          isLoading = false;
        });
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'City Bike Networks',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        color: Colors.teal[50],
        child: isLoading
            ? const Center(
          child: CircularProgressIndicator(
            color: Colors.teal,
          ),
        )
            : ListView.builder(
          itemCount: apiData.length,
          itemBuilder: (context, index) {
            final item = apiData[index];
            return Card(
              color: Colors.teal[100],
              margin: const EdgeInsets.symmetric(
                  horizontal: 15, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  item['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  item['location']['city'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.teal,
                  ),
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: const Icon(
                    Icons.directions_bike,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
