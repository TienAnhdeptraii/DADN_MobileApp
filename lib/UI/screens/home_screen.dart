import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/UI/widgets/custom_bottom_navbar.dart'; // import đã sửa

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DateTime _now;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String getGreeting(int hour) {
    if (hour >= 5 && hour < 12) {
      return 'Good morning !';
    } else if (hour >= 12 && hour < 18) {
      return 'Good afternoon !';
    } else {
      return 'Good evening !';
    }
  }

  String getBackgroundImage(int hour) {
    if (hour >= 5 && hour < 12) {
      return 'assets/morning.png';
    } else if (hour >= 12 && hour < 18) {
      return 'assets/afternoon.png';
    } else {
      return 'assets/night.png';
    }
  }

  Color getTimeTextColor(int hour) {
    if (hour >= 5 && hour < 12) {
      return const Color(0xFF8E6527);
    } else if (hour >= 12 && hour < 18) {
      return const Color(0xFF4A2914);
    } else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hour = _now.hour;
    final greeting = getGreeting(hour);
    final bgImage = getBackgroundImage(hour);
    final time = DateFormat('HH:mm').format(_now);
    final date = DateFormat('dd-MM-yyyy').format(_now);
    final timeTextColor = getTimeTextColor(hour);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: const Color(0xFFFDF5EE),
            ),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 240,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 240,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(bgImage),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 40,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Text(
                            greeting,
                            style: const TextStyle(
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w700,
                              fontSize: 40,
                              height: 1.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 100,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                time,
                                style: TextStyle(
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 60,
                                  height: 1.0,
                                  color: timeTextColor,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  date,
                                  style: TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 25,
                                    height: 1.0,
                                    color: timeTextColor,
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
                Expanded(
                  child: Transform.translate(
                    offset: const Offset(0, -40),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDF5EE),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x66000000),
                            offset: Offset(0, -4),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 170 / 206,
                        children: [
                          DashboardCard(
                            title: 'Humidity',
                            iconPath: 'assets/menu_humidity.png',
                            onTap: () {
                              Navigator.pushNamed(context, '/humidity');
                            },
                          ),
                          DashboardCard(
                            title: 'Temperature',
                            iconPath: 'assets/menu_temp.png',
                            onTap: () {
                              Navigator.pushNamed(context, '/temperature');
                            },
                          ),
                          DashboardCard(
                            title: 'Watering',
                            iconPath: 'assets/menu_watering.png',
                            onTap: () {
                              Navigator.pushNamed(context, '/watering');
                            },
                          ),
                          DashboardCard(
                            title: 'Prediction',
                            iconPath: 'assets/menu_prediction.png',
                            onTap: () {
                              Navigator.pushNamed(context, '/prediction');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {},
      ),
    );
  }
}

// DashboardCard giữ nguyên như ban đầu
class DashboardCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.iconPath,
    required this.onTap,
  });

  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 170,
        height: 206,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 8),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath, width: 84, height: 84),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Open Sans',
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
