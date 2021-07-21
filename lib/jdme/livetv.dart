import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LiveTvManager extends StatefulWidget {
  @override
  _LiveTvManagerState createState() => _LiveTvManagerState();
}

class _LiveTvManagerState extends State<LiveTvManager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Live TV Manager'),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 100 / 100),
            children: [
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.connected_tv),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => NPlay()));
                    },
                  ),
                  Text('Now Playing')
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.tv),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Channels()));
                    },
                  ),
                  Text('TV Channels')
                ],
              ),
            ],
          ),
        ));
  }
}

class Channels extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Channels'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddChannel()));
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('livetv')
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
                            builder: (context) =>
                                EditChannel(valueID: valueID)));
                  });
            },
          );
        },
      ),
    );
  }
}

class AddChannel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController ccont = TextEditingController();
    TextEditingController icont = TextEditingController();
    TextEditingController tcont = TextEditingController();
    TextEditingController vcont = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Channel'),
      ),
      body: ListView(
        children: [
          TextField(
            controller: ccont,
            decoration: InputDecoration(labelText: 'Category'),
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
                  await FirebaseFirestore.instance.collection('livetv').add({
                    'category': ccont.text,
                    'image': icont.text,
                    'title': tcont.text,
                    'video': vcont.text,
                  });
                  Fluttertoast.showToast(
                      msg: 'Added to ChannelList',
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
class EditChannel extends StatelessWidget {
  String valueID;
  EditChannel({this.valueID});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Channel'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('livetv')
            .doc(valueID)
            .snapshots(),
        builder: (context, snapshot) {
          var mdoc = snapshot.data;
          TextEditingController tcont =
              TextEditingController(text: mdoc['title']);
          TextEditingController icont =
              TextEditingController(text: mdoc['image']);
          TextEditingController vcont =
              TextEditingController(text: mdoc['video']);
          TextEditingController ccont =
              TextEditingController(text: mdoc['category']);
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
                          .collection('livetv')
                          .doc(valueID)
                          .set({
                        'title': tcont.text,
                        'video': vcont.text,
                        'image': icont.text,
                        'category': ccont.text,
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
        },
      ),
    );
  }
}

class NPlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Now Playing Show'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddNPlay()));
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('nplay')
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
                          builder: (context) => EditNPlay(valueID: valueID)));
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .runTransaction((Transaction transaction) async {
                      // ignore: await_only_futures
                      await transaction.delete(mypost.reference);
                    });
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AddNPlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController dtcont = TextEditingController();
    TextEditingController icont = TextEditingController();
    TextEditingController tcont = TextEditingController();
    TextEditingController vcont = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Now Playing'),
      ),
      body: ListView(
        children: [
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
                  await FirebaseFirestore.instance.collection('nplay').add({
                    'dot': int.parse(dtcont.text),
                    'image': icont.text,
                    'title': tcont.text,
                    'video': vcont.text,
                  });
                  Fluttertoast.showToast(
                      msg: 'Added to NPList',
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
class EditNPlay extends StatelessWidget {
  String valueID;
  EditNPlay({this.valueID});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit NPlay'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('nplay')
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
                          .collection('nplay')
                          .doc(valueID)
                          .set({
                        'title': tcont.text,
                        'video': vcont.text,
                        'image': icont.text,
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
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
