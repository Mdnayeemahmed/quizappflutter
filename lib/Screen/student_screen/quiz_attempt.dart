import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Module'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('quizzes').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final List<QueryDocumentSnapshot> quizzes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: quizzes.length,
            itemBuilder: (context, index) {
              final quiz = quizzes[index];
              return ListTile(
                title: Text(quiz.id),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizPage(quiz: quiz),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  final QueryDocumentSnapshot quiz;

  QuizPage({required this.quiz});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<String> selectedOptions = [];

  void _submitQuiz() {
    // Store the student's answers in Firestore
    FirebaseFirestore.instance.collection('quiz_submissions').add({
      'quizId': widget.quiz.id,
      'answers': selectedOptions,
    });

    // Navigate back to the quiz list
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> options = widget.quiz['options'];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.id),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(widget.quiz['question']),
            SizedBox(height: 16.0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];

                return ListTile(
                  title: Text(option),
                  leading: Radio(
                    value: option,
                    groupValue: selectedOptions.isNotEmpty ? selectedOptions[0] : null,
                    onChanged: (value) {
                      setState(() {
                        selectedOptions = [value.toString()];
                      });
                    },
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: _submitQuiz,
              child: Text('Submit Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
