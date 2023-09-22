import 'package:flutter/material.dart';
import '../Screens/message_screen.dart';

class AppRoutes{
  static const String HOME='/';
  static const String MEALFeed='/meal_feed_screen';
  static const String SHARE_PICTURE='/share_picture_screen';
  static const String MESSAGE='/message_screen';
 static Route ongenerateRoute(RouteSettings settings){
    switch(settings.name){
      case AppRoutes.MESSAGE:
        return MaterialPageRoute(builder: (_) => MessageScreen());
      default:
        return MaterialPageRoute(builder: (_) => Placeholder());
    }
  }
}