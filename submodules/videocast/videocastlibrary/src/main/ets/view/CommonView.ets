/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { CommonConstants } from '../common/constants/CommonConstants';
import { BreakpointTypeEnum } from '../common/utils/BreakpointSystem';

@Component
export struct IconButton {
  @Prop iconResource: Resource;

  build() {
    Row() {
      SymbolGlyph(this.iconResource)
        .fontSize(24)
        .fontColor([Color.White])
    }
    .width(40)
    .height(40)
    .backgroundColor('rgba(255,255,255,0.1)')
    .borderRadius(20)
    .justifyContent(FlexAlign.Center)
  }
}

@Component
export struct EpisodeChoose {
  @Prop numberTest: number[];
  @Prop videoIndex: number;
  callback: Function = () => {};

  build() {
    Flex() {
      ForEach(this.numberTest, (item: number, index) => {
        RelativeContainer() {
          Text(JSON.stringify(item))
            .width(46)
            .height(46)
            .fontSize(16)
            .textAlign(TextAlign.Center)
            .fontColor(this.videoIndex === index ? $r('sys.color.background_emphasize') : '#E5FFFFFF')
          SymbolGlyph($r('sys.symbol.rhythm'))
            .fontSize(16)
            .alignRules({
              bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
              left: { anchor: '__container__', align: HorizontalAlign.Start },
            })
            .fontColor([$r('sys.color.background_emphasize')])
            .offset({
              x: 2,
              y: 2
            })
            .visibility(this.videoIndex === index ? Visibility.Visible : Visibility.Hidden)
        }
        .width(46)
        .height(46)
        .borderWidth('1')
        .backgroundColor(this.videoIndex === index ? $r('sys.color.comp_emphasize_secondary') :
          '#202224')
        .borderColor(this.videoIndex === index ? $r('sys.color.brand') : '#46484D')
        .borderRadius(8)
        .margin({
          right: 12
        })
        .onClick(() => {
          this.callback(item - 1);
        })
      }, (item: number) => JSON.stringify(item))
    }
    .width('100%')
  }
}

@Component
export struct SpeedChoose {
  @StorageLink(CommonConstants.KEY_PREFIX + 'Breakpoint') currentWidthBreakpoint: string = 'sm';
  @Prop speedChoosen: number;
  @Link isSpeedSheetShow: boolean;
  onChange: Function = () => {};

  build() {
    Grid() {
      ForEach(CommonConstants.SPEED_CHOOSE, (item: string, index: number) => {
        GridItem() {
          Row() {
            Text(item + 'X')
              .fontSize(16)
              .fontWeight(700)
              .fontColor(this.speedChoosen === Number.parseFloat(item) ? $r('sys.color.background_emphasize') :
              $r('sys.color.font_primary'))
          }
          .width('100%')
          .height(72)
          .backgroundColor(this.speedChoosen === Number.parseFloat(item) ? $r('sys.color.comp_emphasize_secondary') :
          $r('sys.color.background_tertiary'))
          .borderColor(this.speedChoosen === Number.parseFloat(item) ? $r('sys.color.brand') : $r('sys.color.gray_04'))
          .borderWidth(1)
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
          .borderRadius(8)
          .onClick(() => {
            this.speedChoosen = Number.parseFloat(item);
            this.isSpeedSheetShow = false;
            this.onChange(this.speedChoosen);
          })
        }

      }, (item: number) => JSON.stringify(item))
    }
    .width('100%')
    .rowsGap(12)
    .columnsGap(12)
    .columnsTemplate(this.currentWidthBreakpoint === BreakpointTypeEnum.SM ? `1fr 1fr 1fr` : `1fr 1fr 1fr 1fr`)
    .padding({
      top: 16,
      left: 16,
      right: 16,
      bottom: 42
    })
  }
}
