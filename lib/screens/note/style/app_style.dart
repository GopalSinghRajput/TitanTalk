import 'package:flutter/material.dart';

class AppStyle {
  static Color bgColor = Color(0xFFe2e2ff);
  static Color mainColor = Color.fromARGB(255, 2, 15, 117);
  static Color accentColor = Color(0xFF0065FF);

  static List<Color> cardsColor = [
    Colors.white,
    Colors.red.shade100,
    Colors.pink.shade100,
    Colors.orange.shade100,
    Colors.yellow.shade100,
    Colors.green.shade100,
    Colors.blue.shade100,
    Colors.blueGrey.shade100,
  ];

  /// Setting the text style without Google Fonts
  static TextStyle mainTitle = const TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  static TextStyle mainContent = const TextStyle(
      fontSize: 16.0, fontWeight: FontWeight.normal, color: Colors.black);

  static TextStyle dateTitle = const TextStyle(
      fontSize: 13.0, fontWeight: FontWeight.w500, color: Colors.black);
}
