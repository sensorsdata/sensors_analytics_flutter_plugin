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

终端执行命令

```shell
  flutter packages get sensors_analytics_flutter_plugin 
  flutter packages upgrade sensors_analytics_flutter_plugin
```

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
## Android

## iOS

**初始化 SDK**

 ```objective-c
 #import "SensorsAnalyticsSDK.h"

#ifdef DEBUG
#define SA_SERVER_URL @"<#【测试项目】数据接收地址#>"
#define SA_DEBUG_MODE SensorsAnalyticsDebugAndTrack
#else
#define SA_SERVER_URL @"<#【正式项目】数据接收地址#>"
#define SA_DEBUG_MODE SensorsAnalyticsDebugOff
#endif

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

[self initSensorsAnalyticsWithLaunchOptions:launchOptions];
return YES;
}

- (void)initSensorsAnalyticsWithLaunchOptions:(NSDictionary *)launchOptions {
// 初始化 SDK
[SensorsAnalyticsSDK sharedInstanceWithServerURL:SA_SERVER_URL
andLaunchOptions:launchOptions

// 打开自动采集, 并指定追踪哪些 AutoTrack 事件 
//目前 autoTrack flutter 只支持 $AppStart 和 $AppEnd
[[SensorsAnalyticsSDK sharedInstance] enableAutoTrack:SensorsAnalyticsEventTypeAppStart|
SensorsAnalyticsEventTypeAppEnd];

}
 ```
**开启需要的 subspecs** 

修改 Pod 中 SensorsAnalyticsSDK 项目的编译选项，如下图：
![](https://www.sensorsdata.cn/manual/img/ios_autotrack_1.png)


## dart 代码中使用插件
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