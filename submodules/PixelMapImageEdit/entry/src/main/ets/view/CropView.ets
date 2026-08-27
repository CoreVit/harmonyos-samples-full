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
import { MirrorType } from '../viewModel/OptionViewModel';
import { IconStatus } from '../viewModel/IconListViewModel';
import { PixelMapManager } from '../pages/PixelMapManager';
import { getValueByBreakpointSync, BreakpointType } from '../utils/MultiDeviceUtil';
import { EditStateViewModel } from '../viewModel/EditStateViewModel';

interface translateListType {
  icon: string;
  title: Resource | string;
  color: string;
  selectColor: string;
}

@Component
export default struct CropView {
  pixelMapManager?: PixelMapManager;
  @Consume editState: EditStateViewModel;
  @StorageProp(CommonConstants.BREAKPOINT_KEY) currentBreakpoint: BreakpointType = 'sm';
  @State cropList: translateListType[] = [
    {
      icon: 'aspect_ratio',
      title: $r('app.string.free_ratio'),
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
  onCropImage?: (index: number) => void;
  onRotateImage?: () => void;
  onMirrorImage?: (mirrorType: MirrorType) => void;

  build() {
    Flex({
      direction: getValueByBreakpointSync({
        sm: FlexDirection.Column,
        lg: FlexDirection.Row
      }, this.currentBreakpoint),
      alignItems: ItemAlign.Center,
    }) {
      Flex({
        direction: getValueByBreakpointSync({
          sm: FlexDirection.Row,
          lg: FlexDirection.Column
        }, this.currentBreakpoint),
        justifyContent: FlexAlign.SpaceBetween
      , alignItems: ItemAlign.Center
      }) {
        Text() {
          SymbolSpan($r(`sys.symbol.rotate_left`))
            .fontColor([Color.White, Color.White, Color.White])
            .fontWeight(FontWeight.Normal)
            .fontSize(24)
        }
        .width(CommonConstants.TAB_MENU_WIDTH)
        .height(CommonConstants.TAB_MENU_WIDTH)
        .onClick(() => {
          if (this.onRotateImage !== undefined) {
            this.onRotateImage();
          }
        })

        Text() {
          SymbolSpan($r(`sys.symbol.line_arrowtriangle_2_inward`))
            .fontColor([Color.White, Color.White, Color.White])
            .fontWeight(FontWeight.Normal)
            .fontSize(24)
        }
        .width(CommonConstants.TAB_MENU_WIDTH)
        .height(CommonConstants.TAB_MENU_WIDTH)
        .onClick(() => {
          if (this.onMirrorImage !== undefined) {
            this.onMirrorImage(MirrorType.HORIZONTAL);
          }
        })
      }
      .padding(getValueByBreakpointSync<Padding | Length | LocalizedPadding>({
        sm: { left: 50, right: 50 },
        md: {
          left: 50,
          right: 50,
          top: 9,
          bottom: 9
        },
        lg: {
          top: 9, bottom: 9
        }
      }, this.currentBreakpoint))
      .width(getValueByBreakpointSync<Length>({
        sm: '100%',
        md: 360,
        lg: 24
      }, this.currentBreakpoint))
      .height(getValueByBreakpointSync<Length>({
        sm: 42,
        lg: 166
      }, this.currentBreakpoint))
      .margin({
        right: getValueByBreakpointSync({
          sm: 0,
          lg: 43
        }, this.currentBreakpoint),
        bottom: getValueByBreakpointSync({
          sm: 24,
          md: 24,
          lg: 0
        }, this.currentBreakpoint)
      })

      Flex({
        direction: getValueByBreakpointSync({
          sm: FlexDirection.Row,
          lg: FlexDirection.Column
        }, this.currentBreakpoint),
        justifyContent: FlexAlign.SpaceBetween
      }) {
        ForEach(this.cropList, (item: translateListType, index: number) => {
          Column() {
            Row() {
              SymbolGlyph($r(`sys.symbol.${item.icon}`))
                .fontColor(this.editState.currentCropMode === index ?
                  [item.selectColor, item.selectColor, item.selectColor] :
                  [item.color, item.color, item.color])
                .fontWeight(FontWeight.Normal)
                .fontSize(24)
            }
            .borderRadius('50%')
            .backgroundColor(this.editState.currentCropMode === index ? '#e6ffffff' : '#26ffffff')
            .width(40)
            .height(40)
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)


            Text(item.title)
              .margin({ top: 4 })
              .fontColor('#fff')
              .fontSize(10)
              .lineHeight(13)
          }
          .onClick(() => {
            this.editState.currentCropMode = index;
            if (this.onCropImage !== undefined) {
              this.onCropImage(index);
            }
          })
        }, (item: IconStatus) => JSON.stringify(item));
      }
      .padding(getValueByBreakpointSync<Padding | Length | LocalizedPadding>({
        sm: { left: 40, right: 40 },
        md: { left: 138, right: 138 },
        lg: 0
      }, this.currentBreakpoint))
      .height(getValueByBreakpointSync<number | string>({
        sm: 58,
        lg: 292
      }, this.currentBreakpoint))
    }
    .width(CommonConstants.LAYOUT_FULL_SCREEN)
    .height(CommonConstants.LAYOUT_FULL_SCREEN)
    .padding(getValueByBreakpointSync<Padding>({
      sm: {
        top: 9,
        bottom: 19
      },
      md: {
        top: 19,
        bottom: 17
      }
    }, this.currentBreakpoint))
  }
}
