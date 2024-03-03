import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/Pages/first.dart';
import 'package:noteapp/Pages/homePage.dart';
import 'package:noteapp/Pages/loginPage.dart';
import 'package:noteapp/Pages/signPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        //iconButtonTheme: IconButtonThemeData(style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.yellowAccent))),
        backgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(color: Colors.white),
        // deepPurple.shade200
        useMaterial3: true,
      ),
      home: (firebaseAuth.currentUser != null)? const HomePage() : const LoginPageSecond(),
    );
  }
}
