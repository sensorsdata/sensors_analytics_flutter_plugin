import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:sensors_analytics_flutter_plugin/autotrack/pageview/sensors_page_stack.dart';
import 'package:sensors_analytics_flutter_plugin/autotrack/utils/element_util.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_autotrack.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_autotrack_config.dart';

class SANavigatorObserver extends NavigatorObserver {
  
  static List<NavigatorObserver> wrap(List<NavigatorObserver>? navigatorObservers) {
    if (navigatorObservers == null) {
      return [SANavigatorObserver()];
    }

    bool found = false;
    List<NavigatorObserver> removeList = [];
    for (NavigatorObserver observer in navigatorObservers) {
      if (observer is SANavigatorObserver) {
        if (found) {
          removeList.add(observer);
        }
        found = true;
      }
    }
    for (NavigatorObserver observer in removeList) {
      navigatorObservers.remove(observer);
    }
    if (!found) {
      navigatorObservers.insert(0, SANavigatorObserver());
    }
    return navigatorObservers;
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    
    try {
      this._findElement(route, (element) {
        SAPageStack.instance.push(route, element, previousRoute);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    // Add your custom logic here
    try {
      SAPageStack.instance.pop(route, previousRoute);
    } catch (e) {
      print(e);
    }
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    // Add your custom logic here
    try {
      SAPageStack.instance.remove(route, previousRoute);
    } catch (e) {
      print(e);
    }
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    // Add your custom logic here
    try {
      this._findElement(newRoute!, (element) {
        SAPageStack.instance.replace(newRoute, element, oldRoute);
      });
    } catch (e) {
      print(e);
    }
  }

  void _findElement(Route route, Function(Element) result) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // check ModelRoute first
      if (route is ModalRoute) {
        ModalRoute pageRoute = route;
        SAElementUtil.walk(pageRoute.subtreeContext, (element, parent) {
          if (parent != null && parent.widget is Semantics) {
            result(element);
            return false;
          }
          return true;
        });
      } else if (SAAutoTrackManager.instance.config.useCustomRoute) {
        List<SAAutoTrackPageConfig> pageConfigs = SAAutoTrackManager.instance.config.pageConfigs;
        if (pageConfigs.isEmpty) {
          return;
        }

        Element? lastPageElement;
        SAElementUtil.walk(route.navigator?.context, (element, parent) {
          if (pageConfigs.last.isPageWidget(element.widget)) {
            lastPageElement = element;
            return false;
          }
          return true;
        });
        if (lastPageElement != null) {
          result(lastPageElement!);
        }
      }
    });
  }
}