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
      appBar: AppBar(
        title: const Text(
          'Forgot password',
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
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
                const Text(
                  'Enter email address',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 36,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "   Email",
                    fillColor: Colors.grey,
                    hintText: "example@gmail.com",
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Đường viền cong
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blue.shade600, width: 2),
                      borderRadius:
                          BorderRadius.circular(30), // Đường viền cong
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(100, 35),
                    backgroundColor: Colors.white,
                    elevation: 0,
                  ),
                  child: const Text(
                    'Back to sign in',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 101, 100, 100),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(400, 60),
                    backgroundColor: Colors.red,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Send',
                    style: TextStyle(
                      fontSize: 22,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 250,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: TextStyle(fontSize: 16),
                    ),
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
                          fontSize: 16,
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
