import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizappflutter/Screen/login&signup/loginscreen.dart';
import 'package:quizappflutter/Screen/student_screen/quizattempt.dart';
import 'package:quizappflutter/utilities/app_colors.dart';
import 'package:quizappflutter/utilities/common_style.dart';
import '../../Service/auth_service.dart';
import 'package:get/get.dart';

import '../../widgets/common_container.dart';
import '../result/view_result.dart';

class studentdashboard extends StatefulWidget {
  const studentdashboard({Key? key}) : super(key: key);

  @override
  State<studentdashboard> createState() => _studentdashboardState();
}

class _studentdashboardState extends State<studentdashboard> {
  AuthService _authService = AuthService();
  User? _user;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    User? user = await _authService.getCurrentUser();
    if (user != null) {
      setState(() {
        _user = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        flexibleSpace: Container(
          margin: EdgeInsets.fromLTRB(10, 40, 10, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello Learner',
                style: titleStyle,
              ),
              Text(
                _user?.email ?? '',
                style: subStyle,
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await _authService.signOut();
              Get.offAll(loginscreen());
            },
            icon: Icon(Icons.output),
          )
        ],
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            common_container(
              title: 'Attempt Quiz',
              onTap: () {
                Get.to(quizpage());
              },
            ),
            SizedBox(
              width: 10,
            ),
            common_container(
              title: 'View Result',
              onTap: () {
                Get.to(viewresult());
              },
            ),
          ],
        ),
      ),
    );
  }
}
