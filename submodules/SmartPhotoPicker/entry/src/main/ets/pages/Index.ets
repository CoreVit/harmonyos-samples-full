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
import { ImmersiveType, WindowUtil } from '../utils/WindowUtils';
import { CommonConstants } from '../common/CommonConstants';
import { ComponentImplPage } from '../view/ComponentImplPage';
import { InterfaceImplPage } from '../view/InterfaceImplPage';
import Logger from '../utils/Logger';

const TAG: string = '[IndexPage]';

@Entry
@Component
struct Index {
  private windowUtil?: WindowUtil = WindowUtil.getInstance();

  aboutToAppear(): void {
    if (this.windowUtil !== undefined) {
      this.windowUtil.setImmersiveType(ImmersiveType.IMMERSIVE);
    }
  }

  aboutToDisappear(): void {
    try {
      AppStorage.delete(CommonConstants.KEY_WINDOW_WIDTH);
      AppStorage.delete(CommonConstants.KEY_WIDTH_BP);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, 'Delete AppStorage data failed, error.code = ' + err.code);
    }
    if (this.windowUtil !== undefined) {
      this.windowUtil.setImmersiveType(ImmersiveType.NORMAL);
      this.windowUtil.release();
    }
  }

  build() {
    Column({ space: 16 }) {
      Scroll() {
        Column() {
          Column() {
            Text($r('app.string.title'))
              .fontSize(26)
              .fontWeight(700)
              .fontColor($r('sys.color.font_primary'))
          }
          .width(CommonConstants.FULL_PARENT)
          .height(56)
          .padding({ top: 12 })
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Start)

          ComponentImplPage()
          InterfaceImplPage()
        }
      }
      .scrollBar(BarState.Off)
      .padding({ bottom: 16 })
    }
    .width(CommonConstants.FULL_PARENT)
    .height(CommonConstants.FULL_PARENT)
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Start)
    .backgroundColor($r('sys.color.background_secondary'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .padding({
      left: 16,
      right: 16
    })
  }
}