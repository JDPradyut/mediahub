import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Request extends StatefulWidget {
  @override
  _RequestState createState() => _RequestState();
}

class _RequestState extends State<Request> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('request')
            .orderBy('dot', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          if (snapshot.data.docs.isEmpty)
            return Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.movie_filter,
                      color: Colors.teal,
                      size: 80,
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'No Request',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              var mypost = snapshot.data.docs[index];
              return Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: ListTile(
                  tileColor: Colors.grey[200],
                  leading: Text(
                    '${mypost['status']}'.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ('${mypost['status']}' == 'pending')
                          ? Colors.amber
                          : ('${mypost['status']}' == 'done')
                              ? Colors.green
                              : Colors.red,
                    ),
                  ),
                  title: Text(
                    '[${mypost['qty']}] ${mypost['title']}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${mypost['cat']}',
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Chooser(
                          valueID: mypost.id,
                          title: '${mypost['title']}',
                          qty: '${mypost['qty']}',
                          cat: '${mypost['cat']}',
                          uid: '${mypost['uid']}',
                        );
                      },
                    );
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

class Chooser extends StatefulWidget {
  final String valueID;
  final String title;
  final String qty;
  final String cat;
  final String uid;
  const Chooser(
      {Key key,
      @required this.valueID,
      this.title,
      this.qty,
      this.cat,
      this.uid})
      : super(key: key);

  @override
  _ChooserState createState() =>
      _ChooserState(this.valueID, this.title, this.qty, this.cat, this.uid);
}

class _ChooserState extends State<Chooser> {
  String valueID;
  String title;
  String qty;
  String cat;
  String uid;
  _ChooserState(this.valueID, this.title, this.qty, this.cat, this.uid);
  String opvalue = 'Choose Status';
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 100,
        child: Center(
          child: DropdownButton(
            hint: Text(opvalue.toUpperCase()),
            onChanged: (value) async {
              setState(() {
                opvalue = value;
              });
              await FirebaseFirestore.instance
                  .collection('request')
                  .doc(valueID)
                  .set({
                'title': title,
                'qty': qty,
                'status': opvalue,
                'cat': cat,
                'uid': uid,
                'dot': DateTime.now().millisecondsSinceEpoch
              }).whenComplete(
                () => Fluttertoast.showToast(
                    msg: 'UPDATED',
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.teal,
                    textColor: Colors.white,
                    timeInSecForIosWeb: 1,
                    fontSize: 16),
              );

              Navigator.pop(context);
            },
            items: [
              DropdownMenuItem(
                child: Text('Pending'),
                value: 'pending',
              ),
              DropdownMenuItem(
                child: Text('Rejected'),
                value: 'reject',
              ),
              DropdownMenuItem(
                child: Text('Done'),
                value: 'done',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
