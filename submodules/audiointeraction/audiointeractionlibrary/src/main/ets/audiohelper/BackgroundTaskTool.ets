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

import { common, wantAgent } from '@kit.AbilityKit';
import { backgroundTaskManager } from '@kit.BackgroundTasksKit';
import { BusinessError } from '@kit.BasicServicesKit';
import Logger from '../common/utils/Logger';

const TAG: string = '[BackgroundTaskTool]';

export class BackgroundTaskTool {
  /**
   * Start background task.
   *
   * @param context
   */
  public static startContinuousTask(context?: common.UIAbilityContext): void {
    if (!context) {
      Logger.error(TAG, 'startContinuousTask failed. context undefined');
      return;
    }
    const wantAgentInfo: wantAgent.WantAgentInfo = {
      wants: [
        {
          bundleName: context.abilityInfo.bundleName,
          abilityName: context.abilityInfo.name
        }
      ],
      actionType: wantAgent.OperationType.START_ABILITY,
      requestCode: 0,
      wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
    };

    wantAgent.getWantAgent(wantAgentInfo).then((wantAgentObj: Object) => {
      try {
        if (canIUse('SystemCapability.ResourceSchedule.BackgroundTaskManager.ContinuousTask')) {
          backgroundTaskManager.startBackgroundRunning(context,
            backgroundTaskManager.BackgroundMode.AUDIO_PLAYBACK, wantAgentObj).then(() => {
            Logger.info('this audioRenderer: ', 'startBackgroundRunning succeeded');
          }).catch((error: BusinessError) => {
            Logger.error(TAG, `startBackgroundRunning failed. code: ${error.code}, message: ${error.message}`);
          });
        }
      } catch (err) {
        Logger.error(TAG, `startBackgroundRunning failed. code: ${err.code}, message: ${err.message}`);
      }
    }).catch((error: BusinessError)=>{
      Logger.error(TAG, `getWantAgent failed. code: ${error.code}, message: ${error.message}`);
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
        backgroundTaskManager.stopBackgroundRunning(context).then(() => {
          Logger.info(TAG, 'stopBackgroundRunning succeeded');
        }).catch((error: BusinessError) => {
          Logger.error(TAG, `stopBackgroundRunning failed. code: ${error.code}, message: ${error.message}`);
        });
      }
    } catch (err) {
      Logger.error(TAG, `stopBackgroundRunning failed. code: ${err.code}, message: ${err.message}`);
    }
  }
}