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
import { DialogModelHelper } from './DialogModelHelper';
import { CustomBuilder } from './adapter/builder/base/CustomBuilder';
import { PopupBuilder } from './adapter/builder/base/PopupBuilder';
import { SheetBuilder } from './adapter/builder/base/SheetBuilder';
import { ToastBuilder } from './adapter/builder/base/ToastBuilder';
import { CustomTemplate } from './adapter/template/base/CustomTemplate';
import { ToastTemplate } from './adapter/template/base/ToastTemplate';
import { PopupTemplate } from './adapter/template/base/PopupTemplate';
import { SheetTemplate } from './adapter/template/base/SheetTemplate';
import { DHubLogger } from '../log/DHubLogger';
import { GlobalDialogLifeCycleHelper } from './lifecycle/GlobalDialogLifeCycleHelper';
import { DialogType } from '../common/constant/DialogType';
import { DialogStatus } from '../common/constant/DialogStatus';
import { AppLifeCycleHelper } from './lifecycle/AppLifeCycleHelper';
import { GlobalEvent } from './lifecycle/GlobalEvent';
import { DialogBackPressResult } from '../common/constant/DialogBackPressResult';
import { DialogError } from '../log/ErrorCode';
import { CustomOption } from '../common/been/option/base/CustomOption';
import { ToastOption } from '../common/been/option/base/ToastOption';
import { PopupOption } from '../common/been/option/base/PopupOption';
import { SheetOption } from '../common/been/option/base/SheetOption';
import { InfDialog } from './dialog/interface/InfDialog';
import { DialogLimitPolicyHelper } from './DialogLimitPolicyHelper';
import { DialogDismissReason } from '../common/constant/DialogDismissReason';
import { GlobalEventHelper } from './lifecycle/GlobalEventHelper';
import { KeyboardAvoidHelper } from './KeyboardAvoidHelper';
import observer from '@ohos.arkui.observer';
import { HAR_VERSION } from '../../../../BuildProfile';
import { PresetToast } from './adapter/template/preset/PresetToast';
import { DialogMode } from '../common/been/config/DialogConfig';
import { DialogBuilder } from './adapter/builder/base/DialogBuilder';
import { TemplateManager } from './TemplateManager';
import { catchError } from '../common/util/catchError';
import { CommonDialog } from './dialog/base/CommonDialog';

export class DialogHub {
  private static uiContext: UIContext;
  private static globalEventListener: GlobalEventHelper = new GlobalEventHelper();
  public static templateManager = new TemplateManager();
  private static mode: DialogMode = DialogMode.OVERLAY_MANAGER;
  private static globalEventUpdateRouterCall: Callback<observer.RouterPageInfo> = (info) => {
    if (info.state === observer.RouterPageState.ON_PAGE_SHOW) {
      let newVal = AppLifeCycleHelper.getInstance()
        .getCurrentPageDialogs(undefined, undefined, undefined, DialogStatus.SHOW)
        .length;
      DialogHub.globalEventListener.dispatchCurentPageDialogNumberChange(newVal, 0);
    }
  };
  private static globalEventUpdateNavigationCall: Callback<observer.NavDestinationSwitchInfo> = () => {
    let newVal = AppLifeCycleHelper.getInstance()
      .getCurrentPageDialogs(undefined, undefined, undefined, DialogStatus.SHOW)
      .length;
    DialogHub.globalEventListener.dispatchCurentPageDialogNumberChange(newVal, 0);
  };
  private static isInit = false;

  private constructor() {
  }

  /**
   * Enable DialogHub logs
   * @param level
   */
  static openLog(level: 'DEBUG' | 'INFO'): void {
    DHubLogger.openLog(level);
  }

  // SDK initialization
  @catchError()
  static init(uiContext: UIContext, dialogMode?: DialogMode): void {
    if (!DialogHub.isInit) {
      DialogHub.uiContext = uiContext;
      AppLifeCycleHelper.getInstance(DialogHub.uiContext);
      DialogLimitPolicyHelper.getInstance(DialogHub.uiContext);
      KeyboardAvoidHelper.getInstance(DialogHub.uiContext);
      DialogHub.initGlobalEventListener();
      DialogHub.mode = dialogMode ? dialogMode : DialogMode.OVERLAY_MANAGER;
      DialogHub.isInit = true;
      DHubLogger.info('Success Init DialogHub, Version:' + HAR_VERSION);
    } else {
      AppLifeCycleHelper.getInstance(DialogHub.uiContext).restartGlobalObserver();
      DialogHub.initGlobalEventListener();
    }
  }

  @catchError()
  private static initGlobalEventListener(): void {
    let uiObserver = DialogHub.uiContext.getUIObserver();
    if (!DialogHub.isInit) {
      GlobalDialogLifeCycleHelper.getInstance()
        .addListener({
          onShow: () => {
            let newVal = AppLifeCycleHelper.getInstance()
              .getCurrentPageDialogs(undefined, undefined, undefined, DialogStatus.SHOW)
              .length;
            DialogHub.globalEventListener.dispatchCurentPageDialogNumberChange(newVal, newVal - 1);
          },
          onDismiss: () => {
            let newVal = AppLifeCycleHelper.getInstance()
              .getCurrentPageDialogs(undefined, undefined, undefined, DialogStatus.SHOW)
              .length;
            DialogHub.globalEventListener.dispatchCurentPageDialogNumberChange(newVal, newVal + 1);
          }
        })
      uiObserver.on('routerPageUpdate', DialogHub.globalEventUpdateRouterCall);
      uiObserver.on('navDestinationSwitch', DialogHub.globalEventUpdateNavigationCall);
    } else {
      uiObserver.off('routerPageUpdate', DialogHub.globalEventUpdateRouterCall);
      uiObserver.off('navDestinationSwitch', DialogHub.globalEventUpdateNavigationCall);
      uiObserver.on('routerPageUpdate', DialogHub.globalEventUpdateRouterCall);
      uiObserver.on('navDestinationSwitch', DialogHub.globalEventUpdateNavigationCall);
    }
  }

  // Get popup behavior
  @catchError()
  static getCustomDialog(): CustomBuilder | DialogBuilder {
    if (DialogHub.getMode() == DialogMode.CUSTOM_DIALOG) {
      return new DialogBuilder(DialogHub.uiContext);
    }
    return new CustomBuilder(DialogHub.uiContext);
  }

  // Toast window constructor, generally used to display operation results, as a message or reminder feedback,
  // display for a period of time after the automatic disappearance, the default 2s
  @catchError()
  static getToast(): ToastBuilder {
    return new ToastBuilder(DialogHub.uiContext);
  }

  // Popup constructor, used to bind page components, to explain the page content
  @catchError()
  static getPopup(): PopupBuilder {
    return new PopupBuilder(DialogHub.uiContext);
  }

  // The bottom popup constructor, which pops up and collapses from the bottom,
  // is generally used to achieve interactive scenes, such as long-press picture saving, term interpretation, etc
  @catchError()
  static getSheet(): SheetBuilder {
    return new SheetBuilder(DialogHub.uiContext);
  }

  // Create a pop-up template
  @catchError()
  static createCustomTemplate(modelName: string): CustomTemplate {
    return new CustomTemplate(DialogHub.uiContext, modelName, false);
  }

  @catchError()
  static createToastTemplate(modelName: string): ToastTemplate {
    return new ToastTemplate(DialogHub.uiContext, modelName, false);
  }

  @catchError()
  static createPopupTemplate(modelName: string): PopupTemplate {
    return new PopupTemplate(DialogHub.uiContext, modelName, false);
  }

  @catchError()
  static createSheetTemplate(modelName: string): SheetTemplate {
    return new SheetTemplate(DialogHub.uiContext, modelName, false);
  }


  // Create a pop-up template
  @catchError()
  static getCustomTemplate(modelName: string): CustomBuilder | null {
    return DialogHub.templateManager.getCustomTemplate(modelName);
  }

  @catchError()
  static getToastTemplate(modelName: string): ToastBuilder | null {
    return DialogHub.templateManager.getToastTemplate(modelName);
  }

  @catchError()
  static getPopupTemplate(modelName: string): PopupBuilder | null {
    return DialogHub.templateManager.getPopupTemplate(modelName);
  }

  @catchError()
  static getSheetTemplate(modelName: string): SheetBuilder | null {
    return DialogHub.templateManager.getSheetTemplate(modelName);
  }


  // Delete a pop-up template
  @catchError()
  static removeTemplate(modelName: string): boolean {
    return DialogModelHelper.remove(modelName);
  }


  // Example Query whether a template with the specified Name exists
  @catchError()
  static isTemplateExist(modelName: string): boolean {
    return DialogModelHelper.query(modelName);
  }


  // Query template's type
  @catchError()
  static queryTemplate(modelName: string): DialogType | null {
    let templateOptions = DialogModelHelper.get(modelName);
    if (!templateOptions) {
      return null;
    } else {
      return templateOptions.type;
    }
  }

  // Modify a pop-up template
  @catchError()
  static updateCustomTemplate(modelName: string): CustomTemplate | null {
    let templateOptions = DialogModelHelper.get(modelName);
    if (!templateOptions) {
      DHubLogger.error(DialogError.ERR_TEMPLATE_WITHOUT, modelName.toString());
      return null;
    }
    return new CustomTemplate(DialogHub.uiContext, modelName, true, templateOptions as CustomOption);
  }

  @catchError()
  static updateToastTemplate(modelName: string): ToastTemplate | null {
    let templateOptions = DialogModelHelper.get(modelName);
    if (!templateOptions) {
      DHubLogger.error(DialogError.ERR_TEMPLATE_WITHOUT, modelName.toString());
      return null;
    }
    return new ToastTemplate(DialogHub.uiContext, modelName, true, templateOptions as ToastOption);
  }

  @catchError()
  static updatePopupTemplate(modelName: string): PopupTemplate | null {
    let templateOptions = DialogModelHelper.get(modelName);
    if (!templateOptions) {
      DHubLogger.error(DialogError.ERR_TEMPLATE_WITHOUT, modelName.toString());
      return null;
    }
    return new PopupTemplate(DialogHub.uiContext, modelName, true, templateOptions as PopupOption);
  }

  @catchError()
  static updateSheetTemplate(modelName: string): SheetTemplate | null {
    let templateOptions = DialogModelHelper.get(modelName);
    if (!templateOptions) {
      DHubLogger.error(DialogError.ERR_TEMPLATE_WITHOUT, modelName.toString());
      return null;
    }
    return new SheetTemplate(DialogHub.uiContext, modelName, true, templateOptions as SheetOption);
  }


  // Setting the default UIContext.UIContext adjustment takes effect only for newly created pop-up objects (Dialog)
  static setUIContext(uiContext: UIContext): void {
    DialogHub.uiContext = uiContext;
  }

  static getUIContext(): UIContext {
    return DialogHub.uiContext;
  }

  // Improve global management capabilities
  static getCurrentPageDialogs(): InfDialog[]

  static getCurrentPageDialogs(type: DialogType): InfDialog[]

  static getCurrentPageDialogs(modelName: string): InfDialog[]
  @catchError()
  static getCurrentPageDialogs(firstInfo?: DialogType | DialogStatus | string): InfDialog[] {
    let type: DialogType | undefined;
    let modelName: string | undefined;

    if (typeof firstInfo === 'string') {
      modelName = firstInfo;
    } else {
      type = firstInfo as DialogType;
    }

    return AppLifeCycleHelper.getInstance(DialogHub.uiContext)
      .getCurrentPageDialogs(undefined, type, modelName, DialogStatus.SHOW) ?? [];
  }
  @catchError()
  static getCurrentPageDialogsByStatus(status?: DialogStatus): CommonDialog[] {
    return AppLifeCycleHelper.getInstance(DialogHub.uiContext)
      .getCurrentPageDialogs(undefined, undefined, undefined, status) ?? [];
  }
  @catchError()
  static dispatchBackPressToDialog(): DialogBackPressResult {
    let curentPageDialogs = AppLifeCycleHelper.getInstance(DialogHub.uiContext)
      .getCurrentPageDialogs(undefined, undefined, undefined, DialogStatus.SHOW);
    let dialogNumber = curentPageDialogs.length;
    if (dialogNumber > 0) {
      let limitHelper = DialogLimitPolicyHelper.getInstance();
      let topDialog = curentPageDialogs[0];
      let maxIndex = limitHelper.getDialogLayerIndex(topDialog);
      for (let i = 1; i < dialogNumber; i++) {
        let curDialog = curentPageDialogs[i];
        let curIndex = limitHelper.getDialogLayerIndex(curDialog);
        if (curIndex > maxIndex) {
          topDialog = curDialog;
          maxIndex = curIndex;
        }
      }
      if (topDialog.dismiss(DialogDismissReason.PRESS_BACK)) {
        return DialogBackPressResult.TOP_DIALOG_DISMISSED;
      } else {
        return DialogBackPressResult.BACK_PRESS_REJECTED;
      }
    } else {
      return DialogBackPressResult.NO_DIALOG;
    }
  }
  static addEventListener(listener: GlobalEvent): void {
    DialogHub.globalEventListener.addListener(listener);
  }
  static removeEventListener(listener: GlobalEvent): void {
    DialogHub.globalEventListener.removeListener(listener);
  }
  static getMode(): DialogMode {
    return DialogHub.mode;
  }
}