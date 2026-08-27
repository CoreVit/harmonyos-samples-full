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

import { common } from '@kit.AbilityKit';
import { display } from '@kit.ArkUI';
import type { BusinessError } from '@kit.BasicServicesKit';
import { CommonConstants } from '../constants/CommonConstants';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';
import Logger from '../utils/Logger';
import { WindowUtil } from '../utils/WindowUtil';
import { DataSource, PhotoData } from '../viewmodel/DataSource';

const TAG: string = '[Index]'

@Component
export struct MultipleImageComponent {
  @State progressData: PhotoData[] = [];
  @State data: DataSource = new DataSource([]);
  @State currentIndex: number = CommonConstants.INITIALLY_CURRENT_INDEX;
  @State slideIndex: number = CommonConstants.SLIDE_INDEX;
  @State duration: number = CommonConstants.DURATION;
  @State slide: boolean = false;
  @State foldStatus: number = 2;
  @State isFoldable: boolean = false;
  @StorageProp(CommonConstants.KEY_PREFIX_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  @StorageProp(CommonConstants.KEY_PREFIX_BREAKPOINT) curBp: string = BreakpointTypeEnum.SM;

  aboutToAppear(): void {
    try {
      if (canIUse('SystemCapability.Window.SessionManager')) {
        this.isFoldable = display.isFoldable();
        let foldStatus: display.FoldStatus = display.getFoldStatus();
        if (this.isFoldable) {
          this.foldStatus = foldStatus;
          let callback: Callback<number> = () => {
            let data: display.FoldStatus = display.getFoldStatus();
            this.foldStatus = data;
          }
          display.on('change', callback);
        }
      }
      let list: PhotoData[] = [];
      for (let i = 1; i <= 4; i++) {
        let newPhotoData = new PhotoData();
        newPhotoData.id = i;
        list.push(newPhotoData);
      }
      this.progressData = list;
      this.data = new DataSource(list);
    } catch (error) {
      Logger.error(TAG, '%{public}s',
        `Failed to set window. code: ${error.code}, message: ${error.message}`);
    }
  }

  aboutToDisappear(): void {
    try {
      display?.off('change');
      WindowUtil.unRegisterBreakPoint();
    } catch (error) {
      Logger.error(TAG, `Failed to unregister the callback for display changes. Cause: ${error.message}`);
    }
  }

  @Builder
  progressComponent() {
    Row({ space: CommonConstants.ROW_SPACE }) {
      ForEach(this.progressData, (_: PhotoData, index: number) => {
        Stack({ alignContent: Alignment.Start }) {
          Row()
            .zIndex(CommonConstants.Z_INDEX_0)
            .width(CommonConstants.FULL_PERCENT)
            .height($r('app.float.row_height'))
            .borderRadius($r('app.float.row_borderRadius'))
            .backgroundColor(Color.Grey)
          Row()
            .zIndex(CommonConstants.Z_INDEX_1)
            .width(this.currentIndex >= index && !this.slide ? CommonConstants.FULL_PERCENT :
            CommonConstants.NONE_PERCENT)
            .height($r('app.float.row_height'))
            .borderRadius($r('app.float.row_borderRadius'))
            .backgroundColor(Color.White)
            .animation(!this.slide ? {
              duration: this.duration - 400,
              curve: Curve.Linear,
              iterations: 1,
              playMode: PlayMode.Normal,
              onFinish: () => {
                if (this.currentIndex === this.progressData.length - 1) {
                  this.duration = 400;
                  this.currentIndex = -1;
                }
              }
            } : {
              duration: 0
            })
          Row()
            .zIndex(CommonConstants.Z_INDEX_2)
            .width(this.currentIndex >= index && this.slide ? CommonConstants.FULL_PERCENT :
            CommonConstants.NONE_PERCENT)
            .height($r('app.float.row_height'))
            .borderRadius($r('app.float.row_borderRadius'))
            .backgroundColor(Color.White)
        }
        .layoutWeight(CommonConstants.LAYOUT_WEIGHT)
      }, (index: number) => JSON.stringify(index))
    }
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.PROGRESS_WRAP_HEIGHT)
  }

  @Builder
  image(item: PhotoData) {
    Image($r(`app.media.` + item.id))
      .width(CommonConstants.FULL_PERCENT)
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.BottomStart }) {
        Scroll() {
          Swiper() {
            LazyForEach(this.data, (item: PhotoData) => {
              this.image(item)
            }, (item: string) => item)
          }
          .cachedCount(CommonConstants.SWIPER_CACHED_COUNT)
          .index($$this.slideIndex)
          .autoPlay(!this.slide ? true : false)
          .interval(CommonConstants.INTERVAL)
          .loop(!this.slide ? true : false)
          .indicatorInteractive(false)
          .duration(CommonConstants.IMAGE_DURATION)
          .itemSpace(CommonConstants.ITEM_SPACE)
          .indicator(false)
          .displayArrow(false)
          .curve(Curve.Linear)
          .onChange((index: number) => {
            this.duration = 3000;
            this.currentIndex = index;
          })
          .onAppear(() => {
            this.currentIndex = 0;
          })
          .onGestureSwipe((index: number, extraInfo: SwiperAnimationEvent) => {
            if (extraInfo.currentOffset > 0 && index === 0 && !this.slide) {
              let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
              context.terminateSelf().catch((error: BusinessError)=>{
                Logger.error(TAG, `Context terminateSelf fail, error code: ${error.code}, message: ${error.message}`);
              });
            }
            this.slide = true;
            if (extraInfo.currentOffset > 0 && this.currentIndex > 0) {
              this.currentIndex = index - 1;
            }
          })
        }
        .scrollBar(BarState.Off)
        .width(CommonConstants.FULL_PERCENT)
        .height(CommonConstants.FULL_PERCENT)

        Column() {
          Column({ space: CommonConstants.COLUMN_SPACE }) {
            Image($r('app.media.avatar'))
              .width($r('app.float.image_width'))
              .height($r('app.float.image_height'))
              .borderRadius($r('app.float.image_borderRadius'))
            Column({ space: CommonConstants.COLUMN_SPACE_INSIDE }) {
              SymbolGlyph($r('sys.symbol.heart_fill'))
                .fontSize(29)
                .fontColor([$r('sys.color.multi_color_08')])
              Text($r('app.string.collection'))
                .fontSize($r('app.float.text_font_size'))
                .fontColor(Color.White)
            }
            .width($r('app.float.image_width'))
            .height($r('app.float.image_height'))

            Column({ space: CommonConstants.COLUMN_SPACE_INSIDE }) {
              SymbolGlyph($r('sys.symbol.ellipsis_bubble'))
                .fontSize(29)
                .fontColor([$r('sys.color.font_on_primary')])
              Text($r('app.string.Comments'))
                .fontSize($r('app.float.text_font_size'))
                .fontColor(Color.White)
            }
            .width($r('app.float.image_width'))
            .height($r('app.float.image_height'))

            Column({ space: CommonConstants.COLUMN_SPACE_INSIDE }) {
              SymbolGlyph($r('sys.symbol.share'))
                .fontSize(29)
                .fontColor([$r('sys.color.font_on_primary')])
              Text($r('app.string.share'))
                .fontSize($r('app.float.text_font_size'))
                .fontColor(Color.White)
            }
            .width($r('app.float.image_width'))
            .height($r('app.float.image_height'))
          }
          .padding({
            right: new BreakpointType($r('sys.float.padding_level8'), $r('sys.float.padding_level12'),
              $r('sys.float.padding_level16')).getValue(this.curBp)
          })
          .margin({ top: $r('app.float.column_image_margin_top') })
        }
        .width(CommonConstants.FULL_PERCENT)
        .height(CommonConstants.FULL_PERCENT)
        .alignItems(HorizontalAlign.End)
        .justifyContent(FlexAlign.Center)
        .hitTestBehavior(HitTestMode.Transparent)

        Column() {
          Column({ space: CommonConstants.COLUMN_SPACE_INSIDE }) {
            Row() {
              Text($r('app.string.cute_pet'))
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
              Text($r('app.string.dots'))
                .fontColor(Color.White)
                .margin({ left: 6, right: 6 })
              Text($r('app.string.date'))
                .fontColor(Color.White)
            }
            .width(CommonConstants.FULL_PERCENT)
            .justifyContent(FlexAlign.Start)
            .margin({ top: $r('app.float.row_margin_top') })

            Row() {
              Text($r('app.string.pets'))
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
              Text($r('app.string.dog'))
                .fontColor(Color.White)
                .margin({ left: $r('app.float.text_margin_left'), right: $r('app.float.text_margin_right') })
              Text($r('app.string.spoiled'))
                .fontColor(Color.White)
            }
            .width(CommonConstants.FULL_PERCENT)
            .justifyContent(FlexAlign.Start)

            this.progressComponent();
          }

          Row() {
            TextInput({ placeholder: $r('app.string.placeholder') })
              .width(new BreakpointType(CommonConstants.FULL_PERCENT, '308vp', '400vp').getValue(this.curBp))
              .backgroundColor($r('app.color.textInput_backgroundColor'))
              .fontColor(Color.White)
              .placeholderColor(Color.White)
              .focusable(false)
          }
          .padding({
            bottom: new BreakpointType($r('sys.float.padding_level8'), $r('sys.float.padding_level16'),
              $r('sys.float.padding_level16')).getValue(this.curBp)
          })
          .justifyContent(FlexAlign.End)
          .width(CommonConstants.FULL_PERCENT)
        }
        .width(CommonConstants.FULL_PERCENT)
        .height($r('app.float.description_column_height'))
        .padding({
          left: new BreakpointType($r('sys.float.padding_level8'), $r('sys.float.padding_level12'),
            $r('sys.float.padding_level16')).getValue(this.curBp),
          right: new BreakpointType($r('sys.float.padding_level8'), $r('sys.float.padding_level12'),
            $r('sys.float.padding_level16')).getValue(this.curBp),
          bottom: this.getUIContext().px2vp(this.navigatorBarHeight)
        })
        .hitTestBehavior(HitTestMode.Transparent)
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .layoutWeight(1)
    }
    .backgroundColor(Color.Black)
    .height(CommonConstants.FULL_PERCENT)
    .width(CommonConstants.FULL_PERCENT)
  }
}