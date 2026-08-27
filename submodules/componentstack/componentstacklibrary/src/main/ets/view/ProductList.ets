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

import { ProductDataModel } from '../viewmodel/IconViewModel';
import { ProductDataSource } from '../viewmodel/DataSource';
import { PRODUCT_DATA } from '../model/IconModel';
import { BusinessError } from '@kit.BasicServicesKit';
import { CommonConstants } from '../constants/CommonConstants';
import { BreakpointTypeEnum } from '../utils/BreakpointSystem';
import Logger from '../utils/Logger';

const TAG: string = '[ProductList]';

@Component
export struct ProductList {
  private productData: ProductDataSource = new ProductDataSource();
  @StorageLink(CommonConstants.KEY_PREFIX + 'currentBreakpoint') curBp: string = BreakpointTypeEnum.SM;

  aboutToAppear() {
    this.productData.pushData(PRODUCT_DATA);
  }

  @Builder
  waterFlowComponent(item: ProductDataModel) {
    Column({ space: CommonConstants.COLUMN_SPACE }) {
      Image(item.uri)
        .width($r('app.integer.icon_view_image_width'))
        .aspectRatio(1)
        .objectFit(ImageFit.Contain)
        .margin({ top: $r('app.integer.water_flow_image_margin_top') })
        .alignSelf(ItemAlign.Center)
        .padding({ right: $r('app.integer.icon_view_padding_right') })

      Text(item.title)
        .width(CommonConstants.FULL_PERCENT)
        .fontSize($r('app.integer.water_flow_title_font_size'))
        .fontWeight(FontWeight.Bold)
        .fontColor($r('sys.color.font_primary'))

      Text(item.price)
        .width(CommonConstants.FULL_PERCENT)
        .fontSize($r('app.integer.water_flow_price_font_size'))
        .offset({ x: CommonConstants.OFFSET })
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.ohos_id_color_warning'))

      Text(item.insurance)
        .fontSize($r('app.integer.water_flow_insurance_font_size'))
        .fontColor($r('app.color.ohos_id_color_list_alert'))
        .borderColor($r('app.color.ohos_id_color_list_alert'))
        .borderWidth($r('app.integer.water_flow_insurance_border_width'))
        .borderRadius($r('app.integer.water_flow_insurance_border_radius'))
        .padding({
          left: $r('app.integer.water_flow_insurance_padding_horizontal'),
          right: $r('app.integer.water_flow_insurance_padding_horizontal'),
          top: $r('app.integer.water_flow_insurance_padding_vertical'),
          bottom: $r('app.integer.water_flow_insurance_padding_vertical')
        })
        .margin({ top: $r('app.integer.water_flow_insurance_margin_top') })
    }
    .alignItems(HorizontalAlign.Start)
    .padding({ left: $r('app.integer.water_flow_column_padding_left') })
    .width(CommonConstants.FULL_PERCENT)
    .height($r('app.integer.water_flow_column_height'))
    .backgroundColor($r('sys.color.comp_background_primary'))
    .borderRadius($r('app.integer.water_flow_column_border_radius'))
    .onClick(() => {
      try {
        this.getUIContext().getPromptAction().showToast({ message: $r('app.string.component_stack_other_function') });
      } catch (error) {
        const err = error as BusinessError;
        Logger.error(TAG, `showToast catch error, code: ${err.code}, message: ${err.message}`);
      }
    });
  }

  build() {
    WaterFlow() {
      LazyForEach(this.productData, (item: ProductDataModel) => {
        FlowItem() {
          this.waterFlowComponent(item)
        }
      }, (item: ProductDataModel) => item.id.toString())
    }
    .cachedCount(2)
    .nestedScroll({
      scrollForward: NestedScrollMode.PARENT_FIRST,
      scrollBackward: NestedScrollMode.SELF_FIRST
    })
    .columnsTemplate(this.curBp === 'sm' ? '1fr 1fr' : this.curBp === 'md' ? '1fr 1fr 1fr' : '1fr 1fr 1fr 1fr')
    .columnsGap(CommonConstants.COLUMNS_GAP)
    .rowsGap(CommonConstants.ROWS_GAP)
    .padding({ bottom: $r('app.integer.water_flow_padding_bottom') })
  }
}