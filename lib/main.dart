import 'package:alemeno/routes/app_routes.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'Screens/meal_feed_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(MyApp(
    cameradescription: firstCamera,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.cameradescription});
  final CameraDescription cameradescription;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alemeno',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'Andika'),
      home: MyHomePage(cameradescription: cameradescription),
      onGenerateRoute: AppRoutes.ongenerateRoute,
    );
  }
}

class MyHomePage extends StatefulWidget {
  final CameraDescription cameradescription;

  const MyHomePage({super.key, required this.cameradescription});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Home"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Center(
            child: GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            MealFeedScreen(camera: widget.cameradescription))),
                child: SizedBox(
                    width: 229,
                    height: 56,
                    child: Image.asset('assets/images/Share_Your_Meal.png'))),
          )
        ],
      ),
    );
  }
}
