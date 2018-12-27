import 'dart:async';

import 'package:flutter/services.dart';

// This is the official Flutter Plugin for Sensors Analytics.
class SensorsAnalyticsFlutterPlugin {
  static const MethodChannel _channel =
      const MethodChannel('sensors_analytics_flutter_plugin');

  static Future<String> get getDistinctId async {
    return await _channel.invokeMethod('getDistinctId');
  }

  static void track(String eventName ,Map<String,dynamic> properties ) {
    assert(eventName != null);
    List<dynamic> params = [eventName,properties];
    _channel.invokeMethod('track',params);
  }

  static void trackInstallation(String eventName ,Map<String,dynamic> properties ) {
    assert(eventName != null);
    List<dynamic> params = [eventName,properties];
    _channel.invokeMethod('trackInstallation',params);
  }

  static void trackTimerStart(String eventName) {
    assert(eventName != null);
    List<String> params = [eventName];
    _channel.invokeMethod('trackTimerStart',params);
  }

  static void trackTimerEnd(String eventName ,Map<String,dynamic> properties ) {
    assert(eventName != null);
    List<dynamic> params = [eventName,properties];
    _channel.invokeMethod('trackTimerEnd',params);
  }

  static void clearTrackTimer() {
    _channel.invokeMethod('clearTrackTimer');
  } 

  static void login(String loginId){
    assert(loginId != null);
    List<String> params = [loginId];
    _channel.invokeMethod('login',params);
  }

  static void logout(){
    _channel.invokeMethod('logout');
  }

  static void trackViewScreen(String url ,Map<String,dynamic> properties ) {
    assert(url != null);
    List<dynamic> params = [url,properties];
    _channel.invokeMethod('trackViewScreen',params);
  }  

  static void profileSet(Map<String,dynamic> profileProperties){
    List<dynamic> params = [profileProperties];
    _channel.invokeMethod('profileSet',params);
  }

  static void profileSetOnce(Map<String,dynamic> profileProperties){
    List<dynamic> params = [profileProperties];
    _channel.invokeMethod('profileSetOnce',params);
  }

  static void profileUnset(String profilePropertity){
    List<dynamic> params = [profilePropertity];
    _channel.invokeMethod('profileUnset',params);
  } 

  static void profileIncrement(String profilePropertity, num number) {
    List<dynamic> params = [profilePropertity,number];
    _channel.invokeMethod('profileIncrement',params);
  }

  static void profileAppend(String profilePropertity, List<String> content) {
    List<dynamic> params = [profilePropertity,content];
    _channel.invokeMethod('profileAppend',params);
  }

  static void profileDelete() {
    _channel.invokeMethod('profileDelete');
  } 
  
  static void clearKeychainData() {
    _channel.invokeMethod('clearKeychainData');
  } 

}
