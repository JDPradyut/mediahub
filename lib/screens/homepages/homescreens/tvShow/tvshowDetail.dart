import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mediahub/players/seriesPlayer.dart';
import 'package:mediahub/players/trailerPlayer.dart';
import 'package:mediahub/services/admob_service.dart';
import 'package:mediahub/widgets/downloaderWidget.dart';

// ignore: must_be_immutable
class SeriesDetail extends StatefulWidget {
  String valueID;

  int sesNum;
  String vdo;
  SeriesDetail({this.valueID, this.vdo, @required this.sesNum});
  @override
  _SeriesDetailState createState() => _SeriesDetailState(valueID, vdo);
}

class _SeriesDetailState extends State<SeriesDetail> {
  String valueID;
  String vdo;
  _SeriesDetailState(this.valueID, this.vdo);
  String sesName;
  AdmobReward videoAd;
  @override
  void initState() {
    if (widget.sesNum > 9) {
      sesName = 'S01';
    } else {
      sesName = 'S1';
    }
    videoAd = AdmobReward(
      adUnitId: 'ca-app-pub-4365365728148175/2916962630',
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) videoAd.load();
        AdMobServices.handleEvent(event, args, 'Video Ad');
      },
    );
    videoAd.load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser.uid;
    String epiID = valueID;
    var screenSize = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('newser')
          .doc(valueID)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Container(
              child: Center(
            child: CircularProgressIndicator(),
          ));
        var mdoc = snapshot.data;
        return Scaffold(
          backgroundColor: Colors.black,
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: screenSize.height / 2,
                  backgroundColor: Colors.black,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            width: screenSize.width,
                            height: ((screenSize.height / 2)) - 10,
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(100),
                                bottomRight: Radius.circular(100),
                              ),
                            ),
                          ),
                          Container(
                            width: screenSize.width,
                            height: ((screenSize.height / 2)) - 12,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(mdoc['image']),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(120),
                                bottomRight: Radius.circular(120),
                              ),
                            ),
                          ),
                          Container(
                            height: ((screenSize.height / 2)) - 12,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(120),
                                bottomRight: Radius.circular(120),
                              ),
                              gradient: LinearGradient(
                                  colors: [Colors.black87, Colors.transparent],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.center),
                            ),
                          ),
                          Container(
                            height: ((screenSize.height / 2)) - 10,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Colors.black87, Colors.transparent],
                                  begin: Alignment.topCenter,
                                  end: Alignment.center),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            child: GestureDetector(
                              child: Container(
                                height: 40,
                                width: 200,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.teal,
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    )),
                                child: Center(
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                      Icon(
                                        Icons.play_arrow,
                                        color: Colors.teal,
                                      ),
                                      Text(
                                        'Trailer',
                                        style: TextStyle(
                                          color: Colors.teal,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ])),
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => TrailerPlayer(
                                            image: mdoc['image'],
                                            tit: mdoc['title'],
                                            vdo: vdo,
                                          )),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                      child: Text(
                        mdoc['title'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                      child: Text.rich(
                        TextSpan(
                            text: 'Detail : ',
                            style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                  text: mdoc['detail'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ))
                            ]),
                      ),
                    ),
                    AdmobBanner(
                      adUnitId: 'ca-app-pub-4365365728148175/3022242173',
                      adSize: AdmobBannerSize.BANNER,
                      listener:
                          (AdmobAdEvent event, Map<String, dynamic> args) {
                        AdMobServices.handleEvent(event, args, 'Banner');
                      },
                      onBannerCreated: (AdmobBannerController adController) {},
                    ),
                    Container(
                      height: 45,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: mdoc['scout'],
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(left: 15, top: 10),
                            child: GestureDetector(
                              onTap: () {
                                if (mdoc['scout'] > 9 && (index + 1) < 10) {
                                  setState(() {
                                    sesName = 'S0' + (index + 1).toString();
                                  });
                                } else {
                                  setState(() {
                                    sesName = 'S' + (index + 1).toString();
                                  });
                                }
                              },
                              child: Container(
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.teal.withOpacity(0.5),
                                ),
                                child: Center(
                                  child: Text(
                                    'Season ' + (index + 1).toString(),
                                    maxLines: 1,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ]),
                ),
              ];
            },
            body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('newser')
                  .doc(epiID)
                  .collection('episodes')
                  .orderBy('title', descending: false)
                  .where('title', isGreaterThanOrEqualTo: sesName)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot mypost = snapshot.data.docs[index];
                    String valueId = mypost.id;
                    return Padding(
                        padding: EdgeInsets.only(left: 8, right: 8, top: 8),
                        child: GestureDetector(
                            onTap: () async {
                              if (await videoAd.isLoaded) {
                                videoAd.show();
                              }
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SeriesPlayer(
                                            image: '${mypost['image']}',
                                            tit: '${mypost['title']}',
                                            vdo: '${mypost['video']}',
                                          )));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[900].withOpacity(0.6),
                              ),
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            height: 70,
                                            width: 150,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      '${mypost['image']}'),
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          Container(
                                            height: 70,
                                            width: 150,
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                  colors: [
                                                    Colors.black54,
                                                    Colors.black12
                                                  ],
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.center),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 10,
                                            left: 0,
                                            right: 0,
                                            child: Icon(
                                              Icons.play_circle_outline,
                                              color: Colors.white60,
                                              size: 50,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Row(children: [
                                        Text(
                                          '${mypost['title']}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22),
                                        )
                                      ]),
                                      Row(children: [
                                        IconButton(
                                            icon: Icon(Icons.add,
                                                color: Colors.white),
                                            onPressed: () async {
                                              await FirebaseFirestore.instance
                                                  .collection('userlist')
                                                  .doc(uid)
                                                  .collection('mylist')
                                                  .doc(valueId)
                                                  .set({
                                                'title': '${mypost['title']}',
                                                'video': '${mypost['video']}',
                                                'image': '${mypost['image']}'
                                              });

                                              Fluttertoast.showToast(
                                                  msg: 'Added to My List',
                                                  toastLength:
                                                      Toast.LENGTH_LONG,
                                                  gravity: ToastGravity.CENTER,
                                                  backgroundColor: Colors.teal,
                                                  textColor: Colors.white,
                                                  timeInSecForIosWeb: 1,
                                                  fontSize: 16);
                                            }),
                                        IconButton(
                                            icon: Icon(Icons.download_outlined,
                                                color: Colors.white),
                                            onPressed: () {
                                              showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (context) {
                                                    return DownWidget(
                                                      header: mdoc['title'],
                                                      image: mdoc['image'],
                                                      detail: mdoc['title'] +
                                                          ' ' +
                                                          '${mypost['title']}',
                                                      video:
                                                          '${mypost['video']}',
                                                    );
                                                  });
                                            })
                                      ])
                                    ],
                                  )
                                ],
                              ),
                            )));
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
