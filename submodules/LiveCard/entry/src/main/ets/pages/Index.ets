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

import { formBindingData, formProvider } from '@kit.FormKit';
import { common, Want } from '@kit.AbilityKit';
import { AddFormMenuItem, promptAction } from '@kit.ArkUI';
import type { BusinessError } from '@kit.BasicServicesKit';
import { HeaderSection } from '../view/common/HeaderSection';
import RouterUtil from '../utils/RouterUtil';
import { Logger } from '../utils/Logger';
import { CARD_ITEM_CONFIGS, CardItemConfig } from '../model/CardConstant';
import { CommonPadding } from '../common/CommonConstants';

const TAG = 'IndexPage';

const PREVIEW_ANIMATION_SCALE_BEGIN: number = 0.8;
const PREVIEW_ANIMATION_SCALE_END: number = 1.0;

const MODULE_NAME: string = 'livecardsample';

@Entry
@Component
struct Index {
  private pathStack: NavPathStack = RouterUtil.getInstance().getPathStack();

  aboutToAppear(): void {
    Logger.info(TAG, `Index aboutToAppear success`);
  }

  build() {
    Navigation(this.pathStack) {
      RootComponent();
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .backgroundColor($r('sys.color.comp_background_gray'))
    .hideTitleBar(true)
    .mode(NavigationMode.Stack);
  }
}

@Component
struct RootComponent {
  @State cardInfoList: CardItemConfig[] = CARD_ITEM_CONFIGS;
  @State defaultConfig: CardItemConfig = CARD_ITEM_CONFIGS[0];

  @Builder
  CardAddMenu() {
    Menu() {
      AddFormMenuItem(
        {
          bundleName: (this.getUIContext().getHostContext() as common.UIAbilityContext).abilityInfo.bundleName,
          abilityName: 'EntryFormAbility',
          parameters: {
            'ohos.extra.param.key.form_dimension': this.defaultConfig.cardDimension,
            'ohos.extra.param.key.form_name': this.defaultConfig.cardName,
            'ohos.extra.param.key.module_name': MODULE_NAME
          },
        },
        this.defaultConfig.cardName,
        {
          formBindingData: formBindingData.createFormBindingData({}),
          callback: (result, formId) => {
            Logger.info(TAG, `callback info：result = ${result.code}, formId = ${formId}`);
            if (result?.code === 0) {
              Logger.info(TAG, '添加至桌面成功');
              RouterUtil.getInstance().closeApp();
            } else {
              Logger.info(TAG, '添加至桌面失败，请尝试其它添加方式');
            }
          }
        }
      );
    };
  }

  @Builder
  CardList() {
    GridRow({
      columns: { xs: 2, md: 4, lg: 6 },
      gutter: 12
    }) {
      ForEach(this.cardInfoList, (config: CardItemConfig) => {
        GridCol({
          span: config.span,
          offset: config.offset
        }) {
          Image(config.mainImg)
            .id(config.cardName)
            .width('100%')
            .objectFit(ImageFit.Contain)
            .onTouch(() => {
              this.defaultConfig = config;
            })
            .draggable(false)
            .bindContextMenu(this.CardAddMenu, ResponseType.LongPress, {
              placement: Placement.BottomRight,
              preview: MenuPreviewMode.IMAGE,
              previewAnimationOptions: { scale: [PREVIEW_ANIMATION_SCALE_BEGIN, PREVIEW_ANIMATION_SCALE_END] },
              mask: { color: '#26000000', backgroundBlurStyle: BlurStyle.BACKGROUND_THIN }
            });
        };
      }, (config: CardItemConfig) => { return JSON.stringify(config)});
    };
  }

  build() {
    Column() {
      HeaderSection($r('app.string.EntryAbility_label'), undefined, undefined, true);
      Scroll() {
        Column() {
          this.CardList();
        };
      }
      .align(Alignment.Top)
      .margin({ top: 12 })
      .scrollBar(BarState.Off)
      .layoutWeight(1);
      Row() {
        Text($r('app.string.common_go_add'))
          .textAlign(TextAlign.Center)
          .fontColor($r('sys.color.font_emphasize'))
          .fontSize(16)
          .lineHeight(21)
          .fontWeight(FontWeight.Medium);
      }
      .justifyContent(FlexAlign.Center)
      .borderRadius($r('app.float.border_radius'))
      .width('100%')
      .backgroundColor($r('sys.color.comp_background_tertiary'))
      .height(40)
      .constraintSize({ maxWidth: 448 })
      .margin({
        top: 9,
        bottom: 9,
      })
      .onClick(() => {
        this.openFormManager(this.defaultConfig);
      });
    }
    .padding({ left: CommonPadding.SMALL, right: CommonPadding.SMALL })
    .width('100%')
    .height('100%');
  }

  openFormManager(config: CardItemConfig): void {
    const want: Want = {
      bundleName: (this.getUIContext().getHostContext() as common.UIAbilityContext).abilityInfo.bundleName,
      abilityName: 'EntryFormAbility',
      parameters: {
        'ohos.extra.param.key.form_dimension': config.cardDimension,
        'ohos.extra.param.key.form_name': config.cardName,
        'ohos.extra.param.key.module_name': MODULE_NAME,
        'ohos.extra.param.key.form_location': 0
      }
    };
    try {
      formProvider.openFormManager(want);
    } catch (e) {
      promptAction.openToast({ message: (e as BusinessError).message }).catch(() => {});
    }
  }
}