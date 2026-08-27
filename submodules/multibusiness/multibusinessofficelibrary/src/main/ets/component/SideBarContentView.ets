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

import { CommonConstants } from '../constants/CommonConstants';
import { BreakpointTypeEnum } from '../utils/BreakpointSystem';

@Component
export struct SideBarContentView {
  @State current: number = CommonConstants.COMMON_ZERO;
  @StorageLink(CommonConstants.KEY_MAIN_BREAKPOINT) breakPoint: string = BreakpointTypeEnum.SM;

  build() {
    Column() {
      List() {
        ListItem() {
          if (this.breakPoint === BreakpointTypeEnum.XL) {
            Row() {
              Image($r('app.media.notes'))
                .width($r('app.float.button_image_size'))
                .height($r('app.float.button_image_size'))
                .margin({ right: $r('app.float.width_or_margin') })
              Text(CommonConstants.NOTES_SIDE_BAR_TEXT[0])
                .fontSize($r('app.float.sub_title_font'))
                .lineHeight($r('app.float.text_line_height'))
                .fontWeight(FontWeight.Medium)
            }
            .margin({
              left: $r('app.float.position_x'),
              top: $r('app.float.margin_common_top')
            })
          }
        }
        .align(Alignment.Start)
        .width(CommonConstants.FULL_PERCENT)

        ListItem() {
          if (this.breakPoint === BreakpointTypeEnum.LG || this.breakPoint === BreakpointTypeEnum.XL) {
            Row() {
              Text(CommonConstants.NOTES_SIDE_BAR_TEXT[1])
                .fontSize($r('app.float.sub_title_font'))
                .lineHeight($r('app.float.text_line_height'))
                .fontWeight(FontWeight.Bold)
            }
            .width(this.breakPoint === BreakpointTypeEnum.LG || this.breakPoint === BreakpointTypeEnum.XL ?
              $r('app.float.sidebar_width_2in1') : $r('app.float.sidebar_width_not_lg'))
            .height(this.breakPoint === BreakpointTypeEnum.XL ? $r('app.float.title_line_height') :
              $r('app.float.notes_list_image'))
            .margin({
              top: this.breakPoint === BreakpointTypeEnum.XL ? $r('app.float.margin_row_top') :
                $r('app.float.memo_list_margin'),
              bottom: $r('app.float.margin_common')
            })
            .justifyContent(FlexAlign.SpaceBetween)
          }
        }

        ListItemGroup() {
          ForEach(CommonConstants.MEMO_LIST, (item: string, index: number) => {
            ListItem() {
              Column() {
                Row() {
                  SymbolGlyph(CommonConstants.MEMO_LIST_ICON[index])
                    .fontSize($r('app.float.symbol_font_size'))
                    .margin({ left: $r('app.float.margin_common') })
                    .fontColor(this.current === index ? [$r('sys.color.icon_primary')] : [$r('sys.color.font_primary')])

                  Text(item)
                    .fontSize($r('app.float.common_font_size'))
                    .margin({ left: CommonConstants.COMMON_MARGIN })
                    .lineHeight($r('app.float.line_height_common'))
                    .fontWeight(FontWeight.Medium)
                    .fontColor($r('sys.color.font_primary'))
                  Blank()
                  Row() {
                    Text(CommonConstants.MEMO_LIST_NUMBER[index])
                      .fontSize($r('app.float.font_size_common'))
                      .lineHeight($r('app.float.common_line_height'))
                      .fontWeight(FontWeight.Regular)
                      .fontColor($r('sys.color.font_secondary'))
                  }
                  .margin({ right: $r('app.float.margin_common') })
                  .justifyContent(FlexAlign.End)
                  .width($r('app.float.memo_list_number_width'))
                  .height($r('app.float.common_line_height'))
                }
                .justifyContent(FlexAlign.Center)
                .height(CommonConstants.FULL_PERCENT)
                .width(CommonConstants.FULL_PERCENT)
              }
              .backgroundColor(this.current === index ? $r('app.color.notes_sidebar_content') :
                $r('app.color.sidebar_color'))
              .padding({
                right: $r('app.float.margin_common'),
                left: $r('app.float.margin_common')
              })
              .width(this.breakPoint === BreakpointTypeEnum.LG ||
                this.breakPoint === BreakpointTypeEnum.XL ? $r('app.float.sidebar_width_2in1') :
                $r('app.float.sidebar_width'))
              .height(this.breakPoint === BreakpointTypeEnum.XL ? $r('app.float.title_line_height') :
                $r('app.float.sidebar_height_2in1'))
              .borderRadius($r('app.float.height_or_line_height'))
              .onClick(() => {
                this.current = index;
              })
            }
          }, (item: string) => item)
        }
        .margin({
          bottom: $r('app.float.notes_content_button_margin'),
          top: this.breakPoint === BreakpointTypeEnum.LG || this.breakPoint === BreakpointTypeEnum.XL ?
            CommonConstants.COMMON_ZERO : $r('app.float.memo_list_margin')
        })
        .width(this.breakPoint === BreakpointTypeEnum.LG || this.breakPoint === BreakpointTypeEnum.XL ?
          $r('app.float.sidebar_width_2in1') : $r('app.float.sidebar_width'))
        .height(this.breakPoint === BreakpointTypeEnum.XL ? $r('app.float.memo_list_height') :
          $r('app.float.sidebar_row_width'))

        ListItem() {
          Row() {
            Text(CommonConstants.NOTES_SIDE_BAR_TEXT[2])
              .fontSize($r('app.float.font_size_common'))
              .lineHeight($r('app.float.common_line_height'))
              .fontWeight(FontWeight.Regular)

            Text(CommonConstants.NOTES_SIDE_BAR_TEXT[3])
              .fontSize($r('app.float.font_size_common'))
              .lineHeight($r('app.float.common_line_height'))
              .fontColor($r('app.color.notes_sidebar_color'))
              .fontWeight(FontWeight.Medium)
          }
          .width(this.breakPoint === BreakpointTypeEnum.LG || this.breakPoint === BreakpointTypeEnum.XL ?
            $r('app.float.sidebar_row_width') : $r('app.float.sidebar_width_not_lg'))
          .height($r('app.float.sub_title_line_height'))
          .margin({ bottom: $r('app.float.margin_common') })
          .justifyContent(FlexAlign.SpaceBetween)
        }

        ListItemGroup() {
          ForEach(CommonConstants.FOLDER_LIST, (item: string, index: number) => {
            ListItem() {
              Column() {
                Row() {
                  Column() {
                    Image(CommonConstants.FOLDER_LIST_ICON[index])
                      .width($r('app.float.width_or_margin'))
                      .height($r('app.float.button_image_size'))
                  }
                  .justifyContent(FlexAlign.Center)
                  .width($r('app.float.width_or_margin'))
                  .height($r('app.float.button_image_size'))

                  Text(item)
                    .fontSize($r('app.float.common_font_size'))
                    .margin({ left: $r('app.float.notes_c_margin') })
                    .lineHeight($r('app.float.line_height_common'))
                    .fontWeight(FontWeight.Medium)
                  Blank()
                  Row() {
                    Text(CommonConstants.FOLDER_LIST_NUMBER[index])
                      .fontSize($r('app.float.font_size_common'))
                      .lineHeight($r('app.float.common_line_height'))
                      .fontWeight(FontWeight.Regular)
                      .fontColor($r('sys.color.font_secondary'))
                  }
                  .margin({ right: $r('app.float.margin_common') })
                  .justifyContent(FlexAlign.End)
                  .width($r('app.float.folder_list_number_width'))
                  .height($r('app.float.common_line_height'))
                }
                .justifyContent(FlexAlign.Center)
                .height(CommonConstants.FULL_PERCENT)
                .width(CommonConstants.FULL_PERCENT)
              }
              .backgroundColor(this.current - CommonConstants.MEMO_LIST.length === index ?
                $r('app.color.notes_sidebar_content') : $r('app.color.sidebar_color'))
              .padding({
                right: $r('app.float.margin_common'),
                left: $r('app.float.margin_common')
              })
              .width(this.breakPoint === BreakpointTypeEnum.LG ||
                this.breakPoint === BreakpointTypeEnum.XL ? $r('app.float.sidebar_width_2in1') :
                $r('app.float.sidebar_width'))
              .height(this.breakPoint === BreakpointTypeEnum.XL ? $r('app.float.title_line_height') :
                $r('app.float.sidebar_height_2in1'))
              .borderRadius($r('app.float.height_or_line_height'))
              .onClick(() => {
                this.current = index + CommonConstants.MEMO_LIST.length;
              })
            }
          }, (item: string) => item)
        }
        .margin({
          bottom: $r('app.float.notes_icon_line_height')
        })
        .width(this.breakPoint === BreakpointTypeEnum.LG || this.breakPoint === BreakpointTypeEnum.XL ?
          $r('app.float.sidebar_width_2in1') : $r('app.float.sidebar_width'))
        .height(this.breakPoint === BreakpointTypeEnum.XL ? $r('app.float.folder_list_height_2in1') :
          ('app.float.folder_list_height'))

        ListItem() {
          Row() {
            Text(CommonConstants.NOTES_SIDE_BAR_TEXT[4])
              .fontSize($r('app.float.common_font_size'))
              .fontColor($r('app.color.notes_sidebar_color'))
              .lineHeight($r('app.float.line_height_common'))
              .fontWeight(FontWeight.Medium)
          }
          .width(this.breakPoint === BreakpointTypeEnum.LG || this.breakPoint === BreakpointTypeEnum.XL ?
            $r('app.float.sidebar_row_width') : $r('app.float.sidebar_width_not_lg'))
          .height($r('app.float.line_height_common'))
          .margin({ bottom: $r('app.float.notes_sidebar_list_margin') })
          .justifyContent(this.breakPoint === BreakpointTypeEnum.XL ? FlexAlign.Center : FlexAlign.Start)
        }
      }
      .scrollBar(BarState.Off)
      .alignListItem(ListItemAlign.Center)
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
    }
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .backgroundColor($r('app.color.sidebar_color'))
    .padding({
      top: this.breakPoint === BreakpointTypeEnum.XL ? CommonConstants.COMMON_ZERO :
        $r('app.float.navigation_margin_top')
    })
  }
}