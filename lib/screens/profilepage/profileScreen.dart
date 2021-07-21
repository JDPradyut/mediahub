import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mediahub/screens/auth/loginPage.dart';
import 'package:mediahub/screens/profilepage/aApp.dart';
import 'package:mediahub/screens/profilepage/requestScreen.dart';
//import 'package:mediahub/jdme/jdpage.dart';
//import 'package:mediahub/screens/testScreen.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
  }

  @override
  Widget build(BuildContext context) {
    var tg = 'https://t.me/MediahubSupport';
    var tc = 'https://t.me/MediahubOfficial';
    var du = 'https://www.buymeacoffee.com/mediahub';
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: ListView(
          children: [
            Center(
              child: Image.asset('images/logo.png', height: 150),
            ),
            Center(
              child: Text(
                'ver: BETA_' + _packageInfo.version,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            SizedBox(height: 50),
            ListTile(
              leading: Icon(
                LineIcons.telegram,
                color: Colors.grey,
              ),
              title: Text(
                'Join us on Telegram',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    color: Colors.white,
                    fontSize: 18),
              ),
              onTap: () async =>
                  await canLaunch(tc) ? await launch(tc) : throw 'Failed',
            ),
            ListTile(
              leading: Icon(
                LineIcons.donate,
                color: Colors.grey,
              ),
              title: Text(
                'Donate us',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    color: Colors.white,
                    fontSize: 18),
              ),
              onTap: () async =>
                  await canLaunch(du) ? await launch(du) : throw 'Failed',
            ),
            ListTile(
              leading: Icon(
                Icons.feedback,
                color: Colors.grey,
              ),
              title: Text(
                'Feedback',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    color: Colors.white,
                    fontSize: 18),
              ),
              onTap: () async =>
                  await canLaunch(tg) ? await launch(tg) : throw 'Failed',
            ),
            ListTile(
              leading: Icon(
                Icons.movie,
                color: Colors.grey,
              ),
              title: Text(
                'Request',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    color: Colors.white,
                    fontSize: 18),
              ),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => RequestScreen())),
            ),
            /*   ListTile(
                leading: Icon(
                  Icons.admin_panel_settings,
                  color: Colors.grey,
                ),
                title: Text(
                  'Admin',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      color: Colors.white,
                      fontSize: 18),
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => JDPage()));
                }),
                   ListTile(
                title: Text(
                  'TestScreen',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      color: Colors.white,
                      fontSize: 18),
                ),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TestScreen()));
                }), */
            ListTile(
              leading: Icon(
                Icons.report,
                color: Colors.grey,
              ),
              title: Text(
                'Report Bug',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    color: Colors.white,
                    fontSize: 18),
              ),
              onTap: () async =>
                  await canLaunch(tg) ? await launch(tg) : throw 'Failed',
            ),
            ListTile(
              leading: Icon(
                Icons.info,
                color: Colors.grey,
              ),
              title: Text(
                'About App',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    color: Colors.white,
                    fontSize: 18),
              ),
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AboutApp())),
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.grey,
              ),
              title: Text(
                'Log Out',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    color: Colors.white,
                    fontSize: 18),
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()),
                    (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
