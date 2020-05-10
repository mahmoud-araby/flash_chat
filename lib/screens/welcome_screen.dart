import 'package:animated_text_kit/animated_text_kit.dart'
    show TypewriterAnimatedTextKit;
import 'package:flashchat/component/button.dart';
import 'package:flashchat/screens/login_screen.dart';
import 'package:flashchat/screens/registration_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = '/';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  speed: Duration(seconds: 2),
                  pause: Duration(seconds: 2),
                  text: ['Flash Chat'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            Button(
              onTap: () => Navigator.pushNamed(context, LoginScreen.id),
              text: "Log In",
              buttonColor: Colors.lightBlueAccent,
            ),
            Button(
              onTap: () => Navigator.pushNamed(context, RegistrationScreen.id),
              text: "Register",
              buttonColor: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }
}
