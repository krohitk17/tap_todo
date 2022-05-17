import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:todo/components/roundedbutton.dart';
import 'package:todo/constants.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key, required this.login}) : super(key: key);
  final bool login;

  @override
  AuthScreenState createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool showSpinner = false;
  String errorMessage = '';
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your Password'),
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                colour:
                    widget.login ? Colors.lightBlueAccent : Colors.blueAccent,
                title: widget.login ? 'Log In' : 'Register',
                onPressed: () async {
                  try {
                    setState(() {
                      showSpinner = true;
                    });
                    widget.login
                        ? await _auth.signInWithEmailAndPassword(
                            email: email, password: password)
                        : await _auth.createUserWithEmailAndPassword(
                            email: email, password: password);
                    setState(() {
                      showSpinner = false;
                    });
                    Navigator.pop(context);
                  } catch (error) {
                    setState(() {
                      showSpinner = false;
                      errorMessage = error.toString();
                    });
                  }
                  emailController.clear();
                  passwordController.clear();
                },
              ),
              Center(
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 15.0),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
