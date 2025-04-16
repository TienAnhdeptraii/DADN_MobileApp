import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:myapp/UI/widgets/custom_bottom_navbar.dart';

class HumidityDetailsScreen extends StatefulWidget {
  const HumidityDetailsScreen({super.key});

  @override
  State<HumidityDetailsScreen> createState() => _HumidityDetailsScreenState();
}

class _HumidityDetailsScreenState extends State<HumidityDetailsScreen> {
  DateTime? _startDateTime;
  DateTime? _endDateTime;
  List<Map<String, String>> data = [];

  @override
  void initState() {
    super.initState();
    fetchFilteredData();
  }

  Future<void> _pickDateTime({required bool isStart}) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2026),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;

    final picked = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
      0,
    );

    setState(() {
      if (isStart) {
        _startDateTime = picked;
      } else {
        _endDateTime = picked;
      }
    });
  }

  Future<void> fetchFilteredData() async {
    if (_startDateTime == null || _endDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn cả thời gian bắt đầu và kết thúc'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final start = _startDateTime!.toIso8601String();
    final end = _endDateTime!.toIso8601String();

    final uri = Uri.parse(
        'https://adapting-doe-precious.ngrok-free.app/ifarm-be/humidity/filter?start=$start&end=$end');

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        if (responseData.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Không tìm thấy dữ liệu trong khoảng thời gian này'),
              backgroundColor: Colors.blueGrey,
            ),
          );
        }
        setState(() {
          data = responseData.map<Map<String, String>>((item) {
            return {
              'date': item['date'],
              'time': item['time'],
              'value': '${item['value']}%',
              'note': item['description'],
            };
          }).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không tìm thấy dữ liệu trong khoảng thời gian này'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi kết nối tới máy chủ: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Color getNoteColor(String note) {
    switch (note) {
      case 'Good':
        return Colors.green;
      case 'Normal':
        return Colors.orange;
      case 'Bad':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  Widget buildDateTimeRow(String label, bool isStart) {
    final dateTime = isStart ? _startDateTime : _endDateTime;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _pickDateTime(isStart: isStart),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Text(
              dateTime != null
                  ? '${dateTime.toLocal()}'.split('.')[0]
                  : 'Select date & time',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildFilterButton() {
    return ElevatedButton(
      onPressed: fetchFilteredData,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF655CD0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        minimumSize: const Size.fromHeight(48),
      ),
      child: const Text(
        'Filter',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCEEDB),
      appBar: AppBar(
  backgroundColor: Colors.transparent,
  elevation: 0,
  title: const Text(
    'Details',
    style: TextStyle(
      color: Color(0xFF492402),
      fontFamily: 'Open Sans',
      fontSize: 30,
      fontWeight: FontWeight.w700,
    ),
  ),
  leading: IconButton(
    icon: Image.asset(
      'assets/return.png',
      width: 60,
      height: 60,
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  ),
),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  buildDateTimeRow('From', true),
                  const SizedBox(height: 10),
                  buildDateTimeRow('To', false),
                  const SizedBox(height: 16),
                  buildFilterButton(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      offset: const Offset(0, 4),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(3),
                          1: FlexColumnWidth(2),
                          2: FlexColumnWidth(1.5),
                          3: FlexColumnWidth(2),
                        },
                        border: TableBorder(
                          horizontalInside: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        children: const [
                          TableRow(
                            decoration: BoxDecoration(color: Colors.white),
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Center(
                                  child: Text(
                                    'Date',
                                    style: TextStyle(
                                      color: Color(0xFF5185CA),
                                      fontFamily: 'Open Sans',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Center(
                                  child: Text(
                                    'Time',
                                    style: TextStyle(
                                      color: Color(0xFF5185CA),
                                      fontFamily: 'Open Sans',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Center(
                                  child: Text(
                                    'Value',
                                    style: TextStyle(
                                      color: Color(0xFF5185CA),
                                      fontFamily: 'Open Sans',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Center(
                                  child: Text(
                                    'Note',
                                    style: TextStyle(
                                      color: Color(0xFF5185CA),
                                      fontFamily: 'Open Sans',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Table(
                          columnWidths: const {
                            0: FlexColumnWidth(3),
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(1.5),
                            3: FlexColumnWidth(2),
                          },
                          border: TableBorder(
                            horizontalInside: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          children: data.map((item) {
                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Center(
                                    child: Text(
                                      item['date']!,
                                      style: const TextStyle(
                                        fontFamily: 'Open Sans',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Center(
                                    child: Text(
                                      item['time']!,
                                      style: const TextStyle(
                                        fontFamily: 'Open Sans',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Center(
                                    child: Text(
                                      item['value']!,
                                      style: const TextStyle(
                                        fontFamily: 'Open Sans',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Center(
                                    child: Text(
                                      item['note']!,
                                      style: TextStyle(
                                        color: getNoteColor(item['note']!),
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Open Sans',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
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
        currentIndex: 1,
        onTap: (index) {},
      ),
    );
  }
}
