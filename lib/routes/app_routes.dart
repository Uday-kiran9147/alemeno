import 'package:flutter/material.dart';

import '../Screens/meal_feed_screen.dart';
import '../Screens/message_screen.dart';
import '../Screens/share_picture_screen.dart';
import '../main.dart';

class AppRoutes{
  static const String HOME='/';
  static const String MEALFeed='/meal_feed_screen';
  static const String SHARE_PICTURE='/share_picture_screen';
  static const String MESSAGE='/message_screen';
 static Route ongenerateRoute(RouteSettings settings){
    switch(settings.name){
      case AppRoutes.HOME:
        return MaterialPageRoute(builder: (_) => MyHomePage());
      case AppRoutes.MEALFeed:
        return MaterialPageRoute(builder: (_) => MealFeedScreen());
      case AppRoutes.SHARE_PICTURE:
        return MaterialPageRoute(builder: (_) => SharePictureScreen());
      case AppRoutes.MESSAGE:
        return MaterialPageRoute(builder: (_) => MessageScreen());
      default:
        return MaterialPageRoute(builder: (_) => MyHomePage());
    }
  }
}