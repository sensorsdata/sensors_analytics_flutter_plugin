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
        NSString *eventId = [self trackTimerStart:event];
        result(eventId);
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
    } else if ([method isEqualToString:@"setServerUrl"]){
        NSString *serverUrl = arguments[0];
        argumentSetNSNullToNil(&serverUrl);
        NSNumber *isRequestRemoteConfig = arguments[1];
        argumentSetNSNullToNil(&isRequestRemoteConfig);
        [self setServerUrl:serverUrl isRequestRemoteConfig:isRequestRemoteConfig.boolValue];
        result(nil);
    } else if ([method isEqualToString:@"getPresetProperties"]){
        NSDictionary *properties = [self getPresetProperties];
        result(properties);
    }  else if ([method isEqualToString:@"enableLog"]){
        NSString *enable = arguments[0];
        argumentSetNSNullToNil(&enable);
        [self enableLog:enable.boolValue];
        result(nil);
    }  else if ([method isEqualToString:@"setFlushNetworkPolicy"]){
        NSNumber *flushNetworkPolicy = arguments[0];
        argumentSetNSNullToNil(&flushNetworkPolicy);
        [self setFlushNetworkPolicy:flushNetworkPolicy.integerValue];
        result(nil);
    }  else if ([method isEqualToString:@"setFlushInterval"]){
        NSNumber *flushInterval = arguments[0];
        argumentSetNSNullToNil(&flushInterval);
        [self setFlushInterval:flushInterval.unsignedLongLongValue];
        result(nil);
    } else if([method isEqualToString:@"getFlushInterval"]){
        result(@([self getFlushInterval]));
    } else if ([method isEqualToString:@"setFlushBulkSize"]){
        NSNumber *flushBulkSize = arguments[0];
        argumentSetNSNullToNil(&flushBulkSize);
        [self setFlushBulkSize:flushBulkSize.unsignedLongLongValue];
        result(nil);
    } else if([method isEqualToString:@"getFlushBulkSize"]){
        result(@([self getFlushBulkSize]));
    } else if ([method isEqualToString:@"getAnonymousId"]){
        NSString *anonymousId = [self getAnonymousId];
        result(anonymousId);
    }  else if ([method isEqualToString:@"getLoginId"]){
        NSString *loginId = [self getLoginId];
        result(loginId);
    }  else if ([method isEqualToString:@"identify"]){
        NSString *distinctId = arguments[0];
        argumentSetNSNullToNil(&distinctId);
        [self identify:distinctId];
        result(nil);
    }  else if ([method isEqualToString:@"trackAppInstall"]){
        NSDictionary *properties = arguments[0];
        argumentSetNSNullToNil(&properties);
        NSNumber *disableCallback = arguments[1];
        argumentSetNSNullToNil(&disableCallback);
        [self trackAppInstall:properties disableCallback:disableCallback.boolValue];
        result(nil);
    }  else if ([method isEqualToString:@"trackTimerPause"]){
        NSString *eventName = arguments[0];
        argumentSetNSNullToNil(&eventName);
        [self trackTimerPause:eventName];
        result(nil);
    }  else if ([method isEqualToString:@"trackTimerResume"]){
        NSString *eventName = arguments[0];
        argumentSetNSNullToNil(&eventName);
        [self trackTimerResume:eventName];
        result(nil);
    }  else if ([method isEqualToString:@"removeTimer"]){
        NSString *eventName = arguments[0];
        argumentSetNSNullToNil(&eventName);
        [self removeTimer:eventName];
        result(nil);
    }  else if ([method isEqualToString:@"flush"]){
        [self flush];
        result(nil);
    }  else if ([method isEqualToString:@"deleteAll"]){
        [self deleteAll];
        result(nil);
    }  else if ([method isEqualToString:@"getSuperProperties"]){
        NSDictionary *properties = [self getSuperProperties];
        result(properties);
    }  else if ([method isEqualToString:@"itemSet"]){
        NSString *itemType = arguments[0];
        argumentSetNSNullToNil(&itemType);
        NSString *itemId = arguments[1];
        argumentSetNSNullToNil(&itemId);
        NSDictionary *properties = arguments[2];
        argumentSetNSNullToNil(&properties);
        [self itemSet:itemType itemId:itemId properties:properties];
    }  else if ([method isEqualToString:@"itemDelete"]){
        NSString *itemType = arguments[0];
        argumentSetNSNullToNil(&itemType);
        NSString *itemId = arguments[1];
        argumentSetNSNullToNil(&itemId);
        [self itemDelete:itemType itemId:itemId];
    }  else if ([method isEqualToString:SensorsAnalyticsFlutterPluginMethodEnableDataCollect]){
        result(nil);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

-(void)track:(NSString *)event properties:(nullable NSDictionary *)properties{
    [SensorsAnalyticsSDK.sharedInstance track:event withProperties:properties];
}
-(NSString *)trackTimerStart:(NSString *)event{
    return [SensorsAnalyticsSDK.sharedInstance trackTimerStart:event];
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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [SensorsAnalyticsSDK.sharedInstance trackViewScreen:url withProperties:properties];
#pragma clang diagnostic pop
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

- (void)setServerUrl:(NSString *)serverUrl isRequestRemoteConfig:(BOOL)isRequestRemoteConfig {
    [SensorsAnalyticsSDK.sharedInstance setServerUrl:serverUrl isRequestRemoteConfig:isRequestRemoteConfig];
}

- (NSDictionary *)getPresetProperties {
    return [SensorsAnalyticsSDK.sharedInstance getPresetProperties];
}

- (void)enableLog:(BOOL)enable {
    [SensorsAnalyticsSDK.sharedInstance enableLog:enable];
}

- (void)setFlushNetworkPolicy:(NSInteger)networkPolicy {
    [SensorsAnalyticsSDK.sharedInstance setFlushNetworkPolicy:networkPolicy];
}

- (void)setFlushInterval:(UInt64)FlushInterval {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [SensorsAnalyticsSDK.sharedInstance setFlushInterval:FlushInterval];
#pragma clang diagnostic pop
}

- (void)setFlushBulkSize:(UInt64)flushBulkSize {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [SensorsAnalyticsSDK.sharedInstance setFlushBulkSize:flushBulkSize];
#pragma clang diagnostic pop
}

- (UInt64)getFlushBulkSize {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return SensorsAnalyticsSDK.sharedInstance.flushBulkSize;
#pragma clang diagnostic pop
}

- (UInt64)getFlushInterval {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return SensorsAnalyticsSDK.sharedInstance.flushInterval;
#pragma clang diagnostic pop
}

- (NSString *)getAnonymousId {
    return SensorsAnalyticsSDK.sharedInstance.anonymousId;
}

- (NSString *)getLoginId {
    return SensorsAnalyticsSDK.sharedInstance.loginId;
}

- (void)identify:(NSString *)distinctId {
    [SensorsAnalyticsSDK.sharedInstance identify:distinctId];
}

- (void)trackAppInstall:(NSDictionary *)properties disableCallback:(BOOL)disableCallback {
    [SensorsAnalyticsSDK.sharedInstance trackInstallation:@"$AppInstall" withProperties:properties disableCallback:disableCallback];
}

- (void)trackTimerPause:(NSString *)eventName {
    [SensorsAnalyticsSDK.sharedInstance trackTimerPause:eventName];
}

- (void)trackTimerResume:(NSString *)eventName {
    [SensorsAnalyticsSDK.sharedInstance trackTimerResume:eventName];
}

- (void)removeTimer:(NSString *)eventName {
    [SensorsAnalyticsSDK.sharedInstance removeTimer:eventName];
}

- (void)flush {
    [SensorsAnalyticsSDK.sharedInstance flush];
}

- (void)deleteAll {
    [SensorsAnalyticsSDK.sharedInstance deleteAll];
}

- (NSDictionary *)getSuperProperties {
    return [SensorsAnalyticsSDK.sharedInstance currentSuperProperties];
}

- (void)itemSet:(NSString *)itemType itemId:(NSString *)itemId properties:(NSDictionary *)properties {
    [SensorsAnalyticsSDK.sharedInstance itemSetWithType:itemType itemId:itemId properties:properties];
}

- (void)itemDelete:(NSString *)itemType itemId:(NSString *)itemId  {
    [SensorsAnalyticsSDK.sharedInstance itemDeleteWithType:itemType itemId:itemId];
}

static inline void argumentSetNSNullToNil(id *arg){
    *arg = (*arg == NSNull.null) ? nil:*arg;
}

@end
