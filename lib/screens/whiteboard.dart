import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class Whiteboards extends StatefulWidget {
  const Whiteboards({Key? key}) : super(key: key);

  @override
  _WhiteboardsState createState() => _WhiteboardsState();
}

class _WhiteboardsState extends State<Whiteboards> {
  List<List<_DrawingSegment>> lines = [];
  List<Offset> points = [];

  Color selectedColor = Colors.black;
  double strokeWidth = 3.0;

  void selectColor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                setState(() {
                  selectedColor = color;
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void clearDrawing() {
    setState(() {
      lines.clear();
    });
  }

  Future<void> saveImage() async {
    if (lines.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('No drawing to save'),
            content: Text('Please draw something before saving.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    for (var line in lines) {
      for (int i = 0; i < line.length - 1; i++) {
        final segment = line[i];
        final nextSegment = line[i + 1];
        if (segment != null && nextSegment != null) {
          final paint = Paint()
            ..color = segment.color
            ..strokeCap = StrokeCap.round
            ..strokeWidth = segment.strokeWidth;
          canvas.drawLine(
            segment.point,
            nextSegment.point,
            paint,
          );
        }
      }
    }

    final picture = recorder.endRecording();
    final img = await picture.toImage(400, 400); // Specify the image size
    final byteData = await img.toByteData(format: ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();

    final result = await ImageGallerySaver.saveImage(Uint8List.fromList(bytes));
    print('Image saved to: $result');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('TitanBoard'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.color_lens),
            onPressed: selectColor,
          ),
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: clearDrawing,
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveImage,
          ),
        ],
      ),
      body: GestureDetector(
        onPanStart: (details) {
          setState(() {
            points = [details.localPosition];
          });
        },
        onPanUpdate: (details) {
          setState(() {
            points.add(details.localPosition);
          });
        },
        onPanEnd: (details) {
          setState(() {
            lines.add(List.from(points.map(
              (point) => _DrawingSegment(
                point: point,
                strokeWidth: strokeWidth,
                color: selectedColor,
              ),
            )));
            points.clear();
          });
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return CustomPaint(
              painter: DrawingPainter(lines: lines),
              size: Size(constraints.maxWidth, constraints.maxHeight),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.brush),
              onPressed: () {
                // Open stroke width dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Select Stroke Width'),
                      content: Container(
                        width: 200, // Adjust the width of the content
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Slider(
                              value: strokeWidth,
                              min: 1.0,
                              max: 10.0,
                              onChanged: (value) {
                                setState(() {
                                  strokeWidth = value;
                                });
                              },
                              divisions: 9,
                              label: strokeWidth.toStringAsFixed(1),
                            ),
                            SizedBox(
                                height: 20), // Add spacing below the slider
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            SizedBox(width: 10), // Add spacing between icon and slider
          ],
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<List<_DrawingSegment>> lines;

  DrawingPainter({required this.lines});

  @override
  void paint(Canvas canvas, Size size) {
    for (var line in lines) {
      for (int i = 0; i < line.length - 1; i++) {
        final segment = line[i];
        final nextSegment = line[i + 1];
        if (segment != null && nextSegment != null) {
          final paint = Paint()
            ..color = segment.color
            ..strokeCap = StrokeCap.round
            ..strokeWidth = segment.strokeWidth;
          canvas.drawLine(
            segment.point,
            nextSegment.point,
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _DrawingSegment {
  final Offset point;
  final double strokeWidth;
  final Color color;

  _DrawingSegment({
    required this.point,
    required this.strokeWidth,
    required this.color,
  });
}
