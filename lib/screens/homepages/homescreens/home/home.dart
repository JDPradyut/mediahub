import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mediahub/widgets/serwidgets/allSeries.dart';
import 'package:mediahub/widgets/movwidgets/allmv.dart';
import 'package:mediahub/widgets/catview.dart';
import 'package:mediahub/widgets/preview.dart';
import 'package:mediahub/widgets/topten.dart';
import 'package:mediahub/widgets/movwidgets/trdMov.dart';
import 'package:mediahub/widgets/serwidgets/trdSer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Container(
              height: 35,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: OpenContainer(
                          closedColor: Colors.transparent,
                          openColor: Colors.transparent,
                          closedBuilder: (context, action) {
                            return Container(
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.teal, Colors.teal.shade700],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Anime',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                          openBuilder: (context, action) {
                            return CatViewer('Anime', 'ocat', 'anime');
                          })),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: OpenContainer(
                        closedColor: Colors.transparent,
                        openColor: Colors.transparent,
                        closedBuilder: (context, action) {
                          return Container(
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Colors.teal, Colors.teal.shade700],
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Bollywood',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                        openBuilder: (context, action) {
                          return CatViewer(
                              'Bollywood', 'category', 'bollywood');
                        }),
                  ),
                  Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: OpenContainer(
                          closedColor: Colors.transparent,
                          openColor: Colors.transparent,
                          closedBuilder: (context, action) {
                            return Container(
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.teal, Colors.teal.shade700],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Bengali',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                          openBuilder: (context, action) {
                            return CatViewer('Bengali', 'category', 'kolkata');
                          })),
                  Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: OpenContainer(
                          closedColor: Colors.transparent,
                          openColor: Colors.transparent,
                          closedBuilder: (context, action) {
                            return Container(
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.teal, Colors.teal.shade700],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Hollywood',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                          openBuilder: (context, action) {
                            return CatViewer(
                                'Hollywood', 'category', 'hollywood');
                          })),
                  Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: OpenContainer(
                          closedColor: Colors.transparent,
                          openColor: Colors.transparent,
                          closedBuilder: (context, action) {
                            return Container(
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.teal, Colors.teal.shade700],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Korean',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                          openBuilder: (context, action) {
                            return CatViewer('Korean', 'ocat', 'korean');
                          })),
                  Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: OpenContainer(
                          closedColor: Colors.transparent,
                          openColor: Colors.transparent,
                          closedBuilder: (context, action) {
                            return Container(
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.teal, Colors.teal.shade700],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'S. Indian',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                          openBuilder: (context, action) {
                            return CatViewer('South Indian', 'ocat', 'south');
                          })),
                ],
              ),
            ),
          ),
          Expanded(
              child: MediaQuery.removeViewInsets(
            context: context,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, bottom: 8, top: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Previews',
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
                PreviewWidget(),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recently Added Movies',
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
                AllMoviesWidget(),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recently Added TV Series',
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
                AllSeriesWidget(),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Top 10 in MediaHub',
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
                TopTenWidget(),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Trending Movies',
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
                TrdMoviesWidget(),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Trending TV Shows',
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
                TrdSeriesWidget()
              ],
            ),
          )),
        ],
      ),
    );
  }
}
