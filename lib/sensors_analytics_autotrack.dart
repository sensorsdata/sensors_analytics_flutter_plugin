import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:sensors_analytics_flutter_plugin/autotrack/element_click/sensors_element_path.dart';
import 'package:sensors_analytics_flutter_plugin/autotrack/element_click/sensors_pointer_event_listener.dart';
import 'package:sensors_analytics_flutter_plugin/autotrack/pageview/sensors_page_stack.dart';
import 'package:sensors_analytics_flutter_plugin/autotrack/utils/element_util.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_flutter_plugin.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_autotrack_config.dart';


///页面浏览接口
///配合全埋点功能使用，全埋点会判断页面浏览发生的页面是否实现了此接口，如果实现了此接口就使用此实现中的数据替换原始埋点数据
abstract class ISensorsDataViewScreen {
  ///页面名称，其格式为：package::xxx/yyy.dart/ZzzPage，表示 ZzzPage 在 yyy.dart 中使用，
  ///其中 package::xxx/yyy.dart 为 dart 的 importUri，ZzzPage 为页面 Widget。
  String? get viewScreenName;
  ///页面标题
  String? get viewScreenTitle;
  ///页面 url，如果为 null 就使用 viewScreenName 替换
  String? get viewScreenUrl => viewScreenName;
  ///其他的页面属性
  Map<String, dynamic>? get trackProperties;
}

class SAAutoTrackManager {
  static final SAAutoTrackManager instance = SAAutoTrackManager._();
  SAAutoTrackManager._();
  SAAutoTrackConfig _config = SAAutoTrackConfig();

  bool _enableElementClick = false;
  bool _enablePageView = false;
  
  SAAutoTrackConfig get config => _config;
  set config(SAAutoTrackConfig config) {
    _config = config;
  }

  void enablePageView(bool enable) {
    _enablePageView = enable;
  }

  bool get pageViewEnabled => _enablePageView;

  void enableElementClick(bool enable) {
    _enableElementClick = enable;
    if (enable) {
      SAPointerEventListener.instance.start();
    } else {
      SAPointerEventListener.instance.stop();
    }
  }

  bool get elementClickEnabled => _enableElementClick;

  SAAutoTrackPageConfig fingPageConfig(Widget pageWidget) {
    return _config.pageConfigs.firstWhere((element) => element.isPageWidget(pageWidget), orElse: () => SAAutoTrackPageConfig());
  }
}

class SAFlutterAutoTrackerPlugin {
  static final SAFlutterAutoTrackerPlugin instance = SAFlutterAutoTrackerPlugin._();
  SAFlutterAutoTrackerPlugin._();

  void trackPageView(SAPageInfo pageInfo) {
    if (!SAAutoTrackManager.instance.pageViewEnabled) {
      return;
    }
    Map<String, dynamic> properties = _getPropertiesFromPageInfo(pageInfo);
    properties.addAll(pageInfo.properties ?? {});
    properties[r'$lib_method'] = 'autoTrack';
    SensorsAnalyticsFlutterPlugin.track(kIsWeb ? r'$pageview' : r'$AppViewScreen', properties);
  }

  void trackElementClick(Element gestureElement, Element pageElement, SAPageInfo pageInfo) {
    if (!SAAutoTrackManager.instance.elementClickEnabled) {
      return;
    }
    Element element = SAElementPath.createFrom(element: gestureElement, pageElement: pageElement).element;
    bool isIgnore = false;
    Key? key = element.widget.key;
    Map<String, dynamic> properties = Map();
    if (key is SAElementKey) {
      isIgnore = key.isIgnore;
      properties.addAll(key.properties ?? {});
    }
    if (isIgnore) {
      return;
    }
    properties.addAll(_getPropertiesFromPageInfo(pageInfo));
    properties[r'$element_content'] = SAElementUtil.findTexts(element).join('-');
    properties[r'$element_type'] = element.widget.runtimeType.toString();
    properties[r'$lib_method'] = 'autoTrack';
    SensorsAnalyticsFlutterPlugin.track(kIsWeb ? r'$WebClick' : r'$AppClick', properties);
  }

  Map<String, dynamic> _getPropertiesFromPageInfo(SAPageInfo pageInfo) {
    Map<String, dynamic> properties = Map();
    properties[r'$title'] = pageInfo.title;
    properties[r'$screen_name'] = pageInfo.screenName;
    return properties;
  }
}