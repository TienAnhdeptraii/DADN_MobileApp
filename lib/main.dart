import 'package:flutter/material.dart';
import 'UI/screens/splash_screen.dart';
import 'UI/screens/home_screen.dart';
import 'package:myapp/UI/screens/humidity_screen.dart';
import 'package:myapp/UI/screens/humidity_details_screen.dart';

//import 'package:myapp/UI/screens/temperature_screen.dart';
//import 'package:myapp/UI/screens/watering_screen.dart';
//import 'package:myapp/UI/screens/prediction_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iFarm App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/humidity': (context) => const HumidityScreen(),
        '/humidity_details': (context) => HumidityDetailsScreen(),
        //'/temperature': (context) => const TemperatureScreen(),
        //'/temperature_details': (context) => const TemperatureDetailsScreen(),
      },
    );
  }
}
