import 'package:flutter/material.dart';
import 'package:mediahub/jdme/bug.dart';
import 'package:mediahub/jdme/feedback.dart';
import 'package:mediahub/jdme/movie.dart';
import 'package:mediahub/jdme/preview.dart';
import 'package:mediahub/jdme/request.dart';
import 'package:mediahub/jdme/series.dart';
import 'package:mediahub/jdme/topten.dart';
import 'package:mediahub/jdme/upcoming.dart';
import 'package:mediahub/jdme/livetv.dart';

class JDPage extends StatefulWidget {
  @override
  _JDPageState createState() => _JDPageState();
}

class _JDPageState extends State<JDPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('JD Page'),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: 100 / 100),
            children: [
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.movie),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Movie()));
                    },
                  ),
                  Text('Add Movie')
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.video_library),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Series()));
                    },
                  ),
                  Text('Add Series')
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.live_tv),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LiveTvManager()));
                    },
                  ),
                  Text('TV manager')
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.bug_report),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Bug()));
                    },
                  ),
                  Text('Bug Reports')
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.feedback),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Feedbacks()));
                    },
                  ),
                  Text('Feedbaack')
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.request_quote),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Request()));
                    },
                  ),
                  Text('Requests')
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.preview),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Preview()));
                    },
                  ),
                  Text('Previews')
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.topic),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => TopTen()));
                    },
                  ),
                  Text('Top Ten')
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.timelapse),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Upcoming()));
                    },
                  ),
                  Text('Upcoming')
                ],
              )
            ],
          ),
        ));
  }
}
