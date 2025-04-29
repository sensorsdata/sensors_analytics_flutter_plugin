import { FlutterAbility, FlutterEngine } from '@ohos/flutter_ohos';
import { GeneratedPluginRegistrant } from '../plugins/GeneratedPluginRegistrant';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import Want from '@ohos.app.ability.Want';
import sensors from '@sensorsdata/analytics';
import { SAAutoTrack, SAAutoTrackType } from '@sensorsdata/analytics'
import { VoIPExtensionContext } from '@kit.PushKit';

export default class EntryAbility extends FlutterAbility {
  configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    GeneratedPluginRegistrant.registerWith(flutterEngine)
  }

  async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    super.onCreate(want, launchParam)
    // this.startSensorsAnalyticsSDK();
  }

  startSensorsAnalyticsSDK() {
    sensors.use(SAAutoTrack({
      auto_track_types: new Set<SAAutoTrackType>([
        SAAutoTrackType.APP_START,
        SAAutoTrackType.APP_END,
        SAAutoTrackType.APP_CLICK,
        SAAutoTrackType.APP_VIEW_SCREEN
      ])
    }))

    sensors.init({
      // 服务器接收地址
      // debug 数据接收地址： 'http://10.1.137.85:8106/debug?project=chuqiangsheng',
      // 正式数据接收地址： http://10.1.137.85:8106/sa?project=chuqiangsheng
      server_url: 'http://10.1.137.85:8106/sa?project=chuqiangsheng',
      // server_url: 'http://xxx',
      // Ability 上下文
      context: this.context,
      // 是否显示日志
      show_log: true,
      // 是否开启采集位置信息，需要 app 授权，默认 false
      enable_track_location: true,
      // 开启 App 打通 H5
      app_js_bridge: true,
      // cache_encrypt: true
      batch_send: {
        flush_interval: 1000
      }
    });
  }
}
