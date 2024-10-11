// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class UserInputPage extends StatefulWidget {
  const UserInputPage({super.key});

  @override
  State<UserInputPage> createState() => _UserInputPageState();
}

class _UserInputPageState extends State<UserInputPage> {
  TextEditingController myController = TextEditingController();

  String message = "";

  void greetUser() {
    String userInput = myController.text;
    setState(() {
      message = userInput;
      myController.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("ToDo list"),
          TextField(
            controller: myController,
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: "Input your todo task"),
          ),
          ElevatedButton(onPressed: greetUser, child: Text("Tap")),
          Text(message),
        ],
      ),
    )));
  }
}
