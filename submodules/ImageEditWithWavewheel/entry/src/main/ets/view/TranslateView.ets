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

import { PixelMapManager } from '../pages/PixelMapManager';
import { CommonConstants } from '../common/constant/CommonConstants';
import type { BreakpointType } from '../utils/MultiDeviceUtil';
import { getValueByBreakpointSync } from '../utils/MultiDeviceUtil';
import { EditStateViewModel } from '../viewModel/EditStateViewModel';

interface translateListType {
  icon: string;
  title: Resource | string;
  color: string;
  selectColor: string;
};

@Component
export default struct TranslateView {
  pixelMapManager?: PixelMapManager;
  @Consume editState: EditStateViewModel;
  @State translateList: translateListType[] = [
    {
      icon: 'camera_panopor_horizontal',
      title: $r('app.string.horizontal'),
      color: '#FFFFFF',
      selectColor: '#ff000000'
    },
    {
      icon: 'camera_panover_vertical',
      title: $r('app.string.vertical'),
      color: '#FFFFFF',
      selectColor: '#ff000000'
    },
  ];
  onTranslateChange?: (value: number, mode: SliderChangeMode) => void;
  @StorageProp(CommonConstants.BREAKPOINT_KEY) currentBreakpoint: BreakpointType = 'sm';

  build() {
    Flex({
      direction: getValueByBreakpointSync({
        sm: FlexDirection.Column,
        lg: FlexDirection.Row
      }, this.currentBreakpoint),
      alignItems: ItemAlign.Center
    }) {
      Row() {
        Slider({
          value: this.editState.currentTranslateData[this.editState.currentTranslateMode],
          step: 1,
          min: 0,
          max: 1000,
          direction: getValueByBreakpointSync({
            sm: Axis.Horizontal,
            lg: Axis.Vertical
          }, this.currentBreakpoint),
          reverse: getValueByBreakpointSync({
            sm: false,
            lg: true
          }, this.currentBreakpoint)
        })
          .trackColor('#1affffff')
          .selectedColor(Color.White)
          .width(getValueByBreakpointSync({
            sm: 240,
            lg: 15
          }, this.currentBreakpoint))
          .showSteps(true)
          .showTips(true, this.editState.currentTranslateData[this.editState.currentTranslateMode].toFixed())
          .clip(false)
          .onChange((value: number, mode: SliderChangeMode) => {
            if (this.onTranslateChange !== undefined) {
              this.onTranslateChange(value > 1000 ? 1000 : value, mode);
            }
          });
      }
      .width(getValueByBreakpointSync<Length>({
        sm: '100%',
        md: 360,
        lg: 56
      }, this.currentBreakpoint))
      .height(getValueByBreakpointSync({
        sm: 54,
        lg: 344
      }, this.currentBreakpoint))
      .justifyContent(FlexAlign.Center)
      .clip(false)
      .margin({
        bottom: getValueByBreakpointSync({
          sm: 21,
          md: 24,
          lg: 0
        }, this.currentBreakpoint),
        right: getValueByBreakpointSync({
          sm: 0,
          lg: 28
        }, this.currentBreakpoint)
      });

      Flex({
        direction: getValueByBreakpointSync({
          sm: FlexDirection.Row,
          lg: FlexDirection.Column
        }, this.currentBreakpoint),
        justifyContent: FlexAlign.SpaceBetween,
        alignItems: ItemAlign.Center
      }) {
        ForEach(this.translateList, (item: translateListType, index: number) => {
          Column() {
            Text() {
              SymbolSpan($r(`sys.symbol.${item.icon}`))
                .fontColor(this.editState.currentTranslateMode === index ?
                  [item.selectColor, item.selectColor, item.selectColor] :
                  [item.color, item.color, item.color])
                .fontWeight(FontWeight.Normal)
                .fontSize(24);
            }
            .padding(9)
            .borderRadius('50%')
            .backgroundColor(this.editState.currentTranslateMode === index ? '#e6ffffff' : '#26ffffff');

            Text(item.title)
              .margin({ top: 4 })
              .fontColor($r('app.color.white'))
              .fontSize(10);
          }
          .onClick(() => {
            this.editState.currentTranslateMode = index;
          });
        }, (item: translateListType) => item.icon);
      }
      .width(getValueByBreakpointSync({
        sm: 155,
        lg: 40
      }, this.currentBreakpoint))
      .height(getValueByBreakpointSync({
        sm: 58,
        lg: 164
      }, this.currentBreakpoint));
    };
  };
};
