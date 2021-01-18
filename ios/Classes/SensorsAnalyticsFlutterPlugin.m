#import "SensorsAnalyticsFlutterPlugin.h"
#import "SensorsAnalyticsSDK.h"
#import <objc/runtime.h>

static NSString* const SensorsAnalyticsFlutterPluginMethodTrack = @"track";
static NSString* const SensorsAnalyticsFlutterPluginMethodTrackTimerStart = @"trackTimerStart";
static NSString* const SensorsAnalyticsFlutterPluginMethodTrackTimerEnd = @"trackTimerEnd";
static NSString* const SensorsAnalyticsFlutterPluginMethodTrackTimerClear = @"clearTrackTimer";
static NSString* const SensorsAnalyticsFlutterPluginMethodTrackInstallation = @"trackInstallation";
static NSString* const SensorsAnalyticsFlutterPluginMethodTrackViewScreenWithUrl = @"trackViewScreen";

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

static NSString* const SensorsAnalyticsFlutterPluginMethodRegisterSuperProperties = @"registerSuperProperties";
static NSString* const SensorsAnalyticsFlutterPluginMethodUnregisterSuperProperty = @"unregisterSuperProperty";
static NSString* const SensorsAnalyticsFlutterPluginMethodClearSuperProperties = @"clearSuperProperties";
static NSString* const SensorsAnalyticsFlutterPluginMethodProfilePushKey = @"profilePushId";
static NSString* const SensorsAnalyticsFlutterPluginMethodProfileUnsetPushKey = @"profileUnsetPushId";
static NSString* const SensorsAnalyticsFlutterPluginMethodEnableDataCollect = @"enableDataCollect";


@implementation SensorsAnalyticsFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"sensors_analytics_flutter_plugin"
                                     binaryMessenger:[registrar messenger]];
    SensorsAnalyticsFlutterPlugin* instance = [[SensorsAnalyticsFlutterPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* method = call.method;
    NSArray* arguments = (NSArray *)call.arguments;
    if([method isEqualToString:SensorsAnalyticsFlutterPluginMethodTrack]){
        NSString* event = arguments[0];
        argumentSetNSNullToNil(&event);
        NSDictionary* properties = arguments[1];
        argumentSetNSNullToNil(&properties);
        [self track:event properties:properties];
        result(nil);
    }else if([method isEqualToString:SensorsAnalyticsFlutterPluginMethodTrackTimerStart]){
        NSString* event = arguments[0];
        argumentSetNSNullToNil(&event);
        [self trackTimerStart:event];
        result(nil);
    }else if ([method isEqualToString:SensorsAnalyticsFlutterPluginMethodTrackTimerEnd]){
        NSString* event = arguments[0];
        argumentSetNSNullToNil(&event);
        NSDictionary* properties = arguments[1];
        argumentSetNSNullToNil(&properties);
        [self trackTimerEnd:event properties:properties];
        result(nil);
    }else if ([method isEqualToString:SensorsAnalyticsFlutterPluginMethodTrackTimerClear]){
        [self clearTrackTimer];
        result(nil);
    }else if ([method isEqualToString:SensorsAnalyticsFlutterPluginMethodTrackInstallation]){
        NSString* event = arguments[0];
        argumentSetNSNullToNil(&event);
        NSDictionary* properties = arguments[1];
        argumentSetNSNullToNil(&properties);
        [self trackInstallation:event properties:properties];
        result(nil);
    }else if ([method isEqualToString:SensorsAnalyticsFlutterPluginMethodTrackViewScreenWithUrl]){
        NSString* url = arguments[0];
        argumentSetNSNullToNil(&url);
        NSDictionary* properties = arguments[1];
        argumentSetNSNullToNil(&properties);
        [self trackViewScreenWithUrl:url porperties:properties];
        result(nil);
    }else if ([method isEqualToString:SensorsAnalyticsFlutterPluginMethodLogin]){
        NSString* loginId = arguments[0];
        argumentSetNSNullToNil(&loginId);
        [self login:loginId];
        result(nil);
    }else if ([method isEqualToString:SensorsAnalyticsFlutterPluginMethodLogout]){
        [self logout];
        result(nil);
    }else if([method isEqualToString:SensorsAnalyticsFlutterPluginMethodGetDistincsId]){
        result(self.getDistinctId);
    }else if ([method isEqualToString:SensorsAnalyticsFlutterPluginMethodClearKeychainData]){
        [self clearKeychainData];
        result(nil);
    }else if ([method isEqualToString:SensorsAnalyticsFlutterPluginMethodProfileSet]){
        NSDictionary* profileDict = arguments[0];
        argumentSetNSNullToNil(&profileDict);
        [self profileSet:profileDict];
        result(nil);
    }else if ([method isEqualToString:SensorsAnalyticsFlutterPluginMethodProfileSetOnce]){
        NSDictionary* profileDict = arguments[0];
        argumentSetNSNullToNil(&profileDict);
        [self profileSetOnce:profileDict];
        result(nil);
    }else if ([method isEqualToString:SensorsAnalyticsFlutterPluginMethodProfileUnset]){
        NSString* profile = arguments[0];
        argumentSetNSNullToNil(&profile);
        [self profileUnset:profile];
        result(nil);
    }else if ([method isEqualToString:SensorsAnalyticsFlutterPluginMethodProfileIncrement]){
        NSString *profile = arguments[0];
        argumentSetNSNullToNil(&profile);
        NSNumber *amount = arguments[1];
        argumentSetNSNullToNil(&amount);
        [self profileIncrement:profile by:amount];
        result(nil);
    }else if ([method isEqualToString:SensorsAnalyticsFlutterPluginMethodProfileAppend]){
        NSString *profile = arguments[0];
        argumentSetNSNullToNil(&profile);
        NSArray *content = arguments[1];
        argumentSetNSNullToNil(&content);
        [self profileAppend:profile by:content];
        result(nil);
    }else if ([method isEqualToString:SensorsAnalyticsFlutterPluginMethodProfileDelete]){
        [self profileDelete];
        result(nil);
    }else if ([method isEqualToString:SensorsAnalyticsFlutterPluginMethodRegisterSuperProperties]){
        NSDictionary* propertyDict = arguments[0];
        argumentSetNSNullToNil(&propertyDict);
        [self registerSuperProperties:propertyDict];
        result(nil);
    }else if ([method isEqualToString:SensorsAnalyticsFlutterPluginMethodUnregisterSuperProperty]){
        NSString* property = arguments[0];
        argumentSetNSNullToNil(&property);
        [self unregisterSuperProperty:property];
        result(nil);
    }else if ([method isEqualToString:SensorsAnalyticsFlutterPluginMethodClearSuperProperties]){
        [self clearSuperProperties];
        result(nil);
    }else if ([method isEqualToString:SensorsAnalyticsFlutterPluginMethodProfilePushKey]){
        NSString *pushKey = arguments[0];
        argumentSetNSNullToNil(&pushKey);
        NSString *pushId = arguments[1];
        argumentSetNSNullToNil(&pushId);
        [self profilePushKey:pushKey pushId:pushId];
        result(nil);
    }else if ([method isEqualToString:SensorsAnalyticsFlutterPluginMethodProfileUnsetPushKey]){
        NSString *pushKey = arguments[0];
        argumentSetNSNullToNil(&pushKey);
        [self profileUnsetPushKey:pushKey];
        result(nil);
    } else if ([method isEqualToString:SensorsAnalyticsFlutterPluginMethodEnableDataCollect]){
        result(nil);
     } else {
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

-(void)registerSuperProperties:(NSDictionary *)propertyDict{
    [SensorsAnalyticsSDK.sharedInstance registerSuperProperties:propertyDict];
}

-(void)unregisterSuperProperty:(NSString *)property{
    [SensorsAnalyticsSDK.sharedInstance unregisterSuperProperty:property];
}

- (void)clearSuperProperties {
   [SensorsAnalyticsSDK.sharedInstance clearSuperProperties];
}

- (void)profilePushKey:(NSString *)pushTypeKey pushId:(nonnull NSString *)pushId {
    [SensorsAnalyticsSDK.sharedInstance profilePushKey:pushTypeKey pushId:pushId];
}

- (void)profileUnsetPushKey:(NSString *)pushTypeKey {
    [SensorsAnalyticsSDK.sharedInstance profileUnsetPushKey:pushTypeKey];
}

static inline void argumentSetNSNullToNil(id *arg){
    *arg = (*arg == NSNull.null) ? nil:*arg;
}

@end
