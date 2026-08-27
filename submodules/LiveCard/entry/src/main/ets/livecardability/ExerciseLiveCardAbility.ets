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

import { formInfo, LiveFormExtensionAbility, LiveFormInfo } from '@kit.FormKit';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import { ExerciseState } from '../model/exercise/ExerciseCardConstant';
import { Logger } from '../utils/Logger';
import ExerciseFileStore from '../database/ExerciseFileStore';

const TAG = 'ExerciseLiveCardAbility';

export class ExerciseLiveCardAbility extends LiveFormExtensionAbility {
  // [Start exercise_liveform_create]
  onLiveFormCreate(liveFormInfo: LiveFormInfo, session: UIExtensionContentSession): void {
    let storage: LocalStorage = new LocalStorage();
    storage.setOrCreate('context', this.context);
    storage.setOrCreate('session', session);
    let formId: string = liveFormInfo.formId;
    storage.setOrCreate('formId', formId);

    let borderRadius: number = liveFormInfo.borderRadius;
    storage.setOrCreate('borderRadius', borderRadius);

    let formRect: formInfo.Rect = liveFormInfo.rect;
    storage.setOrCreate('formRect', formRect);

    try {
      session.loadContent('livecardability/pages/ExerciseLiveCard', storage);
    } catch (error) {
      Logger.error(TAG, 'loadContent error');
    }

    try {
      let savedState = ExerciseFileStore.readExerciseState(this.context);
      if (savedState === undefined) {
        savedState = ExerciseState.NOT_STARTED;
      }
      Logger.info(TAG, `savedState: ${savedState}`)
      storage.setOrCreate('exerciseState', savedState);
    } catch (err) {
      Logger.error(TAG, `readExerciseState error, code is ${err.code}, message is ${err.message}`);
      storage.setOrCreate('exerciseState', ExerciseState.NOT_STARTED);
    }
  }
  // [End exercise_liveform_create]
}