/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import {
  AnimationType,
  CustomKeyboardAvoidMode,
  DialogAction,
  DialogDismissReason,
  DialogHub,
  InfCustomDialog,
  InfPopup,
  InfSheet,
} from 'hadss_dialog';
import { window } from '@kit.ArkUI';
import { ActiveCloseBuilder, ActiveCloseParams } from '../component/ActiveCloseBuilder';
import { AutoDismissBuilder, AutoDismissParams } from '../component/AutoDismissBuilder';
import { InputBuilder, InputParams } from '../component/InputBuilder';
import { SheetBuilder, SheetParams } from '../component/SheetBuilder';
import { SnackbarBuilder, SnackbarParams } from '../component/SnackbarBuilder';
import { TextToastBuilder, TextToastParams } from '../component/TextToastBuilder';
import { TimeToastBuilder, TimeToastParams } from '../component/TimeToastBuilder';
import { ItemHead } from '../utils/ItemHead';
import { ItemGroupModifier, ItemListModifier, ItemTextModifier } from '../utils/SampleModifier';
import { ImagePopupBuilder, ImagePopupParams } from '../component/ImagePopupBuilder';
import CommonConstant from '../utils/CommonConstant';
import { catchError } from 'hadss_dialog/src/main/ets/common/util/catchError';
import { resourceManager } from '@kit.LocalizationKit';

@Builder
export function CommonBuilder(name: string, param: Object) {
  CommonExamples();
}

@Component
export struct CommonExamples {
  pageInfos: NavPathStack = new NavPathStack();
  specifiedLocationDialog?: InfCustomDialog;
  intervalsDisappearsDialog?: InfCustomDialog | null;
  avoidKeyboardDialog?: InfCustomDialog;
  arrowPointingPopup?: InfPopup;
  maskCloseDialog?: InfCustomDialog;
  adjustSheetDialog?: InfSheet;
  sensorDialog?: InfCustomDialog;
  activelyCloseDialog?: InfCustomDialog;
  uiContext: UIContext | undefined = AppStorage.get(CommonConstant.TAG_NAME + 'uiContext');
  windowWidthVp: number | undefined = AppStorage.get(CommonConstant.TAG_NAME + 'windowWidthVp');
  resourceMgr: resourceManager.ResourceManager | undefined = AppStorage.get(CommonConstant.TAG_NAME + 'resourceMgr');
  @State isSensorDialogShow: boolean = false;
  @State keyboardHeightChange: number = 0;
  @State isKeyboardShow: boolean = false;
  @StorageProp(CommonConstant.TAG_NAME + CommonConstant.CURRENT_BREAK_POINT) curBp: string =
    CommonConstant.CURRENT_BREAK_POINT_SM;
  @State intervalID: number = -1;

  @catchError()
  aboutToAppear(): void {
    window.getLastWindow(this.getUIContext().getHostContext()).then((data) => {
      data.on('keyboardHeightChange', h => {
        this.keyboardHeightChange = h;
      })
      data.on('keyboardDidShow', () => {
        this.isKeyboardShow = true;
      })
      data.on('keyboardDidHide', () => {
        this.isKeyboardShow = false;
      })
    });

    this.sensorDialog = DialogHub.getCustomTemplate(CommonConstant.CUSTOM_TEMPLATE_SIMPLE)
    ?.setStyle({
      radius: '50%',
      backgroundColor: 'rgba(241,243,245,0.97)'
    })
    ?.setConfig(CommonConstant.CUSTOM_SAMPLE_CONFIG).build();

    // [Start sensor]
    this.sensorDialog?.addLifeCycleListener({
      onWillShow: () => {
        this.isSensorDialogShow = true
        return true;
      },
      onWillDismiss: (reason: DialogDismissReason) => {
        this.isSensorDialogShow = false
        return true;
      }
    })
    // [End sensor]

    // [Start sensor_log]
    // SHOW: 显示，HIDE: 隐藏， DEFAULT: 默认状态
    this.sensorDialog?.getStatus();
    // [End sensor_log]

    let sheetParams = new SheetParams();

    // [Start adjust]
    this.adjustSheetDialog = DialogHub.getSheet()
      .setContent(wrapBuilder(SheetBuilder), sheetParams)
      .setStyle({
        preferType: SheetType.BOTTOM,
        detents: [CommonConstant.SHEET_MIDDLE, CommonConstant.SHEET_LARGE],
      })
      .setConfig({ enableOutsideInteractive: false, scrollSizeMode: ScrollSizeMode.CONTINUOUS })
      .setComponentTargetId(CommonConstant.ADJUST_SHEET_DIALOG_ID)
      .build();
    // [End adjust]

    // [Start adjust_log]
    this.adjustSheetDialog.addLifeCycleListener({
      onHeightDidChange: (h: number) => {
        let vpValue = this.getUIContext().px2vp(h);
        if (this.isKeyboardShow) {
          this.getUIContext().getFocusController().clearFocus();
        }
        if (vpValue <= CommonConstant.SHEET_MIDDLE && sheetParams.type != 0) {
          sheetParams.type = 0
        } else if (vpValue > CommonConstant.SHEET_MIDDLE && sheetParams.type != 1 && this.keyboardHeightChange == 0) {
          sheetParams.type = 1
        }
        this.adjustSheetDialog?.updateContent(sheetParams)
      },
      // [StartExclude adjust_log]
      onWillDismiss: (reason: DialogDismissReason) => {
        if (reason === DialogDismissReason.TOUCH_OUTSIDE) {
          return false
        }
        return true;
      }
      // [EndExclude adjust_log]
    });
    // [End adjust_log]
  }

  @catchError()
  aboutToDisappear(): void {
    window.getLastWindow(this.getUIContext().getHostContext()).then((data) => {
      data.off('keyboardHeightChange', h => {
        this.keyboardHeightChange = h;
      })
      data.off('keyboardDidShow', () => {
        this.isKeyboardShow = true;
      })
      data.off('keyboardDidHide', () => {
        this.isKeyboardShow = false;
      })
    });
    clearInterval(this.intervalID);
  }

  build() {
    NavDestination() {
      Column() {
        List() {
          // Modal dialog
          ListItem() {
            ItemHead($r('app.string.ModelDialog'))
          }

          ListItemGroup() {
            // Plain text has a duration prompt window
            ListItem() {
              Row() {
                Text($r('app.string.Tooltip_with_duration'))
                  .attributeModifier(new ItemTextModifier())
                Image($r('app.media.icon_right'))
                  .height(24)
                  .opacity(0.2)
              }
            }
            .attributeModifier(new ItemListModifier())
            .onClick(() => {
              // [Start dia_hub]
              DialogHub.getToast()
                .setContent(wrapBuilder(TextToastBuilder))
                // [StartExclude dia_hub]
                .setConfig(CommonConstant.CUSTOM_SAMPLE_CONFIG)
                // [EndExclude dia_hub]
                .setDuration(CommonConstant.DURATION_3000)
                .build()
                .show();
              // [Start dia_hub]
            })

            // A modal dialog for a specified location
            ListItem() {
              Row() {
                Text($r('app.string.Popup_specified_location'))
                  .attributeModifier(new ItemTextModifier())
                Image($r('app.media.icon_right'))
                  .height(24)
                  .opacity(0.2)
              }
            }
            .attributeModifier(new ItemListModifier())
            .onClick(() => {
              // [Start location]
              this.specifiedLocationDialog = this.specifiedLocationDialog ?? DialogHub.getCustomDialog()
                .setOperableContent(wrapBuilder(SnackbarBuilder), (action: DialogAction) => {
                  let param = new SnackbarParams(() => {
                    action.dismiss()
                  }, this.pageInfos)
                  return param
                })
                ?.setStyle({
                  radius: '50%',
                  backgroundColor: 'rgba(241,243,245,0.97)'
                })
                .setConfig({
                  dialogBehavior: { isModal: false, passThroughGesture: true },
                  dialogPosition: {
                    alignment: DialogAlignment.Bottom,
                    offset: { dx: 0, dy: $r('app.float.specified_location_offset') }
                  }
                })
                .build();
              this.specifiedLocationDialog.show();
              // [End location]
            })

            // It disappears on a regular basis with a dialog effect
            ListItem() {
              Row() {
                Text($r('app.string.Popup_disappears_intervals'))
                  .attributeModifier(new ItemTextModifier())
                Image($r('app.media.icon_right'))
                  .height(24)
                  .opacity(0.2)
              }
            }
            .attributeModifier(new ItemListModifier())
            .onClick(() => {
              let time: number = CommonConstant.TIMED_DIALOG_DURATION;
              let params: TimeToastParams =
                new TimeToastParams(this.resourceMgr!.getStringSync($r('app.string.TimedPopup').id),
                  `${time} ${this.resourceMgr!.getStringSync($r('app.string.SecondsClose').id)}`);
              // [Start interval]
              if (!this.intervalsDisappearsDialog) {
                this.intervalsDisappearsDialog = DialogHub.getCustomDialog()
                  .setContent(wrapBuilder(TimeToastBuilder), params)
                  ?.setStyle({
                    radius: '50%',
                    backgroundColor: 'rgba(241,243,245,0.97)'
                  })
                  .setAnimation({ dialogAnimation: AnimationType.UP_DOWN })
                  .setConfig({
                    dialogBehavior: { isModal: false, passThroughGesture: true },
                    dialogPosition: {
                      alignment: DialogAlignment.Top,
                      offset: { dy: $r('app.float.popup_disappears_intervals_offset'), dx: 0 }
                    }
                  })
                  .build();

                this.intervalsDisappearsDialog.show();
                if (this.intervalID === -1) {
                  this.intervalID = setInterval(() => {
                    time -= 1;
                    params.content = `${time} ${this.resourceMgr!.getStringSync($r('app.string.SecondsClose').id)}`;
                    this.intervalsDisappearsDialog?.updateContent(params)
                    if (time <= 0 && this.intervalID) {
                      clearInterval(this.intervalID);
                      this.intervalsDisappearsDialog?.dismiss();
                      this.intervalsDisappearsDialog = null;
                      this.intervalID = -1;
                    }
                  }, CommonConstant.DURATION_1000);
                }
              }
              // [End interval]
            })


            // Avoids keyboard dialog
            ListItem() {
              Row() {
                Text($r('app.string.Avoid_keyboard_dialog'))
                  .attributeModifier(new ItemTextModifier())
                Image($r('app.media.icon_right'))
                  .height(24)
                  .opacity(0.2)
              }
            }
            .attributeModifier(new ItemListModifier())
            .onClick(() => {
              let param = new InputParams((inputValue) => {
                this.avoidKeyboardDialog?.dismiss();
                DialogHub.getToast()
                  .setContent(wrapBuilder(TextToastBuilder), new TextToastParams(inputValue))
                  .setConfig(CommonConstant.CUSTOM_SAMPLE_CONFIG)
                  .setAnimation({ dialogAnimation: AnimationType.UP_DOWN })
                  .setDuration(CommonConstant.DURATION_2000)
                  .build()
                  .show();
              }, CommonConstant.INPUT_DEFAULT_VALUE);
              // [Start avoid_log]
              this.avoidKeyboardDialog = this.avoidKeyboardDialog ?? DialogHub.getCustomDialog()
                .setContent(wrapBuilder(InputBuilder), param)
                // [StartExclude avoid_log]
                .setStyle({
                  radius: '50%',
                  height: 60,
                  width: Math.min(0.9 * this.windowWidthVp!, 480),
                  shadow: {
                    radius: 40,
                    color: '#29000000',
                  },
                  backgroundColor: 'rgba(241,243,245,0.97)'
                })
                // [EndExclude avoid_log]
                .setConfig({
                  dialogBehavior: {
                    isModal: false,
                    passThroughGesture: true,
                    requestFocusWhenShow: true,
                    keyboardAvoidMode: CustomKeyboardAvoidMode.CONTENT_AVOID,
                    keyboardAvoidSpace: -12
                  },
                  dialogPosition: {
                    alignment: DialogAlignment.Bottom,
                    offset: { dx: 0, dy: -28 }
                  }
                })
                .build();
              this.avoidKeyboardDialog.show();
              // [End avoid_log]
            })

          }
          .attributeModifier(new ItemGroupModifier())

          // Not modal dialog
          ListItem() {
            ItemHead($r('app.string.ModelessDialog'))
          }

          ListItemGroup() {
            // Arrow dialog to selected components
            ListItem() {
              Stack() {
                Text('').id('PopupDialog1').width(120).height(24)
                Row() {
                  Text($r('app.string.Arrow_pointing_dialog'))
                    .attributeModifier(new ItemTextModifier())
                  Image($r('app.media.icon_right'))
                    .height(24)
                    .opacity(0.2)
                }
              }
              .alignContent(Alignment.Start)
            }
            .attributeModifier(new ItemListModifier())
            .onClick(() => {
              // [Start pop_up]
              DialogHub.getPopup()
              // [StartExclude pop_up]
                .setOperableContent(wrapBuilder(ImagePopupBuilder), (action: DialogAction) => {
                  let param = new ImagePopupParams(() => {
                    action.dismiss()
                  })
                  return param
                })
                // [EndExclude pop_up]
                .setComponentTargetId('PopupDialog1')
                .setConfig({
                  dialogPosition: {
                    preferPlacement: Placement.Bottom
                  }
                })
                .build()
                .show();
              // [End pop_up]
            })


            // Click the dialog window that automatically closes the mask
            ListItem() {
              Row() {
                Text($r('app.string.Mask_automatically_close_dialog'))
                  .attributeModifier(new ItemTextModifier())
                Image($r('app.media.icon_right'))
                  .height(24)
                  .opacity(0.2)
              }
            }.attributeModifier(new ItemListModifier())
            .onClick(() => {
              // [Start mask_log]
              this.maskCloseDialog = this.maskCloseDialog ?? DialogHub.getCustomDialog()
              // [StartExclude mask_log]
                .setOperableContent(wrapBuilder(AutoDismissBuilder), (action: DialogAction) => {
                  let param = new AutoDismissParams(() => {
                    action.dismiss()
                  })
                  return param
                })
                .setStyle({
                  radius: $r('app.float.auto_dismiss_builder_borderRadius'),
                  maskColor: $r('app.color.mask_automatically_close_dialog_maskColor')
                })
                // [EndExclude mask_log]
                .setConfig({ dialogBehavior: { isModal: true, autoDismiss: true, passThroughGesture: false } })
                .build();
              this.maskCloseDialog.show();
              // [End mask_log]
            })


            // dialog window that can be actively closed
            ListItem() {
              Row() {
                Text($r('app.string.Actively_close_dialog'))
                  .attributeModifier(new ItemTextModifier())
                Image($r('app.media.icon_right'))
                  .height(24)
                  .opacity(0.2)
              }
            }
            .attributeModifier(new ItemListModifier())
            .onClick(() => {
              // [Start active_close]
              this.activelyCloseDialog = this.activelyCloseDialog ?? DialogHub.getCustomDialog()
                .setOperableContent(wrapBuilder(ActiveCloseBuilder), (action: DialogAction) => {
                  let param =
                    new ActiveCloseParams(
                      this.resourceMgr!.getStringSync($r('app.string.LogOut').id),
                      this.resourceMgr!.getStringSync($r('app.string.LogOutTips').id),
                      this.resourceMgr!.getStringSync($r('app.string.Cancel').id),
                      this.resourceMgr!.getStringSync($r('app.string.Exit').id),
                      () => {
                        action.dismiss();
                      },
                      () => {
                        action.dismiss();
                      }
                    )
                  return param;
                })
                .setConfig({ dialogBehavior: { isModal: true, autoDismiss: false, passThroughGesture: false } })
                .build();
              this.activelyCloseDialog.show();
              // [End active_close]
            })


            // Bottom dialog window with dynamic height adjustment
            if (this.curBp === CommonConstant.CURRENT_BREAK_POINT_XS ||
              this.curBp === CommonConstant.CURRENT_BREAK_POINT_SM) {
              ListItem() {
                Row() {
                  Text($r('app.string.Adjust_height_dialog'))
                    .attributeModifier(new ItemTextModifier())
                  Image($r('app.media.icon_right'))
                    .height(24)
                    .opacity(0.2)
                }
              }
              .id(CommonConstant.ADJUST_SHEET_DIALOG_ID)
              .attributeModifier(new ItemListModifier())
              .onClick(() => {
                // [Start adjust_log]
                this.adjustSheetDialog?.show();
                // [End adjust_log]
              })
            }
          }
          .attributeModifier(new ItemGroupModifier())

          // Sense non-modal dialog
          ListItem() {
            Row() {
              ItemHead($r('app.string.ModelessDialog'))

              Text(this.isSensorDialogShow ? $r('app.string.DialogStateOpen') : $r('app.string.DialogStateClose'))
                .fontSize($r('app.float.font_size_regular'))
                .textAlign(TextAlign.End)
                .fontColor($r('app.color.base_blue'))
                .fontWeight(FontWeight.Medium)
                .margin({ top: $r('app.float.item_head_top_margin'), bottom: $r('app.float.item_head_bottom_margin') })
            }
          }

          ListItemGroup() {
            ListItem() {
              Row() {
                Text($r('app.string.Perceive_status_dialog'))
                  .attributeModifier(new ItemTextModifier())

                Toggle({ type: ToggleType.Switch, isOn: false })
                  .width($r('app.float.Perceive_status_dialog_width'))
                  .height($r('app.float.perceive_status_dialog_height'))
                  .backgroundColor(Color.White)
                  .onChange((isOn: boolean) => {
                    if (isOn) {
                      this.sensorDialog?.show();
                    } else {
                      this.sensorDialog?.dismiss();
                    }
                  })
              }
            }.attributeModifier(new ItemListModifier())
          }.attributeModifier(new ItemGroupModifier())
        }
        .onDidScroll(() => {
          this.arrowPointingPopup?.updateDialogPosition();
        })
      }
      .width(CommonConstant.FULL_LENGTH)
      .height(CommonConstant.FULL_LENGTH)
      .padding({
        left: $r('app.float.page_padding'),
        right: $r('app.float.page_padding'),
        bottom: $r('app.float.page_padding')
      })
    }
    .title($r('app.string.CommonDialogExamples'))
    .backgroundColor($r('app.color.page_bg_color'))
    .onBackPressed(() => {
      this.pageInfos.pop();
      return true;
    })
    .onReady((context: NavDestinationContext) => {
      this.pageInfos = context.pathStack;
    })
  }
}