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
import { PhotoContent } from '../component/PhotoContent';
import { PhotoSideBar } from '../component/PhotoSideBar';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';

@Builder
export function PhotoAlbumBuilder() {
  PhotoAlbumView();
}

@Component
export struct PhotoAlbumView {
  @StorageProp(Constants.KEY_BREAKPOINT) curBp: string = BreakpointTypeEnum.SM;
  @StorageProp(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @State sideBarStatus: boolean = this.curBp !== BreakpointTypeEnum.SM;
  private pageStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      GridRow() {
        GridCol({ span: Constants.GRID_SPACE }) {
          Stack({ alignContent: Alignment.TopStart }) {
            SideBarContainer(SideBarContainerType.AUTO) {
              Column() {
                PhotoSideBar()
              }
              .backgroundColor($r('sys.color.comp_background_primary'))

              Column() {
                PhotoContent({ sideBarStatus: $sideBarStatus })
              }
              .backgroundColor($r('sys.color.background_secondary'))
            }
            .divider({ strokeWidth: 0.5, color: $r('sys.color.comp_divider') })
            .controlButton({
              left: Constants.PADDING_16 + Constants.BACK_SIZE,
              top: this.statusBarHeight === 0 ? Constants.PADDING_16 :
                this.statusBarHeight + Constants.PADDING_CUSTOM,
              width: Constants.IMAGE_SIZE_SMALL,
              height: Constants.IMAGE_SIZE_SMALL
            })
            .showSideBar(this.curBp !== BreakpointTypeEnum.SM)
            .onChange((value: boolean) => {
              this.sideBarStatus = value;
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
              }).getValue(this.curBp),
              top: this.statusBarHeight === 0 ? $r('sys.float.padding_level8') :
                this.statusBarHeight + Constants.PADDING_CUSTOM,
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