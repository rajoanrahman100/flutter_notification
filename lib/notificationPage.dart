import 'package:flutter/material.dart';

class NewPage extends StatelessWidget {

 final String? payload;

  const NewPage({Key? key,  required this.payload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.amber,
        title: Text("$payload"),
      ),
    );
  }
}
