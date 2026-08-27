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
  LengthMetrics,
  OnSelectedIndexChange,
  SegmentButtonV2Items,
  TabSegmentButtonV2
} from '@kit.ArkUI';
import { audio } from '@kit.AudioKit';
import Logger from '../common/util/Logger';
import { CommonConstants } from '../common/constants/CommonConstants';

const TAG = 'SegmentButtonComponent'

@ComponentV2
export struct SegmentButtonComponent {
  @Local selectedIndex: number = 3

  @Monitor('selectedIndex')
  onSelectedIndexChange(monitor: IMonitor) {
    let nowValue: number | undefined = monitor.value()?.now as number
    let audioMode: audio.AudioConcurrencyMode = audio.AudioConcurrencyMode.CONCURRENCY_DEFAULT;
    switch (nowValue) {
      case 0:
        audioMode = audio.AudioConcurrencyMode.CONCURRENCY_MIX_WITH_OTHERS;
        break;
      case 1:
        audioMode = audio.AudioConcurrencyMode.CONCURRENCY_DUCK_OTHERS;
        break;
      case 2:
        audioMode = audio.AudioConcurrencyMode.CONCURRENCY_PAUSE_OTHERS;
        break;
      case 3:
        audioMode = audio.AudioConcurrencyMode.CONCURRENCY_DEFAULT;
        break;
    }

    Logger.info(TAG, `current value is ${nowValue},current audioConcurrencyMode is ${audioMode}`)
    AppStorage.setOrCreate<audio.AudioConcurrencyMode>(CommonConstants.KEY_AUDIO_CONCURRENCY_MODE, audioMode);
  }

  build() {
    TabSegmentButtonV2({
      items: new SegmentButtonV2Items([
        { text: 'Mix' }, { text: 'Duck' }, { text: 'Pause' }, { text: 'Default' }
      ]),
      selectedIndex: this.selectedIndex!!,
      buttonMinHeight: new LengthMetrics(40),
      buttonBorderRadius: new LengthMetrics(40),
      itemMinHeight: new LengthMetrics(40),
      itemBorderRadius: new LengthMetrics(40),
      itemFontSize: new LengthMetrics(14), //
      itemSelectedFontSize: new LengthMetrics(14),
      itemSelectedFontWeight: FontWeight.Normal,
    })
  }
}
