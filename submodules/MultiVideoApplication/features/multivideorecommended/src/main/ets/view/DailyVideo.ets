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

import { BreakpointType, BreakpointVisibilityUtil, DeviceApiVersionUtil, WindowInfo } from 'multivideobase';
import { MainPageConstants } from '../constants/MainPageConstants';
import DailyVideoCoverListViewModel, { DailyVideoCoverViewModel } from '../viewmodel/DailyVideoCoverViewModel';
import { getTabIndex,
  MembershipTag,
  SubtitleComponent, VideoImgComponent, VideoImgPlay, VideoImgRating } from './CommonView';
@Component
export struct  DailyVideo {
  @ObjectLink mainWindowInfo: WindowInfo;
  @Consume('inOnTv') isOnTv: boolean;
  @Consume('inOnPc') isOnPc: boolean;
  @Consume('currentTopIndex') currentTopIndex: number = 0;
  @State isShowingMainBorder: boolean = false;
  @ObjectLink dailyVideoCoverList: DailyVideoCoverListViewModel;
  private breakpointFlags() {
    return BreakpointVisibilityUtil.getFlags(this.mainWindowInfo);
  }

  aboutToAppear(): void {
    this.dailyVideoCoverList.loadVideoCoverData();
  }

  aboutToDisappear(): void {
    this.dailyVideoCoverList.clearVideoCoverData();
  }

  build() {
    Column() {
      SubtitleComponent({ title: $r('app.string.DailyVideo'), mainWindowInfo: this.mainWindowInfo })
        .margin({ top: this.isOnTv ? '35vp' : '13vp', bottom: this.isOnTv ? '16vp' : '0vp' })

      GridRow({
        columns: { sm: 4, md: 12 },
        gutter: this.isOnTv ? '32vp' : '12vp'
      }) {
        // Main video section.
        GridCol({ span: { xs: 4, sm: 4, md: 6, lg: 6, xl: 6 } }) {
          Column() {
            Stack({ alignContent: Alignment.Bottom }) {
              Image(this.dailyVideoCoverList.getMainCover().getImgSrc() ?
                this.dailyVideoCoverList.getMainCover().getImgSrc() : '')
                .focusable(true)
                .objectFit(ImageFit.Cover)
                .width('100%')
                .height('100%')
                .draggable(false)
                .borderRadius(this.isOnTv ? 18 : {
                  topLeft: 16,
                  topRight: 16
                })
              VideoImgPlay({ mainWindowInfo: this.mainWindowInfo })
                .visibility(this.isOnTv ? Visibility.None : Visibility.Visible)

              Row() {
                Text(this.dailyVideoCoverList.getMainCover().getTitle())
                  .fontSize(this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '20fp' : '16fp')
                  .fontColor($r('app.color.mp_white'))
                  .fontWeight(700)
                  .margin({ left: this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '16vp' : '12vp' })
                  .layoutWeight(1)
                  .maxLines(1)

                Text(this.dailyVideoCoverList.getMainCover().getRating())
                  .fontSize(this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '12fp' : '8fp')
                  .fontWeight(FontWeight.Normal)
                  .fontColor($r('app.color.mp_white'))
                  .height(this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '18vp' : '12vp')
                  .width(this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '30vp' : '20vp')
                  .margin({
                    right: this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '16vp' : '12vp',
                    top: this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '6vp' : '5vp'
                  })
                  .backgroundColor($r('app.color.mp_badge_overlay_background'))
                  .borderRadius(this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '3vp' : '2vp')
                  .textAlign(TextAlign.Center)
                  .visibility(this.isOnTv ? Visibility.None : Visibility.Visible)
              }
              .alignItems(VerticalAlign.Top)
              .justifyContent(FlexAlign.Start)
              .width('100%')
              .height(this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '46vp' : '33vp')

              Column() {
                MembershipTag()
              }
              .width('100%')
              .height('100%')
              .alignItems(HorizontalAlign.End)
              .justifyContent(FlexAlign.Start)
              .visibility(this.isOnTv ? Visibility.Visible : Visibility.None)
            }
            .width('100%')
            .layoutWeight(5)

            if (!this.isOnTv) {
              Row() {
                Image($r('app.media.daily_small_video'))
                  .height('70%')
                  .borderRadius(8)

                Column({ space: '8vp' }) {
                  Text(this.dailyVideoCoverList.getMainCover().getOtherInfo())
                    .fontSize(this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '16vp' : '14vp')
                    .fontWeight(FontWeight.Normal)
                    .maxLines(1)
                    .fontColor(this.currentTopIndex === 2 ? $r('app.color.mp_text_title_on_immersive') :
                    $r('app.color.mp_text_title'))
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                  Text(this.dailyVideoCoverList.getMainCover().getContent())
                    .fontSize(this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '14vp' : '12vp')
                    .fontWeight(FontWeight.Normal)
                    .maxLines(1)
                    .fontColor(this.currentTopIndex === 2 ? $r('app.color.mp_text_body_on_immersive') :
                      $r('app.color.mp_text_body'))
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }
                .margin({
                  left: this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '16vp' : '12vp',
                  right: this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '16vp' : '12vp'
                })
                .alignItems(HorizontalAlign.Start)
                .justifyContent(FlexAlign.Center)
                .layoutWeight(1)
                .height('100%')

                Button($r('app.string.follow'))
                  .fontSize(this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '14fp' : '12fp')
                  .fontColor($r('app.color.mp_tab_sel_color'))
                  .fontWeight(500)
                  .height('34vp')
                  .width('77vp')
                  .borderRadius(this.isOnPc ? '8vp' : '50%')
                  .backgroundColor(this.currentTopIndex === 2 ? $r('app.color.mp_button_background_on_immersive') :
                    $r('app.color.mp_button_background'))
              }
              .alignItems(VerticalAlign.Center)
              .padding({
                left: this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '16vp' : '12vp',
                right: this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '16vp' : '12vp'
              })
              .layoutWeight(2)
            }
          }
          .tabIndex(getTabIndex('DailyVideoOne'))
          .width('100%')
          .borderRadius(18)
          .backgroundColor(this.currentTopIndex === 2 ? $r('app.color.mp_card_background_on_immersive') :
            $r('app.color.mp_card_background'))
        }
        // Dynamically setting the height at different breakpoints.
        .height(this.isOnTv ? '356vp' :
          this.getDailyVideoHeight(this.mainWindowInfo.widthBp, this.mainWindowInfo.windowSize.width, true))
        .padding({
          top: this.isOnTv ? '8vp' : '13vp',
          bottom: this.isOnTv ? '0vp' : this.mainWindowInfo.widthBp > WidthBreakpoint.WIDTH_SM ? '13vp' : '0vp',
          left: new BreakpointType('16vp', '16vp', '24vp', '36vp', '36vp').getValue(this.mainWindowInfo.widthBp),
          right: this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM ? '16vp' : '0vp'
        })

        // Sub video section.
        GridCol({
          span: {
            xs: 4,
            sm: 4,
            md: 6,
            lg: 6,
            xl: 6
          }
        }) {
          Grid() {
            ForEach(this.dailyVideoCoverList.getCovers(), (item: DailyVideoCoverViewModel) => {
              GridItem() {
                Column() {
                  Stack({ alignContent: Alignment.Bottom }) {
                    VideoImgComponent(item.getImgSrc())
                    VideoImgPlay({
                      mainWindowInfo: this.mainWindowInfo
                    })
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

                    Column() {
                      MembershipTag()
                    }
                    .width('100%')
                    .height('100%')
                    .alignItems(HorizontalAlign.End)
                    .justifyContent(FlexAlign.Start)
                    .visibility(this.isOnTv ? Visibility.Visible : Visibility.None)
                  }
                  .width('100%')
                  .layoutWeight(1)

                  Text(item.getTitle())
                    .fontSize(this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '16fp' : '14fp')
                    .fontWeight(FontWeight.Normal)
                    .lineHeight(this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '24vp' : '21vp')
                    .margin({ top: '4vp' })
                    .fontColor(this.currentTopIndex === 2 ? $r('app.color.mp_text_title_on_immersive') :
                      $r('app.color.mp_text_title'))
                    .visibility(this.isOnTv ? Visibility.None : Visibility.Visible)

                  Text(item.getContent())
                    .fontSize('12fp')
                    .fontWeight(FontWeight.Normal)
                    .lineHeight('18vp')
                    .margin({ top: '2vp' })
                    .fontColor(this.currentTopIndex === 2 ? $r('app.color.mp_text_body_on_immersive') :
                      $r('app.color.mp_text_body'))
                    .visibility(this.breakpointFlags().isWidthBpBelowMd ? Visibility.Visible : Visibility.None)
                }
                .alignItems(HorizontalAlign.Start)
              }
            }, (item: DailyVideoCoverViewModel) => item.getId())
          }
          .tabIndex(getTabIndex('DailyVideoTwo'))
          // Dynamically setting the height at different breakpoints.
          .height(this.isOnTv ? '356vp' :
            this.getDailyVideoHeight(this.mainWindowInfo.widthBp, this.mainWindowInfo.windowSize.width, false))
          .width('100%')
          // Sets the number of grid layout columns and evenly divides the height.
          .columnsTemplate('1fr 1fr')
          .rowsTemplate('1fr 1fr')
          .rowsGap(this.isOnTv ? '32vp' : '12vp')
          .columnsGap(this.isOnTv ? '32vp' : '12vp')
          .padding({
            top: this.isOnTv ? '8vp' : this.mainWindowInfo.widthBp > WidthBreakpoint.WIDTH_SM ? '13vp' : '6vp',
            bottom: this.isOnTv ? '0vp' : this.mainWindowInfo.widthBp > WidthBreakpoint.WIDTH_SM ? '13vp' : '6vp',
            left: this.isOnTv ? '0vp' : this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM ? '16vp' : '6vp',
            right: new BreakpointType('16vp', '16vp', '24vp', '36vp', '36vp').getValue(this.mainWindowInfo.widthBp)
          })
        }
      }
    }
    .padding({
      left: DeviceApiVersionUtil.isApiVersionAfter23() ? '0vp' :
        this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG && this.currentTopIndex === 2 && !this.isOnTv &&
          !this.isOnPc ? '96vp' : '0vp'
    })
    .margin({ top: this.isOnTv ? '0vp' : '12vp' })
  }

  getDailyVideoHeight(currentWidthBreakpoint: number, windowWidth: number, isMain: boolean): string {
    // Available content width after margins and inter-column gap.
    let availableWidth: number = this.getUIContext().px2vp(windowWidth) - new BreakpointType(
      MainPageConstants.VIDEO_GRID_MARGIN[0], MainPageConstants.VIDEO_GRID_MARGIN[0],
      MainPageConstants.VIDEO_GRID_MARGIN[1], MainPageConstants.VIDEO_GRID_MARGIN[2],
      MainPageConstants.VIDEO_GRID_MARGIN[2])
      .getValue(this.mainWindowInfo.widthBp) - MainPageConstants.VIDEO_GRID_ITEM_SPACE;

    // Per-card width by breakpoint.
    let cardWidth: number = 0;
    if (currentWidthBreakpoint === WidthBreakpoint.WIDTH_LG) {
      cardWidth =
        (availableWidth - MainPageConstants.LG_SIDEBAR_WIDTH) / MainPageConstants.DAILY_VIDEO_GRID_COLUMN_COUNT;
    } else if (currentWidthBreakpoint === WidthBreakpoint.WIDTH_MD) {
      cardWidth = availableWidth / MainPageConstants.DAILY_VIDEO_GRID_COLUMN_COUNT;
    } else if (currentWidthBreakpoint <= WidthBreakpoint.WIDTH_SM) {
      cardWidth = availableWidth / MainPageConstants.DAILY_VIDEO_GRID_COLUMN_COUNT_SM;
    } else {
      cardWidth =
        (availableWidth - MainPageConstants.XL_SIDEBAR_WIDTH) / MainPageConstants.DAILY_VIDEO_GRID_COLUMN_COUNT;
    }

    // Image height from fixed dialog aspect ratio.
    const imageHeight: number =
      (cardWidth - MainPageConstants.VIDEO_GRID_ITEM_SPACE) / MainPageConstants.VIDEO_DIALOG_ASPECT_RATIO;

    // Compose final container height by breakpoint rules.
    if (currentWidthBreakpoint <= WidthBreakpoint.WIDTH_SM) {
      if (isMain) {
        return (imageHeight + MainPageConstants.DAILY_VIDEO_DESCRIPTION_HEIGHT[0] + MainPageConstants.VP_UNIT);
      }
      return (imageHeight + MainPageConstants.DAILY_VIDEO_DESCRIPTION_HEIGHT[2] + MainPageConstants.VP_UNIT);
    }

    if (currentWidthBreakpoint === WidthBreakpoint.WIDTH_MD) {
      return (imageHeight + MainPageConstants.DAILY_VIDEO_DESCRIPTION_HEIGHT[1] + MainPageConstants.VP_UNIT);
    }

    return (imageHeight + MainPageConstants.DAILY_VIDEO_DESCRIPTION_HEIGHT[3] + MainPageConstants.VP_UNIT);
  }
}