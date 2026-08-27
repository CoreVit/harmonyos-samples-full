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
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';

@Component
export struct NotesContentView {
  @StorageLink(CommonConstants.KEY_MAIN_BREAKPOINT) breakPoint: string = BreakpointTypeEnum.SM;
  @StorageLink('notesNavMode') notesNavMode: NavigationMode = NavigationMode.Split;
  @StorageLink('arrowStatus') arrowStatus: boolean = true;
  @StorageLink('sideBarStatusNotes') sideBarStatus: boolean = true;
  @Consume(CommonConstants.KEY_NOTES_PATH_STACK) notesPageInfos: NavPathStack;
  @State hoverBgcolor: Resource | string = '';
  public itemsTitle: string = '';

  build() {
    Column() {
      Row() {
        Column() {
          SymbolGlyph(this.arrowStatus && this.breakPoint !== BreakpointTypeEnum.SM ?
            $r('sys.symbol.arrow_up_left_and_arrow_down_right') : $r('sys.symbol.arrow_down_right_and_arrow_up_left'))
            .fontSize($r('app.float.symbol_font_size'))
            .margin($r('app.float.margin_common'))
            .fontColor([$r('sys.color.font_primary')])
        }
        .width($r('app.float.image_size'))
        .height($r('app.float.image_size'))
        .borderRadius(this.breakPoint === BreakpointTypeEnum.XL ? $r('app.float.margin_common') :
          $r('sys.float.corner_radius_level10'))
        .backgroundColor(this.breakPoint === BreakpointTypeEnum.XL ? this.hoverBgcolor :
          $r('sys.color.comp_background_tertiary'))
        .onClick(() => {
          if (this.breakPoint === BreakpointTypeEnum.SM) {
            this.notesPageInfos.pop();
            this.arrowStatus = true;
          } else {
            if (this.arrowStatus) {
              this.notesNavMode = NavigationMode.Stack;
              this.arrowStatus = false;
            } else {
              this.arrowStatus = true;
              this.notesNavMode = NavigationMode.Split;
            }
          }
          if (this.breakPoint === BreakpointTypeEnum.LG ||
            this.breakPoint === BreakpointTypeEnum.XL) {
            this.sideBarStatus = true;
          }
        })
        .onHover((isHover: boolean) => {
          if (isHover) {
            this.hoverBgcolor = $r('sys.color.interactive_hover');
          } else {
            this.hoverBgcolor = '';
          }
        })

        if (this.breakPoint === BreakpointTypeEnum.LG || this.breakPoint === BreakpointTypeEnum.XL) {
          Blank()
          Column() {
            SymbolGlyph($r('sys.symbol.share'))
              .fontSize($r('app.float.symbol_font_size'))
              .margin($r('app.float.margin_common'))
              .fontColor([$r('sys.color.font_primary')])
          }
          .width($r('app.float.image_size'))
          .height($r('app.float.image_size'))
          .borderRadius($r('sys.float.corner_radius_level10'))
          .backgroundColor(this.breakPoint === BreakpointTypeEnum.XL ? '' : $r('sys.color.comp_background_tertiary'))
          .margin({ right: $r('app.float.margin_common') })

          Column() {
            SymbolGlyph($r('sys.symbol.star'))
              .fontSize($r('app.float.symbol_font_size'))
              .margin($r('app.float.margin_common'))
              .fontColor([$r('sys.color.font_primary')])
          }
          .width($r('app.float.image_size'))
          .height($r('app.float.image_size'))
          .borderRadius($r('sys.float.corner_radius_level10'))
          .backgroundColor(this.breakPoint === BreakpointTypeEnum.XL ? '' : $r('app.color.background_gray'))
          .margin({ right: $r('app.float.margin_common') })

          Column() {
            SymbolGlyph($r('sys.symbol.ohos_trash'))
              .fontSize($r('app.float.symbol_font_size'))
              .margin($r('app.float.margin_common'))
              .fontColor([$r('sys.color.font_primary')])
          }
          .width($r('app.float.image_size'))
          .height($r('app.float.image_size'))
          .borderRadius($r('sys.float.corner_radius_level10'))
          .backgroundColor(this.breakPoint === BreakpointTypeEnum.XL ? '' : $r('sys.color.comp_background_tertiary'))
          .margin({ right: $r('app.float.margin_common') })

          Column() {
            SymbolGlyph($r('sys.symbol.dot_grid_2x2'))
              .fontSize($r('app.float.symbol_font_size'))
              .margin($r('app.float.margin_common'))
              .fontColor([$r('sys.color.font_primary')])
          }
          .width($r('app.float.image_size'))
          .height($r('app.float.image_size'))
          .borderRadius($r('sys.float.corner_radius_level10'))
          .backgroundColor(this.breakPoint === BreakpointTypeEnum.XL ? '' : $r('sys.color.comp_background_tertiary'))
          .margin({
            right: this.breakPoint === BreakpointTypeEnum.XL ? $r('app.float.margin_right') :
              new BreakpointType({
                sm: $r('sys.float.padding_level8'),
                md: $r('sys.float.padding_level12'),
                lg: $r('sys.float.padding_level16')
              }).getValue(this.breakPoint),
          })
        }
      }
      .height($r('app.float.top_nav_height'))
      .width(CommonConstants.FULL_PERCENT)
      .padding({
        left: new BreakpointType({
          sm: $r('sys.float.padding_level8'),
          md: $r('sys.float.padding_level12'),
          lg: $r('sys.float.padding_level16')
        }).getValue(this.breakPoint),
        top: $r('sys.float.padding_level16'),
        bottom: new BreakpointType({
          sm: $r('sys.float.padding_level8'),
          md: $r('sys.float.padding_level12'),
          lg: $r('sys.float.padding_level16')
        }).getValue(this.breakPoint)
      })

      Row() {
        Text('                                                    ')
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .borderRadius($r('sys.float.corner_radius_level6'))
          .lineHeight($r('app.float.line_height_or_top'))
      }
      .width(CommonConstants.FULL_PERCENT)
      .padding({
        top: $r('sys.float.padding_level6'),
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
      .constraintSize({ maxWidth: $r('app.float.notes_content_max_width') })

      Row() {
        Text('                          ')
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .borderRadius($r('sys.float.corner_radius_level6'))
      }
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
        bottom: $r('app.float.margin_bottom'),
        top: $r('app.float.margin_common')
      })
      .width(CommonConstants.FULL_PERCENT)
      .constraintSize({ maxWidth: $r('app.float.notes_content_max_width') })

      Row() {
        Column() {
          Text('                          ')
            .backgroundColor($r('sys.color.comp_background_tertiary'))
            .borderRadius($r('sys.float.corner_radius_level6'))
            .width('100%')
            .margin({ bottom: $r('app.float.margin_common') })
          Text('                          ')
            .backgroundColor($r('sys.color.comp_background_tertiary'))
            .borderRadius($r('sys.float.corner_radius_level6'))
            .width('100%')
            .margin({ bottom: $r('app.float.margin_common') })
          Text('                          ')
            .backgroundColor($r('sys.color.comp_background_tertiary'))
            .borderRadius($r('sys.float.corner_radius_level6'))
            .width('100%')
            .margin({ bottom: $r('app.float.margin_common') })
        }
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
        .width(CommonConstants.FULL_PERCENT)
      }
      .width(CommonConstants.FULL_PERCENT)
      .constraintSize({ maxWidth: $r('app.float.notes_content_max_width') })

      Row() {
        Image($r('app.media.notes_image'))
          .width(CommonConstants.FULL_PERCENT)
          .objectFit(ImageFit.Contain)
          .constraintSize({ maxWidth: $r('app.float.notes_image_max_width') })
      }
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
        bottom: $r('app.float.margin_common')
      })
      .width(CommonConstants.FULL_PERCENT)
      .constraintSize({ maxWidth: $r('app.float.notes_content_max_width') })

      Blank()

      if (this.breakPoint !== BreakpointTypeEnum.LG) {
        Row() {
          Column() {
            SymbolGlyph($r('sys.symbol.share'))
              .fontSize($r('app.float.symbol_font_size'))
              .fontColor([$r('sys.color.font_primary')])
            Text($r('app.string.notes_content0'))
              .fontSize($r('app.float.notes_content_font'))
              .lineHeight($r('app.float.notes_icon_line_height'))
              .fontWeight(FontWeight.Medium)
              .margin({ top: $r('app.float.notes_c_margin') })
          }

          Column() {
            SymbolGlyph($r('sys.symbol.star'))
              .fontSize($r('app.float.symbol_font_size'))
              .fontColor([$r('sys.color.font_primary')])
            Text($r('app.string.notes_content1'))
              .fontSize($r('app.float.notes_content_font'))
              .lineHeight($r('app.float.notes_icon_line_height'))
              .fontWeight(FontWeight.Medium)
              .margin({ top: $r('app.float.notes_c_margin') })
          }

          Column() {
            SymbolGlyph($r('sys.symbol.ohos_trash'))
              .fontSize($r('app.float.symbol_font_size'))
              .fontColor([$r('sys.color.font_primary')])
            Text($r('app.string.notes_content2'))
              .fontSize($r('app.float.notes_content_font'))
              .lineHeight($r('app.float.notes_icon_line_height'))
              .fontWeight(FontWeight.Medium)
              .margin({ top: $r('app.float.notes_c_margin') })
          }

          Column() {
            SymbolGlyph($r('sys.symbol.square_grid_2x2'))
              .fontSize($r('app.float.symbol_font_size'))
              .fontColor([$r('sys.color.font_primary')])
            Text($r('app.string.notes_content3'))
              .fontSize($r('app.float.notes_content_font'))
              .lineHeight($r('app.float.notes_icon_line_height'))
              .fontWeight(FontWeight.Medium)
              .margin({ top: $r('app.float.notes_c_margin') })
          }
        }
        .margin({ bottom: $r('app.float.notes_content_button_margin') })
        .justifyContent(FlexAlign.SpaceAround)
        .width(CommonConstants.FULL_PERCENT)
      }
    }
    .padding({
      top: this.breakPoint === BreakpointTypeEnum.XL ? CommonConstants.COMMON_ZERO :
        $r('app.float.navigation_margin_top')
    })
    .justifyContent(FlexAlign.Start)
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
  }
}