import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

// This is the official Flutter Plugin for Sensors Analytics.
class SensorsAnalyticsFlutterPlugin {
  static const MethodChannel _channel =
      const MethodChannel('sensors_analytics_flutter_plugin');

  static Future<String> get getDistinctId async {
    return await _channel.invokeMethod('getDistinctId');
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
    properties = properties == null ? null : {...properties};
    _convertDateTime(properties);
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
  static void trackInstallation(
      String eventName, Map<String, dynamic>? properties) {
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
  static void trackTimerEnd(
      String eventName, Map<String, dynamic>? properties) {
    properties = properties == null ? null : {...properties};
    _convertDateTime(properties);
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
  static void login(String loginId) {
    List<String> params = [loginId];
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
    properties = properties == null ? null : {...properties};
    _convertDateTime(properties);
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
    if (profileProperties != null) {
      profileProperties = {...profileProperties};
    }
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
    if (profileProperties != null) {
      profileProperties = {...profileProperties};
    }
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
    if (superProperties != null) {
      superProperties = {...superProperties};
    }
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

  ///
  /// 开启数据采集，此方法合规功能，需要配合 SAConfigOptions.disableDataCollect() 方法一起使用，并且此方法只针对 Android 平台：
  /// 详情请参考：https://manual.sensorsdata.cn/sa/latest/page-22252691.html
  ///
  static void enableDataCollect() {
    _channel.invokeMethod("enableDataCollect");
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
  static void setServerUrl(String serverUrl,
      [bool isRequestRemoteConfig = false]) {
    _channel.invokeMethod("setServerUrl", [serverUrl, isRequestRemoteConfig]);
  }

  /// 返回预置属性
  static Future<Map<String, dynamic>?> getPresetProperties() async {
    return await _channel
        .invokeMapMethod<String, dynamic>("getPresetProperties");
  }

  /// 设置是否开启 log
  /// [enable] true 表示开启，false 表示关闭
  static void enableLog(bool enable) {
    _channel.invokeMethod("enableLog", [enable]);
  }

  /// 设置 flush 时网络发送策略，默认 3G、4G、5G、WI-FI 环境下都会尝试 flush
  static void setFlushNetworkPolicy(List<SANetworkType> networkType) {
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
  static void trackAppInstall(
      [Map<String, dynamic>? properties, bool disableCallback = false]) {
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
    return await _channel
        .invokeMapMethod<String, dynamic>("getSuperProperties");
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
  static void itemSet(String itemType, String itemId,
      [Map<String, dynamic>? properties]) {
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
