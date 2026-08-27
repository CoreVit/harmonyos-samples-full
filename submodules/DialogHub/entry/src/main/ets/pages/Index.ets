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

import { DialogHub } from 'hadss_dialog';
import { TextToastBuilder } from '../component/TextToastBuilder';
import CommonConstant from '../utils/CommonConstant';
import { RowBoxModifier,RowContentModifier, FancyTextModifier} from '../utils/SampleModifier'

@Entry
@Component
struct Index {
  pageInfos: NavPathStack = new NavPathStack();
  avoidAreaHeight: number | undefined = AppStorage.get(CommonConstant.TAG_NAME + 'avoidAreaHeight');
  @StorageProp(CommonConstant.TAG_NAME + CommonConstant.CURRENT_BREAK_POINT) curBp: string =
    CommonConstant.CURRENT_BREAK_POINT_SM;
  @State rowBoxModifier: RowBoxModifier = new RowBoxModifier();
  @State rowContentModifier: RowContentModifier = new RowContentModifier();
  @State textModifier: FancyTextModifier = new FancyTextModifier();

  aboutToAppear(): void {
    // [Start get_ui_context]
    DialogHub.init(this.getUIContext());
    // [End get_ui_context]
    DialogHub.openLog('DEBUG');
    // [Start wrap_create]
    DialogHub.createCustomTemplate(CommonConstant.CUSTOM_TEMPLATE_SIMPLE)
      .setContent(wrapBuilder(TextToastBuilder))
      .setConfig({ dialogBehavior: { passThroughGesture: true, isModal: false } })
      // [End wrap_create]
      .register();
  }

  getNavMode(): NavigationMode {
    if ((this.curBp === CommonConstant.CURRENT_BREAK_POINT_XS) ||
      (this.curBp === CommonConstant.CURRENT_BREAK_POINT_SM)) {
      return NavigationMode.Stack;
    } else {
      return NavigationMode.Split;
    }
  }

  getNavbarWidth(): Length {
    console.log('xb:curBp', this.curBp);

    if (this.curBp === CommonConstant.CURRENT_BREAK_POINT_SM) {
      return '100%';
    } else if (this.curBp === CommonConstant.CURRENT_BREAK_POINT_MD) {
      return '50%';
    } else {
      return '33%';
    }
  }

  build() {
    Navigation(this.pageInfos) {
      Column() {
        Row() {
          Row() {
            Text($r('app.string.CommonDialogExamples'))
              .attributeModifier(this.textModifier)
            Image($r('app.media.icon_right'))
              .height(24)
              .opacity(0.2)
          }
          .attributeModifier(this.rowContentModifier)
        }
        .attributeModifier(this.rowBoxModifier)
        .onClick(() => {
          this.pageInfos.pushPath({ name: CommonConstant.COMMON_ACTION_PATH });
        })

        Row() {
          Row() {
            Text($r('app.string.OperableDialogExamples'))
              .attributeModifier(this.textModifier)
            Image($r('app.media.icon_right'))
              .height(24)
              .opacity(0.2)
          }
          .attributeModifier(this.rowContentModifier)
        }
        .attributeModifier(this.rowBoxModifier)
        .onClick(() => {
          this.pageInfos.pushPath({ name: CommonConstant.OPERABLE_ACTION_PATH });
        })

        Row() {
          Row() {
            Text($r('app.string.ReusableDialogExamples'))
              .attributeModifier(this.textModifier)
            Image($r('app.media.icon_right'))
              .height(24)
              .opacity(0.2)
          }
          .attributeModifier(this.rowContentModifier)
        }
        .attributeModifier(this.rowBoxModifier)
        .onClick(() => {
          this.pageInfos.pushPath({ name: CommonConstant.REUSE_ACTION_PATH });
        })

        Row() {
          Row() {
            Text($r('app.string.MultipleDialogExamples'))
              .attributeModifier(this.textModifier)
            Image($r('app.media.icon_right'))
              .height(24)
              .opacity(0.2)
          }
          .attributeModifier(this.rowContentModifier)
        }
        .attributeModifier(this.rowBoxModifier)
        .onClick(() => {
          this.pageInfos.pushPath({ name: CommonConstant.MULTI_ACTION_PATH });
        })
      }
      .height(CommonConstant.FULL_LENGTH)
      .justifyContent(FlexAlign.Start)
      .margin({ left: $r('app.float.index_body_margin'), right: $r('app.float.index_body_margin') })
      .padding({ bottom: $r('app.float.index_body_padding') })
    }
    .title($r('app.string.DialogHubDialogExamples'))
    .titleMode(NavigationTitleMode.Mini)
    .hideBackButton(true)
    .padding({
      top: this.avoidAreaHeight
    })
    .backgroundColor($r('app.color.index_page_bg_color'))
    .mode(this.getNavMode())
    .navBarWidth(this.getNavbarWidth())
    .onNavigationModeChange((mode: NavigationMode) => {
      if (mode === 1) {
        this.pageInfos.pushPath({ name: CommonConstant.COMMON_ACTION_PATH });
      }
    })
  }
}

@Extend(Row)
function superFancyRowBox() {
  .width(CommonConstant.FULL_LENGTH)
  .height($r('app.float.index_action_height'))
  .borderRadius(15)
  .margin({ bottom: $r('app.float.index_action_margin') })
  .padding(5)
  .backgroundColor($r('app.color.button_bg'))
}

@Extend(Row)
function superFancyRowContent() {
  .width(CommonConstant.FULL_LENGTH)
  .height(CommonConstant.FULL_LENGTH)
  .borderRadius(15)
  .padding({
    left: 10,
    right: 10
  })
  .justifyContent(FlexAlign.SpaceBetween)
}