import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:mask_detection/services/detector.dart';


const String withMask = "with_mask";
const String withoutMask = "without_mask";
const String labelString = "label";
const String wearingMask = "Wearing mask";
const String noMask = "No mask";


class Home extends StatefulWidget {
  Home() : super();


  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File _image;
  List _recognitions;
  bool _loading = false;
  String text ='';
  final Detector _detector = Detector();
  ImagePicker _picker = ImagePicker();
  PickedFile _imageFile;

  @override
  void initState(){
    super.initState();
    _loading=true;
    loadModel().then((value){
      setState(() {
        _loading=false;
      });
    });
  }

  loadModel() async{
    _detector.loadModel();
  }


  selectImage() async {
    _imageFile = await _picker.getImage(source: ImageSource.gallery);
    if (_imageFile == null) return;
    setState(() {
      _loading = true;
      _image = File(_imageFile.path);
    });
    predictImage(_image);
  }

  predictImage(File image) async{
    var recognitions = await _detector.predictImage(image);
    setState(() {
      _loading=false;
      _recognitions = recognitions;
      text = _recognitions[0][labelString];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: Text('Mask Detection'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.image,
          color: Colors.black,
          size: 30.0,
        ),
        backgroundColor: Colors.white,
        onPressed: selectImage,
      ),
      body:_loading
          ? Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      )
          : Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? Container(
              child: Text(
                selectImage(),
                style: TextStyle(
                    fontSize: 20, color: Colors.green),
              ),
            )
                : Image.file(
              _image,
              height: MediaQuery.of(context).size.height / 2 + 60,
              width: MediaQuery.of(context).size.width - 80,
            ),
            SizedBox(
              height: 20,
            ),
            _recognitions != null
                ? Text(
              "$text".substring(2),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold
              ),
            )
                :
                Container(),
          ],
        ),
      ),
    );
  }
}