import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:todo/routes.dart';

class Splashscreen extends StatefulWidget {
  static const String id = 'splash_screen';
  const Splashscreen({Key? key}) : super(key: key);

  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
  }

  void goMainScreen() {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, RouteNames.mainscreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    goMainScreen();
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 150.0,
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 30.0,
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText('Tap ToDo',
                        textStyle: const TextStyle(
                          fontSize: 40,
                        ),
                        speed: const Duration(milliseconds: 200)),
                  ],
                  onTap: () {
                    Navigator.pushNamed(context, RouteNames.mainscreen);
                  },
                ),
              ),
            ),
            Image.asset(
              'images/logo.png',
              alignment: Alignment.center,
              scale: 2,
            ),
          ],
        ),
      ),
    );
  }
}
