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
import { LengthMetrics, LengthUnit } from '@kit.ArkUI';
import { CommonConstants } from '../common/Constants';
import { BreakpointTypeEnum } from '../utils/BreakpointSystem';
import Logger from '../utils/Logger';

const TAG = '[KnockShareSample]';

@Component
export struct EpisodeChoose {
  @Prop numberTest: number[];
  @Link videoIndex: number;
  @StorageLink(CommonConstants.KEY_PREFIX + 'currentBreakpoint') curBp: string = BreakpointTypeEnum.SM;

  aboutToAppear(): void {
    Logger.info(TAG, 'videoIndex EpisodeChoose ' + this.videoIndex)
  }

  build() {
    Flex({
      space: {
        main: new LengthMetrics(12, LengthUnit.VP)
      }
    }) {
      ForEach(this.numberTest, (item: number, index) => {
        RelativeContainer() {
          Text(item.toString())
            .fontSize(16)
            .textAlign(TextAlign.Center)
            .width(46)
            .height(46)
            .fontColor(this.videoIndex === index ? '#FF317AF7' : '#FFFFFF')
          if (this.videoIndex === index) {
            SymbolGlyph($r('sys.symbol.rhythm'))
              .fontSize(16)
              .alignRules({
                bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
                left: { anchor: '__container__', align: HorizontalAlign.Start },
              })
              .fontColor(['rgba(10,89,247,0.5)'])
              .offset({
                x: 2,
                y: 2
              })
          }
        }
        .width(46)
        .height(46)
        .borderWidth('1')
        .backgroundColor(this.videoIndex === index ? '#330A59F7' : '#46484D')
        .borderColor(this.videoIndex === index ? '#FF317AF7' : '#46484D')
        .borderRadius(8)
        .onClick(() => {
          this.videoIndex = item - 1;
        })
      })
    }
  }
}