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

import CommonConstants from '../../common/CommonConstants';
import { CardAttr } from '../../utils/commonutils/WaterFlowDataSource';

@Reusable
@Component
export struct CardComponent {
  @State cardAttr: CardAttr = new CardAttr();
  @State indexValue: string = '';
  public onColumnClicked?: (index: string) => void = (_index: string) => {
  };

  aboutToReuse(params: Record<string, object>): void {
    this.cardAttr = params.cardAttr as CardAttr;
    this.indexValue = (params.indexValue as String).toString();
    this.onColumnClicked = params.onColumnClicked as (index: string) => void;
  }

  build() {
    Column() {
      Image($r(`app.media.img_${(parseInt(this.indexValue) % 6)}`))
        .width('100%')
        .objectFit(ImageFit.Auto)
        .draggable(false)

      Text($r('app.string.content'))
        .width('100%')
        .height(CommonConstants.ITEM_TEXT_HEIGHT)
        .fontColor($r('sys.color.font_primary'))
        .fontSize(CommonConstants.FONT_TEXT)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .padding($r('sys.float.padding_level6'))
    }
    .backgroundColor($r('sys.color.comp_background_primary'))
    .width('100%')
    .onClick(() => {
      this.onColumnClicked?.(this.indexValue);
    })
  }
}