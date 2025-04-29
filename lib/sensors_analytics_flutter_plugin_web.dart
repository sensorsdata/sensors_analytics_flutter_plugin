import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'dart:js' as js;

class SensorsAnalyticsFlutterPlugin {
  var sensors = js.context['sensorsDataAnalytic201505'];

  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      "sensors_analytics_flutter_plugin",
      const StandardMethodCodec(),
      registrar,
    );
    final flutterPlugin = SensorsAnalyticsFlutterPlugin();
    channel.setMethodCallHandler(flutterPlugin.handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    if (sensors == null) {
      print('sensorsDataAnalytic201505 不存在');
      return;
    }

    switch (call.method) {
      case 'init':
        _initializeSdk(call.arguments);
        break;
      case 'track':
        _track(call.arguments);
        break;
      case 'getPresetProperties':
        return _getPresetProperties();
      case 'profileSet':
        _profileSet(call.arguments);
        break;
      case 'profileSetOnce':
        _profileSetOnce(call.arguments);
        break;
      case 'profileAppend':
        _profileAppend(call.arguments);
        break;
      case 'profileIncrement':
        _profileIncrement(call.arguments);
        break;
      case 'profileDelete':
        _profileDelete();
        break;
      case 'profileUnset':
        _profileUnset(call.arguments);
        break;
      case 'itemSet':
        _itemSet(call.arguments);
        break;
      case 'itemDelete':
        _itemDelete(call.arguments);
        break;
      case 'identify':
        _identify(call.arguments);
        break;
      case 'login':
        _login(call.arguments);
        break;
      case 'logout':
        _logout();
        break;
      case 'bind':
        _bind(call.arguments);
        break;
      case 'unbind':
        _unbind(call.arguments);
        break;
      case 'registerSuperProperties':
        _registerSuperProperties(call.arguments);
        break;
      default:
        print('未知方法: ${call.method}');
    }
  }

  void _initializeSdk(dynamic arguments) {
    _executeSafely(() {
      var originalParams = arguments[0];
      var params = {
        'server_url': originalParams['serverUrl'],
        'show_log': originalParams['enableLog'],
        'preset_properties': {'title': false}
      };
      final config = _jsify(params);
      bool encrypt = originalParams['encrypt'];
      if (encrypt) {
        var smEncryption =
            js.context['SensorsDataWebJSSDKPlugin']['SMEncryption'];
        sensors.callMethod('use', [
          smEncryption,
          _jsify({
            'pkv': originalParams['web']['pkv'],
            'pub_key': originalParams['web']['publicKey']
          })
        ]);
      }
      sensors.callMethod('init', [config]);
      print('SensorsAnalytics 初始化成功');
    }, '_initializeSdk', '初始化 SensorsAnalytics 失败');
  }

  void _track(dynamic arguments) {
    _executeSafely(() {
      var eventName = arguments[0];
      var properties = arguments[1];
      final propertiesMap = _jsify(properties);
      sensors.callMethod('track', [eventName, propertiesMap]);
      print('SensorsAnalytics 事件 $eventName 上报成功');
    }, '_track', 'SensorsAnalytics 事件上报失败');
  }

  Map<String, dynamic>? _getPresetProperties() {
    try {
      final properties = sensors.callMethod('getPresetProperties');
      if (properties != null) {
        final jsonString =
            js.context['JSON'].callMethod('stringify', [properties]);
        final Map<String, dynamic> result = json.decode(jsonString);
        return result;
      }
    } catch (e) {
      print('_getPresetProperties 获取预置属性失败' + e.toString());
    }
    return null;
  }

  void _profileSet(dynamic arguments) {
    _executeSafely(() {
      var properties = arguments[0];
      final propertiesMap = _jsify(properties);
      sensors.callMethod('setProfile', [propertiesMap]);
      print('SensorsAnalytics _profileSet 事件 上报成功');
    }, '_profileSet', 'SensorsAnalytics 事件上报失败');
  }

  void _profileSetOnce(dynamic arguments) {
    _executeSafely(() {
      var properties = arguments[0];
      final propertiesMap = _jsify(properties);
      sensors.callMethod('setOnceProfile', [propertiesMap]);
      print('SensorsAnalytics _profileSetOnce 事件 上报成功');
    }, '_profileSetOnce', 'SensorsAnalytics 事件上报失败');
  }

  void _profileAppend(dynamic arguments) {
    _executeSafely(() {
      var properties = arguments[0];
      final propertiesMap = _jsify(properties);
      sensors.callMethod('appendProfile', [propertiesMap]);
      print('SensorsAnalytics _profileAppend 事件 上报成功');
    }, '_profileAppend', 'SensorsAnalytics 事件上报失败');
  }

  void _profileIncrement(dynamic arguments) {
    _executeSafely(() {
      var properties = arguments[0];
      final propertiesMap = _jsify(properties);
      sensors.callMethod('incrementProfile', [propertiesMap]);
      print('SensorsAnalytics profileIncrement 事件 上报成功');
    }, '_profileIncrement', 'SensorsAnalytics 事件上报失败');
  }

  void _profileDelete() {
    _executeSafely(() {
      sensors.callMethod('deleteProfile');
      print('SensorsAnalytics profileDelete 事件 上报成功');
    }, '_profileDelete', 'SensorsAnalytics 事件上报失败');
  }

  void _profileUnset(dynamic arguments) {
    _executeSafely(() {
      var properties = arguments[0];
      final propertiesMap = _jsify(properties);
      sensors.callMethod('unsetProfile', [propertiesMap]);
      print('SensorsAnalytics profileIncrement 事件 上报成功');
    }, '_profileUnset', 'SensorsAnalytics 事件上报失败');
  }

  void _itemSet(dynamic arguments) {
    _executeSafely(() {
      var itemType = arguments[0];
      var itemId = arguments[1];
      var properties = arguments[2];
      final propertiesMap = _jsify(properties);
      sensors.callMethod('setItem', [itemType, itemId, propertiesMap]);
      print('SensorsAnalytics itemSet 事件上报成功');
    }, '_itemSet', 'SensorsAnalytics 事件上报失败');
  }

  void _itemDelete(dynamic arguments) {
    _executeSafely(() {
      var itemType = arguments[0];
      var itemId = arguments[1];
      sensors.callMethod('deleteItem', [itemType, itemId]);
      print('SensorsAnalytics itemDelete 事件 上报成功');
    }, '_itemDelete', 'SensorsAnalytics 事件上报失败');
  }

  void _identify(dynamic arguments) {
    _executeSafely(() {
      var id = arguments[0];
      sensors.callMethod('identify', [id]);
      print('SensorsAnalytics identify 事件 上报成功');
    }, '_identify', 'SensorsAnalytics 事件上报失败');
  }

  void _login(dynamic arguments) {
    _executeSafely(() {
      var loginId = arguments[0];
      sensors.callMethod('login', [loginId]);
      print('SensorsAnalytics login 事件上报成功');
    }, '_login', 'SensorsAnalytics 事件上报失败');
  }

  void _logout() {
    _executeSafely(() {
      sensors.callMethod('logout');
      print('SensorsAnalytics logout 事件上报成功');
    }, '_logout', 'SensorsAnalytics 事件上报失败');
  }

  void _bind(dynamic arguments) {
    _executeSafely(() {
      var key = arguments[0];
      var value = arguments[1];
      sensors.callMethod('bind', [key, value]);
      print('SensorsAnalytics bind 事件上报成功');
    }, '_bind', 'SensorsAnalytics 事件上报失败');
  }

  void _unbind(dynamic arguments) {
    _executeSafely(() {
      var key = arguments[0];
      var value = arguments[1];
      sensors.callMethod('unbind', [key, value]);
      print('SensorsAnalytics unbind 事件上报成功');
    }, '_unbind', 'SensorsAnalytics 事件上报失败');
  }

  void _registerSuperProperties(dynamic arguments) {
    _executeSafely(() {
      var properties = arguments[0];
      final propertiesMap = _jsify(properties);
      sensors.callMethod('registerPage', [propertiesMap]);
      print('SensorsAnalytics registerSuperProperties 事件 上报成功');
    }, '_registerSuperProperties', 'SensorsAnalytics 事件上报失败');
  }

  void _executeSafely(Function action, String methodName, String errorMessage,
      [dynamic defaultValue]) {
    try {
      return action();
    } catch (e) {
      print('[$methodName] $errorMessage: $e');
      return defaultValue;
    }
  }

  js.JsObject _jsify(dynamic object) {
    return js.JsObject.jsify(object);
  }
}
