import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_computing_project/shopping/view_shopping_list.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';

void main()  {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> requestPermission() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    await Permission.camera.request();
    await Permission.microphone.request();
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Shopping Companion';

    requestPermission();

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
        colorSchemeSeed: const Color(0xff6750a4),
        useMaterial3: true,
      ),
      title: title,
      home: AnimatedSplashScreen(
          duration: 3000,
          splash: Lottie.asset('assets/json/shopping_animated.json'),
          nextScreen: ViewShoppingList(),
          splashTransition: SplashTransition.fadeTransition,
          pageTransitionType: PageTransitionType.rightToLeft,
          backgroundColor: Colors.blue)
    );
  }
}