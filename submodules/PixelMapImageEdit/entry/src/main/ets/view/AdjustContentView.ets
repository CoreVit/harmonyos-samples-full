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

import { adjustIconList, IconStatus } from '../viewModel/IconListViewModel';
import { CommonConstants } from '../common/constant/CommonConstants';
import { AdjustType } from '../viewModel/OptionViewModel';
import { PixelMapManager } from '../pages/PixelMapManager';
import { getValueByBreakpointSync, BreakpointType } from '../utils/MultiDeviceUtil';
import { EditStateViewModel } from '../viewModel/EditStateViewModel';

interface translateListType {
  icon: string;
  title: string | Resource;
  color: string;
  selectColor: string;
}

@Component
struct SliderCustom {
  pixelMapManager?: PixelMapManager;
  @Consume editState: EditStateViewModel;
  @Prop min: number;
  @Prop max: number;
  @Consume('currentAdjustIndex') @Watch('onAdjustIndexChange') currentAdjustType: AdjustType;
  @StorageProp(CommonConstants.BREAKPOINT_KEY) currentBreakpoint: BreakpointType = 'sm';
  private paramValues: number[] = [
    CommonConstants.SLIDER_MAX,
    CommonConstants.SLIDER_MAX,
    CommonConstants.SLIDER_MAX
  ];
  deviceListDialogController: CustomDialogController = new CustomDialogController({
    builder: Dialog(),
    alignment: DialogAlignment.Center,
    autoCancel: false,
    customStyle: true
  });

  onAdjustIndexChange() {
    this.paramValues[this.currentAdjustType] = this.editState.currentAdjustData[this.currentAdjustType];
  }

  build() {
    Column() {
      Row() {
        Slider({
          value: this.editState.currentAdjustData[this.currentAdjustType],
          step: CommonConstants.SLIDER_STEP,
          min: this.min,
          max: this.max,
          direction: getValueByBreakpointSync({ sm: Axis.Horizontal, lg: Axis.Vertical }, this.currentBreakpoint),
          reverse: getValueByBreakpointSync({
            sm: false,
            lg: true
          }, this.currentBreakpoint)
        })
          .trackColor('#1affffff')
          .selectedColor(Color.White)
          .width(getValueByBreakpointSync({
            sm: 240,
            md: 240,
            lg: 15
          }, this.currentBreakpoint))
          .height(getValueByBreakpointSync({
            sm: 16,
            lg: 272
          }, this.currentBreakpoint))
          .showTips(true)
          .clip(false)
          .onChange((value: number, mode: SliderChangeMode) => {
            this.sliderChange(value > this.max ? this.max : value, mode);
          })
      }
      .width(CommonConstants.LAYOUT_FULL_SCREEN)
      .justifyContent(FlexAlign.Center)
    }
  }

  async sliderChange(value: number, mode: SliderChangeMode) {
    if ((mode === SliderChangeMode.End) && (value !== this.editState.currentAdjustData[this.currentAdjustType])) {
      const roundedValue = Math.round(value);
      this.editState.currentAdjustData[this.currentAdjustType] = roundedValue;
      this.paramValues[this.currentAdjustType] = roundedValue;
      this.deviceListDialogController.open();
      await this.pixelMapManager?.adjustImage(this.paramValues);
      this.deviceListDialogController.close();
    }
  }
}

@CustomDialog
export struct Dialog {
  controller?: CustomDialogController;

  build() {
    Column() {
      LoadingProgress()
        .color(Color.White)
        .width(40)
        .height(40)
    }
  }
}

@Component
export default struct AdjustContentView {
  pixelMapManager?: PixelMapManager;
  @Provide currentAdjustIndex: number = 0;
  @StorageProp(CommonConstants.BREAKPOINT_KEY) currentBreakpoint: BreakpointType = 'sm';
  @State adjustList: translateListType[] = [
    {
      icon: 'brightness',
      title: $r('app.string.light'),
      color: '#fff',
      selectColor: '#ff000000'
    },
    {
      icon: 'transparency_lock',
      title: $r('app.string.transparency'),
      color: '#fff',
      selectColor: '#ff000000'
    },
    {
      icon: 'drop_bottomrighthalf_inset_filled',
      title: $r('app.string.saturation'),
      color: '#fff',
      selectColor: '#ff000000'
    }
  ];
  @Consume editState: EditStateViewModel;
  iconList: Array<IconStatus> = adjustIconList;

  build() {
    Flex({
      direction: getValueByBreakpointSync({
        sm: FlexDirection.Column,
        lg: FlexDirection.Row
      }, this.currentBreakpoint),
      alignItems: ItemAlign.Center
    }) {
      Row() {
        SliderCustom({
          pixelMapManager: this.pixelMapManager,
          min: CommonConstants.SLIDER_MIN.valueOf(),
          max: CommonConstants.SLIDER_MAX.valueOf()
        })
      }
      .width(getValueByBreakpointSync({
        sm: 240,
        md: 240,
        lg: 56
      }, this.currentBreakpoint))
      .height(getValueByBreakpointSync<Length>({
        sm: 42,
        lg: '100%'
      }, this.currentBreakpoint))
      .margin({
        bottom: getValueByBreakpointSync({
          sm: 24,
          md: 24,
          lg: 0
        }, this.currentBreakpoint),
        right: getValueByBreakpointSync({
          sm: 0,
          lg: 28
        }, this.currentBreakpoint)
      })
      .justifyContent(FlexAlign.Center)

      Flex(
        {
          direction: getValueByBreakpointSync({
            sm: FlexDirection.Row,
            lg: FlexDirection.Column
          }, this.currentBreakpoint),
          justifyContent: FlexAlign.SpaceBetween,
          alignItems: ItemAlign.Center
        }
      ) {
        ForEach(this.adjustList, (item: translateListType, index) => {
          Column() {
            Text() {
              SymbolSpan($r(`sys.symbol.${item.icon}`))
                .fontColor(this.currentAdjustIndex === index ?
                  [item.selectColor, item.selectColor, item.selectColor] :
                  [item.color, item.color, item.color])
                .fontWeight(FontWeight.Normal)
                .fontSize(22)
            }
            .padding(9)
            .borderRadius('50%')
            .backgroundColor(this.currentAdjustIndex === index ? '#e6ffffff' : '#26ffffff')

            Text(item.title)
              .margin({ top: 4 })
              .fontColor('#fff')
              .fontSize(10)
          }
          .onClick(() => {
            this.currentAdjustIndex = index;
          })
        }, (item: translateListType) => item.icon)
      }
      .width(getValueByBreakpointSync({
        sm: 270,
        md: 320,
        lg: 40
      }, this.currentBreakpoint))
      .height(getValueByBreakpointSync({
        sm: 58,
        lg: 238
      }, this.currentBreakpoint))
    }
    .width(CommonConstants.LAYOUT_FULL_SCREEN)
    .height(getValueByBreakpointSync<Length>({
      sm: CommonConstants.LAYOUT_FULL_SCREEN,
      lg: 344
    }, this.currentBreakpoint))
  }
}