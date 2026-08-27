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

import { image } from '@kit.ImageKit';
import { CardAttr, WaterFlowDataSource } from '../../utils/commonutils/WaterFlowDataSource';
import { SnapShotImage } from '../../utils/customtransition/SnapShotImage';
import { CardUtil } from '../../utils/commonutils/CardUtil';
import { CardComponent } from './CardComponent';
import { BusinessError } from '@kit.BasicServicesKit';
import CommonConstants from '../../common/CommonConstants';
import Logger from '../../utils/Logger';

const TAG: string = 'CardLongTakeTransition';

@Builder
export function CardLongTakeTransitionPageOneBuilder() {
  CardLongTakeTransitionPageOne()
}

@Component
export struct CardLongTakeTransitionPageOne {
  @State dataSource: WaterFlowDataSource = new WaterFlowDataSource();
  @State columnType: string = '';
  @StorageProp(CommonConstants.KEY_PREFIX_BREAKPOINT) @Watch('upDateColumnData') currentBreakpoint: string = '';
  @StorageProp(CommonConstants.KEY_PREFIX_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageProp(CommonConstants.KEY_PREFIX_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  private clickedIndex: number = -1;
  private pageInfos: NavPathStack = new NavPathStack();

  aboutToAppear(): void {
    for (let i = 0; i < 18; i++) {
      this.dataSource.pushData(new CardAttr());
    }
    this.upDateColumnData();
  }

  aboutToDisappear(): void {
    SnapShotImage.pixelMap?.release();
  }

  private upDateColumnData(): void {
    let currentBreakpoint: string | undefined = AppStorage.get(CommonConstants.KEY_PREFIX_BREAKPOINT);
    if (currentBreakpoint === 'sm') {
      this.columnType = '1fr 1fr';
    } else if (currentBreakpoint === 'md') {
      this.columnType = '1fr 1fr 1fr';
    } else {
      this.columnType = '1fr 1fr 1fr 1fr';
    }
  }

  private doFinishTransition(): void {
    this.dataSource.getData(this.clickedIndex).isVisible = Visibility.Visible;
  }

  private onColumnClicked(indexValue: string): void {
    let param: Record<string, Object> = {};
    let clickedIndex = parseInt(indexValue);
    param['indexValue'] = clickedIndex;
    this.clickedIndex = clickedIndex;
    try {
      // Click the card to get the corresponding screenshot and save it.
      this.getUIContext()
        .getComponentSnapshot()
        .get('FlowItem_' + indexValue, (error: Error, pixelMap: image.PixelMap) => {
          if (error) {
            Logger.error(TAG,
              `componentSnapshot.get error, reason: ${(error as BusinessError).message}`);
            this.pageInfos.pushPath({ name: 'CardLongTakeTransitionPageTwo', param: param });
            return;
          } else {
            Logger.info(TAG, 'componentSnapshot.get success!');
            // If the screenshot is successful, then go to a custom mirror in the end transition.
            param['clickedComponentId'] = CardUtil.getFlowItemIdByIndex(indexValue);
            param['doDefaultTransition'] = () => {
              this.doFinishTransition();
            };
            SnapShotImage.pixelMap = pixelMap;
            this.pageInfos.pushPath({ name: 'CardLongTakeTransitionPageTwo', param: param });
            this.dataSource.getData(this.clickedIndex).isVisible = Visibility.Hidden;
          }
        });
    } catch (error) {
      Logger.error(TAG, `Failed to click column. Cause: ${(error as BusinessError).message}`);
    }
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Top }) {
        // eslint-disable-next-line @performance/waterflow-data-preload-check
        WaterFlow() {
          LazyForEach(this.dataSource, (item: CardAttr, index: number) => {
            FlowItem() {
              // eslint-disable-next-line @performance/hp-arkui-use-reusable-component
              CardComponent({
                indexValue: index.toString(),
                cardAttr: item,
                onColumnClicked: (indexValue: string) => {
                  this.onColumnClicked(indexValue);
                }
              })
                .reuseId('CardComponent')
            }
            .width('100%')
            .borderRadius(10)
            .clip(true)
            .id(CardUtil.getFlowItemIdByIndex(index.toString()))
          }, (item: string) => item)
        }
        .cachedCount(this.currentBreakpoint === 'xs' ? 9 : 12)
        .padding({
          left: $r('sys.float.padding_level8'),
          right: $r('sys.float.padding_level8'),
        })
        .columnsTemplate(this.columnType)
        .columnsGap(10)
        .rowsGap(10)
        .width('100%')
        .height('auto')
      }
      .size({
        width: '100%',
        height: '100%'
      })
    }
    .backgroundColor($r('sys.color.background_secondary'))
    .padding({
      top: this.statusBarHeight,
      bottom: this.navigatorBarHeight,
    })
    .title($r('app.string.card_title'))
    .onReady((context: NavDestinationContext) => {
      this.pageInfos = context.pathStack;
    })
  }
}