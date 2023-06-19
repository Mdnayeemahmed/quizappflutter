import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherModule extends StatefulWidget {
  @override
  _TeacherModuleState createState() => _TeacherModuleState();
}

class _TeacherModuleState extends State<TeacherModule> {
  final TextEditingController _quizTitleController = TextEditingController();
  List<TextEditingController> _questionControllers = [];
  List<List<TextEditingController>> _optionControllers = [];
  List<TextEditingController> _correctOptionControllers = [];

  @override
  void initState() {
    super.initState();
    // Initialize the question and option controllers
    for (int i = 0; i < 5; i++) {
      _questionControllers.add(TextEditingController());
      List<TextEditingController> options = [];
      for (int j = 0; j < 4; j++) {
        options.add(TextEditingController());
      }
      _optionControllers.add(options);
      _correctOptionControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    // Dispose of the text controllers
    _quizTitleController.dispose();
    _questionControllers.forEach((controller) => controller.dispose());
    _optionControllers.forEach((options) => options.forEach((controller) => controller.dispose()));
    _correctOptionControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _createQuiz() async {
    // Create a new quiz document with the quizName as the document ID
    String quizName = _quizTitleController.text;
    DocumentReference quizRef = FirebaseFirestore.instance
        .collection('examquestion')
        .doc(quizName);

    // Add the questions, options, and correct answers to the quiz document
    List<Map<String, dynamic>> questions = [];

    for (int i = 0; i < 5; i++) {
      Map<String, dynamic> question = {
        'question': _questionControllers[i].text,
        'options': [
          _optionControllers[i][0].text,
          _optionControllers[i][1].text,
          _optionControllers[i][2].text,
          _optionControllers[i][3].text,
        ],
        'correctOption': _correctOptionControllers[i].text,
      };
      questions.add(question);
    }

    await quizRef.set({'questions': questions});

    // Clear the text fields after creating the quiz
    _quizTitleController.clear();
    _questionControllers.forEach((controller) => controller.clear());
    _optionControllers.forEach((options) => options.forEach((controller) => controller.clear()));
    _correctOptionControllers.forEach((controller) => controller.clear());
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
              controller: _quizTitleController,
              decoration: InputDecoration(labelText: 'Quiz Title'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Questions:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question ${index + 1}',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      TextFormField(
                        controller: _questionControllers[index],
                        decoration: InputDecoration(labelText: 'Question'),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Options:',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 4,
                        itemBuilder: (context, optionIndex) {
                          return TextFormField(
                            controller: _optionControllers[index][optionIndex],
                            decoration: InputDecoration(labelText: 'Option ${optionIndex + 1}'),
                          );
                        },
                      ),
                      SizedBox(height: 8.0),
                      TextFormField(
                        controller: _correctOptionControllers[index],
                        decoration: InputDecoration(labelText: 'Correct Option (1-4)'),
                      ),
                      SizedBox(height: 16.0),
                    ],
                  );
                },
              ),
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
