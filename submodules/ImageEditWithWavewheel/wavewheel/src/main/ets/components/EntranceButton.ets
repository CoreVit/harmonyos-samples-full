/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import type { EntranceStyle } from '../model/Model';
import { phoneEntranceStyle } from '../utils/Style';

const DEFAULT_INIT_VALUE: number = 0;

@Component
export struct EntranceButton {
  @Prop text: string | Resource;
  @Prop componentKey: string;
  @Prop img: Resource | null;
  @Prop enable: boolean;
  @Prop useSysImg: boolean;
  @Prop debug: boolean = false;
  @Prop positionX: number = DEFAULT_INIT_VALUE;
  @Prop positionY: number = DEFAULT_INIT_VALUE;
  @Prop entranceStyle: EntranceStyle = phoneEntranceStyle;
  onButtonClick: ((e: ClickEvent) => void) | null = null;
  @State circleButtonColor: ResourceColor = this.entranceStyle.buttonCircleColorNormal;
  @State circleButtonBorder: number = this.entranceStyle.buttonCircleBorderSizeNormal;
  @State contentWidth: number = DEFAULT_INIT_VALUE;
  @State contentHeight: number = DEFAULT_INIT_VALUE;
  @State contentX: number = DEFAULT_INIT_VALUE;
  @State contentY: number = DEFAULT_INIT_VALUE;

  build() {
    Stack() {
      Column() {
        Column() {
          Button({ type: ButtonType.Normal, stateEffect: true }) {
            if (this.img) {
              if (this.useSysImg) {
                SymbolGlyph(this.img)
                  .draggable(false)
                  .fontSize(this.entranceStyle.buttonImgSize)
                  .fontColor([this.entranceStyle.buttonImgFillColor]);
              } else {
                Image(this.img)
                  .draggable(false)
                  .width(this.entranceStyle.buttonImgSize)
                  .height(this.entranceStyle.buttonImgSize);
              }
            }
          }
          .margin(this.entranceStyle.buttonCircleMargin)
          .padding(this.entranceStyle.buttonCirclePadding)
          .width(this.entranceStyle.buttonCircleSize)
          .height(this.entranceStyle.buttonCircleSize)
          .borderRadius(this.entranceStyle.buttonCircleSize / 2)
          .backgroundColor(this.circleButtonColor)
          .borderWidth(this.circleButtonBorder)
          .borderColor(this.entranceStyle.buttonCircleBorderColor)
          .onFocus(() => {
            this.circleButtonBorder = this.entranceStyle.buttonCircleBorderSizeFocus;
          })
          .onBlur(() => {
            this.circleButtonBorder = this.entranceStyle.buttonCircleBorderSizeNormal;
          })
          .onHover((isHover) => {
            if (isHover) {
              this.circleButtonColor = this.entranceStyle.buttonCircleColorHover;
            } else {
              this.circleButtonColor = this.entranceStyle.buttonCircleColorNormal;
            }
          })
          .onTouch((e) => {
            e.stopPropagation();
          })
          .onClick((e: ClickEvent) => {
            if (this.enable) {
              this.onButtonClick?.(e);
            }
          });

          Text(this.text)
            .fontSize(this.entranceStyle.buttonFontSize)
            .fontFamily(this.entranceStyle.buttonFontFamily)
            .fontColor(this.entranceStyle.buttonFontColor)
            .maxLines(this.entranceStyle.buttonTextMaxLine)
            .textOverflow({ overflow: TextOverflow.Ellipsis });
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .onAreaChange((index, newVal) => {
          index;
          this.contentWidth = typeof newVal.width === 'number' ? newVal.width : DEFAULT_INIT_VALUE;
          this.contentHeight = typeof newVal.height === 'number' ? newVal.height : DEFAULT_INIT_VALUE;
          this.contentX = typeof newVal.position.x === 'number' ? newVal.position.x : DEFAULT_INIT_VALUE;
          this.contentY = typeof newVal.position.y === 'number' ? newVal.position.y : DEFAULT_INIT_VALUE;
        });
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .opacity(this.enable ? this.entranceStyle.buttonEnableAlpha : this.entranceStyle.buttonDisableAlpha)
      .position({ x: this.positionX, y: this.positionY })
      .width(this.entranceStyle.buttonWidth)
      .height(this.entranceStyle.buttonHeight)
      .enabled(this.enable);

      if (this.debug) {
        // Overall border (red)
        Rect()
          .width(this.entranceStyle.buttonWidth)
          .height(this.entranceStyle.buttonHeight)
          .fill(Color.Transparent)
          .stroke(Color.Red)
          .strokeWidth(2)
          .position({ x: DEFAULT_INIT_VALUE, y: DEFAULT_INIT_VALUE });

        // Center dot
        Circle()
          .width(6)
          .height(6)
          .fill(Color.Red)
          .position({
            x: this.entranceStyle.buttonWidth / 2 - 3,
            y: this.entranceStyle.buttonHeight / 2 - 3
          });

        // Content bounding box (blue)
        Rect()
          .width(this.contentWidth)
          .height(this.contentHeight)
          .fill(Color.Transparent)
          .stroke(Color.Blue)
          .strokeWidth(2)
          .position({
            x: this.positionX + this.contentX,
            y: this.positionY + this.contentY
          });
      }

    }
    .width(this.entranceStyle.buttonWidth)
    .height(this.entranceStyle.buttonHeight);
  }
}