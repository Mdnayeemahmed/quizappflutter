import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'full_result_list.dart';

class viewresult extends StatefulWidget {
  const viewresult({Key? key}) : super(key: key);

  @override
  State<viewresult> createState() => _viewresultState();
}

class _viewresultState extends State<viewresult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("results").snapshots(),
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
                                builder: (context) => FullResultOption(
                                  quizId: item.id,
                                )));
                      },
                      title: Text( 'All participant Result of '+item.id),
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
