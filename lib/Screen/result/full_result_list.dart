import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FullResultOption extends StatefulWidget {
  final String quizId;

  const FullResultOption({Key? key, required this.quizId}) : super(key: key);

  @override
  _FullResultOptionState createState() => _FullResultOptionState();
}

class _FullResultOptionState extends State<FullResultOption> {
  List<dynamic> result = [];

  @override
  void initState() {
    super.initState();
    _fetchQuizResults();
  }

  Future<void> _fetchQuizResults() async {
    final resultsCollection = FirebaseFirestore.instance.collection('results');
    final docSnapshot = await resultsCollection.doc(widget.quizId).get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      if (data != null) {
        setState(() {
          result = List<dynamic>.from(data['result']);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Results Of All Student'),
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
