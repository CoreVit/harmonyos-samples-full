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

import { geoLocationManager } from '@kit.LocationKit';
import { map, site } from '@kit.MapKit';
import { Common, MapUiState, PanelMode, PanelRouteName } from 'multitravelbase/Index';
import { HomeConstants } from '../../constants/HomeConstants';
import { SearchViewModel } from '../../viewmodel/SearchViewModel';

@Component
export struct SearchBarView {
  @StorageLink('multitravelnavigationsample_currentLocation')
  currentLocation: geoLocationManager.Location | undefined = undefined;
  @StorageLink('multitravelnavigationsample_searchInput') searchInput: string = '';
  @StorageLink('multitravelnavigationsample_sites') sites: site.Site[] | undefined = [];
  @StorageLink('multitravelnavigationsample_searchLoading') searchLoading: boolean = false;
  @StorageLink('multitravelnavigationsample_mapUiState') mapUiState: MapUiState = MapUiState.HOME;
  @Consume('pageInfo') pageInfo: NavPathStack;
  @Link mapController: map.MapComponentController;
  @Prop panelMode: PanelMode = PanelMode.Half;
  @ObjectLink searchViewModel: SearchViewModel;
  waitForCurrentLocation?: () => Promise<geoLocationManager.Location | undefined>;
  onPanelModeChange?: (mode: PanelMode) => void;

  private isSearchResultPage(): boolean {
    return this.mapUiState === MapUiState.SEARCH_RESULT;
  }

  private resetSearch(): void {
    if (this.isSearchResultPage()) {
      this.onPanelModeChange?.(PanelMode.Half);
    }
    this.searchViewModel.resetSearch({
      onLoadingChange: (loading: boolean) => this.searchLoading = loading,
      onKeywordChange: (keyword: string) => this.searchInput = keyword,
      onSitesChange: (sites: site.Site[]) => this.sites = sites,
      onMapStateChange: (state: MapUiState) => this.mapUiState = state,
      onClearPage: () => this.pageInfo.clear()
    });
  }

  build() {
    Row() {
      Button({ type: ButtonType.Circle }) {
        SymbolGlyph($r('sys.symbol.chevron_backward'))
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor([$r('sys.color.icon_primary')])
      }
      .width($r('app.float.button_back'))
      .height($r('app.float.button_back'))
      .backgroundColor($r('app.color.back_button'))
      .visibility((this.isSearchResultPage() && this.panelMode === PanelMode.High) ?
        Visibility.Visible : Visibility.None)
      .margin({
        right: 8
      })
      .onClick(() => {
        this.resetSearch();
      })

      Stack({ alignContent: Alignment.End }) {
        Stack({ alignContent: Alignment.Start }) {
          TextInput({ placeholder: $r('app.string.poi_textInput_holder'), text: this.searchInput })
            .width(Common.FULL_WIDTH)
            .height(Common.FULL_HEIGHT)
            .enableKeyboardOnFocus(false)
            .expandSafeArea([SafeAreaType.KEYBOARD])
            .padding({
              left: 36,
              right: 12
            })
            .onChange((value: string) => this.searchInput = value)
            .onSubmit(async () => {
              let keyword: string = this.searchInput.trim();
              if (keyword.length === 0) {
                this.searchInput = '';
                return;
              }
              this.searchInput = keyword;
              let shouldOpenSearchPage: boolean = !this.isSearchResultPage();
              if (shouldOpenSearchPage) {
                this.pageInfo.pushPathByName(PanelRouteName.SEARCH_RESULT, undefined);
              }
              await this.searchViewModel.submitSearch({
                keyword,
                currentLocation: this.currentLocation,
                mapController: this.mapController,
                waitForCurrentLocation: this.waitForCurrentLocation,
                onPanelModeChange: this.onPanelModeChange,
                onLoadingChange: (loading: boolean) => this.searchLoading = loading,
                onMapStateChange: (state: MapUiState) => this.mapUiState = state,
                onLocationResolved: (location: geoLocationManager.Location) => this.currentLocation = location,
                onSitesChange: (sites: site.Site[]) => this.sites = sites
              });
            })
            .onClick(() => {
              this.onPanelModeChange?.(PanelMode.High);
            })

          SymbolGlyph($r('sys.symbol.magnifyingglass'))
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor([$r('sys.color.icon_secondary')])
            .margin({ left: 12 })
        }

        if (this.isSearchResultPage()) {
          SymbolGlyph($r('sys.symbol.xmark'))
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor([$r('sys.color.font_secondary')])
            .margin({ right: 12 })
            .onClick(() => {
              this.resetSearch();
            })
        } else {
          SymbolGlyph($r('sys.symbol.mic'))
            .fontSize(16)
            .fontColor([$r('sys.color.font_secondary')])
            .margin({ right: 12 })
        }
      }
      .layoutWeight(1)
      .width((this.isSearchResultPage() && this.panelMode === PanelMode.High) ?
        HomeConstants.SEARCHBAR_WIDTH : Common.FULL_WIDTH)
      .height(Common.FULL_HEIGHT)
    }
    .height($r('app.float.search_height'))
  }
}
