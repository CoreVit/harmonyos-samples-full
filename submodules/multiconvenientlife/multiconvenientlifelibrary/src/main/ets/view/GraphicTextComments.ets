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
import { BreakpointConstants } from '../constants/BreakpointConstants';
import { CommonConstants } from '../constants/CommonConstants';

@Component
export struct GraphicTextComments {
  @StorageLink(CommonConstants.LIFE_PREFIX + 'currentBreakpoint') currentBreakpoint: string =
    BreakpointConstants.BREAKPOINT_LG;
  @StorageLink(CommonConstants.LIFE_PREFIX + 'statusBarHeight') statusBarHeight: number = 0;
  @Consume(CommonConstants.LIFE_PREFIX + 'showSideBar') showSideBar: boolean;
  private tagList: ResourceStr[] = [$r('app.string.free_parking'), $r('app.string.recent_orders'),
    $r('app.string.positive_feedback')]
  private commentsList: ResourceStr[] = ['有图/视频', '好评', '差评', '其他'];

  build() {
    Scroll() {
      Column() {
        Stack() {
          Image($r('app.media.slt_img'))
            .width(CommonConstants.FULL_PERCENT)
            .height($r('app.float.slt_height'))
          Button() {
            SymbolGlyph($r('sys.symbol.xmark'))
              .fontSize($r('sys.float.Title_M'))
              .fontColor([$r('sys.color.font_on_primary')])
          }
          .height(40)
          .aspectRatio(1)
          .position({
            top: CommonConstants.ICON_IMAGE_POSITION + this.statusBarHeight,
            left: $r('app.float.common_padding')
          })
          .backgroundColor($r('sys.color.font_on_fourth'))
          .onClick(() => {
            this.showSideBar = false;
          })
        }

        Column() {
          Column() {
            Row() {
              Text($r('app.string.seabird_park'))
                .fontSize($r('app.float.delicious_font'))
                .fontWeight(CommonConstants.FONT_WEIGHT_700)
                .width('70%')
              Blank()
              Column() {
                SymbolGlyph($r('sys.symbol.star'))
                  .fontSize(14)
                  .fontColor([$r('sys.color.icon_secondary')])
                Text($r('app.string.collections_text'))
                  .fontColor($r('sys.color.font_secondary'))
                  .fontSize($r('app.float.delivery_font'))
              }
            }
            .width(CommonConstants.FULL_PERCENT)
            .margin({
              bottom: $r('app.float.margin_twelves')
            })

            Row() {
              ForEach(this.tagList, () => {
                Button()
                  .size({ width: 64, height: 14 })
                  .backgroundColor($r('sys.color.ohos_id_color_alert'))
                  .opacity(0.1)
                  .padding({
                    top: $r('app.float.orange_padding'),
                    bottom: $r('app.float.orange_padding'),
                    left: $r('app.float.tabs_padding_tb'),
                    right: $r('app.float.tabs_padding_tb')
                  })
                  .margin({
                    right: $r('app.float.tag_margin_right')
                  })
              }, (item: string) => item);
            }
            .width(CommonConstants.FULL_PERCENT)
            .justifyContent(FlexAlign.Start)
            .margin({
              bottom: 8
            })

            Button()
              .size({ width: 57, height: 16 })
              .backgroundColor($r('sys.color.comp_background_secondary'))
              .margin({
                bottom: 8
              })
            Row() {
              Button()
                .size({ width: 40, height: 20 })
                .backgroundColor($r('sys.color.comp_background_secondary'))
                .margin({
                  right: $r('app.float.filtering_padding_lr')
                })
              Button()
                .size({ width: 40, height: 20 })
                .backgroundColor($r('sys.color.comp_background_secondary'))
              Blank()
              if (this.currentBreakpoint !== BreakpointConstants.BREAKPOINT_MD) {
                Button($r('app.string.add_cart'))
                  .fontSize($r('sys.float.Body_M'))
                  .height(26)
              }
            }
            .width(CommonConstants.FULL_PERCENT)
          }
          .borderRadius($r('app.float.dish_border'))
          .padding({
            top: $r('app.float.nine_padding'),
            left: $r('app.float.twelves_padding'),
            right: $r('app.float.twelves_padding'),
            bottom: $r('app.float.twelves_padding')
          })
          .width(CommonConstants.FULL_PERCENT)
          .backgroundColor($r('sys.color.comp_background_primary'))
          .alignItems(HorizontalAlign.Start)
          .margin({
            bottom: $r('app.float.margin_small')
          })

          Column() {
            Row() {
              Button()
                .size({ width: 48, height: 20 })
                .backgroundColor($r('sys.color.comp_divider'))
              Blank()
              Button()
                .size({ width: 48, height: 20 })
                .backgroundColor($r('sys.color.comp_background_secondary'))
            }
            .width(CommonConstants.FULL_PERCENT)
            .margin({
              bottom: $r('sys.float.padding_level6')
            })

            Divider()
              .width(CommonConstants.FULL_PERCENT)
              .margin({
                bottom: $r('app.float.margin_twelves')
              })

            Row() {
              Button()
                .size({ width: 48, height: 16 })
                .backgroundColor($r('sys.color.comp_background_secondary'))
                .margin({ right: 24 })
              Button()
                .size({ height: 16 })
                .backgroundColor($r('sys.color.comp_background_secondary'))
                .layoutWeight(1)
            }
            .margin({
              bottom: $r('app.float.margin_twelves')
            })

            Row() {
              Button()
                .size({ width: 48, height: 16 })
                .backgroundColor($r('sys.color.comp_background_secondary'))
                .margin({ right: 24 })
              Button()
                .size({ height: 16, width: 48 })
                .backgroundColor($r('sys.color.comp_background_secondary'))
            }
            .justifyContent(FlexAlign.Start)
            .width(CommonConstants.FULL_PERCENT)
            .margin({
              bottom: $r('app.float.margin_twelves')
            })

            Row() {
              Button()
                .size({ width: 48, height: 16 })
                .backgroundColor($r('sys.color.comp_background_secondary'))
                .margin({ right: 24 })
              Button()
                .size({ height: 16, width: 48 })
                .backgroundColor($r('sys.color.comp_background_secondary'))
            }
            .justifyContent(FlexAlign.Start)
            .width(CommonConstants.FULL_PERCENT)
            .margin({
              bottom: $r('app.float.margin_twelves')
            })

            Row() {
              Button()
                .size({ width: 48, height: 16 })
                .backgroundColor($r('sys.color.comp_background_secondary'))
                .margin({ right: 24 })
              Button()
                .size({ height: 16, width: 67 })
                .backgroundColor($r('sys.color.comp_background_secondary'))
            }
            .width(CommonConstants.FULL_PERCENT)
            .justifyContent(FlexAlign.Start)
            .margin({
              bottom: $r('app.float.margin_twelves')
            })
          }
          .width(CommonConstants.FULL_PERCENT)
          .backgroundColor($r('sys.color.comp_background_primary'))
          .borderRadius($r('app.float.dish_border'))
          .padding({
            top: $r('app.float.nine_padding'),
            left: $r('app.float.twelves_padding'),
            right: $r('app.float.twelves_padding'),
            bottom: $r('app.float.twelves_padding')
          })
          .margin({
            bottom: $r('app.float.margin_small')
          })

          Column() {
            Row() {
              Button()
                .size({ width: 48, height: 20 })
                .backgroundColor($r('sys.color.comp_divider'))
              Blank()
              Button()
                .size({ width: 48, height: 16 })
                .backgroundColor($r('sys.color.comp_background_secondary'))
            }
            .width(CommonConstants.FULL_PERCENT)
            .margin({
              bottom: $r('app.float.nine_margin')
            })

            Divider()
              .color($r('app.color.five_white'))
              .margin({
                bottom: $r('app.float.text_margin_bottom')
              })
            Row() {
              ForEach(this.commentsList, () => {
                Button()
                  .size({ width: 48, height: 14 })
                  .backgroundColor($r('sys.color.ohos_id_color_alert'))
                  .opacity(0.1)
                  .padding({
                    top: $r('app.float.orange_padding'),
                    bottom: $r('app.float.orange_padding'),
                    left: $r('app.float.tabs_padding_tb'),
                    right: $r('app.float.tabs_padding_tb')
                  })
                  .margin({
                    right: $r('app.float.tag_margin_right')
                  })
                  .borderRadius($r('app.float.tag_radius'))
              }, (item: string) => item);
            }
            .width(CommonConstants.FULL_PERCENT)
            .justifyContent(FlexAlign.Start)
            .margin({
              bottom: $r('app.float.margin_twelves')
            })

            Row() {
              Image($r('app.media.tx2_img'))
                .width($r('app.float.tx2_width'))
                .aspectRatio(1)
                .margin({
                  right: $r('app.float.back_image_right')
                })
              Column() {
                Button()
                  .size({ width: 48, height: 14 })
                  .backgroundColor($r('sys.color.comp_background_secondary'))
                  .margin({ bottom: $r('sys.float.padding_level4') })
                Button()
                  .size({ width: '100%', height: 14 })
                  .backgroundColor($r('sys.color.comp_background_secondary'))
              }
              .alignItems(HorizontalAlign.Start)
              .padding({
                top: $r('app.float.text_margin_bottom')
              })
              .layoutWeight(1)

              Column() {
                Image($r('app.media.v2_ic_public_favor'))
                  .width($r('app.float.more_width'))
                  .aspectRatio(1)
                  .margin({
                    bottom: $r('app.float.favor_bottom')
                  })
                Text($r('app.string.two_number'))
                  .fontColor($r('app.color.forty_black'))
                  .fontSize($r('app.float.filtering_font'))
              }
              .margin({
                left: $r('app.float.favor_margin_left')
              })
            }
            .width(CommonConstants.FULL_PERCENT)
            .margin({
              bottom: $r('app.float.margin_small')
            })

            Row() {
              Button()
                .size({ width: 64, height: 16 })
                .backgroundColor($r('sys.color.comp_background_secondary'))
            }
            .height($r('app.float.all_comments'))
          }
          .borderRadius($r('app.float.dish_border'))
          .padding({
            top: $r('app.float.nine_padding'),
            left: $r('app.float.twelves_padding'),
            right: $r('app.float.twelves_padding'),
            bottom: $r('app.float.twelves_padding')
          })
          .backgroundColor($r('sys.color.comp_background_primary'))
        }
        .width(CommonConstants.FULL_PERCENT)
        .padding($r('app.float.padding_small'))
      }
    }
    .scrollBarWidth(0)
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .backgroundColor($r('sys.color.background_secondary'))
    .height(CommonConstants.FULL_PERCENT)
    .align(Alignment.Top)
  }
}