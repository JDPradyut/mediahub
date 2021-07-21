import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mediahub/services/admob_service.dart';
import 'package:mediahub/widgets/movwidgets/catmov.dart';
import 'package:mediahub/widgets/serwidgets/catser.dart';

// ignore: must_be_immutable
class CatViewer extends StatelessWidget {
  String header;
  String cat;
  String scat;
  CatViewer(this.header, this.cat, this.scat);
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      color: Colors.black,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      width: screenSize.width,
                      height: ((screenSize.height / 2)) - 10,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(100),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      child: Container(
                        height: ((screenSize.height / 2)) - 20,
                        width: screenSize.width - 10,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(110),
                          ),
                          color: Colors.black,
                        ),
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
                              header,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Movies & TV Series',
                              style: TextStyle(
                                color: Colors.teal,
                                //  fontSize: 10,
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
            expandedHeight: screenSize.height / 2,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Movies',
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
              CatMov(where: cat, isEqual: scat),
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
                      'TV Series',
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
              CatSer(where: cat, isEqual: scat),
            ]),
          ),
        ],
      ),
    );
  }
}
