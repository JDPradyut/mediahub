import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:isolate';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mediahub/services/taskInfo.dart';

class DownWidget extends StatefulWidget {
  DownWidget({Key key, this.header, this.image, this.detail, this.video})
      : super(key: key);
  final String header;
  final String image;
  final String detail;
  final String video;
  @override
  _DownloaderWidgetState createState() => _DownloaderWidgetState();
}

class _DownloaderWidgetState extends State<DownWidget> {
  ReceivePort _port = ReceivePort();
  List<TaskInfo> _tasks;
  String newDownload;
  int downloadProgress = 0;
  bool isDownloading = false;
  String downloadFile = 'Unknown';

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
          downloadFile = 'Now Downloading : ' + widget.detail;
        });
      }
      if (status == DownloadTaskStatus.failed) {
        setState(() {
          isDownloading = false;
          Fluttertoast.showToast(
              msg: 'DownLoad Failed',
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
      elevation: 0,
      backgroundColor: Colors.grey[850],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        height: 280,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.grey,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                height: 150,
                width: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(widget.image), fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 127,
              right: 50,
              child: Container(
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.header,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Quality : 720p',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Visibility(
                      visible: isDownloading,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            downloadFile,
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          LinearProgressIndicator(
                            value: downloadProgress / (100),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: 50,
                child: SizedBox(
                  width: (MediaQuery.of(context).size.width) - 100,
                  child: Center(
                    child: Text(
                      'NOTE: This Download manager is Best for Single File Download.However you can Download multiple files but you have to cancel it accordingly or longpress cancel button to cancel all files.',
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                      maxLines: 4,
                    ),
                  ),
                )),
            Positioned(
              right: 10,
              bottom: 10,
              child: Row(
                children: [
                  Visibility(
                    visible: !isDownloading,
                    child: TextButton(
                        child: Text('DOWNLOAD'),
                        onPressed: () async {
                          final status = await Permission.storage.request();
                          if (status.isGranted) {
                            final extDir = await getExternalStorageDirectory();
                            final taskID = await FlutterDownloader.enqueue(
                                url: widget.video,
                                savedDir: extDir.path,
                                showNotification: true,
                                fileName: widget.detail + ".mkv",
                                openFileFromNotification: false);
                            setState(() {
                              newDownload = taskID;
                            });
                            Fluttertoast.showToast(
                                msg: 'DownLoad Started',
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
                        }),
                  ),
                  TextButton(
                    child: Text('CANCEL'),
                    onPressed: (newDownload == null)
                        ? null
                        : () {
                            _cancelDownload(newDownload);
                            Navigator.pop(context);
                            Fluttertoast.showToast(
                                msg: 'DownLoad Canceled',
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.teal,
                                textColor: Colors.white,
                                timeInSecForIosWeb: 1,
                                fontSize: 16);
                          },
                    onLongPress: () {
                      FlutterDownloader.cancelAll();
                      Fluttertoast.showToast(
                          msg: 'All Canceled',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.teal,
                          textColor: Colors.white,
                          timeInSecForIosWeb: 1,
                          fontSize: 16);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
