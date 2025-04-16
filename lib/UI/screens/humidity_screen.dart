import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/UI/widgets/custom_bottom_navbar.dart';
import 'package:myapp/UI/screens/humidity_details_screen.dart';

class HumidityScreen extends StatefulWidget {
  const HumidityScreen({super.key});

  @override
  State<HumidityScreen> createState() => _HumidityScreenState();
}

class _HumidityScreenState extends State<HumidityScreen> {
  List<FlSpot> humiditySpots = [];
  double latestHumidity = 0.0;

  @override
  void initState() {
    super.initState();
    fetchHumidityData();
  }

  Future<void> fetchHumidityData() async {
  try {
    // Lấy giá trị gần nhất
    final recentResponse = await http.get(Uri.parse(
      'https://adapting-doe-precious.ngrok-free.app/ifarm-be/humidity/recent',
    ));

    if (recentResponse.statusCode == 200) {
      final String valueString = recentResponse.body.replaceAll('"', '');
      final double recentValue = double.tryParse(valueString) ?? 0.0;

      setState(() {
        latestHumidity = recentValue;
      });
    }

    // Lấy toàn bộ dữ liệu
    final response = await http.get(Uri.parse(
      'https://adapting-doe-precious.ngrok-free.app/ifarm-be/humidity',
    ));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<FlSpot> spots = [];

      for (int i = 0; i < data.length; i++) {
        final value = double.tryParse(data[i]['value']) ?? 0.0;
        spots.add(FlSpot(i.toDouble(), value));
      }

      setState(() {
        humiditySpots = spots;
      });
    } else {
      print('Failed to load full humidity data: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching humidity data: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCEBD5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCEBD5),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
            child: Image.asset(
              'assets/return.png',
              width: 5,
              height: 5,
              color: Colors.brown,
            ),
          ),
        ),
        title: const Text(
          'Humidity',
          style: TextStyle(
            color: Color(0xFF492402),
            fontFamily: 'Open Sans',
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HumidityDetailsScreen(),
                  ),
                );
              },
              child: Image.asset(
                'assets/details.png',
                width: 28,
                height: 28,
                color: Colors.brown,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Humidity circle
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4)
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/humidity_icon.png',
                        width: 40,
                        height: 40,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Humidity',
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 250,
                    width: 200,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform.scale(
                          scale: 5.0,
                          child: CircularProgressIndicator(
                            value: latestHumidity / 100,
                            strokeWidth: 4,
                            backgroundColor: Colors.grey.shade300,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.lightBlue),
                          ),
                        ),
                        Text(
                          '${latestHumidity.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Statistics chart
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Statistics',
                    style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false, // Ẩn trục hoành
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              interval: 20,
                              getTitlesWidget: (value, meta) {
                                return Text('${value.toInt()}%');
                              },
                            ),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: const Border(
                            left: BorderSide(color: Colors.grey),
                            bottom: BorderSide(color: Colors.grey),
                          ),
                        ),
                        minX: 0,
                        maxX: humiditySpots.length > 1
                            ? humiditySpots.length - 1
                            : 5,
                        minY: 0,
                        maxY: 100,
                        lineBarsData: [
                          LineChartBarData(
                            spots: humiditySpots,
                            isCurved: false,
                            color: Colors.blueAccent,
                            barWidth: 2,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter:
                                  (spot, percent, barData, index) {
                                if (index == barData.spots.length - 1) {
                                  return FlDotCirclePainter(
                                    radius: 5,
                                    color: Colors.deepPurple,
                                    strokeWidth: 0,
                                  );
                                }
                                return FlDotCirclePainter(
                                  radius: 0,
                                  color: Colors.transparent,
                                  strokeWidth: 0,
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
