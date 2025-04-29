import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';
import 'package:sensorsanalyticsflutterplugin_example/home.dart';
import 'package:sensorsanalyticsflutterplugin_example/page2.dart';
import 'package:sensorsanalyticsflutterplugin_example/page3.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ignore: unused_field
  String? _distinctId = '';
  var parameters;

  @override
  void initState() {
    // 初始化 SDK
    startSensorsAnalyticsSDK();
    initPlatformState();

    super.initState();
  }

  void startSensorsAnalyticsSDK() {
    SensorsAnalyticsFlutterPlugin.init(
        serverUrl: "http://10.1.137.85:8106/sa?project=default",
        autoTrackTypes: <SAAutoTrackType>{
          SAAutoTrackType.APP_START,
          SAAutoTrackType.APP_VIEW_SCREEN,
          SAAutoTrackType.APP_CLICK,
          SAAutoTrackType.APP_END
        },
        networkTypes: <SANetworkType>{
          SANetworkType.TYPE_2G,
          SANetworkType.TYPE_3G,
          SANetworkType.TYPE_4G,
          SANetworkType.TYPE_WIFI,
          SANetworkType.TYPE_5G
        },
        flushInterval: 30000,
        flushBulkSize: 150,
        enableLog: true,
        javaScriptBridge: true,
        // encrypt: true,
        android: AndroidConfig(
            maxCacheSize: 48 * 1024 * 1024,
            jellybean: true,
            subProcessFlush: true),
        ios: IOSConfig(maxCacheSize: 10000),
        web: WebConfig(
            publicKey:
                '040db1c4d70c229425134d588cf9d5126815ceda1cb2f72e63f3f29e8974c28d10929d341ee2a21fba224dea13ee2d8b5f98b4bbbd6c887d0bba0a20a190c95c57',
            pkv: 4),
        // harmony: HarmonyConfig(
        //     publicKey:
        //         'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxvWpPH0xvwsOlwzlO0DlUnCfINouVAl1fsLhzUMEqYiDyy1C6VS7y3sJt8+INvXL/ZZ5x9J+NoAlYN0Dsuoe0qwgNasVvzcP0hS7O8pEse3yqixhl8p8pSP0Sm6merVE/rxTK9tUfRRyXKKyvOxGWqlYk5SKtt4TkAjOYtMvLBVmd0pezLN+JimcTw2/MxV+S1P1oD9MDqiCFWT7FOcX9l0ejirLI/AeKIZubjeaWrmriCdqHqtBXrfr2d2JykZZeNUEhf8PKJH51PK7QkDWqsD99Jo1gC+QP91NtFLwrgjaNZ9hoE6OgSs0RpBXtFlaP7FxNwUYzb6txXY+Ge41nwIDAQAB',
        //     pkv: 4,
        //     maxCacheSize: 20000),
        globalProperties: {
          'current_platform': Platform.operatingSystem,
          'global_properties': 'Flutter 全局属性'
        },
        autoTrackConfig: SAAutoTrackConfig(pageConfigs: [
          SAAutoTrackPageConfig<Home>(
              title: '首页', screenName: '首页', properties: {'page': 'home'}),
        ]));
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String? distinctId = "";

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
      navigatorObservers: SANavigatorObserver.wrap([]),
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/page2': (context) => Page2(),
        '/page3': (context) => Page3(),
      },
    );
  }
}
