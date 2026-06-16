import 'package:flutter/material.dart';
import 'Screen/TrangChu.dart';
import 'Screen/DangNhap.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DangNhap(),
    );
  }
}