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

import { BreakpointConstants } from '../constants/BreakpointConstants';
import { CommonConstants } from '../constants/CommonConstants';
import { DishDetailConstants } from '../constants/DishDetailConstants';
import { BreakpointType } from '../utils/BreakpointSystem';
import { CommentsData, CommentsDataList } from '../viewmodel/DishDetailViewModel';

@Component
export struct DishComments {
  @StorageLink(CommonConstants.LIFE_PREFIX + 'currentBreakpoint') currentBreakpoint: string =
    BreakpointConstants.BREAKPOINT_LG;
  @Consume(CommonConstants.LIFE_PREFIX + 'ifShowSides') ifShowSides: boolean;
  private commentsDataList: CommentsData[] = new CommentsDataList().getCommentsDataList();

  build() {
    Column() {
      Row() {
        Button()
          .size({ width: 48, height: 20 })
          .backgroundColor($r('sys.color.comp_divider'))
        Blank()
        Button()
          .size({ width: 48, height: 20 })
          .backgroundColor($r('sys.color.comp_divider'))
      }
      .width(CommonConstants.FULL_PERCENT)
      .justifyContent(FlexAlign.Start)
      .padding({
        left: this.ifShowSides ? new BreakpointType({
          sm: $r('app.float.twelves_padding'), md: $r('app.float.twelves_padding'),
          lg: $r('app.float.dish_lg')
        }).getValue(this.currentBreakpoint) :
          new BreakpointType({
            sm: $r('app.float.twelves_padding'), md: $r('app.float.padding_small'),
            lg: $r('app.float.twelves_padding')
          }).getValue(this.currentBreakpoint),
        right: this.ifShowSides ? new BreakpointType({
          sm: $r('app.float.twelves_padding'), md: $r('app.float.twelves_padding'),
          lg: $r('app.float.dish_lg')
        }).getValue(this.currentBreakpoint) :
          new BreakpointType({
            sm: $r('app.float.twelves_padding'), md: $r('app.float.padding_small'),
            lg: $r('app.float.twelves_padding')
          }).getValue(this.currentBreakpoint),
        top: $r('app.float.twelves_padding'),
        bottom: $r('app.float.dish_bottom')
      })
      .border({
        color: $r('app.color.five_white'),
        width: {
          bottom: $r('app.float.dish_border_bottom')
        }
      })

      Row() {
        ForEach(DishDetailConstants.COMMENT_FILTERING_LIST, () => {
          Button()
            .size({ width: 56, height: 14 })
            .backgroundColor($r('sys.color.ohos_id_color_alert'))
            .opacity(0.1)
            .margin({
              right: $r('app.float.filtering_margin_right')
            })
        }, (index: number) => JSON.stringify(index))
      }
      .width(CommonConstants.FULL_PERCENT)
      .justifyContent(FlexAlign.Start)
      .padding({
        left: this.ifShowSides ? new BreakpointType({
          sm: $r('app.float.twelves_padding'), md: $r('app.float.twelves_padding'),
          lg: $r('app.float.dish_lg')
        }).getValue(this.currentBreakpoint) :
          new BreakpointType({
            sm: $r('app.float.twelves_padding'), md: $r('app.float.padding_small'),
            lg: $r('app.float.twelves_padding')
          }).getValue(this.currentBreakpoint),
        bottom: $r('app.float.twelves_padding'),
        top: $r('app.float.twelves_padding')
      })

      List() {
        ForEach(this.commentsDataList, (item: CommentsData, index: number) => {
          if (index < ((this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ||
            this.currentBreakpoint === BreakpointConstants.BREAKPOINT_XL) && !this.ifShowSides ?
            CommonConstants.DISH_LG_INDEX : CommonConstants.DISH_INDEX)) {
            ListItem() {
              Row() {
                Image(item.getAvatar())
                  .width($r('app.float.avatar_width'))
                  .borderRadius($r('app.float.avatar_border'))
                  .aspectRatio(1)
                Column() {
                  Button()
                    .size({ width: 64, height: 14 })
                    .backgroundColor($r('sys.color.comp_background_secondary'))
                    .margin({
                      bottom: $r('app.float.avatar_margin_bottom')
                    })
                  Button()
                    .size({ width: '100%', height: 14 })
                    .backgroundColor($r('sys.color.comp_background_secondary'))
                    .margin({
                      bottom: $r('app.float.text_margin_bottom')
                    })
                  Button()
                    .size({ width: 28, height: 14 })
                    .backgroundColor($r('sys.color.comp_background_secondary'))
                    .margin({
                      bottom: $r('app.float.date_margin_bottom')
                    })
                }
                .constraintSize({
                  minWidth: 100,
                  maxWidth: 228
                })
                .layoutWeight(1)
                .padding({
                  left: $r('app.float.avatar_padding_left')
                })
                .alignItems(HorizontalAlign.Start)
              }
              .alignItems(VerticalAlign.Top)
            }
          }
        }, (index: number) => JSON.stringify(index))
      }
      .width('auto')
      .height('auto')
      .scrollBarWidth(0)
      .layoutWeight((this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ||
        this.currentBreakpoint === BreakpointConstants.BREAKPOINT_XL) && !this.ifShowSides ? 1 : 0)
      .padding({
        left: this.ifShowSides ? new BreakpointType({
          sm: $r('app.float.twelves_padding'), md: $r('app.float.twelves_padding'),
          lg: $r('app.float.dish_lg')
        }).getValue(this.currentBreakpoint) :
          new BreakpointType({
            sm: $r('app.float.twelves_padding'), md: $r('app.float.padding_small'),
            lg: $r('app.float.twelves_padding')
          }).getValue(this.currentBreakpoint),
        bottom: $r('app.float.dish_bottom'),
        top: $r('app.float.twelves_padding')
      })

      Row() {
        Text($r('app.string.view_all_reviews'))
          .fontColor($r('app.color.sixty_black'))
          .fontSize($r('app.float.reviews_font'))
        Image($r('app.media.icon_more'))
          .width($r('app.float.more_width'))
      }
      .height($r('app.float.view_height'))
    }
    .margin({
      left: this.ifShowSides ? new BreakpointType({
        sm: $r('app.float.margin_small'), md: $r('app.float.margin_small'),
        lg: $r('app.float.common_margin')
      }).getValue(this.currentBreakpoint) :
        new BreakpointType({
          sm: $r('app.float.margin_small'), md: $r('app.float.common_margin'),
          lg: $r('app.float.zero_margin')
        }).getValue(this.currentBreakpoint),
      right: this.ifShowSides ? new BreakpointType({
        sm: $r('app.float.margin_small'), md: $r('app.float.margin_small'),
        lg: $r('app.float.common_margin')
      }).getValue(this.currentBreakpoint) :
        new BreakpointType({
          sm: $r('app.float.margin_small'), md: $r('app.float.common_margin'),
          lg: $r('app.float.common_margin')
        }).getValue(this.currentBreakpoint),
      bottom: $r('app.float.margin_twelves')
    })
    .borderRadius($r('app.float.dish_border'))
    .backgroundColor($r('sys.color.comp_background_primary'))
  }
}