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
import { LaneData } from '../model/RouteDataModel';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';

@Component
export struct LockScreenComponent {
  @StorageLink(Constants.KEY_PREFIX + 'CurrentHeightBreakpoint') currentHeightBreakpoint: string =
    BreakpointTypeEnum.SM;
  @StorageLink(Constants.KEY_PREFIX + 'LaneData') laneData: LaneData | undefined = undefined;
  @StorageLink('LiveViewColorMode') colorMode: ConfigurationConstant.ColorMode =
    AppStorage.get('LiveViewColorMode') ?? ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET;

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Image(new BreakpointType<Resource>({
        sm: this.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT ? $r('app.media.ic_map') :
          $r('app.media.ic_map_dark'),
        md: this.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT ? $r('app.media.ic_map_md') :
          $r('app.media.ic_map_md_dark'),
        lg: this.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT ? $r('app.media.ic_map_lg') :
          $r('app.media.ic_map_lg_dark'),
      }).getValue(this.currentHeightBreakpoint))
        .width('100%')
        .height('100%')

      Image($rawfile('traffic_light.svg'))
        .objectFit(ImageFit.Contain)
        .width(80)
        .position({
          // Layout based on vertical breakpoint.
          right: new BreakpointType({ sm: 75, md: 25, lg: 25, }).getValue(this.currentHeightBreakpoint),
          top: 25
        })
    }
    .width('100%')
    .height('100%')
  }
}