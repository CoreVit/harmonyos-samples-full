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

import { curves } from '@kit.ArkUI';
import CommonConstants from '../../common/CommonConstants';
import { getResourceString } from '../../utils/commonutils/ResourceString';

@Builder
export function SearchLongTakeTransitionPageOneBuilder() {
  SearchLongTakeTransitionPageOne()
}

@Entry
@Component
struct SearchLongTakeTransitionPageOne {
  @State translateY: number = 0;
  @State transitionEffect: TransitionEffect = TransitionEffect.IDENTITY;
  private pageInfos: NavPathStack = new NavPathStack();
  @StorageProp(CommonConstants.KEY_PREFIX_BREAKPOINT) currentBreakpoint: string = '';

  private showSearchPage(): void {
    this.transitionEffect = TransitionEffect.OPACITY;
    this.getUIContext().animateTo({
      curve: curves.interpolatingSpring(0, 1, 342, 38)
    }, () => {
      this.pageInfos.pushPath({ name: 'SearchLongTakeTransitionPageTwo' }, false);
    })
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

        Text($r('app.string.search_title'))
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
      .height(86)
      .zIndex(2)

      Column({ space: 20 }) {
        Search({ placeholder: 'Search' })
          .height(40)
          .placeholderColor($r('sys.color.font_primary'))
          .width(this.currentBreakpoint === 'sm' ? '100%' : this.currentBreakpoint === 'md' ? 308 : 400)
          .geometryTransition('SEARCH_ONE_SHOT_DEMO_TRANSITION_ID', { follow: true })
          .backgroundColor($r('sys.color.comp_background_primary'))
          .defaultFocus(false)
          .focusOnTouch(false)
          .focusable(false)
          .onTouch((event: TouchEvent) => {
            if (event.type === TouchType.Up) {
              this.showSearchPage();
            }
          })
      }
      .alignItems(HorizontalAlign.Start)
      .size({
        width: '100%',
        height: '100%'
      })
      .padding({
        left: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                                 $r('sys.float.padding_level12') :
                                                                                 $r('sys.float.padding_level16'),
        right: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                                  $r('sys.float.padding_level12') :
                                                                                  $r('sys.float.padding_level16')
      })
    }
    .hideTitleBar(true)
    .transition(TransitionEffect.OPACITY)
    .backgroundColor($r('sys.color.background_secondary'))
    .title(getResourceString($r('app.string.search_title'), this))
    .onReady((context: NavDestinationContext) => {
      this.pageInfos = context.pathStack;
    })
    .onBackPressed(() => {
      this.transitionEffect = TransitionEffect.IDENTITY;
      this.pageInfos.pop(true);
      return true;
    })
  }
}