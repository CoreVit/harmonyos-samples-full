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

import { ConfigurationConstant } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { CommonConstants } from '../constants/CommonConstants';
import Logger from './Logger';
import { WindowUtil } from './WindowUtil';

const TAG = '[SetDecorStyleUtil]';

export class SetDecorButtonStyleUtil {
  static persistApplicationColorMode(colorMode: ConfigurationConstant.ColorMode): void {
    AppStorage.setOrCreate(CommonConstants.APPLICATION_COLOR_MODE, colorMode);
  }

  private static resolveColorMode(context: common.UIAbilityContext): ConfigurationConstant.ColorMode | undefined {
    const stored = AppStorage.get<ConfigurationConstant.ColorMode>(CommonConstants.APPLICATION_COLOR_MODE);
    return stored !== undefined ? stored : context.config.colorMode;
  }

  static setDecorButtonForImmersive(currentTopIndex: number, pageInfo: NavPathStack,
    windowUtil: WindowUtil | undefined, context: common.UIAbilityContext): void {
    let colorMode = SetDecorButtonStyleUtil.resolveColorMode(context);
    try {
      if (currentTopIndex === CommonConstants.COMMUNITY_TOP_INDEX && pageInfo.getAllPathName().length === 0) {
        windowUtil?.mainWindow.setDecorButtonStyle({
          colorMode: ConfigurationConstant.ColorMode.COLOR_MODE_DARK
        });
      } else {
        windowUtil?.mainWindow.setDecorButtonStyle({
          colorMode: colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ?
            ConfigurationConstant.ColorMode.COLOR_MODE_DARK : ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT
        });
      }
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to setDecorButtonStyle, errCode = ${err.code}, errMessage = ${err.message}.`);
    }
  }

  static setDecorButtonForNormal(windowUtil: WindowUtil | undefined, context: common.UIAbilityContext): void {
    let colorMode = SetDecorButtonStyleUtil.resolveColorMode(context);
    try {
      windowUtil?.mainWindow.setDecorButtonStyle({
        colorMode: colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ?
          ConfigurationConstant.ColorMode.COLOR_MODE_DARK : ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT
      });
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to setDecorButtonStyle, errCode = ${err.code}, errMessage = ${err.message}.`);
    }
  }

  static setDecorButtonForDark(windowUtil: WindowUtil | undefined): void {
    try {
      windowUtil?.mainWindow.setDecorButtonStyle({
        colorMode: ConfigurationConstant.ColorMode.COLOR_MODE_DARK
      });
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to setDecorButtonStyle, errCode = ${err.code}, errMessage = ${err.message}.`);
    }
  }
}