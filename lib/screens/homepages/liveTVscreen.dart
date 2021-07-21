import 'package:admob_flutter/admob_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mediahub/players/trailerPlayer.dart';
import 'package:mediahub/services/admob_service.dart';

class LiveTVScreen extends StatefulWidget {
  @override
  _LiveTVScreenState createState() => _LiveTVScreenState();
}

class _LiveTVScreenState extends State<LiveTVScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          AdmobBanner(
            adUnitId: AdMobServices.bannerAdUnitID,
            adSize: AdmobBannerSize.BANNER,
            listener: (AdmobAdEvent event, Map<String, dynamic> args) {
              AdMobServices.handleEvent(event, args, 'Banner');
            },
            onBannerCreated: (AdmobBannerController adController) {},
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
                height: 200,
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('nplay')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Container(
                          child: Center(child: CircularProgressIndicator()),
                        );
                      return CarouselSlider.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index, sind) {
                          DocumentSnapshot mypost = snapshot.data.docs[index];
                          return GestureDetector(
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  image: DecorationImage(
                                    image: NetworkImage('${mypost['image']}'),
                                    fit: BoxFit.cover,
                                  ),
                                )),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
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
                                    left: 10,
                                    child: Container(
                                      child: Text(
                                        '${mypost['title']}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 26,
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => TrailerPlayer(
                                        image: '${mypost['image']}',
                                        tit: '${mypost['title']}',
                                        vdo: '${mypost['video']}',
                                      )));
                            },
                          );
                        },
                        options: CarouselOptions(
                          height: 200.0,
                          autoPlay: true,
                          autoPlayCurve: Curves.easeInOut,
                          enlargeCenterPage: true,
                        ),
                      );
                    })),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Now Playing',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Ubuntu',
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                height: 100,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('nplay')
                      .orderBy("dot", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Container(
                          child: Center(child: CircularProgressIndicator()));
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot mypost = snapshot.data.docs[index];
                        return Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: GestureDetector(
                            child: Container(
                              height: 100.0,
                              width: 150.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                    image: NetworkImage('${mypost['image']}'),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => TrailerPlayer(
                                        image: '${mypost['image']}',
                                        tit: '${mypost['title']}',
                                        vdo: '${mypost['video']}',
                                      )));
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              )),
          AdmobBanner(
            adUnitId: AdMobServices.bannerAdUnitID,
            adSize: AdmobBannerSize.BANNER,
            listener: (AdmobAdEvent event, Map<String, dynamic> args) {
              AdMobServices.handleEvent(event, args, 'Banner');
            },
            onBannerCreated: (AdmobBannerController adController) {},
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hindi Channels',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Ubuntu',
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                height: 80,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('livetv')
                      .where('category', isEqualTo: 'hindi')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Container(
                          child: Center(child: CircularProgressIndicator()));
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot mypost = snapshot.data.docs[index];
                        return Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: GestureDetector(
                            child: Container(
                              height: 80.0,
                              width: 80.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                    image: NetworkImage('${mypost['image']}'),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => TrailerPlayer(
                                        image: '${mypost['image']}',
                                        tit: '${mypost['title']}',
                                        vdo: '${mypost['video']}',
                                      )));
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              )),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'English Channels',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Ubuntu',
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                height: 80,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('livetv')
                      .where('category', isEqualTo: 'english')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Container(
                          child: Center(child: CircularProgressIndicator()));
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot mypost = snapshot.data.docs[index];
                        return Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: GestureDetector(
                            child: Container(
                              height: 80.0,
                              width: 80.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                    image: NetworkImage('${mypost['image']}'),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => TrailerPlayer(
                                        image: '${mypost['image']}',
                                        tit: '${mypost['title']}',
                                        vdo: '${mypost['video']}',
                                      )));
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              )),
          AdmobBanner(
            adUnitId: 'ca-app-pub-4365365728148175/7153058873',
            adSize: AdmobBannerSize.BANNER,
            listener: (AdmobAdEvent event, Map<String, dynamic> args) {
              AdMobServices.handleEvent(event, args, 'Banner');
            },
            onBannerCreated: (AdmobBannerController adController) {},
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Other Channels',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Ubuntu',
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                height: 80,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('livetv')
                      .where('category', isEqualTo: 'other')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Container(
                          child: Center(child: CircularProgressIndicator()));
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot mypost = snapshot.data.docs[index];
                        return Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: GestureDetector(
                            child: Container(
                              height: 80.0,
                              width: 80.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                    image: NetworkImage('${mypost['image']}'),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => TrailerPlayer(
                                        image: '${mypost['image']}',
                                        tit: '${mypost['title']}',
                                        vdo: '${mypost['video']}',
                                      )));
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              )),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Music Channels',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Ubuntu',
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                height: 80,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('livetv')
                      .where('category', isEqualTo: 'music')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Container(
                          child: Center(child: CircularProgressIndicator()));
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot mypost = snapshot.data.docs[index];
                        return Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: GestureDetector(
                            child: Container(
                              height: 80.0,
                              width: 80.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                    image: NetworkImage('${mypost['image']}'),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => TrailerPlayer(
                                        image: '${mypost['image']}',
                                        tit: '${mypost['title']}',
                                        vdo: '${mypost['video']}',
                                      )));
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              )),
          AdmobBanner(
            adUnitId: AdMobServices.bannerAdUnitID,
            adSize: AdmobBannerSize.BANNER,
            listener: (AdmobAdEvent event, Map<String, dynamic> args) {
              AdMobServices.handleEvent(event, args, 'Banner');
            },
            onBannerCreated: (AdmobBannerController adController) {},
          ),
        ],
      ),
      appBar: AppBar(
        title: Text(
          'Live TV',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Colors.grey[850],
      ),
    );
  }
}
