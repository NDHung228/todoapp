import 'package:flutter/material.dart';

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
          padding: const EdgeInsets.all(20),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => {},
                    icon: Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.deepOrange.shade600),
                    iconSize: 30,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 30,
                      fontFamily: 'Lilita_One',
                      color: Color.fromARGB(255, 236, 19, 19),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Using  ",
                        ),
                        TextSpan(
                          text: 'marchisdev@gmail.com ',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: "to sign up.",
                        ),
                      ],
                      style: TextStyle(fontSize: 18),
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 107, 107, 107),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 56,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "YOUR NAME",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 136, 136, 136)),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Name",
                    fillColor: Colors.grey,
                    hintText: "Enter your name",
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blue.shade600, width: 2),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "YOUR PASSWORD",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 136, 136, 136)),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Password",
                      fillColor: Colors.grey,
                      hintText: "Enter your password",
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.blue.shade600, width: 2))),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "CONFIRM PASSWORD",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 136, 136, 136)),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Confirm password",
                      fillColor: Colors.grey,
                      hintText: "Enter your password",
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.blue.shade600, width: 2))),
                ),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () => {},
                  style: ButtonStyle(
                      fixedSize: const MaterialStatePropertyAll(Size(370, 60)),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.deepOrange.shade600)),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                SizedBox(
                  height: 150,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?'),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 35),
                        backgroundColor: Colors.white,
                        elevation: 0,
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 211, 57, 33),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
