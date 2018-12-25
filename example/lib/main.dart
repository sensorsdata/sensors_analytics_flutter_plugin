import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _distinctId = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    String distinctId;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
     // platformVersion = await SensorsAnalyticsFlutterPlugin.platformVersion;
      distinctId = await SensorsAnalyticsFlutterPlugin.distinctId;
     SensorsAnalyticsFlutterPlugin.track('FutterEventTest',{'key1':null,'key2':'value2'});
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
      distinctId = 'Failed to get distinctId.';

    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _distinctId = distinctId;

    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Plugin example app: $_distinctId'),
        ),
        //body: Center(
        //  child: Text('Running on: $_platformVersion\n'),
        //),
        body: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.map),
              title: Text(_distinctId),
              onTap: (){},
            ),
            ListTile(
              leading: Icon(Icons.photo_album),
              title: Text('track'),
              onTap: (){ SensorsAnalyticsFlutterPlugin.track('Cell_1_Click',{'key1':null,'key2':'value2'});},
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('trackTimerStart'),
              onTap: (){ SensorsAnalyticsFlutterPlugin.trackTimerStart('TestTrackTimer');},
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('trackTimerEnd'),
              onTap: (){ SensorsAnalyticsFlutterPlugin.trackTimerEnd('Cell_2_Click',{'key1':null,'key2':'value2'});},
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('clearTrackTimer'),
              onTap: (){ SensorsAnalyticsFlutterPlugin.clearTrackTimer();},
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('login'),
              onTap: (){ SensorsAnalyticsFlutterPlugin.login('NewID_uid');},
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('logout'),
              onTap: (){ SensorsAnalyticsFlutterPlugin.logout;},
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('trackViewScreenWithUrl'),
              onTap: (){ SensorsAnalyticsFlutterPlugin.trackViewScreenWithUrl('trackViewScreenWithUrl',{'key1':null,'key2':'value2'});},
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('profileSet'),
              onTap: (){ SensorsAnalyticsFlutterPlugin.profileSet({'name':'liming','age':100,'address':['beijing','hunan']});},
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('profileSetOnce'),
              onTap: (){ SensorsAnalyticsFlutterPlugin.profileSetOnce({'key1':'value1','key2':'value2'});},
            ), 
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('profileUnset'),
              onTap: (){ SensorsAnalyticsFlutterPlugin.profileUnset('key1');},
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('profileIncrement'),
              onTap: (){ SensorsAnalyticsFlutterPlugin.profileIncrement('age',10);},
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('profileAppend'),
              onTap: (){ SensorsAnalyticsFlutterPlugin.profileAppend('address',['shanghai','guangzhou']);},
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('profileDelete'),
              onTap: (){ SensorsAnalyticsFlutterPlugin.profileDelete();},
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('clearKeychainData'),
              onTap: (){ SensorsAnalyticsFlutterPlugin.clearKeychainData();},
            ),
          ],
        ),
      ),
    );
  }
}
