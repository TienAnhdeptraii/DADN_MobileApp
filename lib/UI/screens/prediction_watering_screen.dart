import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import 'package:myapp/UI/widgets/custom_bottom_navbar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:invert_colors/invert_colors.dart';
import 'package:myapp/UI/screens/prediction_humidity_details_screen.dart';


enum TimeRange { threeHours, sixHours, twelveHours, twentyFourHours }

class PredictionWateringScreen extends StatefulWidget {
  const PredictionWateringScreen({super.key});

  @override
  State<PredictionWateringScreen> createState() => _PredictionWateringScreenState();
}

class _PredictionWateringScreenState extends State<PredictionWateringScreen> {

  List<FlSpot> wateringSpots = List.generate(10, (index) {

    double x = index.toDouble();
    double y = Random().nextInt(61) + 30;
    return FlSpot(x, y);
  });


  final duration = Duration(
    hours: 1,
    minutes: 20,
    seconds: 55,
  );

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
  }

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
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
            // TODO: Implement fetchPredictionData for watering
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
            'Watering',
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
                height: 45,
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
                    _buildTimeOption(TimeRange.threeHours, '3 hrs'),
                    _buildTimeOption(TimeRange.sixHours, '6 hrs'),
                    _buildTimeOption(TimeRange.twelveHours, '12 hrs'),
                    _buildTimeOption(TimeRange.twentyFourHours, '24 hrs'),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(right: 15),
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
          ]
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            children: [GridView.count(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 181 / 181,
              children: [
                DashboardCard(
                    title: 'Times',
                    iconPath: 'assets/Garden_Sprinkler.png',
                    value: '20'
                ),
                DashboardCard(
                    title: 'Usage',
                    iconPath: 'assets/Blur.png',
                    value: '10'
                ),
              ],
            ),
              const SizedBox(height: 12),
              Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8.0,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/Sport_Stopwatch.png',
                    width: 30,
                    height: 30,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Duration",
                    style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.pink),
                  ),
                ],
              ),
              SizedBox(height: 0),
              Text(
                formatDuration(duration),
                style: TextStyle(
                    fontSize: 70,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.bold,
                    color: Colors.pink),
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
                                builder: (context) => PredictionHumidityDetailsScreen(data: []),
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
                          maxX: wateringSpots.length > 1
                              ? wateringSpots.length - 1
                              : 5,
                          minY: 0,
                          maxY: 100,
                          lineBarsData: [
                            LineChartBarData(
                              spots: wateringSpots,
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

class DashboardCard extends StatelessWidget {

  final String title;
  final String iconPath;
  final String value;

  const DashboardCard({
    super.key,
    required this.title,
    required this.iconPath,
    required this.value,});

  Color get themeColor {
    switch (title) {
      case 'Times':
        return const Color(0xFF1D8E6D);
      case 'Usage':
        return const Color(0xFF3E80E5);
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
            // Số + dấu %
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
                  right: title == 'Times' ? -10 : -25,
                  top: -1,
                  child: Text(
                    title == 'Times' ? 'X' : 'm³',
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