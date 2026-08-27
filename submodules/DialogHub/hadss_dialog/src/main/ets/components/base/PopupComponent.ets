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
import { drawing } from '@kit.ArkGraphics2D';
import { PopupOption } from '../../common/been/option/base/PopupOption';
import { CommonUtils } from '../../common/util/CommonUtils';
import { POPUP_ARROW_ID, POPUP_CONTENT_ID } from '../../common/constant/Consntant';
import {
  alignDirectionDic,
  PopupRelativePosition,
  popupRelativePositionDic
} from '../../common/constant/DialogAlignment';
import { DimensionUtils } from '../../common/util/DimensionUtils';

@Builder
export function PopupComponent(options: PopupOption) {
  Flex({
    direction: alignDirectionDic[popupRelativePositionDic[options.curPlacement]],
    justifyContent: FlexAlign.Center,
    alignItems: ItemAlign.Center
  }) {
    Stack() {
      options.customContent.builder(options.customContentParam)
    }
    .backgroundColor(options.backgroundColor)
    .borderRadius(options.radius)
    .borderWidth(options.borderWidth)
    .borderColor(options.borderColor)
    .borderStyle(options.borderStyle)
    .shadow(options.shadow)
    .id(POPUP_CONTENT_ID)

    Image(options.getPopupArrowIcon())
      .attributeModifier(new PopupArrowIconModifier(options))
      .width(`${Math.round(DimensionUtils.length2px(options.arrowWidth))}px`)
      .height(getArrowHeight(options.arrowHeight))
      .visibility(options.enableArrow ? Visibility.Visible : Visibility.None)
      .id(POPUP_ARROW_ID + options.dialogId)
      .offset(options.getPopupArrowOffset())
      .zIndex(1)
  }
  .visibility(options.visible)
  .onAreaChange((oldValue: Area, newValue: Area) => {
    options.areaChangedCallback?.();
  })
  .padding(getEdgePadding(options))
  .width('auto')
  .height('auto')
}

function getArrowHeight(height: Length) {
  if (height === '') {
    return undefined; // auto Detect
  } else {
    return `${Math.round(DimensionUtils.length2px(height))}px`;
  }
}

function getEdgePadding(options: PopupOption): Padding {
  let edgePadding: Padding = {
    left: 0,
    right: 0,
    top: 0,
    bottom: 0
  }
  let curPosition = popupRelativePositionDic[options.curPlacement];
  if (curPosition === PopupRelativePosition.Top || curPosition === PopupRelativePosition.Bottom) {
    edgePadding.left = options.edgePadding;
    edgePadding.right = options.edgePadding;
  } else {
    edgePadding.top = options.edgePadding;
    edgePadding.bottom = options.edgePadding;
  }
  return edgePadding;
}

class PopupArrowIconModifier implements AttributeModifier<ImageAttribute> {
  public options: PopupOption;
  constructor(options: PopupOption) {
    this.options = options;
  }

  applyNormalAttribute(instance: ImageAttribute): void {
    if (this.options.arrowColor != undefined) {
      instance.fillColor(this.options.arrowColor)
        .colorFilter(drawing.ColorFilter.createBlendModeColorFilter({
          red: CommonUtils.hex2rgba(CommonUtils.resourceColor2Hex(this.options.arrowColor))[0],
          green: CommonUtils.hex2rgba(CommonUtils.resourceColor2Hex(this.options.arrowColor))[1],
          blue: CommonUtils.hex2rgba(CommonUtils.resourceColor2Hex(this.options.arrowColor))[2],
          alpha: CommonUtils.hex2rgba(CommonUtils.resourceColor2Hex(this.options.arrowColor))[3],
        }, drawing.BlendMode.SRC_IN))
    } else if (!this.options.arrowIcons.keepIconColor && this.options.backgroundColor != undefined) {
      instance.fillColor(this.options.backgroundColor)
        .colorFilter(drawing.ColorFilter.createBlendModeColorFilter({
          red: CommonUtils.hex2rgba(CommonUtils.resourceColor2Hex(this.options.backgroundColor))[0],
          green: CommonUtils.hex2rgba(CommonUtils.resourceColor2Hex(this.options.backgroundColor))[1],
          blue: CommonUtils.hex2rgba(CommonUtils.resourceColor2Hex(this.options.backgroundColor))[2],
          alpha: CommonUtils.hex2rgba(CommonUtils.resourceColor2Hex(this.options.backgroundColor))[3],
        }, drawing.BlendMode.SRC_IN))
    }
  }
}