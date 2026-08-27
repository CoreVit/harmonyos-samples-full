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

import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import CommonConstants from '../../common/CommonConstants';
import Logger from '../../utils/Logger';

const TAG = '[DetailPageContent]';

@Component
export struct DetailPageContent {
  @Prop pageInfos: NavPathStack;
  @Prop indexValue: number;
  @Prop sharedComponentId: string | undefined = undefined;
  @StorageProp(CommonConstants.KEY_PREFIX_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageProp(CommonConstants.KEY_PREFIX_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  @StorageProp(CommonConstants.KEY_PREFIX_NAVIGATOR_SCREEN_WIDTH) screenWidth: number = 0;
  @StorageProp(CommonConstants.KEY_PREFIX_NAVIGATOR_SCREEN_HEIGHT) screenHeight: number = 0;
  @State isWidthLayout: boolean = true;
  public onBackPressed: () => void = () => {
  };
  private windowClass: window.Window | undefined = undefined;
  private uiContext: UIContext = this.getUIContext();
  private windowSizeCallback: Callback<window.Size> = (size) => {
    this.changeWidthLayout(size.width,
      (size.height - this.statusBarHeight - this.navigatorBarHeight -
        this.uiContext.vp2px(CommonConstants.NAV_TOP_HEIGHT)));
  };
  private pageDisappearFlag: boolean = false;

  @Builder
  MyTitleBuilder() {
    Row() {
      Button({ type: ButtonType.Circle }) {
        SymbolGlyph($r('sys.symbol.chevron_backward'))
          .fontColor([$r('sys.color.icon_primary')])
          .fontSize($r('sys.float.Title_M'))
      }
      .height(40)
      .aspectRatio(1)
      .backgroundColor($r('sys.color.comp_background_tertiary'))
      .onClick(() => {
        this.onBackPressed();
      })

      Text($r('app.string.card_title'))
        .margin({ left: $r('sys.float.padding_level4') })
        .font({ size: 20, weight: 700 })
        .fontColor($r('sys.color.font_primary'))
    }
    .padding({
      left: $r('sys.float.padding_level8'),
      right: $r('sys.float.padding_level8'),

    })
    .clip(true)
    .width('100%')
    .height(CommonConstants.NAV_TOP_HEIGHT)
  }

  aboutToAppear(): void {
    this.changeWidthLayout(this.uiContext.vp2px(this.screenWidth),
      (this.uiContext.vp2px(this.screenHeight - CommonConstants.NAV_TOP_HEIGHT) - this.statusBarHeight -
        this.navigatorBarHeight));
    this.registerWindowSizeChange();
  }

  aboutToDisappear(): void {
    try {
      this.pageDisappearFlag = true;
      this.windowClass?.off('windowSizeChange', this.windowSizeCallback);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG,
        `Failed to unregister windowSizeChange. Cause code: ${err.code}, message: ${err.message}`);
    }
  }

  private registerWindowSizeChange(): void {
    try {
      window.getLastWindow(this.uiContext.getHostContext()).then((windowClass: window.Window) => {
        if (windowClass === undefined) {
          Logger.error(TAG, `MainWindowClass is undefined`);
          return;
        }
        if (!this.pageDisappearFlag) {
          this.windowClass = windowClass;
          this.windowClass.on('windowSizeChange', this.windowSizeCallback);
        }
      });
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `Failed to register windowSizeChange. Cause code: ${err.code}, message: ${err.message}`);
    }
  }

  private changeWidthLayout(width: number, height: number): void {
    if (width > height) {
      this.isWidthLayout = false;
    } else {
      this.isWidthLayout = true;
    }
  }

  build() {
    Column() {
      this.MyTitleBuilder()
      Column() {
        Image($r(`app.media.img_${(this.indexValue % 6)}`))
          .size(this.isWidthLayout ? { width: '70%', height: undefined } : { width: undefined, height: '80%' })
          .objectFit(ImageFit.Contain)
        // .id(this.sharedComponentId)

        Text($r('app.string.content'))
          .width('100%')
          .textAlign(TextAlign.Center)
          .margin({
            top: $r('sys.float.padding_level5'),
          })
      }
      .width('100%')
      .id(this.sharedComponentId)
    }
    .padding({
      top: this.statusBarHeight,
      bottom: this.navigatorBarHeight
    })
    .width('100%')
    .height('100%')
  }
}