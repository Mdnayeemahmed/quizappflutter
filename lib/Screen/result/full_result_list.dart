import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizappflutter/Service/auth_service.dart';

class FullResultOption extends StatefulWidget {
  final String quizId;

  const FullResultOption({Key? key, required this.quizId}) : super(key: key);

  @override
  _FullResultOptionState createState() => _FullResultOptionState();
}

class _FullResultOptionState extends State<FullResultOption> {
  List<dynamic> result = [];
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.fetchQuizResults(widget.quizId).then((data) {
      setState(() {
        result = List<dynamic>.from(data['result']);
      });
    }).catchError((error) {
      print('Error fetching quiz results: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Results Of '+widget.quizId),
      ),
      body: result.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: result.length,
              itemBuilder: (context, index) {
                final fullName = result[index]['fullName'];
                final score = result[index]['score'];
                return ListTile(
                  title: Text('Name: $fullName'),
                  subtitle: Text('Score: $score'),
                );
              },
            ),
    );
  }
}
