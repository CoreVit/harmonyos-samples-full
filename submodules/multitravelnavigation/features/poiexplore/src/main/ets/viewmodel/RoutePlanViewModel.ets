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
import { BusinessError } from '@kit.BasicServicesKit';
import { navi } from '@kit.MapKit';
import { LocationUtil, Logger, SelectedSite } from 'multitravelbase/Index';
import { RoutePlanningService } from '../model/service/RoutePlanningService';

const TAG = 'RoutePlanViewModel';

@Observed
export class RoutePlanViewModel {
  public routes: navi.Route[] = [];
  public terminalPoint: string = '';
  public loading: boolean = false;
  public errorMsg?: ResourceStr = undefined;

  private routePlanningService: RoutePlanningService = new RoutePlanningService();

  public reset(): void {
    this.routes = [];
    this.terminalPoint = '';
    this.loading = false;
    this.errorMsg = undefined;
  }

  public async loadRoutes(destination: SelectedSite | undefined,
    currentLocation?: geoLocationManager.Location,
    waitForCurrentLocation?: () => Promise<geoLocationManager.Location | undefined>,
    onLocationResolved?: (location: geoLocationManager.Location) => void): Promise<navi.RouteRoad[] | undefined> {
    this.reset();
    if (!destination) {
      this.errorMsg = $r('app.string.route_error_destination_not_selected');
      return undefined;
    }
    this.terminalPoint = destination.name;
    this.loading = true;
    try {
      let beginPoint: geoLocationManager.Location | undefined = currentLocation;
      if (!beginPoint) {
        beginPoint = await waitForCurrentLocation?.();
      }
      if (!beginPoint && !waitForCurrentLocation) {
        beginPoint = await LocationUtil.getLocation();
        if (beginPoint) {
          onLocationResolved?.(beginPoint);
        }
      }
      if (!beginPoint) {
        this.errorMsg = $r('app.string.route_error_current_location_failed');
        return undefined;
      }

      let routeResult: navi.RouteResult | undefined = await this.routePlanningService.getDrivingRoutes(beginPoint,
        destination);
      if (!routeResult || !routeResult.routes || routeResult.routes.length === 0) {
        this.errorMsg = $r('app.string.route_error_no_routes');
        return undefined;
      }

      this.routes = routeResult.routes;
      let roads: navi.RouteRoad[] = this.collectRoads(routeResult.routes[0]);
      if (roads.length === 0) {
        this.errorMsg = $r('app.string.route_error_empty_roads');
        return undefined;
      }
      return roads;
    } catch (e) {
      let err = e as BusinessError;
      Logger.error(TAG, `loadRoutes fail, error code=${err.code}, message=${err.message}`);
      this.errorMsg = $r('app.string.route_error_failed');
      return undefined;
    } finally {
      this.loading = false;
    }
  }

  public getTotalTime(route: navi.Route): number {
    return this.routePlanningService.getTotalTime(route);
  }

  public getTotalDistance(route: navi.Route): number {
    return this.routePlanningService.getTotalDistance(route);
  }

  private collectRoads(route: navi.Route): navi.RouteRoad[] {
    let roads: navi.RouteRoad[] = [];
    if (!route || !route.steps) {
      return roads;
    }
    route.steps.forEach((step) => {
      if (step.roads && step.roads.length > 0) {
        step.roads.forEach((road) => {
          roads.push(road);
        });
      }
    });
    return roads;
  }
}
