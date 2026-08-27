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

import { appManager, WantAgent, wantAgent } from '@kit.AbilityKit';
import { backgroundTaskManager } from '@kit.BackgroundTasksKit';
import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';
import { Constants } from '../common/Constants';
import { RouteData } from '../model/RouteDataModel';
import { LiveViewUtil } from './LiveViewUtil';
import { getRouteData } from '../viewmodel/RouteDataViewModel';
import Logger from './Logger';

const TAG: string = '[LiveView]';

export class LiveView {
  // Singleton pattern implementation
  private static instance: LiveView;
  private context: Context;
  private liveViewController: LiveViewUtil;
  private updateInterval: number | undefined;

  // Private constructor for singleton pattern
  private constructor(context: Context) {
    this.context = context;
    this.liveViewController = new LiveViewUtil(context);
  }

  // Singleton accessor method
  public static getInstance(context: Context): LiveView {
    // Lazy initialization of the singleton instance
    if (!LiveView.instance) {
      LiveView.instance = new LiveView(context);
    }
    return LiveView.instance;
  }

  // Main entry point to start live view functionality
  public createLiveView(): void {
    // Initialize live view and start background tasks
    this.liveViewController.startLiveView(getRouteData()).then(() => {
      this.startContinuousRunningTask();
      // Set up periodic state checking
      this.updateInterval = setInterval(() => {
        // Monitor application state changes
        appManager.getRunningProcessInformation().then((data: Array<appManager.ProcessInformation>) => {
          Logger.info(TAG, 'Success to getRunningProcessInformation');
          // Handle background state
          if (data[0].state === appManager.ProcessState.STATE_BACKGROUND) {
            let routeData: RouteData = getRouteData();
            this.liveViewController.updateLiveView(routeData);
            // Prepare common event data
            let options: commonEventManager.CommonEventPublishData = {
              data: 'data',
              bundleName: AppStorage.get(Constants.KEY_PREFIX + 'BundleName'),
              parameters: {
                'laneData': routeData.laneData
              }
            };
            // Publish system event for lock screen updates
            commonEventManager.publish('live_view_lock_screen', options, (error: BusinessError) => {
              if (error) {
                Logger.error(TAG, '%{public}s',
                  `Failed to publish commonEvent. code is ${error.code} message is ${error.message}`);
              } else {
                Logger.info(TAG, 'Succeeded in publishing commonEvent.')
              }
            });
          }
        }).catch((error: BusinessError) => {
          Logger.error(TAG, '%{public}s',
            `Failed to getRunningProcessInformation. code is ${error.code} message is ${error.message}`);
        });
      }, 2000)
    })
  }

  // Cleanup method to stop all live view activities
  public finishLiveView(): void {
    // Clear periodic updates
    if (this.updateInterval !== undefined) {
      clearInterval(this.updateInterval);
      this.updateInterval = undefined;
      Logger.info(TAG, 'Timer has been cleared');
    }

    // Shutdown live view components
    this.liveViewController.closeLiveView();

    // Stop background tasks
    try {
      if (canIUse('SystemCapability.ResourceSchedule.BackgroundTaskManager.ContinuousTask')) {
        backgroundTaskManager.stopBackgroundRunning(this.context).then(() => {
          Logger.info(TAG, 'Operation stopBackgroundRunning succeeded');
        }).catch((error: BusinessError) => {
          Logger.error(TAG, '%{public}s',
            `Operation stopBackgroundRunning failed. code is ${error.code} message is ${error.message}`);
        });
      }
    } catch (error) {
      Logger.error(TAG, '%{public}s',
        `Operation stopBackgroundRunning failed. code is ${(error as BusinessError).code} message is ${(error as BusinessError).message}`);
    }
  }

  // Internal method to manage background tasks
  private startContinuousRunningTask(): void {
    // Configure WantAgent for background operation
    const wantAgentInfo: wantAgent.WantAgentInfo = {
      wants: [
        {
          bundleName: AppStorage.get(Constants.KEY_PREFIX + 'BundleName'),
          abilityName: 'LiveviewlockscreensampleAbility'
        }
      ],
      actionType: wantAgent.OperationType.START_ABILITY,
      requestCode: 0,
      actionFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
    };

    try {
      // Acquire WantAgent for background operations
      wantAgent.getWantAgent(wantAgentInfo).then((wantAgentObj: WantAgent) => {
        try {
          Logger.info(TAG, 'Operation startBackgroundRunning begin.');
          // Required background resource types
          const list: string[] = ['location'];
          // Request background running permission
          if (canIUse('SystemCapability.ResourceSchedule.BackgroundTaskManager.ContinuousTask')) {
            backgroundTaskManager.startBackgroundRunning(this.context, list, wantAgentObj).then(() => {
              Logger.info(TAG, 'Operation startBackgroundRunning succeeded.');
            }).catch((error: BusinessError) => {
              Logger.error(TAG, '%{public}s',
                `Failed to Operation startBackgroundRunning. code is ${error.code} message is ${error.message}`);
            });
          }
        } catch (error) {
          Logger.error(TAG, '%{public}s',
            `Failed to Operation startBackgroundRunning. code is ${(error as BusinessError).code} message is ${(error as BusinessError).message}`);
        }
      });
    } catch (error) {
      Logger.error(TAG, '%{public}s',
        `Failed to Operation getWantAgent. code is ${(error as BusinessError).code} message is ${(error as BusinessError).message}`);
    }
  }
}