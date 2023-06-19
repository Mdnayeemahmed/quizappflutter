import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizappflutter/Screen/login&signup/loginscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quizappflutter/utilities/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          appBarTheme: AppBarTheme(
            color: primaryColor, // Set your desired app bar color here
          )
      ),
      home: loginscreen(),
    );
  }
}
