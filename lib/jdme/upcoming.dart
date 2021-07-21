import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Upcoming extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upcoming'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('upmovs').snapshots(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot mypost = snapshot.data.docs[index];
              String valueID = mypost.id;
              return ListTile(
                  title: Text('${mypost['title']}'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditUPMovs(valueID: valueID)));
                  });
            },
          );
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class EditUPMovs extends StatelessWidget {
  String valueID;
  EditUPMovs({this.valueID});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Upcoming'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('upmovs')
            .doc(valueID)
            .snapshots(),
        builder: (context, snapshot) {
          var mdoc = snapshot.data;
          TextEditingController tcont =
              TextEditingController(text: mdoc['title']);
          TextEditingController icont =
              TextEditingController(text: mdoc['image']);
          TextEditingController dcont =
              TextEditingController(text: mdoc['detail']);
          TextEditingController vcont =
              TextEditingController(text: mdoc['video']);
          return ListView(
            children: [
              TextField(
                controller: tcont,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: icont,
                decoration: InputDecoration(labelText: 'Image'),
              ),
              TextField(
                controller: dcont,
                decoration: InputDecoration(labelText: 'Detail'),
              ),
              TextField(
                controller: vcont,
                decoration: InputDecoration(labelText: 'Video'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Text('Edit'),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('upmovs')
                          .doc(valueID)
                          .set({
                        'title': tcont.text,
                        'video': vcont.text,
                        'image': icont.text,
                        'detail': dcont.text
                      });

                      Fluttertoast.showToast(
                          msg: 'UPDATED',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.teal,
                          textColor: Colors.white,
                          timeInSecForIosWeb: 1,
                          fontSize: 16);
                    },
                  )
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
