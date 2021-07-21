import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Movie extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddMovie()));
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('newmov')
            .orderBy("title", descending: false)
            .snapshots(),
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
                            builder: (context) => EditMovie(valueID: valueID)));
                  });
            },
          );
        },
      ),
    );
  }
}

class AddMovie extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController ccont = TextEditingController();
    TextEditingController dcont = TextEditingController();
    TextEditingController dtcont = TextEditingController();
    TextEditingController icont = TextEditingController();
    TextEditingController tcont = TextEditingController();
    TextEditingController vcont = TextEditingController();
    TextEditingController ocont = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Movie'),
      ),
      body: ListView(
        children: [
          TextField(
            controller: ccont,
            decoration: InputDecoration(labelText: 'Category'),
          ),
          TextField(
            controller: ocont,
            decoration: InputDecoration(labelText: 'Other Category'),
          ),
          TextField(
            controller: dcont,
            decoration: InputDecoration(labelText: 'Detail'),
          ),
          TextField(
            controller: dtcont,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'DOT'),
          ),
          TextField(
            controller: icont,
            decoration: InputDecoration(labelText: 'Image'),
          ),
          TextField(
            controller: tcont,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: vcont,
            decoration: InputDecoration(labelText: 'Video'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text('Add'),
                onPressed: () async {
                  await FirebaseFirestore.instance.collection('newmov').add({
                    'category': ccont.text,
                    'detail': dcont.text,
                    'dot': int.parse(dtcont.text),
                    'image': icont.text,
                    'title': tcont.text,
                    'video': vcont.text,
                    'ocat': ocont.text
                  });
                  Fluttertoast.showToast(
                      msg: 'Added to MovieList',
                      toastLength: Toast.LENGTH_LONG,
                      backgroundColor: Colors.teal,
                      gravity: ToastGravity.CENTER,
                      textColor: Colors.white);
                  Navigator.pop(context);
                },
              )
            ],
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class EditMovie extends StatelessWidget {
  String valueID;
  EditMovie({this.valueID});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Movies'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('newmov')
            .doc(valueID)
            .snapshots(),
        builder: (context, snapshot) {
          var mdoc = snapshot.data;
          TextEditingController tcont =
              TextEditingController(text: mdoc['title']);
          TextEditingController icont =
              TextEditingController(text: mdoc['image']);
          TextEditingController dtcont =
              TextEditingController(text: mdoc['dot'].toString());
          TextEditingController vcont =
              TextEditingController(text: mdoc['video']);
          TextEditingController ccont =
              TextEditingController(text: mdoc['category']);
          TextEditingController ocont =
              TextEditingController(text: mdoc['ocat'].toString());
          TextEditingController dcont =
              TextEditingController(text: mdoc['detail']);
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
                controller: ccont,
                decoration: InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: ocont,
                decoration: InputDecoration(labelText: 'Other Category'),
              ),
              TextField(
                controller: dcont,
                decoration: InputDecoration(labelText: 'Detail'),
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: dtcont,
                decoration: InputDecoration(labelText: 'DOT'),
              ),
              TextField(
                controller: vcont,
                decoration: InputDecoration(labelText: 'Video'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Text('Edit'),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('newmov')
                          .doc(valueID)
                          .set({
                        'title': tcont.text,
                        'video': vcont.text,
                        'image': icont.text,
                        'detail': dcont.text,
                        'category': ccont.text,
                        'ocat': ocont.text,
                        'dot': int.parse(dtcont.text)
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
                  ),
                  ElevatedButton(
                    child: Text('Quality'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Quality(valueID: valueID)));
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

// ignore: must_be_immutable
class Quality extends StatelessWidget {
  String valueID;
  Quality({this.valueID});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Quality'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddQuality(valueID: valueID)));
              },
            )
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('newmov')
              .doc(valueID)
              .collection('quality')
              .orderBy("title", descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot myPost = snapshot.data.docs[index];
                String epiID = myPost.id;
                if (!snapshot.hasData)
                  return Container(
                      child: Center(child: CircularProgressIndicator()));
                return ListTile(
                    title: Text('${myPost['title']}'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditQuality(valueID: valueID, epiID: epiID)));
                    });
              },
            );
          },
        ));
  }
}

// ignore: must_be_immutable
class AddQuality extends StatelessWidget {
  String valueID;
  AddQuality({this.valueID});
  @override
  Widget build(BuildContext context) {
    TextEditingController icont = TextEditingController();
    TextEditingController tcont = TextEditingController();
    TextEditingController vcont = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Quality'),
      ),
      body: ListView(
        children: [
          TextField(
            controller: icont,
            decoration: InputDecoration(labelText: 'File Size'),
          ),
          TextField(
            controller: tcont,
            decoration: InputDecoration(labelText: 'Quality Name'),
          ),
          TextField(
            controller: vcont,
            decoration: InputDecoration(labelText: 'Video Link'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text('Add'),
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('newmov')
                      .doc(valueID)
                      .collection('quality')
                      .add({
                    'size': icont.text,
                    'title': tcont.text,
                    'video': vcont.text
                  });
                  Fluttertoast.showToast(
                      msg: 'Added',
                      toastLength: Toast.LENGTH_LONG,
                      backgroundColor: Colors.teal,
                      gravity: ToastGravity.CENTER,
                      textColor: Colors.white);
                  Navigator.pop(context);
                },
              )
            ],
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class EditQuality extends StatelessWidget {
  String valueID, epiID;
  EditQuality({this.valueID, this.epiID});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Quality'),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('newmov')
                .doc(valueID)
                .collection('quality')
                .doc(epiID)
                .snapshots(),
            builder: (context, snapshot) {
              var myPost = snapshot.data;
              TextEditingController tcont =
                  TextEditingController(text: myPost['title']);
              TextEditingController icont =
                  TextEditingController(text: myPost['size']);
              TextEditingController vcont =
                  TextEditingController(text: myPost['video']);
              return ListView(
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Quality Name'),
                    controller: tcont,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'File Size'),
                    controller: icont,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Video Link'),
                    controller: vcont,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        child: Text('Edit'),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('newmov')
                              .doc(valueID)
                              .collection('quality')
                              .doc(epiID)
                              .set({
                            'title': tcont.text,
                            'video': vcont.text,
                            'size': icont.text,
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
                      ),
                    ],
                  )
                ],
              );
            }));
  }
}
