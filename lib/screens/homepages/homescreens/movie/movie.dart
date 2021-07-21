import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:mediahub/screens/homepages/homescreens/movie/cate/bmov.dart';
import 'package:mediahub/screens/homepages/homescreens/movie/cate/hmov.dart';
import 'package:mediahub/screens/homepages/homescreens/movie/cate/kmov.dart';
import 'package:mediahub/screens/homepages/homescreens/movie/cate/omov.dart';

class Movie extends StatefulWidget {
  @override
  _MovieState createState() => _MovieState();
}

class _MovieState extends State<Movie> {
  @override
  Widget build(BuildContext context) {
    var screenH = MediaQuery.of(context).size.height;
    var screenW = MediaQuery.of(context).size.width;
    return Container(
        child: Center(
            child: SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Container(
                  height: screenH / 2 - 120,
                  width: screenW / 2,
                  child: OpenContainer(
                      openColor: Colors.transparent,
                      closedColor: Colors.transparent,
                      closedBuilder: (context, action) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              child: Container(
                                height: screenH / 2 - 120,
                                width: screenW / 2 - 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                  gradient: LinearGradient(
                                    colors: [Colors.red, Colors.red.shade300],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                              right: 5,
                            ),
                            Positioned(
                              child: Container(
                                height: screenH / 2 - 120,
                                width: screenW / 2 - 40,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('images/hmov.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              left: 5,
                            ),
                            Positioned(
                              bottom: 10,
                              right: 5,
                              child: Image.asset('images/hm.png',
                                  width: (screenW / 2) - 30),
                            ),
                          ],
                        );
                      },
                      openBuilder: (context, action) {
                        return HolMov();
                      })),
              SizedBox(height: 20),
              Container(
                  height: screenH / 2 - 80,
                  width: screenW / 2,
                  child: OpenContainer(
                    openColor: Colors.transparent,
                    closedColor: Colors.transparent,
                    openBuilder: (context, action) {
                      return KolMov();
                    },
                    closedBuilder: (context, action) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            child: Container(
                              height: screenH / 2 - 80,
                              width: screenW / 2 - 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                  topLeft: Radius.circular(10),
                                ),
                                gradient: LinearGradient(
                                  colors: [Colors.cyan, Colors.cyan.shade300],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                            right: 7,
                          ),
                          Positioned(
                            child: Container(
                              height: screenH / 2 - 80,
                              width: screenW / 2,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('images/kmov.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            right: 7,
                          ),
                          Positioned(
                            bottom: 10,
                            right: 7,
                            child: Image.asset('images/bm.png',
                                width: (screenW / 2) - 30),
                          ),
                        ],
                      );
                    },
                  )),
            ],
          ),
          Column(
            children: [
              Container(
                  height: screenH / 2 - 80,
                  width: screenW / 2,
                  child: OpenContainer(
                    closedBuilder: (context, action) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            child: Container(
                              height: screenH / 2 - 80,
                              width: screenW / 2 - 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(20),
                                ),
                                gradient: LinearGradient(
                                  colors: [Colors.amber, Colors.amber.shade300],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                            left: 7,
                          ),
                          Positioned(
                            child: Container(
                              height: screenH / 2 - 80,
                              width: screenW / 2,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('images/bmov.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            right: 0,
                          ),
                          Positioned(
                            bottom: 10,
                            left: 7,
                            child: Image.asset('images/bom.png',
                                width: (screenW / 2) - 30),
                          ),
                        ],
                      );
                    },
                    openBuilder: (context, action) {
                      return BolMov();
                    },
                    openColor: Colors.transparent,
                    closedColor: Colors.transparent,
                  )),
              SizedBox(height: 20),
              Container(
                height: screenH / 2 - 120,
                width: screenW / 2,
                child: OpenContainer(
                  openBuilder: (context, action) {
                    return OthMov();
                  },
                  openColor: Colors.transparent,
                  closedColor: Colors.transparent,
                  closedBuilder: (context, action) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          child: Container(
                            height: screenH / 2 - 120,
                            width: screenW / 2 - 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(20),
                              ),
                              gradient: LinearGradient(
                                colors: [Colors.teal, Colors.teal.shade300],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                          left: 15,
                        ),
                        Positioned(
                          child: Container(
                            height: screenH / 2 - 120,
                            width: screenW / 2 - 55,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/omov.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          left: 15,
                        ),
                        Positioned(
                          bottom: 10,
                          left: 15,
                          child: Image.asset('images/om.png',
                              width: (screenW / 2) - 30),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    )));
  }
}
