import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_computing_project/shopping/view_shopping_list.dart';
import 'package:permission_handler/permission_handler.dart';

void main()  {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> requestPermission() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    Permission.camera.request();
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Shopping Companion';

    requestPermission();

    return const MaterialApp(
      title: title,
      home: ViewShoppingList(),
    );
  }
}