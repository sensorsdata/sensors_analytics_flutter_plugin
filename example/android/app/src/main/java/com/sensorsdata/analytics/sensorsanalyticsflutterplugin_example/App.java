package com.sensorsdata.analytics.sensorsanalyticsflutterplugin_example;


import com.sensorsdata.analytics.android.sdk.SAConfigOptions;
import com.sensorsdata.analytics.android.sdk.SensorsAnalyticsAutoTrackEventType;
import com.sensorsdata.analytics.android.sdk.SensorsDataAPI;

import io.flutter.app.FlutterApplication;

/**
 * Created by yzk on 2018/12/22
 */

public class App extends FlutterApplication {


    private final static String SA_SERVER_URL = "https://sdkdebugtest.datasink.sensorsdata.cn/sa?project=default&token=cfb8b60e42e0ae9b";

    @Override
    public void onCreate() {
        super.onCreate();
        //initSensorsDataAPI();
    }
//
//    /**
//     * 初始化 Sensors Analytics SDK
//     */
//    private void initSensorsDataAPI() {
//        SAConfigOptions configOptions = new SAConfigOptions(SA_SERVER_URL);
//        // 打开自动采集, 并指定追踪哪些 AutoTrack 事件
//        configOptions.setAutoTrackEventType(SensorsAnalyticsAutoTrackEventType.APP_START |
//                SensorsAnalyticsAutoTrackEventType.APP_END |
//                SensorsAnalyticsAutoTrackEventType.APP_VIEW_SCREEN |
//                SensorsAnalyticsAutoTrackEventType.APP_CLICK)
//                .enableTrackAppCrash()
//                .enableVisualizedAutoTrack(true)
//                //.disableDataCollect()
//                .enableVisualizedAutoTrackConfirmDialog(true);
//        SensorsDataAPI.startWithConfigOptions(this, configOptions);
//        SensorsDataAPI.sharedInstance(this).trackFragmentAppViewScreen();
//        SensorsDataAPI.sharedInstance().enableHeatMap();
//    }
}
