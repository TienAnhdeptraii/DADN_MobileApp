import 'package:flutter/material.dart';
import 'package:myapp/UI/widgets/custom_bottom_navbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class WateringDetailsScreen extends StatefulWidget {
  const WateringDetailsScreen({super.key});

  @override
  _WateringDetailsScreenState createState() => _WateringDetailsScreenState();
}

class _WateringDetailsScreenState extends State<WateringDetailsScreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> wateringHistory = [];
  DateTime? fromDate;
  DateTime? toDate;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      isLoading = true;
    });

    http.Client client = http.Client();
    try {
      final response = await client.get(
        Uri.parse('https://adapting-doe-precious.ngrok-free.app/ifarm-be/water'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          wateringHistory = List<Map<String, dynamic>>.from(data);
        });
      }
    } catch (e) {
      print('Error loading watering history: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading watering history: $e')),
        );
      }
    } finally {
      client.close(); // Đóng HTTP client
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
    }
  }

  Future<void> _filterData() async {
    // Simple filter by date without API since there's no specific filter endpoint
    // for watering in the API documentation
    setState(() {
      isLoading = true;
    });

    http.Client client = http.Client();
    try {
      // Get all data first
      final response = await client.get(
        Uri.parse('https://adapting-doe-precious.ngrok-free.app/ifarm-be/water'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> allData = json.decode(response.body);
        
        // Filter locally
        if (fromDate != null || toDate != null) {
          final DateTime startDate = fromDate ?? DateTime(2000);
          final DateTime endDate = toDate ?? DateTime(2101);
          
          setState(() {
            wateringHistory = List<Map<String, dynamic>>.from(allData)
                .where((item) {
                  try {
                    // Parse date from API (format: yyyy-MM-dd)
                    DateTime itemDate = DateFormat('yyyy-MM-dd').parse(item['date'] ?? '');
                    return itemDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
                           itemDate.isBefore(endDate.add(const Duration(days: 1)));
                  } catch (e) {
                    print('Error parsing date: $e');
                    return false;
                  }
                })
                .toList();
          });
        } else {
          setState(() {
            wateringHistory = List<Map<String, dynamic>>.from(allData);
          });
        }
      }
    } catch (e) {
      print('Error filtering watering history: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error filtering watering history: $e')),
        );
      }
    } finally {
      client.close(); // Đóng HTTP client
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCEBD5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCEBD5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.brown),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Details',
          style: TextStyle(
            color: Colors.brown,
            fontFamily: 'Open Sans',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Filter Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // From section
                  const Text(
                    'From:',
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectDate(context, true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              fromDate != null ? DateFormat('dd/MM/yyyy').format(fromDate!) : 'dd/MM/yyyy',
                              style: const TextStyle(
                                fontFamily: 'Open Sans',
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // To section
                  const Text(
                    'To:',
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectDate(context, false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              toDate != null ? DateFormat('dd/MM/yyyy').format(toDate!) : 'dd/MM/yyyy',
                              style: const TextStyle(
                                fontFamily: 'Open Sans',
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 19),
                  // Filter button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _filterData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5856D6),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Filter',
                              style: TextStyle(
                                fontFamily: 'Open Sans',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Table
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Table Header
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey),
                        ),
                      ),
                      child: Row(
                        children: const [
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                'Date',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF5185CA),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                'Time',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF5185CA),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                'Duration',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF5185CA),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Table Content
                    Expanded(
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : wateringHistory.isEmpty
                          ? const Center(child: Text('No data available'))
                          : ListView.builder(
                              itemCount: wateringHistory.length,
                              itemBuilder: (context, index) {
                                final item = wateringHistory[index];
                                return Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Colors.grey, width: 0.5),
                                    ),
                                  ),
                                  child: _buildTableRow(
                                    item['date'] ?? '',
                                    item['time'] ?? '',
                                    item['duration'] ?? '',
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(  
        currentIndex: 3, // Index cho tab Watering
        onTap: (index) {}, // Thêm onTap callback
      ),
    );
  }

  Widget _buildTableRow(String date, String time, String duration) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                date,
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                time,
                style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                duration,
                style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 