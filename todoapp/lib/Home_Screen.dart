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
        body: SingleChildScrollView(
      child: Container(
        color: Colors.white10,
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: Column(
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
              ElevatedButton.icon(
                onPressed: () {
                  // Hành động khi button được nhấn
                },
                icon: const Icon(Icons.email_rounded),
                label: const Text(
                  "Continue with Email",
                  style: TextStyle(fontSize: 20),
                ),
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(const Size(350, 50)),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Hành động khi button được nhấn
                },
                icon: const Icon(Icons.apple_rounded, size: 30),
                label: const Text(
                  "Continue with Phone number",
                  style: TextStyle(fontSize: 20),
                ),
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(const Size(350, 50)),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size(169, 50)),
                      side: MaterialStateProperty.all(
                        const BorderSide(
                            color: Color.fromARGB(207, 182, 182, 227),
                            width: 1.5),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/logos_google-icon.png",
                          width: 25,
                          height: 25,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      // Hành động khi button được nhấn
                    },
                    icon: const Icon(Icons.facebook_rounded),
                    label: const Text(''),
                    style: OutlinedButton.styleFrom(
                      fixedSize: Size(169, 50),
                      side: const BorderSide(
                          color: Color.fromARGB(207, 182, 182, 227),
                          width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10)), // foreground border
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
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
    ));
  }
}
