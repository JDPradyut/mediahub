import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Series extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('TV Series'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddSeries()));
              },
            )
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('newser')
              .orderBy("title", descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot myPost = snapshot.data.docs[index];
                String valueID = myPost.id;
                return ListTile(
                    title: Text('${myPost['title']}'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditSeries(valueID: valueID)));
                    });
              },
            );
          },
        ));
  }
}

// ignore: must_be_immutable
class EditSeries extends StatelessWidget {
  String valueID;
  EditSeries({this.valueID});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Series'),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('newser')
                .doc(valueID)
                .snapshots(),
            builder: (context, snapshot) {
              var myPost = snapshot.data;
              TextEditingController tcont =
                  TextEditingController(text: myPost['title']);
              TextEditingController dtcont =
                  TextEditingController(text: myPost['dot'].toString());
              TextEditingController ocont =
                  TextEditingController(text: myPost['ocat']);
              TextEditingController scont =
                  TextEditingController(text: myPost['scout'].toString());
              TextEditingController dcont =
                  TextEditingController(text: myPost['detail']);
              TextEditingController icont =
                  TextEditingController(text: myPost['image']);
              TextEditingController ccont =
                  TextEditingController(text: myPost['category']);
              TextEditingController vcont =
                  TextEditingController(text: myPost['video']);
              return ListView(
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Title'),
                    controller: tcont,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Image'),
                    controller: icont,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Detail'),
                    controller: dcont,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'DOT'),
                    keyboardType: TextInputType.number,
                    controller: dtcont,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Category'),
                    controller: ccont,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Other Category'),
                    controller: ocont,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Number of Seasons'),
                    controller: scont,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Video'),
                    controller: vcont,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        child: Text('Edit'),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('newser')
                              .doc(valueID)
                              .set({
                            'title': tcont.text,
                            'video': vcont.text,
                            'image': icont.text,
                            'detail': dcont.text,
                            'category': ccont.text,
                            'dot': int.parse(dtcont.text),
                            'scout': int.parse(scont.text),
                            'ocat': ocont.text
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
                      SizedBox(
                        width: 30,
                      ),
                      ElevatedButton(
                        child: Text('EpiSodes'),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Episodes(valueID: valueID)));
                        },
                      )
                    ],
                  )
                ],
              );
            }));
  }
}

// ignore: must_be_immutable
class Episodes extends StatelessWidget {
  String valueID;
  Episodes({this.valueID});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Episodes'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddEpisode(valueID: valueID)));
              },
            )
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('newser')
              .doc(valueID)
              .collection('episodes')
              .orderBy("title", descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot myPost = snapshot.data.docs[index];
                String epiID = myPost.id;
                return ListTile(
                    title: Text('${myPost['title']}'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditEpisode(valueID: valueID, epiID: epiID)));
                    });
              },
            );
          },
        ));
  }
}

// ignore: must_be_immutable
class EditEpisode extends StatelessWidget {
  String valueID, epiID;
  EditEpisode({this.valueID, this.epiID});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Episodes'),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('newser')
                .doc(valueID)
                .collection('episodes')
                .doc(epiID)
                .snapshots(),
            builder: (context, snapshot) {
              var myPost = snapshot.data;
              TextEditingController tcont =
                  TextEditingController(text: myPost['title']);
              TextEditingController icont =
                  TextEditingController(text: myPost['image']);
              TextEditingController vcont =
                  TextEditingController(text: myPost['video']);
              return ListView(
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Title'),
                    controller: tcont,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Image'),
                    controller: icont,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Video'),
                    controller: vcont,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        child: Text('Edit'),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('newser')
                              .doc(valueID)
                              .collection('episodes')
                              .doc(epiID)
                              .set({
                            'title': tcont.text,
                            'video': vcont.text,
                            'image': icont.text,
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

// ignore: must_be_immutable
class AddEpisode extends StatelessWidget {
  String valueID;
  AddEpisode({this.valueID});
  @override
  Widget build(BuildContext context) {
    TextEditingController icont = TextEditingController();
    TextEditingController tcont = TextEditingController();
    TextEditingController vcont = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Episode'),
      ),
      body: ListView(
        children: [
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
                  await FirebaseFirestore.instance
                      .collection('newser')
                      .doc(valueID)
                      .collection('episodes')
                      .add({
                    'image': icont.text,
                    'title': tcont.text,
                    'video': vcont.text
                  });
                  Fluttertoast.showToast(
                      msg: 'Added to EpisodeList',
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

class AddSeries extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController ccont = TextEditingController();
    TextEditingController dcont = TextEditingController();
    TextEditingController dtcont = TextEditingController();
    TextEditingController icont = TextEditingController();
    TextEditingController tcont = TextEditingController();
    TextEditingController vcont = TextEditingController();
    TextEditingController ocont = TextEditingController();
    TextEditingController scont = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Series'),
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
            controller: scont,
            decoration: InputDecoration(labelText: 'Number of Seasons'),
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
                  await FirebaseFirestore.instance.collection('newser').add({
                    'category': ccont.text,
                    'detail': dcont.text,
                    'dot': int.parse(dtcont.text),
                    'image': icont.text,
                    'title': tcont.text,
                    'scout': int.parse(scont.text),
                    'ocat': ocont.text,
                    'video': vcont.text
                  });
                  Fluttertoast.showToast(
                      msg: 'Added to SeriesList',
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
