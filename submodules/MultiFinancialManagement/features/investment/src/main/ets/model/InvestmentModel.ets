/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { CommonConstants } from 'financialbase';

export class InvestmentModel {
  private timelineList: TimelineItem[];

  constructor() {
    this.timelineList = [
      {
        date: $r('app.string.financial_detail_timeline_today'),
        action: $r('app.string.financial_detail_timeline_buy_in'),
        barColor: $r('app.color.brand20'),
        showLeftBorder: true,
        alignEnd: false
      },
      {
        date: CommonConstants.TIMELINE_DATE,
        action: $r('app.string.financial_detail_timeline_confirm_shares'),
        barColor: $r('app.color.comp_background_tertiary'),
        showLeftBorder: true,
        alignEnd: false
      },
      {
        date: CommonConstants.TIMELINE_DATE,
        action: $r('app.string.financial_detail_timeline_hold_and_redeem'),
        barColor: $r('app.color.comp_background_tertiary'),
        showLeftBorder: true,
        alignEnd: false
      },
      {
        date: CommonConstants.TIMELINE_PERPETUAL,
        action: $r('app.string.financial_detail_timeline_continue_investing'),
        barColor: $r('app.color.comp_background_tertiary'),
        showLeftBorder: false,
        alignEnd: true
      },
    ]
  }

  getTimelineList(): TimelineItem[] {
    return this.timelineList;
  }
}

export interface TimelineItem {
  date: ResourceStr;
  action: ResourceStr;
  barColor: ResourceColor;
  showLeftBorder: boolean;
  alignEnd: boolean;
}
