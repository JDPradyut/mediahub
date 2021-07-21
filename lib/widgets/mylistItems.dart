import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mediahub/players/trailerPlayer.dart';

class MyListItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser.uid;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('userlist')
          .doc(uid)
          .collection('mylist')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    Icons.subscriptions,
                    color: Colors.teal,
                    size: 80,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'You have not Added anything yet',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, childAspectRatio: 100 / 150),
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot mypost = snapshot.data.docs[index];
            String vdo = '${mypost['video']}';
            String tit = '${mypost['title']}';
            return Padding(
              padding: EdgeInsets.all(5),
              child: GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        image: NetworkImage('${mypost['image']}'),
                        fit: BoxFit.cover,
                      )),
                ),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (BuildContext context) {
                      return Container(
                        height: 150,
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[850],
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10))),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                GestureDetector(
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.play_circle_fill_rounded,
                                        color: Colors.white70,
                                        size: 80,
                                      ),
                                      Text(
                                        'Play',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 25),
                                      )
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TrailerPlayer(
                                                image: '${mypost['image']}',
                                                tit: tit,
                                                vdo: vdo,
                                              )),
                                    );
                                  },
                                ),
                                GestureDetector(
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.delete,
                                        color: Colors.white70,
                                        size: 80,
                                      ),
                                      Text(
                                        'Remove',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 25),
                                      )
                                    ],
                                  ),
                                  onTap: () async {
                                    await FirebaseFirestore.instance
                                        .runTransaction(
                                            (Transaction transaction) async {
                                      // ignore: await_only_futures
                                      await transaction
                                          .delete(mypost.reference);
                                    });
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
