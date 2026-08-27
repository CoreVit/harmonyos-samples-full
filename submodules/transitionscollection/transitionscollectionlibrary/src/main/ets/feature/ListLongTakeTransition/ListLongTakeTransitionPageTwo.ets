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
import { ListDetailPageExtraInfo } from '../../utils/commonutils/ExtraInfo';
import { BreakpointTypeEnum } from '../../utils/windowutils/BreakpointSystem';

@Builder
export function ListLongTakeTransitionPageTwoBuilder() {
  ListLongTakeTransitionPageTwo()
}

@Component
export default struct ListLongTakeTransitionPageTwo {
  @StorageProp(CommonConstants.KEY_PREFIX_BREAKPOINT) currentBreakpoint: string = BreakpointTypeEnum.SM;
  private pageInfos: NavPathStack = new NavPathStack();
  private param: ListDetailPageExtraInfo = new ListDetailPageExtraInfo('', '', $r('app.string.DetailPage_text'));
  private uiContext: UIContext = this.getUIContext();

  customBackPressed(): boolean {
    this.uiContext.animateTo({ curve: curves.interpolatingSpring(0, 1, 342, 38) }, () => {
      this.pageInfos.pop(false);
    })
    return true;
  }

  build() {
    NavDestination() {
      Column({ space: 20 }) {
        Row() {
          Button({ type: ButtonType.Circle }) {
            SymbolGlyph($r('sys.symbol.chevron_backward'))
              .fontColor([$r('sys.color.icon_primary')])
              .fontSize($r('sys.float.Title_M'))
          }
          .height(40)
          .aspectRatio(1)
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .onClick(() => this.customBackPressed())
        }
        .width('100%')
        .height(56)

        Text(this.param?.title ?? '')
          .fontSize(30)
          .fontWeight(FontWeight.Medium)

        Text(this.param?.content ?? '')
          .fontColor($r('sys.color.font_primary'))
          .lineHeight(28)
          .fontSize(16)
      }
      .alignItems(HorizontalAlign.Start)
      .clip(true)
      .size({
        width: '100%',
        height: '100%'
      })
      .geometryTransition(this.param?.geometryId ?? '')
    }
    .padding({
      top: 46,
      left: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                               $r('sys.float.padding_level12') :
                                                                               $r('sys.float.padding_level16'),
      right: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                                $r('sys.float.padding_level12') :
                                                                                $r('sys.float.padding_level16')
    })
    .backgroundColor(CommonConstants.DEFAULT_BG_COLOR)
    .transition(TransitionEffect.OPACITY)
    .hideTitleBar(true)
    .backgroundColor(Color.Transparent)
    .onReady((context: NavDestinationContext) => {
      this.pageInfos = context.pathStack;
      this.param = (context.pathInfo.param as ListDetailPageExtraInfo);
    })
    .onBackPressed(() => {
      return this.customBackPressed();
    })
  }
}