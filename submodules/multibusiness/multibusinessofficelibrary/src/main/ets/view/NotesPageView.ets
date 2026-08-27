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

import { NotesContentView } from '../component/NotesContentView';
import { SideBarContentView } from '../component/SideBarContentView';
import { CommonConstants } from '../constants/CommonConstants';
import { NotesData } from '../model/NotesData';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';

@Builder
export function NotesPageBuilder() {
  NotesPageView()
}

@Component
struct Item {
  @StorageLink(CommonConstants.KEY_MAIN_BREAKPOINT) breakPoint: string = BreakpointTypeEnum.SM;
  @StorageLink('listItemSelect') listItemSelect: string = CommonConstants.NOTES_SCHEDULE[0][0].title;
  @StorageLink('arrowStatus') arrowStatus: boolean = true;
  @Consume(CommonConstants.KEY_NOTES_PATH_STACK) notesPageInfos: NavPathStack;
  public listDate: Array<NotesData> = [];

  build() {
    Column() {
      ForEach(this.listDate, (item: NotesData) => {
        Flex({ direction: FlexDirection.Row }) {
          Column() {
            Row()
              .width($r('app.float.notes_list_icon'))
              .height($r('app.float.position_x'))
              .backgroundColor(item.color)
              .margin({ top: $r('app.float.common_line_height') })
          }
          .width($r('app.float.width_or_margin'))
          .margin({
            left: $r('app.float.width_or_margin'),
            right: $r('app.float.notes_c_margin')
          })
          .height(CommonConstants.FULL_PERCENT)

          Column() {
            Row() {
              Text('                          ')
                .backgroundColor($r('sys.color.comp_background_tertiary'))
                .borderRadius($r('sys.float.corner_radius_level6'))
            }
            .width(CommonConstants.FULL_PERCENT)
            .height($r('app.float.common_height_line_height'))
            .margin({
              top: $r('app.float.position_x'),
              bottom: $r('app.float.common_margin_width')
            })

            Text('  ')
              .width('100%')
              .backgroundColor($r('sys.color.comp_background_tertiary'))
              .borderRadius($r('sys.float.corner_radius_level6'))
          }
          .flexGrow(1)
          .height(CommonConstants.FULL_PERCENT)

          if (item.imageSrc) {
            Column() {
              Image(item.imageSrc)
                .width($r('app.float.notes_list_image'))
                .height($r('app.float.notes_list_image'))
                .borderRadius($r('sys.float.corner_radius_level5'))
                .margin({ top: $r('app.float.margin_common') })
            }
            .width($r('app.float.notes_list_image'))
            .height(CommonConstants.FULL_PERCENT)
            .margin({ left: CommonConstants.COMMON_MARGIN })
          }
        }
        .backgroundColor($r('sys.color.comp_background_primary'))
        .borderRadius($r('sys.float.corner_radius_level10'))
        .margin({ bottom: $r('app.float.margin_top') })
        .padding({ right: CommonConstants.COMMON_MARGIN })
        .width(CommonConstants.FULL_PERCENT)
        .height($r('app.float.notes_list_height'))
        .onClick(() => {
          this.arrowStatus = this.breakPoint === BreakpointTypeEnum.SM ? false : true;
          this.notesPageInfos.replacePath({ name: item.title }, true);
          this.listItemSelect = item.title;
        })
      }, (item: NotesData) => JSON.stringify(item))
    }.margin({
      left: new BreakpointType({
        sm: $r('sys.float.padding_level8'),
        md: $r('sys.float.padding_level12'),
        lg: $r('sys.float.padding_level16')
      }).getValue(this.breakPoint),
      right: new BreakpointType({
        sm: $r('sys.float.padding_level8'),
        md: $r('sys.float.padding_level12'),
        lg: $r('sys.float.padding_level16')
      }).getValue(this.breakPoint)
    })
  }
}

@Component
export struct NotesPageView {
  @StorageLink(CommonConstants.KEY_MAIN_BREAKPOINT) @Watch('handleBreakPointChange') breakPoint: string =
    BreakpointTypeEnum.SM;
  @StorageLink(CommonConstants.KEY_MAIN_NAV_INDICATOR_HEIGHT) naviIndicatorHeight: number = 0;
  @StorageLink('notesNavMode') notesNavMode: NavigationMode =
    this.breakPoint === BreakpointTypeEnum.SM ? NavigationMode.Stack : NavigationMode.Split;
  @StorageLink('arrowStatus') arrowStatus: boolean = true;
  @StorageLink('sideBarStatusNotes') sideBarStatus: boolean =
    this.breakPoint === BreakpointTypeEnum.LG || this.breakPoint === BreakpointTypeEnum.XL ? true : false;
  @StorageLink(CommonConstants.KEY_MAIN_WINDOW_HEIGHT) windowSizeHeight: number = CommonConstants.COMMON_ZERO;
  @Provide(CommonConstants.KEY_NOTES_PATH_STACK) notesPageInfos: NavPathStack = new NavPathStack();
  @Consume(CommonConstants.KEY_MAIN_PATH_STACK) mainPageInfos: NavPathStack;
  @State singleSelectCapsuleSelectedIndexes: number[] = [0];

  handleBreakPointChange() {
    if (this.breakPoint === BreakpointTypeEnum.SM) {
      this.notesNavMode = NavigationMode.Stack;
      if (this.arrowStatus) {
        this.notesPageInfos.pop();
      }
    } else {
      this.notesPageInfos.replacePath({ name: CommonConstants.NOTES_SCHEDULE[0][0].title });
      if (this.arrowStatus) {
        this.notesNavMode = NavigationMode.Split;
      } else {
        this.notesNavMode = NavigationMode.Stack;
      }
      if (this.breakPoint === BreakpointTypeEnum.LG || this.breakPoint === BreakpointTypeEnum.XL) {
        this.sideBarStatus = true;
      }
    }
  }

  @Builder
  pageMap(name: string) {
    NavDestination() {
      NotesContentView({ itemsTitle: name })
    }
    .hideTitleBar(true)
    .onBackPressed(() => {
      if (this.notesNavMode === NavigationMode.Split) {
        return false;
      } else {
        if (this.breakPoint === BreakpointTypeEnum.SM) {
          this.notesPageInfos.pop();
        } else {
          this.notesNavMode = NavigationMode.Split;
        }
        this.arrowStatus = true;
        if (this.breakPoint === BreakpointTypeEnum.LG || this.breakPoint === BreakpointTypeEnum.XL) {
          this.sideBarStatus = true;
        }
        return true;
      }
    })
  }

  aboutToAppear(): void {
    if (this.breakPoint !== BreakpointTypeEnum.SM) {
      this.notesPageInfos.replacePath({ name: CommonConstants.NOTES_SCHEDULE[0][0].title });
    }
  }

  build() {
    NavDestination() {
      Navigation(this.notesPageInfos) {
        Stack({ alignContent: Alignment.TopStart }) {
          SideBarContainer(this.breakPoint === BreakpointTypeEnum.LG ||
            this.breakPoint === BreakpointTypeEnum.XL ? SideBarContainerType.Embed :
            SideBarContainerType.Overlay) {
            SideBarContentView()
            Stack() {
              Column() {
                if (this.breakPoint !== BreakpointTypeEnum.LG && this.breakPoint !== BreakpointTypeEnum.XL) {
                  Stack({ alignContent: Alignment.End }) {
                    Button({ type: ButtonType.Circle }) {
                      SymbolGlyph($r('sys.symbol.more'))
                        .fontColor([$r('sys.color.font_primary')])
                        .fontSize($r('app.float.symbol_font_size'))
                        .margin($r('app.float.margin_common'))
                    }
                    .width($r('app.float.image_size'))
                    .height($r('app.float.image_size'))
                    .backgroundColor($r('sys.color.comp_background_tertiary'))
                    .margin({ right: CommonConstants.COMMON_MARGIN })
                  }
                  .margin({ top: $r('app.float.margin_top') })
                  .width(CommonConstants.FULL_PERCENT)
                } else {
                  Row() {
                    Column() {
                      SymbolGlyph($r('sys.symbol.plus'))
                        .fontColor([$r('sys.color.font_primary')])
                        .fontSize($r('app.float.symbol_font_size'))
                        .margin($r('app.float.margin_common'))
                    }
                    .width($r('app.float.image_size'))
                    .height($r('app.float.image_size'))
                    .borderRadius($r('sys.float.corner_radius_level10'))
                    .backgroundColor(this.breakPoint === BreakpointTypeEnum.XL ? '' :
                      $r('sys.color.comp_background_tertiary'))
                    .margin({ right: $r('app.float.margin_common') })

                    Column() {
                      SymbolGlyph($r('sys.symbol.square_grid_2x2'))
                        .fontColor([$r('sys.color.font_primary')])
                        .fontSize($r('app.float.symbol_font_size'))
                        .margin($r('app.float.margin_common'))
                    }
                    .width($r('app.float.image_size'))
                    .height($r('app.float.image_size'))
                    .borderRadius($r('sys.float.corner_radius_level10'))
                    .backgroundColor(this.breakPoint === BreakpointTypeEnum.XL ? '' :
                      $r('sys.color.comp_background_tertiary'))
                    .margin({ right: $r('app.float.margin_common') })

                    Column() {
                      SymbolGlyph($r('sys.symbol.dot_grid_2x2'))
                        .fontColor([$r('sys.color.font_primary')])
                        .fontSize($r('app.float.symbol_font_size'))
                        .margin($r('app.float.margin_common'))
                    }
                    .width($r('app.float.image_size'))
                    .height($r('app.float.image_size'))
                    .borderRadius($r('sys.float.corner_radius_level10'))
                    .backgroundColor(this.breakPoint === BreakpointTypeEnum.XL ? '' :
                      $r('sys.color.comp_background_tertiary'))
                    .margin({ right: CommonConstants.COMMON_MARGIN })
                  }
                  .margin({
                    top: $r('app.float.margin_top'),
                    bottom: $r('app.float.margin_top')
                  })
                  .justifyContent(FlexAlign.End)
                  .width(CommonConstants.FULL_PERCENT)
                }

                if (this.breakPoint !== BreakpointTypeEnum.XL) {
                  Column() {
                    Text($r('app.string.notes_list0'))
                      .fontSize($r('app.float.font_size_title'))
                      .lineHeight($r('app.float.title_line_height'))
                      .fontWeight(FontWeight.Bold)
                      .width(CommonConstants.FULL_PERCENT)
                      .margin({ top: CommonConstants.COMMON_MARGIN })
                    Text($r('app.string.notes_list1'))
                      .fontSize($r('app.float.font_size_common'))
                      .width(CommonConstants.FULL_PERCENT)
                      .fontWeight(FontWeight.Regular)
                      .lineHeight($r('app.float.common_line_height'))
                      .margin({ top: $r('app.float.common_margin_width') })
                  }
                  .width(CommonConstants.FULL_PERCENT)
                  .padding({
                    left: new BreakpointType({
                      sm: $r('sys.float.padding_level8'),
                      md: $r('sys.float.padding_level12'),
                      lg: $r('sys.float.padding_level16')
                    }).getValue(this.breakPoint),
                    right: new BreakpointType({
                      sm: $r('sys.float.padding_level8'),
                      md: $r('sys.float.padding_level12'),
                      lg: $r('sys.float.padding_level16')
                    }).getValue(this.breakPoint)
                  })
                }
                Row() {
                  Search({ value: '', placeholder: $r('app.string.notes_list2') })
                    .placeholderFont({
                      size: $r('app.float.common_font_size'),
                      weight: FontWeight.Regular
                    })
                    .textFont({
                      size: $r('app.float.common_font_size'),
                      weight: FontWeight.Regular
                    })
                    .backgroundColor($r('sys.color.comp_background_tertiary'))
                    .width(CommonConstants.FULL_PERCENT)
                    .height($r('app.float.title_line_height'))

                }
                .width(CommonConstants.FULL_PERCENT)
                .margin({ top: $r('app.float.margin_common_top') })
                .padding({
                  left: new BreakpointType({
                    sm: $r('sys.float.padding_level8'),
                    md: $r('sys.float.padding_level12'),
                    lg: $r('sys.float.padding_level16')
                  }).getValue(this.breakPoint),
                  right: new BreakpointType({
                    sm: $r('sys.float.padding_level8'),
                    md: $r('sys.float.padding_level12'),
                    lg: $r('sys.float.padding_level16')
                  }).getValue(this.breakPoint)
                })

                Scroll() {
                  Column() {
                    Row() {
                      Text($r('app.string.notes_list3'))
                        .fontSize($r('app.float.sub_title_font'))
                        .lineHeight($r('app.float.sub_title_line_height'))
                        .width(CommonConstants.FULL_PERCENT)
                        .fontWeight(FontWeight.Bold)
                    }
                    .width(CommonConstants.FULL_PERCENT)
                    .padding({
                      left: new BreakpointType({
                        sm: $r('sys.float.padding_level8'), md: $r('sys.float.padding_level12'),
                        lg: $r('sys.float.padding_level16')
                      }).getValue(this.breakPoint),
                      right: new BreakpointType({
                        sm: $r('sys.float.padding_level8'), md: $r('sys.float.padding_level12'),
                        lg: $r('sys.float.padding_level16')
                      }).getValue(this.breakPoint),
                      top: $r('app.float.line_height_or_top'),
                      bottom: $r('app.float.margin_common')
                    })

                    Item({ listDate: CommonConstants.NOTES_SCHEDULE[CommonConstants.COMMON_ZERO] })

                    Row() {
                      Text($r('app.string.notes_list4'))
                        .fontSize($r('app.float.sub_title_font'))
                        .lineHeight($r('app.float.sub_title_line_height'))
                        .width(CommonConstants.FULL_PERCENT)
                        .fontWeight(FontWeight.Bold)
                    }
                    .width(CommonConstants.FULL_PERCENT)
                    .padding({
                      left: new BreakpointType({
                        sm: $r('sys.float.padding_level8'),
                        md: $r('sys.float.padding_level12'),
                        lg: $r('sys.float.padding_level16')
                      }).getValue(this.breakPoint),
                      right: new BreakpointType({
                        sm: $r('sys.float.padding_level8'),
                        md: $r('sys.float.padding_level12'),
                        lg: $r('sys.float.padding_level16')
                      }).getValue(this.breakPoint),
                      top: $r('app.float.margin_top'),
                      bottom: $r('app.float.margin_common')
                    })

                    Item({ listDate: CommonConstants.NOTES_SCHEDULE[1] })
                  }
                  .height('auto')
                }
                .layoutWeight(1)
                .height(this.breakPoint === BreakpointTypeEnum.XL ? this.windowSizeHeight -
                CommonConstants.NOTES_TITLE_2IN1 : this.windowSizeHeight - CommonConstants.NOTES_TITLE_HEIGHT)
                .align(Alignment.Top)
                .scrollBar(BarState.Off)
              }
              .padding({
                bottom: this.naviIndicatorHeight,
                top: this.breakPoint === BreakpointTypeEnum.XL ? CommonConstants.COMMON_ZERO :
                  $r('app.float.navigation_margin_top')
              })
              .justifyContent(FlexAlign.Start)
              .height(CommonConstants.FULL_PERCENT)
              .width(CommonConstants.FULL_PERCENT)
            }
          }
          .autoHide(false)
          .controlButton(this.breakPoint === BreakpointTypeEnum.MD ? {
            top: CommonConstants.CONTROL_BUTTON_TOP + CommonConstants.PADDING_8,
            left: CommonConstants.PADDING_54 + CommonConstants.COMMON_MARGIN,
            width: CommonConstants.PADDING_24,
            height: CommonConstants.PADDING_24
          } : {
            icons: {
              hidden: this.breakPoint === BreakpointTypeEnum.XL ? $r('app.media.close_sidebar') :
                $r('app.media.close_sidebar_bg'),
              shown: this.breakPoint === BreakpointTypeEnum.XL ? $r('app.media.open_sidebar') :
                $r('app.media.open_sidebar_bg'),
              switching: this.sideBarStatus ?
                (this.breakPoint === BreakpointTypeEnum.XL ? $r('app.media.open_sidebar') :
                  $r('app.media.open_sidebar_bg')) : (this.breakPoint === BreakpointTypeEnum.XL ?
                  $r('app.media.close_sidebar') : $r('app.media.close_sidebar_bg'))
            },
            top: this.breakPoint === BreakpointTypeEnum.XL ? CommonConstants.CONTROL_NOTES_BUTTON_TOP :
              CommonConstants.CONTROL_BUTTON_TOP,
            left: (this.breakPoint === BreakpointTypeEnum.XL && this.sideBarStatus) ?
              CommonConstants.PADDING_54 + CommonConstants.CONTROL_BUTTON_LEFT :
              CommonConstants.PADDING_54 + CommonConstants.COMMON_MARGIN,
            width: CommonConstants.CONTROL_BUTTON,
            height: CommonConstants.CONTROL_BUTTON
          })
          .showSideBar(this.breakPoint === BreakpointTypeEnum.LG ||
            this.breakPoint === BreakpointTypeEnum.XL ? this.arrowStatus && this.sideBarStatus : false)
          .minSideBarWidth(this.breakPoint === BreakpointTypeEnum.LG ||
            this.breakPoint === BreakpointTypeEnum.XL ? CommonConstants.SIDEBAR_WIDTH :
            CommonConstants.NOTES_SIDEBAR_WIDTH)
          .sideBarWidth(this.breakPoint === BreakpointTypeEnum.LG ||
            this.breakPoint === BreakpointTypeEnum.XL ? CommonConstants.SIDEBAR_WIDTH :
            CommonConstants.NOTES_SIDEBAR_WIDTH)
          .maxSideBarWidth(this.breakPoint === BreakpointTypeEnum.LG ||
            this.breakPoint === BreakpointTypeEnum.XL ? CommonConstants.SIDEBAR_WIDTH :
            CommonConstants.NOTES_SIDEBAR_WIDTH)
          .onChange((value: boolean) => {
            this.sideBarStatus = value;
          })
          .height(CommonConstants.FULL_PERCENT)
          .backgroundColor($r('app.color.sidebar_color'))

          Button({ type: ButtonType.Circle }) {
            SymbolGlyph($r('sys.symbol.chevron_backward'))
              .fontColor([$r('sys.color.icon_primary')])
              .fontSize($r('sys.float.Title_M'))
          }
          .margin({
            left: ((this.breakPoint === BreakpointTypeEnum.XL) && this.sideBarStatus) ?
              CommonConstants.CONTROL_BUTTON_LEFT : CommonConstants.COMMON_MARGIN,
            top: this.breakPoint === BreakpointTypeEnum.XL ? CommonConstants.CONTROL_NOTES_BUTTON_TOP :
              CommonConstants.CONTROL_BUTTON_TOP
          })
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .height($r('app.float.image_size'))
          .aspectRatio(1)
          .onClick(() => {
            this.mainPageInfos.pop();
          })
        }
      }
      .navDestination(this.pageMap)
      .mode(this.notesNavMode)
      .backgroundColor($r('sys.color.gray_01'))
      .navBarWidth(new BreakpointType({
        sm: $r('app.float.notes_nav_bar_width'),
        md: $r('app.float.notes_nav_md_width'),
        lg: this.sideBarStatus ? CommonConstants.NOTES_NAV_BAR_WIDTH + CommonConstants.SIDEBAR_WIDTH :
          $r('app.float.notes_nav_bar_width')
      }).getValue(this.breakPoint)
      )
      .hideTitleBar(true)
    }.hideTitleBar(true)
  }
}