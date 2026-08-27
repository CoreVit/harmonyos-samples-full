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
export struct PhotoSideBar {
  @State photoList: PhotoType[] = [
    new PhotoType($r('app.string.picture'), 1234),
    new PhotoType($r('app.string.video'), 12),
    new PhotoType($r('app.string.collect'), 7),
    new PhotoType($r('app.string.newAlbum'), 11),
    new PhotoType($r('app.string.avatar'), 223),
    new PhotoType($r('app.string.address'), 125),
    new PhotoType($r('app.string.category'), 234),
    new PhotoType($r('app.string.pictureType'), 22),
    new PhotoType($r('app.string.hidden'), 1),
  ];
  @StorageProp(Constants.KEY_BREAKPOINT) curBp: string = BreakpointTypeEnum.SM;
  @StorageProp(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;

  build() {
    Column() {
      Search({ placeholder: $r('app.string.placeholderText') })
        .backgroundColor($r('sys.color.background_secondary'))
        .focusable(false)
        .width('100%')
        .margin({ top: $r('sys.float.padding_level16') })

      List() {
        ListItem() {
          Row() {
            SymbolGlyph($r('sys.symbol.picture_2'))
              .fontSize($r('sys.float.Title_M'))
              .fontColor([$r('sys.color.icon_primary')])
              .aspectRatio(1)
            Text($r('app.string.photo'))
              .fontColor($r('sys.color.font_primary'))
              .fontSize($r('sys.float.Body_L'))
              .fontWeight(FontWeight.Medium)
              .opacity(0.9)
              .height($r('app.float.item_height_48'))
              .margin({ left: $r('sys.float.padding_level4') })
          }
          .width('100%')
          .padding({ left: $r('sys.float.padding_level4') })
        }

        ListItem() {
          Row() {
            SymbolGlyph($r('sys.symbol.picture_2_fill'))
              .fontSize($r('sys.float.Title_M'))
              .fontColor([$r('sys.color.brand')])
              .aspectRatio(1)
            Text($r('app.string.album'))
              .fontSize($r('sys.float.Body_L'))
              .fontWeight(FontWeight.Medium)
              .opacity(0.9)
              .height($r('app.float.item_height_48'))
              .margin({ left: $r('sys.float.padding_level4') })
              .fontColor($r('sys.color.brand'))
            Blank()
            SymbolGlyph($r('sys.symbol.checkmark'))
              .fontColor([$r('sys.color.brand')])
              .fontSize($r('sys.float.Title_M'))
          }.padding({ left: $r('sys.float.padding_level4'), right: $r('sys.float.padding_level4') }).width('100%')
          .backgroundColor($r('app.color.item_selected_color'))
          .borderRadius($r('sys.float.corner_radius_level5'))
        }

        ForEach(this.photoList, (item: PhotoType, index: number | undefined) => {
          ListItem() {
            Row() {
              Text(item.name)
                .fontColor($r('sys.color.font_secondary'))
                .fontSize($r('sys.float.Body_M'))
                .fontWeight(FontWeight.Medium)
                .height($r('app.float.item_height_48'))
              Blank()
              if (index === this.photoList.length - 1) {
                SymbolGlyph($r('sys.symbol.lock'))
                  .fontSize($r('sys.float.Subtitle_L'))
                  .fontColor([$r('sys.color.font_secondary')])
              } else {
                Text(item.count.toString())
                  .fontSize($r('sys.float.Body_M'))
                  .fontWeight(FontWeight.Regular)
                  .fontColor($r('sys.color.font_secondary'))
              }
            }
            .padding({ left: $r('sys.float.corner_radius_level7'), right: $r('sys.float.corner_radius_level7') })
            .width('100%')
          }
        }, (item: PhotoType, index: number) => {
          return index + JSON.stringify(item);
        })
      }
      .width('100%').height('100%')
    }
    .width('100%').height('100%')
    .padding({
      top: Constants.BACK_SIZE,
      left: new BreakpointType({
        sm: $r('sys.float.padding_level8'),
        md: $r('sys.float.padding_level12'),
        lg: $r('sys.float.padding_level16')
      }).getValue(this.curBp),
      right: new BreakpointType({
        sm: $r('sys.float.padding_level8'),
        md: $r('sys.float.padding_level12'),
        lg: $r('sys.float.padding_level16')
      }).getValue(this.curBp),
    })
  }
}