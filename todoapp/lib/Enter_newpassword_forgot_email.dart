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
      appBar: AppBar(
        title: const Text(
          'New Password',
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
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 10),
                  child: const Text(
                    'Enter new password',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "   Password",
                    fillColor: Colors.grey,
                    hintText: "Enter password",
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
                  height: 30,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 10),
                  child: const Text(
                    'Confirm password',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "   Confirm password",
                    fillColor: Colors.grey,
                    hintText: "Enter confirm password",
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
                  height: 60,
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
                    'Submit',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
