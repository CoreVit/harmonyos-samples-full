/*
* Copyright (c) 2024 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the 'License');
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an 'AS IS' BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import { common } from '@kit.AbilityKit';
import { MapComponent } from '@kit.MapKit';
import { BreakpointType } from '../utils/BreakpointSystem';
import { PermissionsUtil } from '../utils/PermissionsUtil';
import { customInfoWindowBuilder, LocationServiceManager } from '../model/LocationServiceManager';
import { CommonConstants } from '../constants/CommonConstants';

@Component
export struct LocationServiceComponent {
  @StorageProp(CommonConstants.KEY_PREFIX + 'navIndicatorHeight') bottomRectHeight: number = 0;
  @StorageProp(CommonConstants.KEY_PREFIX + 'currentBreakpoint') curBp: string = 'sm';
  @State isShowCacheLocation: boolean = false;
  @State locationServiceManager: LocationServiceManager = new LocationServiceManager();

  aboutToAppear(): void {
    PermissionsUtil.requestPermissions(this.getUIContext().getHostContext() as common.UIAbilityContext);
    this.locationServiceManager.init(this.getUIContext());
  }

  aboutToDisappear(): void {
    this.locationServiceManager?.clear();
  }

  async handlePermissionAndAction(action: () => void) {
    const hasGrant =
      await PermissionsUtil.checkPermissions(this.getUIContext().getHostContext() as common.UIAbilityContext);
    if (hasGrant) {
      action();
    }
  }

  build() {
    Column() {
      Row() {
        if (canIUse('SystemCapability.Map.Core')) {
          MapComponent({
            mapOptions: this.locationServiceManager.mapOption,
            mapCallback: this.locationServiceManager.mapCallback,
            customInfoWindow: customInfoWindowBuilder
          })
            .width('100%')
            .height('100%')
        }
      }
      .height('100%')
      .width('100%')

      Column() {
        Divider()
          .strokeWidth(4)
          .color($r('sys.color.mask_fourth'))
          .width($r('sys.float.padding_level24'))
          .lineCap(LineCapStyle.Round)
          .margin({
            top: $r('sys.float.padding_level3'),
            bottom: $r('sys.float.padding_level7')
          })

        Row() {
          Text()
            .width($r('sys.float.padding_level4'))
            .height($r('sys.float.padding_level4'))
            .margin({
              top: $r('sys.float.padding_level3'),
              right: $r('sys.float.padding_level4')
            })
            .backgroundColor('#00C19C')
            .borderRadius($r('sys.float.corner_radius_level2'))
            .fontWeight(FontWeight.Medium)
          Text() {
            Span(this.isShowCacheLocation ? $r('app.string.cache_geocoded_location') :
            $r('app.string.current_geocoded_location'))
              .fontSize($r('sys.float.Body_M'))
              .lineHeight($r('sys.float.padding_level10'))
              .fontColor('#00BD9D')
            Span(this.locationServiceManager.address)
              .fontSize($r('sys.float.Body_M'))
              .lineHeight($r('sys.float.padding_level10'))
              .fontColor($r('sys.color.font_primary'))
          }
          .fontWeight(FontWeight.Medium)
          .margin({ right: $r('sys.float.padding_level8') })
        }
        .alignItems(VerticalAlign.Top)
        .width('100%')
        .padding({
          bottom: $r('sys.float.padding_level8'),
        })
        .margin({
          left: $r('sys.float.padding_level8'),
          right: $r('sys.float.padding_level8')
        })
        .constraintSize({ maxWidth: '100%' })

        Column() {
          Button($r('app.string.get_cache_location'), { buttonStyle: ButtonStyleMode.NORMAL })
            .onClick(() => this.handlePermissionAndAction(() => {
              this.locationServiceManager.showCacheLocation();
              this.isShowCacheLocation = true;
            }))
            .width('100%')
            .fontWeight(FontWeight.Medium)
            .margin({
              bottom: $r('sys.float.padding_level6')
            })

          Button($r('app.string.get_current_location'), { buttonStyle: ButtonStyleMode.NORMAL })
            .onClick(() => this.handlePermissionAndAction(() => {
              this.locationServiceManager.showCurrentLocation();
              this.isShowCacheLocation = false;
            }))
            .width('100%')
            .fontWeight(FontWeight.Medium)
        }
        .width('100%')
        .constraintSize({ maxWidth: '100%' })
        .margin({
          left: $r('sys.float.padding_level8'),
          right: $r('sys.float.padding_level8'),
          bottom: $r('sys.float.padding_level8')
        })
      }
      .width(new BreakpointType({
        sm: '100%',
        md: '300vp',
        lg: '360vp'
      }).getValue(this.curBp))
      .borderColor($r('sys.color.comp_divider'))
      .borderRadius({
        topLeft: $r('sys.float.corner_radius_level12'),
        topRight: $r('sys.float.corner_radius_level12'),
        bottomLeft: new BreakpointType({
          sm: $r('sys.float.padding_level0'), md: $r('sys.float.corner_radius_level12'),
          lg: $r('sys.float.corner_radius_level12')
        }).getValue(this.curBp),
        bottomRight: new BreakpointType({
          sm: $r('sys.float.padding_level0'), md: $r('sys.float.corner_radius_level12'),
          lg: $r('sys.float.corner_radius_level12')
        }).getValue(this.curBp)
      })
      .backgroundColor($r('sys.color.background_secondary'))
      .shadow(ShadowStyle.OUTER_DEFAULT_XS)
      .position({
        bottom: 0,
        left: new BreakpointType({
          sm: $r('sys.float.padding_level0'), md: $r('sys.float.padding_level12'),
          lg: $r('sys.float.padding_level16')
        }).getValue(this.curBp)
      })
      .padding({
        bottom: new BreakpointType({
          sm: this.bottomRectHeight,
          md: 0,
          lg: 0
        }).getValue(this.curBp)
      })
      .margin({
        bottom: new BreakpointType({
          sm: 0,
          md: this.bottomRectHeight,
          lg: this.bottomRectHeight
        }).getValue(this.curBp)
      })
    }
    .height('100%')
  }
}