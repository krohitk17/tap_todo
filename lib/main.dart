import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo/models/notification.dart';
import 'package:todo/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  await Firebase.initializeApp();
  runApp(const ToDo());
}

class ToDo extends StatelessWidget {
  const ToDo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: true,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      initialRoute: RouteNames.splash,
    );
  }
}
