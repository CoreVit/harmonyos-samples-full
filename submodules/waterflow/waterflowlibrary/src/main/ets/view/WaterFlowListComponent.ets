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
import { CommonConstants, CommonConstants as Const, NavPageStyle } from '../common/constants/CommonConstants';
import FlowItemComponent from './FlowItemComponent';
import { loadingMoreFlowData } from '../model/HomeViewModel';
import { IProductItem } from '../model/ProductItem';
import { WaterFlowDataSource } from '../model/WaterFlowDataSource';

@Component
export default struct WaterFlowListComponent {
  @Prop datasource: WaterFlowDataSource;
  @Consume(CommonConstants.AS_KEY_SUB_PATH_STACK) pageInfos: NavPathStack;
  @StorageProp(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  @StorageProp(CommonConstants.AS_KEY_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  private scroller: Scroller = new Scroller();
  private isEnd: boolean = false;

  aboutToAppear() {
    if (this.datasource.totalCount() <= CommonConstants.DATASOURCE_MIN_COUNT) {
      this.isEnd = true;
    }
  }

  build() {
    WaterFlow({ footer: (): void => this.itemProgressFoot(), scroller: this.scroller }) {
      LazyForEach(this.datasource, (item: IProductItem) => {
        FlowItem() {
          FlowItemComponent({ item: item })
        }.onClick(() => {
          this.pageInfos.pushPathByName('GoodsDetailComponent', item.id);
        })
      }, (item: IProductItem) => JSON.stringify(item))
    }
    .height(CommonConstants.FULL_HEIGHT)
    .friction(CommonConstants.WATER_FLOW_FRICTION)
    .nestedScroll({
      scrollForward: NestedScrollMode.PARENT_FIRST,
      scrollBackward: NestedScrollMode.SELF_FIRST
    })
    .onScrollIndex((_: number, last: number) => {
      if ((last + CommonConstants.CACHED_COUNT) === this.datasource.totalCount()) {
        setTimeout(() => {
          this.datasource.addMoreData(loadingMoreFlowData);
        }, CommonConstants.TIME_OUT_FIVE_HUNDREDS);
      }
    })
    .layoutWeight(Const.WATER_FLOW_LAYOUT_WEIGHT)
    .layoutDirection(FlexDirection.Column)
    .columnsTemplate(new BreakpointType({
      sm: '1fr 1fr',
      md: '1fr 1fr 1fr',
      lg: '1fr 1fr 1fr 1fr'
    }).getValue(this.curBp))
    .columnsGap($r('app.float.water_flow_columns_gap'))
    .rowsGap($r('app.float.water_flow_row_gap'))
    .padding({
      bottom: NavPageStyle.BAR_HEIGHT - 10
    })
    .cachedCount(CommonConstants.CACHED_COUNT)
  }

  @Builder
  itemProgressFoot() {
    Row({ space: 5 }) {
      LoadingProgress()
        .width($r('app.float.loadingProgress_width'))
        .height($r('app.float.loadingProgress_height'))
      Text($r('app.string.loading')).fontSize($r('app.float.progress_font_size')).fontColor(Color.Gray)
    }
    .justifyContent(FlexAlign.Center)
    .width(CommonConstants.FULL_WIDTH)
    .margin({
      top: 10,
      bottom: this.navigatorBarHeight
    })
    .visibility(this.isEnd ? Visibility.Hidden : Visibility.Visible)
  }
}