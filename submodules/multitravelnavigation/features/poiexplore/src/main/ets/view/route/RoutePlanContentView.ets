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

import { navi } from '@kit.MapKit';
import { Common, PanelMode, PanelType, ResourceTextUtil, SelectedSite } from 'multitravelbase/Index';
import { RoutePlanViewModel } from '../../viewmodel/RoutePlanViewModel';
import { RouteBottomActionsView } from './RouteBottomActionsView';

@Component
export struct RoutePlanContentView {
  @ObjectLink viewModel: RoutePlanViewModel;
  @Link selectedTabIndex: number;
  @Prop panelType: PanelType = PanelType.Normal;
  @Prop panelMode: PanelMode = PanelMode.Half;
  @Prop selectedSite: SelectedSite | undefined = undefined;
  @Prop showBottomActions: boolean = false;
  onBack?: () => void;
  onStartNavigate?: () => void;
  onReachStart?: () => void;
  onDidScroll?: (scrollOffset: number) => void;
  private routeListScroller: ListScroller = new ListScroller();
  private travelTabIndexes: number[] = [0, 1, 2, 3, 4, 5, 6, 7];

  private formatString(resource: Resource, placeholder: string, value: string | number): string {
    return ResourceTextUtil.formatString(this.getUIContext(), resource, placeholder, value);
  }

  private getTravelTabLabel(index: number): ResourceStr {
    switch (index) {
      case 0:
        return $r('app.string.drive');
      case 1:
        return $r('app.string.taxi');
      case 2:
        return $r('app.string.public_transportation');
      case 3:
        return $r('app.string.cycling');
      case 4:
        return $r('app.string.walk');
      case 5:
        return $r('app.string.proxy_driving');
      case 6:
        return $r('app.string.train');
      case 7:
        return $r('app.string.passenger_car');
      default:
        return $r('app.string.drive');
    }
  }

  private getRouteStrategyLabel(index: number): ResourceStr {
    switch (index) {
      case 0:
        return $r('app.string.route_strategy_primary');
      case 1:
        return $r('app.string.route_strategy_secondary');
      default:
        return $r('app.string.route_strategy_short');
    }
  }

  private getRouteDistanceText(route: navi.Route): string {
    return this.formatString($r('app.string.route_distance_template'), 'distance',
      this.viewModel.getTotalDistance(route).toFixed(1));
  }

  private getRouteTimeText(route: navi.Route): string {
    let time: string = this.viewModel.getTotalTime(route).toString().split('.')[0];
    return this.formatString($r('app.string.route_time_template'), 'time', time);
  }

  private isCompactPanel(): boolean {
    return (this.panelType !== PanelType.None && this.panelMode === PanelMode.Low) ||
      (this.panelType === PanelType.Mini && this.panelMode !== PanelMode.High);
  }

  private shouldShowLowPanelHiddenContent(): boolean {
    return this.panelType !== PanelType.Mini && this.panelMode === PanelMode.Low;
  }

  private shouldUseVerticalRouteList(): boolean {
    return this.panelType === PanelType.None ||
      (this.panelType !== PanelType.Mini && this.panelMode === PanelMode.High);
  }

  @Builder
  private TopInputArea() {
    Row() {
      if (this.panelType === PanelType.None) {
        Button({ type: ButtonType.Circle }) {
          SymbolGlyph($r('sys.symbol.chevron_backward'))
            .fontSize(18)
            .fontColor([$r('sys.color.font_primary')])
        }
        .width(32)
        .height(32)
        .padding(0)
        .backgroundColor($r('app.color.white'))
        .margin({ right: 16 })
        .onClick(() => {
          this.onBack?.();
        })
      }

      Row() {
        Image($r('app.media.meadress'))
          .height($r('app.float.meadress_height'))
          .width($r('app.float.meadress_width'))
          .margin({ left: 16 })

        Column() {
          TextInput({ placeholder: $r('app.string.my_location') })
            .backgroundColor($r('app.color.input_area'))
            .height($r('app.float.text_input_height'))
            .fontSize(16)
            .focusable(false)

          Divider()
            .strokeWidth(0.5)
            .lineCap(LineCapStyle.Round)
            .margin({ left: 15 })

          TextInput({
            placeholder: $r('app.string.input_terminal_point'),
            text: this.viewModel.terminalPoint || this.selectedSite?.name || ''
          })
            .backgroundColor($r('app.color.input_area'))
            .height($r('app.float.text_input_height'))
            .fontSize(16)
            .focusable(false)
        }
        .layoutWeight(1)

        SymbolGlyph($r('sys.symbol.plus'))
          .fontSize(16)
          .fontColor([$r('sys.color.font_primary')])
          .margin({ left: 16 })
        SymbolGlyph($r('sys.symbol.swap'))
          .fontSize(16)
          .fontColor([$r('sys.color.font_primary')])
          .margin({ left: 12 })
        SymbolGlyph($r('sys.symbol.mic'))
          .fontSize(16)
          .fontColor([$r('sys.color.font_primary')])
          .margin({ left: 12, right: 16 })
      }
      .height(81)
      .layoutWeight(1)
      .backgroundColor($r('app.color.input_area'))
      .borderRadius(this.panelType === PanelType.None ? 16 : 24)
      .alignItems(VerticalAlign.Center)
    }
    .width(Common.FULL_WIDTH)
    .height(81)
    .alignItems(VerticalAlign.Top)
  }

  @Builder
  private TravelTabs() {
    Stack({ alignContent: Alignment.End }) {
      Scroll() {
        Row() {
          ForEach(this.travelTabIndexes, (index: number) => {
            Row() {
              if (index === 0) {
                Image($r('app.media.navigate'))
                  .width(20)
                  .height(16)
                  .margin({ right: 8 })
              }
              Text(this.getTravelTabLabel(index))
                .fontSize(14)
                .fontColor(this.selectedTabIndex === index ? $r('app.color.tab_font_selected') :
                  $r('app.color.tab_font_unselected'))
            }
            .justifyContent(FlexAlign.Center)
            .backgroundColor(this.selectedTabIndex === index ? $r('app.color.tab_selected') : $r('app.color.white'))
            .borderRadius(20)
            .height(28)
            .padding({ left: 8, right: 8 })
            .margin({ right: 12 })
            .onClick(() => {
              this.selectedTabIndex = index;
            })
          })
        }
        .padding({ right: 20 })
      }
      .scrollBar(BarState.Off)
      .scrollable(ScrollDirection.Horizontal)
      .width(Common.FULL_WIDTH)

      Row() {
        Blank()
          .layoutWeight(1)
          .linearGradient({
            direction: GradientDirection.Right,
            colors: [[$r('app.color.route_tab_fade_start'), 0], [$r('app.color.route_tab_fade_end'), 1]]
          })
        SymbolGlyph($r('sys.symbol.chevron_down'))
          .fontSize(20)
          .fontColor([$r('sys.color.font_primary')])
          .backgroundColor($r('app.color.white'))
      }
      .width(36)
      .height(Common.FULL_HEIGHT)
      .hitTestBehavior(HitTestMode.None)
    }
    .width(Common.FULL_WIDTH)
    .height(28)
    .margin({ top: 10 })
    .visibility(this.shouldShowLowPanelHiddenContent() ? Visibility.Hidden : Visibility.Visible)
  }

  @Builder
  private VerticalRouteList() {
    List({ scroller: this.routeListScroller }) {
      ForEach(this.viewModel.routes, (item: navi.Route, index: number) => {
        ListItem() {
          Row() {
            Column() {
              Text(this.getRouteStrategyLabel(index))
                .fontSize(12)
                .fontWeight(FontWeight.Bold)
                .fontColor(index === 0 ? $r('app.color.font_color_heavy_selected') :
                  $r('app.color.route_font_color_unselected'))
                .margin({ bottom: 4 })
              Text(this.getRouteDistanceText(item))
                .fontSize(12)
                .fontWeight(FontWeight.Medium)
                .fontColor(index === 0 ? $r('app.color.font_color_light_selected') :
                  $r('app.color.route_font_color_unselected'))
            }
            .alignItems(HorizontalAlign.Start)
            .margin({ left: 16 })

            Text(this.getRouteTimeText(item))
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor(index === 0 ? $r('app.color.font_color_heavy_selected') :
                $r('app.color.route_font_color_unselected'))
              .margin({ right: 16 })
          }
          .width(Common.FULL_WIDTH)
          .justifyContent(FlexAlign.SpaceBetween)
          .height($r('app.float.list_group_height'))
          .borderRadius($r('app.float.list_group_border_radius'))
          .shadow({
            radius: $r('app.float.route_radius'),
            color: $r('app.color.route_radius')
          })
        }
        .padding({
          top: index === 0 ? 16 : 8,
          left: 4,
          right: 4,
          bottom: 8
        })
        .width(Common.FULL_WIDTH)
        .height($r('app.float.list_row_height'))
      })
    }
    .width(Common.FULL_WIDTH)
    .padding({ bottom: 8 })
    .scrollBar(BarState.Off)
    .onReachStart(() => {
      this.onReachStart?.();
    })
    .onDidScroll(() => {
      this.onDidScroll?.(this.routeListScroller.currentOffset().yOffset);
    })
  }

  @Builder
  private HorizontalRouteList() {
    Row() {
      ForEach(this.viewModel.routes.slice(0, 3), (item: navi.Route, index: number) => {
        Column() {
          Text(this.getRouteStrategyLabel(index))
            .fontSize(12)
            .fontWeight(FontWeight.Bold)
            .fontColor(index === 0 ? $r('app.color.font_color_heavy_selected') :
              $r('app.color.route_font_color_unselected'))
          Text(this.getRouteTimeText(item))
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor(index === 0 ? $r('app.color.font_color_heavy_selected') :
              $r('app.color.route_font_color_unselected'))
          Text(this.getRouteDistanceText(item))
            .fontSize(12)
            .fontColor(index === 0 ? $r('app.color.font_color_light_selected') :
              $r('app.color.public_text_color'))
        }
        .height(64)
        .width(90)
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Center)
        .padding({ top: 4, left: 8 })
        .margin({ right: index === 2 ? 0 : 25 })
        .backgroundColor(index === 0 ? $r('app.color.white') : Color.Transparent)
        .borderRadius(12)
        .shadow({
          radius: index === 0 ? $r('app.float.route_radius') : 0,
          color: $r('app.color.route_radius')
        })
      })
    }
    .margin({ top: 12 })
    .width(Common.FULL_WIDTH)
  }

  @Builder
  private RouteListArea() {
    if (this.viewModel.loading) {
      Column() {
        Text($r('app.string.route_planning_loading'))
          .fontSize(12)
          .fontColor($r('sys.color.font_secondary'))
      }
      .width(Common.FULL_WIDTH)
      .height(64)
      .justifyContent(FlexAlign.Center)
    } else if (this.viewModel.errorMsg) {
      Column() {
        Text(this.viewModel.errorMsg)
          .fontSize(12)
          .fontColor('#E53935')
      }
      .width(Common.FULL_WIDTH)
      .height(64)
      .justifyContent(FlexAlign.Center)
    } else if (this.shouldUseVerticalRouteList()) {
      this.VerticalRouteList()
    } else {
      this.HorizontalRouteList()
    }
  }

  build() {
    Column() {
      this.TopInputArea()
      if (!this.isCompactPanel()) {
        this.TravelTabs()
        Column() {
          this.RouteListArea()
        }
        .width(Common.FULL_WIDTH)
      }
      Blank()
        .layoutWeight(1)
      if (this.showBottomActions) {
        RouteBottomActionsView({
          onStartNavigate: this.onStartNavigate
        })
      }
    }
    .alignItems(HorizontalAlign.Start)
    .width(Common.FULL_WIDTH)
    .padding({
      left: 16,
      right: 16
    })
  }
}
