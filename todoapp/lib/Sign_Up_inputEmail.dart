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
                  child: ElevatedButton(
                    onPressed: () => {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      elevation: MaterialStateProperty.all(0),
                      padding: const MaterialStatePropertyAll(
                        EdgeInsets.all(0),
                      ),
                    ),
                    child: Text(
                      "Close",
                      style: TextStyle(
                          color: Colors.deepOrange.shade600,
                          fontWeight: FontWeight.w400,
                          fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "What your email address?",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "YOUR EMAIL",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Email",
                      fillColor: Colors.grey,
                      hintText: "Enter your email",
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue.shade600, width: 2))),
                ),
                const SizedBox(
                  height: 36,
                ),
                ElevatedButton(
                  onPressed: () => {},
                  style: ButtonStyle(
                      fixedSize: MaterialStatePropertyAll(Size(370, 50)),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.deepOrange.shade600)),
                  child: const Text(
                    "Continue with email",
                    style: TextStyle(fontSize: 22),
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
