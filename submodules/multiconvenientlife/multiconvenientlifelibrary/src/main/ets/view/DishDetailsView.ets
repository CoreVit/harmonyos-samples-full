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
import { BreakpointType } from '../utils/BreakpointSystem';
import { DishDetail, DishDetailList } from '../viewmodel/DishDetailViewModel';
import { DishComments } from './DishComments';

@Component
export struct DishDetailsView {
  @StorageLink(CommonConstants.LIFE_PREFIX + 'currentBreakpoint') currentBreakpoint: string =
    BreakpointConstants.BREAKPOINT_LG;
  @StorageLink(CommonConstants.LIFE_PREFIX + 'naviIndicatorHeight') naviIndicatorHeight: number = 0;
  @StorageLink(CommonConstants.LIFE_PREFIX + 'statusBarHeight') statusBarHeight: number = 0;
  @StorageLink(CommonConstants.LIFE_PREFIX + 'payWidth') payWidth: Length = 0;
  @Consume(CommonConstants.LIFE_PREFIX + 'ifShowSides') ifShowSides: boolean;
  private dishDetailList: DishDetail[] = new DishDetailList().getDishDetailList();

  build() {
    Column() {
      Column() {
        Row() {
          Button()
            .backgroundColor($r('sys.color.comp_divider'))
            .size({ width: 48, height: 20 })
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
          bottom: $r('app.float.dish_bottom')
        })
        .border({
          color: $r('app.color.five_white'),
          width: {
            bottom: $r('app.float.dish_border_bottom')
          }
        })

        ForEach(this.dishDetailList, () => {
          Row() {
            Button()
              .backgroundColor($r('sys.color.comp_background_secondary'))
              .size(({ width: 49, height: 16 }))
              .margin({ right: 24 })
            Button()
              .backgroundColor($r('sys.color.comp_background_secondary'))
              .height(16)
              .layoutWeight(1)
              .constraintSize({
                minWidth: 100,
                maxWidth: 217
              })
          }
          .alignItems(VerticalAlign.Top)
          .padding({
            left: this.ifShowSides ?
              new BreakpointType({
                sm: $r('app.float.twelves_padding'), md: $r('app.float.twelves_padding'),
                lg: $r('app.float.dish_lg')
              }).getValue(this.currentBreakpoint) :
              new BreakpointType({
                sm: $r('app.float.twelves_padding'), md: $r('app.float.padding_small'),
                lg: $r('app.float.twelves_padding')
              }).getValue(this.currentBreakpoint),
            right: $r('app.float.twelves_padding'),
            bottom: $r('app.float.dish_bottom'),
            top: $r('app.float.twelves_padding')
          })
          .justifyContent(FlexAlign.Start)
          .width(CommonConstants.FULL_PERCENT)
        }, (item: DishDetail, index: number) => index + JSON.stringify(item))
      }
      .margin({
        left: this.ifShowSides ? new BreakpointType({
          sm: $r('app.float.padding_small'), md: $r('app.float.padding_small'),
          lg: $r('app.float.common_padding')
        }).getValue(this.currentBreakpoint) :
          new BreakpointType({
            sm: $r('app.float.padding_small'), md: $r('app.float.common_padding'),
            lg: $r('app.float.zero_padding')
          }).getValue(this.currentBreakpoint),
        right: this.ifShowSides ? new BreakpointType({
          sm: $r('app.float.padding_small'), md: $r('app.float.padding_small'),
          lg: $r('app.float.common_padding')
        }).getValue(this.currentBreakpoint) :
          new BreakpointType({
            sm: $r('app.float.padding_small'), md: $r('app.float.common_padding'),
            lg: $r('app.float.common_padding')
          }).getValue(this.currentBreakpoint),
        bottom: $r('app.float.twelves_padding'),
        top: !this.ifShowSides && (this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ||
          this.currentBreakpoint === BreakpointConstants.BREAKPOINT_XL) ? this.statusBarHeight : 0
      })
      .backgroundColor($r('sys.color.comp_background_primary'))
      .borderRadius($r('app.float.dish_border'))
      .padding({
        top: $r('app.float.twelves_padding'),
        bottom: $r('app.float.twelves_padding')
      })

      if (this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ||
        this.currentBreakpoint === BreakpointConstants.BREAKPOINT_XL) {
        DishComments()
      }
    }
    .onAreaChange((oldArea: Area, newArea: Area) => {
      this.payWidth = newArea.width;
    })
  }
}