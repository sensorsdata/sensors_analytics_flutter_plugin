//
// SensorsAnalyticsFlutterPlugin
// SensorsAnalyticsFlutterPlugin
//
// Created by chuqiangsheng on 2025/04/16.
// Copyright © 2015-2025 Sensors Data Co., Ltd. All rights reserved.
//

import { FlutterPlugin, FlutterPluginBinding, MethodCall, MethodCallHandler, MethodChannel, MethodResult, } from '@ohos/flutter_ohos';
import sensors from '@sensorsdata/analytics';
import { SAAESEncryption } from '@sensorsdata/analytics';
import * as global from '@sensorsdata/analytics';
import { SAFlutterUtils } from "./SAFlutterUtils";
import { SAFlutterGlobalPropertyPlugin } from "./SAFlutterGlobalPropertyPlugin";
import { SAFlutterManager } from './SAFlutterManager'
import { SAAutoTrack, SAAutoTrackType } from '@sensorsdata/analytics'
import { common } from '@kit.AbilityKit';

type SAFlutterPluginCallMap = Map<string, string | boolean | number | Array<string> | Date | Function>;

/** SensorsAnalyticsFlutterPlugin **/
export default class SensorsAnalyticsFlutterPlugin implements FlutterPlugin, MethodCallHandler {
  private channel: MethodChannel | null = null;
  private context: Context | null = null;
  private moduleManager: SAFlutterManager = new SAFlutterManager();

  constructor() {
  }

  getUniqueClassName(): string {
    return "SensorsAnalyticsFlutterPlugin"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), "sensors_analytics_flutter_plugin");
    this.channel.setMethodCallHandler(this)
    // 调试出现过 getContext(this) 无法取到结果
    // 如果使用 ApplicationContext，原生 $AppEnd 和 $AppStart 全埋点点无法采集
    this.context = getContext(this) as common.UIAbilityContext ?? binding.getApplicationContext();
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null)
    }
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    if (call.method == "init") {
      this.startWithConfig(call, result)
    } else if (call.method == "track") {
      this.track(call, result)
    } else if (call.method == "registerSuperProperties") {
      this.registerSuperProperties(call, result)
    } else if (call.method == "clearSuperProperties") {
      this.clearSuperProperties(result)
    } else if (call.method == "unregisterSuperProperty") {
      this.unregisterSuperProperty(call, result)
    } else if (call.method == "profileSet") {
      this.profileSet(call, result)
    } else if (call.method == "profileSetOnce") {
      this.profileSetOnce(call, result)
    } else if (call.method == "profileUnset") {
      this.profileUnset(call, result)
    } else if (call.method == "profileIncrement") {
      this.profileIncrement(call, result)
    } else if (call.method == "profileAppend") {
      this.profileAppend(call, result)
    } else if (call.method == "profileDelete") {
      this.profileDelete(call, result)
    } else if (call.method == "identify") {
      this.identify(call, result)
    } else if (call.method == "login") {
      this.login(call, result)
    } else if (call.method == "logout") {
      this.logout(result)
    } else if (call.method == "bind") {
      this.bind(call, result)
    } else if (call.method == "unbind") {
      this.unbind(call, result)
    } else if (call.method == "itemDelete") {
      this.itemDelete(call, result)
    } else if (call.method == "itemSet") {
      this.itemSet(call, result)
    } else if (call.method == "flush") {
      this.flush(result)
    } else if (call.method == "getDistinctId") {
      this.getDistinctId(call, result)
    } else if (call.method == "getAnonymousId") {
      this.getAnonymousId(call, result)
    } else if (call.method == "getLoginId") {
      this.getLoginId(call, result)
    } else if (call.method == "getPresetProperties") {
      this.getPresetProperties(result)
    } else if (call.method == "trackAppInstall") {
      this.trackAppInstall(call, result)
    } else if (call.method == "trackTimerStart") {
      this.trackTimerStart(call, result)
    } else if (call.method == "trackTimerResume") {
      this.trackTimerResume(call, result)
    } else if (call.method == "trackTimerPause") {
      this.trackTimerPause(call, result)
    } else if (call.method == "removeTimer") {
      this.removeTimer(call, result)
    } else if (call.method == "trackTimerEnd") {
      this.trackTimerEnd(call, result)
    } else if (call.method == "clearTrackTimer") {
      this.clearTrackTimer(call, result)
    } else if (call.method == "trackViewScreen") {
      this.trackViewScreen(call, result)
    } else if (call.method == "deleteAll") {
      this.deleteAll(result)
    } else {
      result.notImplemented()
    }
  }

  track(call: MethodCall, result: MethodResult): void {
    try {
      const eventName = call.args[0] as string;
      const propertiesMap =
        call.args[1] as SAFlutterPluginCallMap | undefined;
      let properties: global.EventProps | undefined;
      if (propertiesMap) {
        properties = SAFlutterUtils.mapToJsonObject(propertiesMap);
      }
      if (properties) {
        sensors.track(eventName, properties);
      } else {
        sensors.track(eventName);
      }
    } catch (e) {
      console.error(e);
      result.error("TRACK_ERROR", "Failed to track event", e.toString());
    }
  }

  trackTimerStart(call: MethodCall, result: MethodResult): void {
    try {
      const eventName = call.args[0] as string;
      const timer = sensors.trackTimerStart(eventName);
      this.moduleManager.insertTrackTimer(timer);
      result.success(eventName);
    } catch (e) {
      console.error(e);
      result.error("TRACK_ERROR", "Failed to trackTimerStart", e.toString());
    }
  }

  trackTimerEnd(call: MethodCall, result: MethodResult): void {
    try {
      const eventName = call.args[0] as string;
      const propertiesMap =
        call.args[1] as SAFlutterPluginCallMap | undefined;
      let properties: global.EventProps | undefined;
      if (propertiesMap) {
        properties = SAFlutterUtils.mapToJsonObject(propertiesMap);
      }
      const timer = this.moduleManager.fetchTrackTimer(eventName);
      if (timer) {
        sensors.trackTimerEnd(timer, properties);
        this.moduleManager.cleanTrackTimer(eventName);
      }
    } catch (e) {
      console.error(e);
      result.error("TRACK_ERROR", "Failed to trackTimerEnd", e.toString());
    }
  }

  clearTrackTimer(call: MethodCall, result: MethodResult): void {
    try {
      sensors.clearAllTrackTimer()
      // 保留 timer，用于直接触发事件
      // this.moduleManager.cleanTrackTimer();
    } catch (e) {
      console.error(e);
      result.error("TRACK_ERROR", "Failed to clearTrackTimer", e.toString());
    }
  }

  removeTimer(call: MethodCall, result: MethodResult): void {
    try {
      const eventName = call.args[0] as string;
      const timer = this.moduleManager.fetchTrackTimer(eventName);
      if (timer) {
        sensors.clearTrackTimer(timer)
      }
      // 保留 timer，用于直接触发事件
      // this.moduleManager.cleanTrackTimer(eventName);
    } catch (e) {
      console.error(e);
      result.error("TRACK_ERROR", "Failed to removeTimer", e.toString());
    }
  }

  trackTimerResume(call: MethodCall, result: MethodResult): void {
    try {
      const eventName = call.args[0] as string;
      const timer = this.moduleManager.fetchTrackTimer(eventName);
      sensors.trackTimerResume(timer);
    } catch (e) {
      console.error(e);
      result.error("TRACK_ERROR", "Failed to trackTimerResume", e.toString());
    }
  }

  trackTimerPause(call: MethodCall, result: MethodResult): void {
    try {
      const eventName = call.args[0] as string;
      const timer = this.moduleManager.fetchTrackTimer(eventName);
      sensors.trackTimerPause(timer);
    } catch (e) {
      console.error(e);
      result.error("TRACK_ERROR", "Failed to trackTimerPause", e.toString());
    }
  }

  trackViewScreen(call: MethodCall, result: MethodResult): void {
    try {
      const url = call.args[0] as string;
      const propertiesMap =
        call.args[1] as SAFlutterPluginCallMap | undefined;
      let properties: global.EventProps | undefined;
      if (propertiesMap) {
        properties = SAFlutterUtils.mapToJsonObject(propertiesMap);
      }
      sensors.trackViewScreen({
        $screen_name: url,
      }, properties);

    } catch (e) {
      console.error(e);
      result.error("TRACK_ERROR", "Failed to trackViewScreen", e.toString());
    }
  }

  registerSuperProperties(call: MethodCall, result: MethodResult): void {
    try {
      const propertiesMap =
        call.args[0] as SAFlutterPluginCallMap | undefined;
      let properties: global.EventProps | undefined;
      if (propertiesMap) {
        properties = SAFlutterUtils.mapToJsonObject(propertiesMap);
      }
      if (properties) {
        sensors.register(properties);
      }
    } catch (e) {
      console.error(e);
      result.error("REGISTER_SUPER_PROPERTIES_ERROR", "Failed to register super properties", e.toString());
    }
  }

  clearSuperProperties(result: MethodResult): void {
    try {
      sensors.clearAllRegister();
    } catch (e) {
      console.error(e);
      result.error("CLEAR_SUPER_PROPERTIES_ERROR", "Failed to clear super properties", e.toString());
    }
  }

  unregisterSuperProperty(call: MethodCall, result: MethodResult): void {
    try {
      const property = call.args[0] as string;
      if (property) {
        sensors.clearAllRegister([property])
      }
    } catch (e) {
      console.error(e);
      result.error("unregisterSuperProperty", "Failed to clear unregisterSuperProperty", e.toString());
    }
  }

  profileSet(call: MethodCall, result: MethodResult): void {
    try {
      const propertiesMap =
        call.args[0] as SAFlutterPluginCallMap | undefined;
      let properties: global.EventProps | undefined;
      if (propertiesMap) {
        properties = SAFlutterUtils.mapToJsonObject(propertiesMap);
      }
      if (properties) {
        sensors.setProfile(properties);
      }
    } catch (e) {
      console.error(e);
      result.error("PROFILE_SET_ERROR", "Failed to set profile", e.toString());
    }
  }

  profileSetOnce(call: MethodCall, result: MethodResult): void {
    try {
      const propertiesMap = call.args[0] as SAFlutterPluginCallMap | undefined;
      let properties: global.EventProps | undefined;
      if (propertiesMap) {
        properties = SAFlutterUtils.mapToJsonObject(propertiesMap);
      }
      if (properties) {
        sensors.setOnceProfile(properties);
      }
    } catch (e) {
      console.error(e);
      result.error("PROFILE_SET_ONCE_ERROR", "Failed to set profile once", e.toString());
    }
  }

  profileUnset(call: MethodCall, result: MethodResult): void {
    try {
      const propertiesMap = call.args[0] as string | undefined;
      if (propertiesMap) {
        sensors.unsetProfile(propertiesMap);
      }
    } catch (e) {
      console.error(e);
      result.error("PROFILE_UNSET_ERROR", "Failed to unset profile", e.toString());
    }
  }

  profileIncrement(call: MethodCall, result: MethodResult): void {
    try {
      const key = call.args[0] as string | undefined;
      const value = call.args[1] as number | undefined;
      const param = {} as Record<string, number>;
      if (key === undefined || value === undefined) {
        result.error("PROFILE_INCREMENT_ERROR", "Key or value is undefined", null);
        return;
      }
      param[key] = value;
      sensors.incrementProfile(param);

    } catch (e) {
      console.error(e);
      result.error("PROFILE_INCREMENT_ERROR", "Failed to increment profile", e.toString());
    }
  }

  profileAppend(call: MethodCall, result: MethodResult): void {
    try {
      const key = call.args[0] as string | undefined;
      const value = call.args[1] as Array<string> | undefined;
      if (key === undefined || value === undefined) {
        result.error("PROFILE_APPEND_ERROR", "Key or value is undefined", null);
        return;
      }
      const param = {} as Record<string, Array<string>>;
      param[key] = value;
      sensors.appendProfile(param);
    } catch (e) {
      console.error(e);
      result.error("PROFILE_APPEND_ERROR", "Failed to append profile", e.toString());
    }
  }

  profileDelete(call: MethodCall, result: MethodResult): void {
    try {
      sensors.deleteProfile();

    } catch (e) {
      console.error(e);
      result.error("PROFILE_DELETE_ERROR", "Failed to delete profile", e.toString());
    }
  }

  identify(call: MethodCall, result: MethodResult): void {
    try {
      const params = call.args[0] as string | undefined;
      if (params) {
        sensors.identify(params);
      }

    } catch (e) {
      console.error(e);
      result.error("IDENTIFY_ERROR", "Failed to identify", e.toString());
    }
  }

  login(call: MethodCall, result: MethodResult): void {
    try {
      const params = call.args[0] as string | undefined;
      const propertiesMap =
        call.args[1] as SAFlutterPluginCallMap | undefined;
      let properties: global.EventProps | undefined;
      if (propertiesMap) {
        properties = SAFlutterUtils.mapToJsonObject(propertiesMap);
      }
      if (properties) {
        sensors.login(params, properties);
      } else {
        sensors.login(params);
      }

    } catch (e) {
      console.error(e);
      result.error("LOGIN_ERROR", "Failed to login", e.toString());
    }
  }

  logout(result: MethodResult): void {
    try {
      sensors.logout();

    } catch (e) {
      console.error(e);
      result.error("LOGOUT_ERROR", "Failed to logout", e.toString());
    }
  }

  bind(call: MethodCall, result: MethodResult): void {
    try {
      const key = call.args[0] as string | undefined;
      const value = call.args[1] as string | undefined;
      if (key === undefined || value === undefined) {
        result.error("BIND_ERROR", "Key or value is undefined", null);
        return;
      }
      sensors.bind(key, value);
    } catch (e) {
      console.error(e);
      result.error("BIND_ERROR", "Failed to bind", e.toString());
    }
  }

  unbind(call: MethodCall, result: MethodResult): void {
    try {
      const key = call.args[0] as string | undefined;
      const value = call.args[1] as string | undefined;
      if (key === undefined || value === undefined) {
        result.error("UNBIND_ERROR", "Key or value is undefined", null);
        return;
      }
      sensors.unbind(key, value);
    } catch (e) {
      console.error(e);
      result.error("UNBIND_ERROR", "Failed to unbind", e.toString());
    }
  }

  itemDelete(call: MethodCall, result: MethodResult): void {
    try {
      const key = call.args[0] as string | undefined;
      const value = call.args[1] as string | undefined;
      if (key === undefined || value === undefined) {
        result.error("ITEM_DELETE_ERROR", "Key or value is undefined", null);
        return;
      }
      sensors.deleteItem(key, value);
    } catch (e) {
      console.error(e);
      result.error("ITEM_DELETE_ERROR", "Failed to delete item", e.toString());
    }
  }

  itemSet(call: MethodCall, result: MethodResult): void {
    try {
      const itemType = call.args[0] as string | undefined;
      const itemID = call.args[1] as string | undefined;
      if (itemType === undefined || itemID === undefined) {
        result.error("ITEM_SET_ERROR", "ItemType or ItemID is undefined", null);
        return;
      }
      const propertiesMap: Map<string, string | number | boolean | undefined | Map<string, string | number | boolean | undefined>> =
        call.args[2];
      let properties: Record<string, string | number | boolean | undefined | Map<string, string | number | boolean | undefined>> | undefined;
      if (propertiesMap) {
        properties = SAFlutterUtils.mapToJsonObject(propertiesMap);
      }
      sensors.setItem(itemType, itemID, properties);
    } catch (e) {
      console.error(e);
      result.error("ITEM_SET_ERROR", "Failed to set item", e.toString());
    }
  }

  deleteAll(result: MethodResult): void {
    try {
      sensors.deleteAll();
    } catch (e) {
      console.error(e);
      result.error("FLUSH_ERROR", "Failed to flush", e.toString());
    }
  }

  flush(result: MethodResult): void {
    try {
      sensors.flush();
    } catch (e) {
      console.error(e);
      result.error("FLUSH_ERROR", "Failed to flush", e.toString());
    }
  }

  getDistinctId(call: MethodCall, result: MethodResult): void {
    try {
      result.success(sensors.getDistinctID() as string);
    } catch (e) {
      console.error(e);
      result.error("GET_DISTINCT_ID_ERROR", "Failed to get distinct ID", e.toString());
    }
  }

  getAnonymousId(call: MethodCall, result: MethodResult): void {
    try {
      result.success(sensors.getAnonymousID() as string);
    } catch (e) {
      console.error(e);
      result.error("GET_ANONYMOUS_ID_ERROR", "Failed to get anonymous ID", e.toString());
    }
  }

  getLoginId(call: MethodCall, result: MethodResult): void {
    try {
      result.success(sensors.getLoginID() as string);
    } catch (e) {
      console.error(e);
      result.error("GET_LOGIN_ID_ERROR", "Failed to get login ID", e.toString());
    }
  }

  getPresetProperties(result: MethodResult): void {
    try {
      result.success(sensors.getPresetProperties());
    } catch (e) {
      console.error(e);
      result.error("GET_PRESET_PROPERTIES_ERROR", "Failed to get preset properties", e.toString());
    }
  }

  trackAppInstall(call: MethodCall, result: MethodResult): void {
    try {
      const propertiesMap =
        call.args[0] as SAFlutterPluginCallMap | undefined;
      let properties: global.EventProps | undefined;
      if (propertiesMap) {
        properties = SAFlutterUtils.mapToJsonObject(propertiesMap);
      }
      if (properties) {
        sensors.trackAppInstall(properties);
      }
    } catch (e) {
      console.error(e);
      result.error("TRACK_APP_INSTALL_ERROR", "Failed to track app install", e.toString());
    }
  }


  startWithConfig(call: MethodCall, result: MethodResult): void {
    try {
      const map: Map<string, string | number | boolean | undefined | Map<string, string | number | boolean | undefined>> =
        call.args[0];

      const getArg = <T>(key: string): T | undefined => {
        return map.get(key) as T | undefined;
      };

      // 构建 InitPara 参数
      const initPara: global.InitPara = {
        context: this.context as object,
        server_url: map.get('serverUrl') as string
      };

      const showLog = getArg<boolean>('enableLog');
      if (showLog) {
        initPara.show_log = showLog;
      }

      const appJsBridge = getArg<boolean>('javaScriptBridge');
      if (appJsBridge) {
        initPara.app_js_bridge = appJsBridge;
      }

      // 构建 BatchSendPara 参数
      const batchSend: BatchSendPara = {};
      const flushInterval = getArg<number>('flushInterval');
      if (flushInterval) {
        batchSend.flush_interval = flushInterval;
      }

      const flushBulkSize = getArg<number>('flushBulkSize');
      if (flushBulkSize) {
        batchSend.flush_bulk_size = flushBulkSize;
      }

      // 参考 Android、iOS，默认使用 AES+RSA 加密
      const harmonyConfig = getArg<Map<string, string | number | boolean | undefined>>('harmony');
      if (harmonyConfig != undefined) {
        const pubKey = harmonyConfig.get("publicKey") as string;
        const pkv = harmonyConfig.get("pkv") as number;
        if (typeof pubKey === 'string' && pubKey.length > 0 && pkv != -1) {
          sensors.use(SAAESEncryption, {
            pkv: pkv,
            pub_key: pubKey
          });
        }

        const maxCacheSize = harmonyConfig.get("maxCacheSize") as number;
        if (maxCacheSize) {
          batchSend.max_cache_size = maxCacheSize;
        }
      }

      if (Object.keys(batchSend).length > 0) {
        initPara.batch_send = batchSend;
      }

      // 解析全埋点配置
      const autoTrackTypes = getArg<number>('autotrackTypes') as number;
      if (autoTrackTypes > 0) {
        const autoTrackTypeSet: Set<SAAutoTrackType> = SAFlutterUtils.convertEnumToAutoTrackSet(autoTrackTypes);
        if (autoTrackTypeSet) {
          // 注册全埋点插件，开启全埋点
          sensors.use(SAAutoTrack({
            auto_track_types: autoTrackTypeSet
          }))
        }
      }

      // 初始化 sensors
      sensors.init(initPara);

      const globalPropertiesMap = getArg<Map<string, string | number | boolean | undefined>>('globalProperties');
      const globalProperties = SAFlutterUtils.convertMapToJsonObject(globalPropertiesMap) as global.EventProps;
      // 注册属性插件，采集全局属性
      if (!SAFlutterUtils.isEmpty(globalProperties)) {
        const plugin = new SAFlutterGlobalPropertyPlugin(globalProperties);
        sensors.registerPropertyPlugin(plugin);
      }

    } catch (e) {
      console.error(e);
      result.error("START_WITH_CONFIG_ERROR", "Failed to start with config", e.toString());
    }
  }
}

interface BatchSendPara {
  max_cache_size?: number
  flush_interval?: number,
  flush_bulk_size?: number
}