/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { CommonConstants } from '../common/constants/CommonConstants';

@Builder
export function BindContentCoverDemoBuilder() {
  BindContentCoverDemo();
}

@Component
struct BindContentCoverDemo {
  @StorageLink(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageLink(CommonConstants.AS_KEY_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  @StorageLink(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  pathStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      Navigation(this.pathStack) {
        Column() {
          Row() {
            Text($r('app.string.confirm_order'))
              .fontSize($r('sys.float.Subtitle_L'))
              .fontColor($r('sys.color.font_primary'))
              .width(CommonConstants.FULL_PERCENT)
              .textAlign(TextAlign.Start)
              .fontWeight(FontWeight.Bold)
              .padding({ top: $r('sys.float.padding_level5') })
          }
          .height(50)

          Row() {
            Column() {
              Text($r('app.string.start_time'))
                .fontSize($r('sys.float.Title_S'))
                .fontColor($r('sys.color.font_primary'))
                .fontWeight(FontWeight.Medium)
                .margin({
                  bottom: $r('sys.float.padding_level2')
                })
              Text($r('app.string.start_string'))
                .fontSize($r('sys.float.Subtitle_S'))
                .fontColor($r('sys.color.font_primary'))
            }

            Column() {
              Text($r('app.string.car_name'))
                .fontSize($r('sys.float.Subtitle_L'))
                .fontColor($r('sys.color.font_primary'))
                .margin({
                  bottom: $r('sys.float.padding_level2')
                })
              Text($r('app.string.car_time'))
                .fontSize($r('sys.float.Body_S'))
                .fontColor($r('sys.color.font_tertiary'))
            }

            Column() {
              Text($r('app.string.end_time'))
                .fontSize($r('sys.float.Title_S'))
                .fontColor($r('sys.color.font_primary'))
                .fontWeight(FontWeight.Medium)
                .margin({
                  bottom: $r('sys.float.padding_level2')
                })
              Text($r('app.string.end_name'))
                .fontSize($r('sys.float.Subtitle_S'))
                .fontColor($r('sys.color.font_primary'))
            }
          }
          .width(CommonConstants.FULL_PERCENT)
          .height(97)
          .backgroundColor($r('sys.color.comp_background_primary'))
          .borderRadius($r('sys.float.corner_radius_level6'))
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({
            right: this.curBp === 'sm' ? $r('sys.float.padding_level6') : $r('sys.float.padding_level12'),
            left: this.curBp === 'sm' ? $r('sys.float.padding_level6') : $r('sys.float.padding_level12')
          })
          .margin({
            bottom: $r('sys.float.padding_level6')
          })

          Row() {
            Button({ type: ButtonType.Circle }) {
              SymbolGlyph($r('sys.symbol.plus'))
                .fontColor([$r('sys.color.comp_background_primary')])
                .fontSize($r('sys.float.Subtitle_L'))
            }
            .backgroundColor($r('sys.color.brand'))
            .height($r('sys.float.Title_M'))
            .aspectRatio(1)
            .margin({ right: $r('sys.float.padding_level4') })

            Text($r('app.string.button_select'))
              .fontColor($r('sys.color.brand'))
              .fontSize($r('sys.float.Body_L'))
              .fontWeight(FontWeight.Medium)
          }
          .onClick(() => {
            this.pathStack.replacePath({ name: 'AddPassengers' });
          })
          .width(CommonConstants.FULL_PERCENT)
          .height($r('app.integer.button_height'))
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .backgroundColor($r('sys.color.comp_background_primary'))
          .borderRadius($r('sys.float.corner_radius_level6'))
        }
        .padding({
          right: this.curBp === 'lg' ? $r('sys.float.padding_level16') : $r('sys.float.padding_level8'),
          left: $r('sys.float.padding_level8')
        })
      }
      .title($r('app.string.dialog_name'))
      .mode(this.curBp === 'lg' ? NavigationMode.Split : NavigationMode.Stack)
      .navBarWidth($r('app.integer.nav_bar_width'))
      .titleMode(NavigationTitleMode.Mini)
      .padding({
        top: this.statusBarHeight,
        right: new BreakpointType({
          sm: $r('sys.float.padding_level0'),
          md: $r('sys.float.padding_level4'),
          lg: $r('sys.float.padding_level8')
        }
        ).getValue(this.curBp),
        bottom: this.navigatorBarHeight,
        left: new BreakpointType({
          sm: $r('sys.float.padding_level0'),
          md: $r('sys.float.padding_level4'),
          lg: $r('sys.float.padding_level8')
        }).getValue(this.curBp)
      })
    }
    .hideTitleBar(true)
    .backgroundColor($r('sys.color.background_secondary'))
  }
}