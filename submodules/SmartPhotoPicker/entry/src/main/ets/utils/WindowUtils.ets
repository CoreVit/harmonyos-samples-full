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
import { display, window } from '@kit.ArkUI';
import Logger from './Logger';
import { CommonConstants } from '../common/CommonConstants';

const TAG = '[WindowUtil]';

export enum ImmersiveType {
  NORMAL,
  IMMERSIVE
}

export class WindowUtil {
  private static instance: WindowUtil;
  private windowStage?: window.WindowStage;
  private mainWindowClass?: window.Window;

  private constructor() {
  }

  static getInstance(): WindowUtil | undefined {
    if(!WindowUtil.instance) {
      WindowUtil.instance = new WindowUtil();
    }
    return WindowUtil.instance;
  }

  setWindowStage(windowStage: window.WindowStage): void {
    this.windowStage = windowStage;
    this.windowStage.getMainWindow((err, windowClass: window.Window) => {
      if (err.code) {
        Logger.error(TAG, `Failed to obtain the main window. Code:${err.code}, message:${err.message}`);
        return;
      }
      this.mainWindowClass = windowClass;
      this.updateWidthBp();
      try {
        AppStorage.setOrCreate(CommonConstants.KEY_WINDOW_CLASS, windowClass);
        AppStorage.setOrCreate(CommonConstants.KEY_WINDOW_WIDTH, windowClass.getWindowProperties().windowRect.width);
      } catch (error) {
        let err = error as BusinessError;
        Logger.error(TAG, `getWindowProperties failed, code = ${err.code}, message = ${err.message}`);
      }
      windowClass.on('windowSizeChange', this.onWindowSizeChange);
    });
  }

  updateWidthBp(): void {
    if(!this.mainWindowClass) {
      return;
    }
    try {
      let mainWindow: window.WindowProperties = this.mainWindowClass.getWindowProperties();
      let windowWidth: number = mainWindow.windowRect.width;
      let windowWidthVp = windowWidth / (display.getDefaultDisplaySync().densityDPI / 160);
      let widthBp: string = '';
      if (windowWidthVp < 320) {
        widthBp = 'xs';
      } else if (windowWidthVp >= 320 && windowWidthVp < 600) {
        widthBp = 'sm';
      } else if (windowWidthVp >= 600 && windowWidthVp < 840) {
        widthBp = 'md';
      } else {
        widthBp = 'lg';
      }
      AppStorage.setOrCreate(CommonConstants.KEY_WIDTH_BP, widthBp);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `getDefaultDisplaySync failed, code = ${err.code}, message = ${err.message}`);
    }
  }

  setImmersiveType(type: ImmersiveType) {
    if(!this.mainWindowClass) {
      return;
    }
    try {
      if (type === ImmersiveType.NORMAL) {
        this.mainWindowClass.setWindowDecorVisible(true);
      } else if (type === ImmersiveType.IMMERSIVE) {
        // Set window decor visible
        this.mainWindowClass.setWindowDecorVisible(false);
        // Set window decor height
        this.mainWindowClass.setWindowDecorHeight(56);
        // Set window decor button style
        this.mainWindowClass.setDecorButtonStyle({ buttonIconSize: 24 });
      }
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to set immersive type. Code: ${err.code}, message: ${err.message}`);
    }
  }

  public onWindowSizeChange: (windowSize: window.Size) => void = (windowSize: window.Size) => {
    this.updateWidthBp();
    AppStorage.setOrCreate(CommonConstants.KEY_WINDOW_WIDTH, windowSize.width);
  };

  release(): void {
    if (this.mainWindowClass) {
      this.mainWindowClass.off('windowSizeChange', this.onWindowSizeChange);
    }
  }
}