/*
* Copyright (C) 2025 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { url } from '@kit.ArkTS';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { ConfigMapKey, Constants, Logger, ResourceUtil, WindowUtil } from 'gesturessharecommon';

export default class EntryAbility extends UIAbility {
  // [Start onCreate]
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    // [StartExclude onCreate]
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      let error = err as BusinessError;
      Logger.error(Constants.LOG_TAG, `setColorMode failed, error: ${error.code} ${error.message}`);
    }
    Logger.info(Constants.LOG_TAG, 'Ability onCreate');
    // [EndExclude onCreate]
    let videoIndex = this.getVideoIndex(want);
    if (videoIndex !== '') {
      AppStorage.setOrCreate(Constants.KEY_VIDEO_INDEX, Number.parseInt(videoIndex));
      AppStorage.setOrCreate(Constants.KEY_IS_LINK, true);
    }
  }
  // [End onCreate]

  // [Start onNewWant]
  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam) {
    let videoIndex = this.getVideoIndex(want);
    if (videoIndex !== '') {
      AppStorage.setOrCreate(Constants.KEY_VIDEO_INDEX, Number.parseInt(videoIndex));
      AppStorage.setOrCreate(Constants.KEY_IS_LINK, true);
    }
  }
  // [End onNewWant]

  // [Start getVideoIndex]
  private getVideoIndex(want: Want): string {
    try {
      const wantUri = want?.uri;
      let videoIndex: string = '';
      if (wantUri) {
        const shareUrl: string =
          ResourceUtil.getRawFileString(this.context.resourceManager, ConfigMapKey.SHARE_URL) as string;
        const shareUri = url.URL.parseURL(shareUrl);
        const urlObject = url.URL.parseURL(wantUri);
        if (urlObject.protocol !== shareUri.protocol || urlObject.hostname !== shareUri.hostname) {
          Logger.error(Constants.LOG_TAG, `Invalid url`);
          return '';
        }
        videoIndex = urlObject.params.get('videoIndex') as string;
        if (videoIndex === null || videoIndex === undefined || videoIndex === '') {
          Logger.error(Constants.LOG_TAG, 'Missing videoIndex parameter');
          return '';
        }
        const index: number = Number.parseInt(videoIndex);
        if (Number.isNaN(index) || index < Constants.MIN_VIDEO_INDEX || index > Constants.MAX_VIDEO_INDEX) {
          Logger.error(Constants.LOG_TAG, `Invalid videoIndex parameter`);
          return '';
        }
        Logger.info(Constants.LOG_TAG, `getAid aid: ${videoIndex}`);
      }
      return videoIndex;
    } catch (err) {
      let error = err as BusinessError;
      Logger.error(Constants.LOG_TAG, `Failed to getVideoIndex, error: ${error.code} ${error.message}`);
    }
    return '';
  }
  // [End getVideoIndex]

  onDestroy(): void {
    Logger.info(Constants.LOG_TAG, 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    Logger.info(Constants.LOG_TAG, 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err?.code) {
        Logger.error(Constants.LOG_TAG, `Failed to load the content. Cause: ${err.code}, ${err.message}`);
        return;
      }
      WindowUtil.initialize(windowStage);
      Logger.info(Constants.LOG_TAG, 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    WindowUtil.unregisterBreakPoint();
    Logger.info(Constants.LOG_TAG, 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    Logger.info(Constants.LOG_TAG, 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    Logger.info(Constants.LOG_TAG, 'Ability onBackground');
  }
}