import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../routes/app_routes.dart';

class MealFeedScreen extends StatelessWidget {
/* 
This recipe demonstrates how to use the camera plugin to display a preview, take a photo, and display it using the following steps:
Add the required dependencies.
Get a list of the available cameras.
Create and initialize the CameraController.
Use a CameraPreview to display the camera’s feed.
Take a picture with the CameraController.
Display the picture with an Image widget.
*/
CameraController? controller;
CameraPreview? preview;
  @override
  Widget build(BuildContext context) {
    // double appBarHeight = AppBarTheme.of(context).toolbarHeight!;
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
                    child: SizedBox(height: height *0.06,
                      child: InkWell(
                          onTap: () =>
                              Navigator.pop(context),
                          child: Image.asset('assets/images/Back_Button.png')),
                    ),
                  ),
                  Container(alignment: Alignment.center,
                    height: height*0.30,
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
                        right:width / 2 - 70,
                        child: Column(
                          children: [
                            Text(
                              "Select Your Meal\n",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            InkWell(
                                onTap: () => Navigator.pushNamed(
                                    context, AppRoutes.SHARE_PICTURE),
                                child: Image.asset(
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
      height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.height *0.36 -65,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25)),
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
              height: 100,
              width: 100,
              child: Image.asset('assets/images/Cutlery.png'),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            left: 20,
            child: Container(
              height: 100,
              width: 100,
              child: Image.asset('assets/images/Corners.png'),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            left: 20,
            child: Container(
              height: 100,
              width: 100,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage('assets/images/Plate.png') ,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: TakePictureScreen(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: firstCamera,
      ),
    ),
  );
}

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            if (!mounted) return;

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}