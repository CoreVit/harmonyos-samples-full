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
import type { BreakpointType } from '../utils/MultiDeviceUtil';
import { getValueByBreakpointSync } from '../utils/MultiDeviceUtil';
import { EditStateViewModel } from '../viewModel/EditStateViewModel';

interface filterDataType {
  title: string | Resource;
  key: string;
  color: string;
};

@Component
export default struct ApplyFilterView {
  pixelMapManager?: PixelMapManager;
  scroller: Scroller = new Scroller();
  @State filterData: filterDataType[] = [
    {
      title: $r('app.string.none'),
      key: 'null',
      color: '#fff1efef'
    },
    {
      title: $r('app.string.grayscale'),
      key: 'grayscale',
      color: '#ffeaeaea'
    },
    {
      title: $r('app.string.brightness'),
      key: 'brightness',
      color: '#ffc1bdbd'
    },
    {
      title: $r('app.string.invert'),
      key: 'invert',
      color: '#ff9f9c9c'
    },
    {
      title: $r('app.string.blur'),
      key: 'blur',
      color: '#7a000000'
    },
    {
      title: $r('app.string.customize'),
      key: 'customize',
      color: '#7a000000'
    }
  ];
  @Consume editState: EditStateViewModel;
  @StorageProp(CommonConstants.BREAKPOINT_KEY) currentBreakpoint: BreakpointType = 'sm';

  build() {
    Column() {
      Scroll(this.scroller) {
        Flex({
          direction: getValueByBreakpointSync({
            sm: FlexDirection.Row,
            lg: FlexDirection.Column
          }, this.currentBreakpoint),
          justifyContent: FlexAlign.Center,
          alignItems: ItemAlign.Center
        }) {
          ForEach(this.filterData, (item: filterDataType, index: number) => {
            Column() {
              Row() {
                Text(item.title)
                  .margin({
                    left: 8,
                    bottom: 8
                  })
                  .fontSize(12)
                  .fontColor($r('app.color.white'))
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis });
              }
              .width(68)
              .height(68)
              .alignItems(VerticalAlign.Bottom)
              .backgroundImage($rawfile('low.jpg'))
              .borderRadius(8)
              .borderWidth(2)
              .borderColor(index === this.editState.filterCurrMode ? $r('app.color.white') : Color.Transparent);
            }
            .margin(2)
            .onClick(() => {
              this.pixelMapManager?.handleFilter(index);
              this.editState.filterCurrMode = index;
            });
          }, (item: filterDataType) => item.key);
        }
        .align(Alignment.Bottom);
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .scrollBarColor('#ffeceaea')
      .scrollBarWidth(0)
      .friction(0)
      .edgeEffect(EdgeEffect.None);
    }
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .padding({ left: 16, right: 16 });
  }
};
