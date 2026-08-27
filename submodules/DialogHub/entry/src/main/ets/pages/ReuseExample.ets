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

import { AnimationType, DialogHub, InfToast } from 'hadss_dialog';
import CommonConstant from '../utils/CommonConstant';
import { ItemHead } from '../utils/ItemHead';
import { ItemGroupModifier, ItemListModifier, ItemTextModifier } from '../utils/SampleModifier';

@Builder
export function ReuseBuilder(name: string, param: Object) {
  ReuseExample();
}

@Component
export struct ReuseExample {
  // [Start original]
  originalTemplateDialog?: InfToast;
  // [End original]
  changeTemplateDialog?: InfToast;
  pageInfos: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      Column() {
        List() {
          // Using custom dialog template
          ListItem() {
            ItemHead($r('app.string.PopoutByCustomDialogTemplate'))
          }

          ListItemGroup() {
            // create template
            ListItem() {
              Row() {
                Text($r('app.string.CreateDialogTemplate'))
                  .attributeModifier(new ItemTextModifier())
                Image($r('app.media.icon_right'))
                  .height(24)
                  .opacity(0.2)
              }
            }
            .attributeModifier(new ItemListModifier())
            .onClick(() => {
              // [Start click_create]
              DialogHub.createToastTemplate(CommonConstant.MY_TEMPLATE_NAME)
                .setTextContent(CommonConstant.TOAST_DISPLAYED_CONTENT)
                // [StartExclude click_create]
                .setStyle({
                  backgroundColor: '#AA000000',
                })
                .setConfig({
                  dialogPosition: {
                    alignment: DialogAlignment.Bottom,
                    offset: { dx: $r('app.float.vp_0'), dy: $r('app.float.toast_position_offset_y') }
                  }
                })
                // [EndExclude click_create]
                .setDuration(CommonConstant.TOAST_DISPLAY_DURATION)
                .register();
              // [End click_create]

              // [Start original_dialog]
              this.originalTemplateDialog =
                DialogHub.getToastTemplate(CommonConstant.MY_TEMPLATE_NAME)?.build();
              // [End original_dialog]
            })

            // remove template
            ListItem() {
              Row() {
                Text($r('app.string.DeleteDialogTemplate'))
                  .attributeModifier(new ItemTextModifier())
                Image($r('app.media.icon_right'))
                  .height(24)
                  .opacity(0.2)
              }
            }
            .attributeModifier(new ItemListModifier())
            .onClick(() => {
              // [Start remove_late]
              DialogHub.removeTemplate(CommonConstant.MY_TEMPLATE_NAME);
              // [End remove_late]
            })

            // update template
            ListItem() {
              Row() {
                Text($r('app.string.ModifyDialogTemplateRandomBackgroundColor'))
                  .attributeModifier(new ItemTextModifier())
                Image($r('app.media.icon_right'))
                  .height(24)
                  .opacity(0.2)
              }
            }
            .attributeModifier(new ItemListModifier())
            .onClick(() => {
              // [Start ceil_toString]
              let r = (Math.ceil(Math.random() * 239 + 16) % 255).toString(16).padStart(2, '0');
              let g = (Math.ceil(Math.random() * 239 + 16) % 255).toString(16).padStart(2, '0');
              let b = (Math.ceil(Math.random() * 239 + 16) % 255).toString(16).padStart(2, '0');
              let color = '#ff' + r + g + b;
              DialogHub.updateToastTemplate(CommonConstant.MY_TEMPLATE_NAME)?.setStyle({
                backgroundColor: color
              }).register();
              // [End ceil_toString]
            })

            // get template to show dialog
            ListItem() {
              Row() {
                Text($r('app.string.PopupDialogTemplate'))
                  .attributeModifier(new ItemTextModifier())
                Image($r('app.media.icon_right'))
                  .height(24)
                  .opacity(0.2)
              }
            }
            .attributeModifier(new ItemListModifier())
            .onClick(() => {
              // [Start get_toast_late]
              DialogHub.getToastTemplate(CommonConstant.MY_TEMPLATE_NAME)?.build().show();
              // [End get_toast_late]
            })

            // Use the template and define the dialog animation to show dialog
            ListItem() {
              Row() {
                Text($r('app.string.PopupWithAnimation'))
                  .attributeModifier(new ItemTextModifier())
                Image($r('app.media.icon_right'))
                  .height(24)
                  .opacity(0.2)
              }
            }
            .attributeModifier(new ItemListModifier())
            .onClick(() => {
              // [Start dial_animation]
              DialogHub.getToastTemplate(CommonConstant.MY_TEMPLATE_NAME)?.setAnimation({
                dialogAnimation: AnimationType.UP_DOWN
              }).build().show();
              // [End dial_animation]
            })

            // Use the template and define the dialog position to show dialog
            ListItem() {
              Row() {
                Text($r('app.string.PopupWithSpecifiedPosition'))
                  .attributeModifier(new ItemTextModifier())
                Image($r('app.media.icon_right'))
                  .height(24)
                  .opacity(0.2)
              }
            }
            .attributeModifier(new ItemListModifier())
            .onClick(() => {
              DialogHub.getToastTemplate(CommonConstant.MY_TEMPLATE_NAME)?.setConfig({
                dialogPosition: {
                  alignment: DialogAlignment.Top,
                  offset: { dx: $r('app.float.vp_0'), dy: CommonConstant.Y_OFFSET }
                }
              }).build().show();
            })
          }
          .attributeModifier(new ItemGroupModifier())


          // The same object for dialog show
          ListItem() {
            ItemHead($r('app.string.PopupBySameObject'))
          }

          ListItemGroup() {
            // The same object for dialog show
            ListItem() {
              Row() {
                Text($r('app.string.Dialog'))
                  .attributeModifier(new ItemTextModifier())
                Image($r('app.media.icon_right'))
                  .height(24)
                  .opacity(0.2)
              }
            }
            .attributeModifier(new ItemListModifier())
            .onClick(() => {
              // [Start dia_log]
              this.originalTemplateDialog?.show();
              // [End dia_log]
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
    .id('navDestination')
    .title($r('app.string.ReusableDialogExamples'))
    .width(CommonConstant.FULL_LENGTH)
    .height(CommonConstant.FULL_LENGTH)
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