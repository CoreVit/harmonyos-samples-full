/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { WindowInfo } from 'multivideobase';
import { MainPageConstants } from '../constants/MainPageConstants';
import TVBannerCoverListViewModel, { TVBannerCoverViewModel } from '../viewmodel/TVBannerCoverViewModel';
import { getTabIndex } from './CommonView';

@Component
export struct TVBannerView {
  @ObjectLink mainWindowInfo: WindowInfo;
  @State firstShowIndex: number = 0; // The subscript of the first banner.
  @State bannerTranslateList: Array<TranslateOptions> = []; // Component translation array.
  @State bannerZIndexList: Array<number> = []; // The zIndex for displaying images.
  @State bannerImgDataList: Array<ResourceStr> = []; // The banner image shows an array.
  @State currentCenterIndex: number = 2; // The subscript for the currently centered banner.
  @State bannerCardHeight: number = MainPageConstants.TV_BANNER_CARD_HEIGHT_CENTER;
  @State borderRadiusValue: Array<string> = []; // Array of rounded corners for the outer border of the image.
  private slipDirection: number = MainPageConstants.TV_BANNER_SWIPE_LEFT; // 0:Swipe to the left,1:Swipe to the right.
  private swiperController: SwiperController = new SwiperController();
  // Array of swiper banner image displays.
  @ObjectLink tvBannerCoverList: TVBannerCoverListViewModel;
  private scaleParamData: Array<ScaleOptions> = [
    MainPageConstants.TV_BANNER_IMAGE_SCALE_1, MainPageConstants.TV_BANNER_IMAGE_SCALE_2,
    MainPageConstants.TV_BANNER_IMAGE_SCALE_3, MainPageConstants.TV_BANNER_IMAGE_SCALE_2,
    MainPageConstants.TV_BANNER_IMAGE_SCALE_1
  ]; // Array of TV Banner scale param.

  aboutToAppear(): void {
    this.tvBannerCoverList.loadTVBannerCoverData();
    this.tvBannerCoverList.loadTVBannerScaleData();
    this.updateBannerCard();
  }

  aboutToDisappear(): void {
    this.tvBannerCoverList.clearTVBannerCoverData();
  }

  build() {
    Column() {
      // Banner layout.
      Swiper(this.swiperController) {
        ForEach(this.tvBannerCoverList.getCovers(), (item: TVBannerCoverViewModel, index: number) => {
          Stack({ alignContent: Alignment.BottomStart }) {
            Image(this.bannerImgDataList[index % this.bannerImgDataList.length])
              .height(this.getBannerCardHeight(index))
              .width(this.getBannerCardWidth(index))
              .objectFit(ImageFit.Fill)
              .focusable(true)
              .draggable(false)
              .borderRadius(16)

            Row() {
              Text(item.getTitle())
                .fontSize('16fp')
                .fontColor($r('app.color.mp_white'))
                .fontWeight(800)
              Stack() {
                Image($r('app.media.newMarkGray'))
                  .width('45vp')
                  .height('20vp')
                Text($r('app.string.Membership'))
                  .fontColor($r('app.color.mp_white'))
                  .fontSize('12vp')
              }
              .margin({
                top: '5vp',
                right: '7vp'
              })
            }
            .margin({
              bottom: '22vp'
            })
            .padding({
              left: '32vp',
              right: '32vp'
            })
            .zIndex(this.bannerZIndexList[index % this.bannerZIndexList.length] + 1)
            .translate({
              x: -(this.bannerTranslateList[index % this.bannerTranslateList.length]?.x as number || 0),
              y: 0
            })
            .justifyContent(FlexAlign.SpaceBetween)
            .width(this.getBannerCardWidth(index))
            .visibility(this.currentCenterIndex === index ? Visibility.Visible : Visibility.None)
          }
          .width(this.getBannerCardWidth(index))
          .height(this.bannerCardHeight)
          .zIndex(this.bannerZIndexList[this.getBannerSafeIndex(index)])
          .translate({
            x: (this.bannerTranslateList[this.getBannerSafeIndex(index)]?.x as number || 0) +
              this.getBannerWidthCompensation(index),
            y: this.bannerTranslateList[this.getBannerSafeIndex(index)]?.y as number || 0
          })
        }, (item: TVBannerCoverViewModel) => item.getId())
      }
      .height(this.bannerCardHeight)
      .displayCount(MainPageConstants.TV_BANNER_IMAGE_COUNT)
      .indicator(false)
      .loop(true)
      .disableSwipe(true)
      .autoPlay(true)
      .interval(MainPageConstants.TV_BANNER_AUTO_PLAY_INTERVAL)
      .effectMode(EdgeEffect.None)
      .tabIndex(getTabIndex('Banner'))
      .gesture(
        PanGesture()
          .onActionStart((event: GestureEvent) => {
            // Set the success callback for the sliding gesture recognition.
            if (event.offsetX < -MainPageConstants.TV_BANNER_SWIPE_THRESHOLD) { // Gesture: Swipe left.
              this.swiperController.showNext();
              this.slipDirection = MainPageConstants.TV_BANNER_SWIPE_LEFT; // Swipe to the left.
            } else if (event.offsetX > MainPageConstants.TV_BANNER_SWIPE_THRESHOLD) { // Gesture: Swipe right.
              this.swiperController.showPrevious();
              this.slipDirection = MainPageConstants.TV_BANNER_SWIPE_RIGHT; // Swipe to the right.
            }
          })
      )
      .onAnimationStart(() => {
        this.gestureProcess();
      })
    }
    .width('100%')
    .margin({
      top: '124vp'
    })
  }

  private updateBannerCard(): void {
    const bannerDataLength: number = this.tvBannerCoverList.getCovers().length;
    if (bannerDataLength === 0) {
      return;
    }
    let resList: number[] = [];
    // Calculate centerOffset.
    const centerOffset = Math.floor(MainPageConstants.TV_BANNER_IMAGE_COUNT / 2);
    // The current index of the center of the Banner card.
    this.currentCenterIndex = (this.firstShowIndex + centerOffset) % bannerDataLength;
    for (let showIndex = 0; showIndex < MainPageConstants.TV_BANNER_IMAGE_COUNT; showIndex++) {
      const current = this.firstShowIndex + showIndex + bannerDataLength;
      const currentIndex = current % bannerDataLength;
      resList.push(currentIndex);
    }
    let currentsCenterIndex: number = this.currentCenterIndex;
    for (let index = 0; index < bannerDataLength; index++) {
      const indexOf: number = resList.indexOf(index);
      if (indexOf !== -1) {
        const indexScale: ScaleOptions = this.scaleParamData[indexOf];
        this.tvBannerCoverList.getScales()[index] = indexScale;
        this.bannerTranslateList[index] = this.getTranslateParam(indexOf, index);
      } else {
        this.tvBannerCoverList.getScales()[index] = MainPageConstants.TV_BANNER_IMAGE_SCALE_1;
        this.bannerTranslateList[index] = this.getTranslateParam(MainPageConstants.TWO, index);
        this.bannerZIndexList[index] = MainPageConstants.TV_BANNER_DEFAULT_Z_INDEX;
      }
      this.borderRadiusValue[index] = MainPageConstants.TV_BANNER_BORDER_RADIUS_FIVE_PERCENT;
      // Determine that if the banner is a middle-sized card, display the large image; otherwise,
      // display the small image.
      this.bannerImgDataList[index] =
        currentsCenterIndex === index ? this.tvBannerCoverList.getCovers()[index].getImgHorizontal() :
          this.tvBannerCoverList.getCovers()[index].getImgVertical();
    }
    this.borderRadiusValue[this.currentCenterIndex] = MainPageConstants.TV_BANNER_BORDER_RADIUS_TWO_PERCENT;
    this.bannerZIndexList[this.currentCenterIndex] = MainPageConstants.TV_BANNER_CENTER_Z_INDEX;
  }

  private getTranslateParam(index: number, currentIndex: number): TranslateOptions {
    let res: TranslateOptions = {};
    if (index === MainPageConstants.TV_BANNER_LEFT_SIDE_INDEX) {
      res.x = -MainPageConstants.TV_BANNER_CARD_TRANSLATE_X_OFFSET;
      this.bannerZIndexList[currentIndex] = MainPageConstants.TV_BANNER_SIDE_Z_INDEX;
    } else if (index === MainPageConstants.TV_BANNER_RIGHT_SIDE_INDEX) {
      this.bannerZIndexList[currentIndex] = MainPageConstants.TV_BANNER_SIDE_Z_INDEX;
      res.x = MainPageConstants.TV_BANNER_CARD_TRANSLATE_X_OFFSET;
    } else {
      this.bannerZIndexList[currentIndex] = MainPageConstants.TV_BANNER_DEFAULT_Z_INDEX;
      res.x = 0;
    }
    // In real width/height layout mode, keep all card bottoms on same baseline.
    res.y = 0;
    return res;
  }

  private getBannerSafeIndex(index: number): number {
    const length: number = this.tvBannerCoverList.getCovers().length;
    if (length === 0) {
      return 0;
    }
    return index % length;
  }

  private getBannerScale(index: number): ScaleOptions {
    const safeIndex: number = this.getBannerSafeIndex(index);
    return this.tvBannerCoverList.getScales()[safeIndex] || { x: 1, y: 1 };
  }

  private getBannerCardWidth(index: number): number {
    return MainPageConstants.TV_BANNER_CARD_WIDTH * (this.getBannerScale(index).x || 1);
  }

  private getBannerCardHeight(index: number): number {
    return this.bannerCardHeight * (this.getBannerScale(index).y || 1);
  }

  private getBannerWidthCompensation(index: number): number {
    return (MainPageConstants.TV_BANNER_CARD_WIDTH - this.getBannerCardWidth(index)) / 2;
  }

  private slidingAnimation(): void {
    this.getUIContext().animateTo({
      duration: MainPageConstants.TV_BANNER_ANIMATION_DURATION,
      curve: Curve.Friction,
      delay: 0,
      iterations: 1,
      playMode: PlayMode.Alternate,
      expectedFrameRateRange: {
        min: MainPageConstants.TV_BANNER_FRAME_RATE_MIN,
        max: MainPageConstants.TV_BANNER_FRAME_RATE_MAX,
        expected: MainPageConstants.TV_BANNER_FRAME_RATE_EXPECTED
      }
    }, () => {
      this.updateBannerCard();
    });
  }

  private gestureProcess(): void {
    if (this.slipDirection === MainPageConstants.TV_BANNER_SWIPE_RIGHT) {
      // Swipe right with your hand.
      if (this.firstShowIndex === MainPageConstants.TV_BANNER_FIRST_INDEX) {
        this.firstShowIndex = this.tvBannerCoverList.getCovers().length;
      } else {
        this.firstShowIndex -= 1;
      }
    } else if (this.slipDirection === MainPageConstants.TV_BANNER_SWIPE_LEFT) {
      // Swipe left with your hand.
      if (this.firstShowIndex === this.tvBannerCoverList.getCovers().length) {
        this.firstShowIndex = MainPageConstants.TV_BANNER_FIRST_INDEX;
      } else {
        this.firstShowIndex += 1;
      }
    }
    this.slidingAnimation();
    this.slipDirection = MainPageConstants.TV_BANNER_SWIPE_LEFT; // Set the sliding direction to default.
  }
}