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

import { ImmersiveType, WindowInfo } from 'multitravelbase/Index';

@Component
export struct PcDecorativeToolbar {
  @ObjectLink mainWindowInfo: WindowInfo;

  private px2vp(value: number): number {
    return this.getUIContext().px2vp(value);
  }

  private getToolbarRightMargin(): number {
    let rect = this.mainWindowInfo.titleButtonRect;
    if (!rect) {
      return 0;
    }
    return rect.width + rect.right + 24;
  }

  private getToolbarTop(): number {
    let rect = this.mainWindowInfo.titleButtonRect;
    if (!rect) {
      return 0;
    }
    return rect.top + (rect.height - 28) / 2;
  }

  private shouldShow(): boolean {
    let rect = this.mainWindowInfo.titleButtonRect;
    if (!rect || this.mainWindowInfo.isImmersive === ImmersiveType.NORMAL) {
      return false;
    }
    return rect.width > 0 && rect.height > 0 && this.mainWindowInfo.windowSize.width > 0 &&
      this.px2vp(this.mainWindowInfo.windowSize.width) - this.getToolbarRightMargin() >= 160;
  }

  @Builder
  private ToolbarIcon(icon: Resource) {
    Image(icon)
      .width(16)
      .height(16)
      .objectFit(ImageFit.Contain)
  }

  build() {
    if (this.shouldShow()) {
      Row() {
        this.ToolbarIcon($r('app.media.icon_pc_toolbar1'))
        this.ToolbarIcon($r('app.media.icon_pc_toolbar2'))
        this.ToolbarIcon($r('app.media.icon_pc_toolbar3'))
        this.ToolbarIcon($r('app.media.icon_pc_toolbar4'))
      }
      .width(160)
      .height(28)
      .justifyContent(FlexAlign.SpaceEvenly)
      .backgroundColor($r('app.color.mapcontainer_toolbar_background'))
      .borderRadius(16)
      .margin({
        right: this.getToolbarRightMargin(),
        top: this.getToolbarTop()
      })
      .hitTestBehavior(HitTestMode.None)
    }
  }
}
