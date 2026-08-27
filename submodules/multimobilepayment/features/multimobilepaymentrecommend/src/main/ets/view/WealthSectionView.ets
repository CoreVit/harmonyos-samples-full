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
import { ImageModel } from '../model/ImageModel';
import { ImageViewModel } from '../viewmodel/ImageViewModel';

/**
 * Wealth section view component
 * Displays wealth selection images in a responsive grid layout
 */
@ComponentV2
export struct WealthSectionView {
  @Local windowInfo: WindowInfo = getWindowInfoState();
  private imageList: ImageModel[] = new ImageViewModel().getImageList();
  private wealthList: ImageModel[] = new ImageViewModel().getWealthList();

  /**
   * Get the number of grid columns based on current breakpoint
   * @returns Number of columns (1, 2, or 4)
   */
  private getGridColumns(): number {
    return new WidthBreakpointType(CommonConstants.WEALTH_GRID_COLUMNS_SM, CommonConstants.WEALTH_GRID_COLUMNS_MD,
      CommonConstants.WEALTH_GRID_COLUMNS_LG_XL,
      CommonConstants.WEALTH_GRID_COLUMNS_LG_XL).getValue(this.windowInfo.widthBp);
  }

  private getImageTopList(): ImageModel[] {
    return this.imageList.slice(0,
      new WidthBreakpointType(CommonConstants.WEALTH_GRID_COLUMNS_SM, CommonConstants.WEALTH_GRID_COLUMNS_MD,
        CommonConstants.WEALTH_GRID_COLUMNS_LG_XL,
        CommonConstants.WEALTH_GRID_COLUMNS_LG_XL).getValue(this.windowInfo.widthBp));
  }

  build() {
    Column({ space: $r('app.float.wealth_section_space') }) {
      Grid() {
        ForEach(this.getImageTopList(), (item: ImageModel) => {
          GridItem() {
            Image(item.getIcon())
              .width(CommonConstants.FULL_WIDTH)
              .objectFit(ImageFit.Cover)
              .borderRadius($r('app.float.wealth_image_radius'))
              .height($r('app.float.wealth_image_height'))
          }
        }, (_item: ImageModel, index: number) => index.toString())
      }
      .columnsTemplate(`repeat(${this.getGridColumns()}, 1fr)`)
      .columnsGap($r('app.float.grid_gap'))
      .rowsGap($r('app.float.grid_gap'))
      .width(CommonConstants.FULL_WIDTH)

      Text($r('app.string.wealth_selected'))
        .fontSize($r('app.float.wealth_section_title_font_size'))
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.primary'))
        .alignSelf(ItemAlign.Start)

      Grid() {
        ForEach(this.wealthList, (item: ImageModel) => {
          GridItem() {
            Image(item.getIcon())
              .width(CommonConstants.FULL_WIDTH)
              .objectFit(ImageFit.Cover)
              .borderRadius($r('app.float.wealth_image_radius'))
              .height($r('app.float.wealth_image_height'))
          }
        }, (_item: ImageModel, index: number) => index.toString())
      }
      .columnsTemplate(`repeat(${this.getGridColumns()}, 1fr)`)
      .columnsGap($r('app.float.grid_gap'))
      .rowsGap($r('app.float.grid_gap'))
      .width(CommonConstants.FULL_WIDTH)
    }
    .width(CommonConstants.FULL_WIDTH)
    .backgroundColor(this.windowInfo.widthBp <= WidthBreakpoint.WIDTH_MD ? $r('app.color.on_primary') :
      $r('app.color.gray_01'))
    .padding({
      left: $r('app.float.wealth_padding_horizontal'),
      right: $r('app.float.wealth_padding_horizontal'),
      bottom: this.windowInfo.navigationBarBottomVp,
      top: $r('app.float.wealth_padding_top')
    })
  }
}
