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

import { CommonConstants, ImageAndName } from '../common/CommonConstants';
import { BreakpointType } from '../utils/BreakpointSystem';

@Component
export default struct ThemeDesktop {
  @Link themeDatas: Array<ImageAndName>;
  @StorageProp(CommonConstants.KEY_PREFIX + 'Breakpoint') curBp: string = 'sm';

  build() {
    Grid() {
      ForEach(this.themeDatas, (item: ImageAndName) => {
        GridItem() {
          Column() {
            SymbolGlyph(item.image)
              .fontSize(45)
              .fontColor([item.color])
              .margin({ bottom: $r('sys.float.padding_level2') })
            Text(item.name)
              .fontColor(item.color)
              .fontSize(15)
          }
          .height(90)
          .width('100%')
          .backgroundColor($r('sys.color.background_secondary'))
        }
      }, (item: ImageAndName) => JSON.stringify(item))
    }
    .rowsGap(10)
    .width('100%')
    .columnsGap(10)
    .layoutWeight(1)
    .padding({ top: 20 })
    .backgroundColor($r('sys.color.background_secondary'))
    .columnsTemplate(new BreakpointType({
      sm: '1fr 1fr 1fr 1fr', md: '1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr',
      lg: '1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr'
    }).getValue(this.curBp))
  }
}