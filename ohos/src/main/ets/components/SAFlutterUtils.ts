//
// SAFlutterUtils
// SensorsAnalyticsFlutterPlugin
//
// Created by chuqiangsheng on 2025/04/23.
// Copyright © 2015-2025 Sensors Data Co., Ltd. All rights reserved.
//

import { SAAutoTrackType } from "@sensorsdata/analytics";

// 类型定义
type SAFlutterNestedValue = string | number | boolean | null | SAFlutterNestedMap | SAFlutterNestedValue[];
type SAFlutterNestedMap = Map<string, SAFlutterNestedValue>;
type SAFlutterNestedObject = Record<string, any>;

export class SAFlutterUtils extends Object {
  /**
   * 将 Flutter 传入的全埋点配置，拆分成鸿蒙接口的枚举集合
   * @param num Flutter 全埋点配置
   * @returns harmonyOS 全埋点配置
   */
  static convertEnumToAutoTrackSet(num: number): Set<SAAutoTrackType> {
    const set = new Set<SAAutoTrackType>();
    const enumValues = Object.values(SAAutoTrackType)
      .filter(v => typeof v === 'number') as number[];
    for (const value of enumValues) {
      if (num & value) {
        set.add(value as SAAutoTrackType);
      }
    }
    return set;
  }


  /**
   * 追加 object 中所有 key-value
   *
   * @param obj1 原始 object，如果包含需要追加的 key，则会被覆盖
   * @param obj2 需要追加内容的 object
   */
  static addEntriesFromObject(obj1: object, obj2: object) {
    if (Object.keys(obj2).length === 0) {
      return;
    }

    // 获取 JavaScript 对象的所有属性，并遍历添加到原始对象中
    Object.keys(obj2).forEach((key) => {
      obj1[key] = obj2[key];
    });
  }

  /**
   * 判断对象是否为空
   * @param obj 需要判断的 jsonObject 对象
   * @returns 是否为空
   */
  static isEmpty(obj: object): boolean {
    if (obj === null || obj === undefined || Object.keys(obj).length === 0) {
      return true;
    }
    return false;
  }

  /*
   * map 转 jsonObject，单层解析
   * @param map Flutter 传入解析的 map
   * @returns 转成 HarmonyOS 需要的 Record
   * */
  static mapToJsonObject<K extends string, V>(map: Map<K, V>): Record<K, V> {
    const obj: Record<K, V> = {} as Record<K, V>;
    map.forEach((value, key) => {
      obj[key] = value; //逐项赋值
    });
    return obj;
  }

  /*
   * map 转 jsonObject，支持递归解析
   * @param map Flutter 传入解析的 map
   * @returns 转成 HarmonyOS 需要的 Record
   * */
  static convertMapToJsonObject(map: SAFlutterNestedMap): SAFlutterNestedObject {
    const result: SAFlutterNestedObject = {};
    map.forEach((value, key) => {
      if (value instanceof Map) {
        // 递归处理嵌套Map
        result[key] = SAFlutterUtils.convertMapToJsonObject(value);
      } else if (Array.isArray(value)) {
        // 处理数组中的Map元素
        result[key] = value.map(item =>
        item instanceof Map ? SAFlutterUtils.convertMapToJsonObject(item) : item
        );
      } else {
        // 基础类型直接赋值
        result[key] = value;
      }
    });
    return result;
  }
}
