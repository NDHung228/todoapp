import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'Change_Password.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ChangePassword();
          }));
        },
        child: Text(
          "Change Password",
          style: TextStyle(fontSize: 15, color: Colors.blue),
        ),
      ),
    );
  }
}