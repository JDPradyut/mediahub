import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mediahub/screens/homepages/homescreens/tvShow/tvshowDetail.dart';

class TrdSeriesWidget extends StatefulWidget {
  @override
  _TrdSeriesWidgetState createState() => _TrdSeriesWidgetState();
}

class _TrdSeriesWidgetState extends State<TrdSeriesWidget> {
  ScrollController scrollController = ScrollController();
  int loader = 5;
  _getMore() {
    if (this.mounted)
      setState(() {
        loader += 5;
      });
    debugPrint(loader.toString());
  }

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        _getMore();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          height: 150,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('newser')
                .limit(loader)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Container(
                  child: Center(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              return ListView.builder(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot mypost = snapshot.data.docs[index];
                  String valueID = snapshot.data.docs[index].id;
                  String vdo = '${mypost['video']}';
                  return Padding(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: OpenContainer(
                      closedColor: Colors.transparent,
                      openColor: Colors.transparent,
                      closedBuilder: (context, action) {
                        return Container(
                          height: 150.0,
                          width: 100.0,
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
                          valueID: valueID,
                          vdo: vdo,
                          sesNum: int.parse('${mypost['scout']}'),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ));
  }
}
