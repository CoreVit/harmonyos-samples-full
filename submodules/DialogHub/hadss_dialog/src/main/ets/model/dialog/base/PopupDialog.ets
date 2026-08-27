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
import { PopupOption } from '../../../common/been/option/base/PopupOption';
import { InfPopup } from '../interface/InfPopup';
import { CustomDialog } from './CustomDialog';
import { DimensionUtils } from '../../../common/util/DimensionUtils';
import { DialogLifeCycle } from '../../lifecycle/DialogLifeCycle';
import { componentUtils, inspector, Offset } from '@kit.ArkUI';
import { CompUtils } from '../../../common/util/CompUtils';
import { DialogStyle } from '../../../common/been/style/DialogStyle';
import { POPUP_ARROW_ID, POPUP_SHELL_ID } from '../../../common/constant/Consntant';
import { PopupRelativePosition, popupRelativePositionDic } from '../../../common/constant/DialogAlignment';
import { DialogConfig } from '../../../common/been/config/DialogConfig';
import { PopupConfig } from '../../../common/been/config/PopupConfig';
import { DHubLogger } from '../../../log/DHubLogger';
import { DialogType } from '../../../common/constant/DialogType';
import { DialogHub } from '../../DialogHub';
import { catchError } from '../../../common/util/catchError';

/**
 * Encapsulated popup instances, based on systematic CustomDialog, support custom content.
 * */
export class PopupDialog extends CustomDialog implements InfPopup {
  private dialogCompListener?: inspector.ComponentObserver;
  private dialogRectangle?: componentUtils.ComponentInfo;
  private componentUtil = this.uiContext.getComponentUtils();
  private needWaitRouter = false;
  private onDialogCompLayoutComplete: () => void = (): void => {
    this.dialogCompListener?.off('layout', this.onDialogCompLayoutComplete);
  }
  private arrowOffsetXCache = 0
  private arrowOffsetYCache = 0
  private selfRectangle: componentUtils.ComponentInfo | undefined = undefined;

  constructor(uiContext: UIContext, options: PopupOption, lifeCycle: DialogLifeCycle) {
    super(uiContext, options, lifeCycle);
    DHubLogger.debug(`PopupDialogId:${this.dialogId},type:${DialogType[this.type]}, Building`);
    options.componentUtil = this.componentUtil;
    options.curPlacement = options.preferPlacement;

    if (options.targetCompId && CompUtils.judgeID(this.uiContext, options.targetCompId)) {
      options.targetCompRectangle = this.componentUtil.getRectangleById(options.targetCompId);
    }
    this.observeDialogComponent();
    DHubLogger.debug(`PopupDialogId:${this.dialogId},type:${DialogType[this.type]}, Builded`);
  }

  public show(isInsideCall?: boolean | undefined): boolean {
    DHubLogger.debug(`DialogId:${this.dialogId},type:${DialogType[this.type]}, start popup show before Judge`);
    let compId = (this.builderOptions as PopupOption).targetCompId;
    if (compId) {
      let res = CompUtils.judgeID(this.uiContext, compId);
      if (res) {
        let final = super.show(isInsideCall);
        if (final) {
          if (this.needWaitRouter) {
            // wait when router/navigation to old Page
            setTimeout(() => {
              this.updateDialogPosition();
              this.needWaitRouter = false;
            }, 50)
          } else {
            this.updateDialogPosition();
          }
        }
        return final;
      } else {
        return false;
      }
    } else {
      return false
    }
  }

  private observeDialogComponent() {
    this.dialogCompListener = DialogHub.getUIContext().getUIInspector().createComponentObserver(this.dialogId);
    this.dialogCompListener?.on('layout', this.onDialogCompLayoutComplete);
  }

  public updateStyle(style: DialogStyle): void {
    DHubLogger.debug(`PopupDialogId:${this.dialogId},type:${DialogType[this.type]}, dialog updateStyle`);
    super.updateStyle(style);
    this.updateDialogPosition();
  }

  public updateConfig(config: DialogConfig): void {
    DHubLogger.debug(`PopupDialogId:${this.dialogId},type:${DialogType[this.type]}, dialog updateStyle`);
    let tempPlacement = (config as PopupConfig).dialogPosition?.preferPlacement;
    if (tempPlacement != undefined) {
      (this.builderOptions as PopupOption).curPlacement = tempPlacement;
      this.update(['curPlacement']);
    }
    super.updateConfig(config);
  }

  public updateComponentTargetId(targetCompId: string) {
    let res = CompUtils.judgeID(this.uiContext, targetCompId);
    if (!res) {
      return;
    }
    DHubLogger.debug(`PopupDialogId:${this.dialogId},type:${DialogType[this.type]}, dialog updateTargetId`);
    (this.builderOptions as PopupOption).targetCompId = targetCompId;
    this.update(['targetCompId']);
    this.updateDialogPosition();
  }

  public hide(isInsideCall?: boolean | undefined): boolean {
    this.needWaitRouter = Boolean(isInsideCall); // need wait when router/navigation to old Page
    return super.hide(isInsideCall)
  }

  @catchError()
  public updateDialogPosition() {
    let updateKeys: string[] = ['isShow'];
    if ((this.builderOptions as PopupOption).targetCompId && this.isShown) {
      DHubLogger.debug(`PopupDialogId:${this.dialogId},type:${DialogType[this.type]}, start Update Position`);
      let targetRectangle = this.componentUtil.getRectangleById((this.builderOptions as PopupOption).targetCompId);
      (this.builderOptions as PopupOption).targetCompRectangle = targetRectangle;
      updateKeys.push('targetCompRectRectangle')
      DHubLogger.debug(`PopupDialogId:${this.dialogId},type:${DialogType[this.type]}, Got targetRectangle ${JSON.stringify(targetRectangle)}}`);
      if (!this.selfRectangle) {
        this.selfRectangle = this.componentUtil.getRectangleById(this.builderOptions.dialogId);
        if (this.selfRectangle.size.width == 0 && this.selfRectangle.size.height == 0) {
          this.selfRectangle = undefined;
        }
      }
      let selfRectangle = this.selfRectangle ?? this.componentUtil.getRectangleById(this.builderOptions.dialogId);
      DHubLogger.debug(`PopupDialogId:${this.dialogId},type:${DialogType[this.type]}, Got selfRectangle ${JSON.stringify(selfRectangle)}}`);
      this.dialogRectangle = selfRectangle;

      if (selfRectangle.size.width === 0 || selfRectangle.size.height === 0) {
        DHubLogger.debug(`PopupDialogId:${this.dialogId},type:${DialogType[this.type]}, Need ReUpdate`);
        (this.builderOptions as PopupOption).visible = Visibility.Hidden;
        let dialogCompListener = DialogHub.getUIContext().getUIInspector().createComponentObserver(this.dialogId);
        let listenerCall = () => {
          this.updateDialogPosition();
          dialogCompListener?.off('layout', listenerCall);
        }
        dialogCompListener?.on('layout', listenerCall);
        this.update(['visible']);
        return;
      } else {
        (this.builderOptions as PopupOption).visible = Visibility.Visible;
        updateKeys.push('visible');
      }

      let parentRectangle = (this.builderOptions as PopupOption).dialogShellRectangle;
      if (!parentRectangle || parentRectangle.size.width === 0 || parentRectangle.size.height === 0) {
        parentRectangle = this.componentUtil.getRectangleById(POPUP_SHELL_ID + this.dialogId);
        (this.builderOptions as PopupOption).dialogShellRectangle = parentRectangle;
        DHubLogger.debug(`PopupDialogId:${this.dialogId},type:${DialogType[this.type]}, Re Got parentRectangleNeed ${JSON.stringify(parentRectangle)}`);
        updateKeys.push('dialogShellRectangle');
      }

      let offsetNeed = this.getFixOffsetWithVp(parentRectangle, selfRectangle);
      (this.builderOptions as PopupOption).popupOffset = offsetNeed
      updateKeys.push('popupOffset');
      DHubLogger.debug(`PopupDialogId:${this.dialogId},type:${DialogType[this.type]}, offsetNeed ${JSON.stringify(offsetNeed)}`);

      // calculate ande change Placement
      let selfWidth = selfRectangle.size.width;
      let selfHeight = selfRectangle.size.height;
      let curPosition = popupRelativePositionDic[(this.builderOptions as PopupOption).curPlacement];
      let preferPosition = popupRelativePositionDic[(this.builderOptions as PopupOption).preferPlacement];

      if (preferPosition === PopupRelativePosition.Left || preferPosition === PopupRelativePosition.Right) {
        let leftValid = this.getRectangleDistance('left', targetRectangle, parentRectangle) >= selfWidth;
        let rightValid = this.getRectangleDistance('right', targetRectangle, parentRectangle) >= selfWidth;
        if (preferPosition === curPosition) {
          if (offsetNeed.x > 0) {
            this.changeCurPlacement(PopupRelativePosition.Right)
          } else if (offsetNeed.x < 0) {
            this.changeCurPlacement(PopupRelativePosition.Left);
          }
        } else {
          // recover
          if (curPosition === PopupRelativePosition.Right && offsetNeed.x <= 0 && leftValid) {
            this.changeCurPlacement(PopupRelativePosition.Left)
          } else if (curPosition === PopupRelativePosition.Left && offsetNeed.x >= 0 && rightValid) {
            this.changeCurPlacement(PopupRelativePosition.Right)
          }
        }
      } else {
        let topValid = this.getRectangleDistance('top', targetRectangle, parentRectangle) >= selfHeight;
        let bottomValid = this.getRectangleDistance('bottom', targetRectangle, parentRectangle) >= selfHeight;
        if (preferPosition === curPosition) {
          if (offsetNeed.y > 0) {
            this.changeCurPlacement(PopupRelativePosition.Bottom)
          } else if (offsetNeed.y < 0) {
            this.changeCurPlacement(PopupRelativePosition.Top);
          }
        } else {
          // recover
          if (curPosition === PopupRelativePosition.Bottom && offsetNeed.y <= 0 && topValid) {
            (this.changeCurPlacement(PopupRelativePosition.Top))
          } else if (curPosition === PopupRelativePosition.Top && offsetNeed.y <= 0 && bottomValid) {
            (this.changeCurPlacement(PopupRelativePosition.Bottom))
          }
        }
      }
      this.updateArrowActualOffset();
      this.update(updateKeys);
      DHubLogger.debug(`PopupDialogId:${this.dialogId},type:${DialogType[this.type]}, Finish Update`);
    }
  }

  private changeCurPlacement(targetPosition: PopupRelativePosition) {
    DHubLogger.debug(`PopupDialogId:${this.dialogId},type:${DialogType[this.type]}, ChangePlacement to ${PopupRelativePosition[targetPosition]}`);
    let curPosition = popupRelativePositionDic[(this.builderOptions as PopupOption).curPlacement];
    let needChange = false;
    switch (targetPosition) {
      case PopupRelativePosition.Left:
      case PopupRelativePosition.Top:
        if (curPosition !== PopupRelativePosition.Left && curPosition !== PopupRelativePosition.Top) {
          (this.builderOptions as PopupOption).curPlacement -= 1;
          this.update(['curPlacement']);
          needChange = true;
        } else {
          needChange = false;
        }
        break;
      case PopupRelativePosition.Right:
      case PopupRelativePosition.Bottom:
        if (curPosition !== PopupRelativePosition.Right && curPosition !== PopupRelativePosition.Bottom) {
          (this.builderOptions as PopupOption).curPlacement += 1;
          this.update(['curPlacement']);
          needChange = true;
        } else {
          needChange = false;
        }
        break;
    }
    if (needChange) {
      switch (targetPosition) {
        case PopupRelativePosition.Left:
        case PopupRelativePosition.Right:
          (this.builderOptions as PopupOption).popupOffset.x = 0;
        case PopupRelativePosition.Top:
        case PopupRelativePosition.Bottom:
          (this.builderOptions as PopupOption).popupOffset.y = 0;
      }
      this.update(['curPlacement'])
    }
    return needChange;
  }

  private getFixOffsetWithVp(parent: componentUtils.ComponentInfo, self: componentUtils.ComponentInfo): Offset {
    let offset: Offset = { x: 0, y: 0 };
    if (parent.size.width === 0 || parent.size.height === 0) {
      return offset;
    }

    let topDistance = this.getRectangleDistance('top', self, parent);
    if (topDistance > 0) {
      let bottomDistance = this.getRectangleDistance('bottom', self, parent);
      if (bottomDistance < 0) {
        offset.y = bottomDistance;
      }
    } else {
      offset.y = topDistance * -1;
    }

    let leftDistance = this.getRectangleDistance('left', self, parent);
    if (leftDistance > 0) {
      let rightDistance = this.getRectangleDistance('right', self, parent);
      if (rightDistance < 0) {
        offset.x = rightDistance;
      }
    } else {
      offset.x = leftDistance * -1;
    }

    offset.x = DialogHub.getUIContext().px2vp(offset.x)
    offset.y = DialogHub.getUIContext().px2vp(offset.y)
    return offset;
  }

  @catchError()
  private updateArrowActualOffset() {
    DHubLogger.debug(`PopupDialogId:${this.dialogId},type:${DialogType[this.type]}, updateArrowOffset`);
    let arrowRectangle = this.componentUtil?.getRectangleById(POPUP_ARROW_ID + this.dialogId);
    let shellRectangle = this.dialogRectangle;
    DHubLogger.debug(`PopupDialogId:${this.dialogId},type:${DialogType[this.type]}, arrowRectangle ${JSON.stringify(arrowRectangle)}`);
    DHubLogger.debug(`PopupDialogId:${this.dialogId},type:${DialogType[this.type]}, shellRectangle ${JSON.stringify(shellRectangle)}`);

    if (arrowRectangle && shellRectangle) {
      let preferPosition = popupRelativePositionDic[(this.builderOptions as PopupOption).preferPlacement];
      let popupOffset = (this.builderOptions as PopupOption).popupOffset;
      let arrowOffset: Offset = { x: popupOffset.x, y: popupOffset.y };
      let radiusLength = (this.builderOptions as PopupOption).getRadiusPx();

      switch (preferPosition) {
        case PopupRelativePosition.Top:
        case PopupRelativePosition.Bottom:
          arrowOffset.x = DimensionUtils.length2px((this.builderOptions as PopupOption).arrowOffset);
          if (this.getRectangleDistance('left', arrowRectangle, shellRectangle) <= radiusLength ||
            this.getRectangleDistance('right', arrowRectangle, shellRectangle) <= radiusLength) {
            if (this.arrowOffsetXCache === 0) {
              this.arrowOffsetXCache = popupOffset.x;
            }
            arrowOffset.x = popupOffset.x - this.arrowOffsetXCache;
          } else {
            this.arrowOffsetXCache = 0
          }
          break;
        case PopupRelativePosition.Left:
        case PopupRelativePosition.Right:
          arrowOffset.y = DimensionUtils.length2px((this.builderOptions as PopupOption).arrowOffset);
          if (this.getRectangleDistance('top', arrowRectangle, shellRectangle) <= radiusLength ||
            this.getRectangleDistance('bottom', arrowRectangle, shellRectangle) <= radiusLength) {
            if (this.arrowOffsetYCache === 0) {
              this.arrowOffsetYCache = popupOffset.y;
            }
            arrowOffset.y = popupOffset.y - this.arrowOffsetYCache;
          } else {
            this.arrowOffsetYCache = 0
          }
          break;
      }
      (this.builderOptions as PopupOption).arrowActualOffset = arrowOffset;
      DHubLogger.debug(`PopupDialogId:${this.dialogId},type:${DialogType[this.type]}, update arrowOffset ${JSON.stringify(arrowOffset)}`);
      this.update(['arrowActualOffset'])
    }
  }

  private getRectangleDistance(tag: 'left' | 'right' | 'top' | 'bottom', child: componentUtils.ComponentInfo,
    parent: componentUtils.ComponentInfo) {
    if (tag === 'right') {
      return parent.screenOffset.x + parent.size.width - (child.screenOffset.x + child.size.width);
    } else if (tag === 'left') {
      return child.screenOffset.x - parent.screenOffset.x;
    } else if (tag === 'bottom') {
      return parent.screenOffset.y + parent.size.height - (child.screenOffset.y + child.size.height);
    } else {
      return child.screenOffset.y - parent.screenOffset.y;
    }
  }
}