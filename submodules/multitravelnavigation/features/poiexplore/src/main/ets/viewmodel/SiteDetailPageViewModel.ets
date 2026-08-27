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
import { MapSceneUtil, MapUiState, SelectedSite } from 'multitravelbase/Index';
import { SITE_LIST, SiteInfo } from '../model/data/SiteDetailData';

@Observed
export class SiteDetailPageViewModel {
  public siteList: SiteInfo[] = SITE_LIST;

  private mapSceneUtil: MapSceneUtil = new MapSceneUtil();

  public async enterPage(selectedSite: SelectedSite | undefined, mapController: map.MapComponentController | undefined,
    onMapStateChange: (state: MapUiState) => void): Promise<void> {
    await this.mapSceneUtil.showSiteMarker(mapController, selectedSite?.location, {
      icon: $r('app.media.icon_marker_site_selected')
    });
    this.mapSceneUtil.focusOnSite(mapController, selectedSite?.location);
    onMapStateChange(MapUiState.SITE_DETAIL);
  }

  public leavePage(currentState: MapUiState, onMapStateChange: (state: MapUiState) => void): void {
    if (currentState === MapUiState.ROUTE_PLAN) {
      return;
    }
    onMapStateChange(MapUiState.SEARCH_RESULT);
  }

  public openRoutePlan(selectedSite: SelectedSite | undefined,
    onMapStateChange: (state: MapUiState) => void, onOpenRoutePlan: () => void): void {
    if (!selectedSite) {
      return;
    }
    onMapStateChange(MapUiState.ROUTE_PLAN);
    onOpenRoutePlan();
  }
}
