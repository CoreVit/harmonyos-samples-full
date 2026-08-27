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

import { AbilityConstant, ConfigurationConstant, UIAbility, Want, Configuration } from '@kit.AbilityKit';
import { display, window } from '@kit.ArkUI';
import { BusinessError, deviceInfo } from '@kit.BasicServicesKit';
import type { SimpleWaveWheelOption } from 'wavewheel';
import { WaveWheelController } from 'wavewheel';
import { CommonConstants } from '../common/constant/CommonConstants';
import WaveWheelConstants from '../common/constant/WaveWheelConstant';
import Logger from '../utils/Logger';
import storageManager from '../utils/StorageManager';
import { StatusBarUtil } from '../utils/StatusBarUtil';


const TAG = `EntryAbility`;

export default class EntryAbility extends UIAbility {
  private curBp: string = '';

  onCreate(_: Want, __: AbilityConstant.LaunchParam): void {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `setColorMode failed, error ${err.code}: ${err.message}`);
    }
  }

  // [Start on_configuration_update]
  onConfigurationUpdate(newConfig: Configuration): void {
    if (newConfig.colorMode !== AppStorage.get(CommonConstants.CURRENT_COLOR_MODE)) {
      AppStorage.setOrCreate(CommonConstants.CURRENT_COLOR_MODE, newConfig.colorMode);
    }
    WaveWheelController.getInstance()
      .setDarkMode(newConfig.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
  }

  // [End on_configuration_update]


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
      Logger.error(TAG, `getDefaultDisplaySync failed, code = ${error.code}, message = ${error.message}`);
    }
  }

  private updateFoldedState(windowObj: window.Window): void {
    try {
      if (windowObj) {
        const windowHeight = windowObj.getWindowProperties().windowRect.height;
        const windowHeightVp = windowHeight / display.getDefaultDisplaySync().densityPixels;
        const isFolded = windowHeightVp < 350;
        AppStorage.setOrCreate(CommonConstants.IS_FOLDED, isFolded);
      }
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `Failed to update folded state, error ${err.code}: ${err.message}`);
    }
  }

  private updateSafeArea(windowObj: window.Window): void {
    try {
      if (windowObj) {
        let type = window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR;
        let avoidArea = windowObj.getWindowAvoidArea(type);
        const bottomHeight = avoidArea.bottomRect.height;
        AppStorage.setOrCreate(CommonConstants.AVOID_AREA_BOTTOM, bottomHeight);

        type = window.AvoidAreaType.TYPE_SYSTEM;
        avoidArea = windowObj.getWindowAvoidArea(type);
        const topHeight = avoidArea.topRect.height;
        AppStorage.setOrCreate(CommonConstants.AVOID_AREA_TOP, topHeight);

        Logger.info(TAG, `Safe area updated: top=${topHeight}, bottom=${bottomHeight}`);
      }
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `Failed to get safe area, error ${err.code}: ${err.message}`);
    }
  }

  onDestroy(): void {
    Logger.info(TAG, 'Ability onDestroy');
  }

  // [Start on_window_stage_create]
  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    Logger.info(TAG, 'Ability onWindowStageCreate');
    try {
      // Initialize StorageManager
      await storageManager.init(this.context);
    } catch (err) {
      // [StartExclude on_window_stage_create]
      const error: BusinessError = err as BusinessError;
      Logger.error(TAG, `Error ${error.code} when creating winowStage: ${error.message}`);
      return;
      // [EndExclude on_window_stage_create]
    }


    // Read data from persistent storage and sync to AppStorage
    // [StartExclude on_window_stage_create]
    const selectedIds = await storageManager.loadSelectedIds();
    const selectedOptions = WaveWheelConstants.waveWheelOptions.filter(
      (option: SimpleWaveWheelOption) => selectedIds.includes(option.id)
    );
    Logger.debug(TAG, `selectedOptions=${selectedOptions.length} selectedIds=${selectedIds.length}`);
    AppStorage.setOrCreate(CommonConstants.KEY_SIMPLE_WAVE_WHEEL_OPTIONS, selectedOptions);
    // [EndExclude on_window_stage_create]
    // [Start controller_init]
    const controller = WaveWheelController.getInstance();
    controller.init(windowStage);
    // [End controller_init]
    WaveWheelController.getInstance()
      .setDarkMode(this.context.config.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
    // [End on_window_stage_create]
    try {
      const windowObj = windowStage.getMainWindowSync();
      windowObj.setWindowLayoutFullScreen(true).then(() => {
        Logger.info(TAG, 'Succeeded in setting window layout full screen');
        this.updateSafeArea(windowObj);
        this.updateBreakpoint(windowObj.getWindowProperties().windowRect.width);
      }).catch((err: BusinessError) => {
        Logger.error(TAG, `Failed to set window layout full screen, error ${err.code}: ${err.message}`);
      });
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
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `Failed to initialize window settings, error ${err.code}: ${err.message}`);
    }
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        Logger.error(TAG, `Failed to load the content, error ${err.code}: ${err.message}`);
        return;
      }
      window.getLastWindow(this.context, (err: BusinessError, windowClass) => {
        if (err.code) {
          return;
        }
        AppStorage.setOrCreate(CommonConstants.WAVE_WHEEL_WINDOW_CLASS, windowClass);
        AppStorage.setOrCreate(CommonConstants.WAVE_WHEEL_WINDOW_STAGE, windowStage);
      })

      Logger.info(TAG, 'Succeeded in loading the content.');

      try {
        const windowObj = windowStage.getMainWindowSync();
        const deviceTypeInfo: string = deviceInfo.deviceType;
        const isPCDevice = deviceTypeInfo === deviceInfo.DeviceTypes.TYPE_2IN1;
        if (isPCDevice) {
          windowObj.setWindowDecorVisible(false);
          windowObj.setWindowTitleButtonVisible(false, false, false);
        }
      } catch (error) {
        const err: BusinessError = error as BusinessError;
        Logger.error(TAG, `Failed to set window decor, error ${err.code}: ${err.message}`);
      }
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    Logger.info(TAG, 'Ability onWindowStageDestroy');
    const controller = WaveWheelController.getInstance();
    controller.terminate();
  }

  onForeground(): void {
    // Ability has brought to foreground
    Logger.info(TAG, 'Ability onForeground');
    StatusBarUtil.setWindowStatusBarProperties();
  }

  onBackground(): void {
    // Ability has back to background
    Logger.info(TAG, 'Ability onBackground');
  }
}