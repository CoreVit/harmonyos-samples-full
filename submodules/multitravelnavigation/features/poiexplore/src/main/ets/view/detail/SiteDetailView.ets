/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { map } from '@kit.MapKit';
import { Common, MapUiState, PanelMode, PanelRouteName, PanelType, ResourceTextUtil, SelectedSite, WindowInfo } from
  'multitravelbase/Index';
import { SiteInfo } from '../../model/data/SiteDetailData';
import { PanelGestureCoordinator } from '../gesture/PanelGestureCoordinator';
import { SiteDetailPageViewModel } from '../../viewmodel/SiteDetailPageViewModel';

@Component
export struct SiteDetailView {
  @StorageLink('multitravelnavigationsample_selectedSite') selectedSite: SelectedSite | undefined = undefined;
  @StorageLink('multitravelnavigationsample_mapUiState') mapUiState: MapUiState = MapUiState.SITE_DETAIL;
  @Consume('pageInfo') pageInfo: NavPathStack;
  @ObjectLink mainWindowInfo: WindowInfo;
  @Link mapController: map.MapComponentController | undefined;
  @ObjectLink viewModel: SiteDetailPageViewModel;
  @Watch('onPanelModeChanged') @Prop panelMode: PanelMode = PanelMode.Half;
  @Prop panelType: PanelType = PanelType.Normal;
  @Prop isFloating: boolean = false;
  onPanelPullStart?: () => void;
  onPanelPullUpdate?: (offsetY: number) => void;
  onPanelPullEnd?: () => void;
  private contentScroller: Scroller = new Scroller();
  private panelGestureCoordinator: PanelGestureCoordinator = new PanelGestureCoordinator();

  private gotoRoutePlan(): void {
    this.viewModel.openRoutePlan(this.selectedSite,
      (state: MapUiState) => this.mapUiState = state,
      () => this.pageInfo.pushPathByName(PanelRouteName.ROUTE_PLAN, undefined));
  }

  private getBottomAvoid(): number {
    return this.getUIContext().px2vp(this.mainWindowInfo.avoidNavigationIndicator?.bottomRect.height ?? 0);
  }

  private onPanelModeChanged(): void {
    this.panelGestureCoordinator.reachTop();
  }

  private canScrollContent(): boolean {
    return this.panelType === PanelType.None || this.panelMode === PanelMode.High;
  }

  private getContentPanOption(): PanGestureOptions {
    if (this.panelType !== PanelType.None && this.panelMode === PanelMode.High) {
      return this.panelGestureCoordinator.getDownPanOption();
    }
    return this.panelGestureCoordinator.getVerticalPanOption();
  }

  private formatString(resource: Resource, placeholder: string, value: string | number): string {
    return ResourceTextUtil.formatString(this.getUIContext(), resource, placeholder, value);
  }

  async aboutToAppear(): Promise<void> {
    this.onPanelModeChanged();
    await this.viewModel.enterPage(this.selectedSite, this.mapController,
      (state: MapUiState) => this.mapUiState = state);
  }
  aboutToDisappear(): void {
    if (this.mapUiState !== MapUiState.ROUTE_PLAN) {
      this.mapUiState = MapUiState.SEARCH_RESULT;
    }
  }

  @Builder
  SiteGrid(site: SiteInfo) {
    Column() {
      Image(site.imgSource)
        .width(64)
        .height(64)
        .objectFit(ImageFit.Cover)
        .borderRadius(12)
      Text(site.siteName)
        .height(19)
        .fontSize(14)
        .margin({top: 5})
      Text(site.siteBrief)
        .height(11)
        .fontSize(8)
        .fontColor($r('sys.color.font_secondary'))
      Row() {
        Text() {
          Span('¥')
            .fontSize(8)
            .fontColor($r('sys.color.multi_color_08'))
          Span(`${site.siteCount}`)
            .margin({left: 2})
            .fontColor($r('sys.color.multi_color_08'))
            .fontSize(10)
        }
        Text(site.sitePrice)
          .decoration({
            type: TextDecorationType.LineThrough,
            color: site.isFree ? '00FFFFFF': $r('sys.color.font_secondary')
          })
          .fontColor($r('sys.color.font_secondary'))
          .fontSize(8)
          .margin({left: 2})
        if(site.countInfo) {
          Text(site.countInfo)
            .fontColor($r('sys.color.multi_color_08'))
            .fontSize(6)
            .textAlign(TextAlign.Center)
            .width(21)
            .height(9)
            .backgroundColor($r('app.color.site_tag_background'))
            .margin({left: 2})
        }
      }
      .height(13)
      .margin({ top:2 })
    }
    .margin({right: 12})
  }

  @Builder
  AskIcon() {
    Stack({ alignContent: Alignment.Center }) {
      Image($r('app.media.icon_ask'))
        .height(16)
        .width(16)
      Text($r('app.string.ask_icon_text'))
        .fontSize(10)
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.White)
        .textAlign(TextAlign.Center)
        .width(16)
        .height(16)
    }
    .width(16)
    .height(16)
  }

  @Builder
  AskRow(question: ResourceStr, answerCount: ResourceStr) {
    Row() {
      this.AskIcon()
      Text(question)
        .fontSize(12)
        .margin({ left: 8, right: 12 })
        .layoutWeight(1)
      Text(answerCount)
        .fontColor($r('sys.color.font_secondary'))
        .fontSize(12)
    }
    .margin({
      bottom: 8
    })
  }

  @Builder
  ActionIcon(image: Resource, text: ResourceStr) {
    Column() {
      SymbolGlyph(image)
        .fontSize(24)
        .fontColor([$r('sys.color.icon_secondary')])
      Text(text)
        .fontSize(12)
        .fontColor($r('sys.color.font_secondary'))
        .height(16)
    }
    .margin({left: 26})
    .width(24)
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Column() {
        if (this.selectedSite) {
          Scroll(this.contentScroller) {
            Column(){
              Column() {
                Row() {
                  Text() {
                    Span(this.selectedSite.name)
                      .fontWeight('medium')
                      .fontSize(18)
                    Span(`  ${this.selectedSite.abstractText}`)
                      .fontSize(12)
                      .fontColor($r('sys.color.multi_color_09'))
                  }
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .layoutWeight(1)
                  .margin({ right: 12 })

                  Button({type: ButtonType.Circle}) {
                    SymbolGlyph($r('sys.symbol.xmark'))
                      .fontSize(16)
                      .fontWeight(FontWeight.Bold)
                      .fontColor([$r('sys.color.font_secondary')])
                  }
                  .width(32)
                  .height(32)
                  .backgroundColor(this.panelType === PanelType.None ? '#00000000': '#0C000000')
                  .onClick(() => {
                    this.mapUiState = MapUiState.SEARCH_RESULT;
                    this.pageInfo.pop();
                  })
                }
                .constraintSize({ minHeight: 32 })
                .alignItems(VerticalAlign.Top)

                Row() {
                  Row() {
                    Text($r('app.string.site_open_now'))
                      .fontSize(12)
                    Text(this.selectedSite.openingHours)
                      .fontSize(12)
                      .margin({left: 2})
                  }
                  Row() {
                    Text($r('app.string.phone_label'))
                      .fontSize(12)
                    Text($r('app.string.phone_number_sample'))
                      .fontSize(12)
                      .margin({left: 2})
                  }
                  .margin({left: 13})
                }
                .height(16)
                .alignItems(VerticalAlign.Center)

                Row() {
                  Text(this.formatString($r('app.string.site_detail_distance_template'), 'distance',
                    Math.round(this.selectedSite.distance)))
                    .fontWeight('medium')
                    .fontSize(14)
                  Text($r('app.string.walk_less_than_one_minute'))
                    .fontWeight('medium')
                    .fontSize(14)
                    .margin({left: 13})
                }
                .margin({top: 8})
                .height(19)
                .alignItems(VerticalAlign.Center)

                Row() {
                  Text(this.selectedSite.address)
                    .fontSize(12)
                    .fontColor($r('sys.color.font_secondary'))
                }
                .margin({top: 4})
                .height(16)
                .alignItems(VerticalAlign.Center)

                Row(){
                  Button({ type: ButtonType.Normal }) {
                    Text() {
                      Span($r('app.string.site_nearby_other_store'))
                        .fontSize(10)
                      Span($r('app.string.site_arrival_rate_13'))
                        .fontColor($r('sys.color.multi_color_08'))
                        .fontSize(8)
                    }
                  }
                  .layoutWeight(1)
                  .height(23)
                  .backgroundColor($r('app.color.button_5'))
                  .borderRadius(12)

                  Button({ type: ButtonType.Normal }) {
                    Text() {
                      Span($r('app.string.site_east_gate'))
                        .fontSize(10)
                      Span($r('app.string.site_arrival_rate_87'))
                        .fontColor($r('sys.color.multi_color_04'))
                        .fontSize(8)
                    }
                  }
                  .layoutWeight(1)
                  .height(23)
                  .backgroundColor($r('app.color.button_5'))
                  .margin({left: 12})
                  .borderRadius(12)
                }
                .margin({top: 13})

                Image($r('app.media.img_somewhere1'))
                  .objectFit(ImageFit.Cover)
                  .width('100%')
                  .borderRadius(12)
                  .margin({top: 12})
              }
              .expandSafeArea()
              .alignItems(HorizontalAlign.Start)
              .padding({left: 16, right: 16})

              Divider()
                .strokeWidth(4)
                .color($r('app.color.button_5'))
                .width('100%')
                .margin({top: 4, bottom: 8})

              Column() {
                Text($r('app.string.site_scenic_tickets'))
                  .fontWeight('medium')
                  .fontSize(14)
                  .height(19)
                  .margin({top: 12, right: 16, bottom: 9})
                List() {
                  ForEach(this.viewModel.siteList, (item: SiteInfo) => {
                    ListItem() {
                      this.SiteGrid(item)
                    }
                  })
                }
                .width(Common.FULL_WIDTH)
                .height(114)
                .listDirection(Axis.Horizontal)
                .scrollBar(BarState.Off)
              }
              .width('100%')
              .alignItems(HorizontalAlign.Start)
              .padding({left: 16})

              Divider()
                .strokeWidth(1.5)
                .color($r('app.color.button_5'))
                .width('100%')
                .margin({top: 14, right: 16})

              Column() {
                Row() {
                  Text($r('app.string.have_more'))
                    .fontSize(12)
                    .fontColor($r('sys.color.font_secondary'))
                  SymbolGlyph($r('sys.symbol.chevron_forward'))
                    .fontSize(10)
                    .fontColor([$r('sys.color.font_primary')])
                    .margin({left: 4})
                }
                .margin({top: 10.5})
              }
              .width('100%')
              .alignItems(HorizontalAlign.Center)
              .padding({left: 16, right: 16})

              Divider()
                .strokeWidth(4)
                .color($r('app.color.button_5'))
                .width('100%')
                .margin({top: 8, bottom: 12})

              Column() {
                Text($r('app.string.ask_section_title'))
                  .fontSize(18)
                  .fontWeight(FontWeight.Medium)
                  .fontColor($r('sys.color.font_primary'))
                  .margin({bottom: 8})
                this.AskRow($r('app.string.ask_parking_question'), $r('app.string.ask_parking_answers'))
                this.AskRow($r('app.string.ask_charging_question'), $r('app.string.ask_charging_answers'))
              }
              .alignItems(HorizontalAlign.Start)
              .margin({left: 16, right: 16})

              Column() {
                Row() {
                  Text($r('app.string.recommend_location'))
                    .fontSize($r('app.float.tip_font_size'))
                    .fontColor($r('sys.color.brand_font'))
                  SymbolGlyph($r('sys.symbol.xmark'))
                    .fontSize($r('app.float.close_image_size'))
                    .fontColor([$r('sys.color.font_primary')])
                }
                .width(Common.FULL_WIDTH)
                .justifyContent(FlexAlign.SpaceBetween)
                .padding({
                  left: 16,
                  right: 16,
                  bottom: 4
                })

                Row() {
                  Column() {
                    Row() {
                      Text($r('app.string.recommend'))
                        .padding({ right: 4 })
                        .fontSize($r('app.float.large_font_size'))
                        .fontColor($r('app.color.black'))
                      SymbolGlyph($r('sys.symbol.chevron_forward'))
                        .fontSize(16)
                        .fontColor([$r('sys.color.font_primary')])
                    }
                    .padding({ bottom: 4 })

                    Text($r('app.string.direction_desc'))
                      .fontColor($r('app.color.font_add_color'))
                      .fontSize($r('app.float.tip_font_size'))
                  }
                  .alignItems(HorizontalAlign.Start)
                  .width('70%')

                  Button($r('app.string.goto'))
                    .height($r('app.float.button_height'))
                    .width($r('app.float.button_width'))
                }
                .padding({
                  left: 16,
                  right: 16
                })
                .justifyContent(FlexAlign.SpaceBetween)
                .width(Common.FULL_WIDTH)
              }
              .padding({
                top: 12,
                bottom: 12
              })
              .margin({ top: 12,left: 16, right: 16, bottom: 16 })
              .borderRadius($r('app.float.border_radius'))
              .shadow({
                radius: $r('app.float.shadow_radius'),
                color: $r('app.color.blur')
              })
            }
            .width(Common.FULL_WIDTH)
            .constraintSize({ minHeight: Common.FULL_HEIGHT })

            .alignItems(HorizontalAlign.Start)
            .justifyContent(FlexAlign.Start)
          }
          .scrollBar(BarState.Off)
          .onDidScroll(() => {
            if (!this.canScrollContent()) {
              this.panelGestureCoordinator.reachTop();
              return;
            }
            this.panelGestureCoordinator.updateVerticalOffset(this.contentScroller.currentOffset().yOffset);
          })
          .onScrollEdge((side: Edge) => {
            if (side === Edge.Top) {
              this.panelGestureCoordinator.reachTop();
            }
          })
          .parallelGesture(
            PanGesture(this.getContentPanOption())
              .onActionStart(() => {
                if (!this.canScrollContent()) {
                  this.panelGestureCoordinator.reachTop();
                }
                this.panelGestureCoordinator.beginGesture();
              })
              .onActionUpdate((event?: GestureEvent) => {
                this.panelGestureCoordinator.updatePanelGesture(event, this.panelMode, this.onPanelPullStart,
                  this.onPanelPullUpdate);
              })
              .onActionEnd(() => {
                this.panelGestureCoordinator.endGesture(this.onPanelPullEnd);
              })
          )
          .scrollable(this.canScrollContent() ?
            ScrollDirection.Vertical : ScrollDirection.None)
          .layoutWeight(1)
          .width(Common.FULL_WIDTH)

          Row() {
            this.ActionIcon($r('sys.symbol.heart'), $r('app.string.favor'))
            this.ActionIcon($r('sys.symbol.share'), $r('app.string.share'))

            Blank()
              .layoutWeight(1)

            Button($r('app.string.route'))
              .height(28)
              .width(72)
              .backgroundColor($r('sys.color.comp_background_tertiary'))
              .fontSize(14)
              .fontColor($r('sys.color.brand_font'))
              .onClick(() => this.gotoRoutePlan())
              .margin({ right: 12})

            Button($r('app.string.navigate'))
              .height(28)
              .width(72)
              .backgroundColor($r('sys.color.brand_font'))
              .fontSize(14)
              .fontColor($r('sys.color.font_on_primary'))
              .onClick(() => this.gotoRoutePlan())
              .margin({right: 16})
          }
          .height(52)
          .width(Common.FULL_WIDTH)
        } else {
          Text($r('app.string.no_site_detail'))
            .fontSize(16)
        }
      }
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .width(Common.FULL_WIDTH)
      .height(Common.FULL_HEIGHT)
      .backgroundColor(Color.Transparent)
    }
    .padding({ bottom: this.isFloating? 10 : this.getBottomAvoid() })
  }
}
