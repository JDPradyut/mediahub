import 'package:cloud_firestore/cloud_firestore.dart';

class SearchMovieData {
  String title;
  String documentId;
  String image;
  String detail;
  String video;

  SearchMovieData(this.title, this.image, this.video, this.detail);

  // formatting for upload to Firbase when creating the trip
  Map<String, dynamic> toJson() =>
      {'title': title, 'image': image, 'video': video, 'detail': detail};

  // creating a Trip object from a firebase snapshot
  SearchMovieData.fromSnapshot(DocumentSnapshot snapshot)
      : title = snapshot['title'],
        image = snapshot['image'],
        video = snapshot['video'],
        detail = snapshot['detail'],
        documentId = snapshot.id;
}
