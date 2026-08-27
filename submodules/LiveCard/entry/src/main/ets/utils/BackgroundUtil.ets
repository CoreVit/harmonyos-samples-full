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

import { wantAgent, common } from '@kit.AbilityKit';
import { backgroundTaskManager } from '@kit.BackgroundTasksKit';
import type { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from './Logger';
import { promptAction } from '@kit.ArkUI';

const TAG = 'BackgroundUtilLogTag';

export class BackgroundUtil {
  private static isContinuousTaskStart: boolean = false;

  /**
   * Start background task.
   *
   * @param context
   */
  public static startContinuousTask(context: common.UIAbilityContext): void {
    if (BackgroundUtil.isContinuousTaskStart) {
      Logger.info(TAG, `BackgroundRunning is started`);
      return;
    }
    if (!context) {
      Logger.error(TAG, `context undefined`);
      return;
    }
    let wantAgentInfo: wantAgent.WantAgentInfo = {
      wants: [
        {
          bundleName: context.abilityInfo.bundleName,
          abilityName: context.abilityInfo.name,
        },
      ],
      actionType: wantAgent.OperationType.START_ABILITY,
      requestCode: 0,
      wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG],
      extraInfos: {
        routeName: 'MusicPage',
      }
    };

    wantAgent.getWantAgent(wantAgentInfo).then((wantAgentObj: object) => {
      if (canIUse('SystemCapability.ResourceSchedule.BackgroundTaskManager.ContinuousTask')) {
        backgroundTaskManager
          .startBackgroundRunning(context, backgroundTaskManager.BackgroundMode.AUDIO_PLAYBACK, wantAgentObj)
          .then(() => {
            BackgroundUtil.isContinuousTaskStart = true;
            Logger.info(TAG, 'startBackgroundRunning succeeded');
          })
          .catch((error: BusinessError) => {
            Logger.error(TAG, `startBackgroundRunning failed Cause: code ${error.code}`);
          });
      } else {
        Logger.error(TAG, `cant use BackgroundRunning`);
        promptAction.openToast({ message: $r('app.string.background_playback_not_supported') }).catch(() => {
          Logger.error(TAG, `openToast error`);
        });
      }
    }).catch((error: BusinessError) => {
      Logger.error(TAG, `getWantAgent err, code: ${error.code}, message: ${error.message}`);
    });
  }

  /**
   * Stop background task.
   *
   * @param context
   */
  public static stopContinuousTask(context: common.UIAbilityContext): void {
    try {
      if (canIUse('SystemCapability.ResourceSchedule.BackgroundTaskManager.ContinuousTask')) {
        backgroundTaskManager
          .stopBackgroundRunning(context)
          .then(() => {
            BackgroundUtil.isContinuousTaskStart = false;
            Logger.info(TAG, 'stopBackgroundRunning succeeded');
          })
          .catch((error: BusinessError) => {
            BackgroundUtil.isContinuousTaskStart = false;
            Logger.error(TAG, `stopBackgroundRunning failed Cause: code ${error.code}`);
          });
      } else {
        promptAction.openToast({ message: $r('app.string.background_playback_not_supported') }).catch(() => {
          Logger.error(TAG, `openToast error`);
        });
      }
    } catch (error) {
      Logger.error(
        TAG,
        `stopBackgroundRunning failed. code ${(error as BusinessError).code}
       message ${(error as BusinessError).message}`
      );
    }
  }
}
