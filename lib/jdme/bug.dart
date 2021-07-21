import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Bug extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bug Reports'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('bugreport').snapshots(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot mypost = snapshot.data.docs[index];
              return ListTile(
                title: Text('${mypost['bug']}'),
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
