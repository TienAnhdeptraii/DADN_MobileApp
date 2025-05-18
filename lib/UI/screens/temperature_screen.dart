import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:myapp/UI/widgets/custom_bottom_navbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class TemperatureScreen extends StatefulWidget {
  const TemperatureScreen({super.key});

  @override
  State<TemperatureScreen> createState() => _TemperatureScreenState();
}

class _TemperatureScreenState extends State<TemperatureScreen> {
  String currentTemperature = "0";
  List<Map<String, dynamic>> temperatureHistory = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTemperatureData();
  }

  Future<void> fetchTemperatureData() async {
    setState(() {
      isLoading = true;
    });

    http.Client client = http.Client();
    try {
      // Fetch current temperature
      final recentResponse = await client.get(
        Uri.parse('https://adapting-doe-precious.ngrok-free.app/ifarm-be/temperature/recent'),
      );

      if (recentResponse.statusCode == 200 && mounted) {
        setState(() {
          currentTemperature = recentResponse.body.replaceAll('"', '');
        });
      }

      // Fetch temperature history
      final historyResponse = await client.get(
        Uri.parse('https://adapting-doe-precious.ngrok-free.app/ifarm-be/temperature'),
      );

      if (historyResponse.statusCode == 200 && mounted) {
        final List<dynamic> data = json.decode(historyResponse.body);
        setState(() {
          temperatureHistory = List<Map<String, dynamic>>.from(data);
        });
      }
    } catch (e) {
      print('Error fetching temperature data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching data: $e')),
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

  List<FlSpot> _getChartData() {
    // Lọc dữ liệu chỉ lấy ngày hôm nay
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final todayData = temperatureHistory.where((item) {
      final itemDate = item['date'] ?? '';
      return itemDate == today;
    }).toList();
    
    // Nếu không có dữ liệu hôm nay, trả về danh sách trống
    if (todayData.isEmpty) {
      return [const FlSpot(0, 0)];
    }

    // Sắp xếp dữ liệu theo thời gian
    todayData.sort((a, b) {
      final timeA = a['time'] ?? '';
      final timeB = b['time'] ?? '';
      return timeA.compareTo(timeB);
    });

    // Lấy tối đa 7 điểm dữ liệu
    final displayData = todayData.take(7).toList();
    
    // Tạo các điểm dữ liệu cho biểu đồ
    final spots = <FlSpot>[];
    for (int i = 0; i < displayData.length; i++) {
      final value = double.tryParse(displayData[i]['value'] ?? '0') ?? 0;
      spots.add(FlSpot(i.toDouble(), value));
    }
    return spots;
  }

  String _getStatus(double temp) {
    if (temp < 18) return 'Cool';
    if (temp < 25) return 'Normal';
    if (temp < 30) return 'Warm';
    return 'Hot';
  }

  Color _getStatusColor(double temp) {
    if (temp < 18) return Colors.blue;
    if (temp < 25) return Colors.green;
    if (temp < 30) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final temp = double.tryParse(currentTemperature) ?? 0;
    final status = _getStatus(temp);
    final statusColor = _getStatusColor(temp);

    return Scaffold(
      backgroundColor: const Color(0xFFFCEBD5), // Màu nền cream
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCEBD5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.brown),
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
        ),
        title: const Text(
          'Temperature',
          style: TextStyle(
            color: Color(0xFF492402),
            fontFamily: 'Open Sans',
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 16),
            icon: const ImageIcon(AssetImage('assets/details.png'), color: Colors.brown),
            onPressed: () => Navigator.pushNamed(context, '/temperature_details'),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                fetchTemperatureData();
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Temperature Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.thermostat, color: statusColor, size: 35),
                              const SizedBox(width: 8),
                              Text(
                                'Temperature: $status',
                                style: TextStyle(
                                  fontFamily: 'Open Sans',
                                  color: statusColor,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: currentTemperature,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontSize: 64,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '°C',
                                    style: TextStyle(
                                      color: statusColor,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue,   // Cool
                                  Colors.green,  // Normal
                                  Colors.orange, // Warm 
                                  Colors.red,    // Hot
                                ],
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    // Statistics Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Statistics',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.refresh),
                                onPressed: () => fetchTemperatureData(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 250,
                            child: temperatureHistory.isEmpty
                              ? const Center(child: Text('No data available'))
                              : LineChart(
                                LineChartData(  
                                  gridData: FlGridData(show: false),
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        interval: 5,
                                        reservedSize: 40,
                                        getTitlesWidget: (value, meta) {
                                          return Text('${value.toInt()}°C');
                                        },
                                      ),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        interval: 1,
                                        reservedSize: 30,
                                        getTitlesWidget: (value, meta) {
                                          if (value.toInt() >= temperatureHistory.length || value.toInt() < 0) {
                                            return const SizedBox.shrink();
                                          }
                                          final timeStr = temperatureHistory[value.toInt()]['time'] ?? '';
                                          // Hiển thị thời gian theo định dạng ngắn gọn
                                          return Text(timeStr.substring(0, 5)); // Chỉ hiển thị phần HH:MM
                                        },
                                      ),
                                    ),
                                    rightTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    topTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                  ),
                                  borderData: FlBorderData(
                                    show: true,
                                    border: Border(
                                      left: BorderSide(color: Colors.grey.shade300),
                                      bottom: BorderSide(color: Colors.grey.shade300),
                                    ),
                                  ),
                                  minX: 0,
                                  maxX: _getChartData().length - 1.0,
                                  minY: 0,
                                  maxY: 40, // Giảm xuống 40°C thay vì 50°C
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: _getChartData(),
                                      color: statusColor,
                                      barWidth: 3,
                                      isStrokeCapRound: true,
                                      dotData: FlDotData(
                                        show: true,
                                        getDotPainter: (spot, percent, barData, index) {
                                          return FlDotCirclePainter(
                                            radius: 6,
                                            color: statusColor,
                                            strokeWidth: 0,
                                          );
                                        },
                                        checkToShowDot: (spot, barData) {
                                          return true; // Show dots for all points
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
            ),
      bottomNavigationBar: CustomBottomNavBar(  
        currentIndex: 2, // Index cho tab Temperature
        onTap: (index) {}, // Thêm onTap callback
      ),
    );
  }
}
