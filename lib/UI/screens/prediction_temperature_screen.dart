import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import 'package:myapp/UI/widgets/custom_bottom_navbar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:invert_colors/invert_colors.dart';
import 'package:myapp/UI/screens/prediction_humidity_details_screen.dart';


enum TimeRange { threeHours, sixHours, twelveHours, twentyFourHours }

class PredictionTemperatureScreen extends StatefulWidget {
  const PredictionTemperatureScreen({super.key});

  @override
  State<PredictionTemperatureScreen> createState() => _PredictionTemperatureScreenState();
}

class _PredictionTemperatureScreenState extends State<PredictionTemperatureScreen> {

  List<FlSpot> temperatureSpots = List.generate(10, (index) {

    double x = index.toDouble();
    double y = Random().nextInt(61) + 30;
    return FlSpot(x, y);
  });
  @override
  void initState() {
    super.initState();
  }
  // TimeRange _selectedRange = TimeRange.threeHours;
  //
  // final Map<TimeRange, String> rangeLabels = {
  //   TimeRange.threeHours: '3 hrs',
  //   TimeRange.sixHours: '6 hrs',
  //   TimeRange.twelveHours: '12 hrs',
  //   TimeRange.twentyFourHours: '24 hrs',
  // };
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
            //buildTimeSelector(),
            Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8.0,
                        offset: Offset(0, 4),
                      ),
                    ]
                ),
                child: Stack(
                    alignment: Alignment.center,
                    children: [Image.asset('assets/hour_glass.png',
                      height: 30,
                      width: 30,),
                    ]
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
                    title: 'Maximum',
                    iconPath: 'assets/Internal.png',
                    value: '80'
                ),
                DashboardCard(
                    title: 'Minimum',
                    iconPath: 'assets/External.png',
                    value: '50'
                ),
                DashboardCard(
                    title: 'Average',
                    iconPath: 'assets/Average_Math.png',
                    value: '60'
                ),
                DashboardCard(
                    title: 'Median',
                    iconPath: 'assets/Chain_Intermediate.png',
                    value: '70'
                ),
              ],
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
                                builder: (context) => PredictionHumidityDetailsScreen(),
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
                          maxX: temperatureSpots.length > 1
                              ? temperatureSpots.length - 1
                              : 5,
                          minY: 0,
                          maxY: 100,
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
                  right: -10,
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