//
// SensorsAnalyticsFlutterPlugin.m
// sensors_analytics_flutter_plugin
//
// Created by  储强盛 on 2022/9/14.
// Copyright © 2015-2022 Sensors Data Co., Ltd. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "SensorsAnalyticsFlutterPlugin.h"
#import "SensorsAnalyticsSDK.h"
#import "SAFlutterGlobalPropertyPlugin.h"
#import <objc/runtime.h>

static NSString* const SensorsAnalyticsFlutterPluginMethodTrack = @"track";
static NSString* const SensorsAnalyticsFlutterPluginMethodTrackTimerStart = @"trackTimerStart";
static NSString* const SensorsAnalyticsFlutterPluginMethodTrackTimerEnd = @"trackTimerEnd";
static NSString* const SensorsAnalyticsFlutterPluginMethodTrackTimerClear = @"clearTrackTimer";
static NSString* const SensorsAnalyticsFlutterPluginMethodTrackInstallation = @"trackInstallation";
static NSString* const SensorsAnalyticsFlutterPluginMethodTrackViewScreenWithUrl = @"trackViewScreen";

static NSString* const SensorsAnalyticsFlutterPluginMethodLogin = @"login";
static NSString* const SensorsAnalyticsFlutterPluginMethodLogout = @"logout";
static NSString* const SensorsAnalyticsFlutterPluginMethodBind = @"bind";
static NSString* const SensorsAnalyticsFlutterPluginMethodUnbind = @"unbind";
static NSString* const SensorsAnalyticsFlutterPluginMethodLoginWithKey = @"loginWithKey";
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
static NSString* const SensorsAnalyticsFlutterPluginMethodInit = @"init";

/// 回调返回当前为可视化全埋点连接状态
static NSString* const SensorsAnalyticsGetVisualizedConnectionStatus = @"getVisualizedConnectionStatus";

/// 回调返回当前自定义属性配置
static NSString* const SensorsAnalyticsGetVisualizedPropertiesConfig = @"getVisualizedPropertiesConfig";

/// 发送 flutter 发送的页面数据
static NSString* const SensorsAnalyticsSendVisualizedMessage = @"sendVisualizedMessage";

/// 可视化全埋点状态改变，包括连接状态和自定义属性配置
static NSNotificationName const kSAFlutterPluginVisualizedStatusChangedNotification = @"SensorsAnalyticsVisualizedStatusChangedNotification";

@interface SensorsAnalyticsFlutterPlugin()
@property (nonatomic, weak) NSObject<FlutterPluginRegistrar> *registrar;

@end

@implementation SensorsAnalyticsFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {

    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"sensors_analytics_flutter_plugin"
                                     binaryMessenger:[registrar messenger]];
    SensorsAnalyticsFlutterPlugin* instance = [[SensorsAnalyticsFlutterPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    instance.registrar = registrar;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(chanedVisualizedStatus:) name:kSAFlutterPluginVisualizedStatusChangedNotification object:nil];
    }
    return self;
}

- (void)chanedVisualizedStatus:(NSNotification *)notification {
    if (![notification.userInfo isKindOfClass:NSDictionary.class]) {
        return;
    }

    NSDictionary *statusInfo = notification.userInfo;
    FlutterMethodChannel *methodChannel = [FlutterMethodChannel methodChannelWithName:@"sensors_analytics_flutter_plugin" binaryMessenger:[self.registrar messenger]];

    if (![statusInfo[@"context"] isKindOfClass:NSString.class]) {
        return;
    }

    if ([statusInfo[@"context"] isEqualToString:@"connectionStatus"]) {

        // 调用 Flutter， 通知进入可视化全埋点连接状态
        // Method : Method 名称
        // arguments : 传递给 Flutter 的数据
        [methodChannel invokeMethod:@"visualizedConnectionStatusChanged" arguments:nil];
        return;
    }

    if ([statusInfo[@"context"] isEqualToString:@"propertiesConfig"]) {
        // 调用 Flutter， 通知 Flutter 自定义属性配置修改
        // Method : Method 名称
        [methodChannel invokeMethod:@"visualizedPropertiesConfigChanged" arguments:nil];
        return;
    }
}

/// Flutter 调用接口
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
    }else if ([method isEqualToString:SensorsAnalyticsFlutterPluginMethodBind]){
        NSString* key = arguments[0];
        NSString* value = arguments[1];
        argumentSetNSNullToNil(&key);
        argumentSetNSNullToNil(&value);
        [self bind:key value:value];
        result(nil);
    }else if ([method isEqualToString:SensorsAnalyticsFlutterPluginMethodUnbind]){
        NSString* key = arguments[0];
        NSString* value = arguments[1];
        argumentSetNSNullToNil(&key);
        argumentSetNSNullToNil(&value);
        [self unbind:key value:value];
        result(nil);
    }else if ([method isEqualToString:SensorsAnalyticsFlutterPluginMethodLoginWithKey]){
        NSString* key = arguments[0];
        NSString* value = arguments[1];
        argumentSetNSNullToNil(&key);
        argumentSetNSNullToNil(&value);
        [self loginWithKey:key loginId:value];
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
        [self setFlushInterval:flushInterval.integerValue];
        result(nil);
    } else if([method isEqualToString:@"getFlushInterval"]){
        result(@([self getFlushInterval]));
    } else if ([method isEqualToString:@"setFlushBulkSize"]){
        NSNumber *flushBulkSize = arguments[0];
        argumentSetNSNullToNil(&flushBulkSize);
        [self setFlushBulkSize:flushBulkSize.integerValue];
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
        result(nil);
    }  else if ([method isEqualToString:@"itemDelete"]){
        NSString *itemType = arguments[0];
        argumentSetNSNullToNil(&itemType);
        NSString *itemId = arguments[1];
        argumentSetNSNullToNil(&itemId);
        [self itemDelete:itemType itemId:itemId];
        result(nil);
    }  else if ([method isEqualToString:SensorsAnalyticsFlutterPluginMethodInit]){
        // flutter 初始化 iOS SDK
        NSDictionary *config = arguments[0];
        argumentSetNSNullToNil(&config);
        [self startWithConfig:config];
        result(nil);
    } else if ([method isEqualToString:SensorsAnalyticsGetVisualizedConnectionStatus]){
        // 动态调用 SDK 接口，获取当前连接状态
        NSNumber *visualizedConnectioned = [self invokeSABridgeWithMethod:method arguments:nil];
        if (![visualizedConnectioned isKindOfClass:NSNumber.class]) {
            result(@(NO));
        }
        result(visualizedConnectioned);
    } else if([method isEqualToString:SensorsAnalyticsGetVisualizedPropertiesConfig]) {
        // 动态调用 SDK 接口，获取当前自定义属性配置
        NSString *jsonString = [self invokeSABridgeWithMethod:method arguments:nil];
        result(jsonString);
    } else if ([method isEqualToString:SensorsAnalyticsSendVisualizedMessage]){
        // 发送 Flutter 页面元素信息
        [self invokeSABridgeWithMethod:method arguments:arguments];
        result(nil);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

/// 动态调用 SA 接口
- (id)invokeSABridgeWithMethod:(NSString *)methodString arguments:(NSArray *)arguments {
    Class saBridgeClass = NSClassFromString(@"SAFlutterPluginBridge");
    SEL sharedInstanceSelector = NSSelectorFromString(@"sharedInstance");
    if (![saBridgeClass respondsToSelector:sharedInstanceSelector]) {
        return nil;
    }
    id sharedInstance = ((id (*)(id, SEL))[saBridgeClass methodForSelector:sharedInstanceSelector])(saBridgeClass, sharedInstanceSelector);
    if (!sharedInstance) {
        return nil;
    }

    // 获取连接状态
    if ([methodString isEqualToString:SensorsAnalyticsGetVisualizedConnectionStatus]) {
        SEL isVisualConnectionedSelector = NSSelectorFromString(@"isVisualConnectioned");
        if (![sharedInstance respondsToSelector:isVisualConnectionedSelector]) {
            return nil;
        }
        BOOL isVisualConnectioned = ((BOOL (*)(id, SEL))[sharedInstance methodForSelector:isVisualConnectionedSelector])(sharedInstance, isVisualConnectionedSelector);
        return @(isVisualConnectioned);
    }

    // 获取自定义属性配置
    if ([methodString isEqualToString:SensorsAnalyticsGetVisualizedPropertiesConfig]) {
        SEL visualPropertiesConfigSelector = NSSelectorFromString(@"visualPropertiesConfig");
        if (![sharedInstance respondsToSelector:visualPropertiesConfigSelector]) {
            return nil;
        }

        NSString *jsonString = ((NSString * (*)(id, SEL))[sharedInstance methodForSelector:visualPropertiesConfigSelector])(sharedInstance, visualPropertiesConfigSelector);
        return jsonString;
    }

    // 发送 Flutter 页面元素信息
    if ([methodString isEqualToString:SensorsAnalyticsSendVisualizedMessage]) {
        NSString *jsonString = arguments[0];
        if (!jsonString) {
            return nil;
        }
        SEL updateFlutterElementInfoSelector = NSSelectorFromString(@"updateFlutterElementInfo:");
        if (![sharedInstance respondsToSelector:updateFlutterElementInfoSelector]) {
            return nil;
        }
        ((void (*)(id, SEL, NSString *))[sharedInstance methodForSelector:updateFlutterElementInfoSelector])(sharedInstance, updateFlutterElementInfoSelector, jsonString);
    }
    return nil;
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

- (void)bind:(NSString *)key value:(NSString *)value {
    [SensorsAnalyticsSDK.sharedInstance bind:key value:value];
}

- (void)unbind:(NSString *)key value:(NSString *)value {
    [SensorsAnalyticsSDK.sharedInstance unbind:key value:value];
}

- (void)loginWithKey:(NSString *)key loginId:(NSString *)loginId {
    [SensorsAnalyticsSDK.sharedInstance loginWithKey:key loginId:loginId];
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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [SensorsAnalyticsSDK.sharedInstance setFlushNetworkPolicy:networkPolicy];
#pragma clang diagnostic pop
}

- (void)setFlushInterval:(NSInteger)FlushInterval {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [SensorsAnalyticsSDK.sharedInstance setFlushInterval:FlushInterval];
#pragma clang diagnostic pop
}

- (void)setFlushBulkSize:(NSInteger)flushBulkSize {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [SensorsAnalyticsSDK.sharedInstance setFlushBulkSize:flushBulkSize];
#pragma clang diagnostic pop
}

- (NSInteger)getFlushBulkSize {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return SensorsAnalyticsSDK.sharedInstance.flushBulkSize;
#pragma clang diagnostic pop
}

- (NSInteger)getFlushInterval {
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

- (void)startWithConfig:(NSDictionary *)config {
    if (![config isKindOfClass:[NSDictionary class]]) {
        return;
    }

    NSString *serverURL = config[@"serverUrl"];
    if (![serverURL isKindOfClass:[NSString class]]) {
        return;
    }

    SAConfigOptions *options = [[SAConfigOptions alloc] initWithServerURL:serverURL launchOptions:nil];

    NSNumber *autoTrack = config[@"autotrackTypes"];
    if ([autoTrack isKindOfClass:[NSNumber class]]) {
        options.autoTrackEventType = [autoTrack integerValue];
    }
    NSNumber *networkTypes = config[@"networkTypes"];
    if ([networkTypes isKindOfClass:[NSNumber class]]) {
        options.flushNetworkPolicy = [networkTypes integerValue];
    }
    NSNumber *flushInterval = config[@"flushInterval"];
    if ([flushInterval isKindOfClass:[NSNumber class]]) {
        options.flushInterval = [flushInterval integerValue];
    }
    NSNumber *flushBulksize = config[@"flushBulkSize"];
    if ([flushBulksize isKindOfClass:[NSNumber class]]) {
        options.flushBulkSize = [flushBulksize integerValue];
    }
    NSNumber *enableLog = config[@"enableLog"];
    if ([enableLog isKindOfClass:[NSNumber class]]) {
        options.enableLog = [enableLog boolValue];
    }
    NSNumber *enableEncrypt = config[@"encrypt"];
    if ([enableEncrypt isKindOfClass:[NSNumber class]]) {
        options.enableEncrypt = [enableEncrypt boolValue];
    }

    NSNumber *enableJavascriptBridge = config[@"javaScriptBridge"];
    if ([enableJavascriptBridge isKindOfClass:[NSNumber class]]) {
        options.enableJavaScriptBridge = [enableJavascriptBridge boolValue];
    }

    NSDictionary *iOSConfigs = config[@"ios"];
    if ([iOSConfigs isKindOfClass:[NSDictionary class]] && [iOSConfigs[@"maxCacheSize"] isKindOfClass:[NSNumber class]]) {
        options.maxCacheSize = [iOSConfigs[@"maxCacheSize"] integerValue];
    }

    NSNumber *enableHeatMap = config[@"heat_map"];
    if ([enableHeatMap isKindOfClass:[NSNumber class]]) {
        options.enableHeatMap = [enableHeatMap boolValue];
    }
    NSDictionary *visualizedSettings = config[@"visualized"];
    if ([visualizedSettings isKindOfClass:[NSDictionary class]]) {
        if ([visualizedSettings[@"autoTrack"] isKindOfClass:[NSNumber class]]) {
            options.enableVisualizedAutoTrack = [visualizedSettings[@"autoTrack"] boolValue];
        }
        if ([visualizedSettings[@"properties"] isKindOfClass:[NSNumber class]]) {
            options.enableVisualizedProperties = [visualizedSettings[@"properties"] boolValue];
        }
    }

    NSDictionary *properties = config[@"globalProperties"];
    if ([properties isKindOfClass:NSDictionary.class]) {
        SAFlutterGlobalPropertyPlugin *propertyPlugin = [[SAFlutterGlobalPropertyPlugin alloc] initWithGlobleProperties:properties];
        [options registerPropertyPlugin:propertyPlugin];
    }

    if (NSThread.isMainThread) {
        [SensorsAnalyticsSDK startWithConfigOptions:options];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SensorsAnalyticsSDK startWithConfigOptions:options];
        });
    }
}

static inline void argumentSetNSNullToNil(id *arg){
    *arg = (*arg == NSNull.null) ? nil:*arg;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
