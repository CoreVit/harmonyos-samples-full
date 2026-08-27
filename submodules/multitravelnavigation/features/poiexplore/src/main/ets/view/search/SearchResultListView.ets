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

import { uiObserver } from '@kit.ArkUI';
import { geoLocationManager } from '@kit.LocationKit';
import { map, site } from '@kit.MapKit';
import { Common, MapUiState, PanelMode, PanelRouteName, PanelType, ResourceTextUtil, SelectedSite,
  WidthBreakpointType } from 'multitravelbase/Index';
import { PanelGestureCoordinator } from '../gesture/PanelGestureCoordinator';
import { SearchViewModel } from '../../viewmodel/SearchViewModel';
import { SearchBarView } from './SearchBarView';
import { HomeConstants } from '../../constants/HomeConstants';

@Component
export struct SearchResultListView {
  @StorageLink('multitravelnavigationsample_sites') sites: site.Site[] | undefined = [];
  @StorageLink('multitravelnavigationsample_searchInput') searchInput: string = '';
  @StorageLink('multitravelnavigationsample_searchLoading') searchLoading: boolean = false;
  @StorageLink('multitravelnavigationsample_selectedSite') selectedSite: SelectedSite | undefined = undefined;
  @StorageLink('multitravelnavigationsample_mapUiState') mapUiState: MapUiState = MapUiState.HOME;
  @Consume('pageInfo') pageInfo: NavPathStack;
  @Link mapController: map.MapComponentController;
  @ObjectLink searchViewModel: SearchViewModel;
  @Require getBreakpoint: () => uiObserver.WindowSizeLayoutBreakpointInfo;
  waitForCurrentLocation?: () => Promise<geoLocationManager.Location | undefined>;
  @Watch('onPanelModeChanged') @Prop panelMode: PanelMode = PanelMode.Half;
  @Prop panelType: PanelType = PanelType.Normal;
  onPanelModeChange?: (mode: PanelMode) => void;
  onPanelPullStart?: () => void;
  onPanelPullUpdate?: (offsetY: number) => void;
  onPanelPullEnd?: () => void;
  private resultListScroller: ListScroller = new ListScroller();
  private panelGestureCoordinator: PanelGestureCoordinator = new PanelGestureCoordinator();

  aboutToAppear(): void {
    this.onPanelModeChange?.(PanelMode.Half);
    this.mapUiState = MapUiState.SEARCH_RESULT;
    this.onPanelModeChanged();
  }

  private onPanelModeChanged(): void {
    if (this.panelMode === PanelMode.High) {
      this.panelGestureCoordinator.reachTop();
    }
  }

  private resetSearch(): void {
    this.onPanelModeChange?.(PanelMode.Half);
    this.searchViewModel.resetSearch({
      onLoadingChange: (loading: boolean) => this.searchLoading = loading,
      onKeywordChange: (keyword: string) => this.searchInput = keyword,
      onSitesChange: (sites: site.Site[]) => this.sites = sites,
      onMapStateChange: (state: MapUiState) => this.mapUiState = state,
      onClearPage: () => this.pageInfo.clear()
    });
  }

  aboutToDisappear(): void {
    if (this.mapUiState === MapUiState.SEARCH_RESULT) {
      this.resetSearch();
    }
  }

  private formatString(resource: Resource, placeholder: string, value: string | number): string {
    return ResourceTextUtil.formatString(this.getUIContext(), resource, placeholder, value);
  }

  @Builder
  searchResultList() {
    ForEach(this.sites, (item: site.Site) => {
      Column() {
        Row() {
          Image($r('app.media.attraction1'))
            .width($r('app.float.search_result_image_size'))
            .height($r('app.float.search_result_image_size'))
            .borderRadius($r('app.float.location_image_border'))
          Column() {
            Text(item.name)
              .fontSize($r('app.float.search_result_name_font'))
              .fontColor($r('app.color.black_90'))
              .fontWeight(FontWeight.Medium)
              .width(Common.FULL_WIDTH)
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })

            Row() {
              Text($r('app.string.convenience_store'))
                .fontSize($r('app.float.search_result_text_font'))
                .fontColor($r('sys.color.brand_font'))
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .margin({ right: 8 })

              if (this.searchViewModel.getSiteOpeningHours(item)) {
                Row() {
                  Text($r('app.string.open_now_prefix'))
                    .fontSize($r('app.float.search_result_text_font'))
                    .fontColor($r('app.color.black_90'))
                  Text(this.searchViewModel.getSiteOpeningHours(item))
                    .fontSize($r('app.float.search_result_text_font'))
                    .width(80)
                    .fontColor($r('app.color.black_90'))
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }
                .layoutWeight(1)
              }
            }
            .width(Common.FULL_WIDTH)
            .margin({
              top: 8,
              bottom: 4,
            })

            Row() {
              Text(this.formatString($r('app.string.search_result_distance_template'), 'distance',
                this.searchViewModel.getSiteDistance(item)))
                .fontSize($r('app.float.search_result_text_font'))
                .fontColor($r('app.color.black_90'))
                .maxLines(1)
                .margin({ right: 8 })

              Text(this.searchViewModel.getSiteAddress(item))
                .fontSize($r('app.float.search_result_text_font'))
                .fontColor($r('app.color.black_90'))
                .layoutWeight(1)
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .width(Common.FULL_WIDTH)
          }
          .margin({ left: 12 })
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)
          .constraintSize({
            maxWidth: new WidthBreakpointType($r('app.string.location_name_width'),
              $r('app.float.information_column_width'), $r('app.float.information_column_width'),
              $r('app.float.information_column_width')).getValue(this.getBreakpoint().widthBreakpoint)
          })
        }
        .width(Common.FULL_WIDTH)
        .constraintSize({ minHeight: $r('app.float.search_result_image_size') })
        .alignItems(VerticalAlign.Top)
        .margin({
          top: 12,
        })
        .onClick(() => {
          this.searchViewModel.selectSite({
            item,
            mapController: this.mapController,
            onPanelModeChange: this.onPanelModeChange,
            onSelectedSiteChange: (selectedSite: SelectedSite) => this.selectedSite = selectedSite,
            onMapStateChange: (state: MapUiState) => this.mapUiState = state,
            onOpenSiteDetail: () => this.pageInfo.pushPathByName(PanelRouteName.SITE_DETAIL, undefined)
          });
        })
      }
      .margin({
        left: 16,
        right: 16,
      })
      .constraintSize({ minHeight: $r('app.float.search_result_height_low') })
      .borderRadius($r('app.float.search_result_column_border'))
    })
  }

  @Builder
  LoadingView() {
    Column() {
      LoadingProgress()
        .width(72)
        .height(72)
        .color($r('sys.color.font_secondary'))
      Text($r('app.string.loading_data'))
        .fontSize(14)
        .opacity(0.6)
    }
    .width(Common.FULL_WIDTH)
    .height('80%')
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Column() {
      Column() {
        SearchBarView({
          panelMode: this.panelMode,
          mapController: this.mapController,
          searchViewModel: this.searchViewModel,
          waitForCurrentLocation: this.waitForCurrentLocation,
          onPanelModeChange: this.onPanelModeChange
        })
        Row() {
          Row() {
            Text($r('app.string.location_distance'))
              .fontSize($r('app.float.tip_font_size'))
              .fontColor($r('app.color.black_90'))

            SymbolGlyph($r('sys.symbol.chevron_down'))
              .fontSize($r('app.float.rank_image_width'))
              .fontColor([$r('sys.color.font_primary')])
          }
          Row() {
            Text($r('app.string.rank_recommendation'))
              .fontSize($r('app.float.tip_font_size'))
              .fontColor($r('app.color.black_90'))

            SymbolGlyph($r('sys.symbol.chevron_down'))
              .fontSize($r('app.float.rank_image_width'))
              .fontColor([$r('sys.color.font_primary')])
          }
        }
        .height($r('app.float.search_result_rank_height'))
        .width(Common.FULL_WIDTH)
        .justifyContent(FlexAlign.SpaceEvenly)
        .margin({ top: 8 })

        Divider()
          .width(Common.FULL_WIDTH)
          .strokeWidth(HomeConstants.DIVIDER_STROKE_WIDTH)
          .opacity($r('app.float.divider_opacity'))
          .margin({
            top: 8
          })
      }
      .width(Common.FULL_WIDTH)
      .padding({
        left: 16,
        right: 16
      })
      .parallelGesture(
        PanGesture(this.panelGestureCoordinator.getVerticalPanOption())
          .onActionStart(() => {
            this.panelGestureCoordinator.reachTop();
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
      .visibility(this.panelMode === PanelMode.High || this.panelMode === PanelMode.Half ?
        Visibility.Visible : Visibility.None)

      if (this.searchLoading) {
        this.LoadingView()
      } else if (this.panelType !== PanelType.None && this.panelMode !== PanelMode.High) {
        Column() {
          this.searchResultList()
        }
        .layoutWeight(1)
        .width(Common.FULL_WIDTH)
        .height(Common.FULL_HEIGHT)
        .alignItems(HorizontalAlign.Start)
        .clip(true)
        .parallelGesture(
          PanGesture(this.panelGestureCoordinator.getVerticalPanOption())
            .onActionStart(() => {
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
      } else {
        List({ scroller: this.resultListScroller }) {
          this.searchResultList()
        }
        .layoutWeight(1)
        .width(Common.FULL_WIDTH)
        .height(Common.FULL_HEIGHT)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.None)
        .onReachStart(() => {
          this.panelGestureCoordinator.reachTop();
        })
        .onDidScroll(() => {
          this.panelGestureCoordinator.updateVerticalOffset(this.resultListScroller.currentOffset().yOffset);
        })
        .parallelGesture(
          PanGesture(this.panelGestureCoordinator.getVerticalPanOption())
            .onActionStart(() => {
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
      }
    }
    .height(Common.FULL_HEIGHT)
  }
}
