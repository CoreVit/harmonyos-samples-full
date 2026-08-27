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

import { uiObserver } from '@kit.ArkUI';
import { CommonConstants } from 'financialbase';
import { AccountConstants } from '../constants/AccountConstants';
import {
  AmountText, ContentRow, PrimaryTitleRow, SectionTitle, TertiaryText
} from './CommonView';

@ComponentV2
export struct DemandDepositSection {
  @Env(SystemProperties.BREAK_POINT) breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;
  @Param radius: number = 16;

  build() {
    Column() {
      SectionTitle($r('app.string.account_demand_deposit'), $r('app.color.brand'),
        this.breakpoint.widthBreakpoint >= WidthBreakpoint.WIDTH_LG ? TextAlign.Start : TextAlign.Center)
      if (this.breakpoint.widthBreakpoint >= WidthBreakpoint.WIDTH_LG) {
        this.WideContent()
      } else {
        this.BaseContent()
      }
    }
    .margin({
      left: CommonConstants.COMMON_PADDING[0].getValue(this.breakpoint.widthBreakpoint),
      right: CommonConstants.COMMON_PADDING[0].getValue(this.breakpoint.widthBreakpoint)
    })
  }

  @Styles
  DemandCardStyle(){
    .layoutWeight(1)
    .padding({
      top: 6,
      left: 16,
      right: 16
    })
    .height(129)
    .borderRadius(this.radius)
    .backgroundColor($r('app.color.comp_background_list_card'))
  }

  @Builder
  private BaseContent() {
    Column({ space: 4 }) {
      PrimaryTitleRow($r('app.string.account_savings_card'), true, AccountConstants.DEMAND_AMOUNT)
      if (this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM) {
        ContentRow($r('app.string.account_demand_deposit'), AccountConstants.DEMAND_DEPOSIT)
        ContentRow($r('app.string.account_daily_treasure'), AccountConstants.DEMAND_WEALTH,
          $r('app.string.account_yesterday_income_value'))
      } else {
        Row({ space: 28 }) {
          ContentRow($r('app.string.account_demand_deposit'), AccountConstants.DEMAND_DEPOSIT)
          Divider()
            .vertical(true)
            .strokeWidth(1)
            .height(40)
            .color($r('app.color.primary10'))
          ContentRow($r('app.string.account_daily_treasure'), AccountConstants.DEMAND_WEALTH,
            $r('app.string.account_yesterday_income_value'))
        }
        .width('100%')
        .padding({
          top: 4,
          bottom: 4
        })
        .alignItems(VerticalAlign.Center)
      }
    }
    .width('100%')
    .padding({
      top: 4,
      bottom: 8,
      left: 12,
      right: 12
    })
    .borderRadius(this.radius)
    .backgroundColor($r('app.color.comp_background_list_card'))
    .margin({ top: 12 })
  }

  @Builder
  private WideContent() {
    Row({ space: 12 }) {
      Column() {
        PrimaryTitleRow($r('app.string.account_savings_card'), false)
        AmountText(AccountConstants.DEMAND_AMOUNT)
      }
      .alignItems(HorizontalAlign.Start)
      .DemandCardStyle()

      Column() {
        PrimaryTitleRow($r('app.string.account_demand_deposit'))
        AmountText(AccountConstants.DEMAND_DEPOSIT)
      }
      .alignItems(HorizontalAlign.Start)
      .DemandCardStyle()

      Column() {
        PrimaryTitleRow($r('app.string.account_daily_treasure'))
        AmountText(AccountConstants.DEMAND_WEALTH)
        TertiaryText($r('app.string.account_yesterday_income_value'))
      }
      .alignItems(HorizontalAlign.Start)
      .DemandCardStyle()
    }
    .width('100%')
    .margin({ top: 12 })
  }
}