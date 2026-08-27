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

import Constants from '../common/Constants';
import HotList from '../component/HotList';
import LeftTextRightImageBgGray from '../component/LeftTextRightImageBgGray';
import LeftTextRightImageBgWhite from '../component/LeftTextRightImageBgWhite';
import NewsWithThreeImage from '../component/NewsWithImages';
import TopImageBottomText from '../component/TopImageBottomText';
import TopTextBottomVideo from '../component/TopTextBottomVideo';
import VideoCard from '../component/VideoCard';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';
import HotListViewModel from '../viewmodel/HotListViewModel';
import ImageAndTextViewModel, { News } from '../viewmodel/ImageAndTextViewModel';
import MultiImageViewModel from '../viewmodel/MultiImageViewModel';
import TopImageBottomTextViewModel from '../viewmodel/TopImageBottomTextViewModel';
import VideoListViewModel from '../viewmodel/VideoListViewModel';

@Component
export struct NewsListPage {
  @StorageProp(Constants.KEY_BREAKPOINT) curBp: string = Constants.BREAKPOINTS[1];
  @StorageProp(Constants.KEY_NAV_INDICATOR_HEIGHT) navIndicatorHeight: number = 0;
  @StorageProp(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @Consume(Constants.KEY_PATH_STACK) pathInfos: NavPathStack;
  private scroller: Scroller = new Scroller();
  private imageAndTextViewModel: ImageAndTextViewModel = new ImageAndTextViewModel();
  private multiImageModel: MultiImageViewModel = new MultiImageViewModel();
  private videoModel: VideoListViewModel = new VideoListViewModel();
  private hotList: Resource[] = new HotListViewModel().getHotList();
  private topImageBottomTextModel: TopImageBottomTextViewModel = new TopImageBottomTextViewModel();

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

        Text($r('app.string.list_to_grid'))
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

      Scroll(this.scroller) {
        if (this.curBp === BreakpointTypeEnum.SM) {
          List({ space: Constants.LIST_GUTTER }) {
            ListItem() {
              HotList({ hotList: this.hotList })
                .margin({ bottom: $r('sys.float.padding_level4') })
            }

            ListItem() {
              NewsWithThreeImage({ news: this.multiImageModel.getNewsByIndex(2) })
            }

            ForEach(this.imageAndTextViewModel.getNewsListGroup(0), (news: News) => {
              ListItem() {
                LeftTextRightImageBgWhite({ news })
              }

            }, (news: News) => news.getNewsID())

            ListItem() {
              TopTextBottomVideo({ news: this.videoModel.getNewsByIndex(0) })
            }

            ListItem() {
              NewsWithThreeImage({ news: this.multiImageModel.getNewsByIndex(3) })
            }

            ListItem() {
              NewsWithThreeImage({ news: this.multiImageModel.getNewsByIndex(4) })
            }

            ForEach(this.imageAndTextViewModel.getNewsListGroup(1), (news: News) => {
              ListItem() {
                LeftTextRightImageBgWhite({ news })
              }
            }, (news: News) => news.getNewsID())

            ListItem() {
              TopTextBottomVideo({ news: this.videoModel.getNewsByIndex(1) })
            }
          }
          .width(Constants.FULL_WIDTH)
          .scrollBar(BarState.Off)
        } else {
          Column() {
            GridRow({
              columns: {
                md: Constants.GRID_ROW_COLUMNS[1],
                lg: Constants.GRID_ROW_COLUMNS[2]
              },
              gutter: $r('app.float.news_list_common_space')
            }) {
              GridCol() {
                HotList({ hotList: this.hotList })
              }

              GridCol() {
                TopImageBottomText({ news: this.topImageBottomTextModel.getNewsByIndex(0) })
              }

              GridCol() {
                Column() {
                  LeftTextRightImageBgGray({ news: this.imageAndTextViewModel.getNewsByIndex(0) })
                    .margin({ bottom: $r('sys.float.padding_level6') })
                  LeftTextRightImageBgGray({ news: this.imageAndTextViewModel.getNewsByIndex(1) })
                    .margin({ bottom: $r('sys.float.padding_level6') })
                }
                .height($r('app.float.cards_height2'))
                .justifyContent(FlexAlign.SpaceBetween)
              }

              GridCol() {
                Column() {
                  LeftTextRightImageBgGray({ news: this.imageAndTextViewModel.getNewsByIndex(2) })
                    .margin({ bottom: $r('sys.float.padding_level6') })
                  LeftTextRightImageBgGray({ news: this.imageAndTextViewModel.getNewsByIndex(3) })
                    .margin({ bottom: $r('sys.float.padding_level6') })
                }
                .height($r('app.float.cards_height2'))
                .justifyContent(FlexAlign.SpaceBetween)
              }
            }

            GridRow({
              columns: Constants.GRID_ALL_COLUMNS,
              gutter: $r('app.float.grid_gutter')
            }) {
              GridCol({
                span: {
                  md: Constants.GRID_COLUMN_SPAN[2],
                  lg: Constants.GRID_COLUMN_SPAN[1]
                }
              }) {
                VideoCard({ news: this.videoModel.getNewsByIndex(0) })
              }

              GridCol({
                span: {
                  md: Constants.GRID_COLUMN_SPAN[1],
                  lg: Constants.GRID_COLUMN_SPAN[0]
                }
              }) {
                TopImageBottomText({ news: this.topImageBottomTextModel.getNewsByIndex(1) })
              }

              GridCol({
                span: {
                  md: Constants.GRID_COLUMN_SPAN[1],
                  lg: Constants.GRID_COLUMN_SPAN[0]
                }
              }) {
                TopImageBottomText({ news: this.topImageBottomTextModel.getNewsByIndex(2) })
              }
            }
            .margin({ top: $r('app.float.grid_gutter') })

            GridRow({
              columns: Constants.GRID_ALL_COLUMNS,
              gutter: $r('app.float.grid_gutter')
            }) {
              GridCol({
                span: {
                  md: Constants.GRID_COLUMN_SPAN[1],
                  lg: Constants.GRID_COLUMN_SPAN[0]
                }
              }) {
                Column() {
                  LeftTextRightImageBgGray({ news: this.imageAndTextViewModel.getNewsByIndex(4) })
                  LeftTextRightImageBgGray({ news: this.imageAndTextViewModel.getNewsByIndex(5) })
                }
                .height($r('app.float.cards_height2'))
                .justifyContent(FlexAlign.SpaceBetween)
              }

              GridCol({
                span: {
                  md: Constants.GRID_COLUMN_SPAN[1],
                  lg: Constants.GRID_COLUMN_SPAN[0]
                }
              }) {
                Column() {
                  LeftTextRightImageBgGray({ news: this.imageAndTextViewModel.getNewsByIndex(6) })
                  LeftTextRightImageBgGray({ news: this.imageAndTextViewModel.getNewsByIndex(7) })
                }
                .height($r('app.float.cards_height2'))
                .justifyContent(FlexAlign.SpaceBetween)

              }

              GridCol({
                span: {
                  md: Constants.GRID_COLUMN_SPAN[2],
                  lg: Constants.GRID_COLUMN_SPAN[1]
                }
              }) {
                VideoCard({ news: this.videoModel.getNewsByIndex(1) })
              }
            }.margin({ top: $r('app.float.grid_gutter') })
          }
          .height(Constants.LAYOUT_AUTO)
        }
      }
      .layoutWeight(1)
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
      .backgroundColor($r('sys.color.background_primary'))
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
    }
    .padding({ top: this.statusBarHeight, bottom: this.navIndicatorHeight })
    .backgroundColor($r('sys.color.background_primary'))
    .hideTitleBar(true)
    .title('', { backgroundColor: $r('sys.color.background_primary') })
  }
}