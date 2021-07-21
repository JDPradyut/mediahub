import 'package:flutter/material.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:mediahub/players/offPlayer.dart';
import 'dart:io';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:line_icons/line_icons.dart';

class OfflineScreen extends StatefulWidget {
  @override
  _OfflineScreenState createState() => _OfflineScreenState();
}

class _OfflineScreenState extends State<OfflineScreen> {
  var files;
  void getFiles() async {
    List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
    var root = storageInfo[0].appFilesDir;
    var fm = FileManager(
      root: Directory(root),
    );
    files = await fm.filesTree(extensions: ["mkv"]);
    setState(() {});
  }

  @override
  void initState() {
    getFiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Downloads'),
        backgroundColor: Colors.grey[850],
      ),
      body: files == null
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : files.length == 0
              ? Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_download,
                          color: Colors.teal,
                          size: 80,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'You have not Downloaded anything yet',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    print(files.length.toString());
                    String vdo = files[index].path;
                    var dlt = File(vdo);
                    String title = files[index].path.split('/').last;
                    String tit = title.substring(0, title.indexOf('.'));
                    return Padding(
                        padding: EdgeInsets.only(top: 10, left: 8, right: 8),
                        child: Card(
                          child: ListTile(
                            trailing: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        backgroundColor: Colors.grey[850],
                                        child: Container(
                                          height: 120,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                  top: 10,
                                                  left: 10,
                                                  child: Text(
                                                    'Do you want to Delete this file ?',
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 19,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )),
                                              Positioned(
                                                bottom: 10,
                                                right: 10,
                                                child: Row(
                                                  children: [
                                                    TextButton(
                                                      child: Text('DELETE'),
                                                      onPressed: () async {
                                                        await dlt
                                                            .delete()
                                                            .whenComplete(() {
                                                          setState(() {
                                                            getFiles();
                                                          });
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text('CANCEL'),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                            ),
                            tileColor: Colors.grey[900],
                            title: Text(
                              tit,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70),
                            ),
                            leading: Icon(
                              LineIcons.youtube,
                              size: 50,
                              color: Colors.teal,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OffPlayer(
                                          tit: tit,
                                          vdo: vdo,
                                        )),
                              );
                            },
                          ),
                        ));
                  },
                ),
    );
  }
}
