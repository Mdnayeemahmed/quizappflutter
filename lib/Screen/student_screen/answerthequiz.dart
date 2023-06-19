import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnswerTheQuiz extends StatefulWidget {
  final String quizId;

  const AnswerTheQuiz({Key? key, required this.quizId}) : super(key: key);

  @override
  _AnswerTheQuizState createState() => _AnswerTheQuizState();
}

class _AnswerTheQuizState extends State<AnswerTheQuiz> {
  List<Map<String, dynamic>> quizData = [];
  List<String> selectedOptions = [];
  int score = 0;
  List<Map<String, dynamic>> result = [];

  void _selectOption(int questionIndex, int optionIndex) {
    setState(() {
      selectedOptions[questionIndex] = (optionIndex + 1).toString();
    });
  }

  Future<void> _submitQuiz(String userId) async {
    int tempScore = 0;

    for (int i = 0; i < quizData.length; i++) {
      final correctOption = quizData[i]['correctOption'];
      final selectedOption = selectedOptions[i];

      if (selectedOption == correctOption) {
        tempScore++;
      }
    }

    final userSnapshot =
        await FirebaseFirestore.instance.collection('Users').doc(userId).get();
    if (userSnapshot.exists) {
      final fullName = userSnapshot.get('FullName');
      print(fullName.toString());

      final Map<String, dynamic> quizSubmission = {
        'fullName': fullName,
        'score': tempScore,
      };
      result.add(quizSubmission);

      try {
        final resultsCollection =
            FirebaseFirestore.instance.collection('results');
        final docSnapshot = await resultsCollection.doc(widget.quizId).get();

        List<dynamic> result = [];
        if (docSnapshot.exists) {
          // If the document already exists, retrieve the existing result list
          result = List<dynamic>.from(docSnapshot.get('result'));
        }

        result.add(quizSubmission);

        await resultsCollection.doc(widget.quizId).set({'result': result});

        print('Quiz submission saved successfully!');
        _showScoreResult(tempScore);
      } catch (error) {
        print('Failed to save quiz submission: $error');
      }
    } else {
      print('User data not found!');
    }
  }

  void _showScoreResult(int tempScore) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Quiz Result'),
        content: Text('Your score: $tempScore'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchQuizData();
  }

  Future<void> _fetchQuizData() async {
    final quizSnapshot = await FirebaseFirestore.instance
        .collection('examquestion')
        .doc(widget.quizId)
        .get();

    if (quizSnapshot.exists) {
      setState(() {
        quizData = List<Map<String, dynamic>>.from(
            quizSnapshot.get('questions') ?? []);
        selectedOptions = List<String>.filled(quizData.length, '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Answer the Quiz'),
      ),
      body: quizData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: quizData.length,
              itemBuilder: (context, index) {
                final question = quizData[index]['question'];
                final options = List<String>.from(quizData[index]['options']);

                return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question ${index + 1}:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        question ?? 'Question not available',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Options:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (context, optionIndex) {
                          final option = options[optionIndex];
                          final isSelected = (optionIndex + 1).toString() ==
                              selectedOptions[index];

                          return ListTile(
                            onTap: () {
                              _selectOption(index, optionIndex);
                            },
                            title: Text('${optionIndex + 1}: $option'),
                            leading: isSelected
                                ? Icon(Icons.check_circle, color: Colors.green)
                                : Icon(Icons.radio_button_unchecked),
                          );
                        },
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final userId = FirebaseAuth.instance.currentUser!.uid;

          // Pass the user ID to the _submitQuiz method
          _submitQuiz(userId);
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
