import 'package:cloud_firestore/cloud_firestore.dart';

class SearchSeriesData {
  String title;
  String documentId;
  String image;
  String detail;
  String video;
  int scout;

  SearchSeriesData(this.title, this.image, this.video, this.detail, this.scout);

  // formatting for upload to Firbase when creating the trip
  Map<String, dynamic> toJson() => {
        'title': title,
        'image': image,
        'video': video,
        'detail': detail,
        'scout': scout
      };

  // creating a Trip object from a firebase snapshot
  SearchSeriesData.fromSnapshot(DocumentSnapshot snapshot)
      : title = snapshot['title'],
        image = snapshot['image'],
        video = snapshot['video'],
        detail = snapshot['detail'],
        scout = snapshot['scout'],
        documentId = snapshot.id;
}
