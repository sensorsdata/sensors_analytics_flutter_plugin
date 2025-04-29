  
#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import <SensorsAnalyticsSDK.h>
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //    [SensorsAnalyticsSDK sharedInstanceWithServerURL:@"http://sdk-test.cloud.sensorsdata.cn:8006/sa?project=default&token=95c73ae661f85aa0" andLaunchOptions:launchOptions andDebugMode:SensorsAnalyticsDebugAndTrack];
    //    [SensorsAnalyticsSDK.sharedInstance enableLog:YES];
    //    [[SensorsAnalyticsSDK sharedInstance] enableAutoTrack:SensorsAnalyticsEventTypeAppStart |
    //     SensorsAnalyticsEventTypeAppEnd |
    //     SensorsAnalyticsEventTypeAppClick|SensorsAnalyticsEventTypeAppViewScreen];
    //    [GeneratedPluginRegistrant registerWithRegistry:self];
    //  // Override point for customization after application launch.
    //  return [super application:application didFinishLaunchingWithOptions:launchOptions];
    //
    
    
    [GeneratedPluginRegistrant registerWithRegistry:self];
    
    // 初始化配置
    SAConfigOptions *options = [[SAConfigOptions alloc] initWithServerURL:@"http://sdkdebugtest.datasink.sensorsdata.cn/sa?project=default&token=cfb8b60e42e0ae9b" launchOptions:launchOptions];
    // 开启全埋点
    options.autoTrackEventType = SensorsAnalyticsEventTypeAppStart |
    SensorsAnalyticsEventTypeAppEnd;
    options.enableLog = YES;

    // 在 Flutter 中初始化 SDK
    // [SensorsAnalyticsSDK startWithConfigOptions:options];
    return [super application:application didFinishLaunchingWithOptions:launchOptions];;
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {

    if ([[SensorsAnalyticsSDK sharedInstance] canHandleURL:url]) {
        [[SensorsAnalyticsSDK sharedInstance] handleSchemeUrl:url];
    }

    return NO;
}


@end
