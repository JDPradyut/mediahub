import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mediahub/players/moviePlayer.dart';
import 'package:mediahub/screens/homepages/homescreens/home/home.dart';
import 'package:mediahub/screens/homepages/homescreens/movie/movie.dart';
import 'package:mediahub/screens/homepages/homescreens/myList/myList.dart';
import 'package:mediahub/screens/homepages/homescreens/tvShow/tvShow.dart';
import 'package:mediahub/screens/homepages/homescreens/tvShow/tvshowDetail.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  bool _isSeries = false;
  int currentTab;
  String valueID = '';
  String tit = '';
  String vdo = '';
  String pic = '';
  int scout = 0;
  bool _loaded = false;
  _getLatest() async {
    var movie = await FirebaseFirestore.instance
        .collection('newmov')
        .orderBy("dot", descending: true)
        .limit(1)
        .get();
    var serie = await FirebaseFirestore.instance
        .collection('newser')
        .orderBy("dot", descending: true)
        .limit(1)
        .get();
    if (movie.docs.first.exists && serie.docs.first.exists) {
      DocumentSnapshot myMov = movie.docs.first;
      DocumentSnapshot mySer = serie.docs.first;
      if (int.parse('${myMov['dot']}') > int.parse('${mySer['dot']}')) {
        setState(() {
          valueID = myMov.id;
          vdo = '${myMov['video']}';
          tit = '${myMov['title']}';
          pic = '${myMov['image']}';
          _isSeries = false;
          _loaded = true;
        });
      } else {
        setState(() {
          valueID = mySer.id;
          scout = int.parse('${mySer['scout']}');
          vdo = '${mySer['video']}';
          tit = '${mySer['title']}';
          pic = '${mySer['image']}';
          _isSeries = true;
          _loaded = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getLatest();
    tabController = TabController(length: 4, vsync: this);
    currentTab = 0;
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void goTo(int index) {
    this.tabController.animateTo(index);
    setState(() {
      this.currentTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser.uid;
    final Size screenSize = MediaQuery.of(context).size;
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                child: (!_loaded)
                    ? Container(
                        child: Center(
                        child: CircularProgressIndicator(),
                      ))
                    : Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            width: screenSize.width,
                            height: ((screenSize.height / 2)) - 10,
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(100),
                              ),
                            ),
                          ),
                          Container(
                            width: screenSize.width,
                            height: ((screenSize.height / 2)) - 12,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(pic),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(120),
                              ),
                            ),
                          ),
                          Container(
                            height: ((screenSize.height / 2)) - 12,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(120),
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
                            bottom: 10,
                            right: 0,
                            child: GestureDetector(
                              child: Container(
                                height: 40,
                                width: 200,
                                decoration: BoxDecoration(
                                    color: Colors.teal,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    )),
                                child: Center(
                                  child: Text(
                                    'Watch Now',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                if (_isSeries) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => SeriesDetail(
                                              sesNum: scout,
                                              vdo: vdo,
                                              valueID: valueID,
                                            )),
                                  );
                                } else {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => MoviePlayer(
                                              image: pic,
                                              tit: tit,
                                              vdo: vdo,
                                              valueID: valueID,
                                            )),
                                  );
                                }
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 210,
                            child: GestureDetector(
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.teal,
                                    size: 40,
                                  ),
                                ),
                              ),
                              onTap: () async {
                                if (_isSeries) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => SeriesDetail(
                                              sesNum: scout,
                                              vdo: vdo,
                                              valueID: valueID,
                                            )),
                                  );
                                } else {
                                  await FirebaseFirestore.instance
                                      .collection('userlist')
                                      .doc(uid)
                                      .collection('mylist')
                                      .doc(valueID)
                                      .set({
                                    'title': tit,
                                    'video': vdo,
                                    'image': pic
                                  });

                                  Fluttertoast.showToast(
                                      msg: 'Added to My List',
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.teal,
                                      textColor: Colors.white,
                                      timeInSecForIosWeb: 1,
                                      fontSize: 16);
                                }
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 90,
                            left: screenSize.width / 2 - 140,
                            child: Container(
                              height: 150,
                              width: 300,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Now Streaming',
                                    style: TextStyle(
                                      color: Colors.teal,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    tit,
                                    maxLines: 3,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            pinned: true,
            automaticallyImplyLeading: false,
            expandedHeight:
                (currentTab == 0) ? (screenSize.height / 2) - 10 : null,
            title: Container(
              child: Row(
                children: [
                  GestureDetector(
                    child: Image.asset(
                      'images/slogo.png',
                      height: 42,
                    ),
                    onTap: () => goTo(0),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            child: Text(
                              'TV Shows',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () => goTo(1)),
                        TextButton(
                          child: Text(
                            'Movies',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () => goTo(2),
                        ),
                        TextButton(
                          child: Text(
                            'My List',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () => goTo(3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ];
      },
      body: TabBarView(
        controller: tabController,
        physics: NeverScrollableScrollPhysics(),
        children: [Home(), TVShow(), Movie(), MyList()],
      ),
    );
  }
}
