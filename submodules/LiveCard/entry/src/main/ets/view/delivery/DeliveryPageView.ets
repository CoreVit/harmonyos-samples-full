/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { HeaderSection } from '../common/HeaderSection';
import { WindowInfo, WindowUtil } from '../../utils/WindowUtil';
import { BorderRadius, Constants, FONT_STYLES } from '../../common/CommonConstants';
import { DeliveryTrack, DELIVERY_TRACKS } from '../../model/delivery/DeliveryConstant';
import RouterUtil from '../../utils/RouterUtil';
import { Logger } from '../../utils/Logger';

const TAG = 'DeliveryPage';

@Builder
export function DeliveryPageViewBuilder() {
  DeliveryPage();
}

@Component
struct DeliveryPage {
  @State image: Resource = $r('app.media.delivery_bg');
  @StorageProp(Constants.KEY_WINDOW_INFO) windowInfo?: WindowInfo = undefined;
  @StorageProp(Constants.KEY_WINDOW_UTIL) windowUtil?: WindowUtil = undefined;
  aboutToAppear(): void {
    Logger.info(TAG, `DeliveryPage aboutToAppear success`);
  }
  @Builder
  myBuilder() {
    DeliveryPageView();
  }
  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.TopStart }) {
        Row() {
          if (this.windowInfo && this.windowInfo?.widthBp > WidthBreakpoint.WIDTH_SM) {
            Column() {
              this.myBuilder();
            }
            .width(this.windowInfo?.widthBp >= WidthBreakpoint.WIDTH_LG ? '33%' : '50%')
            .height('100%')
            .backgroundColor('#F5F5F5')
            .borderRadius(BorderRadius.BUTTON)
            .clip(true)
            .shadow({
              radius: 20,
              color: '#14000000',
              offsetX: 0,
              offsetY: 5
            });
          }
          Column() {
            Image($r('app.media.delivery_path'))
              .width(154)
              .height(333);
          }
          .layoutWeight(1)
          .height('100%')
          .justifyContent(FlexAlign.Center);
        }
        .width('100%')
        .height('100%')
        .margin({
          top: 8,
        });

        HeaderSection();
      }
      .padding({
        left: this.windowInfo && this.windowInfo?.widthBp >= WidthBreakpoint.WIDTH_LG ? 32 : 24,
        right: this.windowInfo && this.windowInfo?.widthBp >= WidthBreakpoint.WIDTH_LG ? 32 : 24
      });
    }
    .onBackPressed(() => {
      RouterUtil.getInstance().closeApp();
      return false;
    })
    .bindSheet(this.windowInfo === undefined ||
      this.windowInfo?.widthBp <= WidthBreakpoint.WIDTH_SM, this.myBuilder(), {
      height: '60%',
      detents: ['60%'],
      showClose: false,
      dragBar: true,
      enableOutsideInteractive: true,
      preferType: SheetType.CENTER,

      shadow: {
        radius: 20,
        color: '#14000000',
        offsetX: 0,
        offsetY: 5
      },

      onWillDismiss: (action: DismissSheetAction) => {
        if (action.reason === DismissReason.PRESS_BACK) {
          RouterUtil.getInstance().closeApp();
        }
      }

    })
    .hideTitleBar(true)
    .backgroundImage(this.image)
    .backgroundImageSize(ImageSize.Cover);
  }
}

@Component
struct DeliveryPageView {
  private deliveryNumber: string = 'XX123456789';
  private currentStatus: Resource = $r('app.string.delivery_status_in_transit');
  private tracks: DeliveryTrack[] = DELIVERY_TRACKS;
  aboutToAppear(): void {
    Logger.info(`DeliveryPageView`);
  }
  build() {
    NavDestination() {
      Column() {
        Row() {
          Blank()
            .width(48)
            .height(4)
            .backgroundColor($r('sys.color.icon_fourth'))
            .borderRadius(2);
        }
        .width(48)
        .justifyContent(FlexAlign.Center)
        .alignRules({
          middle: { anchor: '__container__', align: HorizontalAlign.Center },
          top: { anchor: '__container__', align: VerticalAlign.Top },
        });
      }
      .padding({ top: 8 });

      Column() {
        Stack() {
          Row() {
            Text($r('app.string.delivery_detail_title'))
              .fontSize(FONT_STYLES.bodyXLarge.fontSize)
              .lineHeight(FONT_STYLES.bodyXLarge.lineHeight)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('sys.color.font_primary'));
          }
          .padding({
            top: 10.5,
            bottom: 14.5
          })
          .width('100%');
        }
        .margin({
          bottom: 8
        })
        .width('100%');

        Scroll() {
          Column() {
            this.StatusCard();
            this.TrackTimeline();
          }
          .padding({ bottom: 16 });
        }
        .align(Alignment.Top)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
        .layoutWeight(1);
      }
      .width('100%')
      .height('100%');
    }
    .padding({ left: 16, right: 16 })
    .hideTitleBar(true)
    .backgroundColor($r('sys.color.comp_background_gray'));
  }
  @Builder
  StatusCard() {
    Column() {
      Row() {
        Column() {
          Text($r('app.string.delivery_tracking_number'))
            .fontSize(16)
            .lineHeight(21)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.font_primary'));
          Text(this.deliveryNumber)
            .fontSize(14)
            .lineHeight(19)
            .fontWeight(FontWeight.Normal)
            .fontColor($r('sys.color.font_secondary'))
            .margin({ top: 2 });
        }
        .padding({ top: 10.5, bottom: 10.5 })
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1);

        Row() {
          SymbolGlyph($r('sys.symbol.truck_box_fill'))
            .fontSize(24)
            .fontColor([$r('sys.color.icon_emphasize')]);
          Text(this.currentStatus)
            .fontSize(14)
            .lineHeight(19)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.font_emphasize'))
            .margin({ left: 6 });
        };
      }
      .width('100%')
      .padding({
        left: 12,
        right: 12,
        top: 4,
        bottom: 4
      })
      .backgroundColor($r('sys.color.comp_background_list_card'))
      .borderRadius($r('app.float.border_radius'));
    }
    .width('100%')

  }
  @Builder
  TrackTimeline() {
    Column() {
      Text($r('app.string.delivery_tracking_log'))
        .fontSize(14)
        .lineHeight(19)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.font_secondary'))
        .margin({ top: 28, bottom: 8 });

      Column() {
        ForEach(this.tracks, (track: DeliveryTrack, index: number) => {
          Row() {
            Column() {
              Column() {
                if (index > 0) {
                  Line()
                    .width(0.5)
                    .height('100%')
                    .backgroundColor($r('sys.color.comp_divider'));
                }
              }
              .layoutWeight(1);

              Circle()
                .width(8)
                .height(8)
                .margin({ top: 2, bottom: 2 })
                .fill(track.isActive ? $r('sys.color.icon_emphasize') : $r('sys.color.icon_fourth'));
              Column() {
                if (index !== this.tracks.length - 1) {
                  Line()
                    .width(0.5)
                    .height('100%')
                    .backgroundColor($r('sys.color.comp_divider'));
                }
              }
              .layoutWeight(1);
            };

            Column() {
              Text(track.time)
                .fontSize(12)
                .lineHeight(16)
                .fontColor(track.isActive ? $r('sys.color.font_emphasize') : $r('sys.color.font_tertiary'))
                .fontWeight(track.isActive ? FontWeight.Bold : FontWeight.Normal);

              Text(track.location)
                .fontSize(12)
                .lineHeight(16)
                .fontColor($r('sys.color.font_secondary'))
                .margin({ top: 2 });

              Text(track.status)
                .fontSize(track.isActive ? 14 : 12)
                .lineHeight(track.isActive ? 19 : 16)
                .fontColor(track.isActive ? $r('sys.color.font_primary') : $r('sys.color.font_tertiary'))
                .fontWeight(track.isActive ? FontWeight.Medium : FontWeight.Normal)
                .margin({ top: 2 });
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)
            .padding({ left: 12, top: 10, bottom: 10 });
          }
          .height(72)
          .clip(true)
          .width('100%');
        }, (index: number) => index.toString());
      }
      .width('100%')
      .padding(16)
      .backgroundColor($r('sys.color.comp_background_list_card'))
      .borderRadius($r('app.float.border_radius'));
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%');
  }
}