import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/UI/widgets/custom_bottom_navbar.dart';
import 'package:myapp/UI/screens/prediction_humidity_screen.dart';

class PredictionHumidityDetailsScreen extends StatefulWidget {
  final List<HumidityEntry> data;
  const PredictionHumidityDetailsScreen({super.key, required this.data});


  @override
  State<PredictionHumidityDetailsScreen> createState() => _PredictionHumidityDetailsScreenState();
}

class _PredictionHumidityDetailsScreenState extends State<PredictionHumidityDetailsScreen> {
  late List<HumidityEntry> data;
  @override
  void initState() {
    super.initState();
    data = widget.data;
    //fetchPredictionData();
  }

  Color getNoteColor(String note) {
    switch (note) {
      case 'Too dry':
        return const Color(0xFFEF6C00); // Deep orange
      case 'Medium':
        return const Color(0xFFFFA000); // Amber
      case 'Good':
        return const Color(0xFF43A047); // Green
      case 'Too wet':
        return const Color(0xFF1E88E5); // Blue
      default:
        return Colors.grey; // fallback
    }
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
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.25 * 255).toInt()),
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
                                      item.dateTime.toLocal().toIso8601String().split('T')[0],
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
                                      '${item.dateTime.toLocal().hour.toString().padLeft(2, '0')}:${item.dateTime.toLocal().minute.toString().padLeft(2, '0')}:${item.dateTime.toLocal().second.toString().padLeft(2, '0')}',
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
                                      item.value.toStringAsFixed(3),
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
                                      item.description,
                                      style: TextStyle(
                                        color: getNoteColor(item.description),
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
        currentIndex: 4,
        onTap: (index) {},
      ),
    );
  }
}
