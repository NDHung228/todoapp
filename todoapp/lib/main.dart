import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:todoapp/Service/Auth_Service.dart';
import 'package:todoapp/page/HomePage.dart';
import 'package:todoapp/page/SignInPage.dart';
import 'package:todoapp/page/SignUpPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget currentPage = SignInPage();
  AuthClass authClass = AuthClass();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    String token = await authClass.getToken();

    if (token != null) {
      setState(() {
        currentPage = HomePage();
      });
    }
    if (token.length == 0) {
      setState(() {
        currentPage = SignUpPage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: currentPage,
    );
  }
}
