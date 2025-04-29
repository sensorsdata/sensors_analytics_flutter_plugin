import 'dart:collection';
import 'package:flutter/widgets.dart';
import 'package:sensors_analytics_flutter_plugin/autotrack/utils/element_util.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_analytics_autotrack.dart';
import 'package:sensors_analytics_flutter_plugin/sensors_autotrack_config.dart';


enum _SAPageRoutetype {
  push,
  pop,
  remove,
  replace,
}

class SAPageStack {
  
  static final instance = SAPageStack();
  LinkedList<_SAPage> _pages = LinkedList<_SAPage>();
  _SAPageTask _task = _SAPageTask();

  void push(Route route, Element element, Route? previousRoute) {
    _SAPage page = _SAPage.create(route, element);
    _pages.add(page);
    _task.addPush(page, page.previous);
  }

  void pop(Route route, Route? previousRoute) {
    if (_pages.isEmpty) {
      return;
    }
    _SAPage? page = _findPage(route);
    if (page != null) {
      _task.addPop(page, page.previous);
    }
    _removeAllAfter(page);
  }

  void remove(Route route, Route? previousRoute) {
    if (_pages.isEmpty) {
      return;
    }
    _SAPage? page = _findPage(route);
    if (page != null) {
      _pages.remove(page);
    }
  }

  void replace(Route newRoute, Element newElement, Route? oldRoute) {
    _SAPage newPage = _SAPage.create(newRoute, newElement);
    _SAPage? oldPage;
    if (oldRoute != null) {
      oldPage = _findPage(oldRoute);
      _removeAllAfter(oldPage);
    }
    _pages.add(newPage);
    _task.addReplace(newPage, oldPage);
  }

    _SAPage? _findPage(Route route) {
    if (_pages.isEmpty) {
      return null;
    }
    _SAPage? lastPage = _pages.last;
    while (lastPage != null) {
      if (lastPage.route == route) {
        return lastPage;
      }
      lastPage = lastPage.previous;
    }
    return null;
  }

  _SAPage? currentPage() {
    return _pages.isEmpty ? null : _pages.last;
  }

  _removeAllAfter(_SAPage? page) {
    while (page != null) {
      _pages.remove(page);
      page = page.next;
    }
  }
}

class _SAPage extends LinkedListEntry<_SAPage> {
  
  _SAPage._({
    required this.info,
    required this.route,
    required this.element,
  });

  final SAPageInfo info;
  final Route route;
  final Element element;

  factory _SAPage.create(Route route, Element element) {
    return _SAPage._(
      info: SAPageInfo.getInfo(route, element),
      route: route,
      element: element,
    );
  }
}

class SAPageInfo {
  
  SAPageInfo._();

  factory SAPageInfo.getInfo(Route route, Element element) {
    SAAutoTrackPageConfig pageConfig = SAAutoTrackManager.instance.fingPageConfig(element.widget);
    SAPageInfo info = SAPageInfo._();
    info.title = pageConfig.title ?? (SAElementUtil.findTitle(element) ?? '');
    info.screenName = pageConfig.screenName ?? element.widget.runtimeType.toString();
    info.ignore = pageConfig.ignore;
    info.properties = pageConfig.properties;
    return info;
  }

  String title = '';
  String screenName = '';
  bool ignore = false;
  Map<String, dynamic>? properties;
}

class _SAPageTask {
  
  List<_SAPageTaskData> _taskDatas = [];
  bool _isTaskRunning = false;

  void addPush(_SAPage page, _SAPage? previousPage) {
    _SAPageTaskData taskData = _SAPageTaskData(page: page, type: _SAPageRoutetype.push);
    taskData.previousPage = previousPage;
    _taskDatas.add(taskData);
    startTask();
  }

  void addPop(_SAPage page, _SAPage? previousPage) {
    _SAPageTaskData taskData = _SAPageTaskData(page: page, type: _SAPageRoutetype.pop);
    taskData.previousPage = previousPage;
    _taskDatas.add(taskData);
    startTask();
  }

  void addReplace(_SAPage page, _SAPage? previousPage) {
    _SAPageTaskData taskData = _SAPageTaskData(page: page, type: _SAPageRoutetype.replace);
    taskData.previousPage = previousPage;
    _taskDatas.add(taskData);
    startTask();
  }

  void addRemove(_SAPage page, _SAPage? previousPage) {
  }

  void startTask() {
    if (_isTaskRunning) {
      return;
    }
    _isTaskRunning = true;
    Future.delayed(Duration(milliseconds: 30), () {
      _runTask();
    });
  }

  void _runTask() {
    if (_taskDatas.isEmpty) {
      _isTaskRunning = false;
      return;
    }
    List list = _taskDatas.sublist(0);
    //use leavePage to track PageLeave in the futher
    _SAPage? enterPage, leavePage;
    _taskDatas.clear();
    for (_SAPageTaskData data in list) {
      switch (data.type) {
        case _SAPageRoutetype.push:
        if (leavePage == null) {
          leavePage = data.previousPage;
        }
          enterPage = data.page;
          break;
        case _SAPageRoutetype.pop:
        if (leavePage == null) {
          leavePage = data.page;
        }
        if (enterPage == null || enterPage == data.page) {
          enterPage = data.previousPage;
        }
          break;
        case _SAPageRoutetype.replace:
        if (leavePage == null) {
          leavePage = data.previousPage;
        }
        if (enterPage == null || enterPage == data.previousPage) {
          enterPage = data.page;
        }
          break;
        case _SAPageRoutetype.remove:
          break;
      }
    }
    
    if (enterPage == leavePage) {
      _isTaskRunning = false;
      return;
    }
    //track page enter
    if (enterPage !=null && !enterPage.info.ignore) {
      SAFlutterAutoTrackerPlugin.instance.trackPageView(enterPage.info);
    }
    //track page leave
    if (leavePage != null && !leavePage.info.ignore) {
      
    }
    _isTaskRunning = false;
    
  }
}

class _SAPageTaskData {
  _SAPageTaskData({
    required this.page,
    required this.type,
  });
  final _SAPageRoutetype type;
  final _SAPage page;
  _SAPage? previousPage;
}