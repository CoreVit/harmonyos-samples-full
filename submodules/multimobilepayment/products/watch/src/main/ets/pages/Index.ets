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

import { AppStorageV2, ArcList, ArcListItem, ComponentContent, LengthMetrics } from '@kit.ArkUI';
import { CommonConstants, WindowUtil } from 'multimobilepaymentbase';
import { QuickActionModel } from '../model/QuickActionModel';
import { WatchPaymentView } from '../view/WatchPaymentView';
import { QuickActionViewModel } from '../viewmodel/QuickActionViewModel';

@Builder
function buildTitle() {
  Column({ space: $r('app.float.watch_header_column_space') }) {
    Text($r('app.string.app_title'))
      .fontSize($r('app.float.watch_title_font_size'))
      .fontColor($r('app.color.watch_text_primary'))
      .fontWeight(FontWeight.Bold)

    Row({ space: $r('app.float.watch_header_column_space') }) {
      SymbolGlyph($r('sys.symbol.local_fill'))
        .fontSize($r('app.float.watch_location_icon_size'))
        .fontColor([$r('app.color.watch_text_secondary')])

      Text($r('app.string.city_default'))
        .fontSize($r('app.float.watch_city_font_size'))
        .fontColor($r('app.color.watch_text_secondary'))
    }
  }
  .margin({ bottom: $r('app.float.watch_city_margin_bottom') })
}

@Entry
@ComponentV2
struct Index {
  @Local navPathStack: NavPathStack = new NavPathStack();
  @Local windowUtil: WindowUtil = AppStorageV2.connect(WindowUtil, CommonConstants.KEY_WINDOWUTIL)!;
  private context: UIContext = this.windowUtil.getUIContext() as UIContext;
  private quickActions: QuickActionModel[] = new QuickActionViewModel().getQuickActionList();
  titleArea: ComponentContent<Object> = new ComponentContent(this.context, wrapBuilder(buildTitle));

  @Builder
  pageMap(name: string) {
    if (name === 'WatchPaymentView') {
      WatchPaymentView({
        onClose: () => {
          this.navPathStack.pop();
        }
      })
    }
  }

  build() {
    Navigation(this.navPathStack) {
      Stack() {
        ArcList({ header: this.titleArea }) {
          ForEach(this.quickActions, (item: QuickActionModel, index: number) => {
            ArcListItem() {
              Button() {
                Row() {
                  Row() {
                    SymbolGlyph(item.getIcon())
                      .fontSize($r('app.float.watch_icon_size'))
                      .fontColor([$r('app.color.on_primary')])
                  }
                  .width($r('app.float.watch_icon_bg_size'))
                  .height($r('app.float.watch_icon_bg_size'))
                  .backgroundColor($r('app.color.button_background_light'))
                  .borderRadius($r('app.float.watch_icon_bg_size'))
                  .justifyContent(FlexAlign.Center)
                  .margin({
                    right: $r('app.float.watch_quick_action_icon_margin_right')
                  })

                  Text(item.getText())
                    .fontSize($r('app.float.watch_card_font_size'))
                    .fontColor($r('app.color.watch_text_primary'))
                    .fontWeight(FontWeight.Medium)
                    .width(CommonConstants.WATCH_TEXT_WIDTH)
                    .textAlign(TextAlign.Center)

                  Blank()

                  SymbolGlyph($r('sys.symbol.chevron_right'))
                    .fontSize($r('app.float.watch_chevron_icon_size'))
                    .fontColor([$r('app.color.watch_text_secondary')])
                }
                .width(CommonConstants.FULL_WIDTH)
              }
              .height(this.context.px2vp(CommonConstants.WATCH_BUTTON_HEIGHT))
              .width(this.context.px2vp(CommonConstants.WATCH_LIST_WIDTH))
              .focusable(true)
              .focusOnTouch(true)
              .backgroundColor($r('app.color.button_background_light'))
              .borderRadius($r('app.float.watch_arc_list_item_radius'))
              .padding({ left: $r('app.float.watch_card_padding'), right: $r('app.float.watch_card_padding') })
            }
            .borderRadius($r('app.float.watch_arc_list_item_radius'))
            .height($r('app.float.watch_arc_list_item_height'))
            .width(CommonConstants.FULL_WIDTH)
            .onClick(() => {
              if (index === 0) {
                this.navPathStack.pushPath({ name: 'WatchPaymentView' });
              }
            })
          }, (_item: QuickActionModel, index: number) => index.toString())
        }
        .clip(false)
        .space(LengthMetrics.px(CommonConstants.WATCH_LIST_SPACE))
        .borderRadius($r('app.float.watch_container_radius'))
        .focusable(true)
        .focusOnTouch(true)
        .defaultFocus(true)
      }
      .align(Alignment.Center)
      .width($r('app.float.watch_container_size'))
      .borderRadius($r('app.float.watch_container_size'))
    }
    .hideTitleBar(true)
    .navDestination(this.pageMap)
  }
}