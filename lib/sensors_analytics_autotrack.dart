

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