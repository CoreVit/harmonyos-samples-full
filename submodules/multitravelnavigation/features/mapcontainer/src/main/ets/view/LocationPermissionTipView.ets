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

import { Common, LocationPermissionStatus } from 'multitravelbase/Index';

@Component
export struct LocationPermissionTipView {
  @Prop status: LocationPermissionStatus = LocationPermissionStatus.DENIED;
  onRetry?: () => void;
  onClose?: () => void;

  private getMessage(): Resource {
    if (this.status === LocationPermissionStatus.LOCATION_SWITCH_OFF) {
      return $r('app.string.location_switch_off_tip');
    }
    return $r('app.string.location_permission_denied_tip');
  }

  private getActionText(): Resource {
    if (this.status === LocationPermissionStatus.LOCATION_SWITCH_OFF) {
      return $r('app.string.location_tip_open');
    }
    return $r('app.string.location_tip_retry');
  }

  build() {
    Row() {
      Image($r('app.media.icon_myLocation'))
        .width(20)
        .height(20)
        .fillColor($r('sys.color.brand'))
        .margin({ right: 8 })

      Text(this.getMessage())
        .fontSize(13)
        .fontColor($r('sys.color.font_primary'))
        .maxLines(2)
        .layoutWeight(1)

      Button(this.getActionText(), { type: ButtonType.Normal })
        .height(30)
        .fontSize(13)
        .fontColor($r('sys.color.font_on_primary'))
        .backgroundColor($r('sys.color.brand'))
        .borderRadius(15)
        .padding({ left: 12, right: 12 })
        .margin({ left: 8 })
        .onClick(() => {
          this.onRetry?.();
        })

      Button({ type: ButtonType.Circle }) {
        SymbolGlyph($r('sys.symbol.xmark'))
          .fontSize(16)
          .fontColor([$r('sys.color.icon_secondary')])
      }
      .width(28)
      .height(28)
      .backgroundColor(Color.Transparent)
      .margin({ left: 4 })
      .onClick(() => {
        this.onClose?.();
      })
    }
    .width(Common.FULL_WIDTH)
    .padding({ left: 12, right: 8, top: 10, bottom: 10 })
    .backgroundColor($r('app.color.mapcontainer_permission_tip_background'))
    .borderRadius(8)
    .shadow({
      radius: 12,
      color: $r('app.color.mapcontainer_permission_tip_shadow'),
      offsetY: 4
    })
  }
}
