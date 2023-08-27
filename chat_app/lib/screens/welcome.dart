import 'dart:ui';
import 'package:chat_app/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

import '../helper/animated_button.dart';
import '../helper/custom_input.dart';
import '../rounded_button.dart';
import 'login.dart';

class Welcome extends StatefulWidget {
  static String id = 'welcome_screen';
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animationBlur;
  Animation<double>? _animationFade;
  Animation<double>? _animationSize;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animationBlur = Tween<double>(
      begin: 50,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.ease,
      ),
    );

    _animationFade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.easeInOutQuint,
      ),
    );

    _animationSize = Tween<double>(
      begin: 0,
      end: 500,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.decelerate,
      ),
    );

    _controller?.forward();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // timeDilation = 8;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            AnimatedBuilder(
              animation: _animationBlur!,
              builder: (context, widget) {
                return Container(
                  height: 400,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/welcome.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: _animationBlur!.value,
                      sigmaY: _animationBlur!.value,
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 10,
                          child: FadeTransition(
                            opacity: _animationFade!,
                            child: Image.asset("images/detalhe1.png"),
                          ),
                        ),
                        Positioned(
                          left: 50,
                          child: FadeTransition(
                            opacity: _animationFade!,
                            child: Image.asset("images/detalhe2.png"),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
              child: Column(
                children: [
                  // AnimatedBuilder(
                  //   animation: _animationSize!,
                  //   builder: (context, widget) {
                  //     return Container(
                  //       width: _animationSize?.value,
                  //       padding: const EdgeInsets.all(8),
                  //       decoration: BoxDecoration(
                  //         color: Colors.white,
                  //         borderRadius: BorderRadius.circular(20),
                  //         boxShadow: const [
                  //           BoxShadow(
                  //             color: Colors.grey,
                  //             blurRadius: 80,
                  //             spreadRadius: 1,
                  //           )
                  //         ],
                  //       ),
                  //       child: Column(
                  //         children: [
                  //           const CustomInput(
                  //             hint: 'E-mail',
                  //             obscure: false,
                  //             icon: Icon(Icons.person),
                  //           ),
                  //           Container(
                  //             decoration: const BoxDecoration(
                  //               boxShadow: [
                  //                 BoxShadow(
                  //                   color: Colors.grey,
                  //                   spreadRadius: 0.5,
                  //                   blurRadius: 0.5,
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //           const CustomInput(
                  //             hint: 'Password',
                  //             obscure: true,
                  //             icon: Icon(Icons.lock),
                  //           ),
                  //         ],
                  //       ),
                  //     );
                  //   },
                  // ),
                  const SizedBox(height: 20),
                  CustomAnimatedButton(controller: _controller!,buttonName: 'Log In',
                  onCustomButtonPressed: (){
                    Navigator.pushNamed(context, Login.id);
                  },),
                  const SizedBox(height: 20),
                  CustomAnimatedButton(controller: _controller!,buttonName: 'Register',
                  onCustomButtonPressed: (){
                    Navigator.pushNamed(context, RegistrationScreen.id);
                  },),

                  // RoundedButton(title: 'Log In',color: Colors.lightBlueAccent,onPress: (){
                  //   Navigator.pushNamed(context, Login.id);
                  // }),
                  // RoundedButton(title: 'Register', color: Colors.blue, onPress: (){
                  //   Navigator.pushNamed(context, RegistrationScreen.id);
                  // }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
