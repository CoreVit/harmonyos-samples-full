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
import Constants from '../constants/Constants';

@Component
export struct MainPageComponent {
  @StorageProp(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageProp(Constants.KEY_NAV_INDICATOR_HEIGHT) navIndicatorHeight: number = 0;
  @StorageProp(Constants.KEY_BREAKPOINT) docScanBreakpoint: WidthBreakpoint = WidthBreakpoint.WIDTH_SM;
  @Provide(Constants.KEY_PATH_STACK) pathStack: NavPathStack = new NavPathStack();
  @State docImageUris: string[] = [];
  @State result: ResourceStr = '';

  build() {
    Navigation(this.pathStack) {
      Column() {
        Button($r('app.string.button_scan'), { stateEffect: true, type: ButtonType.Capsule })
          .fontWeight(FontWeight.Medium)
          .width(this.docScanBreakpoint === WidthBreakpoint.WIDTH_SM ? '100%' : $r('app.float.button_width'))
          .height($r('sys.float.ohos_id_button_height'))
          .margin({
            bottom: this.navIndicatorHeight === 0 ? $r('app.float.avoid_bottom') : $r('sys.float.padding_level8')
          })
          .onClick(() => {
            this.pathStack.pushPath({ name: 'documentScanner' }, false);
          })
      }
      .padding({
        left: this.docScanBreakpoint === WidthBreakpoint.WIDTH_SM ? $r('sys.float.padding_level8') :
        $r('sys.float.padding_level0'),
        right: this.docScanBreakpoint === WidthBreakpoint.WIDTH_SM ? $r('sys.float.padding_level8') :
        $r('sys.float.padding_level0')
      })
      .justifyContent(FlexAlign.End)
      .width('100%')
      .height('100%')
    }
    .padding({
      bottom: this.navIndicatorHeight
    })
    .backgroundColor($r('sys.color.background_secondary'))
    .title($r('app.string.main_title'))
    .mode(NavigationMode.Stack)
  }
}