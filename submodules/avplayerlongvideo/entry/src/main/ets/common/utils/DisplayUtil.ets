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

import { display } from '@kit.ArkUI';
import Logger from './Logger';
import { KeyConstants } from '../constants/KeyConstants';

const TAG = '[DisplayUtil]';

// [Start display_util]
export class DisplayUtil {
  static getFoldCreaseRegion(uiContext: UIContext): void {
    if (canIUse('SystemCapability.Window.SessionManager')) {
      try {
        if (!display.isFoldable()) {
          return;
        }
        let foldRegion: display.FoldCreaseRegion = display.getCurrentFoldCreaseRegion();
        if (foldRegion.creaseRects.length === 0) {
          return;
        }
        let rect: display.Rect = foldRegion.creaseRects[0];
        // Height of the avoidance area in the upper half screen and height of the avoidance area.
        let creaseRegion: number[] = [uiContext.px2vp(rect.top), uiContext.px2vp(rect.height)];
        AppStorage.setOrCreate(KeyConstants.KEY_CREASE_REGION, creaseRegion);
      } catch (error) {
        Logger.error(TAG, `getIsFoldable failed, errCode = ${error.code}, errMessage = ${error.message}.`);
      }
    }
  }
}
// [End display_util]