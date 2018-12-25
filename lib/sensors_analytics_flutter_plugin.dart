import 'dart:async';

import 'package:flutter/services.dart';

class SensorsAnalyticsFlutterPlugin {
  static const MethodChannel _channel =
      const MethodChannel('sensors_analytics_flutter_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> get distinctId async {
    final String version = await _channel.invokeMethod('getDistinctId');
    return version;
  }

  static void track(String event ,Map<String,dynamic> properties ) {
    assert(event != null);
    List<dynamic> params = [event,properties];
    _channel.invokeMethod('track',params);
  }

  static void trackTimerStart(String event) {
    List<dynamic> params = [event];
    _channel.invokeMethod('trackTimerStart',params);
  }

  static void trackTimerEnd(String event ,Map<String,dynamic> properties ) {
    List<dynamic> params = [event,properties];
    _channel.invokeMethod('trackTimerEnd',params);
  }

  static void clearTrackTimer() {
    _channel.invokeMethod('clearTrackTimer');
  } 

  static void login(String loginId){
    List<dynamic> params = [loginId];
    _channel.invokeMethod('login',params);
  }

  static void logout(){
    _channel.invokeMethod('logout');
  }

  static void trackViewScreenWithUrl(String url ,Map<String,dynamic> properties ) {
    List<dynamic> params = [url,properties];
    _channel.invokeMethod('trackViewScreenWithUrl',params);
  }  

  static void profileSet(Map<String,dynamic> profileDict){
    List<dynamic> params = [profileDict];
    _channel.invokeMethod('profileSet',params);
  }

  static void profileSetOnce(Map<String,dynamic> profileDict){
    List<dynamic> params = [profileDict];
    _channel.invokeMethod('profileSetOnce',params);
  }

  static void profileUnset(String profile){
    List<dynamic> params = [profile];
    _channel.invokeMethod('profileUnset',params);
  } 

  static void profileIncrement(String profile, dynamic amount) {
    List<dynamic> params = [profile,amount];
    _channel.invokeMethod('profileIncrement',params);
  }

  static void profileAppend(String profile, List<dynamic> content) {
    List<dynamic> params = [profile,content];
    _channel.invokeMethod('profileAppend',params);
  }

  static void profileDelete() {
    _channel.invokeMethod('profileDelete');
  } 
  
  static void clearKeychainData() {
    _channel.invokeMethod('clearKeychainData');
  } 

}
