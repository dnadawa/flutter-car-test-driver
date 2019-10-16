import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:screenshot/screenshot.dart';

class Sign extends StatefulWidget {
  final String fullname;

  const Sign({Key key, this.fullname}) : super(key: key);

  @override
  SignState createState() => SignState(fullname);
}

class SignState extends State<Sign> {
  ScreenshotController screenshotController = ScreenshotController();
  String urlsign;
  Color _color = Colors.white;
  final String fullname;
  GlobalKey<SignatureState> signatureKey = GlobalKey();
  var signature;

  SignState(this.fullname);

  String signurl;

  @override
  void initState() {
    super.initState();
  }

  var pngBytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Signature(key: signatureKey),
      persistentFooterButtons: <Widget>[
        FlatButton(
          child: Text('Clear'),
          onPressed: () {
            signatureKey.currentState.clearPoints();
          },
        ),
        FlatButton(
          child: Text('Save'),
          onPressed: () async {
            // Future will resolve later
            // so setState @image here and access in #showImage
            // to avoid @null Checks
            setRenderedImage(context);

            //Navigator.push(context, MaterialPageRoute(builder: (context) =>  HomePage()));
          },
        )
      ],
    );
  }

  setRenderedImage(BuildContext context) async {
    ui.Image renderedImage = await signatureKey.currentState.rendered;

    setState(() {
      signature = renderedImage;
    });

    showImage(context);
  }

  Future<Null> showImage(BuildContext context) async {
    pngBytes = await signature.toByteData(format: ui.ImageByteFormat.png);



    return showDialog<Null>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Please Wait!"),
            titleTextStyle: TextStyle(color: _color),

            content: Screenshot(
              controller: screenshotController,
              child: Image.memory(
                Uint8List.view(pngBytes.buffer),
              ),
            ),



            actions: <Widget>[
              FlatButton(
                onPressed: (){



                  File _imageFile;
                  screenshotController.capture().then((File image) {
                    //Capture Done
                    setState(() async {
                      _imageFile = image;
                      print("File saved as image!");
                      StorageReference ref = FirebaseStorage.instance.ref().child("new/$fullname.png");
                      StorageUploadTask uploadTask = ref.putFile(_imageFile);
                      final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
                      _color = Colors.redAccent;
                      urlsign = (await downloadUrl.ref.getDownloadURL());
                      print("url is $urlsign");
                      Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));

                    });
                  }).catchError((onError) {
                    print("Error while saving image : $onError");
                  });



                },
                child: Text("Submit"),
              ),
            ],
          );
        });
  }

//  String formattedDate() {
//    DateTime dateTime = DateTime.now();
//    String dateTimeString = 'Signature_' +
//        dateTime.year.toString() +
//        dateTime.month.toString() +
//        dateTime.day.toString() +
//        dateTime.hour.toString() +
//        ':' + dateTime.minute.toString() +
//        ':' + dateTime.second.toString() +
//        ':' + dateTime.millisecond.toString() +
//        ':' + dateTime.microsecond.toString();
//    return dateTimeString;
//  }

//  requestPermission() async {
//    bool result = (await SimplePermissions.requestPermission(_permission)) as bool;
//    return result;
//  }
//
//  checkPermission() async {
//    bool result = await SimplePermissions.checkPermission(_permission);
//    return result;
//  }
//
//  getPermissionStatus() async {
//    final result = await SimplePermissions.getPermissionStatus(_permission);
//    print("permission status is " + result.toString());
//  }

}

class Signature extends StatefulWidget {
  Signature({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SignatureState();
  }
}

class SignatureState extends State<Signature> {
  // [SignatureState] responsible for receives drag/touch events by draw/user
  // @_points stores the path drawn which is passed to
  // [SignaturePainter]#contructor to draw canvas
  List<Offset> _points = <Offset>[];

  Future<ui.Image> get rendered {
    // [CustomPainter] has its own @canvas to pass our
    // [ui.PictureRecorder] object must be passed to [Canvas]#contructor
    // to capture the Image. This way we can pass @recorder to [Canvas]#contructor
    // using @painter[SignaturePainter] we can call [SignaturePainter]#paint
    // with the our newly created @canvas
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);
    SignaturePainter painter = SignaturePainter(points: _points);
    var size = context.size;
    painter.paint(canvas, size);
    return recorder
        .endRecording()
        .toImage(size.width.floor(), size.height.floor());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            setState(() {
              RenderBox _object = context.findRenderObject();
              Offset _locationPoints =
                  _object.localToGlobal(details.globalPosition);
              _points = new List.from(_points)..add(_locationPoints);
            });
          },
          onPanEnd: (DragEndDetails details) {
            setState(() {
              _points.add(null);
            });
          },
          child: CustomPaint(
            painter: SignaturePainter(points: _points),
            size: Size.infinite,
          ),
        ),
      ),
    );
  }

  // clearPoints method used to reset the canvas
  // method can be called using
  //   key.currentState.clearPoints();
  void clearPoints() {
    setState(() {
      _points.clear();
    });
  }
}

class SignaturePainter extends CustomPainter {
  List<Offset> points = <Offset>[];

  SignaturePainter({this.points});
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
