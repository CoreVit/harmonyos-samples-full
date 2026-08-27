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

import { map, mapCommon, navi, site } from '@kit.MapKit';
import { MapSceneUtil, MapUiState, SelectedSite } from 'multitravelbase/Index';

interface SyncMapContentOptions {
  mapController: map.MapComponentController | undefined;
  mapUiState: MapUiState;
  selectedSite: SelectedSite | undefined;
  sites: site.Site[] | undefined;
  activeRouteRoads: navi.RouteRoad[];
  onEnsurePanelVisible: () => void;
}

interface RouteContextOptions {
  mapController: map.MapComponentController | undefined;
  selectedSite: SelectedSite | undefined;
  mapUiState: MapUiState;
  sites: site.Site[] | undefined;
  onEnsurePanelVisible: () => void;
  onActiveRouteRoadsChange: (roads: navi.RouteRoad[]) => void;
}

interface ShowRouteOptions extends RouteContextOptions {
  roads: navi.RouteRoad[];
}

@Observed
export class MapContainerPageViewModel {
  private mapSceneUtil: MapSceneUtil = new MapSceneUtil();
  private mapContentVersion: number = 0;
  private searchMarkerSites: Map<string, site.Site> = new Map<string, site.Site>();

  public syncMapContent(options: SyncMapContentOptions): void {
    options.onEnsurePanelVisible();
    let version: number = ++this.mapContentVersion;
    if (!options.mapController) {
      return;
    }
    if (this.renderRouteIfNeeded(options, version)) {
      return;
    }
    this.renderByState(options, version);
  }

  public showRoute(options: ShowRouteOptions): void {
    options.onActiveRouteRoadsChange(options.roads);
    this.syncMapContent({
      mapController: options.mapController,
      mapUiState: options.mapUiState,
      selectedSite: options.selectedSite,
      sites: options.sites,
      activeRouteRoads: options.roads,
      onEnsurePanelVisible: options.onEnsurePanelVisible
    });
    this.focusRoute(options.mapController, options.roads);
  }

  public clearRoute(options: RouteContextOptions): void {
    let emptyRoads: navi.RouteRoad[] = [];
    options.onActiveRouteRoadsChange(emptyRoads);
    this.syncMapContent({
      mapController: options.mapController,
      mapUiState: options.mapUiState,
      selectedSite: options.selectedSite,
      sites: options.sites,
      activeRouteRoads: emptyRoads,
      onEnsurePanelVisible: options.onEnsurePanelVisible
    });
  }

  public focusRoute(mapController: map.MapComponentController | undefined, roads: navi.RouteRoad[]): void {
    if (roads.length === 0) {
      return;
    }
    this.mapSceneUtil.focusOnRoute(mapController, this.getRoutePoints(roads));
  }

  private renderRouteIfNeeded(options: SyncMapContentOptions, version: number): boolean {
    if (options.activeRouteRoads.length === 0) {
      return false;
    }
    options.mapController?.clear();
    this.mapSceneUtil.drawRoute(options.mapController, this.getRoutePoints(options.activeRouteRoads), {
      canContinue: () => version === this.mapContentVersion && options.mapUiState === MapUiState.ROUTE_PLAN &&
        options.activeRouteRoads.length > 0
    });
    this.mapSceneUtil.showSiteMarker(options.mapController, options.selectedSite?.location, {
      clearMap: false,
      icon: $r('app.media.icon_marker_des')
    });
    return true;
  }

  private getRoutePoints(roads: navi.RouteRoad[]): mapCommon.LatLng[] {
    let points: mapCommon.LatLng[] = [];
    roads.forEach((road: navi.RouteRoad) => {
      road.polyline.forEach((point) => {
        points.push(point);
      });
    });
    return points;
  }

  private renderByState(options: SyncMapContentOptions, version: number): void {
    switch (options.mapUiState) {
      case MapUiState.HOME:
        this.renderHomeState(options);
        return;
      case MapUiState.SEARCH_RESULT:
        this.renderSearchResultState(options, version);
        return;
      case MapUiState.SITE_DETAIL:
        this.renderSiteDetailState(options);
        return;
      case MapUiState.ROUTE_PLAN:
        this.renderRoutePlanState(options);
        return;
      default:
        this.renderHomeState(options);
    }
  }

  private renderHomeState(options: SyncMapContentOptions): void {
    this.clearSearchMarkerSites();
    options.mapController?.clear();
  }

  private renderSearchResultState(options: SyncMapContentOptions, version: number): void {
    this.clearSearchMarkerSites();
    this.mapSceneUtil.showSiteMarkers(options.mapController, options.sites, {
      clearMap: true,
      icon: $r('app.media.icon_marker_sites'),
      showName: true,
      clickable: true,
      canContinue: () => version === this.mapContentVersion && options.mapUiState === MapUiState.SEARCH_RESULT &&
        options.activeRouteRoads.length === 0,
      onMarkerCreated: (marker: map.Marker, item: site.Site) => {
        if (version === this.mapContentVersion && options.mapUiState === MapUiState.SEARCH_RESULT) {
          this.searchMarkerSites.set(marker.getId(), item);
        }
      }
    });
    this.mapSceneUtil.focusOnSites(options.mapController, options.sites);
  }

  private renderSiteDetailState(options: SyncMapContentOptions): void {
    this.clearSearchMarkerSites();
    this.mapSceneUtil.showSiteMarker(options.mapController, options.selectedSite?.location, {
      clearMap: true,
      icon: $r('app.media.icon_marker_site_selected')
    });
    this.mapSceneUtil.focusOnSite(options.mapController, options.selectedSite?.location);
  }

  private renderRoutePlanState(options: SyncMapContentOptions): void {
    this.clearSearchMarkerSites();
    this.mapSceneUtil.showSiteMarker(options.mapController, options.selectedSite?.location, {
      clearMap: true,
      icon: $r('app.media.icon_marker_des')
    });
    this.mapSceneUtil.focusOnSite(options.mapController, options.selectedSite?.location);
  }

  public getSearchSiteByMarker(marker: map.Marker): site.Site | undefined {
    return this.searchMarkerSites.get(marker.getId());
  }

  public toSelectedSite(item: site.Site): SelectedSite {
    let openingHours: string = '';
    if (item.poi?.openingHours?.texts && item.poi.openingHours.texts.length > 0) {
      openingHours = item.poi.openingHours.texts[0].split(': ')[1] ?? item.poi.openingHours.texts[0];
    }
    return new SelectedSite(item.name, item.addressComponent?.adminLevel3 ?? '', item.distance ?? 0, item.location,
      openingHours, item.poi?.abstractText ?? '');
  }

  private clearSearchMarkerSites(): void {
    this.searchMarkerSites.clear();
  }
}
