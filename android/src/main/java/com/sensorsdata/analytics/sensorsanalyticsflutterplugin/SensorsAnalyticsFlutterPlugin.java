package com.sensorsdata.analytics.sensorsanalyticsflutterplugin;

import android.app.Activity;
import android.text.TextUtils;

import androidx.annotation.NonNull;

import com.sensorsdata.analytics.android.sdk.SAConfigOptions;
import com.sensorsdata.analytics.android.sdk.SALog;
import com.sensorsdata.analytics.android.sdk.SensorsDataAPI;
import com.sensorsdata.analytics.android.sdk.core.mediator.Modules;
import com.sensorsdata.analytics.android.sdk.core.mediator.SAModuleManager;
import com.sensorsdata.analytics.android.sdk.plugin.property.SAPropertyPlugin;
import com.sensorsdata.analytics.android.sdk.plugin.property.SAPropertyPluginPriority;
import com.sensorsdata.analytics.android.sdk.plugin.property.beans.SAPropertiesFetcher;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * Sensors Analytics Flutter Plugin
 */
public class SensorsAnalyticsFlutterPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    private MethodChannel channel;
    private Activity mActivity;
    private static final String TAG = "SA.SensorsAnalyticsFlutterPlugin";

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "sensors_analytics_flutter_plugin");
        channel.setMethodCallHandler(this);
        FlutterVisual.getInstance().setMethodChannel(channel);
        FlutterVisual.getInstance().registerBroadcast(flutterPluginBinding.getApplicationContext());
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        try {
            List list = (List) call.arguments;
            switch (call.method) {
                case "getVisualizedConnectionStatus":
                    result.success(SAModuleManager.getInstance().invokeModuleFunction(Modules.Visual.MODULE_NAME, Modules.Visual.METHOD_GET_VISUAL_STATE));
                    break;
                case "sendVisualizedMessage":
                    String msg = (String) list.get(0);
                    SAModuleManager.getInstance().invokeModuleFunction(Modules.Visual.MODULE_NAME, Modules.Visual.METHOD_SEND_VISUALIZED_MESSAGE, msg);
                    result.success(null);
                    break;
                case "getVisualizedPropertiesConfig":
                    result.success(SAModuleManager.getInstance().invokeModuleFunction(Modules.Visual.MODULE_NAME, Modules.Visual.METHOD_FLUTTER_GET_APPVISUAL_CONFIG));
                    break;
                case "setServerUrl":
                    setServerUrl(list);
                    break;
                case "getPresetProperties":
                    getPresetProperties(result);
                    break;
                case "enableLog":
                    enableLog(list);
                    break;
                case "setFlushNetworkPolicy":
                    setFlushNetworkPolicy(list);
                    break;
                case "setFlushInterval":
                    setFlushInterval(list);
                    break;
                case "getFlushInterval":
                    getFlushInterval(result);
                    break;
                case "getFlushBulkSize":
                    getFlushBulkSize(result);
                    break;
                case "setFlushBulkSize":
                    setFlushBulkSize(list);
                    break;
                case "getAnonymousId":
                    getAnonymousId(result);
                    break;
                case "getLoginId":
                    getLoginId(result);
                    break;
                case "identify":
                    identify(list);
                    break;
                case "trackAppInstall":
                    trackAppInstall(list);
                    break;
                case "flush":
                    flush();
                    break;
                case "deleteAll":
                    deleteAll();
                    break;
                case "getSuperProperties":
                    getSuperProperties(result);
                    break;
                case "enableNetworkRequest":
                    enableNetworkRequest(list);
                    break;
                case "itemSet":
                    itemSet(list);
                    break;
                case "itemDelete":
                    itemDelete(list);
                    break;
                case "isNetworkRequestEnable":
                    isNetworkRequestEnable(result);
                    break;
                case "track":
                    track(list);
                    break;
                case "trackInstallation":
                    trackInstallation(list);
                    break;
                case "trackTimerStart":
                    trackTimerStart(list, result);
                    break;
                case "trackTimerPause":
                    trackTimerPause(list);
                    break;
                case "trackTimerResume":
                    trackTimerResume(list);
                    break;
                case "removeTimer":
                    removeTimer(list);
                    break;
                case "trackTimerEnd":
                    trackTimerEnd(list);
                    break;
                case "clearTrackTimer":
                    clearTrackTimer();
                    break;
                case "login":
                    login(list);
                    break;
                case "logout":
                    logout();
                    break;
                case "trackViewScreen":
                    trackViewScreen(list);
                    break;
                case "profileSet":
                    profileSet(list);
                    break;
                case "profileSetOnce":
                    profileSetOnce(list);
                    break;
                case "registerSuperProperties":
                    registerSuperProperties(list);
                    break;
                case "unregisterSuperProperty":
                    unregisterSuperProperty(list);
                    break;
                case "clearSuperProperties":
                    clearSuperProperties();
                    break;
                case "profileUnset":
                    profileUnset(list);
                    break;
                case "profileIncrement":
                    profileIncrement(list);
                    break;
                case "profileAppend":
                    profileAppend(list);
                    break;
                case "profileDelete":
                    profileDelete();
                    break;
                case "getDistinctId":
                    getDistinctId(result);
                    break;
                case "profilePushId":
                    profilePushId(list);
                    break;
                case "profileUnsetPushId":
                    profileUnsetPushId(list);
                    break;
                case "init":
                    startWithConfig(list, result);
                    break;
                case "bind":
                    bind(list, result);
                    break;
                case "unbind":
                    unbind(list, result);
                    break;
                case "loginWithKey":
                    loginWithKey(list, result);
                    break;
                default:
                    result.notImplemented();
                    break;
            }
        } catch (Exception e) {
            SALog.d(TAG, e.getMessage());
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        FlutterVisual.getInstance().unRegisterBroadcast(binding.getApplicationContext());
    }

    private void isNetworkRequestEnable(Result result) {
        result.success(SensorsDataAPI.sharedInstance().isNetworkRequestEnable());
    }

    private void itemDelete(List list) {
        SensorsDataAPI.sharedInstance().itemDelete((String) list.get(0), (String) list.get(1));
    }

    private void itemSet(List list) {
        SensorsDataAPI.sharedInstance().itemSet((String) list.get(0), (String) list.get(1), assertProperties2(list.get(2)));
    }

    private void enableNetworkRequest(List list) {
        SensorsDataAPI.sharedInstance().enableNetworkRequest((Boolean) list.get(0));
    }

    private void getSuperProperties(Result result) {
        JSONObject jsonObject = SensorsDataAPI.sharedInstance().getSuperProperties();
        if (jsonObject != null) {
            Iterator<String> keys = jsonObject.keys();
            Map<String, Object> map = new HashMap<>();
            while (keys.hasNext()) {
                String key = keys.next();
                Object value = jsonObject.opt(key);
                if (value instanceof JSONArray) {
                    JSONArray jsonArray = (JSONArray) value;
                    if (jsonArray.length() != 0) {
                        ArrayList<Object> newValue = new ArrayList<>();
                        for (int index = 0; index < jsonArray.length(); index++) {
                            newValue.add(jsonArray.opt(index));
                        }
                        map.put(key, newValue);
                        continue;
                    }
                }
                map.put(key, value);
            }
            result.success(map);
        } else {
            result.success(null);
        }
    }

    private void deleteAll() {
        SensorsDataAPI.sharedInstance().deleteAll();
    }

    private void flush() {
        SensorsDataAPI.sharedInstance().flush();
    }

    private void trackAppInstall(List list) {
        SensorsDataAPI.sharedInstance().trackAppInstall(assertProperties2(list.get(0)), (Boolean) list.get(1));
    }

    private void identify(List list) {
        SensorsDataAPI.sharedInstance().identify((String) list.get(0));
    }

    private void getLoginId(Result result) {
        result.success(SensorsDataAPI.sharedInstance().getLoginId());
    }

    private void getAnonymousId(Result result) {
        result.success(SensorsDataAPI.sharedInstance().getAnonymousId());
    }

    private void getFlushBulkSize(Result result) {
        result.success(SensorsDataAPI.sharedInstance().getFlushBulkSize());
    }

    private void setFlushBulkSize(List list) {
        SensorsDataAPI.sharedInstance().setFlushBulkSize((Integer) list.get(0));
    }

    private void getFlushInterval(Result result) {
        result.success(SensorsDataAPI.sharedInstance().getFlushInterval());
    }

    /**
     * 设置两次数据发送的最小时间间隔
     */
    private void setFlushInterval(List list) {
        SensorsDataAPI.sharedInstance().setFlushInterval((Integer) list.get(0));
    }

    /**
     * 设置 flush 时网络发送策略，默认 3G、4G、WI-FI 环境下都会尝试 flush
     */
    private void setFlushNetworkPolicy(List list) {
        SensorsDataAPI.sharedInstance().setFlushNetworkPolicy((Integer) list.get(0));
    }

    /**
     * 设置是否开启 log
     */
    private void enableLog(List list) {
        SensorsDataAPI.sharedInstance().enableLog((Boolean) list.get(0));
    }

    /**
     * 获取预制属性
     */
    private void getPresetProperties(Result result) {
        JSONObject jsonObject = SensorsDataAPI.sharedInstance().getPresetProperties();
        if (jsonObject != null) {
            Iterator<String> keys = jsonObject.keys();
            Map<String, Object> map = new HashMap<>();
            while (keys.hasNext()) {
                String key = keys.next();
                Object value = jsonObject.opt(key);
                map.put(key, value);
            }
            result.success(map);
        } else {
            result.success(null);
        }
    }

    /**
     * set server url
     */
    private void setServerUrl(List list) {
        SensorsDataAPI.sharedInstance().setServerUrl((String) list.get(0), (Boolean) list.get(1));
    }

    /**
     * trackInstallation 记录激活事件
     */
    private void trackInstallation(List list) {
        SensorsDataAPI.sharedInstance().trackInstallation(assertEventName((String) list.get(0)), assertProperties((Map) list.get(1)));
    }

    /**
     * track 事件
     */
    private void track(List list) {
        SensorsDataAPI.sharedInstance().track(assertEventName((String) list.get(0)), assertProperties((Map) list.get(1)));
    }

    /**
     * login
     */
    private void login(List list) {
        SensorsDataAPI.sharedInstance().login((String) list.get(0), assertProperties((Map) list.get(1)));
    }

    /**
     * trackViewScreen 触发 $AppViewScreen 事件
     */
    @SuppressWarnings("deprecation")
    private void trackViewScreen(List list) {
        //使用了 Deprecated 方法，编译时会产生 xxxx 类使用或覆盖了已过时的 API。
        SensorsDataAPI.sharedInstance().trackViewScreen((String) list.get(0), assertProperties((Map) list.get(1)));
    }

    /**
     * profileSet 设置用户属性
     */
    private void profileSet(List list) {
        JSONObject properties = assertProperties((Map) list.get(0));
        if (properties == null) {
            return;
        }
        SensorsDataAPI.sharedInstance().profileSet(properties);
    }

    /**
     * getDistinctId 获取当前用户的 distinctId
     */
    private void getDistinctId(Result result) {
        String loginId = SensorsDataAPI.sharedInstance().getLoginId();
        if (!TextUtils.isEmpty(loginId)) {
            result.success(loginId);
        } else {
            result.success(SensorsDataAPI.sharedInstance().getAnonymousId());
        }
    }

    /**
     * profileDelete
     */
    private void profileDelete() {
        SensorsDataAPI.sharedInstance().profileDelete();
    }

    /**
     * profileAppend
     */
    @SuppressWarnings("unchecked")
    private void profileAppend(List list) {
        SensorsDataAPI.sharedInstance().profileAppend((String) list.get(0), new HashSet<>((Collection<? extends String>) list.get(1)));
    }

    /**
     * profileIncrement
     */
    private void profileIncrement(List list) {
        SensorsDataAPI.sharedInstance().profileIncrement((String) list.get(0), (Number) list.get(1));
    }

    /**
     * profileUnset
     */
    private void profileUnset(List list) {
        SensorsDataAPI.sharedInstance().profileUnset((String) list.get(0));
    }

    /**
     * profileSetOnce
     */
    private void profileSetOnce(List list) {
        JSONObject properties = assertProperties((Map) list.get(0));
        if (properties == null) {
            return;
        }
        SensorsDataAPI.sharedInstance().profileSetOnce(properties);
    }

    /**
     * logout
     */
    private void logout() {
        SensorsDataAPI.sharedInstance().logout();
    }


    /**
     * clearTrackTimer
     */
    private void clearTrackTimer() {
        SensorsDataAPI.sharedInstance().clearTrackTimer();
    }

    /**
     * trackTimerStart 计时开始
     */
    private void trackTimerStart(List list, Result result) {
        String tmp = SensorsDataAPI.sharedInstance().trackTimerStart(assertEventName((String) list.get(0)));
        result.success(tmp);
    }

    private void trackTimerPause(List list) {
        SensorsDataAPI.sharedInstance().trackTimerPause(assertEventName((String) list.get(0)));
    }

    private void trackTimerResume(List list) {
        SensorsDataAPI.sharedInstance().trackTimerResume(assertEventName((String) list.get(0)));
    }

    private void removeTimer(List list) {
        SensorsDataAPI.sharedInstance().removeTimer(assertEventName((String) list.get(0)));
    }

    /**
     * trackTimerEnd 计时结束并触发事件
     */
    private void trackTimerEnd(List list) {
        SensorsDataAPI.sharedInstance().trackTimerEnd(assertEventName((String) list.get(0)), assertProperties((Map) list.get(1)));
    }

    /**
     * registerSuperProperties 设置公共属性
     */
    private void registerSuperProperties(List list) {
        JSONObject properties = assertProperties((Map) list.get(0));
        if (properties == null) {
            return;
        }
        SensorsDataAPI.sharedInstance().registerSuperProperties(properties);
    }

    /**
     * unregisterSuperProperty 删除某个公共属性
     */
    private void unregisterSuperProperty(List list) {
        SensorsDataAPI.sharedInstance().unregisterSuperProperty((String) list.get(0));
    }

    /**
     * clearSuperProperties 清除本地存储的所有公共属性
     */
    private void clearSuperProperties() {
        SensorsDataAPI.sharedInstance().clearSuperProperties();
    }

    /**
     * 保存用户推送 ID 到用户表
     */
    private void profilePushId(List list) {
        SensorsDataAPI.sharedInstance().profilePushId((String) list.get(0), (String) list.get(1));
    }

    /**
     * 删除用户设置的 pushId
     */
    private void profileUnsetPushId(List list) {
        SensorsDataAPI.sharedInstance().profileUnsetPushId((String) list.get(0));
    }

    private void startWithConfig(List list, Result result) {
        try {
            Map map = (Map) list.get(0);
            Object serverUrl = map.get("serverUrl");

            SAConfigOptions configOptions = new SAConfigOptions(serverUrl == null ? "" : serverUrl.toString());
            Object autotrackTypes = map.get("autotrackTypes");
            if (autotrackTypes != null) {
                configOptions.setAutoTrackEventType((Integer) autotrackTypes);
            }

            Object networkTypes = map.get("networkTypes");
            if (networkTypes != null) {
                configOptions.setNetworkTypePolicy((Integer) networkTypes);
            }

            Object flushInterval = map.get("flushInterval");
            if (flushInterval != null) {
                configOptions.setFlushInterval((Integer) flushInterval);
            }

            Object flushBulkSize = map.get("flushBulkSize");
            if (flushBulkSize != null) {
                configOptions.setFlushBulkSize((Integer) flushBulkSize);
            }

            Object enableLog = map.get("enableLog");
            if (enableLog != null) {
                configOptions.enableLog((Boolean) enableLog);
            }

            Object encrypt = map.get("encrypt");
            if (encrypt != null) {
                configOptions.enableEncrypt((Boolean) encrypt);
            }

            Object heatMap = map.get("heatMap");
            if (heatMap != null) {
                configOptions.enableHeatMap((Boolean) heatMap);
            }

            Object androidConfig = map.get("android");
            boolean jellybean = false;
            if (androidConfig != null) {
                Map androidConfigMap = (Map) androidConfig;
                Object maxCacheSize = androidConfigMap.get("maxCacheSize");
                if (maxCacheSize != null) {
                    configOptions.setMaxCacheSize(Long.parseLong(maxCacheSize.toString()));
                }

                Object jellybeanObj = androidConfigMap.get("jellybean");
                if (jellybeanObj != null) {
                    jellybean = (boolean) jellybeanObj;
                }
                Object subProcessFlush = androidConfigMap.get("subProcessFlush");
                if (subProcessFlush != null && (boolean) subProcessFlush) {
                    configOptions.enableSubProcessFlushData();
                }
            }

            Object javaScriptBridge = map.get("javaScriptBridge");
            if (javaScriptBridge != null && (boolean) javaScriptBridge) {
                configOptions.enableJavaScriptBridge(jellybean);
            }

            Object visualizedConfig = map.get("visualized");
            if (visualizedConfig != null) {
                Map visualizedConfigMap = (Map) visualizedConfig;
                Object autoTrack = visualizedConfigMap.get("autoTrack");
                if (autoTrack != null) {
                    configOptions.enableVisualizedAutoTrack((Boolean) autoTrack);
                }

                Object properties = visualizedConfigMap.get("properties");
                if (properties != null) {
                    configOptions.enableVisualizedProperties((Boolean) properties);
                }
            }
            final Map globalProperties = (Map) map.get("globalProperties");
            if (globalProperties != null && globalProperties.size() > 0) {
                configOptions.registerPropertyPlugin(new SAPropertyPlugin() {

                    @Override
                    public SAPropertyPluginPriority priority() {
                        return SAPropertyPluginPriority.LOW;
                    }

                    @Override
                    public String getName() {
                        return "SAFlutterGloblePropertyPlugin";
                    }

                    @Override
                    public void properties(SAPropertiesFetcher fetcher) {
                        Iterator iterator = globalProperties.entrySet().iterator();
                        while (iterator.hasNext()) {
                            Map.Entry entry = (Map.Entry) iterator.next();
                            try {
                                fetcher.getProperties().put((String) entry.getKey(), entry.getValue());
                            } catch (JSONException e) {
                                SALog.printStackTrace(e);
                            }
                        }
                    }
                });
            }
            SensorsDataAPI.startWithConfigOptions(mActivity, configOptions);
        } catch (Exception e) {
            SALog.printStackTrace(e);
        }
        result.success(null);
    }

    private void bind(List list, Result result) {
        try {
            String key = (String) list.get(0);
            String value = (String) list.get(1);
            SensorsDataAPI.sharedInstance().bind(key, value);
            result.success(null);
        } catch (Exception e) {
            SALog.printStackTrace(e);
        }
    }

    private void unbind(List list, Result result) {
        try {
            String key = (String) list.get(0);
            String value = (String) list.get(1);
            SensorsDataAPI.sharedInstance().unbind(key, value);
            result.success(null);
        } catch (Exception e) {
            SALog.printStackTrace(e);
        }
    }

    private void loginWithKey(List list, Result result) {
        try {
            String key = (String) list.get(0);
            String value = (String) list.get(1);
            JSONObject properties = assertProperties2(list.get(2));
            SensorsDataAPI.sharedInstance().loginWithKey(key, value, properties);
            result.success(null);
        } catch (Exception e) {
            SALog.printStackTrace(e);
        }
    }

    private JSONObject assertProperties(Map map) {
        if (map != null) {
            return new JSONObject(map);
        } else {
            SALog.d(TAG, "传入的属性为空");
            return null;
        }
    }

    private JSONObject assertProperties2(Object map) {
        if (map != null) {
            return new JSONObject((Map) map);
        } else {
            SALog.d(TAG, "传入的属性为空");
            return null;
        }
    }

    private String assertEventName(String eventName) {
        if (TextUtils.isEmpty(eventName)) {
            SALog.d(TAG, "事件名为空，请检查代码");
        }
        return eventName;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        mActivity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        mActivity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivity() {
        mActivity = null;
    }
}
