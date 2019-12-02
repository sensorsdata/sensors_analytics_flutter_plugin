
神策 [`sensors_analytics_flutter_plugin`](https://pub.dartlang.org/packages/sensors_analytics_flutter_plugin) 插件，封装了神策 iOS & Android SDK 常用 API ，使用此插件，可以完成埋点的统计上报。

## 1. 在项目中添加安装插件
在 Flutter 项目的 `pubspec.yam` 文件中添加 `sensors_analytics_flutter_plugin` 依赖

```yml
dependencies:
  # 添加神策 flutter plugin 
  sensors_analytics_flutter_plugin: any
```

执行 flutter packages get 命令安装插件

```shell
  flutter packages get  
```


[Flutter 官网文档](https://flutter.io/docs)
## 2. Android 端
在程序的入口 **Application** 的 `onCreate()` 中调用 `SensorsDataAPI.sharedInstance()` 初始化 SDK：

```java
import io.flutter.app.FlutterApplication;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import com.sensorsdata.analytics.android.sdk.SensorsDataAPI;
import org.json.JSONObject;
import java.util.ArrayList;
import java.util.List;

public class App extends FlutterApplication {

    // debug 模式的数据接收地址 （测试，测试项目）
    final static String SA_SERVER_URL_DEBUG = "【测试项目】数据接收地址";

    // release 模式的数据接收地址（发版，正式项目）
    final static String SA_SERVER_URL_RELEASE = "【正式项目】数据接收地址";

    // SDK Debug 模式选项
    //   SensorsDataAPI.DebugMode.DEBUG_OFF - 关闭 Debug 模式
    //   SensorsDataAPI.DebugMode.DEBUG_ONLY - 打开 Debug 模式，校验数据，但不进行数据导入
    //   SensorsDataAPI.DebugMode.DEBUG_AND_TRACK - 打开 Debug 模式，校验数据，并将数据导入到 Sensors Analytics 中
    // TODO 注意！请不要在正式发布的 App 中使用 DEBUG_AND_TRACK /DEBUG_ONLY 模式！ 请使用 DEBUG_OFF 模式！！！

    // debug 时，初始化 SDK 使用测试项目数据接收 URL 、使用 DEBUG_AND_TRACK 模式；release 时，初始化 SDK 使用正式项目数据接收 URL 、使用 DEBUG_OFF 模式。
    private boolean isDebugMode;

    @Override
    public void onCreate() {
        super.onCreate();
        // 在 Application 的 onCreate 初始化神策 SDK
        initSensorsDataSDK(this);
    }

    /**
     * 初始化 SDK 、开启自动采集
     */
    private void initSensorsDataSDK(Context context) {
        try {
            // 初始化 SDK
            SensorsDataAPI.sharedInstance(
                    context,                                                                                  // 传入 Context
                    (isDebugMode = isDebugMode(context)) ? SA_SERVER_URL_DEBUG : SA_SERVER_URL_RELEASE,       // 数据接收的 URL
                    isDebugMode ? SensorsDataAPI.DebugMode.DEBUG_AND_TRACK : SensorsDataAPI.DebugMode.DEBUG_OFF); // Debug 模式选项

            // 打开自动采集, 并指定追踪哪些 AutoTrack 事件
            List<SensorsDataAPI.AutoTrackEventType> eventTypeList = new ArrayList<>();
            eventTypeList.add(SensorsDataAPI.AutoTrackEventType.APP_START);// $AppStart（启动事件）
            eventTypeList.add(SensorsDataAPI.AutoTrackEventType.APP_END);// $AppEnd（退出事件）
            SensorsDataAPI.sharedInstance().enableAutoTrack(eventTypeList);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * @param context App 的 Context
     * @return debug return true,release return false
     * 用于判断是 debug 包，还是 relase 包
     */
    public static boolean isDebugMode(Context context) {
        try {
            ApplicationInfo info = context.getApplicationInfo();
            return (info.flags & ApplicationInfo.FLAG_DEBUGGABLE) != 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}

```

## 3. iOS 端

在程序的入口（如 AppDelegate.m ）中引入 `SensorsAnalyticsSDK.h`，并在初始化方法（如 `- application:didFinishLaunchingWithOptions:launchOptions` ）中调用 `startWithConfigOptions:` 主线程同步初始化 SDK。


 ```objective-c
#import "SensorsAnalyticsSDK.h"

#ifdef DEBUG
#define SA_SERVER_URL @"<#【测试项目】数据接收地址#>"
#else
#define SA_SERVER_URL @"<#【正式项目】数据接收地址#>"
#endif

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self initSensorsAnalyticsWithLaunchOptions:launchOptions];
    return YES;
}

- (void)initSensorsAnalyticsWithLaunchOptions:(NSDictionary *)launchOptions {
    // 设置神策 SDK 自动采集 options（Flutter 项目只支持 App 启动、退出自动采集）
    SAConfigOptions *options = [[SAConfigOptions alloc] initWithServerURL:SA_SERVER_URL launchOptions:launchOptions];
    options.autoTrackEventType = SensorsAnalyticsEventTypeAppStart | SensorsAnalyticsEventTypeAppEnd;
    // 需要在主线程中初始化 SDK
    [SensorsAnalyticsSDK startWithConfigOptions:options];
}

## 4. Flutter 中使用插件
在具体 dart 文件中导入 `sensors_analytics_flutter_plugin.dart`

```dart
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';
```
### 4.1 埋点事件

例如，触发事件名为 AddToFav ，对应的事件属性有：ProductID 和 UserLevel 的事件：

```dart
SensorsAnalyticsFlutterPlugin.track("AddToFav",{"ProductID":123456,"UserLevel":"VIP"});
```

### 4.2 设置用户属性

例如，设置用户 Age 属性：

```dart
SensorsAnalyticsFlutterPlugin.profileSet({"Age":18});
```
