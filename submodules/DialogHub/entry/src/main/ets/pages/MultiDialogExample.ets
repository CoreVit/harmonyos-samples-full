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
  InfCustomDialog,
  DialogHub,
  TopDialogPriority,
  DialogStatus,
  InfDialog,
  InfToast,
  AnimationType,
  DialogAction
} from 'hadss_dialog'
import { SimpleCustomBuilder, SimpleCustomParams } from '../component/SimpleCustomBuilder';
import { TextToastBuilder, TextToastParams } from '../component/TextToastBuilder';
import { TimeToastBuilder, TimeToastParams } from '../component/TimeToastBuilder';
import CommonConstant from '../utils/CommonConstant'
import { ItemHead } from '../utils/ItemHead'
import { ItemGroupModifier, ItemListModifier, ItemTextModifier } from '../utils/SampleModifier';
import { resourceManager } from '@kit.LocalizationKit';

@Builder
export function MultiDialogBuilder(name: string, param: Object) {
  MultiDialogExample();
}

@Component
export struct MultiDialogExample {
  pageInfos: NavPathStack = new NavPathStack();
  tipsToast?: InfToast;
  dialogA?: InfCustomDialog;
  dialogB?: InfCustomDialog;
  dialogC?: InfCustomDialog;
  dialogD?: InfCustomDialog;
  dialogE?: InfCustomDialog;
  dialogF?: InfCustomDialog;
  dialogG?: InfCustomDialog;
  dialogH?: InfCustomDialog;
  resourceMgr: resourceManager.ResourceManager | undefined = AppStorage.get(CommonConstant.TAG_NAME + 'resourceMgr');

  aboutToAppear(): void {
    this.tipsToast = DialogHub.getToast()
      .setContent(wrapBuilder(TextToastBuilder),
        new TextToastParams(`${this.resourceMgr!.getStringSync($r('app.string.Dialog')
          .id)} B ${this.resourceMgr!.getStringSync($r('app.string.PopupFailed').id)}`))
      .setConfig({
        dialogPosition: {
          alignment: DialogAlignment.Bottom,
          offset: { dx: 0, dy: $r('app.float.text_toast_offset') }
        }
      })
      .setDuration(CommonConstant.DURATION_3000)
      .build();
    this.dialogA = DialogHub.getCustomTemplate(CommonConstant.CUSTOM_TEMPLATE_SIMPLE)
    ?.setOperableContent(wrapBuilder(SimpleCustomBuilder), (action: DialogAction) => {
      return new SimpleCustomParams(`${this.resourceMgr?.getStringSync($r('app.string.Dialog').id)} A`,
        CommonConstant.DIALOG_A_CONTENT, () => {
          action.dismiss();
        })
    }
    )?.build();
    this.dialogB = DialogHub.getCustomTemplate(CommonConstant.CUSTOM_TEMPLATE_SIMPLE)
    ?.setOperableContent(wrapBuilder(SimpleCustomBuilder), (action: DialogAction) => {
      return new SimpleCustomParams(`${this.resourceMgr?.getStringSync($r('app.string.Dialog').id)} B`,
        CommonConstant.DIALOG_B_CONTENT, () => {
          action.dismiss();
        })
    }
    )?.build();
    this.dialogC = DialogHub.getCustomTemplate(CommonConstant.CUSTOM_TEMPLATE_SIMPLE)
    ?.setOperableContent(wrapBuilder(SimpleCustomBuilder), (action: DialogAction) => {
      return new SimpleCustomParams(`${this.resourceMgr?.getStringSync($r('app.string.Dialog').id)} C`,
        CommonConstant.DIALOG_C_CONTENT, () => {
          action.dismiss();
        })
    }
    )?.build();
  }

  private createMessageBuilder(title: string, content: string): ESObject {
    let params: TimeToastParams = new TimeToastParams(title, content)
    return DialogHub.getCustomDialog()
      .setContent(wrapBuilder(TimeToastBuilder), params)
      .setAnimation({ dialogAnimation: AnimationType.UP_DOWN })
      .setConfig({
        dialogBehavior: { isModal: false, passThroughGesture: true },
        dialogPosition: {
          alignment: DialogAlignment.Top,
          offset: { dy: $r('app.float.time_toast_builder_offset'), dx: 0 }
        }
      });
  }

  build() {
    NavDestination() {
      Column() {
        List() {
          // New dialogs are suppressed by existing dialog
          ListItem() {
            ItemHead($r('app.string.NewDialogSuppressedByExistDialog'))
          }

          ListItemGroup() {
            // dialogA
            ListItem() {
              Row() {
                Text($r('app.string.Dialog_A'))
                  .attributeModifier(new ItemTextModifier())
                Image($r('app.media.icon_right'))
                  .height(24)
                  .opacity(0.2)
              }
            }
            .attributeModifier(new ItemListModifier())
            .onClick(() => {
              this.dialogA?.show();
            })

            // If dialog A exists, dialog B cannot be popped up
            ListItem() {
              Row() {
                Text($r('app.string.Suppression_tips'))
                  .attributeModifier(new ItemTextModifier())
                Image($r('app.media.icon_right'))
                  .height(24)
                  .opacity(0.2)
              }
            }
            .attributeModifier(new ItemListModifier())
            .onClick(() => {
              // [Start get_status]
              if (this.dialogA?.getStatus() != DialogStatus.SHOW) {
                this.dialogB?.show();
              }
              // [End get_status]
              else {
                this.tipsToast?.updateContent(new TextToastParams(`${this.resourceMgr!.getStringSync($r('app.string.Dialog')
                  .id)} B ${this.resourceMgr!.getStringSync($r('app.string.PopupFailed').id)}`));
                this.tipsToast?.show();
              }
            })

            // Dialog C is available only when the current page does not have dialog
            ListItem() {
              Row() {
                Text($r('app.string.PopupDialogCWhenNotExistDialog'))
                  .attributeModifier(new ItemTextModifier())
                Image($r('app.media.icon_right'))
                  .height(24)
                  .opacity(0.2)
              }
            }
            .attributeModifier(new ItemListModifier())
            .onClick(() => {
              // [Start current_page]
              if (DialogHub.getCurrentPageDialogs().length === 0) {
                this.dialogC?.show();
              }
              // [End current_page]
              else {
                this.tipsToast?.updateContent(new TextToastParams(`${this.resourceMgr!.getStringSync($r('app.string.Dialog')
                  .id)} C ${this.resourceMgr!.getStringSync($r('app.string.PopupFailed').id)}`));
                this.tipsToast?.show();
              }
            })
          }
          .attributeModifier(new ItemGroupModifier())


          // Developers can control the dialog level to achieve mutual coverage of dialog
          ListItem() {
            ItemHead($r('app.string.ControlLevelMutualCoverage'))
          }

          ListItemGroup() {
            // Normal dialog D
            ListItem() {
              Row() {
                Text($r('app.string.Dialog_D'))
                  .attributeModifier(new ItemTextModifier())
                Image($r('app.media.icon_right'))
                  .height(24)
                  .opacity(0.2)
              }
            }
            .attributeModifier(new ItemListModifier())
            .onClick(() => {
              this.dialogD = this.dialogD ??
                this.createMessageBuilder(`${this.resourceMgr?.getStringSync($r('app.string.Dialog').id)} D`,
                  CommonConstant.DIALOG_D_CONTENT).build();
              this.dialogD?.show();
            })

            // Normal dialog E
            ListItem() {
              Row() {
                Text($r('app.string.Dialog_E'))
                  .attributeModifier(new ItemTextModifier())
                Image($r('app.media.icon_right'))
                  .height(24)
                  .opacity(0.2)
              }
            }
            .attributeModifier(new ItemListModifier())
            .onClick(() => {
              this.dialogE = this.dialogE ??
                this.createMessageBuilder(`${this.resourceMgr?.getStringSync($r('app.string.Dialog').id)} E`,
                  CommonConstant.DIALOG_E_CONTENT).build();
              this.dialogE?.show();
            })

            // dialog F at level 10
            ListItem() {
              Row() {
                Text($r('app.string.Dialog_F'))
                  .attributeModifier(new ItemTextModifier())
                Image($r('app.media.icon_right'))
                  .height(24)
                  .opacity(0.2)
              }
            }
            .attributeModifier(new ItemListModifier())
            .onClick(() => {
              // [Start create_message]
              this.dialogF = this.dialogF ??
                this.createMessageBuilder(`${this.resourceMgr?.getStringSync($r('app.string.Dialog').id)} F`,
                  CommonConstant.DIALOG_F_CONTENT)
                  .setLayerIndex(CommonConstant.DIALOG_F_LAYER_INDEX)
                  .build();
              // [End create_message]
              this.dialogF?.show();
            })

            // Top dialog (Old_First)G
            ListItem() {
              Row() {
                Text($r('app.string.Dialog_G'))
                  .attributeModifier(new ItemTextModifier())
                Image($r('app.media.icon_right'))
                  .height(24)
                  .opacity(0.2)
              }
            }
            .attributeModifier(new ItemListModifier())
            .onClick(() => {
              // [Start create_builder]
              this.dialogG = this.dialogG ??
                this.createMessageBuilder(`${this.resourceMgr?.getStringSync($r('app.string.Dialog').id)} G`,
                  CommonConstant.DIALOG_G_CONTENT).setConfig({
                  dialogBehavior: {
                    layerPolicy: { alwaysTop: true, topDialogPriority: TopDialogPriority.OLD_FIRST }
                  }
                }).build();
              // [End create_builder]
              this.dialogG?.show();
            })

            // Top dialog (New_First)H
            ListItem() {
              Row() {
                Text($r('app.string.Dialog_H'))
                  .attributeModifier(new ItemTextModifier())
                Image($r('app.media.icon_right'))
                  .height(24)
                  .opacity(0.2)
              }
            }
            .attributeModifier(new ItemListModifier())
            .onClick(() => {
              // [Start layer_policy]
              this.dialogH = this.dialogH ??
                this.createMessageBuilder(`${this.resourceMgr?.getStringSync($r('app.string.Dialog').id)} H`,
                  CommonConstant.DIALOG_H_CONTENT).setConfig({
                  dialogBehavior: {
                    layerPolicy: { alwaysTop: true, topDialogPriority: TopDialogPriority.NEW_FIRST }
                  }
                }).build();
              // [End layer_policy]
              this.dialogH?.show();
            })
          }
          .attributeModifier(new ItemGroupModifier())


          // Close all dialog on the current page
          ListItem() {
            ItemHead($r('app.string.CloseCurrentPageAllDialog'))
          }

          ListItemGroup() {
            ListItem() {
              Row() {
                Text($r('app.string.Shut_down'))
                  .attributeModifier(new ItemTextModifier())
                Image($r('app.media.icon_right'))
                  .height(24)
                  .opacity(0.2)
              }
            }
            .attributeModifier(new ItemListModifier())
            .onClick(() => {
              let dialogs: InfDialog[] = DialogHub.getCurrentPageDialogs();
              for (let index = 0; index < dialogs.length; index++) {
                dialogs[index].dismiss();
              }
            })
          }
          .attributeModifier(new ItemGroupModifier())
        }

      }
      .width(CommonConstant.FULL_LENGTH)
      .height(CommonConstant.FULL_LENGTH)
      .padding({
        left: $r('app.float.page_padding'),
        right: $r('app.float.page_padding'),
        bottom: $r('app.float.page_padding')
      })
    }
    .title($r('app.string.MultipleDialogExamples'))
    .backgroundColor($r('app.color.page_bg_color'))
    .onBackPressed(() => {
      this.pageInfos.pop();
      return true;
    }).onReady((context: NavDestinationContext) => {
      this.pageInfos = context.pathStack;
    })
  }
}