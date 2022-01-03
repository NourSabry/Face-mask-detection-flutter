// ignore_for_file: file_names, prefer_typing_uninitialized_variables, avoid_print, prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

// ignore: use_key_in_widget_constructors
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool loading = true;
  File? file;
  var output;
  var label;
  String? fine;
  String images = '';
  ImagePicker picker = ImagePicker();
  var gfg = {
    'with_mask': 'no_fine',
    'without_mask': 'Fine_100_dollar',
  };

  @override
  void initState() {
    super.initState();
    loadmodel().then((value) {
      setState(() {});
    });
  }

  detectimage(String l) async {
    var prediction = await Tflite.runModelOnImage(
      path: l,
      numResults: 2,
      threshold: 0.6,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      output = prediction;
      label = (output![0]['label']).toString().substring(2);
      fine = gfg[label];
      loading = false;
    });
  }

  loadmodel() async {
    await Tflite.loadModel(
      model: 'assets/model_unquant.tflite',
      labels: 'assets/labels.txt',
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  //getImageFromCamera() async {
  //var img = await image.pickImage(source: ImageSource.camera);

  //setState(() {
  // file = File(img!.path);
  //});
  // detectimage(file!);
  // }

  selectImage() async {
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          images = image.path;
          print(images);
        });
        detectimage(images);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  selectImageCamera() async {
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        setState(() {
          images = image.path;
          print(images);
        });
        detectimage(images);
      }
    } catch (e) {
      print(e.toString());
    }
  }
  // getImageFromGallery() async {
  //  XFile file = await image.pickImage(source: ImageSource.gallery);

  //setState(() {
  // file = File(img!.path);
  // });
  //detectimage(file!);
  // }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Mask or without_mask detection Project',
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        height: h,
        width: w,
        child: Column(
          children: [
            SizedBox(height: 40),
            loading == true
                ? Container()
                : Container(
                    color: Colors.grey,
                    child: Column(
                      children: [
                        Container(
                          height: 220,
                          padding: EdgeInsets.all(15),
                          child: Image.file(File(images)),
                        ),
                        SizedBox(height: 10),
                        Text(
                          (output![0]['label']).toString().substring(2),
                        ),
                        // Text(
                        //   'Confidence: ' +
                        //       (output![0]['confidence']).toString(),
                        // ),
                      ],
                    ),
                  ),
            Stack(
              children: [
                SizedBox(height: 30),
                Align(
                  alignment: Alignment(-0.5, 0.8),
                  child: FloatingActionButton(
                    elevation: 0.0,
                    child: Icon(
                      Icons.image,
                    ),
                    backgroundColor: Colors.indigo[900],
                    onPressed: selectImage,
                  ),
                ),
                Align(
                  alignment: Alignment(0.5, 0.8),
                  child: FloatingActionButton(
                    elevation: 0.0,
                    child: Icon(
                      Icons.camera,
                    ),
                    backgroundColor: Colors.indigo[900],
                    onPressed: selectImageCamera,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
