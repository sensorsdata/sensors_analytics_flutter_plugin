//
// SAFlutterManager
// SensorsAnalyticsFlutterPlugin
//
// Created by chuqiangsheng on 2025/04/24.
// Copyright © 2015-2025 Sensors Data Co., Ltd. All rights reserved.
//

import { TimeTracker } from "@sensorsdata/analytics";

export class SAFlutterManager extends Object {
  private trackTimerList: Map<string, Promise<TimeTracker>> = new Map();

  fetchTrackTimer(evetName: string): Promise<TimeTracker> | null {
    if (evetName && typeof evetName === 'string') {
      if (this.trackTimerList.has(evetName)) {
        return this.trackTimerList.get(evetName);
      }
    }
    return null;
  }

  async insertTrackTimer(trackTimer: Promise<TimeTracker>) {
    if (!trackTimer) {
      return;
    }
    this.trackTimerList.set((await trackTimer).event, trackTimer);
  }

  cleanTrackTimer(evetName?: string) {
    if (evetName) {
      this.trackTimerList.delete(evetName);
    } else {
      this.trackTimerList.clear();
    }
  }
}
