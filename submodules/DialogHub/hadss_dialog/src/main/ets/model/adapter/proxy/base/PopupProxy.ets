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
import { PopupConfig } from '../../../../common/been/config/PopupConfig';
import { PopupOption } from '../../../../common/been/option/base/PopupOption';
import { DefaultContent } from '../../../../common/been/option/DefaultContent';
import { PopupStyle } from '../../../../common/been/style/PopupStyle';
import { DialogType } from '../../../../common/constant/DialogType';
import { CommonUtils } from '../../../../common/util/CommonUtils';
import { DefaultComponent } from '../../../../components/base/DefaultComponent';
import { CustomProxy } from './CustomProxy';


/**
 * Popup builder, based on CommonDialogBuilder, not support custom styles.
 * */
export abstract class PopupProxy extends CustomProxy {
  protected builderOptions: PopupOption = new PopupOption();

  constructor(uiContext: UIContext, builderOptions?: PopupOption) {
    super(uiContext)
    if (builderOptions) {
      CommonUtils.copyOptions(this.builderOptions, builderOptions, true, true);
    }
    this.builderOptions.type = DialogType.POPUP;
    this.builderOptions.isShow = false;
  }


  setTextContent(text: string) {
    // judge whether customContent has a value first
    this.builderOptions.customContent = wrapBuilder(DefaultComponent);
    this.builderOptions.customContentParam = new DefaultContent(text);
    return this;
  }

  setStyle(style: PopupStyle) {
    super.setStyle(style);
    this.builderOptions.enableArrow = style.enableArrow ?? this.builderOptions.enableArrow;
    this.builderOptions.arrowOffset = style.arrowOffset ?? this.builderOptions.arrowOffset;
    this.builderOptions.arrowWidth = style.arrowWidth ?? this.builderOptions.arrowWidth;
    this.builderOptions.arrowHeight = style.arrowHeight ?? this.builderOptions.arrowHeight;
    this.builderOptions.arrowColor = style.arrowColor ?? this.builderOptions.arrowColor;
    this.builderOptions.edgePadding = style.edgePadding ?? this.builderOptions.edgePadding;
    if (style.arrowIcons) {
      this.builderOptions.arrowIcons.top = style.arrowIcons.top ?? this.builderOptions.arrowIcons.top;
      this.builderOptions.arrowIcons.bottom = style.arrowIcons.bottom ?? this.builderOptions.arrowIcons.bottom;
      this.builderOptions.arrowIcons.left = style.arrowIcons.left ?? this.builderOptions.arrowIcons.left;
      this.builderOptions.arrowIcons.right = style.arrowIcons.right ?? this.builderOptions.arrowIcons.right;
    }
    return this;
  }


  setConfig(config: PopupConfig) {
    super.setConfig(config);
    if (config.dialogPosition?.preferPlacement || config.dialogPosition?.preferPlacement === Placement.Left) {
      this.builderOptions.preferPlacement = config.dialogPosition.preferPlacement;
    }
    return this;
  }

  setComponentTargetId(targetCompId: string) {
    this.builderOptions.targetCompId = targetCompId;
    return this;
  }
}
