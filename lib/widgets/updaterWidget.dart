import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mediahub/services/taskInfo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class UpdaterWidget extends StatefulWidget {
  final linkUrl;
  final title;
  final status;
  final changelog;
  final latest;
  UpdaterWidget(
      {this.linkUrl, this.changelog, this.status, this.title, this.latest});
  @override
  _UpdaterWidgetState createState() => _UpdaterWidgetState();
}

class _UpdaterWidgetState extends State<UpdaterWidget> {
  ReceivePort _port = ReceivePort();
  List<TaskInfo> _tasks;
  String newDownload;
  String isComplete;
  int downloadProgress = 0;
  bool isDownloading = false;
  bool open = false;
  String downloadFile = 'New Update Available';

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unBindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {
        downloadProgress = data[2];
        newDownload = data[0];
      });
      if (status == DownloadTaskStatus.running) {
        setState(() {
          isDownloading = true;
          downloadFile = 'Updating...';
        });
      }
      if (status == DownloadTaskStatus.complete) {
        setState(() {
          isComplete = newDownload;
          open = true;
        });
        Fluttertoast.showToast(
            msg: 'COMPLETED',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.teal,
            textColor: Colors.white,
            timeInSecForIosWeb: 1,
            fontSize: 16);
      }
      if (status == DownloadTaskStatus.failed) {
        setState(() {
          isDownloading = false;
          Fluttertoast.showToast(
              msg: 'Updating Failed',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.teal,
              textColor: Colors.white,
              timeInSecForIosWeb: 1,
              fontSize: 16);
        });
      }

      if (_tasks != null && _tasks.isNotEmpty) {
        final task = _tasks.firstWhere((task) => task.taskId == id);
        if (task != null) {
          setState(() {
            task.status = status;
            task.progress = progress;
          });
        }
      }
    });
  }

  void _unBindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  void _cancelDownload(String taskId) async {
    await FlutterDownloader.cancel(taskId: taskId);
  }

  @override
  void initState() {
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
    super.initState();
  }

  @override
  void dispose() {
    _unBindBackgroundIsolate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width - 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[850],
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                bottom: 5,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _cancelDownload(newDownload);
                  },
                  child: Container(
                    height: 30,
                    width: MediaQuery.of(context).size.width - 100,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: Text(
                        'CANCEL',
                        style: TextStyle(
                            color: Colors.teal, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !isDownloading,
                child: Positioned(
                  bottom: 40,
                  child: GestureDetector(
                    onTap: () async {
                      final status = await Permission.storage.request();
                      if (status.isGranted) {
                        final extDir = await getExternalStorageDirectory();
                        final taskID = await FlutterDownloader.enqueue(
                            url: widget.linkUrl,
                            savedDir: extDir.path,
                            showNotification: true,
                            fileName: widget.title + ".apk",
                            openFileFromNotification: true);
                        setState(() {
                          newDownload = taskID;
                        });
                        Fluttertoast.showToast(
                            msg: 'UPDATING',
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.teal,
                            textColor: Colors.white,
                            timeInSecForIosWeb: 1,
                            fontSize: 16);
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Please Give Required PerMission',
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.teal,
                            textColor: Colors.white,
                            timeInSecForIosWeb: 1,
                            fontSize: 16);
                      }
                    },
                    child: Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width - 100,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.teal),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.teal),
                      child: Center(
                        child: Text(
                          'UPDATE',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: open,
                child: Positioned(
                  bottom: 40,
                  child: GestureDetector(
                    onTap: () {
                      FlutterDownloader.open(taskId: isComplete);
                    },
                    child: Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width - 100,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.teal),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.teal),
                      child: Center(
                        child: Text(
                          'OPEN',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 80,
                child: Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width - 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              child: Image.asset('images/slogo.png'),
                              height: 60,
                              width: 60,
                            ),
                            Visibility(
                                visible: isDownloading,
                                child: Container(
                                  height: 70,
                                  width: 70,
                                  child: CircularProgressIndicator(
                                      backgroundColor: Colors.orange[100],
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.teal),
                                      value: downloadProgress / (100)),
                                ))
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width - 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'MediaHub',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 19),
                            ),
                            Text(
                              'Latest : ' + widget.latest,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 11),
                            ),
                            Text(
                              'Status : ' + widget.title,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 11),
                            ),
                            Text(
                              'Code Name : ' + widget.status,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 11),
                            ),
                            Text(
                              'Changelogs : ' + widget.changelog,
                              maxLines: 3,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 11),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
