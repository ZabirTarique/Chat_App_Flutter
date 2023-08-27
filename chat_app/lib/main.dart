import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/login.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/registration.dart';
import 'package:chat_app/screens/registration_screen.dart';
import 'package:chat_app/screens/welcome.dart';
import 'package:chat_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return runApp(const FlashChat());}

class FlashChat extends StatelessWidget {
  const FlashChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
       // '/':(context) => const WelcomeScreen(),
        '/':(context) => const Welcome(),
        //Login.id:(context) => LoginScreen(),
        Login.id:(context) => const Login(),
        //RegistrationScreen.id:(context) => const RegistrationScreen(),
        RegistrationScreen.id:(context) => const Registration(),
        ChatScreen.id:(context) => ChatScreen(),
      },
    );
  }
}
