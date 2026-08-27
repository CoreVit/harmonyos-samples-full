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

import CommonConstants from '../../../common/CommonConstants';
import { PhotoItem } from './MyComponent';

@Builder
export function ShowLargeImageWithGesturePageTwoBuilder() {
  ShowLargeImageWithGesturePageTwo();
}

@Component
struct ShowLargeImageWithGesturePageTwo {
  @StorageProp(CommonConstants.KEY_PREFIX_BREAKPOINT) @Watch('cpChangged') currentBreakpoint: string = '';
  @State selectedIndex: number = 0;
  private pageInfo: NavPathStack = new NavPathStack();
  private swiperController: SwiperController = new SwiperController();
  private imageRatioData: number[] = [2772 / 2080, 1706 / 1280, 3648 / 2736, 3648 / 2736, 1280 / 720,
    1280 / 1706, 2772 / 2080, 2081 / 2775, 2772 / 2080];
  private uiContext: UIContext = this.getUIContext();
  @State hasChangedImageSize: boolean = false;
  @State itemWidth: number =
    this.currentBreakpoint === 'sm' ? CommonConstants.SMALL_SCREEN_IMAGE_SIZE : CommonConstants.OTHER_SCREEN_IMAGE_SIZE;

  aboutToAppear(): void {
    for (let i = 0; i < 9; i++) {
      this.bigImageData[i] = i;
    }
  }

  private onIndexChange: (index: number) => void = (_index: number) => {
  }
  private backToFirstPage: () => void = () => {
    this.uiContext.animateTo({
      duration: 300,
      curve: Curve.EaseIn,
    }, () => {
      this.onFirstPageShow?.();
      this.pageInfo.pop(false);
    })
  }
  private onFirstPageShow: () => void = () => {
  };
  private bigImageData: number[] = [];

  cpChangged(): void {
    this.itemWidth = this.currentBreakpoint === 'sm' ? CommonConstants.SMALL_SCREEN_IMAGE_SIZE :
      CommonConstants.OTHER_SCREEN_IMAGE_SIZE;
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.TopStart }) {
        Swiper(this.swiperController) {
          ForEach(this.bigImageData, (item: number) => {
            PhotoItem({
              imageWidth: this.itemWidth,
              imageHeight: this.itemWidth / this.imageRatioData[item],
              imageUrl: 'app.media.img_' + JSON.stringify(item % 9),
              backToFirstPage: this.backToFirstPage,
              needReset: this.hasChangedImageSize
            })
          }, (item: string) => item)
        }
        .transition(TransitionEffect.opacity(0.99))
        .width('100%')
        .height('100%')
        .clip(false)
        .index(this.selectedIndex)
        .onChange((index: number) => {
          this.selectedIndex = index;
          this.onIndexChange?.(index);
          this.hasChangedImageSize = !this.hasChangedImageSize;
        })
        .onAnimationStart((_: number, targetIndex: number) => {
          this.onIndexChange?.(targetIndex);
        })
        .indicator(false)

        Row() {
          Button({ type: ButtonType.Circle }) {
            SymbolGlyph($r('sys.symbol.chevron_backward'))
              .fontColor([$r('sys.color.icon_on_primary')])
              .fontSize($r('sys.float.Title_M'))
          }
          .height(40)
          .aspectRatio(1)
          .backgroundColor('#19FFFFFF')
          .onClick(() => this.backToFirstPage())
        }
        .width('100%')
        .height(56)
        .padding({
          left: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
            $r('sys.float.padding_level12') :
            $r('sys.float.padding_level16'),
          right: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
            $r('sys.float.padding_level12') :
            $r('sys.float.padding_level16'),
        })
        .margin({ top: 46 })
      }
    }
    .width('100%')
    .height('100%')
    .mode(NavDestinationMode.DIALOG)
    .expandSafeArea([SafeAreaType.SYSTEM])
    .onReady((context: NavDestinationContext) => {
      this.pageInfo = context.pathStack;
      let param = context.pathInfo?.param as Record<string, Object>;
      if (param === undefined) {
        return;
      }
      let selectedIndex: number = param['selectedIndex'] as number;
      if (selectedIndex < 0 || selectedIndex >= this.bigImageData.length) {
        selectedIndex = 0;
      }
      this.selectedIndex = selectedIndex;
      if (typeof param['onIndexChange'] === 'function') {
        this.onIndexChange = param['onIndexChange'] as (index: number) => void;
      }
      if (typeof param['onBackToFirstPage'] === 'function') {
        this.onFirstPageShow = param['onBackToFirstPage'] as () => void;
      }
    })
    .hideTitleBar(true)
    .onBackPressed(() => {
      this.backToFirstPage();
      return true;
    })
    .transition(TransitionEffect.opacity(0.99))
  }
}