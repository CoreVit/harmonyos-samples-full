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
import { AnimatorHelper } from '../../animation/AnimatorHelper';
import { DialogLifeCycle } from '../../lifecycle/DialogLifeCycle';
import { DialogLifeCycleHelper } from '../../lifecycle/DialogLifeCycleHelper';
import { DialogType } from '../../../common/constant/DialogType';
import { DialogExecutor } from '../executor/DialogExecutor';
import { InfDialog } from '../interface/InfDialog';
import { DialogStatus } from '../../../common/constant/DialogStatus';
import { GlobalDialogLifeCycleHelper } from '../../lifecycle/GlobalDialogLifeCycleHelper';
import { DialogStyle } from '../../../common/been/style/DialogStyle';
import { BaseOption } from '../../../common/been/option/base/BaseOption';
import { CustomOption } from '../../../common/been/option/base/CustomOption';
import { DialogDismissReason } from '../../../common/constant/DialogDismissReason';
import { CommonUtils } from '../../../common/util/CommonUtils';
import { DialogAction } from '../../../common/been/DialogAction';
import { ObjectUtils } from '../../../common/util/ObjectUtils';
import { DHubLogger } from '../../../log/DHubLogger';
import { DEFINED_ERROR, DialogError, DialogErrorInfo } from '../../../log/ErrorCode';
import { ListenerManager } from '../../ListenerManager';
import { KeyboardAvoidHelper } from '../../KeyboardAvoidHelper';
import { DefaultContent } from '../../../common/been/option/DefaultContent';
import { DialogMode } from '../../../common/been/config/DialogConfig';
import { catchError } from '../../../common/util/catchError';

/**
 * Encapsulated popup instances, based on systematic OverlayManager
 * */
export class CommonDialog implements InfDialog {
  protected uiContext: UIContext;
  private animatorHelper: AnimatorHelper;
  protected builderOptions: BaseOption;
  protected isShown: boolean = false;
  protected lifeCycleHelper: ListenerManager<DialogLifeCycle> = new DialogLifeCycleHelper();
  protected dialogStatus: DialogStatus = DialogStatus.DEFAULT;
  protected dialogExecutor?: DialogExecutor;
  public readonly type: DialogType;
  public readonly dialogId: string;
  public readonly modelName: ResourceStr;
  private action: DialogAction = {
    show: (): void => {
      this.show();
    },
    dismiss: (): void => {
      this.dismiss();
    },
    hide: (): void => {
      this.hide();
    }
  }

  constructor(uiContext: UIContext, options: BaseOption, lifeCycle: DialogLifeCycle) {
    DHubLogger.debug(`type:${DialogType[options.type]}, start Build`);
    this.uiContext = uiContext;
    this.builderOptions = options;
    this.type = options.type;
    this.dialogId = CommonUtils.generateUniqueId();
    this.builderOptions.dialogId = this.dialogId
    this.modelName = options.modelName;
    this.animatorHelper = new AnimatorHelper(this.builderOptions as CustomOption);
    this.animatorHelper.setOnStartListener((builderOptions) => {
      this.builderOptions = builderOptions;
      this.dialogExecutor?.update();
    })

    if ((typeof this.builderOptions.customContentParam === 'function') && this.builderOptions.isOperableContent) {
      this.builderOptions.customContentParam = this.builderOptions.customContentParam(this.action);
    }

    if (Reflect.ownKeys(lifeCycle).length > 0) {
      this.addLifeCycleListener(lifeCycle);
    }
    DHubLogger.debug(`type:${DialogType[options.type]}, finish Build`);
  }

  public addLifeCycleListener(listener: DialogLifeCycle): void {
    this.lifeCycleHelper?.addListener(listener);
  }

  public removeLifeCycleListener(listener: DialogLifeCycle): void {
    this.lifeCycleHelper?.removeListener(listener);
  }

  // update customContentParam
  @catchError()
  public updateContent<T extends Object>(params: T): DialogErrorInfo {
    if (params === undefined || this.builderOptions.customContentParam === undefined) {
      DHubLogger.error(DialogError.CONTENT_PARAM_UNDEFINED);
      return DEFINED_ERROR[DialogError.CONTENT_PARAM_UNDEFINED];
    }

    let updateParams: object = params;
    if (!ObjectUtils.areSameClassPrototype(params, this.builderOptions.customContentParam)) {
      if ((typeof (params) === 'string') && (this.builderOptions.customContentParam) instanceof DefaultContent) {
        updateParams = new DefaultContent(params);
      } else {
        DHubLogger.error(DialogError.PARAMETER_INCONSISTENCY);
        return DEFINED_ERROR[DialogError.PARAMETER_INCONSISTENCY];
      }
    } else {
      updateParams = params;
    }

    CommonUtils.copyOptions(this.builderOptions.customContentParam, updateParams);
    this.dialogExecutor?.update(['customContentParam']);
    return {
      errorCode: 0,
      errorMsg: 'UpdateContent Success!'
    };
  }

  @catchError()
  public updateStyle(style: DialogStyle): void {
    CommonUtils.copyOptions(this.builderOptions, style, true, true);
    let updateKeys = Reflect.ownKeys(style).filter((value) => value !== undefined) as string[];
    this.dialogExecutor?.update(updateKeys);
  }

  @catchError()
  public show(isInsideCall?: boolean) {
    if (isInsideCall) {
      this.isShown = true;
      this.dialogStatus = DialogStatus.SHOW;
      this.dialogExecutor?.show();
      return true;
    } else if (this.isShown) {
      return true;
    } else {
      DHubLogger.debug(`DialogId:${this.dialogId},type:${DialogType[this.type]}, dialog start show`);
      let singleShouldShow: boolean = (this.lifeCycleHelper as DialogLifeCycleHelper).dispatchWillShow();
      let globalShouldShow: boolean = GlobalDialogLifeCycleHelper.getInstance().dispatchWillShow(this);
      if (singleShouldShow && globalShouldShow) {
        this.isShown = true;

        let autoKeyboardAvoidMode = (this.builderOptions as CustomOption).autoKeyboardAvoidMode;
        if (autoKeyboardAvoidMode && this.type !== DialogType.SHEET) {
          KeyboardAvoidHelper.getInstance().setReSizeMode();
        }
        this.dialogStatus = DialogStatus.SHOW;
        this.dialogExecutor?.show();
        DHubLogger.debug(`DialogId:${this.dialogId},type:${DialogType[this.type]}, dialog Executor start show`);
        if (this.animatorHelper.isUseAnimation()) {
          DHubLogger.debug(`DialogId:${this.dialogId},type:${DialogType[this.type]}, dialog Executor start animation`);
          this.animatorHelper.open();
        }
        setTimeout(() => {
          (this.lifeCycleHelper as DialogLifeCycleHelper)?.dispatchShow();
          GlobalDialogLifeCycleHelper.getInstance().dispatchShow(this);
          DHubLogger.debug(`DialogId:${this.dialogId},type:${DialogType[this.type]}, dialog finish show`);
        });
        return true;
      }
      return false;
    }
  }

  @catchError()
  public hide(isInsideCall?: boolean) {
    if (isInsideCall) {
      this.isShown = false;
      this.dialogStatus = DialogStatus.HIDE;
      this.dialogExecutor?.hide();
      return true;
    } else if (!this.isShown) {
      return true;
    } else {
      DHubLogger.debug(`DialogId:${this.dialogId},type:${DialogType[this.type]}, dialog about to hide`);
      let singleShouldHide: boolean = (this.lifeCycleHelper as DialogLifeCycleHelper).dispatchWillHide();
      let globalShouldHide: boolean = GlobalDialogLifeCycleHelper.getInstance().dispatchWillHide(this);
      if (singleShouldHide && globalShouldHide) {
        this.dialogStatus = DialogStatus.HIDE;
        DHubLogger.debug(`DialogId:${this.dialogId},type:${DialogType[this.type]}, dialog Executor start hide`);

        if (this.animatorHelper.isUseAnimation()) {
          this.animatorHelper.close(() => {
            this.isShown = false;
            this.dialogExecutor?.hide();
          });
        } else {
          this.isShown = false;
          this.dialogExecutor?.hide();
        }
        KeyboardAvoidHelper.getInstance().restore();
        setTimeout(() => {
          (this.lifeCycleHelper as DialogLifeCycleHelper)?.dispatchHide();
          GlobalDialogLifeCycleHelper.getInstance().dispatchHide(this);
          DHubLogger.debug(`DialogId:${this.dialogId},type:${DialogType[this.type]}, dialog finish hide`);
        });
        return true;
      }
    }
    return false;
  }

  @catchError()
  public dismiss(dismissReason?: DialogDismissReason): boolean {
    if (this.isShown) {
      dismissReason = dismissReason ?? DialogDismissReason.CLOSE_DIRECTLY;
      DHubLogger.debug(`DialogId:${this.dialogId}, dialog will dismiss with reason: ${dismissReason}`);
      if (this.canDismissNow(dismissReason)) {
        DHubLogger.debug(`DialogId:${this.dialogId}, dialog start dismiss with reason${dismissReason}`);
        this.close(undefined, dismissReason === DialogDismissReason.CLOSE_PAGE_DESTROY);
        DHubLogger.debug(`DialogId:${this.dialogId}, dialog end dismiss with reason${dismissReason}`);
        (this.lifeCycleHelper as DialogLifeCycleHelper)?.dispatchDismiss();
        GlobalDialogLifeCycleHelper.getInstance().dispatchDismiss(this);
        KeyboardAvoidHelper.getInstance().restore();
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  private canDismissNow(dismissReason: DialogDismissReason): boolean {
    let singleShouldDismiss: boolean =
      (this.lifeCycleHelper as DialogLifeCycleHelper).dispatchWillDismiss(dismissReason);
    let globalShouldDismiss: boolean =
      GlobalDialogLifeCycleHelper.getInstance().dispatchWillDismiss(this, dismissReason);
    return singleShouldDismiss && globalShouldDismiss;
  }

  @catchError()
  private close(isPersistence: boolean = false, isInsideCall?: boolean) {
    if (this.isShown && this.dialogStatus === DialogStatus.SHOW) {
      this.dialogStatus = isPersistence ? DialogStatus.HIDE : DialogStatus.DEFAULT;
      if (this.animatorHelper.isUseAnimation() && !isInsideCall) {
        this.animatorHelper.close(() => {
          this.isShown = false;
          isPersistence ? this.dialogExecutor?.hide() : this.dialogExecutor?.dismiss();
        });
      } else {
        this.isShown = false;
        isPersistence ? this.dialogExecutor?.hide() : this.dialogExecutor?.dismiss();
      }
      if(isInsideCall){
        this.destoryDialog();
      }
    }
  }

  private destoryDialog() {
    this.builderOptions.customContentParam = undefined;
  }
  // update specified content of option
  public update(updateParams?: string[]) {
    DHubLogger.debug(`DialogId:${this.dialogId},type:${DialogType[this.type]}, start update Component ${updateParams?.join(',')}`);
    this.dialogExecutor?.update(updateParams);
    DHubLogger.debug(`DialogId:${this.dialogId},type:${DialogType[this.type]}, finish update Component ${updateParams?.join(',')}`);
  }

  public isShow(): boolean {
    return this.isShown;
  }

  public getStatus(): DialogStatus {
    return this.dialogStatus;
  }

  getMode(): DialogMode {
    DHubLogger.error(`DialogId:${this.dialogId},type:${DialogType[this.type]}, GetMode Fail, Return Default Value Now`);
    return DialogMode.CUSTOM_DIALOG;
  }
}
