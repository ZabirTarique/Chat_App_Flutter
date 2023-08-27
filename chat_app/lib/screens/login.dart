
import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../helper/animated_button.dart';
import '../helper/custom_input.dart';
import '../services/authentication_services.dart';
import 'chat_screen.dart';

class Login extends StatefulWidget {
  static String id = '/login_screen';
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  bool _inProgess = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  AnimationController? _controller;
  Animation<double>? _animationBlur;
  Animation<double>? _animationFade;
  Animation<double>? _animationSize;
  var authHandler = Auth();

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
      body: ModalProgressHUD(
        inAsyncCall: _inProgess,
        color: Colors.pinkAccent,
        child: SingleChildScrollView(
          child: Column(
            children: [
              AnimatedBuilder(
                animation: _animationBlur!,
                builder: (context, widget) {
                  return Container(
                    height: 400,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/login.png"),
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
                    AnimatedBuilder(
                      animation: _animationSize!,
                      builder: (context, widget) {
                        return Container(
                          width: _animationSize?.value,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 80,
                                spreadRadius: 1,
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              CustomInput(
                                hint: 'E-mail',
                                obscure: false,
                                icon: const Icon(Icons.person),
                                onChanged: (value) {
                                  email = value;
                                },
                                customController: emailController,
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      spreadRadius: 0.5,
                                      blurRadius: 0.5,
                                    ),
                                  ],
                                ),
                              ),
                              CustomInput(
                                hint: 'Password',
                                obscure: true,
                                icon: const Icon(Icons.lock),
                                onChanged: (value) {
                                  password = value;
                                },
                                customController: passController,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomAnimatedButton(
                        controller: _controller!,
                        buttonName: 'Log-In',
                        onCustomButtonPressed: () {


                          email = emailController.text;
                          password = passController.text;
                          print("emailController");
                          print(emailController);
                          print("passController");
                          print(passController);

                          authHandler.handleSignInEmail(emailController.text, passController.text)
                              .then((User user) {
                            Navigator.pushNamed(context, ChatScreen.id);
                          }).catchError((e) {

                            AnimatedButton(
                              text: 'Error Dialog',
                              color: Colors.red,
                              pressEvent: () {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.rightSlide,
                                  headerAnimationLoop: false,
                                  title: 'Error',
                                  desc: 'Something went wrong! Login Failed',
                                  btnOkOnPress: () {},
                                  btnOkIcon: Icons.cancel,
                                  btnOkColor: Colors.red,
                                ).show();
                              },
                            );
                          });

                          // setState((){
                          //   _inProgess = true;
                          // });
                          // try{
                          //   if (kDebugMode) {
                          //     print('$email $password');
                          //   }
                          //   final user = _auth.signInWithEmailAndPassword(email: email, password: password);
                          //   Navigator.pushNamed(context, ChatScreen.id);
                          //   setState((){
                          //     _inProgess = false;
                          //   });
                          // }
                          // catch(e){
                          //   print(e);
                          // }
                        }),
                    const SizedBox(height: 10),
                    FadeTransition(
                      opacity: _animationFade!,
                      child: const Text(
                        "Forgot Password",
                        style: TextStyle(
                          color: Color.fromRGBO(255, 100, 127, 1),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
