import 'package:flutter/material.dart';
import 'package:todoapp/Home_Screen.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 36,
                ),
                Image.asset(
                  'assets/images/logo.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
                const Text(
                  'Welcome to Todolist',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 36,
                ),
                Image.asset(
                  'assets/images/testBg.png',
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                ),
                const SizedBox(
                  height: 36,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 60),
                      backgroundColor: Colors.red,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  child: const Text(
                    'Sign in',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(300, 60),
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    side: BorderSide(color: Colors.red, width: 2),
                  ),
                  child: const Text(
                    'Create account',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                const SizedBox(
                  width: 300,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "By continuing you agree to TodoList's ",
                        ),
                        TextSpan(
                          text: 'Terms of Service and Privacy Policy',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 107, 107, 107),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
