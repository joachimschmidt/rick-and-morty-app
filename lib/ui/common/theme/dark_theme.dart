import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Colors.tealAccent,
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.grey),
    cardColor: Colors.grey.shade800);
