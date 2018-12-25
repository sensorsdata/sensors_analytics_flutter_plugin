#import "SensorsAnalyticsFlutterPlugin.h"
#import "SensorsAnalyticsSDK.h"
#import <objc/runtime.h>

static NSString* const SensorsAnalyticsFlutterPluginMethodTrack = @"track";
static NSString* const SensorsAnalyticsFlutterPluginMethodTrackTimerStart = @"trackTimerStart";
static NSString* const SensorsAnalyticsFlutterPluginMethodTrackTimerEnd = @"trackTimerEnd";
static NSString* const SensorsAnalyticsFlutterPluginMethodTrackTimerClear = @"clearTrackTimer";
static NSString* const SensorsAnalyticsFlutterPluginMethodTrackInstallation = @"trackInstallation";
static NSString* const SensorsAnalyticsFlutterPluginMethodTrackViewScreenWithUrl = @"trackViewScreenWithUrl";

static NSString* const SensorsAnalyticsFlutterPluginMethodLogin = @"login";
static NSString* const SensorsAnalyticsFlutterPluginMethodLogout = @"logout";
static NSString* const SensorsAnalyticsFlutterPluginMethodGetDistincsId = @"getDistinctId";
static NSString* const SensorsAnalyticsFlutterPluginMethodClearKeychainData = @"clearKeychainData";

static NSString* const SensorsAnalyticsFlutterPluginMethodProfileSet = @"profileSet";
static NSString* const SensorsAnalyticsFlutterPluginMethodProfileSetOnce = @"profileSetOnce";
static NSString* const SensorsAnalyticsFlutterPluginMethodProfileUnset = @"profileUnset";
static NSString* const SensorsAnalyticsFlutterPluginMethodProfileIncrement = @"profileIncrement";
static NSString* const SensorsAnalyticsFlutterPluginMethodProfileAppend = @"profileAppend";
static NSString* const SensorsAnalyticsFlutterPluginMethodProfileDelete = @"profileDelete";



@implementation SensorsAnalyticsFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"sensors_analytics_flutter_plugin"
            binaryMessenger:[registrar messenger]];
  SensorsAnalyticsFlutterPlugin* instance = [[SensorsAnalyticsFlutterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if (shouldHandleMessage(call.method)){
        NSString* selString = SAFlutterPluginSupportedMethodDict()[call.method];
        SEL sel = NSSelectorFromString(selString);
        NSMethodSignature *methodSignature = [SensorsAnalyticsFlutterPlugin instanceMethodSignatureForSelector:sel];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        invocation.target = self;
        invocation.selector = sel;
        [invocation retainArguments];
        if(call.arguments){
            if ([call.arguments isKindOfClass:NSArray.class]) {
                for (int i = 0; i<[call.arguments count];i++) {
                    id obj  = call.arguments[i];
                    if ([obj isKindOfClass:NSNull.class]){
                        obj = nil;
                    }
                    [invocation setArgument:&obj  atIndex:2+i];
                }
            }
        }
        [invocation invoke];
        const char *objCType = [methodSignature methodReturnType];
        if (strcmp(objCType, @encode(void)) == 0) {
            result(nil);
        }else if(strcmp(objCType, @encode(id)) == 0){
            void *returnValue = NULL;
            [invocation getReturnValue:&returnValue];
            result((__bridge id)returnValue);
        }else {
            result(FlutterMethodNotImplemented);
        }
    }else {
        result(FlutterMethodNotImplemented);
    }
}

-(void)track:(NSString *)event properties:(nullable NSDictionary *)properties{
    [SensorsAnalyticsSDK.sharedInstance track:event withProperties:properties];
}
-(void)trackTimerStart:(NSString *)event{
    [SensorsAnalyticsSDK.sharedInstance trackTimerStart:event];
}
-(void)trackTimerEnd:(NSString *)event properties:(nullable NSDictionary *)properties {
    [SensorsAnalyticsSDK.sharedInstance trackTimerEnd:event withProperties:properties];
}

-(void)clearTrackTimer{
    [SensorsAnalyticsSDK.sharedInstance clearTrackTimer];
}

-(void)trackInstallation:(NSString *)event properties:(nullable NSDictionary *)properties {
    [SensorsAnalyticsSDK.sharedInstance trackInstallation:event withProperties:properties];
}

-(void)login:(NSString *)loginId {
    [SensorsAnalyticsSDK.sharedInstance login:loginId];
}

-(void)logout {
    [SensorsAnalyticsSDK.sharedInstance logout];
}

-(void)trackViewScreenWithUrl:(NSString *)url porperties:(nullable NSDictionary *)properties {
    [SensorsAnalyticsSDK.sharedInstance trackViewScreen:url withProperties:properties];
}

-(void)profileSet:(NSDictionary *)profileDict{
    [SensorsAnalyticsSDK.sharedInstance set:profileDict];
}

-(void)profileSetOnce:(NSDictionary *)profileDict{
    [SensorsAnalyticsSDK.sharedInstance setOnce:profileDict];
}

-(void)profileUnset:(NSString *)profile{
    [SensorsAnalyticsSDK.sharedInstance unset:profile];
}

-(void)profileIncrement:(NSString *)profile by:(NSNumber *)amount{
    [SensorsAnalyticsSDK.sharedInstance increment:profile by:amount];
}

-(void)profileAppend:(NSString *)profile by:(NSArray *)content{
    [SensorsAnalyticsSDK.sharedInstance append:profile by:content];
}

-(void)profileDelete{
    [SensorsAnalyticsSDK.sharedInstance deleteUser];
}

-(void)clearKeychainData {
    [SensorsAnalyticsSDK.sharedInstance clearKeychainData];
}

-(NSString *)getDistinctId{
    return SensorsAnalyticsSDK.sharedInstance.distinctId;
}

static inline BOOL shouldHandleMessage(NSString * method){
    return [SAFlutterPluginSupportedMethodDict().allKeys containsObject:method];
}

-(NSString* )getPlatformVersion{
    return [@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]];
}
static inline NSDictionary  * SAFlutterPluginSupportedMethodDict(void) {
    static dispatch_once_t onceToken;
    static NSDictionary *methodsShouldHandle = nil;
    dispatch_once(&onceToken, ^{
        methodsShouldHandle = @{SensorsAnalyticsFlutterPluginMethodTrack: @"track:properties:",
                                SensorsAnalyticsFlutterPluginMethodTrackTimerStart:@"trackTimerStart:",
                                SensorsAnalyticsFlutterPluginMethodTrackTimerEnd:@"trackTimerEnd:properties:",
                                SensorsAnalyticsFlutterPluginMethodTrackTimerClear:@"clearTrackTimer",
                                SensorsAnalyticsFlutterPluginMethodTrackInstallation:@"trackInstallation:properties:",
                                SensorsAnalyticsFlutterPluginMethodTrackViewScreenWithUrl:@"trackViewScreenWithUrl:porperties:",
                                SensorsAnalyticsFlutterPluginMethodLogin:@"login:",
                                SensorsAnalyticsFlutterPluginMethodLogout:@"logout",
                                SensorsAnalyticsFlutterPluginMethodGetDistincsId:@"getDistinctId",
                                SensorsAnalyticsFlutterPluginMethodClearKeychainData:@"clearKeychainData",
                                SensorsAnalyticsFlutterPluginMethodProfileSet:@"profileSet:",
                                SensorsAnalyticsFlutterPluginMethodProfileSetOnce:@"profileSetOnce:",
                                SensorsAnalyticsFlutterPluginMethodProfileUnset:@"profileUnset:",
                                SensorsAnalyticsFlutterPluginMethodProfileIncrement:@"profileIncrement:by:",
                                SensorsAnalyticsFlutterPluginMethodProfileAppend:@"profileAppend:by:",
                                SensorsAnalyticsFlutterPluginMethodProfileDelete:@"profileDelete"};
    });
    return  methodsShouldHandle;
}
@end
