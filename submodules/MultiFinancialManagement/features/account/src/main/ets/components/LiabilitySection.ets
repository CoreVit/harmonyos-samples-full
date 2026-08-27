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
import { AmountText, ContentRow, ContentText, ContextText, PrimaryTitle, SectionTitle } from './CommonView';

@ComponentV2
export struct LiabilitySection {
  @Param radius: number = 16;
  @Env(SystemProperties.BREAK_POINT) breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;

  build() {
    Column() {
      SectionTitle($r('app.string.account_liability_section_title'), $r('app.color.multi_color_08'),
        this.breakpoint.widthBreakpoint >= WidthBreakpoint.WIDTH_LG ? TextAlign.Start : TextAlign.Center)
      Column({ space: 4 }) {
        this.Header()
        if (this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM) {
          this.MainContent()
          ContentRow($r('app.string.account_available_limit'), AccountConstants.LIABILITY_AVAILABLE_LIMIT)
        } else if (this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_MD) {
          Row({ space: 28 }) {
            this.MainContent()
            Divider()
              .vertical(true)
              .strokeWidth(1)
              .height(36)
              .color($r('app.color.primary10'))
            ContentRow($r('app.string.account_available_limit'), AccountConstants.LIABILITY_AVAILABLE_LIMIT)
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .width('100%')
        } else {
          Row({ space: 28 }) {
            Column() {
              Row() {
                AmountText(AccountConstants.LIABILITY_AVAILABLE_LIMIT, 5)
                SymbolGlyph($r('sys.symbol.chevron_right'))
                  .fontSize(24)
                  .fontColor([$r('app.color.icon_tertiary')])
                  .margin({ left: 18 })
              }

              this.DesText($r('app.string.account_available_limit'))
            }
            .layoutWeight(1)
            .alignItems(HorizontalAlign.Start)

            Divider()
              .vertical(true)
              .strokeWidth(1)
              .height(125)
              .color($r('app.color.primary10'))
            Column() {
              Row() {
                AmountText(AccountConstants.LIABILITY_AMOUNT, 5)
                SymbolGlyph($r('sys.symbol.chevron_right'))
                  .fontSize(24)
                  .fontColor([$r('app.color.icon_tertiary')])
                  .margin({ left: 24 })
              }
              .width('100%')

              Text($r('app.string.account_remaining_rmb_due'))
                .fontSize(14)
                .lineHeight(19)
                .margin({ bottom: 45 })
              this.UnBilled()
            }
            .alignItems(HorizontalAlign.Start)
            .justifyContent(FlexAlign.Center)
            .layoutWeight(1)
          }
          .alignItems(VerticalAlign.Top)
          .width('100%')
        }
      }
      .width('100%')
      .padding({
        top: 4,
        bottom: 12,
        left: 16,
        right: 16
      })
      .margin({ top: 12 })
      .borderRadius(this.radius)
      .backgroundColor($r('app.color.comp_background_list_card'))
    }
    .margin({
      left: CommonConstants.COMMON_PADDING[0].getValue(this.breakpoint.widthBreakpoint),
      right: CommonConstants.COMMON_PADDING[0].getValue(this.breakpoint.widthBreakpoint)
    })
  }

  @Builder
  Header() {
    Row() {
      PrimaryTitle($r('app.string.account_credit_card_personal_consume'))
      SymbolGlyph($r('sys.symbol.dot_grid_1x2'))
        .fontSize(24)
        .fontColor([$r('app.color.icon_primary')])
    }
    .height(48)
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder
  MainContent() {
    Column({ space: 4 }) {
      this.RemainRepay()
      this.UnBilled()
    }
    .padding({ top: 4, bottom: 4 })
    .constraintSize({
      maxHeight: 57
    })
    .layoutWeight(1)
  }

  @Builder
  RemainRepay() {
    Row() {
      ContextText($r('app.string.account_remaining_rmb_due'))
      PrimaryTitle(AccountConstants.LIABILITY_AMOUNT)
    }
    .height(21)
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder
  UnBilled() {
    Row() {
      ContentText($r('app.string.account_unbilled_statement_amount'))
      Blank()
      ContentText($r('app.string.account_statement_date'))
      SymbolGlyph($r('sys.symbol.chevron_right'))
        .fontSize(24)
        .fontColor([$r('app.color.icon_tertiary')])
        .margin({ left: 8 })
    }
    .height(24)
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder
  DesText(text: ResourceStr) {
    Text(text)
      .fontSize(14)
      .lineHeight(19)
      .fontWeight(FontWeight.Medium)
      .fontColor($r('app.color.font_secondary'))
  }
}