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

import { CommonConstants, getWindowInfoState, WidthBreakpointType, WindowInfo } from 'multimobilepaymentbase';
import { BusinessModel } from '../model/BusinessModel';
import { BusinessViewModel } from '../viewmodel/BusinessViewModel';

/**
 * Business grid view component
 * Displays business function icons in a responsive grid layout
 */
@ComponentV2
export struct BusinessView {
  @Local windowInfo: WindowInfo = getWindowInfoState();
  private businesses: BusinessModel[] = new BusinessViewModel().getBusinessList();

  /**
   * Get the number of grid columns based on current breakpoint
   * @returns Number of columns (4, 6, or 8)
   */
  private getGridColumns(): number {
    return new WidthBreakpointType(CommonConstants.BUSINESS_GRID_COLUMNS_SM, CommonConstants.BUSINESS_GRID_COLUMNS_MD,
      CommonConstants.BUSINESS_GRID_COLUMNS_LG_XL,
      CommonConstants.BUSINESS_GRID_COLUMNS_LG_XL).getValue(this.windowInfo.widthBp);
  }

  build() {
    Column() {
      Grid() {
        ForEach(this.businesses, (item: BusinessModel) => {
          GridItem() {
            Column({ space: 8 }) {
              SymbolGlyph(item.getIcon())
                .fontSize($r('app.float.business_icon_size'))
                .fontColor([$r('app.color.primary')])
              Text(item.getText())
                .fontSize($r('app.float.business_text_size'))
                .fontColor($r('app.color.text_primary'))
            }
          }
          .height($r('app.float.business_item_height'))
        }, (_item: BusinessModel, index: number) => index.toString())
      }
      .columnsTemplate(`repeat(${this.getGridColumns()}, 1fr)`)
      .rowsTemplate('1fr 1fr')
      .rowsGap($r('app.float.business_grid_row_gap'))
      .padding($r('app.float.business_grid_padding'))
    }
    .height($r('app.float.business_height'))
    .backgroundColor($r('app.color.card_background'))
    .borderRadius($r('app.float.business_card_radius'))
    .width(this.windowInfo.widthBp <= WidthBreakpoint.WIDTH_MD ? CommonConstants.FULL_WIDTH :
      CommonConstants.BUSINESS_WIDTH)
  }
}