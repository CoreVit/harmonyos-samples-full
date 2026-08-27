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

import Constants from '../constants/Constants';
import { BreakpointType, BreakpointTypeEnum } from '../constants/utils/BreakpointSystem';
import TextGradientView from './TextGradientView';
import TextMarqueeView from './TextMarqueeView';
import TextReflectionView from './TextReflectionView';
import TextScrollingView from './TextScrollingView';

@Component
export struct TextEffectsView {
  @State message: ResourceStr = $r('app.string.text_content');
  @StorageLink(Constants.KEY_BREAKPOINT) curBp: string = BreakpointTypeEnum.SM;
  @StorageProp(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;

  @Styles
  fancy() {
    .borderRadius($r('sys.float.corner_radius_level8'))
    .backgroundColor($r('sys.color.comp_background_primary'))
    .padding({
      top: $r('sys.float.padding_level7'),
      bottom: $r('sys.float.padding_level7')
    })
    .width(Constants.FULL_PERCENT)
  }

  @Builder
  textBuilder(value: ResourceStr) {
    Row() {
      Text(value)
        .fontSize($r('sys.float.Subtitle_S'))
        .fontColor($r('sys.color.font_secondary'))
        .fontWeight(Constants.FONT_WEIGHT_500)
        .margin({ top: $r('sys.float.padding_level9') })
        .lineHeight($r('app.float.text_effect_title_line_height'))
    }
    .width(Constants.FULL_PERCENT)
    .height($r('app.float.text_effect_title_row_height'))
    .margin({ bottom: $r('sys.float.padding_level3') })
    .padding({ left: $r('sys.float.padding_level6') })
  }

  build() {
    Column() {
      Text($r('app.string.title'))
        .fontColor($r('sys.color.font_primary'))
        .fontSize($r('sys.float.Title_L'))
        .alignSelf(ItemAlign.Start)
        .fontWeight(Constants.FONT_WEIGHT_700)
        .margin({ top: $r('sys.float.padding_level32') })
      WaterFlow() {
        FlowItem() {
          Column() {
            this.textBuilder($r('app.string.text_gradient'))
            Row() {
              TextGradientView({ message: this.message })
            }
            .fancy()
            .justifyContent(FlexAlign.Center)
          }
        }

        FlowItem() {
          Column() {
            this.textBuilder($r('app.string.text_scrolling'))
            Row() {
              TextScrollingView({ message: this.message })
            }
            .fancy()
            .justifyContent(FlexAlign.Center)
          }
        }

        FlowItem() {
          Column() {
            this.textBuilder($r('app.string.text_reflection'))
            Row() {
              TextReflectionView({ message: this.message })
            }
            .fancy()
            .justifyContent(FlexAlign.Center)
          }
        }

        FlowItem() {
          Column() {
            this.textBuilder($r('app.string.text_marquee'))
            Row() {
              TextMarqueeView({ message: $r('app.string.text_content_longest') })
            }
            .fancy()
            .justifyContent(FlexAlign.Center)
          }
        }
      }
      .columnsGap(Constants.COLUMN_GAP)
      .columnsTemplate(this.curBp === BreakpointTypeEnum.SM ? '1fr' : '1fr 1fr')
      .layoutWeight(1)
    }
    .padding({
      left: new BreakpointType({
        sm: $r('sys.float.padding_level8'),
        md: $r('sys.float.padding_level12'),
        lg: $r('sys.float.padding_level16')
      }).getValue(this.curBp),
      right: new BreakpointType({
        sm: $r('sys.float.padding_level8'),
        md: $r('sys.float.padding_level12'),
        lg: $r('sys.float.padding_level16')
      }).getValue(this.curBp),
      top: this.statusBarHeight
    })
    .height(Constants.FULL_PERCENT)
    .width(Constants.FULL_PERCENT)
    .backgroundColor($r('sys.color.background_secondary'))
  }
}