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

import { liveViewManager } from '@kit.LiveViewKit';
import { common, Want, wantAgent } from '@kit.AbilityKit';
import type { WantAgent } from '@kit.AbilityKit';
import { Logger } from 'multitravelbase/Index';
import { LiveConstants } from '../constants/LiveConstants';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = 'LiveViewController';

export class LiveViewController {
  private sequence: number = 0;

  /**
   * Start the live view.
   * @returns
   */
  public async startLiveView(context: common.UIAbilityContext): Promise<liveViewManager.LiveViewResult> {
    if (!await LiveViewController.isLiveViewEnabled()) {
      throw new Error('Live view is disabled.');
    }
    try {
      const liveView: liveViewManager.LiveView = await this.buildDefaultView(context);
      const result: liveViewManager.LiveViewResult = await liveViewManager.startLiveView(liveView);
      LiveViewController.checkLiveViewResult('start', result);
      return result;
    } catch (error) {
      let err = error as BusinessError;
      if (err.code === LiveConstants.LIVE_VIEW_ALREADY_EXISTS) {
        Logger.warn(TAG, 'Live view already exists, update it instead.');
        return await this.updateLiveView(context);
      }
      Logger.error(TAG, `startLiveView failed, error code=${err.code}, message=${err.message}`);
      throw error as Error;
    }
  }

  /**
   * Update the live view.
   * @returns
   */
  public async updateLiveView(context: common.UIAbilityContext): Promise<liveViewManager.LiveViewResult> {
    if (!await LiveViewController.isLiveViewEnabled()) {
      throw new Error('Live view is disabled.');
    }
    try {
      const result: liveViewManager.LiveViewResult = await liveViewManager.updateLiveView(await this.buildDefaultView(context));
      LiveViewController.checkLiveViewResult('update', result);
      return result;
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `updateLiveView failed, error code=${err.code}, message=${err.message}`);
      throw error as Error;
    }
  }

  /**
   * Build the default live view.
   * @returns
   */
  // [Start build_default_view]
  private async buildDefaultView(context: common.UIAbilityContext): Promise<liveViewManager.LiveView> {
    const liveViewTitle: string = LiveViewController.getString(context, LiveConstants.LIVE_VIEW_TITLE);
    const liveViewContent: string = LiveViewController.getString(context, LiveConstants.LIVE_VIEW_CONTENT);
    const liveViewDestination: string = LiveViewController.getString(context, LiveConstants.LIVE_VIEW_DESTINATION);
    const capsuleTitle: string = LiveViewController.getString(context, LiveConstants.CAPSULE_TITLE);
    const capsuleContent: string = LiveViewController.getString(context, LiveConstants.CAPSULE_CONTENT);
    const clickAction: WantAgent | undefined = await LiveViewController.buildWantAgent(context);
    if (!clickAction) {
      throw new Error('Build live view click action failed.');
    }

    return {
      id: LiveConstants.LIVE_VIEW_ID,
      event: 'NAVIGATION',
      sequence: ++this.sequence,
      liveViewData: {
        primary: {
          title: liveViewTitle,
          content: [
            {
              text: liveViewContent,
            },
            {
              text: liveViewDestination,
              textColor: LiveConstants.LIVE_VIEW_DISTANCE_COLOR
            }
          ],
          keepTime: LiveConstants.TIME,
          clickAction,
          layoutData: {
            layoutType: liveViewManager.LayoutType.LAYOUT_TYPE_NAVIGATION,
            currentNavigationIcon: "big_left_arrow.png",
            navigationIcons: ["left_arrow.png", "straight_arrow.png", "straight_arrow.png", "right_arrow.png"]
          }
        },
        capsule: {
          type: liveViewManager.CapsuleType.CAPSULE_TYPE_TEXT,
          status: 1,
          icon: LiveConstants.CAPSULE_ICON,
          backgroundColor: LiveConstants.CAPSULE_COLOR,
          title: capsuleTitle,
          content: capsuleContent
        }
      }
    };
  }

  // [End build_default_view]
  private async buildStopView(context: common.UIAbilityContext): Promise<liveViewManager.LiveView> {
    const liveView: liveViewManager.LiveView = await this.buildDefaultView(context);
    if (liveView.liveViewData.capsule) {
      liveView.liveViewData.capsule.status = -1;
    }
    return liveView;
  }

  private static checkLiveViewResult(action: string, result: liveViewManager.LiveViewResult): void {
    if (result.resultCode === 0) {
      Logger.info(TAG, `${action} live view success, message=${result.message}`);
      return;
    }
    Logger.error(TAG, `${action} live view partially failed, resultCode=${result.resultCode}, message=${result.message}`);
    throw new Error(`${action} live view failed, resultCode=${result.resultCode}`);
  }

  private static getString(context: common.UIAbilityContext, resource: Resource): string {
    try {
      return context.resourceManager.getStringSync(resource.id);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `getStringSync failed, error code=${err.code}, message=${err.message}`);
      return '';
    }
  }

  /**
   * Judge if the live view in enabled.
   * @returns
   */
  private static async isLiveViewEnabled(): Promise<boolean> {
    try {
      return await liveViewManager.isLiveViewEnabled();
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `isLiveViewEnabled failed, error code=${err.code}, message=${err.message}`);
      return false;
    }
  }

  /**
   * Build the want agent.
   * @returns
   */
  private static async buildWantAgent(context: common.UIAbilityContext): Promise<WantAgent | undefined> {
    const wantAgentInfo: wantAgent.WantAgentInfo = {
      wants: [
        {
          bundleName: context.abilityInfo.bundleName,
          abilityName: context.abilityInfo.name,
          moduleName: context.abilityInfo.moduleName,
        } as Want
      ],
      actionType: wantAgent.OperationType.START_ABILITIES,
      requestCode: 0,
      actionFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
    };
    try {
      const agent = await wantAgent.getWantAgent(wantAgentInfo);
      return agent;
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `getWantAgent failed, error code=${err.code}, message=${err.message}`);
      return undefined;
    }
  }

  /**
   * Stop the live view.
   * @returns
   */
  public async stopLiveView(context: common.UIAbilityContext): Promise<liveViewManager.LiveViewResult> {
    try {
      const result: liveViewManager.LiveViewResult = await liveViewManager.stopLiveView(await this.buildStopView(context));
      LiveViewController.checkLiveViewResult('stop', result);
      this.sequence = 0;
      return result;
    } catch (error) {
      let err = error as BusinessError;
      if (err.code === LiveConstants.LIVE_VIEW_NOT_EXISTS) {
        Logger.warn(TAG, 'Live view does not exist, skip stop.');
        this.sequence = 0;
        return {
          resultCode: 0,
          message: 'Live view does not exist.'
        };
      }
      Logger.error(TAG, `stopLiveView failed, error code=${err.code}, message=${err.message}`);
      throw error as Error;
    }
  }
}

export default new LiveViewController();
