import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mediahub/models/searchMoviemodel.dart';
import 'package:mediahub/screens/homepages/homescreens/movie/movieDetail.dart';

Widget buildMovieResult(BuildContext context, DocumentSnapshot document) {
  final srch = SearchMovieData.fromSnapshot(document);
  return new Padding(
      padding: EdgeInsets.only(left: 8, right: 8, top: 8),
      child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MovieDetail(srch.image, srch.title,
                    srch.detail, srch.documentId, srch.video)));
          },
          child: Container(
              color: Colors.white12,
              height: 170,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      height: 150,
                      width: 100,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(srch.image),
                              fit: BoxFit.cover)),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            srch.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey[800]),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    'Detail : ' + srch.detail,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10)
                ],
              ))));
}
