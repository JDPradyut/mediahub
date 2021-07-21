import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mediahub/widgets/toptenPre.dart';

class PreviewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          height: 150,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('preview')
                .limit(5)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Container(
                  child: Center(child: CircularProgressIndicator()),
                );
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot mypost = snapshot.data.docs[index];
                  String valueID = snapshot.data.docs[index].id;
                  String vdo = '${mypost['video']}';
                  String tit = '${mypost['title']}';
                  return Padding(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: GestureDetector(
                      child: Container(
                        height: 150.0,
                        width: 100.0,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                    image: NetworkImage('${mypost['image']}'),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.teal.withOpacity(0.8),
                                    Colors.transparent
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: 10,
                                child: Container(
                                  child: Text(
                                    '${mypost['title']}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ToptenPre(
                                  '${mypost['image']}', tit, valueID, vdo))),
                    ),
                  );
                },
              );
            },
          ),
        ));
  }
}
