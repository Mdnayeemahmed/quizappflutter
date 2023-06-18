import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Service/auth_service.dart';
import '../utilities/common_style.dart';
import '../widgets/common_button_style.dart';
import '../widgets/common_password_field.dart';
import '../widgets/common_text_field.dart';
import 'teacher_screen/teacher_dashboard.dart';

class signup extends StatefulWidget {
  const signup({Key? key}) : super(key: key);

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passcontroller1 = TextEditingController();
  final TextEditingController _passcontroller2 = TextEditingController();
  AuthService _authService = AuthService();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool isTeacher = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 80,
                width: 80,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "Create New Account",
                style: titleStyle,
              ),
              SizedBox(
                height: 4,
              ),
              commontextfield(
                controller: _namecontroller,
                validator: (String? value) {
                  if (value?.isEmpty ?? true) {
                    return 'Enter Your Name';
                  }
                  return null;
                },
                hinttext: 'Name',
                textInputType: TextInputType.name,
              ),
              SizedBox(
                height: 16,
              ),
              commontextfield(
                controller: _emailcontroller,
                validator: (String? value) {
                  if (value?.isEmpty ?? true) {
                    return 'Enter A Valid Email';
                  }
                  return null;
                },
                hinttext: 'Email Address',
                textInputType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 16,
              ),
              commonpasstextfield(
                controller: _passcontroller1,
                validator: (String? value) {
                  if (value?.isEmpty ?? true) {
                    return 'Enter Your password';
                  }
                  return null;
                },
                hinttext: 'Password',
                textInputType: TextInputType.visiblePassword,
              ),
              SizedBox(
                height: 16,
              ),
              commonpasstextfield(
                controller: _passcontroller2,
                validator: (String? value) {
                  if (_passcontroller1.text != _passcontroller2.text) {
                    print(_passcontroller1.text.toString());
                    print(_passcontroller2.text.toString());
                    return 'pass not match';
                  }
                  return null;
                },
                hinttext: 'Re Enter Your Password',
                textInputType: TextInputType.visiblePassword,
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Text('Are you a teacher?'),
                  Radio<bool>(
                    value: true,
                    groupValue: isTeacher,
                    onChanged: (value) {
                      setState(() {
                        isTeacher = value!;
                      });
                    },
                  ),
                  Text('Yes'),
                  Radio<bool>(
                    value: false,
                    groupValue: isTeacher,
                    onChanged: (value) {
                      setState(() {
                        isTeacher = value!;
                      });
                    },
                  ),
                  Text('No'),
                ],
              ),
              commonbuttonstyle(
                  tittle: 'Sign up & Login',
                  onTap: () async {
                    if (_formkey.currentState!.validate()) {
                      UserCredential? userCredential =
                          await _authService.signUpWithEmailAndPassword(
                        _emailcontroller.text.toString(),
                        _passcontroller1.text.toString(),
                        _namecontroller.text.toString(),
                        isTeacher,
                      );
                      if (userCredential != null) {
                        // Sign in successful
                        print('sign up');
                        Get.to(teacherDashboard());
                      } else {
                        // Error Msg print
                        Get.to(signup());
                        // Sign in failed
                        // Show an error message or perform other actions
                      }
                    }
                  }),
            ],
          ),
        ),
      ),
    ));
  }
}