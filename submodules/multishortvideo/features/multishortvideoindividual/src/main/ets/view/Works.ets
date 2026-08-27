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

import { deviceInfo } from '@kit.BasicServicesKit';
import {
CommonConstants,
getWindowInfoState,
MSVEmptyComponent,
MSVTextIcon,
WidthBreakpointType,
WindowInfo,
WindowUtil
} from 'multishortvideobase';
import { WorksDataModel } from '../model/WorksDataModel';
import { WorksViewModel } from '../viewmodel/WorksViewModel';

@ComponentV2
export struct Works {
  @Local windowInfo: WindowInfo = getWindowInfoState();
  @Local worksData: WorksDataModel[] = [];
  @Consumer('showSideIndividual') showSideIndividual: boolean = false;
  @Consumer('individualWidth') individualWidth: number = 0;

  aboutToAppear(): void {
    this.worksData = new WorksViewModel().getWorksList();
  }

  build() {
    if (this.worksData.length !== 0) {
      Grid() {
        Repeat<WorksDataModel>(this.worksData)
          .each((item: RepeatItem<WorksDataModel>) => {
            GridItem() {
              Stack({ alignContent: Alignment.BottomStart }) {
                Image(item.item.pic)
                  .width('100%')
                  .height('100%')
                  .objectFit(ImageFit.Cover)
                Row({ space: 5 }) {
                  MSVTextIcon({ src: $r('app.media.ic_like'), iconSize: 16 })
                  Text(item.item.likes)
                    .fontSize($r('sys.float.Body_S'))
                    .fontColor($r('sys.color.font_on_primary'))
                    .fontWeight($r('sys.float.font_weight_regular'))
                }
                .margin({
                  left: 12,
                  bottom: 12
                })
              }
            }
            .aspectRatio(0.68)
            .borderRadius(
              deviceInfo.deviceType === 'tv' && !this.showSideIndividual ? 20 : (this.showSideIndividual ? 10 : 0))
            .clip(true)
          })
          .key((item: WorksDataModel) => JSON.stringify(item))
          .virtualScroll({ totalCount: this.worksData.length })
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
      .padding({
        top: deviceInfo.deviceType === 'tv' ? 16 : 0,
        left: this.showSideIndividual ? 14 : 0,
        right: this.showSideIndividual ? 14 : 0,
        bottom: 56
      })
      .scrollBar(BarState.Off)
      .rowsGap(deviceInfo.deviceType === 'tv' && !this.showSideIndividual ? 32 : 8)
      .columnsGap(deviceInfo.deviceType === 'tv' && !this.showSideIndividual ? 32 : 8)
      .columnsTemplate(deviceInfo.deviceType === 'tv' ? (this.showSideIndividual ? 'repeat(3,1fr)' : 'repeat(4,1fr)') :
        new WidthBreakpointType<string>('repeat(3,1fr)', 'repeat(4,1fr)', 'repeat(6,1fr)',
          'repeat(6,1fr)', 'repeat(2,1fr)').getValue(this.showSideIndividual ?
          WindowUtil.getInstance().getCustomWidthBreakpoint(this.individualWidth) :
          this.windowInfo.widthBp))
    } else {
      MSVEmptyComponent()
    }
  }
}