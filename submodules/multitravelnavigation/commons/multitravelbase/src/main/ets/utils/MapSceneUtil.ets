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

import { BusinessError } from '@kit.BasicServicesKit';
import { map, mapCommon, site } from '@kit.MapKit';
import { CommonConstants } from '../constants/CommonConstants';
import Logger from './Logger';

const ROUTE_OUTLINE_COLOR: number = 0xFF089C57;
const ROUTE_FILL_COLOR: number = 0xFF08C76E;
const ROUTE_OUTLINE_WIDTH: number = 34;
const ROUTE_FILL_WIDTH: number = 26;
const ROUTE_ARROW_WIDTH: number = 26;
const ROUTE_OUTLINE_Z_INDEX: number = 10;
const ROUTE_FILL_Z_INDEX: number = 11;
const ROUTE_ARROW_Z_INDEX: number = 12;
const TAG = 'MapSceneUtil';

interface SiteMarkerOptions {
  clearMap?: boolean;
  icon?: ResourceStr;
  annotationContent?: string;
  annotationPosition?: mapCommon.TextPosition;
}

interface SiteMarkersOptions {
  clearMap?: boolean;
  icon?: ResourceStr;
  showName?: boolean;
  clickable?: boolean;
  canContinue?: () => boolean;
  onMarkerCreated?: (marker: map.Marker, item: site.Site) => void;
}

interface DrawRouteOptions {
  canContinue?: () => boolean;
}

export class MapSceneUtil {
  public async drawRoute(mapController: map.MapComponentController | undefined,
    points: mapCommon.LatLng[], options: DrawRouteOptions = {}): Promise<void> {
    if (!mapController || points.length === 0) {
      Logger.info(TAG, 'Drawing failed');
      return;
    }

    let routeOutlineOption: mapCommon.MapPolylineOptions = {
      points,
      color: ROUTE_OUTLINE_COLOR,
      jointType: mapCommon.JointType.ROUND,
      width: ROUTE_OUTLINE_WIDTH,
      startCap: mapCommon.CapStyle.ROUND,
      endCap: mapCommon.CapStyle.ROUND,
      zIndex: ROUTE_OUTLINE_Z_INDEX
    };
    let routeFillOption: mapCommon.MapPolylineOptions = {
      points,
      color: ROUTE_FILL_COLOR,
      jointType: mapCommon.JointType.ROUND,
      width: ROUTE_FILL_WIDTH,
      startCap: mapCommon.CapStyle.ROUND,
      endCap: mapCommon.CapStyle.ROUND,
      zIndex: ROUTE_FILL_Z_INDEX
    };
    let routeArrowLineOption: mapCommon.MapPolylineOptions = {
      points,
      jointType: mapCommon.JointType.ROUND,
      width: ROUTE_ARROW_WIDTH,
      startCap: mapCommon.CapStyle.BUTT,
      endCap: mapCommon.CapStyle.BUTT,
      customTextures: [$r('app.media.route_arrow_tile')],
      customTextureIndexes: this.createTextureIndexes(points),
      zIndex: ROUTE_ARROW_Z_INDEX
    };
    try {
      if (options.canContinue && !options.canContinue()) {
        return;
      }
      await mapController.addPolyline(routeOutlineOption);
      if (options.canContinue && !options.canContinue()) {
        return;
      }
      await mapController.addPolyline(routeFillOption);
      if (options.canContinue && !options.canContinue()) {
        return;
      }
      await mapController.addPolyline(routeArrowLineOption);
      Logger.info(TAG, 'Drawing success');
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `addPolyline failed, error code=${err.code}, message=${err.message}`);
    }
  }

  private createTextureIndexes(points: mapCommon.LatLng[]): number[] {
    let textureIndexes: number[] = [];
    points.forEach(() => {
      textureIndexes.push(0);
    });
    return textureIndexes;
  }

  public focusOnSite(mapController: map.MapComponentController | undefined,
    location: mapCommon.LatLng | undefined): void {
    if (!mapController || !location) {
      return;
    }
    try {
      mapController.animateCamera(map.newLatLng(location, CommonConstants.ZOOM), CommonConstants.DURATION);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `focusOnSite failed, error code=${err.code}, message=${err.message}`);
    }
  }

  public async showSiteMarker(mapController: map.MapComponentController | undefined,
    location: mapCommon.LatLng | undefined,
    options: SiteMarkerOptions = {}): Promise<map.Marker | undefined> {
    if (!mapController || !location) {
      return undefined;
    }
    if (options.clearMap ?? true) {
      mapController.clear();
    }
    try {
      let markerOptions: mapCommon.MarkerOptions = {
        position: location,
        anchorU: 0.5,
        anchorV: 0.5,
        visible: true,
        clickable: false,
        draggable: false,
        icon: options.icon ?? $r('app.media.icon_marker')
      };
      if (options.annotationContent) {
        markerOptions.annotations = [{
          content: options.annotationContent,
          fontSize: 12,
          strokeWidth: 1,
          fontStyle: 0
        }];
        markerOptions.annotationPosition = options.annotationPosition ?? mapCommon.TextPosition.RIGHT;
        markerOptions.collisionRule = mapCommon.CollisionRule.ALL;
      }
      return await mapController.addMarker(markerOptions);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `showSiteMarker failed, error code=${err.code}, message=${err.message}`);
      return undefined;
    }
  }

  public async showSiteMarkers(mapController: map.MapComponentController | undefined,
    sites: site.Site[] | undefined,
    options: SiteMarkersOptions = {}): Promise<void> {
    if (!mapController) {
      return;
    }
    if (options.clearMap ?? true) {
      mapController.clear();
    }
    if (!sites || sites.length === 0) {
      return;
    }
    try {
      for (const item of sites) {
        if (options.canContinue && !options.canContinue()) {
          return;
        }
        if (!item.location) {
          continue;
        }
        let markerOptions: mapCommon.MarkerOptions = {
          position: item.location,
          anchorU: 0.5,
          anchorV: 0.5,
          visible: true,
          clickable: options.clickable ?? false,
          draggable: false,
          icon: options.icon ?? $r('app.media.icon_marker')
        };
        if (options.showName && item.name) {
          markerOptions.annotations = [{
            content: item.name,
            fontSize: 12,
            strokeWidth: 1,
            fontStyle: 0
          }];
          markerOptions.annotationPosition = mapCommon.TextPosition.RIGHT;
          markerOptions.collisionRule = mapCommon.CollisionRule.ALL;
        }
        let marker: map.Marker = await mapController.addMarker(markerOptions);
        options.onMarkerCreated?.(marker, item);
      }
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `showSiteMarkers failed, error code=${err.code}, message=${err.message}`);
    }
  }

  public focusOnSites(mapController: map.MapComponentController | undefined,
    sites: site.Site[] | undefined): void {
    if (!sites || sites.length === 0) {
      return;
    }
    let points: mapCommon.LatLng[] = [];
    sites.forEach((item: site.Site) => {
      if (item.location) {
        points.push(item.location);
      }
    });
    this.focusOnPoints(mapController, points);
  }

  public focusOnRoute(mapController: map.MapComponentController | undefined, points: mapCommon.LatLng[]): void {
    this.focusOnPoints(mapController, points);
  }

  private focusOnPoints(mapController: map.MapComponentController | undefined, points: mapCommon.LatLng[]): void {
    if (!mapController || points.length === 0) {
      return;
    }
    if (points.length === 1) {
      this.focusOnSite(mapController, points[0]);
      return;
    }

    let minLatitude: number = points[0].latitude;
    let maxLatitude: number = points[0].latitude;
    let minLongitude: number = points[0].longitude;
    let maxLongitude: number = points[0].longitude;
    points.forEach((point: mapCommon.LatLng) => {
      minLatitude = Math.min(minLatitude, point.latitude);
      maxLatitude = Math.max(maxLatitude, point.latitude);
      minLongitude = Math.min(minLongitude, point.longitude);
      maxLongitude = Math.max(maxLongitude, point.longitude);
    });

    let bounds: mapCommon.LatLngBounds = {
      northeast: {
        latitude: maxLatitude,
        longitude: maxLongitude
      },
      southwest: {
        latitude: minLatitude,
        longitude: minLongitude
      }
    };

    try {
      let cameraUpdate = map.newLatLngBounds(bounds, 50);
      mapController.animateCamera(cameraUpdate, CommonConstants.DURATION);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `focusOnPoints failed, error code=${err.code}, message=${err.message}`);
    }
  }
}
