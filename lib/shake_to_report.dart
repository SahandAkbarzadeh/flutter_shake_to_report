library shake_to_report;

import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:shake_event/shake_event.dart';

import 'prepare_report_screen.dart';

typedef OnSendReportCallBack = Future Function(
    Uint8List image, String description);

class ShakeToReport extends StatefulWidget {
  final Widget child;
  final OnSendReportCallBack sendReportHandler;

  const ShakeToReport({
    Key key,
    this.child,
    @required this.sendReportHandler,
  }) : super(key: key);

  @override
  _ShakeToReportState createState() => _ShakeToReportState();
}

class _ShakeToReportState extends State<ShakeToReport> with ShakeHandler {
  var _applicationKey = new GlobalKey();
  var isPrepareScreenOpened = false;

  @override
  void dispose() {
    resetShakeListeners();
    super.dispose();
  }

  @override
  shakeEventListener() {
    handleScreenShot();
    return super.shakeEventListener();
  }

  handleScreenShot() async {
    var screen = await takeScreenshot();
    if (!isPrepareScreenOpened) {
      isPrepareScreenOpened = true;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PrepareReportScreen(
            image: screen,
            callBack: widget.sendReportHandler,
          ),
        ),
      );
      isPrepareScreenOpened = false;
    }
  }

  Future<Uint8List> takeScreenshot() async {
    RenderRepaintBoundary boundary =
        _applicationKey.currentContext.findRenderObject();
    var image = await boundary.toImage();
    var byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    startListeningShake(20);
    return RepaintBoundary(
      key: _applicationKey,
      child: widget.child,
    );
  }
}
