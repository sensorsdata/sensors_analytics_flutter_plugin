package com.sensorsdata.analytics.sensorsanalyticsflutterplugin;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;

import com.sensorsdata.analytics.android.sdk.SALog;

import io.flutter.plugin.common.MethodChannel;

public class FlutterVisual {
    private static final String TAG = "SA.FlutterVisual";
    private final DynamicReceiver mDynamicReceiver;
    private MethodChannel mMethodChannel;
    private static final String FLUTTER_ACTION = "android.intent.action.FLUTTER_VISUALIZED";
    private static final String FLUTTER_EXTRA = "visualizedChanged";
    private volatile boolean isRegister = false;
    private static volatile FlutterVisual mFlutterVisual;

    private FlutterVisual() {
        mDynamicReceiver = new DynamicReceiver();
    }

    public static FlutterVisual getInstance() {
        if (mFlutterVisual == null) {
            synchronized (FlutterVisual.class) {
                if (mFlutterVisual == null) {
                    mFlutterVisual = new FlutterVisual();
                }
            }
        }
        return mFlutterVisual;
    }

    public void setMethodChannel(MethodChannel methodChannel) {
        this.mMethodChannel = methodChannel;
    }

    class DynamicReceiver extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (mMethodChannel != null && intent != null && intent.getStringExtra(FLUTTER_EXTRA) != null) {
                if (intent.getStringExtra(FLUTTER_EXTRA).equals("visualizedConnectionStatusChanged")) {
                    SALog.i(TAG, "visualizedConnectionStatusChanged");
                    mMethodChannel.invokeMethod("visualizedConnectionStatusChanged", null);
                } else if (intent.getStringExtra(FLUTTER_EXTRA).equals("visualizedPropertiesConfigChanged")) {
                    SALog.i(TAG, "visualizedPropertiesConfigChanged");
                    mMethodChannel.invokeMethod("visualizedPropertiesConfigChanged", null);
                }
            }
        }
    }

    public synchronized void registerBroadcast(Context context) {
        SALog.i(TAG, "registerBroadcast:" + isRegister);
        if (!isRegister) {
            SALog.i(TAG, "registerBroadcast");
            IntentFilter filter = new IntentFilter();
            filter.addAction(FLUTTER_ACTION);
            context.registerReceiver(mDynamicReceiver, filter);
            isRegister = true;
        }
    }

    public synchronized void unRegisterBroadcast(Context context) {
        SALog.i(TAG, "unRegisterBroadcast");
        context.unregisterReceiver(mDynamicReceiver);
        isRegister = false;
    }
}
