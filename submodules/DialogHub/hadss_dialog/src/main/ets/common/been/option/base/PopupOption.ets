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
import { deviceInfo } from '@kit.BasicServicesKit';
import { DefaultComponent } from '../../../../components/base/DefaultComponent';
import { ArrowIcons } from '../../style/PopupStyle';
import { DefaultContent } from '../DefaultContent';
import { CustomOption } from './CustomOption';
import { componentUtils, ComponentUtils, Offset } from '@kit.ArkUI';
import { PopupRelativePosition, popupRelativePositionDic } from '../../../constant/DialogAlignment';
import { POPUP_SHELL_ID } from '../../../constant/Consntant';
import { DimensionUtils } from '../../../util/DimensionUtils';
import { DialogHub } from '../../../../model/DialogHub';
import { catchError } from '../../../util/catchError';

/**
 * Popup window properties, based on BuilderOption
 * */
@Observed
export class PopupOption extends CustomOption {
  public customContent: WrappedBuilder<[ESObject]> = wrapBuilder(DefaultComponent);
  public customContentParam?: ESObject = new DefaultContent('');
  public isModal: boolean = false; // Whether to open the enlightenment layer
  public alignment: DialogAlignment = DialogAlignment.TopStart;
  public preferPlacement: Placement = Placement.Top;
  public enableArrow: boolean = true // Whether to show the arrow of Popup window
  public arrowOffset: Length = 0
  public arrowWidth: Length = 15
  public arrowHeight: Length = ''  // auto Detect by Image
  // The unique ID attribute of the target component to be bound
  public targetCompId?: string;
  // public radius?: Dimension | BorderRadiuses = 5;
  // public backgroundColor: ResourceColor = '#88000000';
  public arrowColor?: ResourceColor;
  public edgePadding?: number = 0;
  // use for self
  public areaChangedCallback?: () => void;
  public componentUtil?: ComponentUtils;
  public targetCompRectangle?: componentUtils.ComponentInfo;
  public dialogShellRectangle?: componentUtils.ComponentInfo;
  public curPlacement: Placement = this.preferPlacement;
  public popupOffset: Offset = { x: 0, y: 0 } // vp
  public arrowActualOffset: Offset = { x: 0, y: 0 } // vp
  public visible: Visibility = Visibility.Hidden;
  public arrowIcons: ArrowIcons = {
    top: $r('app.media.popup_arrow_top'),
    bottom: $r('app.media.popup_arrow_bottom'),
    left: $r('app.media.popup_arrow_left'),
    right: $r('app.media.popup_arrow_right'),
    keepIconColor: false
  };
  public backgroundColor: ResourceColor = 'rgb(253,253,254)';
  public borderWidth: number = 2;
  public borderColor: ResourceColor = Color.White;
  public radius: number = 400;
  public shadow: ShadowOptions = {
    radius: 60,
    color: '#29000000'
  };
  getPopupArrowIcon() {
    let curPosition = popupRelativePositionDic[this.curPlacement];
    let icon: Resource;
    switch (curPosition) {
      case PopupRelativePosition.Top:
        icon = this.arrowIcons.bottom as Resource;
        break;
      case PopupRelativePosition.Bottom:
        icon = this.arrowIcons.top as Resource;
        break;
      case PopupRelativePosition.Left:
        icon = this.arrowIcons.right as Resource;
        break;
      case PopupRelativePosition.Right:
        icon = this.arrowIcons.left as Resource;
        break;
    }
    return icon;
  }

  getPopupArrowOffset() {
    let position: Position = { x: 0, y: 0 };
    // 0.5 to Pixel alignment
    let fixPixelX = 0;
    let fixPixelY = 0;
    let fixDistance = 0.5
    switch (popupRelativePositionDic[this.curPlacement]) {
      case PopupRelativePosition.Top:
        fixPixelY = -fixDistance;
        break;
      case PopupRelativePosition.Bottom:
        fixPixelY = fixDistance;
        break;
      case PopupRelativePosition.Left:
        fixPixelX = -fixDistance;
        break;
      case PopupRelativePosition.Right:
        fixPixelX = fixDistance;
        break;
    }

    position.x = `${Math.round(DialogHub.getUIContext().vp2px(this.arrowActualOffset.x - this.popupOffset.x + fixPixelX))}px`;
    position.y = `${Math.round(DialogHub.getUIContext().vp2px(this.arrowActualOffset.y - this.popupOffset.y + fixPixelY))}px`;
    return position
  }

  @catchError()
  getPopupPositionWithPx() {
    let position: Offset = { x: 0, y: 0 };
    let dialogShellRectangle = this.dialogShellRectangle;
    if ((!dialogShellRectangle || dialogShellRectangle.size.width === 0 || dialogShellRectangle.size.height === 0) &&
    this.componentUtil) {
      dialogShellRectangle = this.componentUtil.getRectangleById(POPUP_SHELL_ID + this.dialogId);
    }

    // fix getRectangleById does not reflect offset property,change to use getPositionToWindowWithTransform function
    let uiContext = DialogHub.getUIContext();
    let frameNode = uiContext.getFrameNodeById(this.targetCompId);
    if (frameNode && dialogShellRectangle) {
      let positionInfo = frameNode.getPositionToWindowWithTransform();
      position.x = uiContext.vp2px(positionInfo.x) - dialogShellRectangle.windowOffset.x;
      position.y = uiContext.vp2px(positionInfo.y) - dialogShellRectangle.windowOffset.y;
    }
    return position;
  }

  getFinalOffset(): Position {
    let position: Position = { x: 0, y: 0 };
    position.x = `${Math.round(DialogHub.getUIContext().vp2px(this.popupOffset.x))}px`;
    position.y = `${Math.round(DialogHub.getUIContext().vp2px(this.popupOffset.y))}px`;
    return position;
  }

  getRadiusPx(): number {
    let radius = this.radius ?? 0;
    if (typeof radius === 'string') {
      return DimensionUtils.stirng2Px(radius);
    } else if (typeof radius === 'number') {
      return DialogHub.getUIContext().vp2px(radius);
    } else if (Reflect.has(radius, 'topLeft')) {
      let values: number[] = [];
      values.push(DimensionUtils.length2px(Reflect.get(radius, 'topLeft')));
      values.push(DimensionUtils.length2px(Reflect.get(radius, 'topRight')));
      values.push(DimensionUtils.length2px(Reflect.get(radius, 'bottomLeft')));
      values.push(DimensionUtils.length2px(Reflect.get(radius, 'bottomRight')));
      return Math.max(...values);
    } else {
      return DimensionUtils.resource2Px(radius as Resource);
    }
  }
}