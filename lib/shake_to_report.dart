library shake_to_report;

import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:shake_event/shake_event.dart';

class ShakeToReport extends StatefulWidget {
  final Widget child;

  const ShakeToReport({Key key, this.child}) : super(key: key);

  @override
  _ShakeToReportState createState() => _ShakeToReportState();
}

class _ShakeToReportState extends State<ShakeToReport> with ShakeHandler {
  var _applicationKey = new GlobalKey();

  @override
  void dispose() {
    resetShakeListeners();
    super.dispose();
  }

  @override
  shakeEventListener() {
    takeScreenshot();
    return super.shakeEventListener();
  }

  takeScreenshot() async {
    RenderRepaintBoundary boundary =
        _applicationKey.currentContext.findRenderObject();
    var image = await boundary.toImage();
    var byteData = await image.toByteData(format: ImageByteFormat.png);
    var pngBytes = byteData.buffer.asUint8List();
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
