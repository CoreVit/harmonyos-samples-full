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
import { map, mapCommon, site } from '@kit.MapKit';
import { LocationUtil, MapSceneUtil, MapUiState, PanelMode, SelectedSite } from 'multitravelbase/Index';
import { SiteSearchRepository } from '../model/repository/SiteSearchRepository';
import { PoiSelectionService } from '../model/service/PoiSelectionService';

const DEFAULT_LATITUDE: number = 39.91;
const DEFAULT_LONGITUDE: number = 116.3975;

interface ResetSearchOptions {
  onLoadingChange: (loading: boolean) => void;
  onKeywordChange: (keyword: string) => void;
  onSitesChange: (sites: site.Site[]) => void;
  onMapStateChange: (state: MapUiState) => void;
  onClearPage: () => void;
}

interface SubmitSearchOptions {
  keyword: string;
  currentLocation: geoLocationManager.Location | undefined;
  mapController: map.MapComponentController;
  waitForCurrentLocation?: () => Promise<geoLocationManager.Location | undefined>;
  onPanelModeChange?: (mode: PanelMode) => void;
  onLoadingChange: (loading: boolean) => void;
  onMapStateChange: (state: MapUiState) => void;
  onLocationResolved: (location: geoLocationManager.Location) => void;
  onSitesChange: (sites: site.Site[]) => void;
}

interface SelectSiteOptions {
  item: site.Site;
  mapController: map.MapComponentController;
  onPanelModeChange?: (mode: PanelMode) => void;
  onSelectedSiteChange: (site: SelectedSite) => void;
  onMapStateChange: (state: MapUiState) => void;
  onOpenSiteDetail: () => void;
}

@Observed
export class SearchViewModel {
  private siteSearchRepository: SiteSearchRepository = new SiteSearchRepository();
  private mapSceneUtil: MapSceneUtil = new MapSceneUtil();
  private poiSelectionService: PoiSelectionService = new PoiSelectionService();

  public resetSearch(options: ResetSearchOptions): void {
    options.onLoadingChange(false);
    options.onKeywordChange('');
    options.onSitesChange([]);
    options.onMapStateChange(MapUiState.HOME);
    options.onClearPage();
  }

  public async submitSearch(options: SubmitSearchOptions): Promise<void> {
    let keyword: string = options.keyword.trim();
    if (keyword.length === 0) {
      return;
    }
    options.onLoadingChange(true);
    options.onMapStateChange(MapUiState.SEARCH_RESULT);
    options.onPanelModeChange?.(PanelMode.Half);
    try {
      let location: geoLocationManager.Location | undefined =
        await this.resolveLocation(options.currentLocation, options.waitForCurrentLocation);
      if (location && options.currentLocation !== location) {
        options.onLocationResolved(location);
      }
      let position: mapCommon.LatLng = this.toLatLng(location);
      let searchResult: site.SearchByTextResult | undefined =
        await this.siteSearchRepository.searchByText(position, keyword);
      options.onSitesChange(searchResult?.sites ?? []);
    } finally {
      options.onLoadingChange(false);
    }
  }

  public selectSite(options: SelectSiteOptions): void {
    let selectedSite: SelectedSite = this.poiSelectionService.toSelectedSite(options.item);
    options.onPanelModeChange?.(PanelMode.Half);
    options.onSelectedSiteChange(selectedSite);
    this.mapSceneUtil.focusOnSite(options.mapController, selectedSite.location);
    options.onMapStateChange(MapUiState.SITE_DETAIL);
    options.onOpenSiteDetail();
  }

  public getSiteOpeningHours(item: site.Site): string {
    return this.poiSelectionService.getOpeningHours(item);
  }

  public getSiteAddress(item: site.Site): string {
    return this.poiSelectionService.getSiteAddress(item);
  }

  public getSiteDistance(item: site.Site): number {
    return this.poiSelectionService.getSiteDistance(item);
  }

  private async resolveLocation(currentLocation: geoLocationManager.Location | undefined,
    waitForCurrentLocation?: () => Promise<geoLocationManager.Location | undefined>
  ): Promise<geoLocationManager.Location | undefined> {
    let location: geoLocationManager.Location | undefined = currentLocation;
    if (!location) {
      location = await waitForCurrentLocation?.();
    }
    if (!location && !waitForCurrentLocation) {
      location = await LocationUtil.getLocation();
    }
    return location;
  }

  private toLatLng(location: geoLocationManager.Location | undefined): mapCommon.LatLng {
    if (location) {
      return {
        longitude: location.longitude,
        latitude: location.latitude
      };
    }
    return {
      longitude: DEFAULT_LONGITUDE,
      latitude: DEFAULT_LATITUDE
    };
  }
}
