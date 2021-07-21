import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Preview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Previews'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('preview').snapshots(),
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
                                EditPreview(valueID: valueID)));
                  });
            },
          );
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class EditPreview extends StatelessWidget {
  String valueID;
  EditPreview({this.valueID});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Preview'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('preview')
            .doc(valueID)
            .snapshots(),
        builder: (context, snapshot) {
          var mdoc = snapshot.data;
          TextEditingController tcont =
              TextEditingController(text: mdoc['title']);
          TextEditingController icont =
              TextEditingController(text: mdoc['image']);
          TextEditingController scont =
              TextEditingController(text: mdoc['svdo']);
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
                controller: scont,
                decoration: InputDecoration(labelText: 'Short Video'),
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
                          .collection('preview')
                          .doc(valueID)
                          .set({
                        'title': tcont.text,
                        'video': vcont.text,
                        'image': icont.text,
                        'svdo': scont.text
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
