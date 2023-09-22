import 'dart:io';
import 'package:alemeno/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

// ignore: must_be_immutable
class MealFeedScreen extends StatefulWidget {
/*  Source : https://flutter.dev/docs/cookbook/plugins/picture-using-camera
This recipe demonstrates how to use the camera plugin to display a preview, take a photo, and display it using the following steps:
Add the required dependencies.
Get a list of the available cameras.
Create and initialize the CameraController.
Use a CameraPreview to display the camera’s feed.
Take a picture with the CameraController.
Display the picture with an Image widget.
*/
  CameraDescription camera;
  MealFeedScreen({required this.camera});

  @override
  State<MealFeedScreen> createState() => _MealFeedScreenState();
}

class _MealFeedScreenState extends State<MealFeedScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  XFile? image;
  CameraPreview? preview;
  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // double appBarHeight = AppBarTheme.of(context).toolbarHeight!;
    // final cameradescription = ModalRoute.of(context)!.settings.arguments as CameraDescription;
    // final double statusBarHeight = MediaQuery.of(context).padding.top;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: height,
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: height * 0.06,
                      child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Image.asset('assets/images/Back_Button.png')),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: height * 0.30,
                    // width: 500,
                    child: Image.asset(
                      'assets/images/Smilodon.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  Stack(
                    children: [
                      _buildStack(context),
                      Positioned(
                        bottom: 50,
                        left: width / 2 - 70,
                        right: width / 2 - 70,
                        child: Column(
                          children: [
                            Text(
                              image == null
                                  ? "Select Your Meal\n"
                                  : "Will You Eat This ",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            // ):Text(),
                            InkWell(
                                onDoubleTap: () => setState(() {
                                      image = null;
                                    }),
                                onTap: () async {
                                  if (image == null) {
                                    try {
                                      await _initializeControllerFuture;
                                      image = await _controller.takePicture();
                                      setState(() {});
                                      print("Image path uday" + image!.path);
                                    } catch (e) {
                                      print(e.toString());
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(e.toString())));
                                    }
                                  } else {
                                    // database code
                                    Navigator.pushNamed(
                                        context, AppRoutes.MESSAGE);
                                  }
                                },
                                child: image != null
                                    ? Image.asset(
                                        'assets/images/Yes_Button.png')
                                    : Image.asset(
                                        'assets/images/Camera_Button.png')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  Widget _buildStack(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).size.height * 0.36 -
          65,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 15,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            left: 20,
            child: Container(
              height: 200,
              width: 200,
              child: Image.asset('assets/images/Cutlery.png'),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            left: 20,
            child: Container(
              height: 200,
              width: 200,
              child: Image.asset('assets/images/Corners.png'),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            left: 20,
            child: StreamBuilder<void>(
                stream: _initializeControllerFuture.asStream(),
                builder: (context, snapshot) {
                  if (image == null) {
                    return Container(
                      height: 300,
                      width: 300,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30)),
                        child: CircleAvatar(
                            child: CameraPreview(_controller = _controller)),
                      ),
                    );
                  } else {
                    return CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.white,
                      child: ClipOval(child: Image.file(File(image!.path))),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}
