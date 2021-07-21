import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mediahub/widgets/toptenPre.dart';

class TopTenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
          height: 150,
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('topten')
                  .limit(10)
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
                    return GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ToptenPre(
                            '${mypost['image']}',
                            '${mypost['title']}',
                            snapshot.data.docs[index].id,
                            '${mypost['video']}'),
                      )),
                      child: Container(
                        height: 150,
                        width: 120,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Positioned(
                              right: 0,
                              child: Container(
                                height: 150.0,
                                width: 100.0,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                '${mypost['image']}'),
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
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              bottom: 0,
                              child: Text(
                                (index + 1).toString(),
                                style: TextStyle(
                                  height: 0.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70,
                                  fontSize: 80,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              })),
    );
  }
}
