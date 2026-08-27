/*
 * Copyright (c) 2022-2025 Huawei Device Co., Ltd.
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
import { KeyboardAvoidMode } from '@kit.ArkUI'
import { DialogStatus } from '../common/constant/DialogStatus';
import { CommonDialog } from './dialog/base/CommonDialog';
import { CustomDialog } from './dialog/base/CustomDialog';
import { DialogHub } from './DialogHub';
import { AppLifeCycleHelper } from './lifecycle/AppLifeCycleHelper';
import { common } from '@kit.AbilityKit';
import { DialogType } from '../common/constant/DialogType';
import { DHubLogger } from '../log/DHubLogger';
import { deviceInfo } from '@kit.BasicServicesKit';
import { catchError } from '../common/util/catchError';

export class KeyboardAvoidHelper {
  private static instance: KeyboardAvoidHelper;
  private uiContext: UIContext;
  private userKeyboardAvoidMode: KeyboardAvoidMode;
  private isChange: boolean = false;
  private keyboardHeight: number = 0;

  public getKeyboardAvoidModeProtected(): KeyboardAvoidMode {
    let result = this.uiContext.getKeyboardAvoidMode();
    if (deviceInfo.sdkApiVersion < 18) {
      let sysInfo = result + '';
      switch (sysInfo) {
        case 'KeyBoardAvoidMode.OFFSET':
          result = 0;
          break;
        case 'KeyBoardAvoidMode.RESIZE':
          result = 1;
          break;
        case 'KeyBoardAvoidMode.OFFSET_WITH_CARET':
          result = 2;
          break;
        case 'KeyBoardAvoidMode.RESIZE_WITH_CARET':
          result = 3;
          break;
        case 'KeyBoardAvoidMode.NONE':
        default:
          result = 4;
          break;
      }
    }
    return result
  }

  private constructor(uiContext: UIContext) {
    this.uiContext = uiContext;
    this.onKeyboardHeightChange();
    this.userKeyboardAvoidMode = this.getKeyboardAvoidModeProtected();
  }

  public static getInstance(uiContext?: UIContext): KeyboardAvoidHelper {
    if (!KeyboardAvoidHelper.instance && uiContext) {
      KeyboardAvoidHelper.instance = new KeyboardAvoidHelper(uiContext);
    }
    return KeyboardAvoidHelper.instance;
  }

  public setReSizeMode() {
    if (!this.isChange) {
      this.userKeyboardAvoidMode = this.getKeyboardAvoidModeProtected();
      this.uiContext.setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE);
      this.isChange = true;
      DHubLogger.debug('Page\'s KeyboardAvoidMode change!')
    }
  }

  public restore() {
    let dialogNum = DialogHub.getCurrentPageDialogs().length;

    let allSheet = true;
    let dialogs = AppLifeCycleHelper.getInstance(this.uiContext)
      .getCurrentPageDialogs(undefined, undefined, undefined, DialogStatus.SHOW);
    dialogs.forEach((dialog: CommonDialog) => {
      if (dialog.type !== DialogType.SHEET) {
        allSheet = false;
      }
    })

    if (this.isChange && (dialogNum === 0 || allSheet)) {
      this.uiContext.setKeyboardAvoidMode(this.userKeyboardAvoidMode);
      this.isChange = false;
      DHubLogger.debug('Page\'s KeyboardAvoidMode restore!')
    }
  }

  // Enable listening for changes in the fixed state soft keyboard height
  @catchError()
  private onKeyboardHeightChange() {
    let windowStage = (this.uiContext.getHostContext() as common.UIAbilityContext).windowStage;
    if (windowStage) {
      windowStage.getMainWindowSync().on('keyboardHeightChange', (height: number) => {
        this.keyboardHeight = height;
        let dialogs = AppLifeCycleHelper.getInstance(this.uiContext)
          .getCurrentPageDialogs(undefined, undefined, undefined, DialogStatus.SHOW);
        dialogs.forEach((dialog: CommonDialog) => {
          if (dialog.type !== DialogType.SHEET) {
            (dialog as CustomDialog).avoidKeyboard(height, true);
          }
        })
      })
    }
  }

  public getKeyboardHeight(): number {
    return this.keyboardHeight;
  }
}