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

import {
  BreakpointConstants,
  BreakpointType,
  CommonConstants,
  DeviceApiVersionUtil,
  WindowInfo,
  WindowUtil
} from 'multivideobase';
import { MainPageConstants } from '../constants/MainPageConstants';
import { PreviousVideoUtil } from '../utils/PreviousVideoUtil';
import { getTabIndex, SubtitleComponent } from './CommonView';
import PreviousVideoCoverListViewModel, { PreviousVideoCoverViewModel } from '../viewmodel/PreviousVideoCoverViewModel';

@Component
export struct PreviousVideo {
  @ObjectLink mainWindowInfo: WindowInfo;
  @StorageLink(CommonConstants.WINDOW_UTIL) windowUtil: WindowUtil | undefined = undefined;
  @Consume('currentTopIndex') currentTopIndex: number = 0;
  @Consume('inOnPc') isOnPc: boolean;
  @Consume('pageInfo') pageInfo: NavPathStack;
  @ObjectLink previousVideoCoverList: PreviousVideoCoverListViewModel;

  aboutToAppear(): void {
    this.previousVideoCoverList.loadVideoCoverData();
    this.previousVideoCoverList.updateCoversTwoByBreakpoints(this.mainWindowInfo.widthBp);
  }

  aboutToDisappear(): void {
    this.previousVideoCoverList.clearVideoCoverData();
  }

  build() {
    Column() {
      SubtitleComponent({ title: MainPageConstants.HOME_SUB_TITLES[2], mainWindowInfo: this.mainWindowInfo })

      GridRow({
        columns: {
          xs: BreakpointConstants.GRID_ROW_COLUMNS[2],
          sm: BreakpointConstants.GRID_ROW_COLUMNS[2],
          md: BreakpointConstants.GRID_ROW_COLUMNS[0],
          lg: BreakpointConstants.GRID_ROW_COLUMNS[1],
          xl: BreakpointConstants.GRID_ROW_COLUMNS[1]
        },
        gutter: '12vp'
      }) {
        ForEach(this.previousVideoCoverList.getCoversOne(), (item: PreviousVideoCoverViewModel, index: number) => {
          GridCol({
            span: {
              xs: BreakpointConstants.GRID_COLUMN_SPANS[5],
              sm: BreakpointConstants.GRID_COLUMN_SPANS[5],
              md: BreakpointConstants.GRID_COLUMN_SPANS[1],
              lg: BreakpointConstants.GRID_COLUMN_SPANS[3],
              xl: BreakpointConstants.GRID_COLUMN_SPANS[3]
            }
          }) {
            Row() {
              Image(item.getImgSrc())
                .objectFit(ImageFit.Cover)
                .margin({ right: this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM ? '10vp' : '12vp' })
                .layoutWeight(3)
                .height('100%')
                .borderRadius(12)

              Column() {
                Text(item.getTitle())
                  .fontSize(new BreakpointType('14fp', '14fp', '16fp', '18fp', '20fp')
                    .getValue(this.mainWindowInfo.widthBp))
                  .fontWeight(500)
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .fontColor(this.currentTopIndex === 2 ? $r('app.color.mp_text_title_on_immersive') :
                    $r('app.color.mp_text_title'))
                Text(item.getContent())
                  .fontSize(new BreakpointType('10fp', '10fp', '12fp', '14fp', '16fp')
                    .getValue(this.mainWindowInfo.widthBp))
                  .fontWeight(FontWeight.Normal)
                  .margin({ top: '4vp' })
                  .maxLines(1)
                  .fontColor(this.currentTopIndex === 2 ? $r('app.color.mp_text_body_on_immersive') :
                    $r('app.color.mp_text_body'))
                Text(item.getOtherInfo())
                  .fontSize(new BreakpointType('10fp', '10fp', '12fp', '14fp', '16fp')
                    .getValue(this.mainWindowInfo.widthBp))
                  .fontWeight(FontWeight.Normal)
                  .margin({ top: '4vp' })
                  .maxLines(1)
                  .fontColor(this.currentTopIndex === 2 ? $r('app.color.mp_text_body_on_immersive') :
                    $r('app.color.mp_text_body'))

                Row() {
                  Button(index === 0 ? MainPageConstants.HOME_BUTTON_TEXT[1] : MainPageConstants.HOME_BUTTON_TEXT[2])
                    .borderRadius(this.isOnPc ? 8 : '50%')
                    .backgroundColor($r('app.color.mp_tab_sel_color'))
                    .fontWeight(500)
                    .fontSize(this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '14fp' : '12fp')
                    .fontColor($r('app.color.mp_white'))
                    .height(this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '34vp' : '25vp')
                    .layoutWeight(1)
                    .groupDefaultFocus(index === 0 ? true : false)
                    .onClick(() => {
                      this.pageInfo.pushPath({ name: MainPageConstants.PAGE_NAME_FOR_VIDEO });
                    })

                  Blank()
                    .width('12vp')

                  Button(MainPageConstants.HOME_BUTTON_TEXT[3])
                    .borderRadius(this.isOnPc ? 8 : '50%')
                    .backgroundColor(this.currentTopIndex === 2 ? $r('app.color.mp_button_background_on_immersive') :
                    $r('app.color.mp_button_background'))
                    .fontWeight(500)
                    .fontSize(this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '14fp' : '12fp')
                    .fontColor($r('app.color.mp_tab_sel_color'))
                    .height(this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '34vp' : '25vp')
                    .layoutWeight(1)
                }
                .width('100%')
                .alignItems(VerticalAlign.Bottom)
                .layoutWeight(1)
              }
              .alignItems(HorizontalAlign.Start)
              .justifyContent(FlexAlign.Start)
              .layoutWeight(4)
            }
            .aspectRatio(MainPageConstants.PREVIOUS_ONE_ROW_RATIO)
            .width('100%')
            .padding({
              top: this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM ? '10vp' : '12vp',
              bottom: this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM ? '10vp' : '12vp',
              left: this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM ? '10vp' : '12vp',
              right: this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM ? '10vp' : '12vp'
            })
            .backgroundColor(this.currentTopIndex === 2 ? $r('app.color.mp_card_background_on_immersive') :
              $r('app.color.mp_card_background'))
            .borderRadius(16)
          }
        }, (item: PreviousVideoCoverViewModel) => item.getId())

        ForEach(this.previousVideoCoverList.getCoversTwo(), (item: PreviousVideoCoverViewModel, index: number) => {
          GridCol({
            span: {
              xs: BreakpointConstants.GRID_COLUMN_SPANS[6],
              sm: BreakpointConstants.GRID_COLUMN_SPANS[6],
              md: BreakpointConstants.GRID_COLUMN_SPANS[4],
              lg: BreakpointConstants.GRID_COLUMN_SPANS[4],
              xl: BreakpointConstants.GRID_COLUMN_SPANS[4]
            }
          }) {
            Column() {
              Image(item.getImgSrc())
                .width('100%')
                .aspectRatio(PreviousVideoUtil.getImgAspectRatio(this.mainWindowInfo.widthBp, index))
                .objectFit(ImageFit.Cover)
                .focusable(true)
                .borderRadius({
                  topLeft: 12,
                  topRight: 12
                })

              Column() {
                Text(item.getTitle())
                  .fontWeight(FontWeight.Normal)
                  .fontSize(this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '20fp' : '14fp')
                  .maxLines(1)
                  .lineHeight(this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '28vp' : '21vp')
                  .fontColor(this.currentTopIndex === 2 ? $r('app.color.mp_text_title_on_immersive') :
                    $r('app.color.mp_text_title'))
                Text(item.getContent())
                  .fontWeight(FontWeight.Normal)
                  .fontSize(this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '16fp' : '12fp')
                  .margin({ top: this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '6vp' : '4vp' })
                  .maxLines(1)
                  .lineHeight(this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '20vp' : '18vp')
                  .fontColor(this.currentTopIndex === 2 ? $r('app.color.mp_text_body_on_immersive') :
                    $r('app.color.mp_text_body'))
              }
              .alignItems(HorizontalAlign.Start)
              .height(this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '80vp' : '61vp')
              .width('100%')
              .padding({
                top: this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '12vp' : '8vp',
                bottom: this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '14vp' : '10vp',
                left: this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '12vp' : '8vp',
                right: this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '12vp' : '8vp'
              })
            }
            .translate({ y: (((index === 2) || (index === 3)) && (this.mainWindowInfo.widthBp ===
            WidthBreakpoint.WIDTH_MD)) ? '-42vp' : '0vp' })
            .backgroundColor(this.currentTopIndex === 2 ? $r('app.color.mp_card_background_on_immersive') :
              $r('app.color.mp_card_background'))
            .borderRadius(12)
          }
        }, (item: PreviousVideoCoverViewModel) =>item.getId())
      }
      .onBreakpointChange((breakPoints) => {
        const BREAKPOINT_MAP = new Map<string, WidthBreakpoint>([
          ['xs', WidthBreakpoint.WIDTH_XS],
          ['sm', WidthBreakpoint.WIDTH_SM],
          ['md', WidthBreakpoint.WIDTH_MD],
          ['lg', WidthBreakpoint.WIDTH_LG],
          ['xl', WidthBreakpoint.WIDTH_XL]
        ]);
        this.previousVideoCoverList.updateCoversTwoByBreakpoints(BREAKPOINT_MAP.get(breakPoints) ||
          WidthBreakpoint.WIDTH_SM);
      })
      .padding({
        left: new BreakpointType('16vp', '16vp', '24vp', '36vp', '42vp').getValue(this.mainWindowInfo.widthBp),
        right: new BreakpointType('16vp', '16vp', '24vp', '36vp', '42vp').getValue(this.mainWindowInfo.widthBp)})
      .margin({ top: '12vp' })
    }
    .tabIndex(getTabIndex(MainPageConstants.DIRECTION_LIST[8]))
    .padding({
      left: DeviceApiVersionUtil.isApiVersionAfter23() ? '0vp' :
        this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG && this.currentTopIndex === 2 && !this.isOnPc ?
          '96vp' : '0vp',
      bottom: '8vp'
    })
  }
}