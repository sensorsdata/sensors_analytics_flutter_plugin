package com.sensorsdata.analytics.sensorsanalyticsflutterplugin;

import android.text.TextUtils;

import androidx.annotation.NonNull;

import com.sensorsdata.analytics.android.sdk.SALog;
import com.sensorsdata.analytics.android.sdk.SensorsDataAPI;

import org.json.JSONObject;

import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * Sensors Analytics Flutter Plugin
 */
public class SensorsAnalyticsFlutterPlugin implements FlutterPlugin, MethodCallHandler {
    private MethodChannel channel;
    private static final String TAG = "SA.SensorsAnalyticsFlutterPlugin";

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "sensors_analytics_flutter_plugin");
        channel.setMethodCallHandler(this);
    }

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "sensors_analytics_flutter_plugin");
        channel.setMethodCallHandler(new SensorsAnalyticsFlutterPlugin());
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        try {
            List list = (List) call.arguments;
            switch (call.method) {
                case "track":
                    track(list);
                    break;
                case "trackInstallation":
                    trackInstallation(list);
                    break;
                case "trackTimerStart":
                    trackTimerStart(list);
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
                case "enableDataCollect":
                    enableDataCollect();
                    break;
                default:
                    result.notImplemented();
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            SALog.d(TAG, e.getMessage());
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
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
        SensorsDataAPI.sharedInstance().login((String) list.get(0));
    }

    /**
     * trackViewScreen 触发 $AppViewScreen 事件
     */
    private void trackViewScreen(List list) {
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
    private void trackTimerStart(List list) {
        SensorsDataAPI.sharedInstance().trackTimerStart(assertEventName((String) list.get(0)));
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
    private void profilePushId(List list){
        SensorsDataAPI.sharedInstance().profilePushId((String)list.get(0), (String)list.get(1));
    }

    /**
     * 删除用户设置的 pushId
     */
    private void profileUnsetPushId(List list){
        SensorsDataAPI.sharedInstance().profileUnsetPushId((String)list.get(0));
    }

    /**
     * 开启数据采集
     */
    private void enableDataCollect(){
        SensorsDataAPI.sharedInstance().enableDataCollect();
    }

    private JSONObject assertProperties(Map map) {
        if (map != null) {
            return new JSONObject(map);
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

}
