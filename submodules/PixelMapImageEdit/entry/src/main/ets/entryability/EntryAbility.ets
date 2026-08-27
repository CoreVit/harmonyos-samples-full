/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
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
import { display, window } from '@kit.ArkUI';
import { BusinessError, deviceInfo } from '@kit.BasicServicesKit';
import { CommonConstants } from '../common/constant/CommonConstants';
import Logger from '../utils/Logger';


export default class EntryAbility extends UIAbility {
  private curBp: string = '';

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      Logger.error(`setColorMode failed: ${JSON.stringify(err)}`);
    }
  }

  private updateBreakpoint(windowWidth: number): void {
    try {
      let windowWidthVp = windowWidth / display.getDefaultDisplaySync().densityPixels;
      let newBp: string = '';
      if (windowWidthVp < 600) {
        newBp = 'sm';
      } else if (windowWidthVp < 840) {
        newBp = 'md';
      } else {
        newBp = 'lg';
      }
      if (this.curBp !== newBp) {
        this.curBp = newBp;
        AppStorage.setOrCreate(CommonConstants.BREAKPOINT_KEY, this.curBp);
      }
    } catch (error) {
      Logger.error(`getDefaultDisplaySync failed, code = ${error.code}, message = ${error.message}`);
    }
  }

  private updateFoldedState(windowObj: window.Window): void {
    try {
      const windowHeight = windowObj.getWindowProperties().windowRect.height;
      const windowHeightVp = windowHeight / display.getDefaultDisplaySync().densityPixels;
      const isFolded = windowHeightVp < 350;
      AppStorage.setOrCreate(CommonConstants.IS_FOLDED, isFolded);
    } catch (error) {
      Logger.error('EntryAbility', `Failed to update folded state: ${JSON.stringify(error)}`);
    }
  }

  private updateSafeArea(windowObj: window.Window): void {
    try {
      let type = window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR;
      let avoidArea = windowObj.getWindowAvoidArea(type);
      const bottomHeight = avoidArea.bottomRect.height;
      AppStorage.setOrCreate(CommonConstants.AVOID_AREA_BOTTOM, bottomHeight);

      type = window.AvoidAreaType.TYPE_SYSTEM;
      avoidArea = windowObj.getWindowAvoidArea(type);
      const topHeight = avoidArea.topRect.height;
      AppStorage.setOrCreate(CommonConstants.AVOID_AREA_TOP, topHeight);

      Logger.info('EntryAbility', `Safe area updated: top=${topHeight}, bottom=${bottomHeight}`);
    } catch (error) {
      Logger.error('EntryAbility', `Failed to get safe area: ${JSON.stringify(error)}`);
    }
  }

  onDestroy(): void {
    Logger.info('EntryAbility', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    Logger.info('EntryAbility', 'Ability onWindowStageCreate');
    try {
      const windowObj = windowStage.getMainWindowSync();
      windowObj.setWindowLayoutFullScreen(true).then(() => {
        Logger.info('EntryAbility', 'Succeeded in setting window layout full screen');
        this.updateSafeArea(windowObj);
      }).catch((err: BusinessError) => {
        Logger.error('EntryAbility', `Failed to set window layout full screen. Cause: ${JSON.stringify(err)}`);
      });
      this.updateBreakpoint(windowObj.getWindowProperties().windowRect.width);
      windowObj.on('windowSizeChange', (windowSize) => {
        this.updateBreakpoint(windowSize.width);
        this.updateSafeArea(windowObj);
        this.updateFoldedState(windowObj);
      });
      windowObj.on('avoidAreaChange', (data) => {
        if (data.type === window.AvoidAreaType.TYPE_SYSTEM) {
          AppStorage.setOrCreate(CommonConstants.AVOID_AREA_TOP, data.area.topRect.height);
        } else if (data.type === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
          AppStorage.setOrCreate(CommonConstants.AVOID_AREA_BOTTOM, data.area.bottomRect.height);
        }
      });

      const deviceTypeInfo: string = deviceInfo.deviceType;
      const isPCDevice = deviceTypeInfo === deviceInfo.DeviceTypes.TYPE_2IN1;
      AppStorage.setOrCreate(CommonConstants.IS_PC_DEVICE, isPCDevice);

      this.updateFoldedState(windowObj);

    } catch (error) {
      Logger.error('EntryAbility', `Failed to initialize window settings: ${JSON.stringify(error)}`);
    }
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        Logger.error('EntryAbility', `Failed to load the content. Cause: ${JSON.stringify(err)}`);
        return;
      }

      Logger.info('EntryAbility', 'Succeeded in loading the content.');

      try {
        const windowObj = windowStage.getMainWindowSync();
        const deviceTypeInfo: string = deviceInfo.deviceType;
        const isPCDevice = deviceTypeInfo === deviceInfo.DeviceTypes.TYPE_2IN1;
        if (isPCDevice) {
          windowObj.setWindowDecorVisible(false);
          windowObj.setWindowTitleButtonVisible(false, false, false);
        }
      } catch (err) {
        Logger.error('EntryAbility', `Failed to set window decor: ${JSON.stringify(err)}`);
      }
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    Logger.info('EntryAbility', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    Logger.info('EntryAbility', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    Logger.info('EntryAbility', 'Ability onBackground');
  }
}