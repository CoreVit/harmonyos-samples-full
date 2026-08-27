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

import { uiObserver } from '@kit.ArkUI';
import { ProductConfig } from './ProductConfig';
import { ProductDiscount } from './ProductDiscount';
import { ProductPrice } from './ProductPrice';
import { UserComments } from './UserComments';
import { ProductInfoState } from '../viewmodel/ProductInfoState';
import { WidthBreakpointType } from 'multishoppingbase';

@ComponentV2
export struct ProductInfo {
  @Env(SystemProperties.BREAK_POINT) private breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;
  @Local private state: ProductInfoState = new ProductInfoState(this.getUIContext().getHostContext()!);

  build() {
    Column() {
      ProductPrice({
        widthBp: this.breakpoint.widthBreakpoint,
        state: this.state
      })
      ProductDiscount({
        widthBp: this.breakpoint.widthBreakpoint,
        state: this.state
      })
      ProductConfig({
        widthBp: this.breakpoint.widthBreakpoint,
        state: this.state
      })
      UserComments({
        widthBp: this.breakpoint.widthBreakpoint,
        state: this.state
      })
    }
    .background($r('app.color.page_section_background'))
    .width('100%')
    .padding({
      left: new WidthBreakpointType(16, 24, 32, 32).getValue(this.breakpoint.widthBreakpoint),
      right: new WidthBreakpointType(16, 24, 32, 32).getValue(this.breakpoint.widthBreakpoint),
      bottom: 16
    })
  }
}
