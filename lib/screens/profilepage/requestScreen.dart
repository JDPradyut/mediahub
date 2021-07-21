import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mediahub/widgets/reqDialog.dart';

class RequestScreen extends StatefulWidget {
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  String uid = FirebaseAuth.instance.currentUser.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Request'),
        backgroundColor: Colors.grey[850],
      ),
      floatingActionButton: ElevatedButton.icon(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        icon: Icon(Icons.add),
        label: Text('Request'),
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return ReqDialog();
            },
          );
        },
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('request')
              .where('uid', isEqualTo: uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            if (snapshot.data.docs.isEmpty)
              return Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.movie_filter,
                        color: Colors.teal,
                        size: 80,
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'You have not requested anything yet.Press the Request Button to add your request about your favourite Movies/Series which is not available in app right now.',
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                var mypost = snapshot.data.docs[index];
                return Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                  child: ListTile(
                    tileColor: Colors.grey[900],
                    leading: Text(
                      '${mypost['status']}'.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ('${mypost['status']}' == 'pending')
                            ? Colors.amber
                            : ('${mypost['status']}' == 'done')
                                ? Colors.green
                                : Colors.red,
                      ),
                    ),
                    title: Text(
                      '[${mypost['qty']}] ${mypost['title']}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      '${mypost['cat']}',
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .runTransaction((Transaction transaction) async {
                          // ignore: await_only_futures
                          await transaction.delete(mypost.reference);
                        });
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
