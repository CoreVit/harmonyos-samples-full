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

import { Callback, emitter } from '@kit.BasicServicesKit';
import { common, Want } from '@kit.AbilityKit';
import { TextModifier } from '@kit.ArkUI';
import {
  BreakpointType,
  Logger,
  UniversalIcon,
  WindowInfo,
  WindowUtil,
  WordBackgroundComm,
  StockForm,
  KEY_MAIN_WINDOW_INFO,
  KEY_WINDOW_UTIL,
  KEY_IS_SPLIT_SCREEN,
  KEY_IS_HIDE_SPLIT_SCREEN
} from '@stock/base';
import { StockDetailViewModel } from '../viewmodels/StockDetailViewModel';
// [Start ImportMulti]
import { MultiWindowEntryComponent } from './MultiWindowEntryComponent';

// [Start StackEmit]
@Component
export struct TopTitleBar {
  // [StartExclude StackEmit]
  // [StartExclude ImportMulti]
  @StorageLink(KEY_MAIN_WINDOW_INFO) mainWindowInfo: WindowInfo = new WindowInfo();
  @StorageLink(KEY_WINDOW_UTIL) windowUtil: WindowUtil | undefined = undefined;
  @StorageLink(KEY_IS_SPLIT_SCREEN) isSplitScreen: boolean = false;
  @StorageLink(KEY_IS_HIDE_SPLIT_SCREEN) isHideSplitScreen: boolean = false;
  @Consume('pageInfos') pageInfos: NavPathStack;
  @Consume('tabletMode') tabletMode: NavigationMode;
  private viewModel: StockDetailViewModel = new StockDetailViewModel();
  @Prop stockInForm: StockForm | undefined = undefined;
  // [EndExclude ImportMulti]
  @State textModifier: TextModifier = new TextModifier();
  @State splitScreenWant: Want = {
    // Modify the bundleName, moduleName and abilityName of the current application,
    // and launch the UIAbility within the application.
    bundleName: 'com.example.multiticketclass',
    moduleName: 'multiticketclassdefaultsample',
    abilityName: 'SplitScreenAbility',
  };
  // [StartExclude ImportMulti]
  isPcStockTable: boolean = false;
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;
  // [EndExclude StackEmit]
  private innerEvent: emitter.InnerEvent = { eventId: 1 };
  private callBack: Callback<emitter.EventData> = (eventData: emitter.EventData) => {
    Logger.info(`eventData:${eventData}`);
    if (this.pageInfos?.pop) {
      this.pageInfos.pop();
    }
  };

  aboutToAppear(): void {
    this.viewModel.loadData();
    if (this.context.abilityInfo.name === 'MultiticketclassdefaultAbility') {
      emitter.on(this.innerEvent, this.callBack);
    }
  }

  aboutToDisappear(): void {
    emitter.off(this.innerEvent.eventId, this.callBack);
  }

  // [StartExclude StackEmit]
  private getMultiWindowVisibility(): Visibility {
    if (this.context.abilityInfo.name !== 'MultiticketclassdefaultAbility') {
      return Visibility.Hidden;
    }

    const widthBp = this.mainWindowInfo.widthBp;
    const heightBp = this.mainWindowInfo.heightBp;

    const isVisible =
      (widthBp === WidthBreakpoint.WIDTH_SM && this.isSplitScreen) ||
        ((widthBp === WidthBreakpoint.WIDTH_LG || widthBp === WidthBreakpoint.WIDTH_XL) &&
          heightBp === HeightBreakpoint.HEIGHT_SM) ||
        (widthBp === WidthBreakpoint.WIDTH_MD && heightBp === HeightBreakpoint.HEIGHT_MD);

    return isVisible ? Visibility.Visible : Visibility.Hidden;
  }

  // [EndExclude ImportMulti]
  build() {
    // [Start top_title_bar_area]
    Row() {
      // [StartExclude ImportMulti]
      // The icon area on the left
      Row() {
        if (this.tabletMode === NavigationMode.Split &&
          (this.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_LG ||
            this.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_XL ||
            this.isPcStockTable)) {
          Row() {
            UniversalIcon(this.isPcStockTable ? $r('app.color.card_background_color') :
              $r('sys.color.comp_background_tertiary'), $r('sys.symbol.arrow_up_left_and_arrow_down_right'))
          }
          // [StartExclude top_title_bar_area]
          .onClick(() => {
            this.tabletMode = NavigationMode.Stack;
          })

          // [EndExclude top_title_bar_area]
        } else {
          Row() {
            UniversalIcon(this.isPcStockTable ? $r('app.color.card_background_color') :
              $r('sys.color.comp_background_tertiary'), $r('sys.symbol.chevron_backward'))
          }
          // [StartExclude top_title_bar_area]
          .onClick(() => {
            if (this.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_LG ||
              this.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_XL || this.isPcStockTable) {
              this.tabletMode = NavigationMode.Split;
            } else {
              this.pageInfos.pop();
            }
          })

          // [EndExclude top_title_bar_area]
        }
      }

      Blank()

      // The central title area at the top
      Column() {
        // [StartExclude top_title_bar_area]
        if (this.stockInForm) {
          Text() {
            Span(this.stockInForm.title)
            Span(`（${this.stockInForm.stockNumber}）`)
          }
          .fontSize(16)
          .height(21)
        }

        Row() {
          WordBackgroundComm($r('app.string.deep'), $r('app.color.plate_tag_font_color'),
            $r('app.color.plate_tag_background_color'))
          Text($r('app.string.closed_day'))
            .fontSize(11)
            .height(15)
            .fontColor($r('app.color.text_secondary_color'))
        }

        // [EndExclude top_title_bar_area]
      }
      .height(40)

      Blank()
      // [EndExclude ImportMulti]
      // The area displayed by the icon on the right side
      Row({ space: 16 }) {
        // split screen
        Row() {
          MultiWindowEntryComponent({
            textModifier: this.textModifier,
            want: this.splitScreenWant
          })
        }
        .visibility(this.getMultiWindowVisibility())
      }
    }
    // [StartExclude ImportMulti]
    // [End top_title_bar_area]
    .width('100%')
    .height(new BreakpointType(56, 56, 62, 62, 62).getValue(this.mainWindowInfo.widthBp))
    .backgroundColor($r('app.color.card_background_color'))
    .padding({
      right: new BreakpointType(16, 16, 24, 32, 32).getValue(this.mainWindowInfo.widthBp),
      left: new BreakpointType(16, 16, 24, 32, 32).getValue(this.mainWindowInfo.widthBp)
    })

    // [EndExclude ImportMulti]
    // [EndExclude StackEmit]
  }
}

// [End StackEmit]
// [End ImportMulti]