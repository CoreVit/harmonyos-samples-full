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

import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { CommonConstants } from '../common/constants/CommonConstants';
import { GridData } from '../model/GridListDataSources';
import GridItemComponent from './GridItemComponent';

@Component
export default struct GridComponent {
  @StorageLink(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  @State gridData: GridData = new GridData('', []);
  @State isLastItem: boolean = false;

  build() {
    Column() {
      Row() {
        Text(this.gridData.groupName)
          .fontColor($r('sys.color.font_secondary'))
          .fontSize($r('sys.float.Title_S'))
          .height($r('app.float.grid_title_height'))
          .fontWeight(FontWeight.Bold)
          .margin({ top: $r('sys.float.padding_level8') })
      }
      .width(CommonConstants.FULL_PERCENT)
      .justifyContent(FlexAlign.Start)

      Grid() {
        ForEach(this.gridData.gridItemList, (item: string) => {
          GridItemComponent({ itemName: item })
        }, (item: string, index: number) => (index + item).toString())
      }
      .margin({
        top: $r('sys.float.padding_level4')
      })
      .borderRadius($r('sys.float.corner_radius_level6'))
      .padding({
        top: $r('sys.float.padding_level6'),
        bottom: $r('sys.float.padding_level6')
      })
      .height(this.getGridHeight())
      .rowsGap($r('app.float.grid_rows_gap_size'))
      .scrollBar(BarState.Off)
      .columnsTemplate(new BreakpointType({
        sm: CommonConstants.GRID_COLUMNS_TEMPLATE_SM,
        md: CommonConstants.GRID_COLUMNS_TEMPLATE_MD,
        lg: CommonConstants.GRID_COLUMNS_TEMPLATE_LG
      }).getValue(this.curBp))
      .backgroundColor($r('sys.color.comp_background_primary'))

      if (this.isLastItem) {
        Blank()
          .height(CommonConstants.FULL_PERCENT)
      }
    }
  }

  getGridHeight(): number {
    let lineNumber: number = this.curBp === 'sm' ? 4 : this.curBp === 'md' ? 6 : 8
    //Grid height to be calculated
    let gridHeight: number = 0;
    //Total height of grid items in each row.
    gridHeight += Math.ceil(this.gridData.gridItemList.length / lineNumber) * 68;
    //Total height of the intervals between grid items.
    gridHeight += (Math.ceil(this.gridData.gridItemList.length / lineNumber) - 1) * 8;
    //Top and bottom margins of the grid
    gridHeight += 12 * 2;
    return gridHeight;
  }
}