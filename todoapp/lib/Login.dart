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
                  alignment: Alignment.center,
                  child: Text(
                    "Log in",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 60,
                        fontFamily: 'Lilita_One',
                        color: Color.fromARGB(255, 236, 19, 19)),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 56,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "USERNAME",
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
                    labelText: "Username",
                    fillColor: Colors.grey,
                    hintText: "Enter your username",
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
                    "PASSWORD",
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
                  height: 15,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.all(0),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 45),
                      backgroundColor: Colors.white,
                      elevation: 0,
                    ),
                    child: const Text(
                      'FORGOT PASSWORD',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 211, 57, 33),
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
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
                    "Login",
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                SizedBox(
                  height: 150,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account?'),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 35),
                        backgroundColor: Colors.white,
                        elevation: 0,
                      ),
                      child: const Text(
                        'Create account',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 211, 57, 33),
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
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
