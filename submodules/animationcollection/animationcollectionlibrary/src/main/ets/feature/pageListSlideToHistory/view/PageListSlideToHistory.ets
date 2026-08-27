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

import { util } from '@kit.ArkTS';
import { BasicDataSource, FriendMoment } from '../model/BasicDataSource';
import { OneMoment } from './OneMoment';
import { Constants } from '../common/Constants';
import CommonConstants from '../../../common/CommonConstants';
import Logger from '../../../utils/Logger';


@Component
export struct PageListSlideToHistory {
  @State cachedCountNumber: number = 3;
  @State firstIndex: number = 0;
  @StorageProp(CommonConstants.KEY_PREFIX_BREAKPOINT) currentBreakpoint: string = '';
  private pageInfos: NavPathStack = new NavPathStack();
  public listScroller: ListScroller = new ListScroller();
  public historyOffset: number = 0;
  public isHistoricalRecord: boolean = false;
  public isJump: boolean = true;
  public readonly DEFAULT_OFFSET: number = 1000;
  public readonly ANIMATION_DURATION: number = 500;
  public readonly SWITCH_BUTTON: number = 3;


  aboutToAppear(): void {
    if (!this.getUIContext().getHostContext()) {
      return;
    }
    getFriendMomentFromRawfile(this.getUIContext().getHostContext()!);
  }

  @Builder
  moments(moment: FriendMoment, index: number) {
    ListItem() {
      Column() {
        if (index === Constants.COMM_INIT && this.isHistoricalRecord && this.isJump) {
          Text($r('app.string.jump_to_history'))
            .fontColor($r('app.color.ohos_id_color_emphasize'))
            .fontSize($r('app.integer.jump_font_size'))
            .margin({ top: $r('app.integer.jump_margin'), bottom: $r('app.integer.jump_margin') })
            .onClick(() => {
              if (this.firstIndex < this.SWITCH_BUTTON) {
                this.listScroller.scrollTo({
                  xOffset: 0,
                  yOffset: this.historyOffset === Constants.COMM_INIT ? this.DEFAULT_OFFSET :
                  this.historyOffset,
                  animation: { duration: this.ANIMATION_DURATION, curve: Curve.LinearOutSlowIn }
                });
                this.isHistoricalRecord = false;
                this.isJump = true;
              }
            })
        }
        OneMoment({ moment: moment })
      }
    }
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.BottomEnd }) {
        Stack({ alignContent: Alignment.Top }) {
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

            Text($r('app.string.near_message'))
              .margin({ left: $r('sys.float.padding_level4') })
              .font({ size: 20, weight: 700 })
              .fontColor($r('sys.color.font_primary'))
          }
          .padding({
            top: 40,
            left: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
            $r('sys.float.padding_level12') : $r('sys.float.padding_level16'),
            right: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
            $r('sys.float.padding_level12') : $r('sys.float.padding_level16')
          })
          .width('100%')
          .height(96)
          .zIndex(2)
          .backgroundBlurStyle(BlurStyle.COMPONENT_THICK)

          Column() {
            List({ space: Constants.LIST_SPACE, scroller: this.listScroller }) {
              if (this.currentBreakpoint === 'sm') {
                ListItem().height(80)

              } else {
                ListItem().height(90)
                ListItem().height(90)

              }
              LazyForEach(momentData, (moment: FriendMoment, index: number) => {
                this.moments(moment, index);
              }, (moment: FriendMoment) => moment.id)
            }
            .scrollBar(BarState.Off)
            .lanes(this.currentBreakpoint === 'sm' ? 1 : 2, 16)
            .cachedCount(this.cachedCountNumber)
            .width(Constants.LAYOUT_MAX)
            .height(Constants.LAYOUT_MAX)
            .listDirection(Axis.Vertical)
            .divider({
              strokeWidth: $r('app.integer.friends_page_divider_width'),
              color: $r('app.color.friends_page_divider_color'),
              startMargin: $r('app.integer.list_history_list_divider_margin'),
              endMargin: $r('app.integer.list_history_list_divider_margin')
            })
            .onScrollIndex((first: number) => {
              this.firstIndex = first;
            })
          }
          .padding({
            left: this.currentBreakpoint === 'sm' ? 8 : this.currentBreakpoint === 'md' ? 18 : 24,
            right: this.currentBreakpoint === 'sm' ? 8 : this.currentBreakpoint === 'md' ? 18 : 24
          })
          .height(Constants.LAYOUT_MAX)
          .width(Constants.LAYOUT_MAX)
        }

        Row() {
          Image($r('app.media.ic_public_backtotop'))
            .width($r('app.integer.back_top_img_size'))
            .height($r('app.integer.back_top_img_size'))
            .opacity($r('app.float.jump_button_opacity'))
        }
        .onClick(() => {
          if (this.firstIndex >= this.SWITCH_BUTTON) {
            this.historyOffset = this.listScroller.currentOffset().yOffset;
            this.listScroller.scrollTo({
              xOffset: Constants.COMM_INIT,
              yOffset: Constants.COMM_INIT,
              animation: { duration: this.ANIMATION_DURATION, curve: Curve.LinearOutSlowIn }
            });
            this.isHistoricalRecord = true;
          }
        })
        .visibility(this.firstIndex >= this.SWITCH_BUTTON ? Visibility.Visible : Visibility.None)
        .justifyContent(FlexAlign.Center)
        .width($r('app.integer.back_top_img_background_size'))
        .height($r('app.integer.back_top_img_background_size'))
        .backgroundColor($r('app.color.ohos_id_color_emphasize'))
        .borderRadius($r('app.integer.back_top_bag_radius'))
        .margin({
          bottom: 16,
          right: $r('app.integer.back_top_margin')
        })
      }
    }
    .backgroundColor($r('sys.color.background_secondary'))
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.pageInfos = context.pathStack;
    })
  }
}

class FriendMomentsData extends BasicDataSource<FriendMoment> {
  public momentList: Array<FriendMoment> = [];

  public totalCount(): number {
    return this.momentList.length;
  }

  public getData(index: number): FriendMoment {
    const  uiContext: UIContext | undefined = AppStorage.get<UIContext>(CommonConstants.KEY_PREFIX_SYSTEM_UICONTEXT);
    if (index === this.momentList.length - 1 && uiContext && uiContext.getHostContext()) {
      getFriendMomentFromRawfile(uiContext.getHostContext()!);
    } else {
      Logger.error('PageListSlideToHistory', 'getFriendMomentFromRawfile fail.');
    }
    return this.momentList[index];
  }

  public addData(index: number, data: FriendMoment): void {
    this.momentList.splice(index, Constants.COMM_INIT, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: FriendMoment): void {
    this.momentList.push(data);
    this.notifyDataAdd(this.momentList.length - 1);
  }
}

const momentData: FriendMomentsData = new FriendMomentsData();

async function getFriendMomentFromRawfile(context: Context): Promise<void> {
  const resourceManager = context.resourceManager;

  interface MyJsonModel {
    friendMoments: FriendMoment[];
  }

  try {
    const res = await resourceManager.getRawFileContent('mockFriendMomentOneModelData.json');
    const textDecoder = util.TextDecoder.create();
    const friendMomentArray = (JSON.parse(textDecoder.decodeToString(res)) as MyJsonModel).friendMoments;

    friendMomentArray.forEach(item => {
      item.id = Math.floor(momentData.totalCount() / 10) + item.id;
      item.text = resourceManager.getStringSync($r('app.string.jump_text_one').id, parseInt(item.id) + 1) + item.text;
      momentData.pushData(item);
    });
  } catch (err) {
    Logger.error('PageListSlideToHistory', '%{public}s', 'getFriendMomentFromRawfile error: ' + err.code);
  }
}

@Builder
export function getPageListSlideToHistory(name: string): void {
  if (name === 'PageListSlideToHistory') {
    PageListSlideToHistory()

  }
}

export const wrappedBuilderPageListSlideToHistory: WrappedBuilder<[string, number]> =
  wrapBuilder(getPageListSlideToHistory);

