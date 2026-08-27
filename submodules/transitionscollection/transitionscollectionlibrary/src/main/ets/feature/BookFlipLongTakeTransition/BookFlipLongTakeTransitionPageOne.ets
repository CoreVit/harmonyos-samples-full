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


import { BusinessError } from '@kit.BasicServicesKit';
import CommonConstants from '../../common/CommonConstants';
import { BreakpointTypeEnum } from '../../utils/windowutils/BreakpointSystem';
import { ComponentAttrUtils, RectInfoInPx } from '../../utils/commonutils/ComponentAttrUtils';
import { CustomTransition } from '../../utils/customtransition/CustomNavigationUtils';
import Logger from '../../utils/Logger';

const TAG: string = 'BookFlipLongTakeTransition';

@Builder
export function BookFlipLongTakeTransitionPageOneBuilder() {
  BookFlipLongTakeTransitionPageOne()
}

interface BookItem {
  id: string;
  timestamp: number;
  coverImageUrl: string;
}

@Component
export struct BookFlipLongTakeTransitionPageOne {
  @State dataSource: BookItem[] = new Array(3);
  @State columnWidth: Length = 0;
  @State columnType: string = '';
  @StorageProp(CommonConstants.KEY_PREFIX_BREAKPOINT) private currentBreakpoint: string = BreakpointTypeEnum.SM;
  private pageInfos: NavPathStack = new NavPathStack();
  private pageId: string = '';
  private recentData: BookItem[] = new Array(3);

  aboutToAppear(): void {
    this.updateColumnData();
    for (let i = 2; i >= 0; i--) {
      this.dataSource[i] = {
        id: `book_${i}`,
        timestamp: Number(new Date()),
        coverImageUrl: `app.media.book_cover_${i}`
      }
    }

    for (let i = 0; i < 4; i++) {
      this.recentData[i] = {
        id: `recent_book_${i}`,
        coverImageUrl: `app.media.book_cover_${i}`,
        timestamp: Number(new Date())
      }
    }
  }

  private updateColumnData(): void {
    let currentBreakpoint: string | undefined = AppStorage.get(CommonConstants.KEY_PREFIX_BREAKPOINT);
    if (currentBreakpoint === 'sm') {
      this.columnType = '1fr 1fr 1fr';
      this.columnWidth = '33.3%';
    } else if (currentBreakpoint === 'md') {
      this.columnType = '1fr 1fr 1fr 1fr';
      this.columnWidth = '25%';
    } else {
      this.columnType = '1fr 1fr 1fr 1fr 1fr';
      this.columnWidth = '20%';
    }
  }

  private onColumnClicked(bookId: string, bookCoverUrl: string, toBookId?: string, prePageCallback?: () => void): void {
    try {
      CustomTransition.getInstance().unRegisterNavParam(this.pageId);
      const fromCardItemInfo: RectInfoInPx =
        ComponentAttrUtils.getRectInfoById(this.getUIContext(), bookId);
      let param: Record<string, Object> = {};
      param['fromCardItemInfo'] = fromCardItemInfo;
      param['bookCoverUrl'] = bookCoverUrl;
      if (toBookId) {
        const toCardItemInfo: RectInfoInPx =
          ComponentAttrUtils.getRectInfoById(this.getUIContext(), toBookId);
        param['toCardItemInfo'] = toCardItemInfo;
      }
      if (prePageCallback) {
        param['prePageCallback'] = prePageCallback;
      }
      this.pageInfos.pushPath({ name: 'BookFlipLongTakeTransitionPageTwo', param: param });
    } catch (error) {
      Logger.error(TAG, `Failed to click column. Cause: ${(error as BusinessError).message}`);
    }
  }

  build() {
    NavDestination() {
      Row() {
        Button({ type: ButtonType.Circle }) {
          SymbolGlyph($r('sys.symbol.chevron_backward'))
            .fontColor([$r('sys.color.icon_primary')])
            .fontSize($r('sys.float.Title_M'))
        }
        .height(40)
        .aspectRatio(1)
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .onClick(() => this.pageInfos.pop())

        Text($r('app.string.book_title'))
          .margin({ left: $r('sys.float.padding_level4') })
          .font({ size: 20, weight: 700 })
          .fontColor($r('sys.color.font_primary'))
      }
      .padding({
        top: 40,
        left: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                                 $r('sys.float.padding_level12') :
                                                                                 $r('sys.float.padding_level16'),
        right: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                                  $r('sys.float.padding_level12') :
                                                                                  $r('sys.float.padding_level16')
      })
      .width('100%')
      .height(96)
      .zIndex(2)
      .backgroundBlurStyle(BlurStyle.COMPONENT_THICK)

      Scroll() {
        Column({ space: 12 }) {
          // A mirror returns to the first position.
          Grid() {
            ForEach(this.dataSource, (item: BookItem, index: number) => {
              GridItem() {
                Image($r(item.coverImageUrl))
                  .id(item.id)
                  .width('100%')
                  .onClick(() => {
                    this.onColumnClicked(item.id, item.coverImageUrl, this.dataSource[0].id, () => {
                      this.dataSource.sort((a, b) => b.timestamp - a.timestamp);
                    })
                    this.dataSource[index].timestamp = Number(new Date());
                  })
              }
              .width(this.columnWidth)
            }, (item: BookItem) => JSON.stringify(item))
          }
          .padding({
            left: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                                     $r('sys.float.padding_level12') :
                                                                                     $r('sys.float.padding_level16'),
            right: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                                      $r('sys.float.padding_level12') :
                                                                                      $r('sys.float.padding_level16'),
            top: 12
          })
          .columnsTemplate(this.columnType)
          .columnsGap(10)
          .rowsGap(10)

          // A mirror is returned to its original position.
          Column({ space: 12 }) {
            Text($r('app.string.recent_reading'))
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor(Color.Gray)
              .padding({ top: 10 })

            Grid() {
              ForEach(this.recentData, (item: BookItem) => {
                GridItem() {
                  Image($r(item.coverImageUrl))
                    .id(item.id)
                    .onClick(() => {
                      this.onColumnClicked(item.id, item.coverImageUrl);
                    })
                }.width(this.columnWidth)
              }, (item: BookItem) => JSON.stringify(item))
            }
            .columnsTemplate(this.columnType)
            .columnsGap(10)
            .rowsGap(10)
          }
          .padding({
            left: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                                     $r('sys.float.padding_level12') :
                                                                                     $r('sys.float.padding_level16'),
            right: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                                      $r('sys.float.padding_level12') :
                                                                                      $r('sys.float.padding_level16'),
          })
          .alignItems(HorizontalAlign.Start)
        }
      }
    }
    .hideTitleBar(true)
    .backgroundColor(CommonConstants.DEFAULT_BG_COLOR)
    .onReady((context: NavDestinationContext) => {
      this.pageInfos = context.pathStack;
      if (context.navDestinationId) {
        this.pageId = context.navDestinationId;
      }
    })
    .onBackPressed(() => {
      this.pageInfos.pop();
      return true;
    })
  }
}