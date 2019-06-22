import 'dart:typed_data';

import 'package:flutter/material.dart';

class PrepareReportScreen extends StatefulWidget {
  final Uint8List image;

  const PrepareReportScreen({Key key, this.image}) : super(key: key);

  @override
  _PrepareReportScreenState createState() => _PrepareReportScreenState();
}

class _PrepareReportScreenState extends State<PrepareReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Report a bug")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => print("sent"),
        child: Icon(Icons.send),
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
