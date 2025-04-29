//
// SAFlutterGlobalPropertyPlugin
// SensorsAnalyticsFlutterPlugin
//
// Created by chuqiangsheng on 2025/04/23.
// Copyright © 2015-2025 Sensors Data Co., Ltd. All rights reserved.
//

import { RegisterPropertyPluginArg, EventProps } from "@sensorsdata/analytics";
import { SAFlutterUtils } from "./SAFlutterUtils";

export interface SAFlutterEventData {
  // 事件属性
  properties: object;

  // 事件名
  event: string;

  // 事件类型
  type: string;
}

/**
 * 定义属性插件，采集全局属性
 */
export class SAFlutterGlobalPropertyPlugin implements RegisterPropertyPluginArg {
  // 需要采集的全局属性
  globalProperties: EventProps;

  constructor(properties: EventProps) {
    this.globalProperties = properties;
  }

  properties(eventData: SAFlutterEventData): void {
    if (!SAFlutterUtils.isEmpty(this.globalProperties)) {
      SAFlutterUtils.addEntriesFromObject(eventData.properties, this.globalProperties);
    }
  }

  // 只对事件类型添加属性，不支持 item 相关
  validEventArray: string[] = ['track', 'track_signup', 'track_id_bind', 'track_id_unbind'];

  isMatchedWithFilter(eventData: SAFlutterEventData): boolean {
    if (SAFlutterUtils.isEmpty(this.globalProperties)) {
      return false;
    }

    return this.validEventArray.includes(eventData.type);
  }
}

/**
 * 定义属性插件，采集动态公共属性，暂未使用
 */
export class SAFlutterDynamicSuperPropertyPlugin implements RegisterPropertyPluginArg {
  // 需要采集的全局属性
  dynamicProperties: EventProps | null;

  // constructor(properties: SA.NativeSensorsAnalyticsModule.SAPropertiesObjectType) {
  //   this.dynamicProperties = properties;
  // }

  properties(eventData: SAFlutterEventData): void {
    if (!SAFlutterUtils.isEmpty(this.dynamicProperties)) {
      SAFlutterUtils.addEntriesFromObject(eventData.properties, this.dynamicProperties);
    }
  }

  // 只对事件类型添加属性，不支持 item 相关
  validEventArray: string[] = ['track', 'track_signup', 'track_id_bind', 'track_id_unbind'];

  isMatchedWithFilter(eventData: SAFlutterEventData): boolean {
    if (SAFlutterUtils.isEmpty(this.dynamicProperties)) {
      return false;
    }
    return this.validEventArray.includes(eventData.type);
  }
}

