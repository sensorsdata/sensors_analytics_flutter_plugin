import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class AndroidConfig {
  final int maxCacheSize;
  final bool jellybean;
  final bool subProcessFlush;

  ///配置 Android 部分功能。[maxCacheSize] 表示 Android 最大缓存量，单位是 byte。
  ///[jellybean] 表示是否支持 Android JellyBean 版本，JellyBean 版本的 WebView 存在安全性问题。
  ///[subProcessFlush] 表示 Android SDK 是否支持多进程上报数据。
  AndroidConfig({this.maxCacheSize = 32 * 1024 * 1024, this.jellybean = false, this.subProcessFlush = false});

  Map<String, dynamic> get map => {"maxCacheSize": "$maxCacheSize", "jellybean": jellybean, "subProcessFlush": subProcessFlush};
}

class IOSConfig {
  final int maxCacheSize;

  ///配置 iOS 部分功能。[maxCacheSize] 表示 iOS 最大缓存事件数目，单位是“条”。
  IOSConfig({this.maxCacheSize = 10000});

  Map<String, dynamic> get map => {"maxCacheSize": maxCacheSize};
}

class VisualizedConfig {
  final bool autoTrack;
  final bool properties;

  ///配置可视化全埋点功能。[autotrack] 表示开启可视化全埋点，[properties] 表示开启可视化全埋点自定义属性功能。
  VisualizedConfig({this.autoTrack = false, this.properties = false});

  Map<String, dynamic> get map => {"autoTrack": autoTrack, "properties": properties};
}

// This is the official Flutter Plugin for Sensors Analytics.
class SensorsAnalyticsFlutterPlugin {
  static const String FLUTTER_PLUGIN_VERSION = "2.4.0";
  static bool hasAddedFlutterPluginVersion = false;

  static Future<String?> get getDistinctId async {
    return await _channel.invokeMethod('getDistinctId');
  }

  /// Just for SDK inner used
  static MethodChannel get _channel => ChannelManager.getInstance().methodChannel;

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
  /// [networkTypes]: 数据上报的网络条件<br/>
  /// [flushInterval]: 数据上报的时间间隔，单位是毫秒，默认是 1500ms <br/>
  /// [flushBulkSize]：触发上报逻辑的事件数目，默认是 100 条 <br/>
  /// [enableLog]：是否开启本地 log，该配置只在 debug 阶段有效 <br/>
  /// [javaScriptBridge]: 是否支持 H5 打通，Android 中需要和 [AndroidConfig.jellybean] 配合使用 <br/>
  /// [encrypt]: 是否支持加密，Flutter 中初始化只支持 RSA+AES 加密 <br/>
  /// [android]: Android 部分特有的配置 <br/>
  /// [ios]: iOS 部分特有的配置 <br/>
  /// [visualized]: 可视化全埋点部分特有的配置，Flutter 暂不支持可视化，该配置会影响 Native <br/>
  /// [heatMap]: 是否开启点击图，Flutter 暂不支持点击分析功能，该配置会影响 Native <br/>
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
      VisualizedConfig? visualized,
      bool heatMap = false,
      Map? globalProperties}) async {
    Map<String, dynamic> initConfig = {
      "serverUrl": serverUrl ??
          () {
            assert(() {
              print("Server Url is empty, SDK will not upload data. You can call 'setServerUrl()' to set it later.");
              return true;
            }());
            return "";
          }(),
      "enableLog": enableLog,
      "javaScriptBridge": javaScriptBridge,
      "encrypt": encrypt,
      "heatMap": heatMap,
      "flushInterval": flushInterval,
      "flushBulkSize": flushBulkSize,
      if (android != null) "android": android.map,
      if (ios != null) "ios": ios.map,
      if (visualized != null) "visualized": visualized.map,
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
            break;
          case SAAutoTrackType.APP_VIEW_SCREEN:
            result |= 1 << 3;
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
    _channel.invokeMethod('track', params);
  }

  ///
  /// trackInstallation
  /// App 激活事件追踪
  ///
  /// @param eventName  String 通常为'AppInstall'.
  /// @param properties Map<String,dynamic> App 激活事件的属性.
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.trackInstallation('AppInstall',{'key1':'value1','key2':'value2'});
  ///
  static void trackInstallation(String eventName, Map<String, dynamic>? properties) {
    properties = properties == null ? null : {...properties};
    _convertDateTime(properties);
    List<dynamic> params = [eventName, properties];
    _channel.invokeMethod('trackInstallation', params);
  }

  /// 初始化事件的计时器，计时单位为秒。
  ///
  /// @param eventName 事件的名称
  /// @return 交叉计时的事件名称
  static Future<String> trackTimerStart(String eventName) async {
    List<String> params = [eventName];
    return await _channel.invokeMethod('trackTimerStart', params);
  }

  /// 暂停事件计时器，计时单位为秒。
  ///
  /// [eventName] 事件的名称
  static void trackTimerPause(String eventName) {
    List<String> params = [eventName];
    _channel.invokeMethod('trackTimerPause', params);
  }

  /// 恢复事件计时器，计时单位为秒。
  ///
  /// [eventName] 事件的名称
  static void trackTimerResume(String eventName) {
    List<String> params = [eventName];
    _channel.invokeMethod('trackTimerResume', params);
  }

  /// 删除事件的计时器
  ///
  /// [eventName] 事件名称
  static void removeTimer(String eventName) {
    List<String> params = [eventName];
    _channel.invokeMethod('removeTimer', params);
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
  static void trackTimerEnd(String eventName, Map<String, dynamic>? properties) {
    properties = properties == null ? {} : {...properties};
    _convertDateTime(properties);
    _setupLibPluginVersion(properties);
    List<dynamic> params = [eventName, properties];
    _channel.invokeMethod('trackTimerEnd', params);
  }

  ///
  /// clearTrackTimer
  /// 清除所有事件计时器
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.clearTrackTimer();
  ///
  static void clearTrackTimer() {
    _channel.invokeMethod('clearTrackTimer');
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
    _channel.invokeMethod('login', params);
  }

  ///
  /// logout
  /// 用户登出
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.logout();
  ///
  static void logout() {
    _channel.invokeMethod('logout');
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
    _channel.invokeMethod('trackViewScreen', params);
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
    _channel.invokeMethod('profileSet', params);
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
    _channel.invokeMethod('profileSetOnce', params);
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
    _channel.invokeMethod('profileUnset', params);
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
    _channel.invokeMethod('profileIncrement', params);
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
    _channel.invokeMethod('profileAppend', params);
  }

  ///
  /// profileDelete
  /// 删除当前用户的所有记录
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.profileDelete();
  ///
  static void profileDelete() {
    _channel.invokeMethod('profileDelete');
  }

  ///
  /// clearKeychainData
  /// 删除当前 keychain 记录 (仅 iOS 使用)
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.clearKeychainData();
  ///
  static void clearKeychainData() {
    _channel.invokeMethod('clearKeychainData');
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
    _channel.invokeMethod('registerSuperProperties', params);
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
    _channel.invokeMethod('unregisterSuperProperty', params);
  }

  ///
  /// clearSuperProperties
  /// 删除本地存储的所有公共属性
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.clearSuperProperties();
  ///
  static void clearSuperProperties() {
    _channel.invokeMethod('clearSuperProperties');
  }

  ///
  /// 保存用户推送 ID 到用户表
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.profilePushId("jiguang"，"12123123");
  ///
  static void profilePushId(String pushTypeKey, String pushId) {
    _channel.invokeMethod("profilePushId", [pushTypeKey, pushId]);
  }

  ///
  /// 删除用户设置的 pushId
  ///
  /// 使用示例：
  /// SensorsAnalyticsFlutterPlugin.profileUnsetPushId("jiguang");
  ///
  static void profileUnsetPushId(String pushTypeKey) {
    _channel.invokeMethod("profileUnsetPushId", [pushTypeKey]);
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
  /// [serverUrl] 当前 serverUrl
  /// [isRequestRemoteConfig] 是否立即请求当前 serverUrl 的远程配置，默认是 false
  static void setServerUrl(String serverUrl, [bool isRequestRemoteConfig = false]) {
    _channel.invokeMethod("setServerUrl", [serverUrl, isRequestRemoteConfig]);
  }

  /// 返回预置属性
  static Future<Map<String, dynamic>?> getPresetProperties() async {
    return await _channel.invokeMapMethod<String, dynamic>("getPresetProperties");
  }

  /// 设置是否开启 log
  /// [enable] true 表示开启，false 表示关闭
  static void enableLog(bool enable) {
    _channel.invokeMethod("enableLog", [enable]);
  }

  /// 设置 flush 时网络发送策略，默认 3G、4G、5G、WI-FI 环境下都会尝试 flush
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
      _channel.invokeMethod("setFlushNetworkPolicy", [result]);
    }
  }

  /// 设置两次数据发送的最小时间间隔
  /// [flushInterval] 时间间隔，单位毫秒
  static void setFlushInterval(int flushInterval) {
    _channel.invokeMethod("setFlushInterval", [flushInterval]);
  }

  /// 两次数据发送的最小时间间隔，单位毫秒
  /// 默认值为 15 * 1000 毫秒
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
    return await _channel.invokeMethod("getFlushInterval");
  }

  /// 设置本地缓存日志的最大条目数，最小 50 条
  /// [flushBulkSize] 时间间隔，单位毫秒
  static void setFlushBulkSize(int flushBulkSize) {
    _channel.invokeMethod("setFlushBulkSize", [flushBulkSize]);
  }

  /// 返回本地缓存日志的最大条目数
  /// 默认值为 100 条
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
    return await _channel.invokeMethod("getFlushBulkSize");
  }

  /// 获取当前用户的匿名 ID
  static Future<String> getAnonymousId() async {
    return await _channel.invokeMethod("getAnonymousId");
  }

  /// 获取当前用户的 loginId
  static Future<String> getLoginId() async {
    return await _channel.invokeMethod("getLoginId");
  }

  /// 设置当前用户的 distinctId。一般情况下，如果是一个注册用户，则应该使用注册系统内
  /// 的 user_id，如果是个未注册用户，则可以选择一个不会重复的匿名 ID，如设备 ID 等，如果
  /// 客户没有调用 identify，则使用SDK自动生成的匿名 ID
  ///
  /// [distinctId] 当前用户的 distinctId，仅接受数字、下划线和大小写字母
  static void identify(String distinctId) {
    _channel.invokeMethod("identify", [distinctId]);
  }

  /// 记录 $AppInstall 事件，用于在 App 首次启动时追踪渠道来源，并设置追踪渠道事件的属性。
  /// 注意：如果之前使用 trackInstallation 触发的激活事件，需要继续保持原来的调用，无需改成 trackAppInstall，否则会导致激活事件数据分离。
  /// 这是 Sensors Analytics 进阶功能，请参考文档 https://sensorsdata.cn/manual/track_installation.html
  ///
  /// [properties] 渠道追踪事件的属性
  /// [disableCallback] 是否关闭这次渠道匹配的回调请求
  static void trackAppInstall([Map<String, dynamic>? properties, bool disableCallback = false]) {
    properties = properties == null ? null : {...properties};
    _convertDateTime(properties);
    _channel.invokeMethod("trackAppInstall", [properties, disableCallback]);
  }

  /// 将所有本地缓存的日志发送到 Sensors Analytics.
  static void flush() {
    _channel.invokeMethod("flush");
  }

  /// 删除本地缓存的全部事件
  static void deleteAll() {
    _channel.invokeMethod("deleteAll");
  }

  /// 获取事件公共属性
  static Future<Map<String, dynamic>?> getSuperProperties() async {
    return await _channel.invokeMapMethod<String, dynamic>("getSuperProperties");
  }

  /// 设置是否允许请求网络，默认是 true。此方法只针对 Android 平台有效
  ///
  /// [isRequest] boolean
  static void enableNetworkRequest(bool isRequest) {
    if (Platform.isAndroid) {
      _channel.invokeMethod("enableNetworkRequest", [isRequest]);
    }
  }

  /// 设置 item
  ///
  /// [itemType] item 类型
  /// [itemId] item ID
  /// [properties] item 相关属性
  static void itemSet(String itemType, String itemId, [Map<String, dynamic>? properties]) {
    properties = properties == null ? null : {...properties};
    _convertDateTime(properties);
    _channel.invokeMethod("itemSet", [itemType, itemId, properties]);
  }

  /// 删除 item
  ///
  /// [itemType] item 类型
  /// [itemId] item ID
  static void itemDelete(String itemType, String itemId) {
    _channel.invokeMethod("itemDelete", [itemType, itemId]);
  }

  /// 是否请求网络，默认是 true。此方法只针对 Android 平台有效
  ///
  /// 返回是否请求网络
  static Future<bool> isNetworkRequestEnable() async {
    if (Platform.isAndroid) {
      return await _channel.invokeMethod("isNetworkRequestEnable");
    }
    return true;
  }

  ///绑定业务 ID。[key] 为业务 ID 的名，[value] 为业务 ID 的值
  static Future<void> bind(String key, String value) async {
    return await _channel.invokeMethod("bind", [key, value]);
  }

  ///解绑业务 ID。[key] 为业务 ID 的名，[value] 为业务 ID 的值
  static Future<void> unbind(String key, String value) async {
    return await _channel.invokeMethod("unbind", [key, value]);
  }

  ///设置当前用户的登陆 ID。[loginKey] 是登录 id 名，[loginValue] 是登录的值，[properties] 用户登录属性
  static Future<void> loginWithKey(String loginKey, String loginValue, [Map<String, dynamic>? properties]) async {
    properties = properties == null ? null : {...properties};
    _convertDateTime(properties);
    return await _channel.invokeMethod("loginWithKey", [loginKey, loginValue, properties]);
  }

  ///判断全埋点类型是否被忽略
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
    return await _channel.invokeMethod("isAutoTrackEventTypeIgnored", [result]);
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

enum SANetworkType { TYPE_NONE, TYPE_2G, TYPE_3G, TYPE_4G, TYPE_WIFI, TYPE_5G, TYPE_ALL }

enum SAAutoTrackType { NONE, APP_START, APP_END, APP_CLICK, APP_VIEW_SCREEN }

/// Flutter MethodChannel Manager
class ChannelManager {
  static ChannelManager _instance = ChannelManager._();

  factory ChannelManager.getInstance() => _instance;

  final MethodChannel _channel = const MethodChannel('sensors_analytics_flutter_plugin');

  ChannelManager._();

  MethodChannel get methodChannel => _channel;
}
