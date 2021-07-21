import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Feedbacks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedbacks'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('feedback').snapshots(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot mypost = snapshot.data.docs[index];
              return ListTile(
                title: Text('${mypost['title']}'),
                onTap: () async {
                  await FirebaseFirestore.instance
                      .runTransaction((Transaction transaction) async {
                    // ignore: await_only_futures
                    await transaction.delete(mypost.reference);
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}
