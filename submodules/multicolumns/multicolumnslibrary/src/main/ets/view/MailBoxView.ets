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

import { Constants } from '../common/Constants';
import { MailNavigation } from '../component/MailNavigation';
import { MailSideBar } from '../component/MailSideBar';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';

@Builder
export function MailBoxBuilder() {
  MailBoxView();
}

@Component
export struct MailBoxView {
  @State isFold: boolean = false;
  @State sideBarWidth: number = 304;
  @StorageProp(Constants.KEY_BREAKPOINT) currentBreakPoint: string = BreakpointTypeEnum.MD;
  @StorageProp(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageProp('isShowMailSideBar') isShowMailSideBar: boolean =
    this.currentBreakPoint === BreakpointTypeEnum.LG || this.currentBreakPoint === BreakpointTypeEnum.XL ? true : false;
  private pageStack: NavPathStack = new NavPathStack();

  aboutToAppear(): void {
    this.isShowMailSideBar =
      this.currentBreakPoint === BreakpointTypeEnum.LG || this.currentBreakPoint === BreakpointTypeEnum.XL ? true :
        false;
  }

  build() {
    NavDestination() {
      GridRow() {
        GridCol({ span: Constants.GRID_SPACE }) {
          Stack({ alignContent: Alignment.TopStart }) {
            SideBarContainer(SideBarContainerType.AUTO) {
              // Area A
              Column() {
                MailSideBar()
              }
              .borderWidth({ right: 0.5 })
              .borderColor({ right: $r('sys.color.comp_divider') })
              .width('100%')
              .height('100%')
              .backgroundColor($r('sys.color.background_primary'))

              // Area B+C
              Column() {
                Stack() {
                  MailNavigation()
                  if (this.isFold && this.currentBreakPoint !== BreakpointTypeEnum.LG &&
                    this.currentBreakPoint !== BreakpointTypeEnum.XL) {
                    Column()
                      .width('100%')
                      .height('100%')
                      .backgroundColor($r('app.color.detail_background'))
                  }
                }
              }.height('100%').width('100%')
            }
            .divider({ color: $r('sys.color.comp_divider'), strokeWidth: 0 })
            .sideBarWidth(this.sideBarWidth)
            .minSideBarWidth(Constants.SIDE_BAR_WIDTH_MIN)
            .minContentWidth(this.currentBreakPoint === BreakpointTypeEnum.SM ? '100%' :
              Constants.SIDE_BAR_WIDTH_CONTENT_MIN)
            .controlButton({
              left: new BreakpointType({
                sm: Constants.PADDING_16 + Constants.BACK_SIZE,
                md: Constants.PADDING_24 + Constants.BACK_SIZE,
                lg: Constants.PADDING_32 + Constants.BACK_SIZE,
              }).getValue(this.currentBreakPoint),
              top: this.statusBarHeight === 0 ? Constants.PADDING_16 :
                this.statusBarHeight + Constants.PADDING_CUSTOM,
              width: Constants.IMAGE_SIZE_SMALL,
              height: Constants.IMAGE_SIZE_SMALL
            })
            .showSideBar(this.isShowMailSideBar)
            .onChange((value: boolean) => {
              this.isShowMailSideBar = value;
              this.isFold = value;
            })

            Button({ type: ButtonType.Circle }) {
              SymbolGlyph($r('sys.symbol.chevron_backward'))
                .fontColor([$r('sys.color.icon_primary')])
                .fontSize($r('sys.float.Title_M'))
            }
            .margin({
              left: new BreakpointType({
                sm: $r('sys.float.padding_level8'),
                md: $r('sys.float.padding_level12'),
                lg: $r('sys.float.padding_level16')
              }).getValue(this.currentBreakPoint),
              top: this.statusBarHeight === 0 ? Constants.PADDING_16 :
                this.statusBarHeight + Constants.PADDING_CUSTOM
            })
            .backgroundColor(Color.Transparent)
            .height($r('app.float.button_height_small'))
            .aspectRatio(1)
            .onClick(() => {
              this.pageStack.pop();
            })
          }
        }
      }
    }
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.pageStack = context.pathStack;
    })
  }
}



