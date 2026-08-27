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

import { CommonConstants } from '../common/constant/CommonConstants';
import { PixelMapManager } from '../pages/PixelMapManager';
import { BreakpointType, getValueByBreakpointSync } from '../utils/MultiDeviceUtil';
import { EditStateViewModel } from '../viewModel/EditStateViewModel';

interface translateListType {
  icon: string;
  title: Resource | string;
  color: string;
  selectColor: string;
}

@Component
export default struct ZoomView {
  pixelMapManager?: PixelMapManager;
  @StorageProp(CommonConstants.BREAKPOINT_KEY) currentBreakpoint: BreakpointType = 'sm';
  @Consume editState: EditStateViewModel;
  @State cropList: translateListType[] = [
    {
      icon: 'aspect_ratio',
      title: $r('app.string.none'),
      color: '#fff',
      selectColor: '#ff000000'
    },
    {
      icon: 'rectangle_ratio_1_to_1',
      title: '1:1',
      color: '#fff',
      selectColor: '#ff000000'
    },
    {
      icon: 'rectangle_ratio_4_to_3',
      title: '4:3',
      color: '#fff',
      selectColor: '#ff000000'
    },
    {
      icon: 'rectangle_ratio_16_to_9',
      title: '16:9',
      color: '#fff',
      selectColor: '#ff000000'
    }
  ];
  onZoomChange?: (value: number, mode: SliderChangeMode) => void;

  build() {
    Column() {
      Row() {
        Slider({
          value: this.editState.currentZoom,
          step: 1,
          min: 80,
          max: 120,
          direction: getValueByBreakpointSync({
            sm: Axis.Horizontal,
            lg: Axis.Vertical
          }, this.currentBreakpoint),
          reverse: getValueByBreakpointSync({
            sm: false,
            lg: true
          }, this.currentBreakpoint)
        })
          .width(getValueByBreakpointSync({
            sm: 240,
            md: 240,
            lg: 15
          }, this.currentBreakpoint))
          .height(getValueByBreakpointSync({
            sm: 16,
            md: 16,
            lg: 272
          }, this.currentBreakpoint))
          .trackThickness(4)
          .trackColor('#1affffff')
          .selectedColor(Color.White)
          .showTips(true, (this.editState.currentZoom.toFixed() + '%'))
          .clip(false)
          .onChange((value: number, mode: SliderChangeMode) => {
            if (this.onZoomChange !== undefined) {
              this.onZoomChange(value > 120 ? 120 : value, mode);
            }
          })
      }
      .width(getValueByBreakpointSync<Length>({
        sm: '100%',
        md: 360,
        lg: 56
      }, this.currentBreakpoint))
      .height(getValueByBreakpointSync({
        sm: 54,
        md: 54,
        lg: 344
      }, this.currentBreakpoint))
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .justifyContent(getValueByBreakpointSync({
      sm: FlexAlign.Start,
      lg: FlexAlign.Center
    }, this.currentBreakpoint))
  }
}
