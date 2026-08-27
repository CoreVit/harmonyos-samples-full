/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import { ConfigurationConstant } from '@kit.AbilityKit';
import { Constants } from '../common/Constants';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { LiveView } from '../utils/LiveView';
import { TrafficView } from '../view/TrafficView';

@Component
export struct IndexComponent {
  @StorageLink(Constants.KEY_PREFIX + 'CurrentWidthBreakpoint') currentWidthBreakpoint: string = BreakpointTypeEnum.SM;
  @StorageLink('LiveViewColorMode') colorMode: ConfigurationConstant.ColorMode =
    AppStorage.get('LiveViewColorMode') ?? ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET;

  aboutToAppear(): void {
    LiveView.getInstance(this.getUIContext().getHostContext() as Context).createLiveView();
  }

  build() {
    Stack() {
      Image(new BreakpointType({
        sm: this.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT ? $r('app.media.ic_map') :
          $r('app.media.ic_map_dark'),
        md: this.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT ? $r('app.media.ic_map_md') :
          $r('app.media.ic_map_md_dark'),
        lg: this.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT ? $r('app.media.ic_map_lg') :
          $r('app.media.ic_map_lg_dark'),
      }).getValue(this.currentWidthBreakpoint))
        .width('110%')
        .height('110%')

      TrafficView()
    }
    .width('100%')
    .height('100%')
  }
}