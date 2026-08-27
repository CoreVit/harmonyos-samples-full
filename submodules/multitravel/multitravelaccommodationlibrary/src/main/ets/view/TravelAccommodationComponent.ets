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

import { Constants } from '../commons/constants/Constants';
import { LowPriceView } from '../component/LowPriceView';
import { BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { HotelDetailsPage } from './HotelDetailsPage';
import { SearchTicketPage } from './SearchTicketPage';

class DirectoryItem {
  public title: Resource | undefined = undefined;
  public uri: string = '';
}

@Component
export struct TravelAccommodationComponent {
  @StorageLink(Constants.KEY_BREAKPOINT) breakPoint: BreakpointTypeEnum = BreakpointTypeEnum.SM;
  @StorageProp(Constants.KEY_NAV_INDICATOR_HEIGHT) navIndicatorHeight: number = 0;
  @StorageProp(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @Provide(Constants.KEY_PATH_STACK) pageInfos: NavPathStack = new NavPathStack();
  private directory: DirectoryItem[] = [
    {
      title: $r('app.string.HotelDetailPage'),
      uri: Constants.HOTEL_DETAIL_PAGE_URL,
    },
    {
      title: $r('app.string.SearchTicketsPage'),
      uri: Constants.SEARCH_TICKET_PAGE_URL,
    },
  ];

  @Builder
  PageMap(name: string) {
    if (name === Constants.HOTEL_DETAIL_PAGE_URL) {
      HotelDetailsPage()
    } else if (name === Constants.SEARCH_TICKET_PAGE_URL) {
      SearchTicketPage()
    } else if (name === Constants.LOW_PRICE_CALENDAR_URL) {
      LowPriceView()
    }
  }

  build() {
    Navigation(this.pageInfos) {
      Column() {
        Text($r('app.string.project_name'))
          .fontWeight(FontWeight.Bold)
          .fontColor($r('sys.color.font_primary'))
          .fontSize($r('sys.float.Title_L'))
          .alignSelf(ItemAlign.Start)
          .margin({
            left: this.breakPoint === BreakpointTypeEnum.SM ? $r('sys.float.padding_level0') :
              this.breakPoint === BreakpointTypeEnum.MD ? $r('sys.float.padding_level4') :
                $r('sys.float.padding_level8')
          })
        Column() {
          ForEach(this.directory, (item: DirectoryItem, index) => {
            Button(item.title)
              .fontSize($r('sys.float.Subtitle_M'))
              .fontColor($r('sys.color.font_on_primary'))
              .width(this.breakPoint === BreakpointTypeEnum.SM ? '100%' : $r('app.float.index_button_width_lg'))
              .height($r('app.float.button_height'))
              .margin({ top: $r('sys.float.padding_level6') })
              .backgroundColor($r('sys.color.comp_background_emphasize'))
              .onClick(() => {
                this.pageInfos.pushPath(new NavPathInfo(item.uri, []));
              })
          }, (item: DirectoryItem) => JSON.stringify(item))
        }
        .width(Constants.FULL_WIDTH_PERCENT)
      }
      .backgroundColor($r('sys.color.background_primary'))
      .width(Constants.FULL_WIDTH_PERCENT)
      .height(Constants.FULL_WIDTH_PERCENT)
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        left: $r('sys.float.padding_level8'),
        right: $r('sys.float.padding_level8'),
        top: Constants.PADDING_TOP_INDEX + this.statusBarHeight,
        bottom: Constants.PADDING_BOTTOM_INDEX + this.navIndicatorHeight
      })
    }
    .mode(NavigationMode.Stack)
    .hideTitleBar(true)
    .navDestination(this.PageMap)
  }
}