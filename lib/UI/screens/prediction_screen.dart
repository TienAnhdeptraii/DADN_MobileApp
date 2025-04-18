import 'package:flutter/material.dart';
import 'package:myapp/UI/screens/prediction_temperature_screen.dart';
import 'package:myapp/UI/screens/prediction_watering_screen.dart';
//import 'package:intl/intl.dart';
import 'package:myapp/UI/widgets/custom_bottom_navbar.dart';
import 'package:myapp/UI/screens/prediction_humidity_screen.dart';


class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {

  @override
  void initState() {
    super.initState();

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
          'Prediction',
          style: TextStyle(
            color: Color(0xFF492402),
            fontFamily: 'Open Sans',
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Dashboard(
            title: 'Humidity',
            iconPath: 'assets/pre_humidity.png',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PredictionHumidityScreen(),
                ),
              );
            }, // Điều hướng đến HumidityScreen
          ),
          const SizedBox(height: 16),
          Dashboard(
            title: 'Temperature',
            iconPath: 'assets/pre_temp.png',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PredictionTemperatureScreen(),
                ),
              );
            }, // Điều hướng đến HumidityScreen
          ),
          const SizedBox(height: 16),
          Dashboard(
            title: 'Watering',
            iconPath: 'assets/pre_water.png',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PredictionWateringScreen(),
                ),
              );
            }, // Điều hướng đến HumidityScreen
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 4,
        onTap: (index) {},
      ),
    );
  }
}


class Dashboard extends StatelessWidget {

  final String title;
  final String iconPath;
  final VoidCallback onTap;

  const Dashboard({
    super.key,
    required this.title,
    required this.iconPath,
    required this.onTap,});
  Color get themeColor {
    switch (title) {
      case 'Humidity':
        return const Color(0xFF319DFC);
      case 'Temperature':
        return const Color(0xFFF7802F);
      case 'Watering':
        return const Color(0xFF48BB78);
      default:
        return Colors.white; // Mặc định
    }
  }


  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: double.infinity, // Let container take full width
        height: 150, // Fixed height for dashboard card
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            // Left side: Icon Image
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                iconPath,
                width: 119,
                height: 119,
                fit: BoxFit.cover,
              ),
            ),
            // Right side: Title and GestureDetector
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: themeColor,
                        fontFamily: 'Open Sans',
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: onTap,
                      child: Container(
                        width: 180, // Let container take full width
                        height: 47, // Fixed height for dashboard card
                        decoration: BoxDecoration(
                          color: themeColor,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 10),
                            Text(
                              'View Details',
                              style: TextStyle(
                              color: Colors.white, // Adjust color for visibility
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Open Sans',
                              fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 20),
                            Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Image.asset(
                                'assets/view_detail.png',
                                width: 38,
                                height: 37,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
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
    );
  }
}