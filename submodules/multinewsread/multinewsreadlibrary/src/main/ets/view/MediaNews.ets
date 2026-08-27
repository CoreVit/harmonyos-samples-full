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

import Constants from '../../ets/common/Constants';
import { News } from '../../ets/viewmodel/ImageAndTextViewModel';
import MultiImageViewModel from '../../ets/viewmodel/MultiImageViewModelForMediaNews';
import NewsWithThreeImages from '../component/NewsWithImages';
import { BreakpointType } from '../utils/BreakpointSystem';

@Component
export struct MediaNews {
  @StorageProp(Constants.KEY_BREAKPOINT) curBp: string = Constants.BREAKPOINTS[1];
  @StorageProp(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @Consume(Constants.KEY_PATH_STACK) pathInfos: NavPathStack;
  private multiImageViewModel = new MultiImageViewModel();
  @State newsList: News[] = this.multiImageViewModel.getNewsListByBreakpoint(this.curBp);

  build() {
    NavDestination() {
      Row() {
        Button({ type: ButtonType.Circle }) {
          SymbolGlyph($r('sys.symbol.chevron_backward'))
            .fontColor([$r('sys.color.icon_primary')])
            .fontSize($r('sys.float.Title_M'))
        }
        .height($r('app.float.back_button_height'))
        .aspectRatio(1)
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .onClick(() => this.pathInfos.pop())

        Text($r('app.string.repeated_layout_1'))
          .margin({ left: $r('sys.float.padding_level4') })
          .font({ size: $r('app.float.bar_font_size'), weight: Constants.FONT_WEIGHT[2] })
          .fontColor($r('sys.color.font_primary'))
      }
      .padding({
        left: new BreakpointType({
          sm: $r('sys.float.padding_level8'),
          md: $r('sys.float.padding_level12'),
          lg: $r('sys.float.padding_level16')
        }).getValue(this.curBp),
        right: new BreakpointType({
          sm: $r('sys.float.padding_level8'),
          md: $r('sys.float.padding_level12'),
          lg: $r('sys.float.padding_level16')
        }).getValue(this.curBp),
      })
      .width(Constants.FULL_WIDTH)
      .height($r('app.float.bar_height'))
      .zIndex(2)

      Column() {
        GridRow({
          gutter: $r('app.float.grid_gutter_bigger')
        }) {
          ForEach(this.newsList, (news: News) => {
            GridCol({
              span: {
                sm: Constants.GRID_COL_SPAN[5],
                lg: Constants.GRID_COL_SPAN[4]
              }
            }) {
              NewsWithThreeImages({ news })
            }
          }, (news: News) => news.getNewsID())
        }
        .onBreakpointChange((breakPoints: string) => {
          this.newsList = this.multiImageViewModel.getNewsListByBreakpoint(breakPoints);
        })
        .width(Constants.FULL_WIDTH)
      }
      .padding({
        left: new BreakpointType({
          sm: $r('sys.float.padding_level8'),
          md: $r('sys.float.padding_level12'),
          lg: $r('sys.float.padding_level16')
        }).getValue(this.curBp),
        right: new BreakpointType({
          sm: $r('sys.float.padding_level8'),
          md: $r('sys.float.padding_level12'),
          lg: $r('sys.float.padding_level16')
        }).getValue(this.curBp),
      })
      .width(Constants.FULL_WIDTH)
      .justifyContent(FlexAlign.Center)
    }
    .hideTitleBar(true)
    .padding({ top: this.statusBarHeight })
    .backgroundColor($r('sys.color.background_primary'))
    .title('', { backgroundColor: $r('sys.color.background_primary') })
  }
}