# sensors_analytics_flutter_plugin

SensorsAnalyticsSDK 的 [Flutter](https://flutter.io) 插件.
同时支持 iOS & Android.

* track()
* getDistinctId()
* trackInstallation()
* profileSet()

## 工程中添加插件
在 flutter 工程添加 dependency:

```yml
dependencies:
  ...
  sensors_analytics_flutter_plugin: any
```

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.

## dart 代码中引用插件
Import `sensors_analytics_flutter_plugin.dart`

```dart
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';
```
## Demo Code
```dart
      String distinctId;
    // distinctId messages may fail, so we use a try/catch PlatformException.
    try {
      distinctId = await SensorsAnalyticsFlutterPlugin.distinctId;
    } on PlatformException {
      distinctId = 'Failed to get distinctId.';
    }

    SensorsAnalyticsFlutterPlugin.track('Cell_1_Click',{'key1':null,'key2':'value2'});
    SensorsAnalyticsFlutterPlugin.trackTimerStart('TestTrackTimer');
    SensorsAnalyticsFlutterPlugin.trackTimerEnd('Cell_2_Click',{'key1':null,'key2':'value2'});
    SensorsAnalyticsFlutterPlugin.clearTrackTimer();
    SensorsAnalyticsFlutterPlugin.trackInstallation('AppInstall',{});
    SensorsAnalyticsFlutterPlugin.login('NewID_uid');
    SensorsAnalyticsFlutterPlugin.logout();
    SensorsAnalyticsFlutterPlugin.trackViewScreen('UrlForViewScreen',{'key1':null,'key2':'value2'});
    SensorsAnalyticsFlutterPlugin.profileSet({'name':'liming','age':100,'address':['beijing','hunan']});
    SensorsAnalyticsFlutterPlugin.profileSetOnce({'key1':'value1','key2':'value2'});
    SensorsAnalyticsFlutterPlugin.profileUnset('key1');
    SensorsAnalyticsFlutterPlugin.profileIncrement('age',10);
    SensorsAnalyticsFlutterPlugin.profileAppend('address',['shanghai','guangzhou']);
    SensorsAnalyticsFlutterPlugin.profileDelete();

    //删除 SensorsAnalyticsSDK 存在 keychain 的数据，仅支持iOS
    SensorsAnalyticsFlutterPlugin.clearKeychainData();
```
