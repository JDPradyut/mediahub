import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mediahub/screens/homepages/homescreens/tvShow/tvshowDetail.dart';

class HolSer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.black,
              flexibleSpace: FlexibleSpaceBar(
                title: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hollywood',
                      ),
                      Text(
                        'Series',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                background: Container(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        width: screenSize.width,
                        height: ((screenSize.height / 2)) - 10,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(100),
                          ),
                        ),
                      ),
                      Container(
                        height: ((screenSize.height / 2)) - 30,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(160),
                          ),
                          color: Colors.black,
                        ),
                      ),
                      Positioned(
                        child: Container(
                          height: ((screenSize.height / 2)) - 10,
                          width: screenSize.width / 2,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/hser.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        left: 5,
                      ),
                      Positioned(
                        bottom: 100,
                        left: 50,
                        child: SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'HOLLYWOOD',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Series',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              pinned: true,
              expandedHeight: (screenSize.height / 2) - 10,
            )
          ];
        },
        body: Container(
          color: Colors.black,
          child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('newser')
                  .where('category', isEqualTo: 'hollywood')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData)
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, childAspectRatio: 100 / 150),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot mypost = snapshot.data.docs[index];
                    String vdo = '${mypost['video']}';
                    return Padding(
                        padding: EdgeInsets.all(5),
                        child: OpenContainer(
                            openColor: Colors.transparent,
                            closedColor: Colors.transparent,
                            closedBuilder: (context, action) {
                              return Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    image: DecorationImage(
                                      image: NetworkImage('${mypost['image']}'),
                                      fit: BoxFit.cover,
                                    )),
                              );
                            },
                            openBuilder: (context, action) {
                              return SeriesDetail(
                                valueID: mypost.id,
                                vdo: vdo,
                                sesNum: int.parse('${mypost['scout']}'),
                              );
                            }));
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
