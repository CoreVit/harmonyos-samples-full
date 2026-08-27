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

import {
  CommonConstants,
  getWindowInfoState,
  MSVDataModel,
  MSVTabs,
  MSVTextIcon,
  WindowInfo
} from 'multishortvideobase';
import { SubTabsViewModel } from '../viewmodel/SubTabsViewModel';

@ComponentV2
export struct SubTabs {
  @Local windowInfo: WindowInfo = getWindowInfoState();
  @Local data: MSVDataModel[] = [];
  @Consumer('isDark') isDark: boolean = false;

  aboutToAppear(): void {
    this.data = new SubTabsViewModel().getSubTabsData();
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Row() {
        Row() {
          MSVTextIcon({ src: $r('app.media.ic_search'), iconSize: 24 })
        }
        .width(40)
        .aspectRatio(1)
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#19ffffff')
        .borderRadius(CommonConstants.HALF_PERCENT)
      }
      .height(56)
      .alignItems(VerticalAlign.Center)
      .margin({ right: 16 })
      .zIndex(1)
      .visibility(this.windowInfo.widthBp === WidthBreakpoint.WIDTH_XS ||
        (this.windowInfo.widthBp === WidthBreakpoint.WIDTH_SM &&
          this.windowInfo.heightBp === HeightBreakpoint.HEIGHT_MD) ? Visibility.None : Visibility.Visible)

      MSVTabs({
        data: this.data,
        useFloating: false,
        index: 1,
        showBarUnderline: true,
        isDark: this.isDark,
        barFontsize: 15
      })
    }
  }
}