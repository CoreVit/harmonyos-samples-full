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

import window from '@ohos.window';
import { BusinessError } from '@ohos.base';
import Logger from '../utils/Logger';
import { WaveWheelController } from '../controllers/WaveWheelController';
import { Constants } from './Constants';

const TAG = 'FloatWindowManager';

export class FloatWindowManager {
  private windowStage: window.WindowStage | null = null;
  private subWindow: window.Window | null = null;
  private packageName: string | null = null;
  private controller: WaveWheelController | null = null;

  constructor(packageName: string, windowStage: window.WindowStage) {
    this.windowStage = windowStage;
    this.packageName = packageName;
  }

  public setController(controller: WaveWheelController): void {
    this.controller = controller;
  }


  // Recommend using Promise style for clarity
  async createFloatWindow(): Promise<void> {
    if (this.packageName === null) {
      Logger.debug(TAG, `invalid packageName`);
      return;
    }
    if (!this.windowStage) {
      Logger.error(TAG, `windowStage is null`);
      return;
    }

    if (this.subWindow) {
      Logger.error(TAG, `floatWindow is already exists`);
      return;
    }

    try {
      const subWin = await this.createSubWindowPromise('MyFloatBall');
      this.subWindow = subWin;

      // Set basic properties
      await this.setWindowLayoutFullScreen(subWin);


      subWin.setSubWindowZLevel(Constants.SUB_WINDOW_Z_LEVEL).catch((err: BusinessError) => {
        Logger.error(TAG, `fail to set windows Level, error ${err.code}: ${err.message}`);
      });

      import('../pages/WaveWheelPage')
        .then(() => {
          let storage = new LocalStorage();
          storage.setOrCreate('floatMgr', this);
          storage.setOrCreate('currentSubWindow', subWin);
          if (this.controller) {
            storage.setOrCreate('waveWheelController', this.controller);
          }

          subWin.loadContentByName(Constants.WAVEWHEEL_PAGE_ROUTER, storage)
            .then(() => {
              subWin.setWindowBackgroundColor('#00000000');
              subWin.showWindow().catch((err: BusinessError) => {
                Logger.error(TAG, `subWin fail to showWindow, error ${err.code}: ${err.message}`);
              });
              Logger.debug(TAG, `windows show succ`);


              const props = subWin.getWindowProperties();
              const rect = props.windowRect;

              const windowWidth = rect.width; // unit: px
              const windowHeight = rect.height; // unit: px

              Logger.debug(TAG, `Actual window size: width=${windowWidth}px, height=${windowHeight}px`);
            }).catch((err: BusinessError) => {
            Logger.error(TAG, `subwin loadContentByName failed, error ${err.code}: ${err.message}`);
          });
          subWin.setWindowFocusable(false)
            .catch((err: BusinessError) => {
              Logger.error(TAG, `subwin setWindowFocusable failed, error ${err.code}: ${err.message}`);
            });
        })
        .catch((err: BusinessError) => {
          Logger.error(TAG, `import WaveWheelPage failed, error ${err.code}: ${err.message}`);
        })
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `float window show failed, error ${err.code}: ${err.message}`);
      if (this.subWindow) {
        try {
          await this.subWindow.destroyWindow();
        } catch (errorInner) {
          const errInner: BusinessError = errorInner as BusinessError;
          Logger.error(TAG, `Destory window failed, error ${errInner.code}: ${errInner.message}`);
        }
        this.subWindow = null;
      }
    }
  }

  private createSubWindowPromise(name: string): Promise<window.Window> {
    return new Promise((resolve, reject) => {
      if (!this.windowStage) {
        return reject(`@FloatingWindowsManager windowStage is null.`);
      }
      this.windowStage.createSubWindow(name, (err: BusinessError, win: window.Window) => {
        if (err.code) {
          reject(err);
        } else {
          resolve(win);
        }
      });
    });
  }

  private setWindowLayoutFullScreen(win: window.Window): Promise<void> {
    return new Promise((resolve, reject) => {
      win.setWindowLayoutFullScreen(true).then(() => {
        resolve();
      }).catch((err: BusinessError) => {
        reject(err);
      });
    });
  }


  // Destroy
  async destroyFloatWindow(): Promise<void> {
    try {
      await this.subWindow?.destroyWindow();
      Logger.debug(TAG, `destory window succ`);
      this.subWindow = null;
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `destory window failed, error ${err.code}: ${err.message}`);
    }
  }

  // Get the current sub-window (for external drag, move, and other operations)
  getSubWindow(): window.Window | null {
    return this.subWindow;
  }
}
