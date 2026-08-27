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

import { stylusInteraction } from '@kit.Penkit';
import Logger from '../utils/Logger';
import { FloatWindowManager } from '../common/FloatingWindowsManager';
import { window } from '@kit.ArkUI';
import { bundleManager } from '@kit.AbilityKit';
import { ApiChecker } from '../utils/ApiChecker';
import { BusinessError } from '@ohos.base';
import { emitter } from '@kit.BasicServicesKit';
import { Constants } from '../common/Constants';


const TAG = 'WaveWheelController';

export interface WaveWheelPosition {
  x: number; // vp
  y: number; // vp
}

export type WaveWheelCallback = (id: string, x: number, y: number) => void;

export interface WaveWheelOption {
  id: string;
  title: string | Resource;
  icon: Resource;
  useSysImg?: boolean;
  enable?: boolean | (() => boolean);
  callback: WaveWheelCallback;
}

export interface SimpleWaveWheelOption {
  id: string;
  title: string | Resource;
  icon: Resource;
  useSysImg?: boolean;
  enable?: boolean | (() => boolean);
}


function defaultCallback(_: stylusInteraction.SqueezeEvent): void {

}

function forbiddenSystemWavewheelCallback(_: stylusInteraction.SqueezeEvent): void {
  Logger.debug(TAG, `ignore because forbidden`);
}


export class WaveWheelController {
  private static instance: WaveWheelController | null = null;
  private x: number = -1;
  private y: number = -1;
  private status: boolean = false;
  private forbiddenStatus: boolean = false;
  private uiContext: UIContext | undefined = undefined;
  private waveWheelOptions: WaveWheelOption[] = [];
  private darkMode: boolean = false;
  private floatWindowManager: FloatWindowManager | null = null;
  private windowStage: window.WindowStage | null = null;
  private debug: boolean = false;
  private disableReasons: Set<string> = new Set<string>();
  private boundSqueezeCallback: ((event: stylusInteraction.SqueezeEvent) => void) | null = null;
  private callback: (event: stylusInteraction.SqueezeEvent) => void = defaultCallback;
  private emptyOptionCallback: (event: stylusInteraction.SqueezeEvent) => void = defaultCallback;

  public addDisableReason(reason: string): void {
    this.disableReasons.add(reason);
  }

  public removeDisableReason(reason: string): void {
    this.disableReasons.delete(reason);
  }

  public cleanDisableReasons(): void {
    this.disableReasons.clear();
  }

  public forbiddenSystemWavewheel(): void {
    if (ApiChecker.canUseWaveWheel() === false) {
      return;
    }
    if (this.forbiddenStatus) {
      Logger.debug(TAG, `stylus already forbidden succ`);
      return;
    }
    this.forbiddenStatus = true;
    try {
      stylusInteraction.on('squeeze', forbiddenSystemWavewheelCallback);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `forbiddenSystemWavewheel fail error ${err.code}: ${err.message}`);
    }
  }

  public unForbiddenSystemWavewheel(): void {
    if (ApiChecker.canUseWaveWheel() === false) {
      return;
    }
    if (this.forbiddenStatus === false) {
      Logger.debug(TAG, `stylus already unforbidden succ`);
      return;
    }
    this.forbiddenStatus = false;
    try {
      stylusInteraction.off('squeeze', forbiddenSystemWavewheelCallback);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `unForbiddenSystemWavewheel fail error ${err.code}: ${err.message}`);
    }
  }


  public static getInstance(): WaveWheelController {
    if (!WaveWheelController.instance) {
      WaveWheelController.instance = new WaveWheelController();
    }
    return WaveWheelController.instance;
  }

  public setDebug(debug: boolean): void {
    this.debug = debug;
  }

  public getDebug(): boolean {
    return this.debug;
  }

  public setEmptyOptionCallback(callback: (event: stylusInteraction.SqueezeEvent) => void): void {
    this.emptyOptionCallback = callback;
  }

  public init(windowStage: window.WindowStage): void {

    try {
      let bundleInfo = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT);
      let bundleName = bundleInfo.name;
      this.windowStage = windowStage;
      this.floatWindowManager = new FloatWindowManager(bundleName, this.windowStage);
      this.floatWindowManager.setController(this);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `getBundleInfoForSelfSync failed ${err.code}: ${err.message}`);
    }

    emitter.on({
      eventId: Constants.DISABLE_EVENT_ID
    }, this.emitterCallback);
  }

  public terminate(): void {
    emitter.off(Constants.DISABLE_EVENT_ID, this.emitterCallback);
  }

  private constructor() {
  }

  public setWaveWheelOptions(options: WaveWheelOption[]): number {
    this.waveWheelOptions = options.slice(0, 4);
    return options.length;
  }

  public setWaveWheelOptionsBySimple(options: SimpleWaveWheelOption[],
    callbacks: Map<string, WaveWheelCallback>): number {
    let waveWheelOptions: WaveWheelOption[] = [];
    for (let i = 0; i < options.length; ++i) {
      let opt: SimpleWaveWheelOption = options[i];
      let callback = callbacks.get(opt.id);
      if (callback === undefined) {
        continue;
      }
      waveWheelOptions.push({
        id: opt.id,
        title: opt.title,
        icon: opt.icon,
        useSysImg: opt.useSysImg,
        enable: opt.enable,
        callback: callback
      });
      if (waveWheelOptions.length === 4) {
        break;
      }
    }
    this.waveWheelOptions = waveWheelOptions;
    return this.waveWheelOptions.length;
  }

  public updatePosition(position: WaveWheelPosition): void {
    this.x = position.x;
    this.y = position.y;
  }

  public getDarkMode(): boolean {
    return this.darkMode;
  }

  public setDarkMode(darkMode: boolean): void {
    if (this.darkMode === darkMode) {
      return;
    }
    this.floatWindowManager?.destroyFloatWindow().catch((err: BusinessError) => {
      Logger.error(TAG, `Failed to destory float window, error ${err.code}: ${err.message}`);
    });
    this.darkMode = darkMode;
  }


  public getPosition(): WaveWheelPosition {
    return ({ x: this.x, y: this.y } as WaveWheelPosition);
  }

  public addWaveWheelOption(option: WaveWheelOption): number {
    for (let i: number = 0; i < this.waveWheelOptions.length; ++i) {
      if (this.waveWheelOptions[i].id === option.id) {
        return 0;
      }
    }
    this.waveWheelOptions.push(option);
    if (this.waveWheelOptions.length > 4) {
      this.waveWheelOptions.shift();
    }
    return 1;
  }

  public addWaveWheelOptions(options: WaveWheelOption[]): number {
    let uniqOptionNum = 0;
    for (let i = 0; i < options.length; ++i) {
      uniqOptionNum += this.addWaveWheelOption(options[i]);
    }
    return uniqOptionNum;
  }


  public deleteWaveWheelOption(id: string): number {
    let pos = -1;
    for (let i = 0; i < this.waveWheelOptions.length; ++i) {
      if (this.waveWheelOptions[i].id === id) {
        pos = i;
        break;
      }
    }
    if (pos < 0) {
      return 0;
    }
    this.waveWheelOptions.splice(pos, 1);
    Logger.info(TAG, `deleteWaveWheelOption succ size=${this.waveWheelOptions.length}`);
    return 1;
  }

  public emptyWaveWheelOption(): number {
    let ret = this.waveWheelOptions.length;
    this.waveWheelOptions.splice(0);
    return ret;
  }

  public getWaveWheelOptions(): WaveWheelOption[] {
    return this.waveWheelOptions;
  }

  public setCallback(callback: (event: stylusInteraction.SqueezeEvent) => void): void {
    this.callback = callback;
  }

  private squeezeCallback = async (event: stylusInteraction.SqueezeEvent): Promise<void> => {
    if (this.disableReasons.size > 0) {
      Logger.debug(TAG,
        `squeeze intercepted, wavewheel is currently disabled. reaons: ${Array.from(this.disableReasons).join(',')}`);
      try {
        this.uiContext?.getPromptAction().showToast({
          message: $r('app.string.scene_not_support_wheel'),
          duration: 2000,
          alignment: Alignment.Center
        });
      } catch (error) {
        const err: BusinessError = error as BusinessError;
        Logger.error(TAG, `fail to showToast, error ${err.code}: ${err.message}`);
      }
      return;
    }
    if (this.waveWheelOptions.length < 1) {
      Logger.debug(TAG, `waveWheelOptions is empty`);
      this.emptyOptionCallback(event);
      return;
    }
    Logger.info(TAG, `got squeeze`);
    if (this.floatWindowManager !== null) {
      if (this.floatWindowManager.getSubWindow() === null) {
        await this.floatWindowManager.createFloatWindow();
        Logger.debug(TAG, `createFloatWindow succ`);

      } else {
        emitter.emit({
          eventId: Constants.HANDPAN_SQUEEZE_EVENT_ID,
          priority: emitter.EventPriority.HIGH
        }
        );
        Logger.debug(TAG, `emit HANDPAN_SQUEEZE_EVENT_ID succ`);
      }

    } else {
      Logger.error(TAG, `floatWindowManager is null`);
    }
    this.callback(event);
  };

  public start(): void {
    if (ApiChecker.canUseWaveWheel() === false) {
      return;
    }
    if (this.status) {
      Logger.debug(TAG, `stylus already listen succ`);
      return;
    }

    if (this.windowStage === null) {
      Logger.error(TAG, `init first`);
    }
    this.status = true;
    this.cleanDisableReasons();
    try {
      this.boundSqueezeCallback = this.squeezeCallback;
      stylusInteraction.on('squeeze', this.boundSqueezeCallback);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `sytlus listen fail error ${err.code}: ${err.message}`);
    }
  }

  public stop(): void {
    if (ApiChecker.canUseWaveWheel() === false) {
      return;
    }
    this.status = false;
    try {
      if (this.boundSqueezeCallback) {
        stylusInteraction.off('squeeze', this.boundSqueezeCallback);
        this.boundSqueezeCallback = null;
      }
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `off squeeze event fail error ${err.code}: ${err.message}`);
    }
    if (this.floatWindowManager !== null) {
      if (this.floatWindowManager.getSubWindow() !== null) {
        this.floatWindowManager.destroyFloatWindow().then(() => {
          Logger.debug(TAG, `destroyFloatWindow succ`);
        })
          .catch((err: BusinessError) => {
            Logger.error(TAG, `destory window failed, error ${err.code}: ${err.message}`);
          })
      }
    }
  }

  public async testShow(): Promise<void> {
    let event: stylusInteraction.SqueezeEvent = { timestamp: new Date().getTime() };
    await this.squeezeCallback(event);
  }

  public getStatus(): boolean {
    return this.status;
  }

  private emitterCallback(eventData: emitter.EventData) {
    if (eventData.data?.action === Constants.ADD_DISABLE_ACTION) {
      this.addDisableReason(eventData.data?.reason);
    } else if (eventData.data?.action === Constants.REMOVE_DISABLE_ACTION) {
      this.removeDisableReason(eventData.data?.reason);
    }
  }
}
