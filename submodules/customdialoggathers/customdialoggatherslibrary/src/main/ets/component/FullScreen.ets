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

import { curves } from '@kit.ArkUI';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { CommonConstants } from '../common/constants/CommonConstants';

@Builder
export function FullScreenBuilder() {
  FullScreen();
}

@Component
struct FullScreen {
  private positionY: number = 0;
  @State translateY: string | number = '110%';
  @StorageLink(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageLink(CommonConstants.AS_KEY_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  @StorageLink(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;

  build() {
    NavDestination() {
      Stack() {
        Navigation() {
          Column() {
            Button($r('app.string.full_screen'))
              .fontSize($r('sys.float.Subtitle_M'))
              .width(this.curBp === 'sm' ? CommonConstants.FULL_PERCENT : CommonConstants.WIDTH_MD_LG)
              .height($r('app.integer.button_height_small'))
              .margin({ bottom: $r('sys.float.padding_level6') })
              .backgroundColor($r('sys.color.brand'))
              .onClick(() => {
                this.getUIContext().animateTo({
                  duration: CommonConstants.DURATION,
                  curve: Curve.Sharp
                }, () => {
                  this.translateY = '0%';
                });
              })
          }
          .height(CommonConstants.FULL_PERCENT)
          .justifyContent(FlexAlign.End)
          .padding({
            right: this.curBp === 'sm' ? $r('sys.float.padding_level8') : $r('sys.float.padding_level0'),
            left: this.curBp === 'sm' ? $r('sys.float.padding_level8') : $r('sys.float.padding_level0')
          })
        }
        .width(CommonConstants.FULL_PERCENT)
        .height(CommonConstants.FULL_PERCENT)
        .title($r('app.string.full_screen'))
        .titleMode(NavigationTitleMode.Mini)
        .mode(NavigationMode.Stack)
        .backgroundColor($r('sys.color.background_secondary'))
        .padding({
          top: this.statusBarHeight,
          bottom: this.navigatorBarHeight,
        })

        RelativeContainer() {
          Column() {
            Image($r('app.media.background_guide'))
              .width(this.curBp === 'sm' ? $r('app.integer.full_screen_icon_width') :
              $r('app.integer.full_screen_icon_height'))
              .height(this.curBp === 'sm' ? $r('app.integer.full_screen_icon_width') :
              $r('app.integer.full_screen_icon_height'))
            Row() {
              Text($r('app.string.full_screen'))
                .backgroundColor($r('sys.color.multi_color_aux_02'))
                .fontColor($r('sys.color.font_on_primary'))
                .fontSize($r('sys.float.Body_L'))
            }
            .height(21)
          }
          .width(CommonConstants.FULL_PERCENT)
          .height(CommonConstants.FULL_PERCENT)
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)

          Button({ type: ButtonType.Circle }) {
            SymbolGlyph($r('sys.symbol.xmark'))
              .fontColor([$r('sys.color.icon_primary')])
              .fontSize($r('sys.float.Subtitle_L'))
          }
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .height($r('app.integer.button_height_small'))
          .aspectRatio(1)
          .margin({
            top: this.statusBarHeight,
            right: new BreakpointType({
              sm: $r('sys.float.padding_level8'),
              md: $r('sys.float.padding_level12'),
              lg: $r('sys.float.padding_level16')
            }).getValue(this.curBp),
          })
          .alignRules({
            top: { anchor: '__container__', align: VerticalAlign.Top },
            right: { anchor: '__container__', align: HorizontalAlign.End }
          })
          .onClick(() => {
            this.closeSelf();
          })
          .id('button')
        }
        .width(CommonConstants.FULL_PERCENT)
        .height(CommonConstants.FULL_PERCENT)
        .backgroundColor($r('sys.color.multi_color_aux_02'))
        .translate({ x: CommonConstants.ZERO, y: this.translateY })
        .gesture(
          PanGesture({ direction: PanDirection.Vertical, distance: CommonConstants.PAN_GESTURE_DISTANCE })
            .onActionUpdate((event?: GestureEvent) => {
              this.handlePanGestureUpdate(event?.offsetY);
            })
            .onActionEnd((event?: GestureEvent) => {
              this.handlePanGestureEnd(event?.offsetY);
            })
        )
      }
    }
    .hideTitleBar(true)
    .backgroundColor($r('sys.color.background_secondary'))
  }

  private closeSelf() {
    this.getUIContext().animateTo({
      duration: CommonConstants.DIALOG_ANIMATE_DURATION,
      curve: Curve.Sharp,
    }, () => {
      this.translateY = '110%';
    });
  }

  private reset() {
    this.getUIContext().animateTo({
      curve: curves.responsiveSpringMotion()
    }, () => {
      this.translateY = '0%';
      this.positionY = 0;
    });
  }

  handlePanGestureUpdate(offsetY?: number): void {
    if (!offsetY || offsetY < 0) {
      return;
    }
    this.getUIContext().animateTo({
      curve: curves.responsiveSpringMotion()
    }, () => {
      this.translateY = this.positionY + offsetY;
    });
  }

  handlePanGestureEnd(offsetY?: number): void {
    if (!offsetY) {
      return;
    }
    if (offsetY > 300) {
      this.closeSelf();
    } else {
      this.reset();
    }
  }
}