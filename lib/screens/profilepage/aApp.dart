import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AboutApp extends StatefulWidget {
  @override
  _AboutAppState createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  PackageInfo _packageInfo = PackageInfo(version: 'Unknown');
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
        appBar: AppBar(
          title: Text('About App'),
          backgroundColor: Colors.grey[850],
        ),
        body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('appUpdate').snapshots(),
          builder: (context, snapshot) {
            DocumentSnapshot checkUp = snapshot.data.docs[0];
            String upVer = '${checkUp['ver']}';
            if (!snapshot.hasData)
              return Container(
                  child: Center(
                child: CircularProgressIndicator(),
              ));
            return Center(
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Image.asset(
                      'images/logo.png',
                      height: 150,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      checkStatus(upVer, _packageInfo.version),
                      style: TextStyle(
                        color: checkStatusColor(upVer, _packageInfo.version),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Latest version : ' + upVer,
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Current version : ' + _packageInfo.version,
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 70),
                    Visibility(
                      visible: buttonVisible(upVer, _packageInfo.version),
                      child: RaisedButton.icon(
                        icon: Icon(Icons.update_rounded),
                        label: Text('UPDATE'),
                        onPressed: () {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('MediaHub Update'),
                                  contentPadding: EdgeInsets.all(10),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: [
                                        Text('Status : ' +
                                            '${checkUp['title']}'),
                                        Text('Latest Version : ' +
                                            '${checkUp['ver']}'),
                                        Text('Changelogs : ' +
                                            '${checkUp['detail']}'),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text('UPDATE'),
                                      onPressed: () async {
                                        final status =
                                            await Permission.storage.request();
                                        if (status.isGranted) {
                                          final extDir =
                                              await getExternalStorageDirectory();
                                          FlutterDownloader.enqueue(
                                              url: '${checkUp['link']}',
                                              savedDir: extDir.path,
                                              showNotification: true,
                                              fileName: '${checkUp['title']}' +
                                                  ".apk",
                                              openFileFromNotification: true);
                                          Fluttertoast.showToast(
                                              msg:
                                                  'UPDATING...Check Notification Panel',
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.CENTER,
                                              backgroundColor:
                                                  Colors.deepOrangeAccent,
                                              textColor: Colors.white,
                                              timeInSecForIosWeb: 1,
                                              fontSize: 16);
                                          Navigator.pop(context);
                                        } else {
                                          Fluttertoast.showToast(
                                              msg:
                                                  'Please Give Required PerMission',
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.CENTER,
                                              backgroundColor:
                                                  Colors.deepOrangeAccent,
                                              textColor: Colors.white,
                                              timeInSecForIosWeb: 1,
                                              fontSize: 16);
                                          Navigator.pop(context);
                                        }
                                      },
                                    )
                                  ],
                                );
                              });
                        },
                      ),
                    ),
                    SizedBox(height: 15),
                    Divider(height: 2),
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: ListBody(
                                children: [
                                  Text(
                                    "What's New !",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                    child: Divider(
                                      height: 1,
                                      color: Colors.grey,
                                    ),
                                    padding: EdgeInsets.all(5),
                                  ),
                                  Text(
                                    '1. UI changes \n2. Added Notification features\n3. Fixed all bugs and Missing features\n4. Added Youtube player\n5. Added advanced Download Manager where you can press CANCEL button to cancel ongoing task from app and Longpress CANCEL button to cancel all ongoing tasks\n6. Added Advanced & Fast Searching system in Search Page\n7. Added Delete Confirmation option\n8. Added Auto Rotation in Video Player\n9. Added Brightness Controller in Video Player\n10. Added HwAcc support in Video Player to fix Frame drops in Video Player while Streaming HD Videos(Auto,ON,OFF[Default])\n11. Upcoming, Preview and TOP movies lists are replace with TMDB Database.',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  Padding(
                                    child: Divider(
                                      height: 1,
                                      color: Colors.grey,
                                    ),
                                    padding: EdgeInsets.all(5),
                                  ),
                                  Text(
                                    "Features",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                    child: Divider(
                                      height: 1,
                                      color: Colors.grey,
                                    ),
                                    padding: EdgeInsets.all(5),
                                  ),
                                  Text(
                                    '1. Watch new and trending Movies and TV Shows in HD quality\n2. You can also download movies/shows and watch it later\n3. You can request movies/shows which you want to watch and it will be added within 1-24hrs\n4. Cast Video Player screen in your Chrome cast devices\n5. Set Hardware Acceleration accordingly to your device for better frame rates in video\n6. Use two fingers to zoom in/out video to fit your screen',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
