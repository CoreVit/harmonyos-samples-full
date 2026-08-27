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

@Reusable
@Component
export struct GraphicTextSwiper {
  @StorageLink(CommonConstants.LIFE_PREFIX + 'currentBreakpoint') currentBreakpoint: string =
    BreakpointConstants.BREAKPOINT_LG;
  @Consume(CommonConstants.LIFE_PREFIX + 'upDownStructure') upDownStructure: boolean;
  @Consume(CommonConstants.LIFE_PREFIX + 'showSideBar') showSideBar: boolean;
  @Consume(CommonConstants.LIFE_PREFIX + 'isFullScreen') isFullScreen: boolean;
  @Consume(CommonConstants.LIFE_PREFIX + 'fullImageIndex') fullImageIndex: number;
  @Consume(CommonConstants.LIFE_PREFIX + 'imgList') imgList: Array<Resource>;
  @Link swiperHeight: number;
  @Link swiperMargin: number;
  @Link swiperItemSpace: number;
  private swiperController: SwiperController = new SwiperController()

  aboutToAppear(): void {
    this.swiperController.changeIndex(this.fullImageIndex);
  };

  aboutToReuse(): void {
    this.swiperController.changeIndex(this.fullImageIndex);
  };

  build() {
    Column() {
      Swiper(this.swiperController) {
        ForEach(this.imgList, (item: Resource, index: number) => {
          Column() {
            Image(item)
              .width('100%')
              .borderRadius(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM ? 0 :
                $r('app.float.image_border'))
              .height(CommonConstants.FULL_PERCENT)
              .onClick(() => {
                this.getUIContext().animateTo({
                  duration: CommonConstants.ANIMATE_DURATION,
                  curve: Curve.Friction
                }, () => {
                  this.isFullScreen = true;
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
                      this.isFullScreen = true;
                      this.fullImageIndex = index;
                    });
                  })
              )
          }
        }, (item: string) => item);
      }
      .layoutWeight(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM ||
        (this.currentBreakpoint === BreakpointConstants.BREAKPOINT_MD && this.upDownStructure) ? 0 : 1)
      .height(this.upDownStructure ?
        new BreakpointType({
          sm: CommonConstants.TEXT_SWIPER_HEIGHT, md: JSON.stringify(this.swiperHeight),
          lg: JSON.stringify(this.swiperHeight)
        }).getValue(this.currentBreakpoint) :
        new BreakpointType({
          sm: CommonConstants.TEXT_SWIPER_HEIGHT, md: CommonConstants.SELF_ADAPTING,
          lg: CommonConstants.SELF_ADAPTING
        }).getValue(this.currentBreakpoint))
      .width((this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ||
        this.currentBreakpoint === BreakpointConstants.BREAKPOINT_XL) && !this.showSideBar ? '400vp' :
        this.currentBreakpoint === BreakpointConstants.BREAKPOINT_MD && this.upDownStructure ?
          CommonConstants.FULL_PERCENT : CommonConstants.SELF_ADAPTING)
      .displayCount(1)
      .displayMode(SwiperDisplayMode.STRETCH)
      .prevMargin(this.upDownStructure && this.currentBreakpoint === BreakpointConstants.BREAKPOINT_MD ?
        this.swiperMargin : 0)
      .nextMargin(this.upDownStructure && this.currentBreakpoint === BreakpointConstants.BREAKPOINT_MD ?
        this.swiperMargin : 0)
      .itemSpace(this.upDownStructure && this.currentBreakpoint === BreakpointConstants.BREAKPOINT_MD ?
        this.swiperItemSpace : 0)
      .cachedCount(4)
      .indicator(false)
      .index($$this.fullImageIndex)
      .geometryTransition(CommonConstants.GRAPHIC_GEOMETRY_ID + this.fullImageIndex)
      .transition(TransitionEffect.OPACITY)
      .onChange((index) => {
        this.fullImageIndex = index;
      })

      Row() {
        ForEach(this.imgList, (index: number) => {
          Row() {
          }
          .width(this.fullImageIndex === index ? $r('app.float.img_list_width') : $r('app.float.img_choose_width'))
          .height(8)
          .backgroundColor(this.fullImageIndex === index ?
            $r('app.color.swiper_img_background') : $r('app.color.swiper_choose_background'))
          .margin({
            left: $r('app.float.five_margin'),
            right: $r('app.float.five_margin')
          })
          .borderRadius($r('app.float.add_cart_border'))
        }, (item: string) => item);
      }
      .margin({
        top: $r('app.float.swiper_margin_top'),
        bottom: $r('app.float.swiper_margin_bottom')
      })
      .justifyContent(FlexAlign.Center)
    }
    .padding({
      top: this.upDownStructure ? $r('app.float.padding_small') : new BreakpointType({
        sm: $r('app.float.padding_small'),
        md: $r('app.float.swiper_padding_md'), lg: $r('app.float.padding_small')
      }).getValue(this.currentBreakpoint),
      left: this.upDownStructure ? new BreakpointType({
        sm: $r('app.float.zero_padding'), md: $r('app.float.zero_padding'),
        lg: $r('app.float.padding_header')
      }).getValue(this.currentBreakpoint) :
        new BreakpointType({
          sm: $r('app.float.zero_padding'),
          md: $r('app.float.common_padding'),
          lg: $r('app.float.padding_header')
        })
          .getValue(this.currentBreakpoint),
      right: this.upDownStructure ? new BreakpointType({
        sm: $r('app.float.zero_padding'), md: $r('app.float.zero_padding'),
        lg: $r('app.float.padding_header')
      }).getValue(this.currentBreakpoint) :
        new BreakpointType({
          sm: $r('app.float.zero_padding'),
          md: $r('app.float.common_padding'),
          lg: $r('app.float.padding_header')
        })
          .getValue(this.currentBreakpoint),
    })
    .width((this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ||
      this.currentBreakpoint === BreakpointConstants.BREAKPOINT_XL) && !this.showSideBar ?
      CommonConstants.SEVENTY_PERCENT : CommonConstants.FULL_PERCENT)
  }
}