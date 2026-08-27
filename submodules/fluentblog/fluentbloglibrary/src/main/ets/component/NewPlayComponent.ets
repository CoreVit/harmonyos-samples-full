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
import { Constants } from '../common/Constants';

@Component
export struct NewPlayComponent {
  @State rotateAngle: number = 0;
  @StorageLink(Constants.KEY_PREFIX + 'CurrentBreakpoint') curBp: string = BreakpointTypeEnum.SM;
  @StorageLink(Constants.KEY_PREFIX + 'StatusBarHeight') statusBarHeight: number = 0;
  @Consume('NavPathStack') pageStack: NavPathStack;
  private controller: VideoController = new VideoController();

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          Row() {
            Button({ type: ButtonType.Circle }) {
              SymbolGlyph($r('sys.symbol.chevron_backward'))
                .fontColor([$r('sys.color.icon_primary')])
                .fontSize($r('sys.float.Title_M'))
            }
            .height(40)
            .aspectRatio(1)
            .backgroundColor($r('sys.color.comp_background_tertiary'))
            .width(Constants.BUTTON_SIZE)
            .height(Constants.BUTTON_SIZE)
            .onClick(() => {
              this.pageStack.pop();
            })

            Text($r('app.string.nav_bar_return_text'))
              .margin({ left: $r('sys.float.padding_level4') })
              .font({ size: 20, weight: 700 })
              .fontColor($r('sys.color.font_primary'))
              .onClick(() => {
                this.pageStack.pop();
              })
          }
          .padding({
            left: new BreakpointType({
              sm: $r('sys.float.padding_level8'), md: $r('sys.float.padding_level12'),
              lg: $r('sys.float.padding_level16')
            }).getValue(this.curBp),
            right: new BreakpointType({
              sm: $r('sys.float.padding_level8'), md: $r('sys.float.padding_level12'),
              lg: $r('sys.float.padding_level16')
            }).getValue(this.curBp)
          })
          .width(Constants.FULL_SIZE)
          .height(56)
          .zIndex(2)

          Video({
            src: $rawfile(Constants.VIDEO_NAME),
            previewUri: $r('app.media.video_cover'),
            controller: this.controller
          })
            .backgroundColor(Color.Transparent)
            .width('100%')
            .constraintSize({
              maxHeight: '66%'
            })
            .aspectRatio(Constants.ASPECT_RATIO_16_9)
            .controls(false)
            .autoPlay(true)
            .objectFit(ImageFit.Cover)
            .loop(true)

          Row() {
            Image($r('app.media.avatar'))
              .width(40)
              .height(40)
              .margin(20)
              .borderRadius(100)
              .rotate({
                x: 0,
                y: 0,
                z: 1,
                centerX: '50%',
                centerY: '50%',
                angle: this.rotateAngle
              })
          }
          .padding({
            left: new BreakpointType({
              sm: $r('sys.float.padding_level8'), md: $r('sys.float.padding_level12'),
              lg: $r('sys.float.padding_level16')
            }).getValue(this.curBp),
            right: new BreakpointType({
              sm: $r('sys.float.padding_level8'), md: $r('sys.float.padding_level12'),
              lg: $r('sys.float.padding_level16')
            }).getValue(this.curBp)
          })
          .width(Constants.FULL_SIZE)
          .justifyContent(FlexAlign.End)
        }
        .padding({
          top: this.statusBarHeight
        })
        .height(Constants.FULL_SIZE)
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Start)
        .backgroundColor($r('sys.color.background_primary'))
      }
    }.hideTitleBar(true)
  }
}

@Builder
export function NewPlayPageBuilder() {
  NewPlayComponent()
}