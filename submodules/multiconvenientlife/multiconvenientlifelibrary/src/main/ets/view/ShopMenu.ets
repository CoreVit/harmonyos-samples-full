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
import { ShopMenuData, ShopMenuItem } from '../viewmodel/ShopDisplayViewModel';
import { ShopDish } from './ShopDish';

@Component
export struct ShopMenu {
  @StorageLink(CommonConstants.LIFE_PREFIX + 'currentBreakpoint') currentBreakpoint: string =
    BreakpointConstants.BREAKPOINT_LG;
  @Consume(CommonConstants.LIFE_PREFIX + 'ifShowSides') ifShowSides: boolean;
  @Consume(CommonConstants.LIFE_PREFIX + 'ifScroll') ifScroll: boolean;
  private shopMenuList = new ShopMenuData().getMenuList();
  private scroller: Scroller = new Scroller();
  private menuClassifyList: string[] =
    ['热销', '优惠', '招牌单品', '美味双拼', '精美小吃', '新品上架', '下单必点', '加料区'];

  build() {
    Row() {
      Column() {
        ForEach(this.menuClassifyList, () => {
          Row() {
            Button()
              .backgroundColor($r('sys.color.comp_background_secondary'))
              .size({ width: 56, height: 17 })
          }
          .height(53)
        }, (item: string) => item);
      }
      .borderRadius({
        topRight: $r('app.float.enlarge_margin_left')
      })
      .height(CommonConstants.FULL_PERCENT)
      .justifyContent(FlexAlign.Start)
      .width(this.ifShowSides ? new BreakpointType({
        sm: $r('app.float.menu_width_sm'), md: $r('app.float.menu_width_md'),
        lg: $r('app.float.menu_width_lg')
      }).getValue(this.currentBreakpoint) :
        new BreakpointType({
          sm: $r('app.float.menu_width_sm'), md: $r('app.float.menu_width_lg'),
          lg: $r('app.float.menu_width_lg_show')
        }).getValue(this.currentBreakpoint))
      .backgroundColor($r('sys.color.comp_background_gray'))

      Scroll(this.scroller) {
        Column() {
          Swiper() {
            Image($r('app.media.shopBanner1'))
            Image($r('app.media.shopBanner2'))
          }
          .indicator(false)
          .itemSpace(CommonConstants.DEFAULT_SPACE)
          .displayCount(this.ifShowSides ?
            new BreakpointType({ sm: 1, md: 1, lg: 2 }).getValue(this.currentBreakpoint) :
            new BreakpointType({ sm: 1, md: 2, lg: 2 }).getValue(this.currentBreakpoint))
          .margin({
            bottom: $r('app.float.margin_twelves')
          })

          List() {
            ForEach(this.menuClassifyList, () => {
              ListItem() {
                List() {
                  ForEach(this.shopMenuList, (item: ShopMenuItem) => {
                    ShopDish({ shopMenuItem: item, showSelectButton: true })
                  }, (item: string, index: number) => item + JSON.stringify(index))
                }
                .width('auto')
                .height('auto')
              }
            }, (item: string, index: number) => item + JSON.stringify(index))
          }
          .width('auto')
          .height('auto')
        }
      }
      .onDidScroll(() => {
        this.ifScroll = true;
      })
      .onReachStart(() => {
        this.ifScroll = false;
      })
      .scrollBarWidth(0)
      .padding({
        left: $r('app.float.avatar_padding_left'),
        right: this.ifShowSides ? new BreakpointType({
          sm: $r('app.float.padding_small'), md: $r('app.float.padding_small'),
          lg: $r('app.float.common_padding')
        }).getValue(this.currentBreakpoint) :
          new BreakpointType({
            sm: $r('app.float.padding_small'), md: $r('app.float.common_padding'),
            lg: $r('app.float.common_padding')
          }).getValue(this.currentBreakpoint),
      })
      .layoutWeight(1)
      .nestedScroll({ scrollForward: NestedScrollMode.PARENT_FIRST, scrollBackward: NestedScrollMode.SELF_FIRST })
    }
    .width(CommonConstants.FULL_PERCENT)
    .padding({
      top: $r('app.float.twelves_padding')
    })
  }
}