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
import { CustomOption } from '../../common/been/option/base/CustomOption'
import { PopupOption } from '../../common/been/option/base/PopupOption'
import { POPUP_ANCHOR_ID, DIALOG_MASK_ID, POPUP_SHELL_ID } from '../../common/constant/Consntant'
import { popupAlignRuleDic, alignmentDic } from '../../common/constant/DialogAlignment'
import { DialogDismissReason } from '../../common/constant/DialogDismissReason'
import { DialogType } from '../../common/constant/DialogType'
import { DialogHub } from '../../model/DialogHub'
import { AppLifeCycleHelper } from '../../model/lifecycle/AppLifeCycleHelper'
import { PopupComponent } from './PopupComponent'
import { DialogMode } from '../../common/been/config/DialogConfig'


@Builder
export function BaseDialogComponent(options: CustomOption) {
  Column() {
    if (options.type === DialogType.POPUP) {
      RelativeContainer() {
        Column()
          .id(POPUP_ANCHOR_ID)// id is useful when brother Comment
          .backgroundColor(Color.Transparent)
          .width(DialogHub.getUIContext().px2vp((options as PopupOption).targetCompRectangle?.size.width))
          .height(DialogHub.getUIContext().px2vp((options as PopupOption).targetCompRectangle?.size.height))
          .margin({
            left: `${(options as PopupOption).getPopupPositionWithPx().x}px`,
            top: `${(options as PopupOption).getPopupPositionWithPx().y}px`
          })
          .hitTestBehavior(HitTestMode.Transparent)

        Column() {
          PopupComponent(options as PopupOption)
        }
        .alignRules(popupAlignRuleDic[(options as PopupOption).curPlacement])
        .id(options.dialogId)
        // Control by setStyle
        .justifyContent(FlexAlign.Start)
        .visibility(options.isShow ? Visibility.Visible : Visibility.Hidden)
        .transition(options.animation?.dialogAnimation as TransitionEffect)
        .onTouch((event) => {
          if (!options.passThroughGesture) {
            event.stopPropagation();
          }
        })
        .offset(((options as PopupOption).getFinalOffset()))
        .gestureModifier(new PassThroughGestureModifier(options.passThroughGesture))

        if (options.isModal && options.dialogMode === DialogMode.OVERLAY_MANAGER) {
          Column()
            .id(DIALOG_MASK_ID)
            .width(options.maskRect?.width ?? '100%')
            .height(options.maskRect?.height ?? '100%')
            .position({ x: options.maskRect?.x, y: options.maskRect?.y })
            .backgroundColor(options.maskColor ?? '#55000000')
            .backgroundEffect(options.maskBackgroundEffect)
            .visibility(options.isShow ? Visibility.Visible : Visibility.Hidden)
            .transition(options.animation?.customMaskAnimation as TransitionEffect)
            .hitTestBehavior(options.autoDismiss ? HitTestMode.Block : HitTestMode.Transparent)
            .zIndex(-1)// ensure Default focus sequence
            .hitTestBehavior(HitTestMode.Block)
            .onTouch((event) => {
              if (event.type === TouchType.Down && options.autoDismiss) {
                AppLifeCycleHelper.getInstance().getCurrentPageDialogs(options.dialogId)[0]
                ?.dismiss(DialogDismissReason.TOUCH_OUTSIDE);
              }
            })
        }
      }
      .id(POPUP_SHELL_ID + options.dialogId)
      .hitTestBehavior(HitTestMode.Transparent)
      .width('100%')
      .height('100%')
      .attributeModifier(new PopupMaskModifier(options))
    } else if (options.dialogMode === DialogMode.CUSTOM_DIALOG) {
      options.customContent.builder(options.customContentParam)
    } else {
      Stack({ alignContent: alignmentDic[options.alignment] }) {
        Column() {
          options.customContent.builder(options.customContentParam)
        }
        .position(options.position)
        .markAnchor(options.markAnchor)
        .offset({
          x: options.offset.dx,
          y: options.offset.dy
        })
        .id(options.dialogId)
        // Control by setStyle
        .clip(options.radius ? true : false)
        .width(options.width)
        .height(options.height)
        .borderRadius(options.radius)
        .shadow(options.shadow)
        .borderWidth(options.borderWidth)
        .borderColor(options.borderColor)
        .borderStyle(options.borderStyle)
        .backgroundColor(options.backgroundColor)
        .justifyContent(FlexAlign.Start)
        .visibility(options.isShow ? Visibility.Visible : Visibility.Hidden)
        .transition(options.animation?.dialogAnimation as TransitionEffect)
        .onTouch((event) => {
          if (!options.passThroughGesture) {
            event.stopPropagation();
          }
        })
        .gestureModifier(new PassThroughGestureModifier(options.passThroughGesture))

        if (options.isModal) {
          Column()
            .id(DIALOG_MASK_ID)
            .width(options.maskRect?.width ?? '100%')
            .height(options.maskRect?.height ?? '100%')
            .position({ x: options.maskRect?.x, y: options.maskRect?.y })
            .backgroundColor(options.maskColor ?? '#55000000')
            .backgroundEffect(options.maskBackgroundEffect)
            .visibility(options.isShow ? Visibility.Visible : Visibility.Hidden)
            .transition(options.animation?.customMaskAnimation as TransitionEffect)
            .hitTestBehavior(options.autoDismiss ? HitTestMode.Block : HitTestMode.Transparent)
            .zIndex(-1)// ensure Default focus sequence
            .hitTestBehavior(HitTestMode.Block)
            .onTouch((event) => {
              if (event.type === TouchType.Down && options.autoDismiss) {
                AppLifeCycleHelper.getInstance().getCurrentPageDialogs(options.dialogId)[0]
                ?.dismiss(DialogDismissReason.TOUCH_OUTSIDE);
              }
              event.stopPropagation();
            })
            .gestureModifier(new DialogMaskGestureModifier())

        }
      }
      .hitTestBehavior(HitTestMode.Transparent)
      .width('100%')
      .height('100%')
    }
  }.attributeModifier(new DialogContainerModifier(options))
}

class PassThroughGestureModifier implements GestureModifier {
  public passThroughGesture: boolean;

  constructor(passThroughGesture: boolean) {
    this.passThroughGesture = passThroughGesture;
  }

  applyGesture(event: UIGestureEvent): void {
    if (!this.passThroughGesture) {
      event.addParallelGesture(new PanGestureHandler())
      event.addParallelGesture(new TapGestureHandler())
      event.addParallelGesture(new LongPressGestureHandler())
      event.addParallelGesture(new PinchGestureHandler())
      event.addParallelGesture(new RotationGestureHandler())
      event.addParallelGesture(new SwipeGestureHandler())
    }
  }
}

/**
 * When there are multiple pop ups, the upper level pop up event cannot be transmitted to the lower level
 */
class DialogMaskGestureModifier implements GestureModifier {
  applyGesture(event: UIGestureEvent): void {
    event.addGesture(
      new PanGestureHandler()
        .onActionStart((event: GestureEvent) => {
          return;
        })
    );
    event.addGesture(
      new TapGestureHandler()
        .onAction((event: GestureEvent) => {
          return
        })
    )
  }
}

class DialogContainerModifier implements AttributeModifier<ColumnAttribute> {
  private dialogOptions: CustomOption;

  constructor(options: CustomOption) {
    this.dialogOptions = options;
  }

  applyNormalAttribute(instance: ColumnAttribute): void {
    if (this.dialogOptions.dialogMode === DialogMode.CUSTOM_DIALOG && this.dialogOptions.type !== DialogType.POPUP) {
      instance
        .id(this.dialogOptions.dialogId)
        // Control by setStyle
        .clip(this.dialogOptions.radius ? true : false)
        .width(this.dialogOptions.width)
        .height(this.dialogOptions.height)
        .borderRadius(this.dialogOptions.radius)
        .shadow(this.dialogOptions.shadow)
        .borderWidth(this.dialogOptions.borderWidth)
        .borderColor(this.dialogOptions.borderColor)
        .borderStyle(this.dialogOptions.borderStyle)
        .backgroundColor(this.dialogOptions.backgroundColor)
        .justifyContent(FlexAlign.Start)
        .visibility(this.dialogOptions.isShow ? Visibility.Visible : Visibility.Hidden)
        .transition(this.dialogOptions.animation?.dialogAnimation as TransitionEffect)
        .defaultFocus(this.dialogOptions.requestFocusWhenShow)
    } else {
      instance
        .width('100%')
        .height('100%')
        .focusable(this.dialogOptions.focusable)
        .hitTestBehavior(HitTestMode.Transparent)
    }
  }
}

class PopupMaskModifier implements AttributeModifier<RelativeContainerAttribute> {
  private dialogOptions: CustomOption;

  constructor(options: CustomOption) {
    this.dialogOptions = options;
  }

  applyNormalAttribute(instance: RelativeContainerAttribute): void {
    if (this.dialogOptions.dialogMode === DialogMode.CUSTOM_DIALOG) {
      instance
        .onClick(() => {
          AppLifeCycleHelper.getInstance().getCurrentPageDialogs(this.dialogOptions.dialogId)[0]
          ?.dismiss(DialogDismissReason.TOUCH_OUTSIDE);
        })
    }
  }
}

