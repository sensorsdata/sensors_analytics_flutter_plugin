import 'package:flutter/material.dart';

class Page3 extends StatefulWidget {
  const Page3({ Key? key }) : super(key: key);

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page3'),
      ),
      body: ListView(
        children: [
          Container(
            height: 300,
            child: Center(
              child: Text('Page3'),
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
                Navigator.pop(context);
              },
              child: Text('pop to page2')
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) {
                  return route.settings.name == '/page2';
                });
              },
              child: Text('popUntil to page2')
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            child: InkWell (
              onTap: () {
                print('InkWell test');
              },
              child: Text('InkWell test', textAlign: TextAlign.center, style: TextStyle(color: Colors.red),) 
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: GestureDetector (
              onTap: () {
                print('GestureDetector test');
              },
              child: Text('GestureDetector test', textAlign: TextAlign.center, style: TextStyle(color: Colors.blue),)
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) {
                  return route.settings.name == '/';
                });
              },
              child: Text('Back Home')
            ),
          ),
        ],
      ),
    );
  }
}