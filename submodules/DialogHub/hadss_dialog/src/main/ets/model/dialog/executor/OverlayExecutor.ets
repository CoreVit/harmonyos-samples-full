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
import { ComponentContent, OverlayManager } from '@kit.ArkUI';
import { CustomOption } from '../../../common/been/option/base/CustomOption';
import { BaseDialogComponent } from '../../../components/base/BaseDialogComponent';
import { catchError } from '../../../common/util/catchError';

export class OverlayExecutor extends DialogExecutor {
  private overlayManager: OverlayManager;
  private isAdd: boolean = false;

  constructor(uiContext: UIContext, builderOptions: CustomOption) {
    super(uiContext, builderOptions);
    this.overlayManager = this.uiContext.getOverlayManager();
  }

  @catchError()
  protected init() {
    let wrappedBuilder = new WrappedBuilder<[CustomOption]>(BaseDialogComponent);
    this.contentNode =
      new ComponentContent(this.uiContext, wrappedBuilder, this.builderOptions as CustomOption,
        { nestingBuilderSupported: true });
  }

  @catchError()
  public show() {
    if (this.isAdd) {
      this.overlayManager.showComponentContent(this.contentNode);
    } else {
      this.init();
      this.overlayManager.addComponentContent(this.contentNode, (this.builderOptions as CustomOption).layerIndex);
      this.isAdd = true;
    }
  }

  @catchError()
  public dismiss(): void {
    this.overlayManager.removeComponentContent(this.contentNode);
    this.contentNode?.dispose();
    this.isAdd = false;
  }

  @catchError()
  public hide() {
    this.overlayManager.hideComponentContent(this.contentNode);
  }

  @catchError()
  public resetIndex(): void {
    this.overlayManager.addComponentContent(this.contentNode, (this.builderOptions as CustomOption).layerIndex);
  }

  @catchError()
  public update(updateParams?: string[]) {
    if (updateParams && updateParams.length > 0) {
      if (updateParams.includes('Configuration')) {
        this.contentNode?.updateConfiguration();
      }
    }
    this.contentNode?.update(this.builderOptions);
  }
}