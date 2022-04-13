import 'package:flutter/material.dart';


class MensajePage extends StatelessWidget {
  const MensajePage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)?.settings.arguments ?? 'No data';

    return Scaffold(
      appBar: AppBar(
        title: Text('Message'),
      ),
      body: Center(
        child: Text( '$args' , style: TextStyle(fontSize: 30)),
      ),
    );
  
  }
}