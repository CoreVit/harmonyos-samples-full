/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { common, Want } from '@kit.AbilityKit';
import Logger from './Logger';

export const TAG: string = '[EventUtil]';

interface Data {
  context: Context;
  launchWant: Want;
}

export class EventUtil {
  private static abilityHandler?: (data: Data) => void;

  public static subscribeEvent(context: common.UIAbilityContext, want: Want) {
    EventUtil.abilityHandler = (data: Data): void => {
      Logger.info(TAG, `%{public}s`, `getAbilityData`);
      data.context = context;
      data.launchWant = want;
    };
    try {
      context.eventHub.on('getAbilityData', EventUtil.abilityHandler);
    } catch (err) {
      Logger.error(TAG, `eventHub.on failed. code: ${err.code ?? ''}, message: ${err.message ?? ''}`);
    }
  }

  public static unsubscribeEvent(context: common.UIAbilityContext) {
    if (EventUtil.abilityHandler) {
      try {
        context.eventHub.off('getAbilityData', EventUtil.abilityHandler);
        EventUtil.abilityHandler = undefined;
      } catch (err) {
        Logger.error(TAG, `eventHub.off failed. code: ${err.code ?? ''}, message: ${err.message ?? ''}`);
      }
    }
  }
}