/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import { HomeHeader } from 'multishoppingbase';
import { WidthBreakpointType } from 'multishoppingbase';
import { ProductClassification } from 'multishoppingproduct';
import { HomeRecommend } from 'multishoppingrecommend';
import { uiObserver } from '@kit.ArkUI';

@ComponentV2
export struct Home {
  @Env(SystemProperties.BREAK_POINT) breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;
  private scroller: Scroller = new Scroller();

  build() {
    Column() {
      HomeHeader()
      Scroll(this.scroller) {
        Column() {
          ProductClassification()
          HomeRecommend()
        }
        .width('100%')
      }
      .layoutWeight(1)
      .width('100%')
      .scrollBar(BarState.Off)
      .padding({
        bottom: 70
      })
    }
    .height('100%')
    .width('100%')
    .padding({
      left: new WidthBreakpointType('16vp', '16vp', '24vp', '24vp').getValue(this.breakpoint.widthBreakpoint),
      right: new WidthBreakpointType('16vp', '16vp', '24vp', '24vp').getValue(this.breakpoint.widthBreakpoint),
    })
  }
}