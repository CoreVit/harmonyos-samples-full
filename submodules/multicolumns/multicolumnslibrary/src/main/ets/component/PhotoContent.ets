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

import { Constants } from '../common/Constants';
import { PhotoType } from '../model/dataType';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';

@Component
export struct PhotoContent {
  @State photoList: PhotoType[] = [
    new PhotoType($r('app.string.picture'), 1234, $r('app.media.P1')),
    new PhotoType($r('app.string.video'), 12, $r('app.media.P2')),
    new PhotoType($r('app.string.collect'), 7, $r('app.media.P3')),
    new PhotoType($r('app.string.newAlbum'), 11, $r('app.media.P4')),
    new PhotoType($r('app.string.avatar'), 223, $r('app.media.P5')),
    new PhotoType($r('app.string.address'), 125, $r('app.media.P6')),
    new PhotoType($r('app.string.category'), 234, $r('app.media.P7')),
    new PhotoType($r('app.string.pictureType'), 22, $r('app.media.P8')),
  ]
  @State columnsTemplate: string = '1fr 1fr 1fr';
  @Link @Watch('onStateChange') sideBarStatus: boolean;
  @StorageProp(Constants.KEY_BREAKPOINT) currentBreakPoint: string = BreakpointTypeEnum.SM;
  @StorageProp(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;

  aboutToAppear() {
    if (this.sideBarStatus && this.currentBreakPoint === BreakpointTypeEnum.MD) {
      this.columnsTemplate = '1fr 1fr 1fr';
    } else if (this.sideBarStatus &&
      (this.currentBreakPoint === BreakpointTypeEnum.LG || this.currentBreakPoint === BreakpointTypeEnum.XL)) {
      this.columnsTemplate = '1fr 1fr 1fr 1fr 1fr 1fr';
    } else if (!this.sideBarStatus &&
      (this.currentBreakPoint === BreakpointTypeEnum.LG || this.currentBreakPoint === BreakpointTypeEnum.XL)) {
      this.columnsTemplate = '1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr';
    } else if (!this.sideBarStatus && this.currentBreakPoint === BreakpointTypeEnum.MD) {
      this.columnsTemplate = '1fr 1fr 1fr 1fr';
    } else if (this.sideBarStatus && this.currentBreakPoint === BreakpointTypeEnum.SM) {
      this.columnsTemplate = '1fr 1fr 1fr 1fr';
    } else if (!this.sideBarStatus && this.currentBreakPoint === BreakpointTypeEnum.SM) {
      this.columnsTemplate = '1fr 1fr 1fr 1fr';
    }
  }

  onStateChange() {
    this.getUIContext().animateTo({ duration: 300 }, () => {
      if (this.sideBarStatus && this.currentBreakPoint === BreakpointTypeEnum.MD) {
        this.columnsTemplate = '1fr 1fr 1fr';
      } else if (this.sideBarStatus &&
        (this.currentBreakPoint === BreakpointTypeEnum.LG || this.currentBreakPoint === BreakpointTypeEnum.XL)) {
        this.columnsTemplate = '1fr 1fr 1fr 1fr 1fr 1fr';
      } else if (!this.sideBarStatus &&
        (this.currentBreakPoint === BreakpointTypeEnum.LG || this.currentBreakPoint === BreakpointTypeEnum.XL)) {
        this.columnsTemplate = '1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr';
      } else if (!this.sideBarStatus && this.currentBreakPoint === BreakpointTypeEnum.MD) {
        this.columnsTemplate = '1fr 1fr 1fr 1fr';
      } else if (this.sideBarStatus && this.currentBreakPoint === BreakpointTypeEnum.SM) {
        this.columnsTemplate = '1fr 1fr 1fr 1fr';
      } else if (!this.sideBarStatus && this.currentBreakPoint === BreakpointTypeEnum.SM) {
        this.columnsTemplate = '1fr 1fr 1fr 1fr';
      }
    })
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.album'))
          .fontSize($r('sys.float.Title_S'))
          .fontWeight(FontWeight.Medium)
          .margin({ left: this.sideBarStatus ? 0 : Constants.ALBUMS_PADDING_LEFT + Constants.BACK_SIZE })
        Row() {
          SymbolGlyph($r('sys.symbol.plus'))
            .fontSize($r('sys.float.Title_M'))
            .fontColor([$r('sys.color.font_primary')])
            .margin({ right: $r('sys.float.padding_level4') })
          SymbolGlyph($r('sys.symbol.dot_grid_2x2'))
            .fontSize($r('sys.float.Title_M'))
            .fontColor([$r('sys.color.font_primary')])
        }
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ top: this.statusBarHeight + Constants.PADDING_CUSTOM })
      .height($r('app.float.item_height'))
      .width('100%')

      Grid() {
        ForEach(this.photoList, (item: PhotoType) => {
          GridItem() {
            Column() {
              Image(item.src).width('100%').aspectRatio(1).borderRadius($r('sys.float.corner_radius_level6'))
              Column() {
                Text(item.name)
                  .margin({ top: $r('sys.float.padding_level4') })
                  .fontSize($r('sys.float.Body_M'))
                  .fontWeight(FontWeight.Regular)
                Text(item.count.toString()).fontSize($r('sys.float.Body_S'))
                  .fontWeight(FontWeight.Regular)
              }
              .width('100%')
              .alignItems(HorizontalAlign.Start)
              .padding({ left: $r('sys.float.padding_level4'), right: $r('sys.float.padding_level4') })
            }
          }
        }, (item: PhotoType, index: number) => {
          return index + JSON.stringify(item);
        })
      }
      .height('85%')
      .scrollBar(BarState.Off)
      .columnsTemplate(this.columnsTemplate)
      .columnsGap($r('app.float.albums_image_column_gap'))
      .rowsGap($r('app.float.albums_image_row_gap'))
      .margin({ top: $r('sys.float.padding_level12') })
    }
    .padding({
      left: new BreakpointType({
        sm: $r('sys.float.padding_level8'),
        md: $r('sys.float.padding_level12'),
        lg: $r('sys.float.padding_level16')
      }).getValue(this.currentBreakPoint),
      right: new BreakpointType({
        sm: $r('sys.float.padding_level8'),
        md: $r('sys.float.padding_level12'),
        lg: $r('sys.float.padding_level16')
      }).getValue(this.currentBreakPoint)
    })
  }
}