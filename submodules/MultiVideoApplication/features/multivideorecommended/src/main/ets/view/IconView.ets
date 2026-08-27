/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { BusinessError } from '@kit.BasicServicesKit';
import { Logger, WindowInfo, BreakpointType, BreakpointVisibilityUtil } from 'multivideobase';
import { MainPageConstants } from '../constants/MainPageConstants';
import IconCoverListViewModel, { IconCoverViewModel } from '../viewmodel/IconCoverViewModel';
import { getTabIndex } from './CommonView';

const TAG = '[IconView]';

@Component
export struct IconView {
  @ObjectLink mainWindowInfo: WindowInfo;
  @Consume('currentTopIndex') currentTopIndex: number = 0;
  @ObjectLink iconCoverList: IconCoverListViewModel;
  private breakpointFlags() {
    return BreakpointVisibilityUtil.getFlags(this.mainWindowInfo);
  }

  aboutToAppear(): void {
    this.iconCoverList.loadIconCoverData();
  }

  aboutToDisappear(): void {
    this.iconCoverList.clearIconCoverData();
  }

  build() {
    Column() {
      List({ space: this.getSpace(this.mainWindowInfo.windowSize.width, this.mainWindowInfo.widthBp) }) {
        ForEach(this.iconCoverList.getCovers(), (item: IconCoverViewModel, index: number) => {
          ListItem() {
            Column() {
              Image(item.getImage())
                .width('40vp')
                .height('40vp')
                .margin({ bottom: '4vp' })
                .focusable(true)
                .groupDefaultFocus(index === 0)
                .borderRadius(20)

              Text(item.getName())
                .fontSize('12fp')
                .fontWeight(FontWeight.Normal)
                .lineHeight('20vp')
                .fontColor(this.currentTopIndex === 2 ? $r('app.color.mp_text_title_on_immersive') :
                  $r('app.color.mp_text_primary'))
            }
            .alignItems(HorizontalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .height('76vp')
          }
          .padding({
            right: index === this.iconCoverList.getCovers().length - 1 ?
              this.getSpace(this.mainWindowInfo.windowSize.width, this.mainWindowInfo.widthBp) / 2 : 0
          })
        }, (item: IconCoverViewModel) => item.getId())
      }
      .clip(false)
      .listDirection(Axis.Horizontal)
      .scrollBar(BarState.Off)
      .scrollSnapAlign(ScrollSnapAlign.START)
      .edgeEffect(EdgeEffect.None)
      .chainAnimation(true)
      .tabIndex(getTabIndex(MainPageConstants.DIRECTION_LIST[3]))
      .width('100%')
      .height('auto')
    }
    .padding({
      left: new BreakpointType('16vp', '16vp', '24vp', '36vp', '36vp').getValue(this.mainWindowInfo.widthBp)
    })
    .margin({ top: this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '4vp' : '0vp' })
    .visibility(this.breakpointFlags().isWidthBpAboveMd && this.currentTopIndex === 2 ?
      Visibility.None : Visibility.Visible)
  }

  /**
   * Calculates spacing between icon items based on window width and breakpoint.
   */
  getSpace(windowWidth: number, currentWidthBreakpoint: number): number {
    try {
      if (!this.getUIContext() || this.getUIContext().getHostContext() === undefined) {
        return 0;
      }
      let result: number =
        this.getUIContext().px2vp(windowWidth) -
          (new BreakpointType(MainPageConstants.VIDEO_GRID_MARGIN[0], MainPageConstants.VIDEO_GRID_MARGIN[0],
            MainPageConstants.VIDEO_GRID_MARGIN[1], MainPageConstants.VIDEO_GRID_MARGIN[2],
            MainPageConstants.VIDEO_GRID_MARGIN[3]).getValue(this.mainWindowInfo.widthBp) / MainPageConstants.TWO) -
        MainPageConstants.ICON_IMG_HALF_SIZE;
      if (currentWidthBreakpoint <= WidthBreakpoint.WIDTH_SM) {
        result = (result - MainPageConstants.ICONVIEW_ITEM_WIDTH[0] * MainPageConstants.FOUR) / MainPageConstants.FOUR;
      } else if (currentWidthBreakpoint === WidthBreakpoint.WIDTH_MD) {
        result = (result - MainPageConstants.ICONVIEW_ITEM_WIDTH[1] * MainPageConstants.SIX) / MainPageConstants.SIX;
      } else if (currentWidthBreakpoint === WidthBreakpoint.WIDTH_LG) {
        result =
          (result - MainPageConstants.LG_SIDEBAR_WIDTH -
            MainPageConstants.ICONVIEW_ITEM_WIDTH[2] * MainPageConstants.EIGHT) /
            MainPageConstants.EIGHT;
      } else {
        result =
          (result - MainPageConstants.XL_SIDEBAR_WIDTH -
            MainPageConstants.ICONVIEW_ITEM_WIDTH[3] * MainPageConstants.EIGHT) /
            MainPageConstants.EIGHT;
      }
      return result;
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `getNumber failed, errCode = ${err.code}, errMessage = ${err.message}.`);
    }
    return 0;
  }
}