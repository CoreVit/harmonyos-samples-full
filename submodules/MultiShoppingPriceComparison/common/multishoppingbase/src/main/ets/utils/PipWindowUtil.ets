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

import { PiPWindow } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import Logger from './Logger';
import { AvPlayerUtil } from './AvPlayerUtil';
import { abilityScopedAppStorageKey } from './AbilityStorageKey';

/** PiP already closed (e.g. user tapped delete on panel); stopPiP is invalid. */
const PIP_STOP_ALREADY_DONE: number = 1300012;
/** Multi-window / split: stopPiP may race or target wrong stage; treat as cleanup-only. */
const PIP_STOP_STATE_MISMATCH: number = 1300015;

export class PipWindowUtil {
  private static readonly storageKey: string = 'MultiShoppingPipWindowUtil';
  private isShowingPip: boolean = false;
  private pipController?: PiPWindow.PiPController = undefined;
  private mXComponentController: XComponentController = new XComponentController();
  private avPlayerUtil: AvPlayerUtil | undefined = undefined;
  /** Serialize stopPip vs onStateChange(STOPPED) to avoid concurrent JsPipController::OnStopPictureInPicture failures. */
  private stopPipChain: Promise<void> = Promise.resolve();

  constructor(uiContext: UIContext) {
    this.avPlayerUtil = AvPlayerUtil.getAvPlayerUtil(uiContext);
  }

  static getPipWindowUtil(uiContext: UIContext): PipWindowUtil | undefined {
    const key = abilityScopedAppStorageKey(uiContext, PipWindowUtil.storageKey);
    if (!AppStorage.get<PipWindowUtil>(key)) {
      AppStorage.setOrCreate(key, new PipWindowUtil(uiContext));
    }
    return AppStorage.get<PipWindowUtil>(key);
  }

  getIsShowingPip(): boolean {
    return this.isShowingPip;
  }

  getPipController(): PiPWindow.PiPController | undefined {
    return this.pipController;
  }

  getXComponentController(): XComponentController {
    return this.mXComponentController;
  }

  async startPip(navId: string, xComponentController: XComponentController, context: Context,
    pageInfos: NavPathStack): Promise<void> {
    if (!canIUse('SystemCapability.Window.SessionManager')) {
      return;
    }
    if (!PiPWindow.isPiPEnabled()) {
      Logger.error('picture in picture disabled for current OS');
      return;
    }
    const config: PiPWindow.PiPConfiguration = {
      context: context,
      componentController: xComponentController,
      navigationId: navId,
      templateType: PiPWindow.PiPTemplateType.VIDEO_LIVE
    };
    PiPWindow.create(config).then((controller: PiPWindow.PiPController) => {
      this.pipController = controller;
      this.initPipController();
      this.pipController.startPiP().then(() => {
        Logger.info('Succeeded in starting pip.');
        if (this.avPlayerUtil === undefined) {
          return;
        }
        this.avPlayerUtil.play();
        pageInfos.pop();
      }).catch((err: BusinessError) => {
        Logger.error(`Failed to start pip. Cause: ${err.code}, message: ${err.message}`);
      });
    }).catch((err: BusinessError) => {
      Logger.error(`Failed to create pip controller. Cause: ${err.code}, message: ${err.message}`);
    });
  }

  private initPipController(): void {
    if (!this.pipController) {
      return;
    }
    if (!canIUse('SystemCapability.Window.SessionManager')) {
      return;
    }
    this.pipController.on('stateChange', (state: PiPWindow.PiPState, reason: string) => {
      this.onStateChange(state, reason);
    });
    this.pipController.on('controlPanelActionEvent', (event: PiPWindow.PiPActionEventType) => {
      this.onActionEvent(event);
    });
  }

  /**
   * Unregister listeners and drop controller reference. Safe when PiP was already closed by the system/user.
   */
  private releasePipCallbacksAndClear(): void {
    const controller = this.pipController;
    if (!controller) {
      return;
    }
    try {
      controller.off('stateChange');
      controller.off('controlPanelActionEvent');
    } catch (exception) {
      Logger.error(`Failed to unregister pip callbacks: ${JSON.stringify(exception)}`);
    }
    this.pipController = undefined;
    this.isShowingPip = false;
  }

  async stopPip(): Promise<void> {
    const task = this.stopPipChain.then(async (): Promise<void> => {
      await this.stopPipSerialized();
    });
    this.stopPipChain = task.catch((): void => {
    });
    return task;
  }

  private async stopPipSerialized(): Promise<void> {
    if (!canIUse('SystemCapability.Window.SessionManager')) {
      return;
    }
    if (!this.pipController) {
      return;
    }
    // User may have closed PiP from the floating panel; state is STOPPED but we had not cleared the ref yet.
    if (!this.isShowingPip) {
      this.releasePipCallbacksAndClear();
      return;
    }
    const controller = this.pipController;
    try {
      await controller.stopPiP();
      Logger.info('Succeeded in stopping pip.');
    } catch (err) {
      const be = err as BusinessError;
      if (be.code === PIP_STOP_ALREADY_DONE || be.code === PIP_STOP_STATE_MISMATCH) {
        Logger.info(`PiP stop finished with benign code ${be.code}, releasing controller.`);
      } else {
        Logger.error(`Failed to stop pip. Cause: ${be.code}, message: ${be.message}`);
      }
    } finally {
      this.releasePipCallbacksAndClear();
    }
  }

  private onStateChange(state: PiPWindow.PiPState, reason: string): void {
    let curState: string = '';
    switch (state) {
      case PiPWindow.PiPState.ABOUT_TO_START:
        curState = 'ABOUT_TO_START';
        break;
      case PiPWindow.PiPState.STARTED:
        curState = 'STARTED';
        this.isShowingPip = true;
        break;
      case PiPWindow.PiPState.ABOUT_TO_STOP:
        curState = 'ABOUT_TO_STOP';
        break;
      case PiPWindow.PiPState.STOPPED:
        curState = 'STOPPED';
        this.isShowingPip = false;
        this.releasePipCallbacksAndClear();
        break;
      case PiPWindow.PiPState.ABOUT_TO_RESTORE:
        curState = 'ABOUT_TO_RESTORE';
        this.isShowingPip = false;
        break;
      case PiPWindow.PiPState.ERROR:
        curState = 'ERROR';
        this.isShowingPip = false;
        this.releasePipCallbacksAndClear();
        break;
      default:
        break;
    }
    Logger.info(`onStateChange: ${curState}, reason: ${reason}`);
  }

  private onActionEvent(event: PiPWindow.PiPActionEventType): void {
    switch (event) {
      case 'playbackStateChanged':
        if (this.avPlayerUtil === undefined) {
          return;
        }
        this.avPlayerUtil.playerStateControl();
        break;
      default:
        break;
    }
  }
}
