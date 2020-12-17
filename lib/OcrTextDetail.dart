import 'package:flutter/material.dart';

class OcrTextDetail extends StatefulWidget {
  final ocrText;
  OcrTextDetail({this.ocrText});
  @override
  _OcrTextDetailState createState() => _OcrTextDetailState();
}

class _OcrTextDetailState extends State<OcrTextDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('${widget.ocrText}'),
    );
  }
}
