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

import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { BreakpointConstants } from '../constants/BreakpointConstants';
import { CommonConstants } from '../constants/CommonConstants';
import { BreakpointType } from '../utils/BreakpointSystem';
import Logger from '../utils/Logger';
import { GraphicTextComments } from '../view/GraphicTextComments';
import { GraphicTextDescriptions } from '../view/GraphicTextDescriptions';
import { GraphicTextFooter } from '../view/GraphicTextFooter';
import { GraphicTextHeader } from '../view/GraphicTextHeader';
import { GraphicTextSwiper } from '../view/GraphicTextSwiper';

@Builder
export function GraphicTextBuilder() {
  GraphicText();
}

const TAG: string = '[GraphicText]';

@Component
export struct GraphicText {
  @StorageLink(CommonConstants.LIFE_PREFIX + 'currentBreakpoint') @Watch('breakpointChange') currentBreakpoint: string =
    BreakpointConstants.BREAKPOINT_LG;
  @StorageLink(CommonConstants.LIFE_PREFIX + 'naviIndicatorHeight') naviIndicatorHeight: number = 0;
  @StorageLink(CommonConstants.LIFE_PREFIX + 'statusBarHeight') statusBarHeight: number = 0;
  @State headerColor: ResourceColor = $r('sys.color.background_secondary');
  @State headerOpacity: number = 1;
  @State isShowHeader: boolean = true;
  @Provide(CommonConstants.LIFE_PREFIX + 'upDownStructure') upDownStructure: boolean = true;
  @Provide(CommonConstants.LIFE_PREFIX + 'showSideBar') showSideBar: boolean = false;
  @Provide(CommonConstants.LIFE_PREFIX + 'isFullScreen') @Watch('isFullScreenChange') isFullScreen: boolean = false;
  @Provide(CommonConstants.LIFE_PREFIX + 'fullImageIndex') fullImageIndex: number = 0;
  @Provide(CommonConstants.LIFE_PREFIX + 'imgList') imgList: Array<Resource> =
    [$r('app.media.xq1_img'), $r('app.media.xq2_img'), $r('app.media.xq3_img'), $r('app.media.xq4_img')];
  @State swiperHeight: number = CommonConstants.SWIPER_HEIGHT;
  @State swiperMargin: number = CommonConstants.SWIPER_MARGIN;
  @State swiperItemSpace: number = CommonConstants.SWIPER_ITEM_SPACE;
  @State isSliding: boolean = false;
  pathStack: NavPathStack = new NavPathStack();
  private mainScroller: Scroller = new Scroller();

  isFullScreenChange() {
    window.getLastWindow(this.getUIContext().getHostContext()).then(async (windowStage: window.Window) => {
      try {
        if (this.isFullScreen) {
          windowStage.setWindowSystemBarEnable([]);
        } else {
          windowStage.setWindowSystemBarEnable(['status', 'navigation']);
        }
      } catch (err) {
        Logger.error(TAG, `Failed to set window system bar. Cause: ${err.message}`);
      }
    }).catch((err: BusinessError) => {
      Logger.error(TAG, `Failed to get Last window. Cause: ${err.message}`);
    });
  }

  breakpointChange() {
    if (this.isFullScreen) {
      this.isFullScreen = false;
    }
  }

  build() {
    NavDestination() {
      SideBarContainer(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ||
        this.currentBreakpoint === BreakpointConstants.BREAKPOINT_XL ? SideBarContainerType.Embed :
        SideBarContainerType.Overlay) {
        Column() {
          GraphicTextComments()
        }

        Stack() {
          if (this.currentBreakpoint === BreakpointConstants.BREAKPOINT_MD) {
            Column() {
              Stack() {
                Scroll(this.mainScroller) {
                  GridRow({
                    columns: {
                      sm: BreakpointConstants.GRID_ROW_COLUMNS[5],
                      md: BreakpointConstants.GRID_ROW_COLUMNS[6],
                      lg: BreakpointConstants.GRID_ROW_COLUMNS[0]
                    }
                  }) {
                    GridCol({
                      span: {
                        sm: BreakpointConstants.GRID_COLUMN_SPANS[0],
                        md: this.upDownStructure ? BreakpointConstants.GRID_COLUMN_SPANS[5] :
                          BreakpointConstants.GRID_COLUMN_SPANS[1],
                        lg: BreakpointConstants.GRID_COLUMN_SPANS[0]
                      }
                    }) {
                      Column() {
                        GraphicTextSwiper({
                          swiperHeight: this.swiperHeight,
                          swiperMargin: this.swiperMargin,
                          swiperItemSpace: this.swiperItemSpace
                        })
                          .layoutWeight(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ||
                            this.currentBreakpoint === BreakpointConstants.BREAKPOINT_XL ||
                            (this.currentBreakpoint === BreakpointConstants.BREAKPOINT_MD && !this.upDownStructure) ?
                            1 : 0)
                        GraphicTextFooter()
                          .visibility(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ||
                            this.currentBreakpoint === BreakpointConstants.BREAKPOINT_XL ||
                            (this.currentBreakpoint === BreakpointConstants.BREAKPOINT_MD && !this.upDownStructure) ?
                            Visibility.Visible : Visibility.None)
                      }
                      .height(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM ||
                        this.currentBreakpoint === BreakpointConstants.BREAKPOINT_MD ?
                        CommonConstants.SELF_ADAPTING : CommonConstants.FULL_PERCENT)
                    }

                    GridCol({
                      span: {
                        sm: BreakpointConstants.GRID_COLUMN_SPANS[0],
                        md: this.upDownStructure ? BreakpointConstants.GRID_COLUMN_SPANS[5] :
                          BreakpointConstants.GRID_COLUMN_SPANS[0],
                        lg: BreakpointConstants.GRID_COLUMN_SPANS[0]
                      }
                    }) {
                      Scroll() {
                        GraphicTextDescriptions()
                      }
                      .align(Alignment.Top)
                      .layoutWeight(1)
                      .width(CommonConstants.FULL_PERCENT)
                      .nestedScroll({
                        scrollForward: NestedScrollMode.PARENT_FIRST,
                        scrollBackward: NestedScrollMode.SELF_FIRST
                      })
                      .onScrollFrameBegin((offset: number) => {
                        return { offsetRemain: offset };
                      })
                    }
                    .padding({
                      top: this.upDownStructure ? 0 : $r('app.float.not_up_down_padding')
                    })
                  }
                  .height(this.upDownStructure ? CommonConstants.FULL_PERCENT : 'auto')
                  .margin({
                    top: $r('app.float.title_height')
                  })
                }
                .scrollBarWidth(0)
                .layoutWeight(1)
                .onScrollFrameBegin((offset: number) => {
                  let yOffset = this.mainScroller.currentOffset().yOffset;
                  window.getLastWindow(this.getUIContext().getHostContext())
                    .then(async (windowStage: window.Window) => {
                      try {
                        if (yOffset > CommonConstants.OFFSET_ARRAY[0]) {
                          this.isSliding = true;
                          windowStage.setWindowSystemBarEnable([]);
                        } else {
                          this.isSliding = false;
                          windowStage.setWindowSystemBarEnable(['status', 'navigation']);
                        }
                      } catch (err) {
                        Logger.error(TAG, `Failed to set window system bar. Cause: ${err.message}`);
                      }
                    })
                    .catch((err: BusinessError) => {
                      Logger.error(TAG, `Failed to get Last window. Cause: ${err.message}`);
                    });
                  if (yOffset < CommonConstants.OFFSET_ARRAY[0]) {
                    this.headerColor = $r('sys.color.background_secondary');
                    this.headerOpacity = 1;
                  } else if (yOffset < CommonConstants.OFFSET_ARRAY[1]) {
                    this.headerColor = $r('sys.color.background_secondary');
                    this.headerOpacity = 0.8;
                    this.isShowHeader = true;
                  } else if (yOffset < CommonConstants.OFFSET_ARRAY[2]) {
                    this.headerColor = $r('sys.color.background_secondary');
                    this.headerOpacity = 0.6;
                    this.isShowHeader = true;
                  } else if (yOffset < CommonConstants.OFFSET_ARRAY[3]) {
                    this.headerColor = $r('sys.color.background_secondary');
                    this.headerOpacity = 0.4;
                    this.isShowHeader = true;
                  } else if (yOffset < CommonConstants.OFFSET_ARRAY[4]) {
                    this.headerColor = $r('sys.color.background_secondary');
                    this.headerOpacity = 0.2
                    this.isShowHeader = true;
                  } else if (yOffset < CommonConstants.OFFSET_ARRAY[5]) {
                    this.headerColor = $r('sys.color.background_secondary');
                    this.headerOpacity = 0;
                    this.isShowHeader = true;
                  } else {
                    this.isShowHeader = false;
                  }
                  this.swiperHeight = CommonConstants.SWIPER_HEIGHT - yOffset * CommonConstants.HEIGHT_COEFFICIENTS;
                  this.swiperMargin = CommonConstants.SWIPER_MARGIN + yOffset * CommonConstants.MARGIN_COEFFICIENTS;
                  this.swiperItemSpace =
                    CommonConstants.SWIPER_ITEM_SPACE - yOffset * CommonConstants.MARGIN_COEFFICIENTS;
                  return { offsetRemain: offset };
                })

                GraphicTextHeader({
                  handleBackPress: () => {
                    this.pathStack.pop();
                  }
                })
                  .transition(TransitionEffect.OPACITY.animation({ duration: 0 }))
                  .backgroundColor(this.headerColor)
                  .opacity(this.headerOpacity)
                  .visibility(this.isShowHeader ? Visibility.Visible : Visibility.Hidden)
              }
              .layoutWeight(1)
              .alignContent(Alignment.Top)
              .margin({
                top: this.showSideBar ? this.statusBarHeight : 0
              })

              GraphicTextFooter()
                .visibility(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM ||
                  (this.currentBreakpoint === BreakpointConstants.BREAKPOINT_MD && this.upDownStructure) ?
                  Visibility.Visible : Visibility.None)
            }
          } else {
            Column() {
              GraphicTextHeader({
                handleBackPress: () => {
                  this.pathStack.pop();
                }
              })
                .transition(TransitionEffect.OPACITY.animation({ duration: 0 }))
              Scroll(this.mainScroller) {
                GridRow({
                  columns: {
                    sm: BreakpointConstants.GRID_ROW_COLUMNS[5],
                    md: BreakpointConstants.GRID_ROW_COLUMNS[0],
                    lg: BreakpointConstants.GRID_ROW_COLUMNS[0]
                  }
                }) {
                  GridCol({
                    span: {
                      sm: BreakpointConstants.GRID_COLUMN_SPANS[0],
                      md: this.upDownStructure ? BreakpointConstants.GRID_COLUMN_SPANS[2] :
                        BreakpointConstants.GRID_COLUMN_SPANS[0],
                      lg: BreakpointConstants.GRID_COLUMN_SPANS[0]
                    }
                  }) {
                    Column() {
                      GraphicTextSwiper({
                        swiperHeight: this.swiperHeight,
                        swiperMargin: this.swiperMargin,
                        swiperItemSpace: this.swiperItemSpace
                      })
                        .layoutWeight(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ||
                          this.currentBreakpoint === BreakpointConstants.BREAKPOINT_XL ||
                          (this.currentBreakpoint === BreakpointConstants.BREAKPOINT_MD && !this.upDownStructure) ? 1 :
                          0)
                      GraphicTextFooter()
                        .visibility(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ||
                          this.currentBreakpoint === BreakpointConstants.BREAKPOINT_XL ||
                          (this.currentBreakpoint === BreakpointConstants.BREAKPOINT_MD && !this.upDownStructure) ?
                          Visibility.Visible : Visibility.None)
                    }
                    .height(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM ||
                      (this.currentBreakpoint === BreakpointConstants.BREAKPOINT_MD && this.upDownStructure) ?
                      CommonConstants.SELF_ADAPTING : CommonConstants.FULL_PERCENT)
                  }

                  GridCol({
                    span: {
                      sm: BreakpointConstants.GRID_COLUMN_SPANS[0],
                      md: this.upDownStructure ? BreakpointConstants.GRID_COLUMN_SPANS[2] :
                        BreakpointConstants.GRID_COLUMN_SPANS[0],
                      lg: BreakpointConstants.GRID_COLUMN_SPANS[0]
                    }
                  }) {
                    Scroll() {
                      GraphicTextDescriptions()
                    }
                    .scrollBarWidth(0)
                    .align(Alignment.Top)
                    .height(this.currentBreakpoint !== BreakpointConstants.BREAKPOINT_SM ?
                      CommonConstants.FULL_PERCENT : CommonConstants.SELF_ADAPTING)
                    .width(CommonConstants.FULL_PERCENT)
                    .nestedScroll({
                      scrollForward: NestedScrollMode.SELF_FIRST,
                      scrollBackward: NestedScrollMode.SELF_FIRST
                    })
                  }
                }
              }
              .scrollBarWidth(0)
              .layoutWeight(1)

              GraphicTextFooter()
                .visibility(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM ||
                  (this.currentBreakpoint === BreakpointConstants.BREAKPOINT_MD && this.upDownStructure) ?
                  Visibility.Visible : Visibility.None)
            }
            .margin({
              top: this.showSideBar ? this.statusBarHeight : 0
            })
          }
          if (this.isFullScreen) {
            Swiper() {
              ForEach(this.imgList, (item: Resource, index: number) => {
                Column() {
                  Image(item)
                    .aspectRatio(CommonConstants.GRAPHIC_ASPECT_RATIO)
                    .geometryTransition(CommonConstants.GRAPHIC_GEOMETRY_ID)
                    .transition(TransitionEffect.OPACITY)
                    .id(CommonConstants.GRAPHIC_IMAGE_ID)
                    .onClick(() => {
                      this.getUIContext().animateTo({
                        duration: CommonConstants.ANIMATE_DURATION,
                        curve: Curve.Friction
                      }, () => {
                        this.isFullScreen = false;
                        this.fullImageIndex = index;
                      });
                    })
                    .gesture(
                      PinchGesture({ fingers: 2 })
                        .onActionUpdate(() => {
                          this.getUIContext().animateTo({
                            duration: CommonConstants.ANIMATE_DURATION,
                            curve: Curve.Friction
                          }, () => {
                            this.isFullScreen = false;
                            this.fullImageIndex = index;
                          });
                        })
                    )

                }
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Center)
                .onClick(() => {
                  this.getUIContext().animateTo({ duration: CommonConstants.DEFAULT_DURATION }, () => {
                    this.isFullScreen = false;
                  })
                })
                .backgroundColor($r('sys.color.comp_background_primary'))
                .height(CommonConstants.FULL_PERCENT)
                .width(CommonConstants.FULL_PERCENT)
              }, (item: string) => item);
            }
            .backgroundColor($r('sys.color.comp_background_primary'))
            .index($$this.fullImageIndex)
            .height(CommonConstants.FULL_PERCENT)
            .width(CommonConstants.FULL_PERCENT)
          }
        }
        .height(CommonConstants.FULL_PERCENT)
      }
      .backgroundColor($r('sys.color.background_secondary'))
      .showSideBar(this.showSideBar)
      .sideBarPosition(SideBarPosition.End)
      .showControlButton(false)
      .minSideBarWidth(new BreakpointType({
        sm: CommonConstants.FULL_PERCENT,
        md: CommonConstants.FORTY_PERCENT_STRING,
        lg: CommonConstants.THIRTY_THREE_PERCENT
      }).getValue(this.currentBreakpoint))
      .padding({
        top: this.isSliding || this.showSideBar || this.isFullScreen ? 0 : this.statusBarHeight,
        bottom: this.isFullScreen ? 0 : this.naviIndicatorHeight
      })
    }
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
    })
    .onBackPressed(() => {
      if (this.isFullScreen) {
        this.getUIContext().animateTo({ duration: CommonConstants.DEFAULT_DURATION }, () => {
          this.isFullScreen = false;
        })
        return true;
      }
      return false;
    })
  }
}