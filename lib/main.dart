import 'package:flutter/material.dart';
import 'package:ujian_si/helper/addNilai.dart';
import 'package:ujian_si/helper/addStudent.dart';
import 'package:ujian_si/pages/login_pages.dart';
import 'package:ujian_si/pages/home_page.dart';
import 'package:ujian_si/pages/register_pages.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: LoginPage(),
    );
  }
}