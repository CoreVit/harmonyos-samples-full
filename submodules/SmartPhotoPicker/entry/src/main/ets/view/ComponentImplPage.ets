/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import { window } from '@kit.ArkUI';
import { deviceInfo } from '@kit.BasicServicesKit';
import { photoAccessHelper, PhotoPickerComponent, PickerController, PickerOptions } from '@kit.MediaLibraryKit';
import { BreakpointConstants } from '../common/BreakpointConstants';
import { CommonConstants } from '../common/CommonConstants';
import { itemData } from '../module/ItemData';
import { ItemInfo } from '../module/ItemInfo';
import Logger from '../utils/Logger';

const TAG: string = '[ComponentImplPage]';

@Component
export struct ComponentImplPage {
  @State content: string = '';
  @State selectedIndex: number = 0;
  @State isShow: boolean = false;
  @State recommendationType: number = 4;
  @State isTypePickerShow: boolean = false;
  @State isTextPickerShow: boolean = false;
  @State isEnable: boolean = false;
  @State windowClass: window.Window | undefined = undefined;
  @State pickerController: PickerController = new PickerController();
  @StorageLink(CommonConstants.KEY_WIDTH_BP) currentWidthBreakpoint: string = BreakpointConstants.BREAKPOINT_LG;
  pickerOptions: PickerOptions = new PickerOptions();
  private selectItem: ResourceStr[] = [$r('app.string.identity_card'), $r('app.string.QR_code')];
  private componentSelectDialog: CustomDialogController = new CustomDialogController({
    builder: () => {
      this.SelectDialogBuilder();
    },
    cancel: () => {
      this.selectedIndex = 0;
    },
    height: 216
  })
  private componentInputDialog: CustomDialogController = new CustomDialogController({
    builder: () => {
      this.InputDialogBuilder();
    },
    cancel: () => {
      this.content = '';
      this.isEnable = false;
    },
    height: 186
  })

  aboutToAppear(): void {
    this.windowClass = AppStorage.get(CommonConstants.KEY_WINDOW_CLASS);
  }

  aboutToDisappear(): void {
    try {
      AppStorage.delete(CommonConstants.KEY_WINDOW_CLASS);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, 'Delete AppStorage data failed, error.code = ' + err.code);
    }
  }

  @Builder
  SelectDialogBuilder() {
    Column() {
      Text($r('app.string.select_keywords'))
        .fontSize(20)
        .margin({ bottom: 15 })
        .fontWeight(FontWeight.Bold)
        .fontColor($r('sys.color.font_primary'))
      Column() {
        ForEach(this.selectItem, (item: ResourceStr, index: number) => {
          Row() {
            Text(item)
              .fontSize(16)
              .fontColor($r('sys.color.font_primary'))
            Image($r(this.selectedIndex === index ? 'app.media.checkmark_circle' : 'app.media.circle'))
              .width(24)
              .height(24)
              .fillColor($r(this.selectedIndex === index ? 'sys.color.comp_background_emphasize' :
                'sys.color.icon_tertiary'))
          }
          .width('100%')
          .height(48)
          .border({
            width: { bottom: 1 },
            color: $r('sys.color.comp_background_tertiary'),
            style: BorderStyle.Solid
          })
          .justifyContent(FlexAlign.SpaceBetween)
          .onClick(() => {
            this.selectedIndex = index;
            if (index === 0) {
              this.recommendationType = photoAccessHelper.RecommendationType.ID_CARD;
            } else {
              this.recommendationType = photoAccessHelper.RecommendationType.QR_CODE;
            }
          })
        }, (index: number) => index.toString())
      }

      Row() {
        Button($r('app.string.cancel'), { buttonStyle: ButtonStyleMode.TEXTUAL })
          .width('40%')
          .height(40)
          .onClick(() => {
            this.componentSelectDialog.close();
            this.selectedIndex = 0;
          })
        Button($r('app.string.confirm'), { buttonStyle: ButtonStyleMode.EMPHASIZED })
          .width('40%')
          .height(40)
          .onClick(() => {
            this.isTypePickerShow = true;
            this.pickerOptions.recommendationOptions = {
              recommendationType: this.recommendationType
            };
          })
          .bindSheet($$this.isTypePickerShow, this.photoPickerBuilder(), {
            preferType: SheetType.CENTER,
            title: { title: $r('app.string.Component_recommendation') }
          })
      }
      .width('100%')
      .margin({ top: 8 })
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .height('100%')
    .padding({
      left: 24,
      right: 24,
      top: 15,
      bottom: 15
    })
  }

  @Builder
  InputDialogBuilder() {
    Column() {
      Text($r('app.string.enter_keywords'))
        .fontSize(20)
        .margin({ bottom: 30 })
        .fontWeight(FontWeight.Bold)
        .fontColor($r('sys.color.font_primary'))
      TextInput({ placeholder: $r('app.string.input_text') })
        .width('100%')
        .height(48)
        .showUnderline(true)
        .underlineColor(Color.Gray)
        .onChange((value: string) => {
          if (value.trim().length !== 0 && value.trim().length < 99) {
            this.content = value;
            this.isEnable = true;
          } else {
            this.isEnable = false;
          }
        })
      Row() {
        Button($r('app.string.cancel'), { buttonStyle: ButtonStyleMode.TEXTUAL })
          .width('40%')
          .height(40)
          .onClick(() => {
            this.componentInputDialog.close();
            this.content = '';
            this.isEnable = false;
          })
        Button($r('app.string.confirm'), { buttonStyle: ButtonStyleMode.TEXTUAL })
          .width('40%')
          .height(40)
          .enabled(this.isEnable)
          .onClick(() => {
            this.isTextPickerShow = true;
            let textInfo: photoAccessHelper.TextContextInfo = {
              text: this.content
            };
            this.pickerOptions.recommendationOptions = {
              textContextInfo: textInfo
            };
          })
          .bindSheet($$this.isTextPickerShow, this.photoPickerBuilder(), {
            preferType: SheetType.CENTER,
            title: { title: $r('app.string.Component_recommendation') }
          })
      }
      .width('100%')
      .margin({ top: 8 })
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .height('100%')
    .padding({
      left: 24,
      right: 24,
      top: 15,
      bottom: 15
    })
  }

  @Builder
  photoPickerBuilder() {
    Flex({
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.Center,
      alignItems: ItemAlign.Center
    }) {
      PhotoPickerComponent({
        pickerOptions: this.pickerOptions,
        pickerController: this.pickerController
      })
        .height('100%')
        .width('100%')
    }
  }

  build() {
    Column({ space: 12 }) {
      Text($r('app.string.Component_recommendation'))
        .fontSize(14)
        .margin({ left: 12 })
        .fontColor($r('sys.color.font_secondary'))
      GridRow({
        columns: {
          sm: BreakpointConstants.GRID_ROW_COLUMNS[2],
          md: BreakpointConstants.GRID_ROW_COLUMNS[0],
          lg: BreakpointConstants.GRID_ROW_COLUMNS[0]
        },
        gutter: '12vp'
      }) {
        ForEach(itemData, (item: ItemInfo, index: number) => {
          GridCol({
            span: {
              sm: BreakpointConstants.GRID_COLUMN_SPANS[5],
              md: BreakpointConstants.GRID_COLUMN_SPANS[1],
              lg: BreakpointConstants.GRID_COLUMN_SPANS[1],
            }
          }) {
            Row() {
              Text(item.title)
                .fontSize(16)
                .fontColor($r('sys.color.font_primary'))
              Image($r('app.media.right_arrow'))
                .width(12)
                .height(24)
                .fillColor($r('sys.color.icon_fourth'))
            }
            .width('100%')
            .height(56)
            .borderRadius(deviceInfo.deviceType === CommonConstants.DEVICE_TYPE ? 8 : 16)
            .backgroundColor($r('app.color.list_item_bg'))
            .padding({ left: 12, right: 12 })
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Center)
            .onClick(() => {
              if (index === 0) {
                this.isShow = true;
                this.pickerOptions = {};
              } else if (index === 1) {
                this.componentSelectDialog.open();
              } else {
                if (this.windowClass) {
                  try {
                    this.windowClass.setWindowPrivacyMode(true, (err: BusinessError) => {
                      if (err) {
                        Logger.error(TAG, `Failed to set the window to privacy mode. Cause code: ${err.code}`);
                        return;
                      }
                      Logger.info(TAG, 'Succeeded in setting the window to privacy mode.');
                    });
                  } catch (exception) {
                    Logger.error(TAG, `Failed to set the window to privacy mode. Cause code: ${exception.code}`);
                  }
                }
                this.componentInputDialog.open();
              }
            })
          }
        }, (item: ItemInfo) => item.index.toString())
      }
    }
    .width(CommonConstants.FULL_PARENT)
    .padding({ top: 28 })
    .alignItems(HorizontalAlign.Start)
    .bindSheet($$this.isShow, this.photoPickerBuilder(), {
      preferType: SheetType.CENTER,
      title: { title: $r('app.string.Component_recommendation') }
    })
  }
}