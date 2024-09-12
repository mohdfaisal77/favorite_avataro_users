import 'package:avatarro_assignment/ui/home_screen.dart';
import 'package:avatarro_assignment/utils/app_color.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue, // Primary color for the app
        hintColor: AppColor.orangeColor, // Accent color for the app
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColor.taleColor, // AppBar background color
          titleTextStyle: TextStyle(color: AppColor.blackColor, fontSize: 20.0),
        ),
      ),
      home: HomeScreen(),
    );
  }
}
