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

class DirectoryItem {
  public title: ResourceStr = '';
  public uri: string | Resource = '';
  public id: string = '';
}

@Component
export struct MultiBusinessOfficeView {
  @StorageLink(CommonConstants.KEY_MAIN_BREAKPOINT) breakPoint: string = BreakpointTypeEnum.SM;
  @Provide(CommonConstants.KEY_MAIN_PATH_STACK) pathStack: NavPathStack = new NavPathStack();
  private title: string | Resource = $r('app.string.entrances0');
  private directory: DirectoryItem[] = [
    {
      title: $r('app.string.title_list0'),
      uri: $r('app.media.notes'),
      id: 'NotesPage'
    },
    {
      title: $r('app.string.title_list1'),
      uri: $r('app.media.calendar'),
      id: 'CalendarPage'
    }
  ];

  build() {
    Navigation(this.pathStack) {
      Column() {
        Text(this.title)
          .fontSize($r('app.float.symbol_font_size'))
          .lineHeight($r('app.float.line_height_or_top'))
          .fontWeight(FontWeight.Medium)
          .margin({
            top: this.breakPoint === BreakpointTypeEnum.SM ? $r('app.float.margin_top_title') :
              $r('app.float.title_margin_top')
          })

        Text($r('app.string.entrances1'))
          .fontSize($r('app.float.common_font_size'))
          .lineHeight($r('app.float.line_height_common'))
          .fontWeight(FontWeight.Medium)
          .margin({
            top: $r('app.float.margin_common'),
            bottom: $r('app.float.margin_top')
          })

        List() {
          ForEach(this.directory, (item: DirectoryItem, index: number) => {
            ListItem() {
              Column() {
                Image(item.uri)
                  .width($r('app.float.image_size_entry'))
                  .height($r('app.float.image_size_entry'))
                  .margin({
                    top: this.breakPoint === BreakpointTypeEnum.SM ? $r('app.float.margin_entry_sm_top') :
                      $r('app.float.margin_entry_top'),
                    bottom: this.breakPoint === BreakpointTypeEnum.SM ? $r('app.float.margin_top') :
                      $r('app.float.margin_bottom')
                  })

                Text(item.title)
                  .fontColor($r('sys.color.font_tertiary'))
                  .fontSize($r('app.float.common_font_size'))
                  .lineHeight($r('app.float.line_height_common'))
                  .fontWeight(FontWeight.Medium)
                  .margin({
                    bottom: this.breakPoint === BreakpointTypeEnum.SM ? $r('app.float.margin_entry_title') :
                      $r('app.float.margin_entry_title_top')
                  })
              }
              .width(this.breakPoint === BreakpointTypeEnum.SM ? $r('app.float.index_list_item_width_sm') :
                $r('app.float.index_list_item_width'))
              .height(this.breakPoint === BreakpointTypeEnum.SM ? $r('app.float.index_list_item_height_sm') :
                $r('app.float.index_list_item_height'))
              .borderRadius($r('app.float.border_radius_entry'))
              .backgroundColor($r('sys.color.comp_background_primary'))
              .onClick(() => {
                this.pathStack.pushPathByName(item.id, null);
              })
            }
            .width(this.breakPoint === BreakpointTypeEnum.SM ? CommonConstants.FULL_PERCENT :
              $r('app.float.index_list_item_width'))
            .height(this.breakPoint === BreakpointTypeEnum.SM ? $r('app.float.index_list_item_height_sm') :
              $r('app.float.index_list_item_height'))
            .margin({
              top: $r('app.float.margin_common_top'),
              right: this.breakPoint === BreakpointTypeEnum.SM ? CommonConstants.COMMON_ZERO :
                $r('app.float.list_item_margin_right')
            })
          }, (item: DirectoryItem) => JSON.stringify(item))
        }
        .width(this.breakPoint === BreakpointTypeEnum.SM ? CommonConstants.FULL_PERCENT :
          $r('app.float.trip_schedule_height'))
        .height(this.breakPoint === BreakpointTypeEnum.SM ? $r('app.float.home_card_height') :
          $r('app.float.home_card_height_small'))
        .padding({
          left: this.breakPoint === BreakpointTypeEnum.SM ? CommonConstants.COMMON_ZERO :
            $r('app.float.list_item_margin_right')
        })
        .listDirection(this.breakPoint === BreakpointTypeEnum.SM ? Axis.Vertical : Axis.Horizontal)
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
      .backgroundColor($r('sys.color.gray_01'))
      .backgroundImageSize({
        height: CommonConstants.FULL_PERCENT,
        width: CommonConstants.FULL_PERCENT
      })
    }
    .mode(NavigationMode.Stack)
    .hideTitleBar(true)
  }
}