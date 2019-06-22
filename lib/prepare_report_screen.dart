import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'shake_to_report.dart';

class PrepareReportScreen extends StatefulWidget {
  final Uint8List image;
  final OnSendReportCallBack callBack;

  const PrepareReportScreen({Key key, this.image, this.callBack})
      : super(key: key);

  @override
  _PrepareReportScreenState createState() => _PrepareReportScreenState();
}

class _PrepareReportScreenState extends State<PrepareReportScreen> {
  TextEditingController textEditingController = TextEditingController(text: "");

  GlobalKey<ScaffoldState> _scaffold = GlobalKey();

  bool _isLoading = false;

  void setLoading(bool state) => this.setState(() => _isLoading = state);

  void send() async {
    setLoading(true);
    try {
      await widget.callBack(widget.image, textEditingController.text);
      Navigator.of(context).pop();
    } catch (e) {
      setLoading(false);
      _scaffold.currentState
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    print(textEditingController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      appBar: AppBar(title: Text("Report a bug")),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : send,
        child: _isLoading ? CircularProgressIndicator() : Icon(Icons.send),
      ),
      body: ListView(
        children: <Widget>[
          buildImage(),
          buildTextField(),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget buildTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: textEditingController,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(labelText: "Report Description"),
      ),
    );
  }

  FractionallySizedBox buildImage() {
    return FractionallySizedBox(
      widthFactor: 0.6,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
            color: Colors.black54,
            width: 2,
          )),
          child: Image.memory(
            widget.image,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
