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
import { WaterFlowDataSource } from '../model/SectionsWaterFlowDataSource';

@Reusable
struct ReusableFlowItem {
  @State item: number = 0;
  @StorageLink(CommonConstants.AS_KEY_ITEM_HEIGHT_ARRAY) itemHeightArray: number[] = [];

  aboutToReuse(params: Record<string, number>) {
    this.item = params.item;
  }

  private getImagePath(): Resource {
    const safeIndex = Math.abs(Math.floor(this.item || 0)) % 4;
    const imageName = `${safeIndex}.jpg`;
    const safePath = `sections/${imageName}`;
    if (safePath.indexOf('..') >= 0 || safePath.indexOf('\\') >= 0 || safePath.indexOf('/') !== safePath.lastIndexOf('/')) {
      return $rawfile('sections/0.jpg');
    }
    return $rawfile(safePath);
  }

  build() {
    Row() {
      Stack() {
        Image(this.getImagePath())
          .objectFit(ImageFit.Cover)
          .width('100%')
          .height('100%')
          .borderRadius($r('app.float.sections_item_radius'))
          .alignRules({
            top: { anchor: '__container__', align: VerticalAlign.Top },
            bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
            left: { anchor: '__container__', align: HorizontalAlign.Start },
            right: { anchor: '__container__', align: HorizontalAlign.End }
          })
          .id('image')

        Text('NO. ' + (this.item + 1))
          .fontSize($r('app.float.sections_item_text_size'))
          .fontColor(Color.White)
          .alignRules({
            bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
            left: { anchor: '__container__', align: HorizontalAlign.Start }
          })
          .margin({
            left: $r('app.float.sections_item_text_margin_left'),
            bottom: $r('app.float.sections_item_text_margin_bottom')
          })
          .id('text')
      }
    }
    .width('100%')
    .height('100%')
    .borderRadius($r('app.float.sections_item_radius'))
    .backgroundColor(Color.Gray)
  }
}

@Preview
@Component
export struct SectionsPage {
  @State minSize: number = 80;
  @State maxSize: number = 180;
  scroller: Scroller = new Scroller();
  dataSource: WaterFlowDataSource = new WaterFlowDataSource();
  dataCount: number = this.dataSource.totalCount();
  @StorageLink(CommonConstants.AS_KEY_ITEM_HEIGHT_ARRAY) itemHeightArray: number[] = [];
  @StorageProp(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  @State sections: WaterFlowSections = new WaterFlowSections();
  @StorageProp(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  sectionMargin: Margin = {
    top: 8,
    left: 0,
    bottom: 0,
    right: 0
  };
  oneColumnSection: SectionOptions = {
    itemsCount: 3,
    crossCount: new BreakpointType({ sm: 1, md: 1, lg: 3 }).getValue(this.curBp),
    columnsGap: 5,
    rowsGap: 10,
    margin: this.sectionMargin,
    onGetItemMainSizeByIndex: (_: number) => {
      return 170;
    }
  };
  twoColumnSection: SectionOptions = {
    itemsCount: 2,
    crossCount: new BreakpointType({ sm: 2, md: 2, lg: 2 }).getValue(this.curBp),
    margin: this.sectionMargin,
    onGetItemMainSizeByIndex: (_: number) => {
      return 100;
    }
  };
  lastSection: SectionOptions = {
    itemsCount: 20,
    crossCount: new BreakpointType({ sm: 2, md: 4, lg: 5 }).getValue(this.curBp),
    margin: this.sectionMargin,
    onGetItemMainSizeByIndex: (index: number) => {
      if (index % 100 >= 0 && index % 100 < this.itemHeightArray.length) {
        return this.itemHeightArray[index % 100];
      }
      return 0;
    }
  };

  getSize() {
    let ret = Math.floor(Math.random() * this.maxSize);
    return (ret > this.minSize ? ret : this.minSize);
  }

  setItemSizeArray() {
    for (let i = 0; i < 100; i++) {
      this.itemHeightArray.push(this.getSize());
    }
  }

  aboutToAppear() {
    this.setItemSizeArray();
    let sectionOptions: SectionOptions[] = [];
    let count = 0;
    let oneOrTwo = 0;
    while (count < this.dataCount) {
      if (this.dataCount - count < 96) {
        this.lastSection.itemsCount = this.dataCount - count;
        sectionOptions.push(this.lastSection);
        break;
      }
      if (oneOrTwo++ % 2 === 0) {
        sectionOptions.push(this.oneColumnSection);
        count += this.oneColumnSection.itemsCount;
      } else {
        sectionOptions.push(this.twoColumnSection);
        count += this.twoColumnSection.itemsCount;
      }
    }
    this.sections.splice(0, 0, sectionOptions);
  }

  build() {
    Column({ space: 0 }) {
      ForEach(new BreakpointType({ sm: [0, 1], md: [0, 1, 2], lg: [0, 1, 2, 3, 4] }).getValue(this.curBp),
        (_: number) => {
          FlowItem()
            .width('100%')
        }, (index: number) => JSON.stringify(index))
      WaterFlow({ scroller: this.scroller, sections: this.sections }) {
        LazyForEach(this.dataSource, (item: number) => {
          FlowItem() {
            ReusableFlowItem({ item: item })
          }
          .width(CommonConstants.FULL_WIDTH)
          .borderRadius($r('app.float.sections_item_radius'))
          .backgroundColor(Color.Gray)
        }, (item: string) => item)
      }
      .columnsTemplate(new BreakpointType({
        sm: '1fr 1fr',
        md: '1fr 1fr 1fr',
        lg: '1fr 1fr 1fr 1fr 1fr'
      }).getValue(this.curBp))
      .columnsGap($r('app.float.sections_margin'))
      .rowsGap($r('app.float.sections_margin'))
      .width(CommonConstants.FULL_WIDTH)
      .height(CommonConstants.FULL_HEIGHT)
      .layoutWeight(1)
      .onScrollIndex((_: number, last: number) => {
        if (last + 20 >= this.dataSource.totalCount()) {
          for (let i = 0; i < this.dataCount; i++) {
            this.dataSource.addLastItem();
          }
          this.lastSection.itemsCount += 100;
          this.sections.update(-1, this.lastSection);
        }
      })
    }
    .padding({
      left: new BreakpointType({
        sm: $r('sys.float.padding_level8'),
        md: $r('sys.float.padding_level12'),
        lg: $r('sys.float.padding_level16')
      }
      ).getValue(this.curBp),
      right: new BreakpointType({
        sm: $r('sys.float.padding_level8'),
        md: $r('sys.float.padding_level12'),
        lg: $r('sys.float.padding_level16')
      }).getValue(this.curBp)
    })
  }
}