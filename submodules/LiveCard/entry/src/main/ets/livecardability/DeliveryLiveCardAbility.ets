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
import { Logger } from '../utils/Logger';

const TAG = 'DeliveryLiveCardAbility';

export class DeliveryLiveCardAbility extends LiveFormExtensionAbility {
  // [Start delivery_liveform_create]
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
      session.loadContent('livecardability/pages/DeliveryLiveCard', storage);
    } catch (error) {
      Logger.error(TAG, `session.loadContent error`);
    }
  }
  // [End delivery_liveform_create]
}