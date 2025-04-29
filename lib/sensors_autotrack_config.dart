import 'package:flutter/widgets.dart';

class SAAutoTrackConfig {

SAAutoTrackConfig({
    this.pageConfigs = const [],
    this.useCustomRoute = false,
  });

  List<SAAutoTrackPageConfig> pageConfigs;
  //if use Route out of MaterialPageRoute/PageRoute/ModalRoute, must set this switch to true, and all pages should be set in pageConfigs
  bool useCustomRoute;
}

class SAAutoTrackPageConfig<T extends Widget> {
  
  SAAutoTrackPageConfig({
    String? title,
    String? screenName,
    Map<String, dynamic>? properties,
    bool ignore = false,
  })  : ignore = ignore {
    this.title = title;
    this.screenName = screenName;
    this.properties = properties;
  }

  String? title;
  String? screenName;
  Map<String, dynamic>? properties;
  bool ignore;

  bool isPageWidget(Widget pageWidget) => pageWidget is T;
}

class SAElementKey extends Key {
  final String key;
  final Map<String, dynamic>? properties;
  final bool isIgnore;
  SAElementKey(this.key, {this.properties, this.isIgnore = false}) : super.empty();
}