// main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todolist',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 4 text editing controllers that associate with the 4 input fields
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  final TextEditingController _fieldFive = TextEditingController();
  final TextEditingController _fieldSix = TextEditingController();

  // This is the entered code
  // It will be displayed in a Text widget
  String? _otp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todolist'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 25.0),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Verify the Authorization Code',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.only(left: 25.0),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Sent to 04982437402',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
            ),
          ),

          // Implement 4 input fields
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OtpInput(_fieldOne, true), // auto focus
              OtpInput(_fieldTwo, false),
              OtpInput(_fieldThree, false),
              OtpInput(_fieldFour, false),
              OtpInput(_fieldFive, false),
              OtpInput(_fieldSix, false)
            ],
          ),

          const SizedBox(
            height: 30,
          ),
          // Display the entered OTP code
          Container(
            padding: const EdgeInsets.only(left: 25.0),
            alignment: Alignment.centerLeft,
            child: const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Resend Authorization Code ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: 'in 0 sec',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _otp = _fieldOne.text +
                    _fieldTwo.text +
                    _fieldThree.text +
                    _fieldFour.text +
                    _fieldFive.text +
                    _fieldSix.text;
              });
            },
            style: ElevatedButton.styleFrom(minimumSize: const Size(100, 45)),
            child: const Text(
              'Submit',
              style: TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(100, 45),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            child: const Text(
              'Skip',
              style: TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 25, 143, 240),
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Create an input widget that takes only one digit
class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  const OtpInput(this.controller, this.autoFocus, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 45,
      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        cursorColor: Theme.of(context).primaryColor,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            counterText: '',
            hintStyle: TextStyle(color: Colors.black, fontSize: 50.0)),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
