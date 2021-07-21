import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mediahub/players/trailerPlayer.dart';
import 'package:mediahub/services/admob_service.dart';
import 'package:mediahub/widgets/downloaderWidget.dart';

// ignore: must_be_immutable
class ToptenPre extends StatefulWidget {
  String image;
  String title;
  String valueID;
  String vdo;

  ToptenPre(this.image, this.title, this.valueID, this.vdo);

  @override
  _ToptenPreState createState() =>
      _ToptenPreState(this.image, this.title, this.valueID, this.vdo);
}

class _ToptenPreState extends State<ToptenPre> {
  String image;
  String title;
  String valueID;
  String vdo;

  _ToptenPreState(this.image, this.title, this.valueID, this.vdo);

  AdmobReward videoAd;
  @override
  void initState() {
    super.initState();
    videoAd = AdmobReward(
      adUnitId: 'ca-app-pub-4365365728148175/2916962630',
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) videoAd.load();
        AdMobServices.handleEvent(event, args, 'Video Ad');
      },
    );
    videoAd.load();
  }

  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    String uid = FirebaseAuth.instance.currentUser.uid;
    return Container(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.black,
            expandedHeight: screensize.height,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black, Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 50,
                    child: Container(
                      width: screensize.width - 50,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              maxLines: 3,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            AdmobBanner(
                              adUnitId:
                                  'ca-app-pub-4365365728148175/3502971361',
                              adSize: AdmobBannerSize.BANNER,
                              listener: (AdmobAdEvent event,
                                  Map<String, dynamic> args) {
                                AdMobServices.handleEvent(
                                    event, args, 'Banner');
                              },
                              onBannerCreated:
                                  (AdmobBannerController adController) {},
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    if (await videoAd.isLoaded) {
                                      videoAd.show();
                                    }
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => TrailerPlayer(
                                                image: image,
                                                tit: title,
                                                vdo: vdo,
                                              )),
                                    );
                                  },
                                  icon: Icon(Icons.play_arrow),
                                  label: Text('PLAY NOW'),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: (screensize.width / 2) / 2 + 10,
                                      child: ElevatedButton.icon(
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('userlist')
                                              .doc(uid)
                                              .collection('mylist')
                                              .doc(valueID)
                                              .set({
                                            'title': title,
                                            'video': vdo,
                                            'image': image
                                          });

                                          Fluttertoast.showToast(
                                              msg: 'Added to My List',
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.CENTER,
                                              backgroundColor: Colors.teal,
                                              textColor: Colors.white,
                                              timeInSecForIosWeb: 1,
                                              fontSize: 16);
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.white),
                                        ),
                                        icon: Icon(
                                          Icons.add,
                                          color: Colors.teal,
                                        ),
                                        label: Text(
                                          'My List',
                                          style: TextStyle(color: Colors.teal),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: screensize.width / 2 + 25,
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) {
                                                return DownWidget(
                                                  header: title,
                                                  image: image,
                                                  detail: title,
                                                  video: vdo,
                                                );
                                              });
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.red[300]),
                                        ),
                                        icon: Icon(
                                          Icons.cloud_download_rounded,
                                          color: Colors.white,
                                        ),
                                        label: Text(
                                          'DOWNLOAD',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
