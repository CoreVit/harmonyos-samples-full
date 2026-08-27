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

let storageUpdateCall = new LocalStorage();

@Entry(storageUpdateCall)
@Component
struct SleepCard {
  @LocalStorageProp('formId') formId: string = '';
  @LocalStorageProp('formWidth') formWidth: number = 0;
  @LocalStorageProp('formHeight') formHeight: number = 0;
  @LocalStorageProp('isSleep') isSleep: boolean = true;

  build() {
    RelativeContainer() {
      // Clover
      Image(this.isSleep ? $rawfile('sleep/clover_sleep.png') : $rawfile('sleep/clover_wakeup.png'))
        .objectFit(ImageFit.Cover)
        .width('100%')
        .height('100%');

      // hanhan
      Stack({alignContent: Alignment.Center}) {
        Image(this.isSleep ? $rawfile('sleep/hanhan_sleep.png') : $r('app.media.sleep_hanhan_frame89_95'))
          .objectFit(ImageFit.Contain)
          .width('100%')
          .height('100%');
      }
      .offset({
        x: '-20%',
        y: '-25%'
      })
      .width('130%')
      .height('150%');
      Column() {
        Stack()
          .aspectRatio(1)
          .layoutWeight(1)
          .onClick(() => {
            ActionUtils.jumpAppPage(this, 'CloverPage');
          });
        Row() {
          Text(this.isSleep ? $r('app.string.sleep_status_sleeping') : $r('app.string.sleep_status_wakeup'))
            .fontColor(this.isSleep ? '#8D68FC' : '#27C2D7')
            .maxLines(1)
            .layoutWeight(1)
            .minFontSize('16px')
            .maxFontSize('36px');
          SymbolGlyph($r('sys.symbol.checkmark_circle_fill'))
            .fontColor([this.isSleep ? '#8D68FC' : '#27C2D7'])
            .fontSize('36px');
        }
          .justifyContent(FlexAlign.SpaceBetween)
          .backgroundColor('#A6FFFDFD')
          .width('90%')
          .borderRadius('50%')
          .padding({
            top: 5,
            right: 7,
            left: 7,
            bottom: 5
          });
      }
      .width('45%')
      .alignItems(HorizontalAlign.Center)
      .padding(12)
      .alignRules({
        top: { anchor: '__container__', align: VerticalAlign.Top },
        right: { anchor: '__container__', align: HorizontalAlign.End }
      });
    }
    .backgroundImage($rawfile('sleep/background.png'))
    .backgroundImageSize(ImageSize.Cover)
    .width('100%')
    .height('100%')
    .onClick(() => {
      if (this.isSleep) {
        ActionUtils.requestOverFlow(this, LiveCardScale.SLEEP_WIDTH,
          LiveCardScale.SLEEP_HEIGHT, LIVE_CARD_DURATION);
      } else {
        ActionUtils.jumpAppPage(this, 'SleepReport');
      }
    });
  }
}