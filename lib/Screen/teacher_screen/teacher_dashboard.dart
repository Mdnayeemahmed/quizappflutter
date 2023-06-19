import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:quizappflutter/Screen/teacher_screen/quiz_create.dart';
import 'package:quizappflutter/Screen/result/view_result.dart';

import '../../Service/auth_service.dart';
import '../../utilities/app_colors.dart';
import '../../utilities/common_style.dart';
import '../../widgets/common_container.dart';
import '../login&signup/loginscreen.dart';

class teacherDashboard extends StatefulWidget {
  const teacherDashboard({Key? key}) : super(key: key);

  @override
  State<teacherDashboard> createState() => _teacherDashboardState();
}

class _teacherDashboardState extends State<teacherDashboard> {
  AuthService _authService = AuthService();
  User? _user;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    User? user = _authService.getCurrentUser();
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
                  'Hello Teacher',
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
                icon: Icon(Icons.output))
          ],
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              common_container(
                title: 'Create Quiz',
                onTap: () {
                  Get.to(TeacherModule());
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
              )
            ],
          ),
        ));
  }
}
