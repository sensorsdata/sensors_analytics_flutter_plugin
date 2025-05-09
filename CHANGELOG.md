## 4.0.1

* 修改依赖的原生 iOS 埋点 SDK 的引入方式

## 4.0.0

* 支持 HarmonyOS 埋点
* 支持 HarmonyOS 全埋点

## 3.0.1

* 修复页面名称字段错误的问题

## 3.0.0

* 支持全埋点
* Flutter 支持 Web 端数据采集

## 2.8.0

* 新增 namespace 配置以支持 Android AGP 8.0+ 

## 2.7.0

* register Receiver 适配 API 33 及以上版本

## 2.6.0

* 升级依赖的 Android SDK 版本到 v6.8.0

## 2.5.0

* 修复 getLoginId 方法缺陷

## 2.4.0

* 异常处理优化
* 支持页面离开事件采集

## 2.3.1

* Release 模式下，延迟初始化后立即触发事件失败的问题

## 2.3.0

* 支持 Flutter 项目可视化全埋点及自定义属性

## 2.2.2

* 新增接口 bind、unbind、loginWithKey

## 2.2.1

* Swift 项目中，使用 modular 头文件导入报错的缺陷

## 2.2.0

* 延迟初始化支持配置全局属性

## 2.1.1

* 初始化方法支持 await 修饰

## 2.1.0

* 支持 Flutter 项目延迟初始化 SDK

## 2.0.4

* 支持采集全埋点 SDK 版本号 

## 2.0.3

* 修复 enableR8 异常日志问题 

## 2.0.2

* 新增采集插件版本号功能

## 2.0.1

* 修复 track 接口时传入 const map 报错

## 2.0.0

* 支持 null safety

## 1.0.6

* 同步原生 SDK 接口

## 1.0.5

* 增加合规功能

## 1.0.4

* 属性中适配 DateTime 实例

## 1.0.2

* 新增 profilePushId 和 profileUnsetPushId 接口

## 1.0.0

* 事件追踪
* 用户属性修改
* App激活
* 用户登陆
* 其他