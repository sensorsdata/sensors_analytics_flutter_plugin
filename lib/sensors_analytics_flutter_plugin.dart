export 'package:sensors_analytics_flutter_plugin/autotrack/pageview/sensors_pageview_observer.dart';
export 'package:sensors_analytics_flutter_plugin/sensors_autotrack_config.dart';

import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_autotrack.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_autotrack_config.dart';

class AndroidConfig {
  final int maxCacheSize;
  final bool jellybean;
  final bool subProcessFlush;

  ///配置 Android 部分功能。[maxCacheSize] 表示 Android 最大缓存量，单位是 byte。
  ///[jellybean] 表示是否支持 Android JellyBean 版本，JellyBean 版本的 WebView 存在安全性问题。
  ///[subProcessFlush] 表示 Android SDK 是否支持多进程上报数据。
  AndroidConfig(
      {this.maxCacheSize = 32 * 1024 * 1024,
      this.jellybean = false,
      this.subProcessFlush = false});

  Map<String, dynamic> get map => {
        "maxCacheSize": "$maxCacheSize",
        "jellybean": jellybean,
        "subProcessFlush": subProcessFlush
      };
}

class IOSConfig {
  final int maxCacheSize;

  ///配置 iOS 部分功能。[maxCacheSize] 表示 iOS 最大缓存事件数目，单位是“条”。
  IOSConfig({this.maxCacheSize = 10000});

  Map<String, dynamic> get map => {"maxCacheSize": maxCacheSize};
}

class WebConfig {
  final String publicKey;
  final int pkv;
  WebConfig({this.publicKey = '', this.pkv = -1});
  Map<String, dynamic> get map => {"publicKey": publicKey, 'pkv': pkv};
}

class VisualizedConfig {
  final bool autoTrack;
  final bool properties;

  ///配置可视化全埋点功能。[autotrack] 表示开启可视化全埋点，[properties] 表示开启可视化全埋点自定义属性功能。
  VisualizedConfig({this.autoTrack = false, this.properties = false});

  Map<String, dynamic> get map =>
      {"autoTrack": autoTrack, "properties": properties};
}

// 鸿蒙配置
class HarmonyConfig {
  // 公钥，默认使用 RSA + AES 加密
  final String publicKey;
  final int pkv;
  final int maxCacheSize;
  HarmonyConfig(
      {this.publicKey = '', this.pkv = -1, this.maxCacheSize = 10000});
  Map<String, dynamic> get map =>
      {"publicKey": publicKey, 'pkv': pkv, "maxCacheSize": maxCacheSize};
}

// This is the official Flutter Plugin for Sensors Analytics.
class SensorsAnalyticsFlutterPlugin {
  static const String FLUTTER_PLUGIN_VERSION = "4.0.0";
  static bool hasAddedFlutterPluginVersion = false;

  static Future<String?> get getDistinctId async {
    return await _channel.invokeMethod('getDistinctId');
  }

  /// Just for SDK inner used
  static MethodChannel get _channel =>
      ChannelManager.getInstance().methodChannel;

  /// 初始化神策 SDK。
  /// 用户需要尽可能早的调用该初始化方法，建议在 main() 方法中，不过至少要保证 Flutter 项目这段代码执行完毕：
  /// ```
  /// WidgetsFlutterBinding.ensureInitialized()
  /// ```
  /// 参考示例如下：
  /// ```
  /// void main(){
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///   SensorsAnalyticsFlutterPlugin.init(...);
  ///   runApp(MyApp());
  /// }
  /// ```
  /// 如果你不用 Flutter 全埋点功能，也可以放在合适位置进行初始化。另外如果 Native 中也执行了初始化，会以最先执行的为准。
  ///
  /// 参数定义如下：  <br/>
  /// [serverUrl]: 数据接收地址 <br/>
  /// [autoTrackTypes]: 全埋点类型 <br/>
  /// [networkTypes]: 数据上报的网络条件，HarmonyOS 暂不支持<br/>
  /// [flushInterval]: 数据上报的时间间隔，单位是毫秒，默认是 1500ms <br/>
  /// [flushBulkSize]：触发上报逻辑的事件数目，默认是 100 条 <br/>
  /// [enableLog]：是否开启本地 log，该配置只在 debug 阶段有效 <br/>
  /// [javaScriptBridge]: 是否支持 H5 打通，Android 中需要和 [AndroidConfig.jellybean] 配合使用 <br/>
  /// [encrypt]: 是否支持加密，Flutter 中初始化只支持 RSA+AES 加密，数据上报的网络条件，HarmonyOS 端使用 harmony 配置 <br/>
  /// [android]: Android 部分特有的配置 <br/>
  /// [ios]: iOS 部分特有的配置 <br/>
  /// [web]: Web 部分特有的配置 <br/>
  /// [harmony]: HarmonyOS 部分特有的配置 <br/>
  /// [visualized]: 可视化全埋点部分特有的配置，Flutter 暂不支持可视化，该配置会影响 Native，HarmonyOS 暂不支持 <br/>
  /// [heatMap]: 是否开启点击图，Flutter 暂不支持点击分析功能，该配置会影响 Native，HarmonyOS 暂不支持 <br/>
  static Future<void> init(
      {required String? serverUrl,
      Set<SAAutoTrackType>? autoTrackTypes,
      Set<SANetworkType>? networkTypes,
      int flushInterval = 15000,
      int flushBulkSize = 100,
      bool enableLog = false,
      bool javaScriptBridge = false,
      bool encrypt = false,
      AndroidConfig? android,
      IOSConfig? ios,
      WebConfig? web,
      HarmonyConfig? harmony,
      SAAutoTrackConfig? autoTrackConfig,
      Map? globalProperties}) async {
    Map<String, dynamic> initConfig = {
      "serverUrl": serverUrl ??
          () {
            assert(() {
              print(
                  "Server Url is empty, SDK will not upload data. You can call 'setServerUrl()' to set it later.");
              return true;
            }());
            return "";
          }(),
      "enableLog": enableLog,
      "javaScriptBridge": javaScriptBridge,
      "encrypt": encrypt,
      "flushInterval": flushInterval,
      "flushBulkSize": flushBulkSize,
      if (android != null) "android": android.map,
      if (ios != null) "ios": ios.map,
      if (web != null) "web": web.map,
      if (harmony != null) "harmony": harmony.map
    };

    if (autoTrackTypes != null) {
      int result = 0;
      autoTrackTypes.forEach((element) {
        switch (element) {
          case SAAutoTrackType.NONE:
            result |= 0;
            break;
          case SAAutoTrackType.APP_START:
            result |= 1;
            break;
          case SAAutoTrackType.APP_END:
            result |= 1 << 1;
            break;
          case SAAutoTrackType.APP_CLICK:
            result |= 1 << 2;
            SAAutoTrackManager.instance.enableElementClick(true);
            break;
          case SAAutoTrackType.APP_VIEW_SCREEN:
            result |= 1 << 3;
            SAAutoTrackManager.instance.enablePageView(true);
            break;
        }
      });
      initConfig["autotrackTypes"] = result;
    }

    if (networkTypes != null && networkTypes.isNotEmpty) {
      int result = 0;
      networkTypes.forEach((element) {
        switch (element) {
          case SANetworkType.TYPE_NONE:
            result |= 0;
            break;
          case SANetworkType.TYPE_2G:
            result |= 1;
            break;
          case SANetworkType.TYPE_3G:
            result |= 1 << 1;
            break;
          case SANetworkType.TYPE_4G:
            result |= 1 << 2;
            break;
          case SANetworkType.TYPE_5G:
            result |= 1 << 4;
            break;
          case SANetworkType.TYPE_WIFI:
            result |= 1 << 3;
            break;
          case SANetworkType.TYPE_ALL:
            result |= 0xFF;
            break;
        }
      });
      initConfig["networkTypes"] = result;
    }
    //全局公共属性配置
    initConfig["globalProperties"] = globalProperties;
    if (autoTrackConfig != null) {
      SAAutoTrackManager.instance.config = autoTrackConfig;
    }
    await _channel.invokeMethod("init", [initConfig]);
  }

  ///
  /// track
  /// 事件追踪
  ///
  /// @param eventName  String 事件名.
  /// @param properties Map<String,dynamic> 事件属性.
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.track('eventname',{'key1':'value1','key2':'value2'});
  ///
  static void track(String eventName, Map<String, dynamic>? properties) {
    properties = properties == null ? {} : {...properties};
    _convertDateTime(properties);
    _setupLibPluginVersion(properties);
    List<dynamic> params = [eventName, properties];
    try {
      _channel.invokeMethod('track', params);
    } catch (e) {
      print('Error invoking track method: $e');
    }
  }

  ///
  /// trackInstallation
  /// App 激活事件追踪，不支持 HarmonyOS 端
  ///
  /// @param eventName  String 通常为'AppInstall'.
  /// @param properties Map<String,dynamic> App 激活事件的属性.
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.trackInstallation('AppInstall',{'key1':'value1','key2':'value2'});
  ///
  static void trackInstallation(
      String eventName, Map<String, dynamic>? properties) {
    properties = properties == null ? null : {...properties};
    _convertDateTime(properties);
    List<dynamic> params = [eventName, properties];
    try {
      _channel.invokeMethod('trackInstallation', params);
    } catch (e) {
      print('Error invoking trackInstallation method: $e');
    }
  }

  /// 初始化事件的计时器，计时单位为秒。
  ///
  /// @param eventName 事件的名称
  /// @return 交叉计时的事件名称
  static Future<String?> trackTimerStart(String eventName) async {
    List<String> params = [eventName];
    try {
      return await _channel.invokeMethod('trackTimerStart', params);
    } catch (e) {
      print('Error invoking trackTimerStart method: $e');
      return null;
    }
  }

  /// 暂停事件计时器，计时单位为秒。
  ///
  /// [eventName] 事件的名称
  static void trackTimerPause(String eventName) {
    List<String> params = [eventName];
    try {
      _channel.invokeMethod('trackTimerPause', params);
    } catch (e) {
      print('Error invoking trackTimerPause method: $e');
    }
  }

  /// 恢复事件计时器，计时单位为秒。
  ///
  /// [eventName] 事件的名称
  static void trackTimerResume(String eventName) {
    List<String> params = [eventName];
    try {
      _channel.invokeMethod('trackTimerResume', params);
    } catch (e) {
      print('Error invoking trackTimerResume method: $e');
    }
  }

  /// 删除事件的计时器
  ///
  /// [eventName] 事件名称
  static void removeTimer(String eventName) {
    List<String> params = [eventName];
    try {
      _channel.invokeMethod('removeTimer', params);
    } catch (e) {
      print('Error invoking removeTimer method: $e');
    }
  }

  ///
  /// trackTimerEnd
  /// 计时结束
  ///
  /// 初始化事件的计时器，默认计时单位为秒(计时开始).
  /// @param eventName 事件的名称.
  /// @param properties Map<String,dynamic> 事件属性.
  ///
  /// 使用示例：（计时器事件名称 viewTimer ）
  /// SensorsAnalyticsFlutterPlugin.trackTimerEnd('viewTimer',{});
  ///
  static void trackTimerEnd(
      String eventName, Map<String, dynamic>? properties) {
    properties = properties == null ? {} : {...properties};
    _convertDateTime(properties);
    _setupLibPluginVersion(properties);
    List<dynamic> params = [eventName, properties];
    try {
      _channel.invokeMethod('trackTimerEnd', params);
    } catch (e) {
      print('Error invoking trackTimerEnd method: $e');
    }
  }

  ///
  /// clearTrackTimer
  /// 清除所有事件计时器
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.clearTrackTimer();
  ///
  static void clearTrackTimer() {
    try {
      _channel.invokeMethod('clearTrackTimer');
    } catch (e) {
      print('Error invoking clearTrackTimer method: $e');
    }
  }

  ///
  /// login.
  /// 用户登陆
  /// @param loginId 用户登录 ID.
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.login('login_id');
  ///
  static void login(String loginId, [Map<String, dynamic>? properties]) {
    properties = properties == null ? {} : {...properties};
    _convertDateTime(properties);
    _setupLibPluginVersion(properties);
    List<dynamic> params = [loginId, properties];
    try {
      _channel.invokeMethod('login', params);
    } catch (e) {
      print('Error invoking login method: $e');
    }
  }

  ///
  /// logout
  /// 用户登出
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.logout();
  ///
  static void logout() {
    try {
      _channel.invokeMethod('logout');
    } catch (e) {
      print('Error invoking logout method: $e');
    }
  }

  ///
  /// trackViewScreen
  /// 页面浏览
  ///
  /// @param url String 页面标示.
  /// @param properties Map<String,dynamic> 事件属性.
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.trackViewScreen('urlForView',{'key1':'value1','key2':'value2'});
  ///
  static void trackViewScreen(String url, Map<String, dynamic>? properties) {
    properties = properties == null ? {} : {...properties};
    _convertDateTime(properties);
    _setupLibPluginVersion(properties);
    List<dynamic> params = [url, properties];
    try {
      _channel.invokeMethod('trackViewScreen', params);
    } catch (e) {
      print('Error invoking trackViewScreen method: $e');
    }
  }

  ///
  /// profileSet
  /// 设置用户属性值
  ///
  /// @param profileProperties Map<String,dynamic> 用户属性.
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.profileSet({'key1':'value1','key2':'value2'});
  ///
  static void profileSet(Map<String, dynamic> profileProperties) {
    profileProperties = {...profileProperties};
    _convertDateTime(profileProperties);
    List<dynamic> params = [profileProperties];
    try {
      _channel.invokeMethod('profileSet', params);
    } catch (e) {
      print('Error invoking profileSet method: $e');
    }
  }

  ///
  /// profileSetOnce
  /// 设置用户属性值，与 profileSet 不同的是：如果之前存在，则忽略，否则，新创建.
  ///
  /// @param profileProperties Map<String,dynamic> 用户属性.
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.profileSetOnce({'key1':'value1','key2':'value2'});
  ///
  static void profileSetOnce(Map<String, dynamic> profileProperties) {
    profileProperties = {...profileProperties};
    _convertDateTime(profileProperties);
    List<dynamic> params = [profileProperties];
    try {
      _channel.invokeMethod('profileSetOnce', params);
    } catch (e) {
      print('Error invoking profileSetOnce method: $e');
    }
  }

  ///
  /// profileUnset
  /// 删除一个用户属性.
  ///
  /// @param profileProperty String 用户属性.
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.profileUnset('key1');
  ///
  static void profileUnset(String profileProperty) {
    List<dynamic> params = [profileProperty];
    try {
      _channel.invokeMethod('profileUnset', params);
    } catch (e) {
      print('Error invoking profileUnset method: $e');
    }
  }

  ///
  /// profileIncrement
  /// 给一个数值类型的Profile增加一个数值. 只能对数值型属性进行操作，若该属性未设置，则添加属性并设置默认值为0
  ///
  /// @param profileProperty String 用户属性.
  /// @param number 增加的数值，可以为负数
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.profileIncrement('age',10);
  ///
  static void profileIncrement(String profileProperty, num number) {
    List<dynamic> params = [profileProperty, number];
    try {
      _channel.invokeMethod('profileIncrement', params);
    } catch (e) {
      print('Error invoking profileIncrement method: $e');
    }
  }

  ///
  /// profileAppend
  /// 给一个 List 类型的 Profile 增加一些值
  ///
  /// @param profileProperty String 用户属性.
  /// @param content List<String> 增加的值，List 中元素必须为 String
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.profileAppend('address',['Beijing','Shanghai']);
  ///
  static void profileAppend(String profileProperty, List<String> content) {
    List<dynamic> params = [profileProperty, content];
    try {
      _channel.invokeMethod('profileAppend', params);
    } catch (e) {
      print('Error invoking profileAppend method: $e');
    }
  }

  ///
  /// profileDelete
  /// 删除当前用户的所有记录
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.profileDelete();
  ///
  static void profileDelete() {
    try {
      _channel.invokeMethod('profileDelete');
    } catch (e) {
      print('Error invoking profileDelete method: $e');
    }
  }

  ///
  /// clearKeychainData
  /// 删除当前 keychain 记录 (仅 iOS 使用)
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.clearKeychainData();
  ///
  static void clearKeychainData() {
    try {
      _channel.invokeMethod('clearKeychainData');
    } catch (e) {
      print('Error invoking clearKeychainData method: $e');
    }
  }

  ///
  /// registerSuperProperties
  /// 设置公共属性
  ///
  /// @param superProperties Map<String,dynamic> 公共属性.
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.registerSuperProperties({'key1':'value1','key2':'value2'});
  ///
  static void registerSuperProperties(Map<String, dynamic> superProperties) {
    superProperties = {...superProperties};
    _convertDateTime(superProperties);
    List<dynamic> params = [superProperties];
    try {
      _channel.invokeMethod('registerSuperProperties', params);
    } catch (e) {
      print('Error invoking registerSuperProperties method: $e');
    }
  }

  ///
  /// unregisterSuperProperty
  /// 删除一个指定的公共属性.
  ///
  /// @param superProperty String 公共属性.
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.unregisterSuperProperty('key1');
  ///
  static void unregisterSuperProperty(String superProperty) {
    List<dynamic> params = [superProperty];
    try {
      _channel.invokeMethod('unregisterSuperProperty', params);
    } catch (e) {
      print('Error invoking unregisterSuperProperty method: $e');
    }
  }

  ///
  /// clearSuperProperties
  /// 删除本地存储的所有公共属性
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.clearSuperProperties();
  ///
  static void clearSuperProperties() {
    try {
      _channel.invokeMethod('clearSuperProperties');
    } catch (e) {
      print('Error invoking clearSuperProperties method: $e');
    }
  }

  ///
  /// 保存用户推送 ID 到用户表
  /// HarmonyOS 不支持
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.profilePushId("jiguang"，"12123123");
  ///
  static void profilePushId(String pushTypeKey, String pushId) {
    try {
      _channel.invokeMethod('profilePushId', [pushTypeKey, pushId]);
    } catch (e) {
      print('Error invoking profilePushId method: $e');
    }
  }

  ///
  /// 删除用户设置的 pushId
  /// HarmonyOS 不支持
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.profileUnsetPushId("jiguang");
  ///
  static void profileUnsetPushId(String pushTypeKey) {
    try {
      _channel.invokeMethod('profileUnsetPushId', [pushTypeKey]);
    } catch (e) {
      print('Error invoking profileUnsetPushId method: $e');
    }
  }

  /// 如果 map 中的 value 字段是 DateTime 类型，将其转换成
  static void _convertDateTime(Map<String, dynamic>? map) {
    if (map != null) {
      map.updateAll((key, value) {
        if (value is DateTime) {
          String timeString = value.toLocal().toString();
          int lastDotIndex = timeString.lastIndexOf(".");
          return timeString.substring(0, lastDotIndex);
        }
        return value;
      });
    }
  }

  /// 设置当前 serverUrl
  /// HarmonyOS 不支持
  /// [serverUrl] 当前 serverUrl
  /// [isRequestRemoteConfig] 是否立即请求当前 serverUrl 的远程配置，默认是 false
  static void setServerUrl(String serverUrl,
      [bool isRequestRemoteConfig = false]) {
    try {
      _channel.invokeMethod('setServerUrl', [serverUrl, isRequestRemoteConfig]);
    } catch (e) {
      print('Error invoking setServerUrl method: $e');
    }
  }

  /// 返回预置属性
  static Future<Map<String, dynamic>?> getPresetProperties() async {
    try {
      return await _channel
          .invokeMapMethod<String, dynamic>('getPresetProperties');
    } catch (e) {
      print('Error invoking getPresetProperties method: $e');
      return null;
    }
  }

  /// 设置是否开启 log
  /// HarmonyOS 不支持
  /// [enable] true 表示开启，false 表示关闭
  static void enableLog(bool enable) {
    try {
      _channel.invokeMethod('enableLog', [enable]);
    } catch (e) {
      print('Error invoking enableLog method: $e');
    }
  }

  /// 设置 flush 时网络发送策略，默认 3G、4G、5G、WI-FI 环境下都会尝试 flush
  /// HarmonyOS 不支持
  static void setFlushNetworkPolicy(Set<SANetworkType> networkType) {
    if (networkType.isNotEmpty) {
      int result = 0;
      networkType.forEach((element) {
        switch (element) {
          case SANetworkType.TYPE_NONE:
            result |= 0;
            break;
          case SANetworkType.TYPE_2G:
            result |= 1;
            break;
          case SANetworkType.TYPE_3G:
            result |= 1 << 1;
            break;
          case SANetworkType.TYPE_4G:
            result |= 1 << 2;
            break;
          case SANetworkType.TYPE_5G:
            result |= 1 << 4;
            break;
          case SANetworkType.TYPE_WIFI:
            result |= 1 << 3;
            break;
          case SANetworkType.TYPE_ALL:
            result |= 0xFF;
            break;
        }
      });
      try {
        _channel.invokeMethod('setFlushNetworkPolicy', [result]);
      } catch (e) {
        print('Error invoking setFlushNetworkPolicy method: $e');
      }
    }
  }

  /// 设置两次数据发送的最小时间间隔
  /// HarmonyOS 不支持
  /// [flushInterval] 时间间隔，单位毫秒
  static void setFlushInterval(int flushInterval) {
    try {
      _channel.invokeMethod('setFlushInterval', [flushInterval]);
    } catch (e) {
      print('Error invoking setFlushInterval method: $e');
    }
  }

  /// 两次数据发送的最小时间间隔，单位毫秒
  /// 默认值为 15 * 1000 毫秒，HarmonyOS 不支持
  /// 在每次调用 track、signUp 以及 profileSet 等接口的时候，都会检查如下条件，以判断是否向服务器上传数据:
  /// 1. 是否是 WIFI/3G/4G 网络条件
  /// 2. 是否满足发送条件之一:
  /// 1) 与上次发送的时间间隔是否大于 flushInterval
  /// 2) 本地缓存日志数目是否大于 flushBulkSize
  /// 如果满足这两个条件，则向服务器发送一次数据；如果不满足，则把数据加入到队列中，等待下次检查时把整个队列的内
  /// 容一并发送。需要注意的是，为了避免占用过多存储，队列最多只缓存 20MB 数据。
  ///
  /// 返回时间间隔，单位毫秒
  static Future<int> getFlushInterval() async {
    try {
      return await _channel.invokeMethod('getFlushInterval');
    } catch (e) {
      print('Error invoking getFlushInterval method: $e');
      return 15000;
    }
  }

  /// 设置本地缓存日志的最大条目数，最小 50 条
  /// HarmonyOS 不支持
  /// [flushBulkSize] 时间间隔，单位毫秒
  static void setFlushBulkSize(int flushBulkSize) {
    try {
      _channel.invokeMethod('setFlushBulkSize', [flushBulkSize]);
    } catch (e) {
      print('Error invoking setFlushBulkSize method: $e');
    }
  }

  /// 返回本地缓存日志的最大条目数
  /// 默认值为 100 条，HarmonyOS 不支持
  /// 在每次调用 track、signUp 以及 profileSet 等接口的时候，都会检查如下条件，以判断是否向服务器上传数据:
  /// 1. 是否是 WIFI/3G/4G 网络条件
  /// 2. 是否满足发送条件之一:
  /// 1) 与上次发送的时间间隔是否大于 flushInterval
  /// 2) 本地缓存日志数目是否大于 flushBulkSize
  /// 如果满足这两个条件，则向服务器发送一次数据；如果不满足，则把数据加入到队列中，等待下次检查时把整个队列的内
  /// 容一并发送。需要注意的是，为了避免占用过多存储，队列最多只缓存 32MB 数据。
  ///
  /// 返回本地缓存日志的最大条目数
  static Future<int> getFlushBulkSize() async {
    try {
      return await _channel.invokeMethod('getFlushBulkSize');
    } catch (e) {
      print('Error invoking getFlushBulkSize method: $e');
      return 100;
    }
  }

  /// 获取当前用户的匿名 ID
  static Future<String?> getAnonymousId() async {
    try {
      return await _channel.invokeMethod('getAnonymousId');
    } catch (e) {
      print('Error invoking getAnonymousId method: $e');
      return null;
    }
  }

  /// 获取当前用户的 loginId
  static Future<String?> getLoginId() async {
    try {
      return await _channel.invokeMethod('getLoginId');
    } catch (e) {
      print('Error invoking getLoginId method: $e');
      return null;
    }
  }

  /// 设置当前用户的 distinctId。一般情况下，如果是一个注册用户，则应该使用注册系统内
  /// 的 user_id，如果是个未注册用户，则可以选择一个不会重复的匿名 ID，如设备 ID 等，如果
  /// 客户没有调用 identify，则使用SDK自动生成的匿名 ID
  ///
  /// [distinctId] 当前用户的 distinctId，仅接受数字、下划线和大小写字母
  static void identify(String distinctId) {
    try {
      _channel.invokeMethod('identify', [distinctId]);
    } catch (e) {
      print('Error invoking identify method: $e');
    }
  }

  /// 记录 $AppInstall 事件，用于在 App 首次启动时追踪渠道来源，并设置追踪渠道事件的属性。
  /// 注意：如果之前使用 trackInstallation 触发的激活事件，需要继续保持原来的调用，无需改成 trackAppInstall，否则会导致激活事件数据分离。
  /// 这是 Sensors Analytics 进阶功能，请参考文档 https://sensorsdata.cn/manual/track_installation.html
  ///
  /// [properties] 渠道追踪事件的属性
  /// [disableCallback] 是否关闭这次渠道匹配的回调请求
  static void trackAppInstall(
      [Map<String, dynamic>? properties, bool disableCallback = false]) {
    properties = properties == null ? null : {...properties};
    _convertDateTime(properties);
    try {
      _channel.invokeMethod('trackAppInstall', [properties, disableCallback]);
    } catch (e) {
      print('Error invoking trackAppInstall method: $e');
    }
  }

  /// 将所有本地缓存的日志发送到 Sensors Analytics.
  static void flush() {
    try {
      _channel.invokeMethod('flush');
    } catch (e) {
      print('Error invoking flush method: $e');
    }
  }

  /// 删除本地缓存的全部事件
  static void deleteAll() {
    try {
      _channel.invokeMethod('deleteAll');
    } catch (e) {
      print('Error invoking deleteAll method: $e');
    }
  }

  /// 获取事件公共属性
  /// HarmonyOS 端不支持
  static Future<Map<String, dynamic>?> getSuperProperties() async {
    try {
      return await _channel
          .invokeMapMethod<String, dynamic>('getSuperProperties');
    } catch (e) {
      print('Error invoking getSuperProperties method: $e');
      return null;
    }
  }

  /// 设置是否允许请求网络，默认是 true。此方法只针对 Android 平台有效
  ///
  /// [isRequest] boolean
  static void enableNetworkRequest(bool isRequest) {
    try {
      if (Platform.isAndroid) {
        _channel.invokeMethod("enableNetworkRequest", [isRequest]);
      }
    } catch (e) {
      print('Error invoking enableNetworkRequest method: $e');
    }
  }

  /// 设置 item
  ///
  /// [itemType] item 类型
  /// [itemId] item ID
  /// [properties] item 相关属性
  static void itemSet(String itemType, String itemId,
      [Map<String, dynamic>? properties]) {
    properties = properties == null ? null : {...properties};
    _convertDateTime(properties);
    try {
      _channel.invokeMethod('itemSet', [itemType, itemId, properties]);
    } catch (e) {
      print('Error invoking itemSet method: $e');
    }
  }

  /// 删除 item
  ///
  /// [itemType] item 类型
  /// [itemId] item ID
  static void itemDelete(String itemType, String itemId) {
    try {
      _channel.invokeMethod('itemDelete', [itemType, itemId]);
    } catch (e) {
      print('Error invoking itemDelete method: $e');
    }
  }

  /// 是否请求网络，默认是 true。此方法只针对 Android 平台有效
  ///
  /// 返回是否请求网络
  static Future<bool> isNetworkRequestEnable() async {
    try {
      if (Platform.isAndroid) {
        return await _channel.invokeMethod("isNetworkRequestEnable");
      }
    } catch (e) {
      print('Error invoking isNetworkRequestEnable method: $e');
    }
    return true;
  }

  ///绑定业务 ID。[key] 为业务 ID 的名，[value] 为业务 ID 的值
  static Future<void> bind(String key, String value) async {
    try {
      return await _channel.invokeMethod('bind', [key, value]);
    } catch (e) {
      print('Error invoking bind method: $e');
    }
  }

  ///解绑业务 ID。[key] 为业务 ID 的名，[value] 为业务 ID 的值
  static Future<void> unbind(String key, String value) async {
    try {
      return await _channel.invokeMethod('unbind', [key, value]);
    } catch (e) {
      print('Error invoking unbind method: $e');
    }
  }

  ///设置当前用户的登陆 ID。[loginKey] 是登录 id 名，[loginValue] 是登录的值，[properties] 用户登录属性
  /// HarmonyOS 端不支持
  static Future<void> loginWithKey(String loginKey, String loginValue,
      [Map<String, dynamic>? properties]) async {
    properties = properties == null ? null : {...properties};
    _convertDateTime(properties);
    try {
      return await _channel
          .invokeMethod('loginWithKey', [loginKey, loginValue, properties]);
    } catch (e) {
      print('Error invoking loginWithKey method: $e');
    }
  }

  /// 判断全埋点类型是否被忽略
  /// HarmonyOS 端不支持
  static Future<bool> isAutoTrackEventTypeIgnored(SAAutoTrackType type) async {
    int result = 0;
    switch (type) {
      case SAAutoTrackType.NONE:
        result = 0;
        break;
      case SAAutoTrackType.APP_START:
        result = 1;
        break;
      case SAAutoTrackType.APP_END:
        result = 1 << 1;
        break;
      case SAAutoTrackType.APP_CLICK:
        result = 1 << 2;
        break;
      case SAAutoTrackType.APP_VIEW_SCREEN:
        result = 1 << 3;
        break;
    }
    try {
      return await _channel
          .invokeMethod('isAutoTrackEventTypeIgnored', [result]);
    } catch (e) {
      print('Error invoking isAutoTrackEventTypeIgnored method: $e');
      return false;
    }
  }

  ///添加 Flutter 插件版本号
  static void _setupLibPluginVersion(Map<String, dynamic>? properties) {
    if (!hasAddedFlutterPluginVersion) {
      if (properties == null) {
        properties = {};
      }
      dynamic tmp = properties[r"$lib_plugin_version"];
      if ((tmp is! List<String>) && (tmp is! List<String?>)) {
        properties.remove(r"$lib_plugin_version");
      }
      dynamic values = properties[r"$lib_plugin_version"];
      values = values == null ? [] : [...values];
      values.add("flutter_plugin:$FLUTTER_PLUGIN_VERSION");
      properties[r"$lib_plugin_version"] = values;
      hasAddedFlutterPluginVersion = true;
    }
  }
}

enum SANetworkType {
  TYPE_NONE,
  TYPE_2G,
  TYPE_3G,
  TYPE_4G,
  TYPE_WIFI,
  TYPE_5G,
  TYPE_ALL
}

enum SAAutoTrackType { NONE, APP_START, APP_END, APP_CLICK, APP_VIEW_SCREEN }

/// Flutter MethodChannel Manager
class ChannelManager {
  static ChannelManager _instance = ChannelManager._();

  factory ChannelManager.getInstance() => _instance;

  final MethodChannel _channel =
      const MethodChannel('sensors_analytics_flutter_plugin');

  ChannelManager._();

  MethodChannel get methodChannel => _channel;
}
