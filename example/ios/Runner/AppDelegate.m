#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import <SensorsAnalyticsSDK.h>
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [SensorsAnalyticsSDK sharedInstanceWithServerURL:@"http://sdk-test.cloud.sensorsdata.cn:8006/sa?project=default&token=95c73ae661f85aa0" andLaunchOptions:launchOptions andDebugMode:SensorsAnalyticsDebugAndTrack];
    [SensorsAnalyticsSDK.sharedInstance enableLog:YES];
    [[SensorsAnalyticsSDK sharedInstance] enableAutoTrack:SensorsAnalyticsEventTypeAppStart |
     SensorsAnalyticsEventTypeAppEnd |
     SensorsAnalyticsEventTypeAppClick|SensorsAnalyticsEventTypeAppViewScreen];
    [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
