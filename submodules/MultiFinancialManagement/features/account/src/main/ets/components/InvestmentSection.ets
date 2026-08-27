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
  AmountText,
  ContentRow,
  IncomeText,
  PrimaryTitle,
  PrimaryTitleRow,
  SectionTitle,
  TertiaryText
} from './CommonView';

@ComponentV2
export struct InvestmentSection {
  @Param radius: number = 16;
  @Consumer('pageStack') pageStack: NavPathStack = new NavPathStack();
  @Env(SystemProperties.BREAK_POINT) breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;

  get isLargeScreen(): boolean {
    return this.breakpoint.widthBreakpoint >= WidthBreakpoint.WIDTH_LG;
  }

  build() {
    Column() {
      SectionTitle($r('app.string.account_invest_section_title'), $r('app.color.multi_color_11'),
        this.isLargeScreen ? TextAlign.Start : TextAlign.Center)

      GridRow({ columns: 2, gutter: 12 }) {
        GridCol({ span: { sm: 2, md: 1 } }) {
          this.WealthCard()
        }

        GridCol({ span: { sm: 2, md: 1 } }) {
          this.FundCard()
        }
      }
      .width('100%')
      .margin({ top: 12 })
    }
    .margin({
      left: CommonConstants.COMMON_PADDING[0].getValue(this.breakpoint.widthBreakpoint),
      right: CommonConstants.COMMON_PADDING[0].getValue(this.breakpoint.widthBreakpoint)
    })
  }

  @Builder
  WealthCard() {
    Column() {
      if (this.isLargeScreen) {
        PrimaryTitleRow($r('app.string.account_wealth'))
        AmountText(AccountConstants.INVESTMENT_WEALTH, 32)
        PrimaryTitleRow($r('app.string.account_half_year_treasure'), false)
      } else {
        PrimaryTitleRow($r('app.string.account_wealth'), true, AccountConstants.INVESTMENT_WEALTH)
        ContentRow($r('app.string.account_half_year_treasure'))
      }
      Row({ space: 4 }) {
        Column() {
          TertiaryText($r('app.string.account_yesterday_income'))
          TertiaryText($r('app.string.account_recent_redeem_date'))
        }
        .height('100%')
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.SpaceAround)

        Column() {
          IncomeText(AccountConstants.INVESTMENT_POSITION_INCOME)
          TertiaryText(AccountConstants.INVESTMENT_DATE)
        }
        .height('100%')
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.SpaceAround)

        Column() {
          PrimaryTitle(AccountConstants.INVESTMENT_POSITION_AMOUNT)
          TertiaryText($r('app.string.account_position_income'))
        }
        .height('100%')
        .margin({ bottom: 12 })
        .alignItems(HorizontalAlign.End)
        .justifyContent(FlexAlign.SpaceAround)
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .height(46)
    }
    .alignItems(HorizontalAlign.Start)
    .InvestmentCardStyle()
    .onClick(() => {
      this.pageStack.pushPath({ name: CommonConstants.FINANCIAL_DETAIL_PAGE_NAME })
    })
  }

  @Builder
  FundCard() {
    Column() {
      if (this.isLargeScreen) {
        PrimaryTitleRow($r('app.string.account_fund'))
        AmountText(AccountConstants.INVESTMENT_FUND, 32)
        PrimaryTitleRow($r('app.string.account_index_fund_c'), false)
      } else {
        PrimaryTitleRow($r('app.string.account_fund'), true, AccountConstants.INVESTMENT_FUND)
        ContentRow($r('app.string.account_index_fund_c'))
      }
      Row({ space: 4 }) {
        Column() {
          TertiaryText($r('app.string.account_yesterday_income'))
          TertiaryText($r('app.string.account_position_income'))
        }
        .height('100%')
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.SpaceAround)

        Column() {
          IncomeText(AccountConstants.INVESTMENT_YESTERDAY_INCOME_FUND)
          IncomeText(AccountConstants.INVESTMENT_POSITION_INCOME_FUND)
        }
        .height('100%')
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.SpaceAround)

        Column() {
          PrimaryTitle(AccountConstants.INVESTMENT_POSITION_AMOUNT_FUND)
          TertiaryText($r('app.string.account_position_amount'))
        }
        .height('100%')
        .alignItems(HorizontalAlign.End)
        .justifyContent(FlexAlign.SpaceAround)
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .height(46)
    }
    .alignItems(HorizontalAlign.Start)
    .InvestmentCardStyle()
    .onClick(() => {
      this.pageStack.pushPath({ name: CommonConstants.FINANCIAL_DETAIL_PAGE_NAME })
    })
  }

  @Styles
  InvestmentCardStyle(){
    .padding({
      top: this.isLargeScreen ? 4 : 12,
      bottom: 12,
      left: this.isLargeScreen ? 16 : 12,
      right: this.isLargeScreen ? 16 : 12
    })
    .height('auto')
    .borderRadius(this.radius)
    .backgroundColor($r('app.color.comp_background_list_card'))
  }
}