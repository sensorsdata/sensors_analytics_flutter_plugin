
import 'package:flutter/material.dart';

class Page2 extends StatefulWidget {
  const Page2({ Key? key }) : super(key: key);

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: const Text('Page2'),
        ),
      ),
      body: ListView(
        children: [
          Container(
            height: 100,
            child: Center(
              child: Text('Page2'),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: ElevatedButton(
              onPressed: () {
                print('Test Tap');
              },
              child: Text('Test Tap')
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/page3');
              },
              child: Text('push To Page3')
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/page3', (route) {
                  return route.settings.name == '/';
                });
              },
              child: Text('pushNamedAndRemove To Page3')
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: ElevatedButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, '/page3');
              },
              child: Text('popAndPushNamed To Page3')
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/page3');
              },
              child: Text('pushReplacementNamed To Page3')
            ),
          ),
        ],
      ),
    );
  }
}