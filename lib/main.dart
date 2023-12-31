import 'package:alemeno/firebase_options.dart';
import 'package:alemeno/providers/appstate.dart';
import 'package:alemeno/routes/app_routes.dart';
import 'package:alemeno/services/notification_service.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Screens/meal_feed_screen.dart';

@pragma('vm:entry-point')
Future<void> _firebaseBackGroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // firebase_options.dart file is intentionally pushed onto the repository
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final cameras = await availableCameras();
  FirebaseMessaging.onBackgroundMessage(_firebaseBackGroundMessageHandler);
 await FirebaseMessaging.instance.getInitialMessage();
  final firstCamera = cameras.first;
  runApp(MyApp(
    cameradescription: firstCamera,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.cameradescription});
  final CameraDescription cameradescription;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  NotificationService notificationService = NotificationService();
  @override
  void initState() {
    super.initState();
    notificationService.requestNotification_permission();
    notificationService.listenToNotifications();
    notificationService
        .getDeviceToken()
        .then((value) => {print("Device token " + value.toString())});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => AppState())],
      child: MaterialApp(
        title: 'Alemeno',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            fontFamily: 'Andika'),
        home: MyHomePage(cameradescription: widget.cameradescription),
        onGenerateRoute: AppRoutes.ongenerateRoute,debugShowCheckedModeBanner: false,
      ),
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
        title: Text("Home"),centerTitle: true,
      ),
      body: Center(
        child: GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        MealFeedScreen(camera: widget.cameradescription))),
            child: SizedBox(
                width: 220,
                height: 40,
                child: Image.asset('assets/images/Share_Your_Meal.png'))),
      ),
    );
  }
}
