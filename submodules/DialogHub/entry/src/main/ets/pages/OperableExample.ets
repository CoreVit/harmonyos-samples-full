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
  CustomKeyboardAvoidMode,
  DialogAction,
  DialogBackPressResult,
  DialogDismissReason,
  DialogHub,
  InfCustomDialog,
  InfToast
} from 'hadss_dialog';
import { InputCallbackBuilder, InputCallbackParams } from '../component/InputCallbackBuilder';
import { SimpleCustomBuilder, SimpleCustomParams } from '../component/SimpleCustomBuilder';
import { ItemHead } from '../utils/ItemHead';
import { ProgressBuilder, ProgressParams } from '../component/ProgressBuilder';
import { SkipBuilder, SkipParams } from '../component/SkipBuilder';
import { ItemGroupModifier, ItemListModifier, ItemTextModifier } from '../utils/SampleModifier';
import { ActiveCloseBuilder, ActiveCloseParams } from '../component/ActiveCloseBuilder';
import CommonConstant from '../utils/CommonConstant';
import { deviceInfo } from '@kit.BasicServicesKit';
import { resourceManager } from '@kit.LocalizationKit';

@Builder
export function OperableBuilder(name: string, param: Object) {
  OperableExample();
}

@Component
export struct OperableExample {
  @StorageProp(CommonConstant.TAG_NAME + CommonConstant.CURRENT_BREAK_POINT) curBp: string =
    CommonConstant.CURRENT_BREAK_POINT_SM;
  pageInfos: NavPathStack = new NavPathStack();
  simpleDialog?: InfCustomDialog;
  passThroughGestureDialog?: InfToast;
  returnDataDialog?: InfCustomDialog;
  updateByParentDialog?: InfCustomDialog;
  skipDialog?: InfCustomDialog;
  intervalID: number = -1;
  resourceMgr: resourceManager.ResourceManager | undefined = AppStorage.get(CommonConstant.TAG_NAME + 'resourceMgr');
  // [Start back_close]
  @State backCloseDialog: boolean = false;
  // [End back_close]
  @State tagName: string = CommonConstant.TAG_NAME;
  @State dialogNum: number = 0; // Number of dialogs on the current page

  aboutToAppear(): void {
    this.simpleDialog =
      DialogHub.getCustomTemplate(CommonConstant.CUSTOM_TEMPLATE_SIMPLE)
      ?.setOperableContent(wrapBuilder(SimpleCustomBuilder),
        (action: DialogAction) => {
          return new SimpleCustomParams(this.resourceMgr!.getStringSync($r('app.string.Dialog3').id),
            this.resourceMgr!.getStringSync($r('app.string.NoResponseToBackGesture').id), () => {
              action.dismiss()
            })
        }
      )
      ?.build();
    this.simpleDialog?.addLifeCycleListener({
      onWillDismiss: (reason: DialogDismissReason) => {
        if (this.backCloseDialog && reason === DialogDismissReason.PRESS_BACK) {
          return false;
        }
        return true;
      }
    })

    this.skipDialog = DialogHub.getCustomDialog()
      .setOperableContent(wrapBuilder(SkipBuilder), (action: DialogAction) => {
        return new SkipParams(() => {
          action.dismiss()
        }, 0, this.pageInfos)
      })
      .setConfig({ dialogBehavior: { isModal: true, autoDismiss: false } })
      .build();

    // [Start add_event]
    DialogHub.addEventListener({
      OnCurentPageDialogNumberChange: (newNum: number, oldNum: number) => {
        this.dialogNum = newNum;
      }
    })
    // [End add_event]
  }

  aboutToDisappear(): void {
    DialogHub.removeEventListener({
      OnCurentPageDialogNumberChange: (newNum: number, oldNum: number) => {
        this.dialogNum = newNum;
      }
    })
  }

  private createSensorDialog(title: string, isSecondDialog: boolean = false): InfCustomDialog | undefined {
    let sensorDialog: InfCustomDialog | undefined =
      DialogHub.getCustomTemplate(CommonConstant.CUSTOM_TEMPLATE_SIMPLE)
      ?.setOperableContent(wrapBuilder(ActiveCloseBuilder),
        (action: DialogAction) => {
          let param = new ActiveCloseParams(
            title,
            '',
            this.resourceMgr!.getStringSync($r('app.string.Cancel').id),
            (isSecondDialog ?
              this.resourceMgr!.getStringSync($r('app.string.CloseAllDialog').id) :
              this.resourceMgr!.getStringSync($r('app.string.Open').id) +
                (title === this.resourceMgr!.getStringSync($r('app.string.Dialog1').id) ?
                  this.resourceMgr!.getStringSync($r('app.string.Dialog2').id) :
                  this.resourceMgr!.getStringSync($r('app.string.Dialog1').id))),
            () => {
              action.dismiss()
            },
            () => {
              if (isSecondDialog) {
                DialogHub.getCurrentPageDialogs()
                  .forEach((dialog) => {
                    dialog.dismiss();
                  })
              } else {
                if (title === this.resourceMgr!.getStringSync($r('app.string.Dialog1').id)) {
                  this.createSensorDialog(this.resourceMgr!.getStringSync($r('app.string.Dialog2').id), true)?.show();
                } else {
                  this.createSensorDialog(this.resourceMgr!.getStringSync($r('app.string.Dialog1').id), true)?.show();
                }
              }
            },
            isSecondDialog ? (deviceInfo.deviceType === '2in1' ? Color.White : $r('app.color.base_red')) : undefined
          )
          return param;
        })
        .setConfig({ dialogBehavior: { isModal: true, autoDismiss: false, passThroughGesture: false } })
        .build();
    return sensorDialog;
  }

  build() {
    NavDestination() {
      Row() {
        List() {
          // The custom return gesture is to exit the page or close the popup
          ListItem() {
            if (this.backCloseDialog) {
              ItemHead($r('app.string.currentlyAllocatedDialog'))
            } else {
              ItemHead($r('app.string.currentlyAllocatedPage'))
            }
          }

          ListItemGroup() {
            // Return gesture to the page
            ListItem() {
              Row() {
                Text($r('app.string.break_on_page'))
                  .attributeModifier(new ItemTextModifier())
                Image($r('app.media.icon_right'))
                  .height(24)
                  .opacity(0.2)
              }
            }
            .attributeModifier(new ItemListModifier())
            .onClick(() => {
              this.backCloseDialog = false;
            })

            // Return gesture to the dialog
            ListItem() {
              Row() {
                Text($r('app.string.break_on_dialog'))
                  .attributeModifier(new ItemTextModifier())
                Image($r('app.media.icon_right'))
                  .height(24)
                  .opacity(0.2)
              }
            }
            .attributeModifier(new ItemListModifier())
            .onClick(() => {
              this.backCloseDialog = true;
            })

            // Simple dialog_1
            ListItem() {
              Row() {
                Text($r('app.string.SHOW_SIMPLE_DIALOG_1'))
                  .attributeModifier(new ItemTextModifier())
                Image($r('app.media.icon_right'))
                  .height(24)
                  .opacity(0.2)
              }
            }
            .attributeModifier(new ItemListModifier())
            .onClick(() => {
              this.createSensorDialog(this.resourceMgr!.getStringSync($r('app.string.Dialog1').id))?.show();
            })

            // Simple dialog_2
            ListItem() {
              Row() {
                Text($r('app.string.SHOW_SIMPLE_DIALOG_2'))
                  .attributeModifier(new ItemTextModifier())
                Image($r('app.media.icon_right'))
                  .height(24)
                  .opacity(0.2)
              }
            }
            .attributeModifier(new ItemListModifier())
            .onClick(() => {
              this.createSensorDialog(this.resourceMgr!.getStringSync($r('app.string.Dialog2').id))?.show();
            })

            // Non-response Return gesture dialog_3
            ListItem() {
              Row() {
                Text($r('app.string.SHOW_SIMPLE_DIALOG_3'))
                  .attributeModifier(new ItemTextModifier())
                Image($r('app.media.icon_right'))
                  .height(24)
                  .opacity(0.2)
              }
            }
            .attributeModifier(new ItemListModifier())
            .onClick(() => {
              this.simpleDialog?.show();
            })
          }.attributeModifier(new ItemGroupModifier())

          // Users can manipulate the page through the dialog content
          ListItem() {
            ItemHead($r('app.string.passThroughGestureDialog'))
          }

          ListItemGroup() {
            // A dialog with passThroughGesture
            ListItem() {
              Row() {
                Text($r('app.string.passThroughGestureDialog'))
                  .attributeModifier(new ItemTextModifier())
                Image($r('app.media.icon_right'))
                  .height(24)
                  .opacity(0.2)
              }
            }
            .attributeModifier(new ItemListModifier())
            .onClick(() => {
              // [Start pass_through]
              let passThroughGestureDialog = DialogHub.getCustomDialog()
                .setOperableContent(wrapBuilder(SimpleCustomBuilder), (action: DialogAction) => {
                  return new SimpleCustomParams(
                    this.resourceMgr!.getStringSync($r('app.string.Dialog').id),
                    this.resourceMgr!.getStringSync($r('app.string.passThroughDialog').id),
                    () => {
                      action.dismiss();
                    })
                })
                .setConfig({
                  dialogBehavior: {
                    passThroughGesture: true
                  }
                })
                .build();
              // [End pass_through]
              passThroughGestureDialog.show();
            })
          }.attributeModifier(new ItemGroupModifier())

          // Dialogs interact with the page for data
          ListItem() {
            ItemHead($r('app.string.dialog_interacts_with_page'))
          }

          ListItemGroup() {
            ListItem() {
              Row() {
                Text($r('app.string.tagName'))
                  .margin(CommonConstant.TOP_BOTTOM_MARGIN)
                  // .width(CommonConstant.FULL_LENGTH)
                  .textAlign(TextAlign.Center)
                Text(this.tagName)
                  .margin(CommonConstant.TOP_BOTTOM_MARGIN)
                  // .width(CommonConstant.FULL_LENGTH)
                  .textAlign(TextAlign.Center)
              }
              .alignSelf(ItemAlign.Center)
              .justifyContent(FlexAlign.SpaceAround)
              .alignItems(VerticalAlign.Center)

            }.attributeModifier(new ItemListModifier())

            // A dialog that needs to return data to the page
            ListItem() {
              Row() {
                Text($r('app.string.ReturnDataDialog'))
                  .attributeModifier(new ItemTextModifier())
                Image($r('app.media.icon_right'))
                  .height(24)
                  .opacity(0.2)
              }
            }
            .attributeModifier(new ItemListModifier())
            .onClick(() => {
              // [Start return_content]
              this.returnDataDialog = DialogHub.getCustomDialog()
                .setOperableContent(wrapBuilder(InputCallbackBuilder), (action: DialogAction) => {
                  let parms = new InputCallbackParams(CommonConstant.UPDATE_TAG, () => {
                    action.dismiss();
                  }, (value) => {
                    this.tagName = value;
                  })
                  return parms;
                })
                .setConfig({
                  dialogBehavior: {
                    isModal: true,
                    autoDismiss: false,
                    keyboardAvoidMode: CustomKeyboardAvoidMode.CONTENT_AVOID,
                    keyboardAvoidSpace: 16
                  }
                })
                .build();
              this.returnDataDialog.show();
              // [End return_content]
            })

            // The parent page can refresh the dialog content
            ListItem() {
              Row() {
                Text($r('app.string.FatherPageUpdateDialogContent'))
                  .attributeModifier(new ItemTextModifier())
                Image($r('app.media.icon_right'))
                  .height(24)
                  .opacity(0.2)
              }
            }
            .attributeModifier(new ItemListModifier())
            .onClick(() => {
              // [Start pro_param]
              let params = new ProgressParams(this.resourceMgr!.getStringSync($r('app.string.Uploading').id),
                CommonConstant.progressNameStart,
                CommonConstant.progressNameTotal);

              this.updateByParentDialog = DialogHub.getCustomDialog()
                .setContent(wrapBuilder(ProgressBuilder), params)
                .setConfig({ dialogBehavior: { isModal: true, autoDismiss: false } })
                .build();
              this.updateByParentDialog.show();
              this.intervalID = setInterval(() => {
                params.value += 1
                if (params.value >= CommonConstant.progressNameTotal && this.intervalID >= 0) {
                  this.updateByParentDialog?.dismiss();
                  clearInterval(this.intervalID);
                }
                this.updateByParentDialog?.updateContent(params);
              }, CommonConstant.Interval_20);
              // [End pro_param]
            })
          }
          .attributeModifier(new ItemGroupModifier())

          if (this.curBp === CommonConstant.CURRENT_BREAK_POINT_SM) {
            // The relationship between dialogs and pages
            ListItem() {
              ItemHead($r('app.string.DialogWithPage'))
            }

            ListItem() {
              Row() {
                Text($r('app.string.numbersOfDialogInCurrentPage'))
                  .fontWeight(FontWeight.Medium)
                  .fontSize($r('app.float.font_size_regular'))
                  .fontColor($r('app.color.now_dialogs_font_color'))
                  .margin({ bottom: $r('app.float.now_dialogs_bottom_margin') })
                Text(this.dialogNum.toString())
                  .fontWeight(FontWeight.Medium)
                  .fontSize($r('app.float.font_size_regular'))
                  .fontColor($r('app.color.now_dialogs_font_color'))
                  .margin({ bottom: $r('app.float.now_dialogs_bottom_margin') })
              }
            }

            ListItemGroup() {
              // There is dialog for jump link(Router)
              ListItem() {
                Row() {
                  Text($r('app.string.SkipRouter'))
                    .attributeModifier(new ItemTextModifier())
                  Image($r('app.media.icon_right'))
                    .height(24)
                    .opacity(0.2)
                }
              }
              .attributeModifier(new ItemListModifier())
              .onClick(() => {
                let parms = new SkipParams(() => {
                  this.skipDialog?.dismiss();
                }, 0, this.pageInfos);
                this.skipDialog?.updateContent(parms);
                this.skipDialog?.updateConfig({
                  dialogPosition: { offset: { dx: 0, dy: 0 } }
                });
                this.skipDialog?.show();
              })

              // There is dialog for jump link(Navigation)
              ListItem() {
                Row() {
                  Text($r('app.string.SkipNavigation'))
                    .attributeModifier(new ItemTextModifier())
                  Image($r('app.media.icon_right'))
                    .height(24)
                    .opacity(0.2)
                }
              }
              .attributeModifier(new ItemListModifier())
              .onClick(() => {
                // [Start skip_miss]
                let parms = new SkipParams(() => {
                  this.skipDialog?.dismiss();
                }, 1, this.pageInfos);
                this.skipDialog?.updateContent(parms);
                this.skipDialog?.updateConfig({
                  dialogPosition: { offset: { dx: 0, dy: 0 } }
                });
                this.skipDialog?.show();
                // [End skip_miss]
              })

              // (widescreen)Display dialog in specific split screens
              ListItem() {
                Row() {
                  Text($r('app.string.DifferentPositionShow'))
                    .attributeModifier(new ItemTextModifier())
                  Image($r('app.media.icon_right'))
                    .height(24)
                    .opacity(0.2)
                }
              }
              .attributeModifier(new ItemListModifier())
              .onClick(() => {
                let parms = new SkipParams(() => {
                  this.skipDialog?.dismiss();
                }, 1, this.pageInfos);
                this.skipDialog?.updateContent(parms);
                this.skipDialog?.updateConfig({
                  dialogPosition: { offset: { dx: 0, dy: 0 } }
                });
                this.skipDialog?.show();
              })
            }
            .attributeModifier(new ItemGroupModifier())
          } else {
            ListItem() {
              ItemHead($r('app.string.DialogWithPage'))
            }

            ListItem() {
              Row() {
                Text($r('app.string.numbersOfDialogInCurrentPage'))
                  .fontWeight(FontWeight.Medium)
                  .fontSize($r('app.float.font_size_regular'))
                  .fontColor($r('app.color.now_dialogs_font_color'))
                  .margin({ bottom: $r('app.float.now_dialogs_bottom_margin') })
                Text(this.dialogNum.toString())
                  .fontWeight(FontWeight.Medium)
                  .fontSize($r('app.float.font_size_regular'))
                  .fontColor($r('app.color.now_dialogs_font_color'))
                  .margin({ bottom: $r('app.float.now_dialogs_bottom_margin') })
              }
            }


            ListItemGroup() {
              // There is dialog for jump link(Router)
              ListItem() {
                Row() {
                  Text($r('app.string.SkipRouter'))
                    .attributeModifier(new ItemTextModifier())
                  Image($r('app.media.icon_right'))
                    .height(24)
                    .opacity(0.2)
                }
              }
              .attributeModifier(new ItemListModifier())
              .onClick(() => {
                let parms = new SkipParams(() => {
                  this.skipDialog?.dismiss();
                }, 0, this.pageInfos);
                this.skipDialog?.updateContent(parms);
                this.skipDialog?.updateConfig({
                  dialogPosition: { offset: { dx: 0, dy: 0 } }
                });
                this.skipDialog?.show();
              })

              // There is dialog for jump link(Navigation)
              ListItem() {
                Row() {
                  Text($r('app.string.SkipNavigation'))
                    .attributeModifier(new ItemTextModifier())
                  Image($r('app.media.icon_right'))
                    .height(24)
                    .opacity(0.2)
                }
              }
              .attributeModifier(new ItemListModifier())
              .onClick(() => {
                let parms = new SkipParams(() => {
                  this.skipDialog?.dismiss();
                }, 1, this.pageInfos);
                this.skipDialog?.updateContent(parms);
                this.skipDialog?.updateConfig({
                  dialogPosition: { offset: { dx: 0, dy: 0 } }
                });
                this.skipDialog?.show();
              })

              // (left)Display dialog in specific split screens
              ListItem() {
                Row() {
                  Text($r('app.string.LeftDialog'))
                    .attributeModifier(new ItemTextModifier())
                  Image($r('app.media.icon_right'))
                    .height(24)
                    .opacity(0.2)
                }
              }
              .attributeModifier(new ItemListModifier())
              .onClick(() => {
                // [Start skip_config]
                let parms = new SkipParams(() => {
                  this.skipDialog?.dismiss()
                }, 1, this.pageInfos);
                this.skipDialog?.updateContent(parms);
                this.skipDialog?.updateConfig({
                  dialogPosition: { offset: CommonConstant.LEFT_DIALOG_OFFSET }
                });
                this.skipDialog?.show();
                // [End skip_config]
              })

              // (right)Display dialog in specific split screens
              ListItem() {
                Row() {
                  Text($r('app.string.RightDialog'))
                    .attributeModifier(new ItemTextModifier())
                  Image($r('app.media.icon_right'))
                    .height(24)
                    .opacity(0.2)
                }
              }
              .attributeModifier(new ItemListModifier())
              .onClick(() => {
                // [Start new_skip]
                let parms = new SkipParams(() => {
                  this.skipDialog?.dismiss();
                }, 1, this.pageInfos);
                this.skipDialog?.updateContent(parms);
                this.skipDialog?.updateConfig({
                  dialogPosition: { offset: CommonConstant.RIGHT_DIALOG_OFFSET }
                });
                this.skipDialog?.show();
                // [End new_skip]
              })
            }
            .attributeModifier(new ItemGroupModifier())
          }

          ListItem() {
            Stack().width(CommonConstant.FULL_LENGTH).height($r('app.float.item_button_height'))
          }
        }
        .id('first-list')
        .width(CommonConstant.FULL_LENGTH)
        .scrollBar(BarState.Off)
      }
      .id('root-row')
      .width(CommonConstant.FULL_LENGTH)
      .height(CommonConstant.FULL_LENGTH)
      .padding({ left: $r('app.float.page_padding'), right: $r('app.float.page_padding') })
    }
    .title($r('app.string.OperableDialogExamples'))
    .backgroundColor($r('app.color.page_bg_color'))
    // [Start back_press]
    .onBackPressed(() => {
      if (this.backCloseDialog) {
        let tmp: DialogBackPressResult = DialogHub.dispatchBackPressToDialog();
        if (tmp !== DialogBackPressResult.NO_DIALOG) {
          return true;
        }
      }
      this.pageInfos.pop();
      return true;
    })
    // [End back_press]
    .onReady((context: NavDestinationContext) => {
      this.pageInfos = context.pathStack;
    })
  }
}