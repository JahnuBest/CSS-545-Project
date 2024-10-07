import 'package:cs_545_jahnu_best/second_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Hello World!'),
        ),
        body: Center(
          child: Column (
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Click this button to go to the Second Page'),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SecondPage()),
              );
            }, 
            child: const Text('Go to Second Page'))
          ],)
        )
      );
  }
}
