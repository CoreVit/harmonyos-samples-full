/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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


import CommonConstants from '../../../common/CommonConstants';
import { DigitalScrollConstants } from '../constants/DigitalScrollConstants';
import { DigitalScrollDetail } from './DigitalScrollDetail';

@Component
export struct DigitalScrollExample {
  @State public isRefresh: boolean = false;
  @StorageProp(CommonConstants.KEY_PREFIX_BREAKPOINT) currentBreakpoint: string = '';
  private pageInfos: NavPathStack = new NavPathStack();
  private scroller: Scroller = new Scroller();

  @Builder
  scrollArea() {
    List({ space: DigitalScrollConstants.ITEM_SPACE, scroller: this.scroller }) {
      ListItem() {
        Text($r('app.string.digital_scroll_animation_ticket'))
          .fontSize($r('sys.float.ohos_id_text_size_headline8'))
          .fontWeight(FontWeight.Bold)
          .width($r('app.string.max_size'))
          .textAlign(TextAlign.Center)
      }

      ListItem() {
        Row({ space: DigitalScrollConstants.TEXT_SPACE }) {
          Text($r('app.string.digital_scroll_animation_today'))
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))

          DigitalScrollDetail({ isRefresh: this.isRefresh })

          Text($r('app.string.digital_scroll_animation_get_ticket'))
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        }
        .width($r('app.string.max_size'))
        .justifyContent(FlexAlign.Center)
      }
    }
    .scrollBar(BarState.Off)
    .height($r('app.string.max_size'))
  }

  build() {
    NavDestination() {
      Row() {
        Button({ type: ButtonType.Circle }) {
          SymbolGlyph($r('sys.symbol.chevron_backward'))
            .fontColor([$r('sys.color.icon_primary')])
            .fontSize($r('sys.float.Title_M'))
        }
        .height(40)
        .aspectRatio(1)
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .onClick(() => this.pageInfos.pop())

        Text('')
          .margin({ left: $r('sys.float.padding_level4') })
          .font({ size: 20, weight: 700 })
          .fontColor($r('sys.color.font_primary'))
      }
      .padding({
        top: 40,
        left: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                                 $r('sys.float.padding_level12') :
                                                                                 $r('sys.float.padding_level16'),
        right: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                                  $r('sys.float.padding_level12') :
                                                                                  $r('sys.float.padding_level16')
      })
      .width('100%')
      .height(96)
      .zIndex(2)

      Column({ space: DigitalScrollConstants.ITEM_SPACE }) {
        Refresh({ refreshing: $$this.isRefresh }) {
          this.scrollArea()
        }
        .onRefreshing(() => {
          setTimeout(() => {
            this.isRefresh = false;
          }, DigitalScrollConstants.TIME_OUT);
        })
      }
      .padding({ top: $r('app.float.column_padding_top') })
      .width($r('app.string.max_size'))
      .height($r('app.string.max_size'))
    }
    .onReady((context: NavDestinationContext) => {
      this.pageInfos = context.pathStack;
    })
    .hideTitleBar(true)

  }
}

@Builder
export function getDigitalScrollExample(name: string): void {
  if (name === 'DigitalScrollExample') {
    DigitalScrollExample()

  }
}

export const wrappedBuilderDigitalScroll: WrappedBuilder<[string, number]> = wrapBuilder(getDigitalScrollExample);