import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherModule extends StatefulWidget {
  @override
  _TeacherModuleState createState() => _TeacherModuleState();
}

class _TeacherModuleState extends State<TeacherModule> {
  final TextEditingController _quiztittlecontroller = TextEditingController();
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _option1Controller = TextEditingController();
  final TextEditingController _option2Controller = TextEditingController();
  final TextEditingController _option3Controller = TextEditingController();
  final TextEditingController _option4Controller = TextEditingController();

  void _createQuiz() async {
    // Create a new quiz document
    String quizName = _quiztittlecontroller.text;

    DocumentReference quizRef = FirebaseFirestore.instance.collection('quizzes').doc(quizName);

// Add the question and options to the quiz document
    await quizRef.collection('questions').add({
      'question': _questionController.text,
      'options': [
        _option1Controller.text,
        _option2Controller.text,
        _option3Controller.text,
        _option4Controller.text,
      ],
    });

    // Clear the text fields after creating the quiz
    _quiztittlecontroller.clear();
    _questionController.clear();
    _option1Controller.clear();
    _option2Controller.clear();
    _option3Controller.clear();
    _option4Controller.clear();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Module'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _quiztittlecontroller,
              decoration: InputDecoration(labelText: 'Quiz Tittle'),
            ),
            TextFormField(
              controller: _questionController,
              decoration: InputDecoration(labelText: 'Question'),
            ),
            TextFormField(
              controller: _option1Controller,
              decoration: InputDecoration(labelText: 'Option 1'),
            ),
            TextFormField(
              controller: _option2Controller,
              decoration: InputDecoration(labelText: 'Option 2'),
            ),
            TextFormField(
              controller: _option3Controller,
              decoration: InputDecoration(labelText: 'Option 3'),
            ),
            TextFormField(
              controller: _option4Controller,
              decoration: InputDecoration(labelText: 'Option 4'),
            ),
            ElevatedButton(
              onPressed: _createQuiz,
              child: Text('Create Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
