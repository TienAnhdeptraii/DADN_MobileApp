import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:myapp/UI/widgets/custom_bottom_navbar.dart';

class TemperatureScreen extends StatelessWidget {
  const TemperatureScreen({super.key});
  @override
  Widget build(BuildContext context) {
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
            icon: ImageIcon(AssetImage('assets/details.png'), color: Colors.brown),
            onPressed: () => Navigator.pushNamed(context, '/temperature_details'),
          ),
        ],
      ),
      body: Padding(
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
                      Icon(Icons.thermostat, color: Colors.red, size: 35),
                      const SizedBox(width: 8),
                      Text(
                        'Temperature',
                        style: TextStyle(
                        fontFamily: 'Open Sans',
                          color: Colors.red,
                          fontSize: 30,
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
                            text: '20',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 64,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: '°C',
                            style: TextStyle(
                              color: Colors.red,
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
                          Colors.orange,
                          Colors.red.shade100,
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
                  Text(
                    'Statistics',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 300,
                    child: LineChart(
                      LineChartData(  
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 25,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text('${value.toInt()}°C');
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                              reservedSize: 0,
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
                        maxX: 6,
                        minY: 0,
                        maxY: 100,
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              FlSpot(0, 45),
                              FlSpot(1, 45),
                              FlSpot(2, 30),
                              FlSpot(3, 50),
                              FlSpot(4, 65),
                              FlSpot(5, 50),
                              FlSpot(6, 75),
                            ],
                            color: Colors.orange,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 6,
                                  color: Colors.orange,
                                  strokeWidth: 0,
                                );
                              },
                              checkToShowDot: (spot, barData) {
                                return spot.x == 6; // Chỉ hiện dot ở điểm cuối
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
        currentIndex: 2, // Index cho tab Temperature
        onTap: (index) {}, // Thêm onTap callback
      ),
    );
  }
}
