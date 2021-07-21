import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mediahub/services/admob_service.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mediahub/screens/homepages/homescreens/homeScreen.dart';
import 'package:mediahub/screens/homepages/offlineScreen.dart';
import 'package:mediahub/screens/profilepage/profileScreen.dart';
import 'package:mediahub/screens/homepages/searchScreen.dart';
import 'package:mediahub/screens/homepages/liveTVscreen.dart';
import 'package:mediahub/widgets/updaterWidget.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int cindex = 0;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  // ignore: unused_field
  String _message;

  var ofweb = 'https://downloadmediahub.web.app/#/';

  PackageInfo _packageInfo = PackageInfo(
      version: 'Unknown',
      appName: 'Unknown',
      buildNumber: 'Unknown',
      packageName: 'Unknown');
  Future<void> _initPinfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  void initState() {
    super.initState();
    _initPinfo();
    _firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message) async {
        setState(() {
          _message = message['title'];
        });
      },
      onResume: (Map<String, dynamic> message) async {
        setState(() {
          _message = message['title'];
        });
      },
      onMessage: (Map<String, dynamic> message) async {
        setState(() {
          _message = message['title'];
        });
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
        alert: true,
        badge: true,
        provisional: true,
        sound: true,
      ),
    );
    _firebaseMessaging.getToken().then((value) {
      print(value);
    });
  }

  Widget checkVersion(String l, String c, String link, String title,
      String detail, String verCode) {
    var parts1 = l.split('.');
    var parts2 = c.split('.');
    String la = parts1[0].trim() + parts1[1].trim();
    String cu = parts2[0].trim() + parts2[1].trim();
    int latest = int.parse(la);
    int current = int.parse(cu);
    if (latest > current) {
      return Center(
        child: SafeArea(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Image.asset('images/logo.png'),
                SizedBox(
                  height: 15,
                ),
                Text(
                  checkStatus(l, _packageInfo.version),
                  style: TextStyle(
                    color: checkStatusColor(l, _packageInfo.version),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Latest version : ' + l,
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Current version : ' + _packageInfo.version,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 70),
                Visibility(
                  visible: buttonVisible(l, _packageInfo.version),
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.update_rounded),
                    label: Text('UPDATE'),
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return UpdaterWidget(
                              title: title,
                              latest: l,
                              linkUrl: link,
                              status: verCode,
                              changelog: detail,
                            );
                          });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Having problems while updating?',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      child: Text('Click Here'),
                      onPressed: () async => await canLaunch(ofweb)
                          ? await launch(ofweb)
                          : throw 'Failed',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          alignment: Alignment.center,
          children: [
            (cindex == 0)
                ? HomeScreen()
                : (cindex == 1)
                    ? SearchScreen()
                    : (cindex == 2)
                        ? LiveTVScreen()
                        : (cindex == 3)
                            ? OfflineScreen()
                            : ProfileScreen(),
            Positioned(
              bottom: 0,
              child: AdmobBanner(
                adUnitId: 'ca-app-pub-4365365728148175/8208503135',
                adSize: AdmobBannerSize.BANNER,
                listener: (AdmobAdEvent event, Map<String, dynamic> args) {
                  AdMobServices.handleEvent(event, args, 'Banner');
                },
                onBannerCreated: (AdmobBannerController adController) {},
              ),
            ),
          ],
        ),
      );
    }
  }

  String checkStatus(String l, String c) {
    var parts1 = l.split('.');
    var parts2 = c.split('.');
    String la = parts1[0].trim() + parts1[1].trim();
    String cu = parts2[0].trim() + parts2[1].trim();
    int latest = int.parse(la);
    int current = int.parse(cu);
    if (latest > current) {
      return 'New Update is Available';
    } else {
      return 'Your App is Up to Date';
    }
  }

  Color checkStatusColor(String l, String c) {
    var parts1 = l.split('.');
    var parts2 = c.split('.');
    String la = parts1[0].trim() + parts1[1].trim();
    String cu = parts2[0].trim() + parts2[1].trim();
    int latest = int.parse(la);
    int current = int.parse(cu);
    if (latest > current) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  bool buttonVisible(String l, String c) {
    var parts1 = l.split('.');
    var parts2 = c.split('.');
    String la = parts1[0].trim() + parts1[1].trim();
    String cu = parts2[0].trim() + parts2[1].trim();
    int latest = int.parse(la);
    int current = int.parse(cu);
    if (latest > current) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: Container(
          decoration: BoxDecoration(color: Colors.grey[900], boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.tealAccent.withOpacity(.1))
          ]),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: GNav(
                  gap: 0,
                  color: Colors.white,
                  activeColor: Colors.white,
                  iconSize: 24,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  duration: Duration(milliseconds: 800),
                  tabBackgroundColor: Colors.black,
                  tabs: [
                    GButton(
                      icon: LineIcons.home,
                      text: 'Home',
                    ),
                    GButton(
                      icon: LineIcons.search,
                      text: 'Search',
                    ),
                    GButton(
                      icon: Icons.live_tv,
                      text: 'Live TV',
                    ),
                    GButton(
                      icon: LineIcons.download,
                      text: 'Offline',
                    ),
                    GButton(
                      icon: LineIcons.user,
                      text: 'Profile',
                    ),
                  ],
                  selectedIndex: cindex,
                  onTabChange: (index) {
                    setState(() {
                      cindex = index;
                    });
                  }),
            ),
          )),
      body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('appUpdate').snapshots(),
          builder: (context, snapshot) {
            DocumentSnapshot checkUp = snapshot.data.docs[0];
            String upver = '${checkUp['ver']}';

            if (!snapshot.hasData)
              return Center(
                child: Container(
                  child: CircularProgressIndicator(),
                ),
              );
            return checkVersion(
              upver,
              _packageInfo.version,
              '${checkUp['link']}',
              '${checkUp['title']}',
              '${checkUp['detail']}',
              '${checkUp['verCode']}',
            );
          }),
    );
  }
}
