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

import { display } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { CommonConstants, Logger, WindowInfo, WindowUtil } from 'multivideobase';
import { MainPageConstants } from '../constants/MainPageConstants';
import { FeaturedContent } from './FeaturedContent';
import { VideoContent } from './VideoContent';
import { CommunityContent } from './CommunityContent';

const TAG = '[MainPageView]';

@Component
export struct MainPageView {
  @Consume('pageInfo') pageInfo: NavPathStack;
  @ObjectLink @Watch('mainWindowInfoChange') mainWindowInfo: WindowInfo;
  @StorageLink(CommonConstants.WINDOW_UTIL) windowUtil: WindowUtil | undefined = undefined;
  @Consume('currentTopIndex') currentTopIndex: number = 0;
  @Link scrollHeight: number;
  @Link bottomBarHeight: number;
  @Link hdsTabsHeight: number;
  @Link hdsTabsOpacity: number;
  @Link hdsTabsAvoidHeight: number;
  // The current vertical sliding distance of the list.
  @State currentYOffset: number = 0;
  @State currentIndex: number = 0;
  @State bottomAvoidHeight: number = this.getUIContext().px2vp(this.mainWindowInfo.avoidSystem?.bottomRect.height);
  private isAnimating: boolean = false;
  private scroller: Scroller = new Scroller();
  private sideScroller: Scroller = new Scroller();
  private isHiding: boolean = false;
  callback: Callback<display.FoldStatus> = (data: display.FoldStatus) => {
    if (data === display.FoldStatus.FOLD_STATUS_EXPANDED || data === display.FoldStatus.FOLD_STATUS_FOLDED) {
      if (this.currentTopIndex === 2) {
        this.sideScroller.scrollToIndex(this.currentIndex);
      } else {
        this.scroller.scrollToIndex(this.currentIndex);
      }
    }
    Logger.info(TAG, 'Listening enabled.');
  };

  /**
   * If mainWindowInfo changes, change the home page style.
   */
  mainWindowInfoChange(): void {
    this.bottomAvoidHeight = this.getUIContext().px2vp(this.mainWindowInfo.avoidSystem?.bottomRect.height);
    this.bottomBarHeight = this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM &&
      this.mainWindowInfo.heightBp <= HeightBreakpoint.HEIGHT_MD ?
      MainPageConstants.BOTTOM_TAB_BAR_HEIGHT_SM + this.bottomAvoidHeight :
      MainPageConstants.BOTTOM_TAB_BAR_HEIGHT + this.bottomAvoidHeight;
    this.hdsTabsHeight = 56;
    this.hdsTabsAvoidHeight =
      this.getUIContext().px2vp(this.mainWindowInfo.avoidNavigationIndicator?.bottomRect.height) || 16;
    this.hdsTabsOpacity = 1;
  }

  aboutToAppear(): void {
    // Set fold status change listen.
    try {
      display.on('foldStatusChange', this.callback);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to update fold status, errCode = ${err.code}, errMessage = ${err.message}.`);
    }
    if (this.windowUtil) {
      try {
        this.windowUtil.mainWindow.setDecorButtonStyle({ buttonIconSize: MainPageConstants.DECOR_BUTTON_ICON_SIZE });
        this.windowUtil.mainWindow.setWindowDecorHeight(MainPageConstants.DECOR_WINDOW_HEIGHT);
      } catch (error) {
        let err = error as BusinessError;
        Logger.error(TAG, `Failed to set DecorButtonStyle, errCode = ${err.code}, errMessage = ${err.message}.`);
      }
    }
    // Initial home page style.
    this.mainWindowInfoChange();
  }

  aboutToDisappear(): void {
    try {
      display.off('foldStatusChange', this.callback);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to off fold status, errCode = ${err.code}, errMessage = ${err.message}.`);
    }
  }

  build() {
    this.MainPageScrollContent()
  }

  getBottomPadding() {
    return this.hdsTabsHeight + this.hdsTabsAvoidHeight;
  }

  /**
   * Scrollable content area containing tab-specific content (Featured, Video, Community).
   */
  @Builder
  MainPageScrollContent() {
    Scroll(this.scroller) {
      if (this.currentTopIndex === 0) {
        // Featured Content Page
        FeaturedContent({
          mainWindowInfo: this.mainWindowInfo,
          hdsTabsHeight: this.hdsTabsHeight,
          hdsTabsAvoidHeight: this.hdsTabsAvoidHeight
        })
      } else if (this.currentTopIndex === 1) {
        // Video Content Page
        VideoContent({
          mainWindowInfo: this.mainWindowInfo,
          hdsTabsHeight: this.hdsTabsHeight,
          hdsTabsAvoidHeight: this.hdsTabsAvoidHeight
        })
      } else if (this.currentTopIndex === 2) {
        // Community Content Page
        CommunityContent({
          mainWindowInfo: this.mainWindowInfo,
          hdsTabsHeight: this.hdsTabsHeight,
          hdsTabsAvoidHeight: this.hdsTabsAvoidHeight
        })
      } else {
        Column()
      }
    }
    .layoutWeight(1)
    .scrollBar(BarState.Off)
    .onScrollFrameBegin((offset: number) => {
      // Obtains the sliding offset on the y axis during sliding.
      this.scrollHeight = this.scroller.currentOffset().yOffset;
      if (this.mainWindowInfo.widthBp > WidthBreakpoint.WIDTH_SM ||
        this.mainWindowInfo.heightBp > HeightBreakpoint.HEIGHT_MD) {
        return { offsetRemain: offset };
      }
      if (offset > 0) {
        this.currentYOffset += offset;
        if (this.currentYOffset <= MainPageConstants.SCROLL_BAR_HIDE_THRESHOLD) {
          this.bottomBarHeight =
            this.bottomBarHeight * (1 - this.currentYOffset / MainPageConstants.SCROLL_BAR_HIDE_THRESHOLD);
          this.hdsTabsHeight =
            this.hdsTabsHeight * (1 - this.currentYOffset / MainPageConstants.SCROLL_BAR_HIDE_THRESHOLD);
          this.hdsTabsAvoidHeight =
            this.hdsTabsAvoidHeight * (1 - this.currentYOffset / MainPageConstants.SCROLL_BAR_HIDE_THRESHOLD);
          this.hdsTabsOpacity = 1 - this.currentYOffset / MainPageConstants.SCROLL_BAR_HIDE_THRESHOLD;
        } else {
          this.bottomBarHeight = 0;
          this.hdsTabsHeight = 0;
          this.hdsTabsAvoidHeight = 0;
          this.hdsTabsOpacity = 0;
        }
        this.isHiding = true;
      }
      if (offset < 0 && this.isHiding && !this.isAnimating) {
        this.isAnimating = true;
        this.getUIContext().animateTo({
          duration: MainPageConstants.BAR_RESTORE_ANIMATION_DURATION
        }, () => {
          this.bottomBarHeight = this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM &&
            this.mainWindowInfo.heightBp <= HeightBreakpoint.HEIGHT_MD ?
            MainPageConstants.BOTTOM_TAB_BAR_HEIGHT_SM + this.bottomAvoidHeight :
            MainPageConstants.BOTTOM_TAB_BAR_HEIGHT + this.bottomAvoidHeight;
          this.hdsTabsHeight = 56;
          this.hdsTabsAvoidHeight =
            this.getUIContext().px2vp(this.mainWindowInfo.avoidNavigationIndicator?.bottomRect.height) || 16;
          this.hdsTabsOpacity = 1;
          this.currentYOffset = 0;
          this.isHiding = false;
          this.isAnimating = false;
        });
      }
      return { offsetRemain: offset };
    })
  }
}

