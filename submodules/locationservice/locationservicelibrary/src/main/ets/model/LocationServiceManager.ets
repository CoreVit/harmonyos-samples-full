/*
* Copyright (c) 2024 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the 'License');
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an 'AS IS' BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import { geoLocationManager } from '@kit.LocationKit';
import { map, mapCommon } from '@kit.MapKit';
import { AsyncCallback } from '@kit.BasicServicesKit';
import { connection } from '@kit.NetworkKit';
import { CommonConstants } from '../constants/CommonConstants';
import Toast from '../utils/Toast';
import Logger from '../utils/Logger';

export const TAG: string = '[LocationServiceManager]';

@Observed
export class LocationServiceManager {
  public mapCallback?: AsyncCallback<map.MapComponentController>;
  public mapOption?: mapCommon.MapOptions;
  public address: string = '';
  private uiContext?: UIContext;
  private mapController?: map.MapComponentController;
  private mapMarker?: map.Marker;

  /**
   * Init locationServiceManager
   */
  public init(uiContext: UIContext) {
    this.uiContext = uiContext;
    const cameraPosition: mapCommon.CameraPosition = {
      target: { longitude: 113.886642, latitude: 22.878538 },
      zoom: 15
    };
    this.mapOption = {
      position: cameraPosition,
      scaleControlsEnabled: true,
      dayNightMode: mapCommon.DayNightMode.AUTO
    };

    this.mapCallback = async (err, mapController) => {
      if (!err) {
        this.mapController = mapController;
      }
    };
  }

  /**
   * Get current location information
   */
  public async showCurrentLocation() {
    if (!this.isPreCheckOK()) {
      return;
    }
    const mapLocation = await this.getCurrentPosition();
    this.updateMapCamera(mapLocation);
    this.updateMapMarker(mapLocation);
  }

  /**
   * Get cached location information
   */
  public async showCacheLocation() {
    if (!this.isPreCheckOK()) {
      return;
    }
    const mapLocation = this.getLastPosition();
    this.updateMapCamera(mapLocation);
    this.updateMapMarker(mapLocation);
  }

  /*
   * Clear map controller
   */
  public clear() {
    this.mapController?.clear();
  }

  private isPreCheckOK(): boolean {
    if (!this.isConnected()) {
      Toast.showToast($r('app.string.internet_switch'), this.uiContext!);
    }
    if (!this.isLocationEnable()) {
      Toast.showToast($r('app.string.location_switch'), this.uiContext!);
    }
    return this.isConnected() && this.isLocationEnable();
  }

  private isConnected(): boolean {
    try {
      const netHandle: connection.NetHandle = connection.getDefaultNetSync();
      if (!netHandle || netHandle.netId <= 0) {
        return false;
      }
      const netCapability = connection.getNetCapabilitiesSync(netHandle);
      const cap: connection.NetCap[] = netCapability.networkCap || [];
      return cap.includes(connection.NetCap.NET_CAPABILITY_VALIDATED);
    } catch (err) {
      Logger.error(TAG, `Failed to connect netwoek, code: ${err.code}, message: ${err.message}`);
      return false;
    }
  }

  private isLocationEnable(): boolean {
    try {
      return geoLocationManager.isLocationEnabled();
    } catch (err) {
      Logger.error(TAG, `location unable, code: ${err.code}, message: ${err.message}`);
      return false;
    }
  }

  private async updateMapMarker(mapLocation: mapCommon.LatLng) {
    try {
      const reverseGeocodeRequest: geoLocationManager.ReverseGeoCodeRequest = {
        locale: this.uiContext?.getHostContext()?.resourceManager.getStringSync($r('app.string.language').id),
        latitude: mapLocation.latitude,
        longitude: mapLocation.longitude,
        maxItems: 1
      };

      const geoAddress = await geoLocationManager.getAddressesFromLocation(reverseGeocodeRequest);
      this.address = geoAddress[0]?.placeName ?? '';

      const makerOptions: mapCommon.MarkerOptions = {
        position: mapLocation,
        icon: $r('app.media.point'),
        clickable: true,
        title: this.uiContext?.getHostContext()?.resourceManager.getStringSync($r('app.string.geocoded_location').id),
        snippet: this.address
      };
      if (this.mapMarker) {
        this.mapMarker.setPosition(mapLocation);
        this.mapMarker.setSnippet(this.address);
      } else {
        this.mapMarker = await this.mapController?.addMarker(makerOptions);
      }
      this.mapMarker?.setInfoWindowVisible(true);
    } catch (err) {
      Logger.error(TAG, `fail to update mapMarker, code: ${err.code}, message: ${err.message}`);
    }
  }

  private updateMapCamera(mapLocation: mapCommon.LatLng) {
    const cameraPosition: mapCommon.CameraPosition = {
      target: mapLocation,
      zoom: 15,
      tilt: 0,
      bearing: 0
    };
    const cameraUpdate: map.CameraUpdate = map.newCameraPosition(cameraPosition);
    this.mapController?.animateCamera(cameraUpdate, 100);
  }

  private async getCurrentPosition(): Promise<mapCommon.LatLng> {
    const request: geoLocationManager.SingleLocationRequest = {
      locatingPriority: CommonConstants.PRIORITY_LOCATING_SPEED,
      locatingTimeoutMs: CommonConstants.LOCATING_TIMEOUT_MS
    };
    try {
      const location = await geoLocationManager.getCurrentLocation(request);
      return map.convertCoordinateSync(mapCommon.CoordinateType.WGS84, mapCommon.CoordinateType.GCJ02, location);
    } catch (err) {
      Logger.error(TAG, `getCurrentPosition error, code: ${err.code}, message: ${err.message}`);
      return { latitude: 0, longitude: 0 };
    }

  }

  private getLastPosition(): mapCommon.LatLng {
    try {
      const location = geoLocationManager.getLastLocation();
      return map.convertCoordinateSync(mapCommon.CoordinateType.WGS84, mapCommon.CoordinateType.GCJ02, location);
    } catch (err) {
      Logger.error(TAG, `getLastPosition error, code: ${err.code}, message: ${err.message}`);
      return { latitude: 0, longitude: 0 };
    }
  }
}


@Builder
export function customInfoWindowBuilder(params: map.MarkerDelegate) {
  if (params.marker) {
    Column() {
      Text(params.marker.getTitle())
        .width(180)
        .height(24)
        .backgroundColor($r('app.color.green'))
        .borderRadius({
          topLeft: 12,
          topRight: 12
        })
        .padding({
          top: 4,
          bottom: 4,
          left: 12
        })
        .fontSize(12)
        .fontColor($r('app.color.white_e6'))
        .lineHeight(16)
        .textAlign(TextAlign.Start)
      Text(params.marker.getSnippet())
        .width(180)
        .backgroundColor(Color.White)
        .borderRadius({
          bottomLeft: 12,
          bottomRight: 12
        })
        .padding({
          top: 4,
          bottom: 6,
          left: 12,
          right: 8
        })
        .fontSize(14)
        .fontColor($r('app.color.black_e6'))
        .lineHeight(19)
        .textAlign(TextAlign.Start)
    }
  }
}
