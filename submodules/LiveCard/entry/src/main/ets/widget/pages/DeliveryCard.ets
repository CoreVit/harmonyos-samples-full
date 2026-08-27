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

import ActionUtils from '../../utils/ActionUtils';
import { LIVE_CARD_DURATION, LiveCardScale } from '../../model/common/FormCardConstant';

// [Start delivery_static_card]
let storageUpdateCall = new LocalStorage();

@Entry(storageUpdateCall)
@Component
struct DeliveryCard {
  @LocalStorageProp('formWidth') formWidth: number = 0;
  @LocalStorageProp('formHeight') formHeight: number = 0;

  build() {
    RelativeContainer() {
      Image($rawfile('delivery/background.png'))
        .objectFit(ImageFit.Contain)
        .width('100%')
        .height('100%')
        .aspectRatio(1);
      Image($rawfile('delivery/fuzzball.png'))
        .objectFit(ImageFit.Contain)
        .width('145%')
        .height('145%')
        .offset({
          x: `-22.5%`,
          y: `-22.5%`
        });
      Row() {
        Image($r('app.media.delivery_box'))
          .objectFit(ImageFit.Contain)
          .width(this.formWidth * 0.2 + 'px')
          .height(this.formHeight * 0.2 + 'px');
        Text($r('app.string.delivery_in_transit'))
          .fontSize('21.55f')
          .fontColor('#646166')
          .fontFamily('HarmonyOS Scans SC');
      }
      .justifyContent(FlexAlign.SpaceEvenly)
      .alignRules({
        middle: { anchor: '__container__', align: HorizontalAlign.Center },
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
      })
      .backgroundColor('#BFFFFFFF')
      .width(this.formWidth * 0.830 + 'px')
      .height(this.formHeight * 0.205 + 'px')
      .margin({ bottom: this.formHeight * 0.082 + 'px' })
      .borderRadius('9%');
      // [Start delivery_card_jump]
      Stack()
        .width('100%')
        .height('30%')
        .onClick(() => {
          ActionUtils.jumpAppPage(this, 'DeliveryPage');
        })
        .alignRules({
          left: { anchor: '__container__', align: HorizontalAlign.Start },
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
        });
      // [End delivery_card_jump]
    }
    .width('100%')
    .height('100%')
    .onClick(() => {
      ActionUtils.requestOverFlow(this, LiveCardScale.DELIVERY_WIDTH,
        LiveCardScale.DELIVERY_HEIGHT, LIVE_CARD_DURATION);
    });
  }
}
// [End delivery_static_card]