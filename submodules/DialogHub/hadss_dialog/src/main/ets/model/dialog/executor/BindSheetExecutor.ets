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

import { DialogExecutor } from './DialogExecutor';
import { SheetOption } from '../../../common/been/option/base/SheetOption';
import { ComponentContent, LengthMetrics } from '@kit.ArkUI';
import { DialogDismissReason } from '../../../common/constant/DialogDismissReason';
import { Callback } from '@kit.BasicServicesKit';
import { catchError } from '../../../common/util/catchError';

enum SheetKeyboardAvoidMode {
  NONE = 0,
  TRANSLATE_AND_RESIZE = 1,
  RESIZE_ONLY = 2,
  TRANSLATE_AND_SCROLL = 3
}

interface DialogHubSheetOptions extends SheetOptions {
  keyboardAvoidMode?: SheetKeyboardAvoidMode;
}

export class BindSheetExecutor extends DialogExecutor {
  public customSheetOptions: SheetOption;
  // need Call when BindSheet Close by self,e.g. TOUCH_OUTSIDE、CLOSE_BUTTON、SLIDE_DOWN
  public callBackWhenDismissSelf: Callback<void>;

  constructor(uiContext: UIContext, builderOptions: SheetOption, callBackWhenDismissSelf: Callback<void>) {
    super(uiContext, builderOptions);
    this.customSheetOptions = this.builderOptions as SheetOption;
    this.callBackWhenDismissSelf = callBackWhenDismissSelf;
    this.init();
  }

  @catchError()
  protected init() {
    if (this.customSheetOptions.customContent) {
      this.contentNode =
        new ComponentContent(this.uiContext, this.customSheetOptions.customContent,
          this.customSheetOptions.customContentParam);
    }
  }

  private getSheetOptions(): SheetOptions {
    let sheetOptions: DialogHubSheetOptions = {};
    sheetOptions.height = this.customSheetOptions.height;
    if (this.customSheetOptions.detents) {
      if (this.customSheetOptions.detents[2]) {
        sheetOptions.detents =
          [this.customSheetOptions.detents[0], this.customSheetOptions.detents[1], this.customSheetOptions.detents[2]];
      } else if (this.customSheetOptions.detents[1]) {
        sheetOptions.detents =
          [this.customSheetOptions.detents[0], this.customSheetOptions.detents[1]];
      } else {
        sheetOptions.detents =
          [this.customSheetOptions.detents[0]];
      }
    }

    if (this.customSheetOptions.radius) {
      let radius = this.customSheetOptions.radius;
      if(typeof radius === 'string'){
        let value  = parseInt(radius);
        let unitString = radius.split(String(value))[1];
        let units = ['px','vp','fp','%','lpx'];
        sheetOptions.radius = new LengthMetrics(unitString === '%' ? value/100 : value, units.indexOf(unitString));
      }else if(typeof radius === 'number'){
        sheetOptions.radius = new LengthMetrics(radius);
      }else {
        sheetOptions.radius = this.customSheetOptions.radius as BorderRadiuses;
      }
    }

    sheetOptions.preferType = this.customSheetOptions.preferType;
    sheetOptions.showClose = this.customSheetOptions.showClose;
    sheetOptions.dragBar = this.customSheetOptions.dragBar;
    sheetOptions.blurStyle = this.customSheetOptions.blurStyle;
    sheetOptions.maskColor = this.customSheetOptions.maskColor;
    sheetOptions.title = this.customSheetOptions.title;
    sheetOptions.enableOutsideInteractive = this.customSheetOptions.enableOutsideInteractive;
    sheetOptions.borderWidth = this.customSheetOptions.borderWidth;
    sheetOptions.borderColor = this.customSheetOptions.borderColor;
    sheetOptions.borderStyle = this.customSheetOptions.borderStyle;
    sheetOptions.width = this.customSheetOptions.width;
    sheetOptions.shadow = this.customSheetOptions.shadow;
    sheetOptions.scrollSizeMode = this.customSheetOptions.scrollSizeMode;
    sheetOptions.backgroundColor = this.customSheetOptions.backgroundColor;

    // onWillDismiss is different from ArkUI 's onWillDismiss;  need external process here
    sheetOptions.onWillDismiss = (oriAction: DismissSheetAction) => {
      let isDismiss = true;
      // Lifecycle events that cannot be implemented or triggered by `DialogHub`,
      // itself need to be delegated to native capabilities (`BindSheet`) for execution.
      if (oriAction.reason === DismissReason.TOUCH_OUTSIDE) {
        isDismiss =
          this.customSheetOptions?.sheetLifeCycleConfig.onWillDismiss?.(DialogDismissReason.TOUCH_OUTSIDE) ?? true;
      } else if (oriAction.reason === DismissReason.SLIDE_DOWN) {
        isDismiss =
          this.customSheetOptions?.sheetLifeCycleConfig.onWillDismiss?.(DialogDismissReason.SLIDE_DOWN) ?? true;
      } else if (oriAction.reason === DismissReason.CLOSE_BUTTON) {
        isDismiss =
          this.customSheetOptions?.sheetLifeCycleConfig.onWillDismiss?.(DialogDismissReason.CLOSE_BUTTON) ?? true;
      } else if (oriAction.reason === DismissReason.PRESS_BACK) {
        isDismiss =
          this.customSheetOptions?.sheetLifeCycleConfig.onWillDismiss?.(DialogDismissReason.PRESS_BACK) ?? true;
      } else {
        // need do something only when DismissSheetAction.DismissReason support more action
      }
      if (isDismiss) {
        oriAction.dismiss();
        this.callBackWhenDismissSelf();
      }
    };
    sheetOptions.onWillSpringBackWhenDismiss = this.customSheetOptions.sheetLifeCycleConfig.onWillSpringBackWhenDismiss;
    sheetOptions.onHeightDidChange = this.customSheetOptions.sheetLifeCycleConfig.onHeightDidChange;
    sheetOptions.onDetentsDidChange = this.customSheetOptions.sheetLifeCycleConfig.onDetentsDidChange;
    sheetOptions.onWidthDidChange = this.customSheetOptions.sheetLifeCycleConfig.onWidthDidChange;
    sheetOptions.onTypeDidChange = this.customSheetOptions.sheetLifeCycleConfig.onTypeDidChange;
    sheetOptions.mode = SheetMode.OVERLAY;
    sheetOptions.keyboardAvoidMode = SheetKeyboardAvoidMode.TRANSLATE_AND_RESIZE;
    return sheetOptions
  }

  @catchError()
  public show() {
    if(!this.contentNode){
      this.init();
    }
    this.uiContext.openBindSheet(this.contentNode, this.getSheetOptions(), this.customSheetOptions.targetCompUniqueId);
  }

  @catchError()
  public hide() {
    this.uiContext.closeBindSheet(this.contentNode);
  }

  @catchError()
  public dismiss(): void {
    this.uiContext.closeBindSheet(this.contentNode);
    this.contentNode?.dispose();
    this.contentNode = undefined;
  }

  public resetIndex(): void {
    // bindSheet has no ability to setIndex Now; So, do nothing here!
  }

  @catchError()
  public update(updateParams?: string[]): void {
    if (updateParams && updateParams.length > 0) {
      if (!updateParams.includes('customContentParam')) {
        // `systemSheetOptions` has changed.
        this.uiContext.updateBindSheet(this.contentNode, this.getSheetOptions());
      }
      if (updateParams.includes('Configuration')) {
        this.contentNode?.updateConfiguration();
      }
    }
    this.contentNode?.update(this.customSheetOptions.customContentParam);
  }
}