import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:screen/screen.dart';
import 'package:sensors/sensors.dart';
import 'package:wakelock/wakelock.dart';

// ignore: must_be_immutable
class SeriesPlayer extends StatefulWidget {
  String tit;
  String vdo;
  String image;
  SeriesPlayer({this.tit, this.vdo, @required this.image});
  @override
  State<StatefulWidget> createState() {
    return _SeriesPlayerState(tit, vdo, image);
  }
}

class _SeriesPlayerState extends State<SeriesPlayer> {
  String tit;
  String vdo;
  String image;
  _SeriesPlayerState(this.tit, this.vdo, this.image);

  VlcPlayerController _controller;

  final double initSnapshotRightPosition = 10;
  final double initSnapshotBottomPosition = 10;

  double sliderValue = 0.0;
  double volumeValue = 50;
  String position = '';
  String duration = '';
  bool _isFit = false;
  List<StreamSubscription<dynamic>> _ss = <StreamSubscription<dynamic>>[];
  int numberOfCaptions = 0;
  int numberOfAudioTracks = 0;
  bool validPosition = false;

  List<double> playbackSpeeds = [0.5, 1.0, 2.0];
  int playbackSpeedIndex = 1;

  // ignore: unused_field
  bool _isON = false;
  double _brightness = 1.0;
  double _eB = 1.0;
  double x = 0;

  double videoH = 400;
  double videoW = 800;
  double videoAspect = 16 / 9;
  bool _isLoading = true;

  bool isVisible = true;
  bool isSpeed = false;
  bool isHwAcc = false;

  String hwAccSet = '(OFF)';
  var setHwAcc = HwAcc.DISABLED;

  double currentPlayerTime = 0.0;

  _initPlatformState() async {
    bool keptOn = await Screen.isKeptOn;
    double brightness = await Screen.brightness;
    setState(() {
      _isON = keptOn;
      _brightness = brightness;
      _eB = brightness;
    });
  }

  void listener() async {
    if (!mounted) return;
    //
    if (_controller.value.isInitialized) {
      var oPosition = _controller.value.position;
      var oDuration = _controller.value.duration;
      if (oPosition != null && oDuration != null) {
        if (oDuration.inHours == 0) {
          var strPosition = oPosition.toString().split('.')[0];
          var strDuration = oDuration.toString().split('.')[0];
          position =
              "${strPosition.split(':')[1]}:${strPosition.split(':')[2]}";
          duration =
              "${strDuration.split(':')[1]}:${strDuration.split(':')[2]}";
          setState(() {
            currentPlayerTime = _controller.value.position.inSeconds.toDouble();
          });
        } else {
          position = oPosition.toString().split('.')[0];
          duration = oDuration.toString().split('.')[0];
          setState(() {
            currentPlayerTime = _controller.value.position.inSeconds.toDouble();
          });
        }
        validPosition = oDuration.compareTo(oPosition) >= 0;
        sliderValue = validPosition ? oPosition.inSeconds.toDouble() : 0;
      }
      numberOfCaptions = _controller.value.spuTracksCount;
      numberOfAudioTracks = _controller.value.audioTracksCount;
      //
      setState(() {});
    }
  }

  void _onSliderPositionChanged(double progress) {
    setState(() {
      sliderValue = progress.floor().toDouble();
      currentPlayerTime = _controller.value.position.inSeconds.toDouble();
    });
    //convert to Milliseconds since VLC requires MS to set time
    _controller.setTime(sliderValue.toInt() * 1000);
  }

  void _getSubtitleTracks() async {
    if (!_controller.value.isPlaying) return;

    var subtitleTracks = await _controller.getSpuTracks();
    //
    if (subtitleTracks != null && subtitleTracks.isNotEmpty) {
      var selectedSubId = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Select Subtitle'),
            content: Container(
              width: double.maxFinite,
              height: 250,
              child: ListView.builder(
                itemCount: subtitleTracks.keys.length + 1,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      index < subtitleTracks.keys.length
                          ? subtitleTracks.values.elementAt(index).toString()
                          : 'Disable',
                    ),
                    onTap: () {
                      Navigator.pop(
                        context,
                        index < subtitleTracks.keys.length
                            ? subtitleTracks.keys.elementAt(index)
                            : -1,
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      );
      if (selectedSubId != null) await _controller.setSpuTrack(selectedSubId);
    }
  }

  void _getAudioTracks() async {
    if (!_controller.value.isPlaying) return;

    var audioTracks = await _controller.getAudioTracks();
    //
    if (audioTracks != null && audioTracks.isNotEmpty) {
      var selectedAudioTrackId = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Select Audio'),
            content: Container(
              width: double.maxFinite,
              height: 250,
              child: ListView.builder(
                itemCount: audioTracks.keys.length + 1,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      index < audioTracks.keys.length
                          ? audioTracks.values.elementAt(index).toString()
                          : 'Disable',
                    ),
                    onTap: () {
                      Navigator.pop(
                        context,
                        index < audioTracks.keys.length
                            ? audioTracks.keys.elementAt(index)
                            : -1,
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      );
      if (selectedAudioTrackId != null) {
        await _controller.setAudioTrack(selectedAudioTrackId);
      }
    }
  }

  void _getRendererDevices() async {
    var castDevices = await _controller.getRendererDevices();
    //
    if (castDevices != null && castDevices.isNotEmpty) {
      var selectedCastDeviceName = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Display Devices'),
            content: Container(
              width: double.maxFinite,
              height: 250,
              child: ListView.builder(
                itemCount: castDevices.keys.length + 1,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      index < castDevices.keys.length
                          ? castDevices.values.elementAt(index).toString()
                          : 'Disconnect',
                    ),
                    onTap: () {
                      Navigator.pop(
                        context,
                        index < castDevices.keys.length
                            ? castDevices.keys.elementAt(index)
                            : null,
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      );
      await _controller.castToRenderer(selectedCastDeviceName);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No Display Device Found!')));
    }
  }

  @override
  void initState() {
    super.initState();
    _initPlatformState();
    Wakelock.enable();
    _ss.add(accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        x = event.x;
      });
    }));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIOverlays([]);
    _controller = VlcPlayerController.network(
      Uri.parse(vdo).toString(),
      autoInitialize: true,
      autoPlay: true,
      hwAcc: setHwAcc,
      onInit: () async {
        await _controller.startRendererScanning();
      },
      onRendererHandler: (type, id, name) {
        print('onRendererHandler $type $id $name');
      },
      options: VlcPlayerOptions(
        video: VlcVideoOptions([
          VlcVideoOptions.dropLateFrames(false),
          VlcVideoOptions.skipFrames(false),
        ]),
        sout: VlcStreamOutputOptions([
          VlcStreamOutputOptions.soutMuxCaching(2000),
        ]),
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.networkCaching(2000),
        ]),
        subtitle: VlcSubtitleOptions([
          VlcSubtitleOptions.boldStyle(true),
          VlcSubtitleOptions.fontSize(50),
          VlcSubtitleOptions.outlineColor(VlcSubtitleColor.white),
          VlcSubtitleOptions.outlineThickness(VlcSubtitleThickness.none),
        ]),
        rtp: VlcRtpOptions([
          VlcRtpOptions.rtpOverRtsp(true),
        ]),
        extras: [],
      ),
    );
    _controller.addListener(listener);
    if (_controller.value.hasError) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(_controller.value.errorDescription.toString()),
          );
        },
      );
    }
  }

  @override
  void dispose() async {
    Screen.setBrightness(_eB);
    for (StreamSubscription<dynamic> subscription in _ss) {
      subscription.cancel();
    }
    Wakelock.disable();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
    await _controller.stopRendererScanning();
    await _controller.dispose();
    _controller.removeListener(listener);
  }

  @override
  void deactivate() {
    super.deactivate();
    _controller.pause();
  }

  @override
  Widget build(BuildContext context) {
    if (x > 4) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
      ]);
    }
    if (x < (-4)) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
      ]);
    }
    if (_controller.value.isPlaying) {
      setState(() {
        _isLoading = false;
        videoAspect = _controller.value.aspectRatio;
        videoH = _controller.value.size.height;
        videoW = _controller.value.size.width;
      });
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black,
          child: Stack(
            alignment: Alignment.center,
            children: [
              InteractiveViewer(
                panEnabled: false,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => setState(() => isVisible = !isVisible),
                  onDoubleTap: () {
                    setState(() {
                      _isFit = !_isFit;
                    });
                  },
                  child: SizedBox.expand(
                    child: FittedBox(
                      fit: (_isFit == false) ? BoxFit.contain : BoxFit.fill,
                      child: SizedBox(
                        width: videoW,
                        height: videoH,
                        child: VlcPlayer(
                          controller: _controller,
                          aspectRatio: videoAspect,
                          placeholder: Center(child: Container()),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: _isLoading,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(image), fit: BoxFit.cover)),
                ),
              ),
              Visibility(
                visible: isVisible,
                child: Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 60,
                    color: Colors.black38,
                    child: SafeArea(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  Text(
                                    tit,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.cast,
                                      color: Colors.white,
                                    ),
                                    onPressed: () async {
                                      _getRendererDevices();
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.subtitles,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      _getSubtitleTracks();
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.audiotrack,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      _getAudioTracks();
                                    },
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: isVisible,
                child: Positioned(
                  bottom: (MediaQuery.of(context).size.height / 2) - 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.replay_10,
                          color: Colors.white,
                        ),
                        iconSize: 50,
                        onPressed: () {
                          if (_controller.value.isInitialized) {
                            if ((currentPlayerTime - 10.0) < 10.0) {
                              setState(() {
                                currentPlayerTime = 0.0;
                                _controller
                                    .setTime(currentPlayerTime.toInt() * 1000);
                              });
                            } else {
                              setState(() {
                                currentPlayerTime = currentPlayerTime - 10.0;
                                _controller
                                    .setTime(currentPlayerTime.toInt() * 1000);
                              });
                            }
                          } else {}
                        },
                      ),
                      IconButton(
                        color: Colors.white,
                        icon: _controller.value.isPlaying
                            ? Icon(Icons.pause_circle_outline)
                            : Icon(Icons.play_circle_outline),
                        onPressed: () async {
                          return _controller.value.isPlaying
                              ? await _controller.pause()
                              : await _controller.play();
                        },
                        iconSize: 70,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.forward_10,
                          color: Colors.white,
                        ),
                        iconSize: 50,
                        onPressed: () {
                          if (_controller.value.isInitialized) {
                            if ((currentPlayerTime + 10.0) >
                                _controller.value.duration.inSeconds
                                    .toDouble()) {
                              setState(() {
                                currentPlayerTime = _controller
                                    .value.duration.inSeconds
                                    .toDouble();
                                _controller
                                    .setTime(currentPlayerTime.toInt() * 1000);
                              });
                            } else {
                              setState(() {
                                currentPlayerTime = currentPlayerTime + 10.0;
                                _controller
                                    .setTime(currentPlayerTime.toInt() * 1000);
                              });
                            }
                          } else {}
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: _isLoading,
                child: Positioned(
                  bottom: (MediaQuery.of(context).size.height / 2) - 20,
                  child: SizedBox(
                    height: 65,
                    width: 65,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              Visibility(
                  visible: isVisible,
                  child: Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 100,
                      color: Colors.black38,
                      child: SafeArea(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Flexible(
                              flex: 3,
                              child: Column(children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        position,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                      Expanded(
                                        child: Slider(
                                          activeColor: Colors.white,
                                          value: sliderValue,
                                          min: 0.0,
                                          max:
                                              _controller.value.duration == null
                                                  ? 1.0
                                                  : _controller
                                                      .value.duration.inSeconds
                                                      .toDouble(),
                                          onChanged: !validPosition
                                              ? null
                                              : _onSliderPositionChanged,
                                        ),
                                      ),
                                      Text(
                                        duration,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.speed,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              'Speed',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          setState(() {
                                            isSpeed = !isSpeed;
                                          });
                                        },
                                      ),
                                      GestureDetector(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.hd_outlined,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              'Default(720p)',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        onTap: null,
                                      ),
                                      GestureDetector(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.video_settings,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              'HwAcc' + hwAccSet,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          setState(() {
                                            isHwAcc = !isHwAcc;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Text('Powered by MH-Player',
                                      style: TextStyle(
                                        color: Colors.white54,
                                      )),
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
              Visibility(
                visible: isSpeed,
                child: Positioned(
                  bottom: 100,
                  right: 0,
                  left: 0,
                  child: Container(
                    height: 50,
                    color: Colors.black12,
                    child: SafeArea(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            child: Text('-speed'),
                            onPressed: () => _controller.setPlaybackSpeed(0.5),
                          ),
                          TextButton(
                            child: Text('Normal'),
                            onPressed: () => _controller.setPlaybackSpeed(1),
                          ),
                          TextButton(
                            child: Text('+speed'),
                            onPressed: () => _controller.setPlaybackSpeed(2.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: isHwAcc,
                child: Positioned(
                    left: 40,
                    top: (MediaQuery.of(context).size.height / 2) - 120,
                    child: Container(
                      color: Colors.black38,
                      height: 200,
                      width: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'HwAcc Settings',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Set Hardware Acceleration to get better video frame rates',
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          ),
                          SizedBox(height: 5),
                          TextButton(
                            child: Text('Auto'),
                            onPressed: () {
                              setState(() {
                                setHwAcc = HwAcc.AUTO;
                                hwAccSet = '(AUTO)';
                                isHwAcc = false;
                              });
                            },
                          ),
                          TextButton(
                            child: Text('On'),
                            onPressed: () {
                              setState(() {
                                setHwAcc = HwAcc.FULL;
                                hwAccSet = '(ON)';
                                isHwAcc = false;
                              });
                            },
                          ),
                          TextButton(
                            child: Text('Off'),
                            onPressed: () {
                              setState(() {
                                setHwAcc = HwAcc.DISABLED;
                                hwAccSet = '(OFF)';
                                isHwAcc = false;
                              });
                            },
                          )
                        ],
                      ),
                    )),
              ),
              Visibility(
                visible: isVisible,
                child: Positioned(
                  right: 20,
                  top: (MediaQuery.of(context).size.height / 2) - 40,
                  child: Container(
                    child: Transform(
                      alignment: FractionalOffset.center,
                      transform: Matrix4.identity()
                        ..rotateZ(270 * 3.1415927 / 180),
                      child: Row(
                        children: [
                          Icon(
                            Icons.brightness_low,
                            color: Colors.white54,
                            size: 15,
                          ),
                          Slider(
                            value: _brightness,
                            onChanged: (double b) {
                              setState(() {
                                _brightness = b;
                              });
                              Screen.setBrightness(b);
                            },
                          ),
                          Icon(
                            Icons.brightness_high,
                            color: Colors.white54,
                            size: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
