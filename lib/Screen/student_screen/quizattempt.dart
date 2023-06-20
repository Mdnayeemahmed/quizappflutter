import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizappflutter/Screen/student_screen/answerthequiz.dart';

class quizpage extends StatefulWidget {
  const quizpage({Key? key}) : super(key: key);

  @override
  State<quizpage> createState() => _quizpageState();
}

class _quizpageState extends State<quizpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Homepage'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("examquestion").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (snapshot.hasData) {
              print(snapshot.data!.docs);
              return ListView.builder(
                  itemCount: snapshot.data?.docs.length ?? 0,
                  itemBuilder: (context, index) {
                    final QueryDocumentSnapshot item =
                    snapshot.data!.docs[index];
                    return ListTile(
                      onTap: () {
                         Navigator.push(
                             context,
                             MaterialPageRoute(
                                 builder: (context) => AnswerTheQuiz(
                                   quizId: item.id,
                                 )));
                      },
                        title: Text(item.id),
                      trailing: Icon(Icons.arrow_forward),
                    );
                  });
            } else {
              Text('Error');
              return SizedBox();
            }
          }),

    );
  }
}
