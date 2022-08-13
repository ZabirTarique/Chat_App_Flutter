
import 'package:chat_app/screens/registration_screen.dart';
import 'package:flutter/material.dart';

import '../rounded_button.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{

  late AnimationController controller;
  late Animation animation;


  @override
  void initState()  {
    super.initState();
    controller = AnimationController(vsync: this,duration: Duration(seconds: 1));
    animation = CurvedAnimation(parent:controller,curve: Curves.easeOutCubic);
    controller.forward();

    controller.addListener(() {
      setState((){
      });
      print( animation.value * 100);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(controller.value),
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
                    height:( animation.value * 100),
                  ),
                ),
                Text(
                  'Flash Chat',
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.black
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(title: 'Log In',color: Colors.lightBlueAccent,onPress: (){
              Navigator.pushNamed(context, LoginScreen.id);

            }),
            RoundedButton(title: 'Register', color: Colors.blue, onPress: (){
              Navigator.pushNamed(context, RegistrationScreen.id);
            }),
          ],
        ),
      ),
    );
  }
}
