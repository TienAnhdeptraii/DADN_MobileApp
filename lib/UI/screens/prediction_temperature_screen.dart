import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import 'package:myapp/UI/widgets/custom_bottom_navbar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:invert_colors/invert_colors.dart';
import 'package:myapp/UI/screens/prediction_temperature_details_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Defines the time range options for temperature predictions
enum TimeRange { threeHours, sixHours, twelveHours, twentyFourHours }

/// Model class for temperature data entries
class TemperatureEntry {
  final DateTime dateTime;
  final double value;
  final String description;

  TemperatureEntry({
    required this.dateTime,
    required this.value,
    required this.description,
  });

  /// Factory constructor to create a TemperatureEntry from JSON
  factory TemperatureEntry.fromJson(Map<String, dynamic> json) {
    return TemperatureEntry(
      dateTime: DateTime.parse(json['dateTime']),
      value: (json['data'] as num).toDouble(),
      description: json['description'],
    );
  }
}

/// Screen that displays temperature prediction data with statistics and trend visualization
class PredictionTemperatureScreen extends StatefulWidget {
  const PredictionTemperatureScreen({super.key});

  @override
  State<PredictionTemperatureScreen> createState() => _PredictionTemperatureScreenState();
}

class _PredictionTemperatureScreenState extends State<PredictionTemperatureScreen> {
  /// List to store temperature data entries
  List<TemperatureEntry> temperatureData = [];
  
  /// Statistical values calculated from temperature data
  double? maxValue;
  double? minValue;
  double? avgValue;
  double? medianValue;
  
  /// Data points for the temperature chart
  List<FlSpot> temperatureSpots = [];
  
  /// Selected time range for prediction
  TimeRange _selectedRange = TimeRange.threeHours;
  
  /// Flag to show/hide the time selector
  bool _showTimeSelector = false;
  
  /// Maps for tracking hover states of each time range option
  Map<TimeRange, bool> _hoverStates = {
    TimeRange.threeHours: false,
    TimeRange.sixHours: false,
    TimeRange.twelveHours: false,
    TimeRange.twentyFourHours: false,
  };
  
  @override
  void initState() {
    super.initState();
    fetchPredictionData();
  }
  
  /// Fetches temperature prediction data from the API
  Future<void> fetchPredictionData() async {
    // Convert the selected time range to the appropriate step value
    final int step;
    switch (_selectedRange) {
      case TimeRange.threeHours:
        step = 12;
        break;
      case TimeRange.sixHours:
        step = 24;
        break;
      case TimeRange.twelveHours:
        step = 48;
        break;
      case TimeRange.twentyFourHours:
        step = 72;
        break;
    }
    
    final uri = Uri.parse(
      'https://adapting-doe-precious.ngrok-free.app/ifarm-be/predictions/temperature/$step',
    );
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
          return;
        }

        final entries = responseData.map((e) => TemperatureEntry.fromJson(e)).toList();

        setState(() {
          temperatureData = entries;
          updateStats(entries);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
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
  
  /// Calculates statistical values from temperature data and updates the chart
  void updateStats(List<TemperatureEntry> entries) {
    if (entries.isEmpty) return;

    final values = entries.map((e) => e.value).toList()..sort();

    double min = values.first;
    double max = values.last;
    double avg = values.reduce((a, b) => a + b) / values.length;
    double median = values.length % 2 == 1
        ? values[values.length ~/ 2]
        : (values[values.length ~/ 2 - 1] + values[values.length ~/ 2]) / 2;
    final List<FlSpot> spots = List.generate(
      entries.length,
          (index) => FlSpot(index.toDouble(), entries[index].value),
    );

    setState(() {
      minValue = min;
      maxValue = max;
      avgValue = avg;
      medianValue = median;
      temperatureSpots = spots;
    });
  }

  /// Returns the color for a specific time range option
  Color _getTimeRangeColor(TimeRange range) {
    switch (range) {
      case TimeRange.threeHours:
        return Colors.blue;
      case TimeRange.sixHours:
        return Colors.purple;
      case TimeRange.twelveHours:
        return Colors.orange;
      case TimeRange.twentyFourHours:
        return Colors.red;
    }
  }

  /// Builds a time option with hover and selection effects
  Widget _buildTimeOption(TimeRange range, String text) {
    final bool isSelected = _selectedRange == range;
    final bool isHovered = _hoverStates[range] ?? false;
    final Color color = _getTimeRangeColor(range);
    
    return MouseRegion(
      onEnter: (_) => setState(() => _hoverStates[range] = true),
      onExit: (_) => setState(() => _hoverStates[range] = false),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedRange = range;
            fetchPredictionData();
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.2) : (isHovered ? color.withOpacity(0.1) : Colors.transparent),
            borderRadius: BorderRadius.circular(22.5),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: isSelected || isHovered ? FontWeight.w800 : FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
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
                Navigator.pushReplacementNamed(context, '/prediction');
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
            'Temperature',
            style: TextStyle(
              color: Color(0xFF492402),
              fontFamily: 'Open Sans',
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            if (_showTimeSelector)
              Container(
                margin: const EdgeInsets.only(right: 5),
                height: 40,
                width: 330,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTimeOption(TimeRange.threeHours, '12 hrs'),
                    _buildTimeOption(TimeRange.sixHours, '24 hrs'),
                    _buildTimeOption(TimeRange.twelveHours, '48 hrs'),
                    _buildTimeOption(TimeRange.twentyFourHours, '72 hrs'),

                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showTimeSelector = !_showTimeSelector;
                  });
                },
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/hour_glass.png',
                      width: 24,
                      height: 24,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            children: [
              /// Grid of dashboard cards displaying statistics
              GridView.count(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 181 / 181,
              children: [
                DashboardCard(
                    title: 'Maximum',
                    iconPath: 'assets/External.png',
                    value: maxValue?.toStringAsFixed(0) ?? '--',
                ),
                DashboardCard(
                    title: 'Minimum',
                    iconPath: 'assets/Internal.png',
                    value: minValue?.toStringAsFixed(0) ?? '--',
                ),
                DashboardCard(
                    title: 'Average',
                    iconPath: 'assets/Average_Math.png',
                    value: avgValue?.toStringAsFixed(0) ?? '--',
                ),
                DashboardCard(
                    title: 'Median',
                    iconPath: 'assets/Chain_Intermediate.png',
                    value: medianValue?.toStringAsFixed(0) ?? '--',
                ),
              ],
            ),
              const SizedBox(height: 20),
              /// Temperature trend chart
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Trend Over Time',
                          style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PredictionTemperatureDetailsScreen(data: temperatureData),
                              ),
                            );

                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: Stack(
                                alignment: Alignment.center,
                                children: [InvertColors(

                                    child: Image.asset(
                                      'assets/details.png',
                                      width: 23,
                                      height: 23,

                                    )
                                )
                                ]
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 160,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false, // Hiding the x-axis labels
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                interval: 10,
                                getTitlesWidget: (value, meta) {
                                  return Text('${value.toInt()}°C');
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
                          maxX: temperatureSpots.length > 1
                              ? temperatureSpots.length - 1
                              : 5,
                          minY: 0,
                          maxY: 50,
                          lineBarsData: [
                            LineChartBarData(
                              spots: temperatureSpots,
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
            ]
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 4,
        onTap: (index) {},
      ),
    );
  }
}

/// Widget for displaying key temperature statistics in a card format
class DashboardCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final String value;

  const DashboardCard({
    super.key,
    required this.title,
    required this.iconPath,
    required this.value,});

  /// Returns a color based on the card's title
  Color get themeColor {
    switch (title) {
      case 'Maximum':
        return const Color(0xFF1D8E6D);
      case 'Minimum':
        return const Color(0xFFFD4A85);
      case 'Average':
        return const Color(0xFF3E80E5);
      case 'Median':
        return const Color(0xFFF29D38);
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 181,
        height: 181,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8.0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon(Icons.pie_chart, color: Colors.orange, size: 20),
                Image.asset(
                  iconPath,
                  width: 30,
                  height: 30,
                  color: themeColor,
                ),
                SizedBox(width: 4),
                Text(
                  title,
                  style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: themeColor
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Value display with degree celsius symbol
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 70,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.bold,
                    color: themeColor,
                  ),
                ),
                Positioned(
                  right: -15,
                  top: -1,
                  child: Text(
                    '°C',
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.bold,
                      color: themeColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }
}