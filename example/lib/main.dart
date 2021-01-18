import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _distinctId = '';
  var parameters;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String distinctId = "";

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      distinctId = await SensorsAnalyticsFlutterPlugin.getDistinctId;
    } on PlatformException {
      distinctId = 'Failed to get distinctId.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _distinctId = distinctId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Plugin for Sensors Analytics.'),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              title: Text(_distinctId ?? ""),
              onTap: () {},
            ),
            ListTile(
              title: Text(
                  'This is the official Flutter Plugin for Sensors Analytics.'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('注册成功/登录成功时调用 login '),
              onTap: () {
                SensorsAnalyticsFlutterPlugin.login('传入你们服务端分配给用户的登录 ID');
              },
            ),
            ListTile(
              leading: Icon(Icons.event),
              title: Text('触发激活事件 trackInstallation '),
              onTap: () {
                SensorsAnalyticsFlutterPlugin.trackInstallation(
                    'AppInstall', <String, dynamic>{
                  "a_time": DateTime.now(),
                  "product_name": "Apple 12 max pro"
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.event),
              title: Text('追踪事件 track'),
              onTap: () {
                print("======触发事件233");
                SensorsAnalyticsFlutterPlugin.track(
                    'ViewProduct', <String, dynamic>{
                  "a_time": DateTime.now(),
                  "product_name": "Apple 12 max pro"
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.assessment),
              title: Text('设置用户属性 profileSet2'),
              onTap: () {
                SensorsAnalyticsFlutterPlugin.profileSet(
                    {'Age': 18, 'Sex': 'Male', "a_time": DateTime.now()});
              },
            ),
            ListTile(
              leading: Icon(Icons.assessment),
              title: Text('设置用户推送 ID 到用户表'),
              onTap: () {
                SensorsAnalyticsFlutterPlugin.profilePushId(
                    "jgId", "12312312312");
              },
            ),
            ListTile(
              leading: Icon(Icons.assessment),
              title: Text('删除用户设置的 pushId'),
              onTap: () {
                SensorsAnalyticsFlutterPlugin.profileUnsetPushId("jgId");
              },
            ),
            ListTile(
              title: Text("合规功能测试"),
              onTap: () {
                SensorsAnalyticsFlutterPlugin.enableDataCollect();
              },
            ),
            ListTile(
              title: Text(
                  'https://github.com/sensorsdata/sensors_analytics_flutter_plugin'),
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }
}
