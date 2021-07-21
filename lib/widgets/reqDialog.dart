import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ReqDialog extends StatefulWidget {
  @override
  _ReqDialogState createState() => _ReqDialogState();
}

class _ReqDialogState extends State<ReqDialog> {
  String opvalue = 'Choose category';
  TextEditingController name = TextEditingController();
  TextEditingController quality = TextEditingController();
  String uid = FirebaseAuth.instance.currentUser.uid;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: DropdownButton(
        hint: Text(opvalue),
        onChanged: (value) {
          setState(() {
            opvalue = value;
          });
        },
        items: [
          DropdownMenuItem(
            child: Text('Movie'),
            value: 'Movie',
          ),
          DropdownMenuItem(
            child: Text('Series'),
            value: 'Series',
          ),
        ],
      ),
      content: Container(
        height: (opvalue != 'Movie') ? 100 : 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: name,
              decoration: InputDecoration(
                  hintText: 'Movie/Series name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            SizedBox(height: 10),
            Visibility(
              visible: (opvalue == 'Movie'),
              child: TextField(
                controller: quality,
                decoration: InputDecoration(
                    helperText: 'Example: 720p/480p',
                    hintText: 'Enter video quality',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text('ADD'),
          onPressed: () async {
            if (opvalue == 'Choose category') {
              Fluttertoast.showToast(
                  msg: 'Please choose category...',
                  toastLength: Toast.LENGTH_LONG,
                  backgroundColor: Colors.teal,
                  gravity: ToastGravity.CENTER,
                  textColor: Colors.white);
            } else {
              if (name.text.trim() != '') {
                await FirebaseFirestore.instance.collection('request').add({
                  'uid': uid,
                  'title': name.text.trim(),
                  'qty': (quality.text.trim() != '')
                      ? quality.text.trim()
                      : '720p',
                  'status': 'pending',
                  'cat': opvalue,
                  'dot': DateTime.now().millisecondsSinceEpoch
                });
                Fluttertoast.showToast(
                    msg: 'Requested',
                    toastLength: Toast.LENGTH_LONG,
                    backgroundColor: Colors.teal,
                    gravity: ToastGravity.CENTER,
                    textColor: Colors.white);
                Navigator.pop(context);
              } else {
                Fluttertoast.showToast(
                    msg: 'Please write something...',
                    toastLength: Toast.LENGTH_LONG,
                    backgroundColor: Colors.teal,
                    gravity: ToastGravity.CENTER,
                    textColor: Colors.white);
              }
            }
          },
        ),
        TextButton(
          child: Text('CANCEL'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
