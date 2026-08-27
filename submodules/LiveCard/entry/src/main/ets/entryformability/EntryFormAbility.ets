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

import { formBindingData, FormExtensionAbility, formInfo, formProvider } from '@kit.FormKit';
import Want from '@ohos.app.ability.Want';
import type { BusinessError } from '@kit.BasicServicesKit';
import { FormInfo } from '../model/common/FormInfo';
import { Logger } from '../utils/Logger';
import FormUtils from '../utils/FormUtils';
import ExerciseFileStore from '../database/ExerciseFileStore';
import MusicFileStore from '../database/MusicFileStore';
import { ExerciseState } from '../model/exercise/ExerciseCardConstant';
import { LIVE_CARD_DURATION, LiveCardScale } from '../model/common/FormCardConstant';
import { LIVE_CARD_RATIO } from '../common/CommonConstants';

const TAG = 'EntryFormAbility';

export default class EntryFormAbility extends FormExtensionAbility {
  onAddForm(want: Want): formBindingData.FormBindingData {
    let formId: string = '';
    let formWidth: number = -1;
    let formHeight: number = -1;
    if (want && want.parameters) {
      if (want.parameters['ohos.extra.param.key.form_identity']) {
        formId = want.parameters['ohos.extra.param.key.form_identity'] as string;
      }
      if (want.parameters['ohos.extra.param.key.form_width']) {
        formWidth = want.parameters['ohos.extra.param.key.form_width'] as number;
      }
      if (want.parameters['ohos.extra.param.key.form_height']) {
        formHeight = want.parameters['ohos.extra.param.key.form_height'] as number;
      }
      let formName = want.parameters['ohos.extra.param.key.form_name'] as string;

      let formDimension = want.parameters['ohos.extra.param.key.form_dimension'] as string;

      if (formName !== '' && formDimension) {
        let formInfo = new FormInfo();
        formInfo.formId = formId;
        formInfo.formDimension = formDimension;
        formInfo.formName = formName;

        FormUtils.insertFormData(this.context, formInfo);
      }

      if (formName.includes('Music')) {
        FormUtils.updateMusicControlCard(formId, true);
      }
    }
    return formBindingData.createFormBindingData({
      formId: formId,
      formWidth: formWidth,
      formHeight: formHeight
    });
  }

  onUpdateForm(formId: string): void {
    FormUtils.getFormInfoById(this.context, formId)
      .then((formInfo) => {
        if (!formInfo) {
          Logger.error(TAG, `formInfo not found`);
          return;
        }
        if (formInfo.formName.includes('Delivery')) {
          this.requestOverflow(formId, LiveCardScale.DELIVERY_WIDTH,
            LiveCardScale.DELIVERY_HEIGHT, LIVE_CARD_DURATION);
        } else if (formInfo.formName.includes('Exercise')) {
          try {
            ExerciseFileStore.writeExerciseState(this.context, ExerciseState.NOT_STARTED);
            setTimeout(() => {
              this.requestOverflow(formId, LiveCardScale.EXERCISE_WIDTH,
                LiveCardScale.EXERCISE_HEIGHT, LIVE_CARD_DURATION);
            }, 1200);
          } catch (e) {
            Logger.error(TAG, `onUpdateForm ExerciseCard request error: ${e.code}, ${e.message}`);
          }

        }
        Logger.info(TAG, `onUpdateForm formName: ${formInfo.formName}`);
      }).catch((e: BusinessError) => {
      Logger.error(TAG, `getFormInfoById error, code is ${e.code}, message is ${e.message}`);
    });
  }

  // [Start form_event_handler]
  onFormEvent(formId: string, message: string): void {
    const params: Record<string, Object> = JSON.parse(message);
    let shortMessage: string = params.message as string;

    if (shortMessage === 'requestOverflow') {
      let widthRatio: number = Math.min(Math.max(params.widthRatio as number || 0, 0), LIVE_CARD_RATIO);
      let heightRatio: number = Math.min(Math.max(params.heightRatio as number || 0, 0), LIVE_CARD_RATIO);
      let duration: number = Math.min(Math.max(params.duration as number || 0, 0), LIVE_CARD_DURATION);
      // [StartExclude form_event_handler]
      let triggerAction: string = params.triggerAction as string || '';
      let songId: string = params.songId as string || '';

      if (triggerAction) {
        MusicFileStore.storeTriggerAction(this.context, triggerAction, songId);
      }
      // [EndExclude form_event_handler]

      this.requestOverflow(formId, widthRatio, heightRatio, duration);
      return;
    } else if (shortMessage === 'updateRequestOverflowState') {
      updateRequestOverFlowState(formId, true);
    }
  }
  // [End form_event_handler]

  onRemoveForm(formId: string): void {
    FormUtils.deleteFormInfo(this.context, formId);
  }

  /**
   * 激活互动卡片
   * @param formId
   * @param widthRatio
   * @param heightRatio
   * @param duration
   * @returns
   */
  // [Start request_overflow]
  private async requestOverflow(formId: string, widthRatio: number, heightRatio: number,
    duration: number): Promise<void> {
    try {
      let formRect: formInfo.Rect = await formProvider.getFormRect(formId);
      // [StartExclude request_overflow]
      Logger.info(TAG, `formId: ${formId} widthRatio: ${widthRatio} heightRatio: ${heightRatio} ` +
        `duration: ${duration} width: ${formRect.width} height: ${formRect.height} ` +
        `left: ${formRect.left} top: ${formRect.top}`);
      // [EndExclude request_overflow]
      if (formRect.width <= 0 || formRect.height <= 0) {
        return;
      }
      let cardWidth = formRect.width * widthRatio;
      let cardHeight = formRect.height * heightRatio;
      let leftOffset = (formRect.width - cardWidth) / 2;
      let topOffset = (formRect.height - cardHeight) / 2;

      formProvider.requestOverflow(formId, {
        area: {
          left: leftOffset,
          top: topOffset,
          width: cardWidth,
          height: cardHeight
        },
        duration: duration
      }).catch((e: BusinessError) => {
        Logger.error(TAG, `requestOverflow error, code: ${e.code} message: ${e.message}`);
      }).finally(() => {
        const timeoutId = setTimeout(() => {
          updateRequestOverFlowState(formId, false);
          clearTimeout(timeoutId);
        }, 500)
      });
    } catch (error) {
      // [StartExclude request_overflow]
      Logger.error(TAG, `requestOverflow error: ${error.code}, message is ${error.message}`);
      // [EndExclude request_overflow]
    }
  }
  // [End request_overflow]
  onAcquireFormState(): formInfo.FormState {
    // Called to return a {@link FormState} object.
    return formInfo.FormState.READY;
  }
}

function updateRequestOverFlowState(formId: string, state: boolean) {
  class RequestOverflowState {
    public isRequestingOverflow: boolean = state;
  }
  let updateData = new RequestOverflowState();
  let message: formBindingData.FormBindingData = formBindingData.createFormBindingData(updateData);
  formProvider.updateForm(formId, message).catch(() => {
    Logger.error(TAG, `update request overflow result error.`);
  })
}