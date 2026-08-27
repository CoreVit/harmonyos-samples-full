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


import { bundleManager, UIExtensionContentSession } from '@kit.AbilityKit';
import { display, window } from '@kit.ArkUI';
import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';
import { Constants } from '../common/Constants';
import { LaneData } from '../model/RouteDataModel';
import { BreakpointTypeEnum } from './BreakpointSystem';
import Logger from './Logger';

const TAG: string = '[LiveViewExtAbilityUtil]';

export class LiveViewExtAbilityUtil {
  // Singleton pattern implementation
  private static instance: LiveViewExtAbilityUtil;
  private subscriber: commonEventManager.CommonEventSubscriber | null;

  // Private constructor for singleton pattern
  private constructor() {
    this.subscriber = null;
  }

  // Singleton accessor method
  public static getInstance(): LiveViewExtAbilityUtil {
    // Lazy initialization of the singleton instance
    if (!LiveViewExtAbilityUtil.instance) {
      LiveViewExtAbilityUtil.instance = new LiveViewExtAbilityUtil();
    }
    return LiveViewExtAbilityUtil.instance;
  }

  public setSession(session: UIExtensionContentSession): void {
    // Window size listener.
    try {
      session.getUIExtensionWindowProxy().on('windowSizeChange', (windowSize: window.Size) => {
        LiveViewExtAbilityUtil.updateBreakPoint(windowSize);
      });
    } catch (error) {
      Logger.error(TAG,
        `Session update break point failed. code: ${(error as BusinessError).code} message is ${(error as BusinessError).message}`);
    }
    LiveViewExtAbilityUtil.getInstance().createSubscriber();
  }

  public destroySubscribe(): void {
    commonEventManager.unsubscribe(this.subscriber, () => {
      this.subscriber = null;
    });
  }

  private createSubscriber(): void {
    // Initialize event subscription.
    let bundleName: string = LiveViewExtAbilityUtil.getBundleName();
    let subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: ['live_view_lock_screen'],
      publisherBundleName: bundleName,
      priority: 0,
    };
    commonEventManager.createSubscriber(subscribeInfo,
      (error: BusinessError, data: commonEventManager.CommonEventSubscriber) => {
        if (error) {
          Logger.error(TAG, `Failed to create subscriber. code is ${error.code} message is ${error.message}.`);
          return;
        }
        this.subscriber = data;
        Logger.info(TAG, 'Succeeded in creating subscriber.');
        // Event handling logic.
        commonEventManager.subscribe(this.subscriber,
          async (error: BusinessError, data: commonEventManager.CommonEventData) => {
            if (error) {
              Logger.error(TAG, `Failed to subscribe commonEvent. code is ${error.code} message is ${error.message}.`);
              return;
            }
            Logger.info(TAG, 'Succeeded in subscribe commonEvent success.');
            if (data.parameters) {
              let laneData = data.parameters['laneData'] as LaneData;
              AppStorage.setOrCreate(Constants.KEY_PREFIX + 'LaneData', laneData);
              Logger.info(TAG, 'Succeeded in receive commonEvent.');
            }
          });
      })
  }

  // Distinguish page layout using vertical breakpoints.
  private static updateBreakPoint(windowSize: window.Size): void {
    try {
      let windowWidthVp: number = windowSize.width / display.getDefaultDisplaySync().densityPixels;
      let windowHeightVp: number = windowSize.height / display.getDefaultDisplaySync().densityPixels;
      let windowRatio: number = windowWidthVp / windowHeightVp;
      let currentHeightBreakpoint: string = BreakpointTypeEnum.SM;
      // Vertical breakpoints are distinguished by aspect ratio.
      if (windowRatio < 0.8) {
        currentHeightBreakpoint = BreakpointTypeEnum.SM;
      } else if (windowRatio > 1.2) {
        currentHeightBreakpoint = BreakpointTypeEnum.LG;
      } else {
        currentHeightBreakpoint = BreakpointTypeEnum.MD;
      }
      AppStorage.setOrCreate(Constants.KEY_PREFIX + 'CurrentHeightBreakpoint', currentHeightBreakpoint);
      Logger.info(TAG, 'updateBreakpoint');
    } catch (error) {
      Logger.error(TAG,
        `updateBreakpoint catch. code is ${(error as BusinessError).code} message is ${(error as BusinessError).message}`)
      ;
    }
  }

  private static getBundleName(): string {
    let bundleName: string = '';
    try {
      bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT).then((data) => {
        bundleName = data.name;
        Logger.info(TAG, 'getBundleInfoForSelf successfully.');
      }).catch((error: BusinessError) => {
        Logger.error(TAG,
          `getBundleInfoForSelf failed. code is ${error.code} message is ${error.message}`);
      });
    } catch (error) {
      Logger.error(TAG,
        `getBundleInfoForSelf failed. code is ${(error as BusinessError).code} message is ${(error as BusinessError).message}`);
    }
    Logger.info(TAG, 'Ability onCreate');
    return bundleName;
  }
}