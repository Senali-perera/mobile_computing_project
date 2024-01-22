import 'package:flutter/material.dart';
import 'package:mobile_computing_project/shopping/view_shopping_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Shopping Companion';

    return const MaterialApp(
      title: title,
      home: ViewShoppingList(),
    );
  }
}