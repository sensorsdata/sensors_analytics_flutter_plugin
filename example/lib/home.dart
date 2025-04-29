import 'package:flutter/material.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_autotrack_config.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? _distinctId = '';
  @override
  Widget build(BuildContext context) {
    late dynamic tmpResult;
    // TODO: implement build
    return Scaffold(
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
            key: SAElementKey('key1',
                properties: {'key1': 'value1'}, isIgnore: false),
            leading: Icon(Icons.account_circle),
            title: Text('跳转到 page2'),
            onTap: () {
              Navigator.pushNamed(context, '/page2');
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('注册成功/登录成功时调用 login '),
            onTap: () {
              SensorsAnalyticsFlutterPlugin.login(
                  "flutter_lgoin_test123654", {"hello": "world"});
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

              dynamic a = "aaa";
              print(a is String);
              String? b = "bbb";
              dynamic c = b;
              print(c.runtimeType);
              print(c is String);
              print(c is! String);
              print(c is String?);
              print("======");
              dynamic d = null;
              print(d.runtimeType);
              print(d is String);
              print(d is! String);
              print(d is String?);

              // SensorsAnalyticsFlutterPlugin.track(
              //     'ViewProduct', <String, dynamic>{
              //   "a_time": DateTime.now(),
              //   "product_name": "Apple 12 max pro"
              // });
              var map = {"address": "beijing"};
              SensorsAnalyticsFlutterPlugin.track("hello", map);
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
            title: Text(
                'https://github.com/sensorsdata/sensors_analytics_flutter_plugin'),
            onTap: () {},
          ),
          ListTile(
            title: Text('set server url'),
            onTap: () async {
              SensorsAnalyticsFlutterPlugin.setServerUrl(
                  "https://newsdktest.datasink.sensorsdata.cn/sa?project=zhujiagui&token=5a394d2405c147ca",
                  true);
            },
          ),
          ListTile(
            title: Text('getPresetProperties'),
            onTap: () async {
              dynamic map =
                  await SensorsAnalyticsFlutterPlugin.getPresetProperties();
              print("getPresetProperties===$map");
            },
          ),
          ListTile(
            title: Text('enableLog'),
            onTap: () async {
              SensorsAnalyticsFlutterPlugin.enableLog(false);
              print("enableLog==333=");
            },
          ),
          ListTile(
            title: Text('setFlushNetworkPolicy'),
            onTap: () async {
              SensorsAnalyticsFlutterPlugin.setFlushNetworkPolicy(
                  <SANetworkType>{SANetworkType.TYPE_WIFI});
              print("setFlushNetworkPolicy===");
            },
          ),
          ListTile(
            title: Text('setFlushInterval'),
            onTap: () async {
              SensorsAnalyticsFlutterPlugin.setFlushInterval(60 * 1000);
              print("setFlushInterval===");
            },
          ),
          ListTile(
            title: Text('getFlushInterval'),
            onTap: () async {
              dynamic result =
                  await SensorsAnalyticsFlutterPlugin.getFlushInterval();
              print("getFlushInterval===$result");
            },
          ),
          ListTile(
            title: Text('setFlushBulkSize'),
            onTap: () async {
              SensorsAnalyticsFlutterPlugin.setFlushInterval(60 * 60 * 1000);
              SensorsAnalyticsFlutterPlugin.setFlushBulkSize(100);
              print("setFlushBulkSize===");
              dynamic result =
                  await SensorsAnalyticsFlutterPlugin.getFlushBulkSize();
              print("getFlushBulkSize===$result");
              for (int index = 0; index <= 100; index++) {
                SensorsAnalyticsFlutterPlugin.track(
                    'ViewProduct2', <String, dynamic>{
                  "a_time": DateTime.now(),
                  "product_name": "Apple 12 max pro"
                });
              }
              print("track end=====");
            },
          ),
          ListTile(
            title: Text('getFlushBulkSize'),
            onTap: () async {
              dynamic result =
                  await SensorsAnalyticsFlutterPlugin.getFlushBulkSize();
              print("getFlushBulkSize===$result");
            },
          ),
          ListTile(
            title: Text('getAnonymousId'),
            onTap: () async {
              dynamic result =
                  await SensorsAnalyticsFlutterPlugin.getAnonymousId();
              print("getAnonymousId===$result");
            },
          ),
          ListTile(
            title: Text('getLoginId'),
            onTap: () async {
              //SensorsAnalyticsFlutterPlugin.login("aa212132");
              dynamic result = await SensorsAnalyticsFlutterPlugin.getLoginId();
              print("getLoginId===$result");
            },
          ),
          ListTile(
            title: Text('identify'),
            onTap: () async {
              SensorsAnalyticsFlutterPlugin.identify("qwe");
              print("identify===");
            },
          ),
          ListTile(
            title: Text('trackAppInstall'),
            onTap: () async {
              SensorsAnalyticsFlutterPlugin.trackAppInstall(
                  {"age": 888}, false);
              print("trackAppInstall==");
            },
          ),
          ListTile(
            title: Text('trackViewScreen'),
            onTap: () async {
              SensorsAnalyticsFlutterPlugin.trackViewScreen(
                  'test_screen', {"name": 'trackViewScreen 触发测试'});
              print("trackViewScreen==");
            },
          ),
          ListTile(
            title: Text('trackTimerStart'),
            onTap: () async {
              tmpResult = await SensorsAnalyticsFlutterPlugin.trackTimerStart(
                  "hello_event");
              print("trackTimerStart===$tmpResult");
            },
          ),
          ListTile(
            title: Text('trackTimerPause'),
            onTap: () async {
              SensorsAnalyticsFlutterPlugin.trackTimerPause("hello_event");
              print("trackTimerPause===");
            },
          ),
          ListTile(
            title: Text('trackTimerResume'),
            onTap: () async {
              SensorsAnalyticsFlutterPlugin.trackTimerResume("hello_event");
              print("trackTimerResume===");
            },
          ),
          ListTile(
            title: Text('removeTimer'),
            onTap: () async {
              SensorsAnalyticsFlutterPlugin.removeTimer("hello_event");
              print("removeTimer===");
            },
          ),
          ListTile(
            title: Text('clearTimer'),
            onTap: () async {
              SensorsAnalyticsFlutterPlugin.clearTrackTimer();
              print("clearTimer ===");
            },
          ),
          ListTile(
            title: Text('timerEnd'),
            onTap: () async {
              SensorsAnalyticsFlutterPlugin.trackTimerEnd(tmpResult, null);
              print("timerEnd===");
            },
          ),
          ListTile(
            title: Text('flush'),
            onTap: () async {
              SensorsAnalyticsFlutterPlugin.flush();
              print("flush===");
            },
          ),
          ListTile(
            title: Text('deleteAll'),
            onTap: () async {
              SensorsAnalyticsFlutterPlugin.deleteAll();
              print("deleteAll===");
            },
          ),
          ListTile(
            title: Text('setsuperproperties'),
            onTap: () async {
              var map = {
                "superproperties_test": "flutter 注册公共属性",
                "aaa": "同名公共属性 aaa"
              };
              SensorsAnalyticsFlutterPlugin.registerSuperProperties(map);
              print("setSuperProperties===");
            },
          ),
          ListTile(
            title: Text('getSuperProperties'),
            onTap: () async {
              dynamic map =
                  await SensorsAnalyticsFlutterPlugin.getSuperProperties();
              print("getSuperProperties===$map");
            },
          ),
          ListTile(
            title: Text('clearSuperProperties'),
            onTap: () async {
              SensorsAnalyticsFlutterPlugin.clearSuperProperties();
              print("clearSuperProperties===");
            },
          ),
          ListTile(
            title: Text('unregisterSuperProperty'),
            onTap: () async {
              SensorsAnalyticsFlutterPlugin.unregisterSuperProperty('aaa');
              print("unregisterSuperProperty===aaa");
            },
          ),
          ListTile(
            title: Text('enableNetworkRequest'),
            onTap: () async {
              SensorsAnalyticsFlutterPlugin.enableNetworkRequest(true);
              print("enableNetworkRequest===");
            },
          ),
          ListTile(
            title: Text('itemSet'),
            onTap: () async {
              SensorsAnalyticsFlutterPlugin.itemSet(
                  "aaatype", "aaaid", {"age": 999});
              print("itemSet===");
            },
          ),
          ListTile(
            title: Text('itemDelete'),
            onTap: () async {
              SensorsAnalyticsFlutterPlugin.itemDelete("aaatype", "aaaid");
              print("itemDelete===");
            },
          ),
          ListTile(
            title: Text('isNetworkRequestEnable'),
            onTap: () async {
              dynamic result =
                  await SensorsAnalyticsFlutterPlugin.isNetworkRequestEnable();
              print("isNetworkRequestEnable===$result");
            },
          ),
          ListTile(
            title: Text('logout'),
            onTap: () async {
              SensorsAnalyticsFlutterPlugin.logout();
              print("logout===");
            },
          ),
          ListTile(
            title: Text('bind'),
            onTap: () async {
              SensorsAnalyticsFlutterPlugin.bind("sss1", "vvv1");
              print("bind===");
            },
          ),
          ListTile(
            title: Text('unbind'),
            onTap: () async {
              SensorsAnalyticsFlutterPlugin.unbind("sss2", "vvv2");
              print("unbind===");
            },
          ),
          ListTile(
            title: Text('loginwithkey'),
            onTap: () async {
              SensorsAnalyticsFlutterPlugin.loginWithKey("sss3", "vvv3");
              //SensorsAnalyticsFlutterPlugin.loginWithKey("sss3", "vvv3", {"p1111": "vvvv1"});
              print("loginwithkey===");
            },
          ),
          ListTile(
            title: Text('isAutoTrackEventTypeIgnored'),
            onTap: () async {
              bool click = await SensorsAnalyticsFlutterPlugin
                  .isAutoTrackEventTypeIgnored(SAAutoTrackType.APP_CLICK);
              bool end = await SensorsAnalyticsFlutterPlugin
                  .isAutoTrackEventTypeIgnored(SAAutoTrackType.APP_END);
              bool start = await SensorsAnalyticsFlutterPlugin
                  .isAutoTrackEventTypeIgnored(SAAutoTrackType.APP_START);
              bool screen = await SensorsAnalyticsFlutterPlugin
                  .isAutoTrackEventTypeIgnored(SAAutoTrackType.APP_VIEW_SCREEN);

              //SensorsAnalyticsFlutterPlugin.loginWithKey("sss3", "vvv3", {"p1111": "vvvv1"});
              print(
                  "isAutoTrackEventTypeIgnored====$click====$end====$start====$screen");
            },
          ),
        ],
      ),
    );
  }
}
