/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import {
  IconHorizontalToastContent,
  IconVerticalToastContent,
  MenuPopupContent,
  ActionSheetContent,
  ConfirmHorizontalDialogContent,
  ConfirmVerticalDialogContent,
  PopupItem,
  IconPosition,
  SheetItem,
  ButtonItemParams,
} from './PresetContent'

export interface PresetTemplate<T extends Object> {
  builder: WrappedBuilder<[T]>;
  param: T;
}

@Builder
export function IconHorizontalToastBuilder(content: IconHorizontalToastContent) {
  Column() {
    Row() {
      Row() {
        if (content.icon) {
          Image($r(content.icon))
            .width(20)
            .objectFit(ImageFit.Contain)
            .margin({ right: 12 })
        }
        Text(content.text)
          .fontSize(14)
          .lineHeight(19)
          .fontWeight(400)
          .fontColor($r('app.color.mainTextColor'))
          .margin({ right: 10 })
      }
      Row() {
        if (content.button) {
          Text(content.button)
            .fontSize(14)
            .lineHeight(19)
            .fontWeight(400)
            .fontColor($r('app.color.primaryButtonColor'))
            .onClick(() => {
              if (content.buttonCallback) {
                content.buttonCallback(content.dialog!);
              }
            })
        }
        if (content.buttonBuilder) {
          content.buttonBuilder.builder();
        }
      }
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .height('100%')
    .padding({
      top: 12,
      right: 0,
      bottom: 12,
      left: 0
    })
  }
  .width('100%')
  .height('100%')
  .padding({
    top: 0,
    right: 8,
    bottom: 0,
    left: 12
  })
}

@Builder
export function IconVerticalToastBuilder(content: IconVerticalToastContent) {
  Column({ space: 25 }) {
    if (content.icon) {
      Image($r(content.icon))
        .width(44)
        .objectFit(ImageFit.Contain)
    }
    if (content.text) {
      Text(content.text)
        .fontSize(14)
        .lineHeight(19)
        .fontWeight(400)
        .fontColor($r('app.color.mainTextColor'))
    }
  }
  .backdropBlur(80)
  .padding({
    left: 20,
    right: 20,
    top: 25,
    bottom: 25
  })
}


@Builder
export function MenuPopupBuilder(content: MenuPopupContent) {
  Column() {
    ForEach(content.popupList, (item: PopupItem) => {
      Row() {
        if (content.showIcon && (content.iconPosition === IconPosition.LEFT)) {
          Image($r(item.icon))
            .width(19)
            .height('auto')
            .margin({ left: 3, right: 11 })
        }
        Text(item.text)
          .fontSize(16)
          .fontColor($r('app.color.mainTextColor'))
          .lineHeight(21)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .layoutWeight(1)
          .onClick(() => {
            item.itemClick?.(content.dialog!)
          })
        if (content.showIcon && content.iconPosition === IconPosition.RIGHT) {
          Image($r(item.icon))
            .width(19)
            .height('auto')
            .margin({ left: 11, right: 3 })
        }
      }
      .width('100%')
      .padding({
        top: 12,
        bottom: 12
      })
    }, (item: PopupItem, index: number) => {
      return index + '_' + item.text;
    })
  }
  .width(224)
  .padding({
    top: 4,
    bottom: 4,
    left: 16,
    right: 16
  })
}

@Builder
export function ActionSheetBuilder(content: ActionSheetContent) {
  Column() {
    Column({ space: content?.isTransparent ? 0 : 12 }) {
      ForEach(content?.sheetList, (sheetItem: SheetItem, index: number) => {
        Row() {
          if (sheetItem.icon) {
            Column() {
              Image($r(sheetItem.icon))
                .width($r('app.string.ActionSheetItem_Image_Width'))
                .height('auto')
            }
            .justifyContent(FlexAlign.Center)
            .width(48)
            .height(48)
            .margin({ right: 16 })
          }

          Text(sheetItem.text)
            .fontSize(16)
            .fontColor($r('app.color.mainTextColor'))
            .fontWeight(500)
            .lineHeight(21)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .layoutWeight(1)
        }
        .border({
          width: {
            bottom: index < content?.sheetList.length - 1 && content?.isTransparent ? 1 : 0
          },
          color: '#EEEEEE',
          radius: content?.isTransparent ? 0 : 16
        })
        .backgroundColor(content?.isTransparent ? $r('app.color.sheetItemBackgroundColor2') :
        $r('app.color.sheetItemBackgroundColor1'))
        .width($r('app.string.ActionSheetItem_Width'))
        .constraintSize({
          minHeight: 64
        })
        .padding({
          left: 12,
          right: 12,
          top: 8,
          bottom: 8
        })
        .onClick(() => {
          if (sheetItem.itemClick) {
            sheetItem.itemClick(content?.dialog)
          }
        })
      }, (item: SheetItem, index: number) => {
        return index + '_' + item.text;
      })
    }
    .width('100%')
    .borderRadius(content?.isTransparent ? 16 : 0)
    .clip(true)

    if (content?.showBtnButton) {
      Button() {
        Text('取消')
          .fontColor(Color.White)
          .fontWeight(500)
          .fontSize(16)
          .lineHeight(21)
      }
      .borderRadius(20)
      .backgroundColor($r('app.color.primaryButtonColor'))
      .width('100%')
      .height(40)
      .padding({
        top: 9,
        bottom: 9,
        left: 16,
        right: 16
      })
      .margin({
        top: 12,
        bottom: 16
      })
      .onClick(() => {
        if (content?.dialog) {
          content.dialog.dismiss();
        }
      })
    }
  }
  .width($r('app.string.ActionSheet_Width'))
  .padding({
    left: $r('app.string.ActionSheetContainer_Padding'),
    right: $r('app.string.ActionSheetContainer_Padding'),
    top: content?.title ? 0 : $r('app.string.ActionSheetContainer_Padding'),
    bottom: $r('app.string.ActionSheetContainer_Padding')
  })
}

@Builder
export function ConfirmHorizontalDialogBuilder(content: ConfirmHorizontalDialogContent) {
  Column() {
    if (content.title) {
      Text(content.title)
        .fontSize(20)
        .fontColor($r('app.color.mainTextColor'))
        .fontWeight(700)
        .lineHeight(27)
        .textAlign(content.textAlign)
        .width('100%')
        .padding({
          top: 15,
          bottom: 15
        })
    }

    if (content.text) {
      Text(content.text)
        .fontSize(16)
        .fontColor($r('app.color.subTextColor'))
        .fontWeight(400)
        .lineHeight(21)
        .textAlign(content.textAlign)
        .width('100%')
        .padding({ bottom: 8 })
        .margin({
          left: 24,
          right: 24
        })
    }

    if (content.textBuilder) {
      content.textBuilder.builder(content.textBuilderParams);
    }

    Row() {
      ForEach(content.buttons, (item: ButtonItemParams) => {
        Button(item.text,
          { buttonStyle: item.buttonStyleMode })
          .width('100%')
          .fontSize(16)
          .fontWeight(500)
          .height(40)
          .fontColor(item.fontColor)
          .backgroundColor(item.backgroundColor)
          .layoutWeight(1)
          .onClick(() => {
            if (item.itemClick) {
              item.itemClick(content.dialog)
            }
          })
      }, (item: ButtonItemParams, index: number) => {
        return index + '_' + item.text;
      })
    }
    .padding({
      left: 16,
      right: 16,
      bottom: 16
    })
  }
  .width(328)
  .margin({
    left: 16,
    right: 16
  })
}

@Builder
export function ConfirmVerticalDialogBuilder(content: ConfirmVerticalDialogContent) {
  Column() {
    Column() {
      if (content.title) {
        Text(content.title)
          .fontSize(20)
          .fontColor($r('app.color.mainTextColor'))
          .fontWeight(700)
          .lineHeight(27)
          .textAlign(content.textAlign)
      }

      if (content.text) {
        Text(content.text)
          .fontSize(14)
          .fontColor($r('app.color.subTextColor'))
          .fontWeight(400)
          .lineHeight(19)
          .padding({
            top: 0,
            right: 24,
            bottom: 0,
            left: 24
          })
          .textAlign(content.textAlign)
      }

      if (content.textBuilder) {
        content.textBuilder.builder(content.textBuilderParams);
      }
    }
    .padding({
      top: 15,
      bottom: 15,
      left: 24,
      right: 24
    })

    Column({ space: 4 }) {
      ForEach(content.buttons, (item: ButtonItemParams) => {
        Button(item.text,
          { buttonStyle: item.buttonStyleMode ?? ButtonStyleMode.TEXTUAL })
          .width('100%')
          .padding({
            top: 9,
            right: 16,
            bottom: 9,
            left: 16
          })
          .height(40)
          .fontColor(item.fontColor ? item.fontColor :
            (item.buttonStyleMode === ButtonStyleMode.EMPHASIZED) ? Color.White :
            $r('app.color.primaryButtonColor'))
          .onClick(() => {
            if (item.itemClick) {
              item.itemClick(content.dialog)
            }
          })
      }, (item: ButtonItemParams, index: number) => {
        return index + '_' + item.text;
      })
    }
    .padding({
      top: 0,
      left: 16,
      right: 16,
      bottom: 8
    })
  }
  .width(328)
}