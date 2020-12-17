import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';
import 'package:projext_x/OcrTextDetail.dart';

void main() => runApp(ProjectX());

class ProjectX extends StatefulWidget {
  @override
  _ProjectXState createState() => _ProjectXState();
}

class _ProjectXState extends State<ProjectX> {
  int _cameraOcr = FlutterMobileVision.CAMERA_BACK;
  bool _autoFocusOcr = true;
  bool _torchOcr = false;
  bool _multipleOcr = true;
  bool _waitTapOcr = true;
  bool _showTextOcr = true;
  Size _previewOcr;
  List<OcrText> _textsOcr = [];

  @override
  void initState() {
    super.initState();
    FlutterMobileVision.start().then((previewSizes) => setState(() {
          _previewOcr = previewSizes[_cameraOcr].first;
        }));
  }

  List<DropdownMenuItem<int>> _getFormats() {
    List<DropdownMenuItem<int>> formatItems = [];

    Barcode.mapFormat.forEach((key, value) {
      formatItems.add(
        DropdownMenuItem(
          child: Text(value),
          value: key,
        ),
      );
    });

    return formatItems;
  }

  ///
  /// Camera list
  ///
  List<DropdownMenuItem<int>> _getCameras() {
    List<DropdownMenuItem<int>> cameraItems = [];

    cameraItems.add(DropdownMenuItem(
      child: Text('BACK'),
      value: FlutterMobileVision.CAMERA_BACK,
    ));

    cameraItems.add(DropdownMenuItem(
      child: Text('FRONT'),
      value: FlutterMobileVision.CAMERA_FRONT,
    ));

    return cameraItems;
  }

  ///
  /// Preview sizes list
  ///
  List<DropdownMenuItem<Size>> _getPreviewSizes(int facing) {
    List<DropdownMenuItem<Size>> previewItems = [];

    List<Size> sizes = FlutterMobileVision.getPreviewSizes(facing);

    if (sizes != null) {
      sizes.forEach((size) {
        previewItems.add(
          DropdownMenuItem(
            child: Text(size.toString()),
            value: size,
          ),
        );
      });
    } else {
      previewItems.add(
        DropdownMenuItem(
          child: Text('Empty'),
          value: null,
        ),
      );
    }
    return previewItems;
  }

  Future<Null> _read() async {
    List<OcrText> texts = [];
    try {
      texts = await FlutterMobileVision.read(
        flash: _torchOcr,
        autoFocus: _autoFocusOcr,
        multiple: _multipleOcr,
        waitTap: _waitTapOcr,
        showText: _showTextOcr,
        preview: _previewOcr,
        camera: _cameraOcr,
        fps: 30.0,
      );
    } on Exception {
      texts.add(OcrText('Failed to recognize text.'));
    }

    if (!mounted) return;
    setState(() {
      _textsOcr = texts;
      print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      for (int i = 0; i < _textsOcr.length; i++) {
        print(_textsOcr[i].value);
      }
    });
  }

  List<Widget> items = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          padding: const EdgeInsets.only(top: 12.0),
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
                left: 18.0,
                right: 18.0,
              ),
              child: const Text('Camera:'),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 18.0,
                right: 18.0,
              ),
              child: DropdownButton(
                items: _getCameras(),
                onChanged: (value) {
                  _previewOcr = null;
                  setState(() => _cameraOcr = value);
                },
                value: _cameraOcr,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
                left: 18.0,
                right: 18.0,
              ),
              child: const Text('Preview size:'),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 18.0,
                right: 18.0,
              ),
              child: DropdownButton(
                items: _getPreviewSizes(_cameraOcr),
                onChanged: (value) {
                  setState(() => _previewOcr = value);
                },
                value: _previewOcr,
              ),
            ),
            SwitchListTile(
              title: const Text('Auto focus:'),
              value: _autoFocusOcr,
              onChanged: (value) => setState(() => _autoFocusOcr = value),
            ),
            SwitchListTile(
              title: const Text('Torch:'),
              value: _torchOcr,
              onChanged: (value) => setState(() => _torchOcr = value),
            ),
            SwitchListTile(
              title: const Text('Return all texts:'),
              value: _multipleOcr,
              onChanged: (value) => setState(() => _multipleOcr = value),
            ),
            SwitchListTile(
              title: const Text('Capture when tap screen:'),
              value: _waitTapOcr,
              onChanged: (value) => setState(() => _waitTapOcr = value),
            ),
            SwitchListTile(
              title: const Text('Show text:'),
              value: _showTextOcr,
              onChanged: (value) => setState(() => _showTextOcr = value),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 18.0,
                right: 18.0,
                bottom: 12.0,
              ),
              child: RaisedButton(
                onPressed: _read,
                child: Text('READ!'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OcrTextWidget extends StatelessWidget {
  final OcrText ocrText;

  OcrTextWidget(this.ocrText);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.title),
      title: Text(ocrText.value),
      subtitle: Text(ocrText.language),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => OcrTextDetail(ocrText: ocrText),
        ),
      ),
    );
  }
}
