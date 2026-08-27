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

import { BreakpointType, DeviceApiVersionUtil, WindowInfo } from 'multivideobase';
import { MainPageConstants } from '../constants/MainPageConstants';
import NewVideoReleaseCoverListViewModel, {
  NewVideoReleaseCoverViewModel
} from '../viewmodel/NewVideoReleaseCoverViewModel';
import { getTabIndex,SubtitleComponent,VideoContent,VideoImgComponent, VideoImgPlay, VideoImgRating, VideoTitle } from
  './CommonView';

@Component
export struct NewVideoRelease {
  @ObjectLink mainWindowInfo: WindowInfo;
  @Consume('inOnTv') isOnTv: boolean;
  @Consume('inOnPc') isOnPc: boolean;
  @Consume('currentTopIndex') currentTopIndex: number = 0;
  @ObjectLink newVideoReleaseCoverList: NewVideoReleaseCoverListViewModel;

  aboutToAppear(): void {
    this.newVideoReleaseCoverList.loadVideoCoverData();
  }

  aboutToDisappear(): void {
    this.newVideoReleaseCoverList.clearVideoCoverData();
  }

  build() {
    Column() {
      SubtitleComponent({ title: MainPageConstants.HOME_SUB_TITLES[0], mainWindowInfo: this.mainWindowInfo })
        .margin({ top: this.isOnTv ? '35vp' : '13vp', bottom: this.isOnTv ? '16vp' : '0vp' })

      // Video grid
      Grid() {
        ForEach(this.newVideoReleaseCoverList.getCovers(), (item: NewVideoReleaseCoverViewModel, index: number) => {
          GridItem() {
            Column() {
              Stack({ alignContent: Alignment.Bottom }) {
                VideoImgComponent(item.getImgSrc(), index)
                VideoImgPlay({ mainWindowInfo: this.mainWindowInfo })
                  .visibility(this.isOnTv ? Visibility.None : Visibility.Visible)
                VideoImgRating(item.getRating(), this.isOnTv)
                Row() {
                  Text(item.getTitle())
                    .fontSize('16fp')
                    .fontWeight(FontWeight.Normal)
                    .lineHeight('24vp')
                    .margin({ top: '4vp' })
                    .fontColor($r('app.color.mp_white'))
                }
                .justifyContent(FlexAlign.Start)
                .width('100%')
                .padding(8)
                .visibility(this.isOnTv ? Visibility.Visible : Visibility.None)
              }
              .height(new BreakpointType('120vp', '120vp', '161vp', '211vp',
                '240vp').getValue(this.mainWindowInfo.widthBp))
              .width('100%')
              .aspectRatio(MainPageConstants.NEW_VIDEO_ASPECT_RATIO)

              if (!this.isOnTv) {
                VideoTitle({ title: item.getTitle() })
                VideoContent({ content: item.getContent() })
              }
            }
            .alignItems(HorizontalAlign.Start)
          }
        }, (item: NewVideoReleaseCoverViewModel) => item.getId())
      }
      .tabIndex(MainPageConstants.DIRECTION_LIST.length >= 6 ? getTabIndex(MainPageConstants.DIRECTION_LIST[5]) : 6)
      .padding({
        left: new BreakpointType('16vp', '16vp', '24vp', '36vp', '36vp').getValue(this.mainWindowInfo.widthBp),
        right: new BreakpointType('16vp', '16vp', '24vp', '36vp', '36vp').getValue(this.mainWindowInfo.widthBp),
        top: this.isOnTv ? '8vp' : '13vp',
        bottom: this.isOnTv ? '0vp' : '13vp'
      })
      .columnsTemplate(new BreakpointType(MainPageConstants.VIDEO_GRID_COLUMNS[1],
        MainPageConstants.VIDEO_GRID_COLUMNS[1],
        MainPageConstants.VIDEO_GRID_COLUMNS[3], MainPageConstants.VIDEO_GRID_COLUMNS[4],
        MainPageConstants.VIDEO_GRID_COLUMNS[4]).getValue(this.mainWindowInfo.widthBp))
      .rowsTemplate(MainPageConstants.NEW_VIDEO_ROWS_TEMPLATE)
      .width('100%')
      .columnsGap(this.isOnTv ? '32vp' : '12vp')
      .height(this.isOnTv ? '210vp' :
        this.getNewVideoHeight(this.mainWindowInfo.widthBp, this.mainWindowInfo.windowSize.width))
    }
    .padding({
      left: DeviceApiVersionUtil.isApiVersionAfter23() ? '0vp' :
        this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG && this.currentTopIndex === 2 && !this.isOnTv &&
          !this.isOnPc ? '96vp' : '0vp'
    })
  }

  getNewVideoHeight(currentWidthBreakpoint: number, windowWidth: number): string {
    let result: number = this.getUIContext().px2vp(windowWidth) -
    new BreakpointType(MainPageConstants.VIDEO_GRID_MARGIN[0], MainPageConstants.VIDEO_GRID_MARGIN[0],
      MainPageConstants.VIDEO_GRID_MARGIN[1], MainPageConstants.VIDEO_GRID_MARGIN[2],
      MainPageConstants.VIDEO_GRID_MARGIN[2]).getValue(this.mainWindowInfo.widthBp);
    if (currentWidthBreakpoint <= WidthBreakpoint.WIDTH_SM) {
      result = (result - MainPageConstants.VIDEO_GRID_ITEM_SPACE * MainPageConstants.TWO) / MainPageConstants.THREE;
    } else if (currentWidthBreakpoint === WidthBreakpoint.WIDTH_MD) {
      result = (result - MainPageConstants.VIDEO_GRID_ITEM_SPACE * MainPageConstants.FOUR) / MainPageConstants.FIVE;
    } else if (currentWidthBreakpoint === WidthBreakpoint.WIDTH_LG) {
      if (this.isOnPc) {
        result = result - MainPageConstants.XL_SIDEBAR_WIDTH;
      } else if (DeviceApiVersionUtil.isApiVersionBefore23()) {
        result = result - MainPageConstants.LG_SIDEBAR_WIDTH;
      }
      result = (result - MainPageConstants.VIDEO_GRID_ITEM_SPACE * MainPageConstants.SIX) / MainPageConstants.SEVEN;
    } else {
      if (this.isOnPc) {
        result = result - MainPageConstants.XL_SIDEBAR_WIDTH;
      } else if (DeviceApiVersionUtil.isApiVersionBefore23()) {
        result = result - MainPageConstants.LG_SIDEBAR_WIDTH;
      }
      result = (result - MainPageConstants.VIDEO_GRID_ITEM_SPACE * MainPageConstants.SIX) / MainPageConstants.SEVEN;
    }
    return (result / MainPageConstants.NEW_VIDEO_ASPECT_RATIO + MainPageConstants.NEW_VIDEO_DESCRIPTION_HEIGHT +
    MainPageConstants.VP_UNIT);
  }
}