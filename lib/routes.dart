import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/screens/auth.dart';
import 'package:todo/screens/dashboard.dart';
import 'package:todo/screens/mainscreen.dart';
import 'package:todo/screens/splash.dart';
import 'package:todo/screens/task.dart';
import 'package:todo/screens/welcome.dart';

class RouteNames {
  static const String mainscreen = '/mainscreen';
  static const String welcomescreen = '/welcomescreen';
  static const String authscreen = '/authscreen';
  static const String dashboard = '/dashboard';
  static const String splash = '/splash';
  static const String taskscreen = '/taskscreen';
}

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.mainscreen:
        return MaterialPageRoute<dynamic>(
            builder: (context) => const MainScreen());
      case RouteNames.welcomescreen:
        return MaterialPageRoute<dynamic>(
            builder: (_) => const WelcomeScreen());
      case RouteNames.authscreen:
        bool login = settings.arguments as bool;
        return MaterialPageRoute<dynamic>(
            builder: (_) => AuthScreen(login: login));
      case RouteNames.dashboard:
        return MaterialPageRoute<dynamic>(builder: (_) => const Dashboard());
      case RouteNames.splash:
        return MaterialPageRoute<dynamic>(builder: (_) => const Splashscreen());
      case RouteNames.taskscreen:
        return MaterialPageRoute<dynamic>(
            builder: (_) => TaskScreen(
                  taskRef: settings.arguments as DocumentReference,
                ));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}'))));
    }
  }
}
