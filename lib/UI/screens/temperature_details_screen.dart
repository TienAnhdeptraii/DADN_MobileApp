import 'package:flutter/material.dart';
import 'package:myapp/UI/widgets/custom_bottom_navbar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TemperatureDetailsScreen extends StatefulWidget {
  const TemperatureDetailsScreen({super.key});

  @override
  _TemperatureDetailsScreenState createState() => _TemperatureDetailsScreenState();
}

class _TemperatureDetailsScreenState extends State<TemperatureDetailsScreen> {
  DateTime? fromDate;
  DateTime? toDate;
  bool isLoading = false;

  List<Map<String, dynamic>> filteredData = [];
  List<Map<String, dynamic>> allData = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData(); // Luôn lấy dữ liệu thực tế khi vào màn hình
  }

  Future<void> _loadInitialData() async {
    setState(() {
      isLoading = true;
    });

    http.Client client = http.Client();
    try {
      final response = await client.get(
        Uri.parse('https://adapting-doe-precious.ngrok-free.app/ifarm-be/temperature'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (mounted) {
          setState(() {
            allData = List<Map<String, dynamic>>.from(data);
            filteredData = allData;
          });
        }
      }
    } catch (e) {
      print('Error loading initial data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading initial data: $e')),
        );
      }
    } finally {
      client.close();
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
    setState(() {
      isLoading = true;
    });

    // Nếu không chọn ngày nào, luôn gọi API lấy toàn bộ dữ liệu
    if (fromDate == null && toDate == null) {
      await _loadInitialData();
      setState(() { isLoading = false; });
      return;
    }

    // Lọc trên allData thay vì filteredData
    if (fromDate != null || toDate != null) {
      final DateTime startDate = fromDate ?? DateTime(2000);
      final DateTime endDate = toDate ?? DateTime(2101);
      final filteredResults = allData.where((item) {
        try {
          DateTime itemDate = DateFormat('yyyy-MM-dd').parse(item['date'] ?? '');
          return itemDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
                 itemDate.isBefore(endDate.add(const Duration(days: 1)));
        } catch (e) {
          print('Error parsing date: $e');
          return false;
        }
      }).toList();
      setState(() {
        filteredData = filteredResults;
        isLoading = false;
      });
      return;
    }

    // Phần code thật với API call
    http.Client client = http.Client();
    try {
      String url = 'https://adapting-doe-precious.ngrok-free.app/ifarm-be/temperature/filter?';
      
      if (fromDate != null && toDate != null) {
        // Format dates to the required format: yyyy-MM-ddTHH:mm:ss
        final String fromDateFormatted = DateFormat('yyyy-MM-dd').format(fromDate!) + 'T00:00:00';
        final String toDateFormatted = DateFormat('yyyy-MM-dd').format(toDate!) + 'T23:59:59';
        
        url += 'start=$fromDateFormatted&end=$toDateFormatted';
      } else if (fromDate != null) {
        // Only fromDate is set - set end to current time
        final String fromDateFormatted = DateFormat('yyyy-MM-dd').format(fromDate!) + 'T00:00:00';
        final String currentDateFormatted = DateFormat('yyyy-MM-dd').format(DateTime.now()) + 'T23:59:59';
        
        url += 'start=$fromDateFormatted&end=$currentDateFormatted';
      } else if (toDate != null) {
        // Only toDate is set - set start to 30 days before
        final String toDateFormatted = DateFormat('yyyy-MM-dd').format(toDate!) + 'T23:59:59';
        final String thirtyDaysBeforeFormatted = DateFormat('yyyy-MM-dd').format(toDate!.subtract(const Duration(days: 30))) + 'T00:00:00';
        
        url += 'start=$thirtyDaysBeforeFormatted&end=$toDateFormatted';
      } else {
        // No date selected, use default endpoint to get all data
        url = 'https://adapting-doe-precious.ngrok-free.app/ifarm-be/temperature';
      }

      print('Calling API: $url'); // Debug info

      final response = await client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (mounted) {
          setState(() {
            filteredData = List<Map<String, dynamic>>.from(data);
          });
        }
      } else {
        throw Exception('Failed to load data: Status ${response.statusCode}');
      }
    } catch (e) {
      print('Error filtering data: $e');
      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error filtering data: $e')),
        );
      }
      
      // Trở lại dữ liệu mẫu nếu API bị lỗi
    } finally {
      client.close();
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  String _getNote(String value) {
    final temp = double.tryParse(value) ?? 0;
    if (temp < 18) return 'Cool';
    if (temp < 25) return 'Normal';
    if (temp < 30) return 'Warm';
    return 'Hot';
  }
  
  Color _getNoteColor(String value) {
    final temp = double.tryParse(value) ?? 0;
    if (temp < 18) return Colors.blue;
    if (temp < 25) return Colors.green;
    if (temp < 30) return Colors.orange;
    return Colors.red;
  }

  // Thêm nút Clear Filter
  void _clearFilter() async {
    setState(() {
      fromDate = null;
      toDate = null;
    });
    await _loadInitialData();
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
            color: Color(0xFF492402),
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
                      const SizedBox(width: 8),
                      // Nút Clear Filter
                      ElevatedButton(
                        onPressed: _clearFilter,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Clear Filter',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
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
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
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
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                'Value',
                                style: TextStyle(
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                'Note',
                                style: TextStyle(
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Table Content
                    Expanded(
                      child: filteredData.isEmpty
                          ? const Center(child: Text('No data available'))
                          : ListView.builder(
                              itemCount: filteredData.length,
                              itemBuilder: (context, index) {
                                final item = filteredData[index];
                                final note = _getNote(item['value'] ?? '0');
                                return _buildTableRow(
                                  item['date'] ?? '',
                                  item['time'] ?? '',
                                  '${item['value'] ?? '0'}°C',
                                  note,
                                  _getNoteColor(item['value'] ?? '0'),
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
        currentIndex: 2,
        onTap: (index) {},
      ),
    );
  }

  Widget _buildTableRow(String date, String time, String value, String note, Color noteColor) {
    Color bgColor;
    switch (note) {
      case 'Cool':
        bgColor = Colors.blue.withOpacity(0.07);
        break;
      case 'Normal':
        bgColor = Colors.green.withOpacity(0.07);
        break;
      case 'Warm':
        bgColor = Colors.orange.withOpacity(0.07);
        break;
      case 'Hot':
        bgColor = Colors.red.withOpacity(0.07);
        break;
      default:
        bgColor = Colors.white;
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: bgColor,
        border: const Border(
          bottom: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Center(child: Text(date, style: const TextStyle(fontFamily: 'Open Sans', fontWeight: FontWeight.bold))),
          ),
          Expanded(
            flex: 2,
            child: Center(child: Text(time, style: const TextStyle(fontFamily: 'Open Sans', fontWeight: FontWeight.bold))),
          ),
          Expanded(
            flex: 2,
            child: Center(child: Text(value, style: const TextStyle(fontFamily: 'Open Sans', fontWeight: FontWeight.bold))),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                note,
                style: TextStyle(
                  fontFamily: 'Open Sans',
                  color: noteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

