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
import { Constants } from '../common/Constants';

interface GridConfig {
  rows: number,
  columns: number,
  imageWidth: string
}

const GRID_GAP: number = 4;
const IMAGE_SET_SIZE_9: number = 9;

@Component
export default struct SampleUnitPicView {
  @StorageLink(Constants.KEY_PREFIX + 'CurrentBreakpoint') curBp: string = BreakpointTypeEnum.SM;
  @Prop imageArray: ResourceStr[] = [];
  private arraySize: number = 0;

  aboutToAppear(): void {
    this.arraySize = Math.min(this.imageArray.length, IMAGE_SET_SIZE_9);
  }

  build() {
    Column() {
      Grid() {
        ForEach(this.imageArray.slice(0, this.arraySize), (item: string | Resource, _: number) => {
          GridItem() {
            Image(item)
              .objectFit(ImageFit.Cover)
              .width(new BreakpointType({
                sm: this.getSmConfig(),
                md: this.getMdConfig(),
                lg: this.getLgConfig()
              }).getValue(this.curBp)
                .imageWidth)
              .aspectRatio(1)
          }
        }, (index: number) => index.toString())
      }
      .maxCount(new BreakpointType({
        sm: this.getSmConfig(),
        md: this.getMdConfig(),
        lg: this.getLgConfig()
      }).getValue(this.curBp)
        .columns)
      .columnsGap(GRID_GAP)
      .rowsGap(GRID_GAP)
      .width(Constants.FULL_SIZE)
    }
  }

  private getSmConfig(): GridConfig {
    let rows: number;
    let columns: number;
    if (this.arraySize <= 1) {
      rows = 1;
      columns = 1;
      return { rows, columns, imageWidth: '60%' };
    } else if (this.arraySize === 2) {
      rows = 1;
      columns = 2;
    } else if (this.arraySize === 3) {
      rows = 1;
      columns = 3;
    } else if (this.arraySize === 4) {
      rows = 2;
      columns = 2;
    } else if (this.arraySize <= 6) {
      rows = 2;
      columns = 3;
    } else {
      rows = 3;
      columns = 3;
    }
    const imageWidth = `calc((100% - ${GRID_GAP * (columns - 1)}vp) / ${columns})`;
    return { rows, columns, imageWidth };
  }

  private getMdConfig(): GridConfig {
    let rows: number;
    let columns: number;
    if (this.arraySize <= 1) {
      rows = 1;
      columns = 1;
      return { rows, columns, imageWidth: '40%' };
    } else if (this.arraySize === 2) {
      rows = 1;
      columns = 2;
    } else if (this.arraySize === 3) {
      rows = 1;
      columns = 3;
    } else if (this.arraySize === 4) {
      rows = 2;
      columns = 2;
      return { rows, columns, imageWidth: '30%' };
    } else if (this.arraySize <= 6) {
      rows = 2;
      columns = 3;
    } else if (this.arraySize <= 8) {
      rows = 2;
      columns = 4;
    } else {
      rows = 2;
      columns = 5;
    }
    const imageWidth = `calc((100% - ${GRID_GAP * (columns - 1)}vp) / ${columns})`;
    return { rows, columns, imageWidth };
  }

  private getLgConfig(): GridConfig {
    let rows: number;
    let columns: number;
    if (this.arraySize <= 1) {
      rows = 1;
      columns = 1;
      return { rows, columns, imageWidth: '40%' };
    } else if (this.arraySize === 2) {
      rows = 1;
      columns = 2;
    } else if (this.arraySize === 3) {
      rows = 1;
      columns = 3;
    } else if (this.arraySize === 4) {
      rows = 1;
      columns = 4;
    } else if (this.arraySize <= 6) {
      rows = 2;
      columns = 3;
    } else if (this.arraySize <= 8) {
      rows = 2;
      columns = 4;
    } else {
      rows = 2;
      columns = 5;
    }
    const imageWidth = `calc((100% - ${GRID_GAP * (columns - 1)}vp) / ${columns})`;
    return { rows, columns, imageWidth };
  }
}