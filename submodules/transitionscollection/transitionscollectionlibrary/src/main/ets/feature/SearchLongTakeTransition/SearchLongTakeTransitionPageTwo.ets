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
import { SearchPageExtraInfo } from '../../utils/commonutils/ExtraInfo';

@Builder
export function SearchLongTakeTransitionPageTwoBuilder() {
  SearchLongTakeTransitionPageTwo()
}

@Component
export default struct SearchLongTakeTransitionPageTwo {
  @StorageProp(CommonConstants.KEY_PREFIX_BREAKPOINT) currentBreakpoint: string = '';
  private pageInfos: NavPathStack = new NavPathStack();
  @Prop param: SearchPageExtraInfo;
  @State componentWidth: number = 0;
  @State viewWidth: number = 0;

  private onArrowClicked(): void {
    this.getUIContext().animateTo({
      curve: curves.interpolatingSpring(0, 1, 342, 38)
    }, () => {
      this.pageInfos.pop(false);
    })
  }

  build() {
    NavDestination() {
      Column() {
        Row({ space: 8 }) {
          Row() {
            Button({ type: ButtonType.Circle }) {
              SymbolGlyph($r('sys.symbol.chevron_backward'))
                .fontColor([$r('sys.color.icon_primary')])
                .fontSize($r('sys.float.Title_M'))
            }
            .height(40)
            .aspectRatio(1)
            .backgroundColor($r('sys.color.comp_background_tertiary'))
            .onClick(() => {
              this.onArrowClicked();
            })
            .transition(TransitionEffect.asymmetric(
              TransitionEffect.OPACITY
                .animation({ duration: 200, delay: 150, curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1) }),
              TransitionEffect.OPACITY
                .animation({ duration: 200, curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1) })
            ))
          }
          .height(86)
          .zIndex(2)
          .onAreaChange((_oldValue: Area, newValue: Area) => {
            this.componentWidth = newValue.width as number;
          })

          if (this.currentBreakpoint !== 'sm') {
            Text($r('app.string.search_title'))
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
            Blank()
          }
          // [Start bind_id]
          Search({ placeholder: 'Search' })
            .height(40)
            .placeholderColor($r('sys.color.font_primary'))
            .width(this.currentBreakpoint === 'sm' ? this.viewWidth - this.componentWidth - 16 * 2 - 8 :
                   this.currentBreakpoint === 'md' ? 308 : 400)
            .backgroundColor($r('sys.color.comp_background_primary'))
            .geometryTransition('SEARCH_ONE_SHOT_DEMO_TRANSITION_ID')
            .transition(TransitionEffect.opacity(0.99))
            .defaultFocus(true)
            .focusOnTouch(true)
          // [End bind_id]
        }
        .margin({
          top: 40,
          left: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                                   $r('sys.float.padding_level12') :
                                                                                   $r('sys.float.padding_level16'),
          right: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                                    $r('sys.float.padding_level12') :
                                                                                    $r('sys.float.padding_level16')
        })
        .width('100%')
        .height(50)
        .alignItems(VerticalAlign.Center)
        .padding(16)
      }
      .size({
        width: '100%',
        height: '100%'
      })
      .onAreaChange((_oldValue: Area, newValue: Area) => {
        this.viewWidth = newValue.width as number;
      })
    }
    .transition(TransitionEffect.OPACITY)
    .hideTitleBar(true)
    .backgroundColor($r('sys.color.background_secondary'))
    .onReady((context: NavDestinationContext) => {
      this.pageInfos = context.pathStack;
    })
    .onBackPressed(() => {
      this.getUIContext().animateTo({
        curve: curves.interpolatingSpring(0, 1, 342, 38),
      }, () => {
        this.pageInfos.pop(false);
      })
      return true;
    })
  }
}