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

import { AsyncCallback, BusinessError } from '@kit.BasicServicesKit';
import { geoLocationManager } from '@kit.LocationKit';
import { MapComponent, map, mapCommon } from '@kit.MapKit';
import { CommonConstants, Logger, LocationUtil, WindowInfo } from 'multitravelbase/Index';

const DEFAULT_LATITUDE: number = 39.91;
const DEFAULT_LONGITUDE: number = 116.3975;
const COMPASS_SIZE: number = 48;
const COMPASS_RIGHT_MARGIN: number = 16;
const TAG = 'BaseMapView';

@Component
export struct BaseMapView {
  @Link currentLocation: geoLocationManager.Location | undefined;
  @Link mapController: map.MapComponentController | undefined;
  @ObjectLink mainWindowInfo: WindowInfo;
  @Prop isBottomSheet: boolean = false;
  onMapReady?: (mapController: map.MapComponentController) => void;
  onInitialLocationRequest?: (promise: Promise<geoLocationManager.Location | undefined>) => void;
  requestCurrentLocation?: () => Promise<geoLocationManager.Location | undefined>;
  onMapMove?: () => void;
  onMapIdle?: () => void;
  onMapClick?: () => void;
  onMarkerClick?: (marker: map.Marker) => void;

  private mapOptions?: mapCommon.MapOptions;
  private mapCallback?: AsyncCallback<map.MapComponentController>;
  private mapEventManager?: map.MapEventManager;
  private initialCameraLocated: boolean = false;
  private mapLoadCallback: () => void = () => {
    Logger.info(TAG, 'on-mapLoad');
  };
  private cameraMoveCallback: () => void = () => {
    this.onMapMove?.();
  };
  private cameraIdleCallback: () => void = () => {
    this.onMapIdle?.();
  };
  private mapClickCallback: (location: mapCommon.LatLng) => void = () => {
    this.onMapClick?.();
  };
  private markerClickCallback: (marker: map.Marker) => void = (marker: map.Marker) => {
    this.onMarkerClick?.(marker);
  };

  aboutToAppear(): void {
    this.mapOptions = {
      position: {
        target: {
          latitude: DEFAULT_LATITUDE,
          longitude: DEFAULT_LONGITUDE
        },
        zoom: CommonConstants.ZOOM
      },
      dayNightMode: mapCommon.DayNightMode.AUTO
    };

    this.mapCallback = async (err, mapController) => {
      if (err) {
        return;
      }
      this.mapController = mapController;
      await this.enableMapAbility();

      this.mapEventManager = mapController.getEventManager();
      this.mapEventManager?.on('mapLoad', this.mapLoadCallback);
      this.mapEventManager?.on('cameraMove', this.cameraMoveCallback);
      this.mapEventManager?.on('cameraIdle', this.cameraIdleCallback);
      this.onMapReady?.(mapController);
      this.mapEventManager?.on('mapClick', this.mapClickCallback);
      this.mapEventManager?.on('markerClick', this.markerClickCallback);
      this.startInitialLocation();
    };
  }

  aboutToDisappear(): void {
    this.onDestroy();
  }

  private onDestroy(): void {
    this.mapEventManager?.off('mapLoad', this.mapLoadCallback);
    this.mapEventManager?.off('cameraMove', this.cameraMoveCallback);
    this.mapEventManager?.off('cameraIdle', this.cameraIdleCallback);
    this.mapEventManager?.off('mapClick', this.mapClickCallback);
    this.mapEventManager?.off('markerClick', this.markerClickCallback);
    this.mapEventManager = undefined;
  }

  async enableMapAbility(): Promise<void> {
    try {
      this.mapController?.setMyLocationEnabled(true);
      this.mapController?.setMyLocationControlsEnabled(true);
      this.mapController?.setTrafficEnabled(true);
      this.mapController?.setBuildingEnabled(true);
      this.mapController?.setCompassPosition(this.getCompassPosition());
      if (this.isBottomSheet) {
        this.mapController?.setZoomControlsEnabled(false);
      }
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `enableMapAbility failed, error code=${err.code}, message=${err.message}`);
    }
  }

  private getCompassPosition(): mapCommon.MapPoint {
    let rightMargin: number = this.getUIContext().vp2px(COMPASS_RIGHT_MARGIN);
    let compassSize: number = this.getUIContext().vp2px(COMPASS_SIZE);
    let windowWidth: number = this.mainWindowInfo.windowSize.width;
    let topAvoid: number = this.mainWindowInfo.avoidSystem?.topRect.height ?? 0;
    let positionX: number = windowWidth > 0 ? windowWidth - compassSize - rightMargin : rightMargin;
    return {
      positionX: Math.max(rightMargin, positionX),
      positionY: topAvoid
    };
  }

  private applyCurrentLocationToMap(location: geoLocationManager.Location): void {
    void this.enableMapAbility();
    try {
      this.mapController?.setMyLocation(location);
      Logger.info(TAG, 'applyCurrentLocationToMap setMyLocation success');
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `applyCurrentLocationToMap setMyLocation failed, error code=${err.code}, message=${err.message}`);
    }
    this.moveCameraToInitialLocation(location);
    void this.switchToTrackingStyle();
  }

  private createMyLocationStyle(displayType: mapCommon.MyLocationDisplayType): mapCommon.MyLocationStyle {
    return {
      anchorU: 0.5,
      anchorV: 0.5,
      icon: $r('app.media.icon_myLocation'),
      radiusFillColor: 0xff00FFFFFF,
      displayType
    };
  }

  private async startInitialLocation(): Promise<void> {
    if (this.currentLocation) {
      this.applyCurrentLocationToMap(this.currentLocation);
      return;
    }
    await this.switchToInitialLocateStyle();
    let locationPromise: Promise<geoLocationManager.Location | undefined> =
      this.requestCurrentLocation?.() ?? LocationUtil.getLocation();
    this.onInitialLocationRequest?.(locationPromise);
    locationPromise.then((location: geoLocationManager.Location | undefined) => {
      if (!location) {
        this.switchToTrackingStyle();
        return;
      }
      Logger.info(TAG, 'get initial location success');
      this.currentLocation = location;
      this.applyCurrentLocationToMap(location);
    });
  }

  private async switchToInitialLocateStyle(): Promise<void> {
    try {
      await this.mapController?.setMyLocationStyle(
        this.createMyLocationStyle(mapCommon.MyLocationDisplayType.LOCATE));
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `switchToInitialLocateStyle failed, error code=${err.code}, message=${err.message}`);
    }
  }

  private async switchToTrackingStyle(): Promise<void> {
    try {
      await this.mapController?.setMyLocationStyle(
        this.createMyLocationStyle(mapCommon.MyLocationDisplayType.TRACK_ROTATE));
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `switchToTrackingStyle failed, error code=${err.code}, message=${err.message}`);
    }
  }

  private moveCameraToInitialLocation(location: geoLocationManager.Location): void {
    if (this.initialCameraLocated || !this.mapController) {
      return;
    }
    this.initialCameraLocated = true;
    try {
      let origin: mapCommon.LatLng = {
        latitude: location.latitude,
        longitude: location.longitude
      };
      let mapLocation: mapCommon.LatLng =
        map.convertCoordinateSync(mapCommon.CoordinateType.WGS84, mapCommon.CoordinateType.GCJ02, origin);
      this.mapController.animateCamera(map.newLatLng(mapLocation, CommonConstants.ZOOM), CommonConstants.DURATION);
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `moveCameraToInitialLocation failed, error code=${err.code}, message=${err.message}`);
    }
  }

  build() {
    MapComponent({
      mapOptions: this.mapOptions,
      mapCallback: this.mapCallback,
    })
      .width('100%')
      .height('100%')
  }
}
