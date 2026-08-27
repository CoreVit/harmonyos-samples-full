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

import { ScanViewModel } from '../viewmodel/ScanViewModel';
import { CommonConstants, getWindowInfoState, Logger, WindowInfo } from 'multimobilepaymentbase';
import { abilityAccessCtrl, common, PermissionRequestResult, bundleManager } from '@kit.AbilityKit';
import { customScan, scanBarcode, scanCore } from '@kit.ScanKit';
import { ScanModel } from '../model/ScanModel';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = 'ScanSheetView';

/**
 * Scan sheet view component
 * Provides camera-based scanning functionality with custom UI
 * Supports scan, recognize, and AR modes
 */
@ComponentV2
export struct ScanSheetView {
  @Require @Param viewModel: ScanViewModel;
  @Param isCenterMode: boolean = false;
  @Event onClose: () => void = () => {
  };
  @Event onPaymentClick: () => void = () => {
  };
  @Local selectedTabIndex: number = 0;
  private mXComponentController: XComponentController = new XComponentController();
  @Local userGrant: boolean = false; // Whether camera permission has been requested
  @Local isShowPermissionDialog: boolean = false; // Whether to show permission guide dialog
  @Local permissionMessage: string = ''; // Permission guide message
  @Local surfaceId: string = ''; // XComponent generated surface id
  @Local cameraHeight: number = CommonConstants.INIT_CAMERA_HEIGHT; // Preview stream height, default unit: vp
  @Local cameraWidth: number = CommonConstants.INIT_CAMERA_WIDTH; // Preview stream width, default unit: vp
  @Local scanResult: Array<scanBarcode.ScanResult> = []; // Scan result
  @Local windowInfo: WindowInfo = getWindowInfoState();
  private scanList: ScanModel[] = new ScanViewModel().getScanList();

  async aboutToAppear(): Promise<void> {
    await this.requestCameraPermission();
    this.initCustomScan();
  }

  aboutToDisappear(): void {
    this.customScanStop();
    try {
      if (canIUse('SystemCapability.Multimedia.Scan.ScanBarcode')) {
        customScan.release().catch((error: BusinessError) => {
          Logger.error(TAG,
            `Failed to release customScan by promise. Code: ${error.code}, message: ${error.message}`);
        })
      }
    } catch (error) {
      Logger.error(TAG, `Failed to release customScan. Code: ${error.code}, message: ${error.message}`);
    }
  }

  // Check if camera permission has been granted
  checkCameraPermissionGrant(): boolean {
    let hasPermission = false;
    let tokenId: number = 0;
    try {
      let bundleInfo: bundleManager.BundleInfo =
        bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
      let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
      tokenId = appInfo.accessTokenId;
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG,
        `Failed to get bundle info for self. Code is ${err.code}, message is ${err.message}`);
    }

    try {
      let atManager = abilityAccessCtrl.createAtManager();
      let cameraPermission = atManager.checkAccessTokenSync(tokenId, 'ohos.permission.CAMERA');
      hasPermission = cameraPermission === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED;
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `Failed to check access token. Code is ${err.code}, message is ${err.message}`);
    }
    return hasPermission;
  }

  // Open permission setting page
  private openCameraPermissionSetting(): void {
    let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    let atManager = abilityAccessCtrl.createAtManager();
    atManager.requestPermissionOnSetting(context, ['ohos.permission.CAMERA']).then((data: Array<abilityAccessCtrl.GrantStatus>) => {
      if (data[0] === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
        this.userGrant = true;
        this.initCustomScan();
        this.isShowPermissionDialog = false;
      } else {
        this.isShowPermissionDialog = true;
        this.permissionMessage = 'Camera permission is required to use the scan function';
      }
    }).catch((err: BusinessError) => {
      Logger.error(TAG, `Failed to requestPermissionOnSetting. Code is ${err.code}, message is ${err.message}`);
    });
  }

  // Request permissions from user
  async reqPermissionsFromUser(): Promise<void> {
    Logger.info(TAG, 'reqPermissionsFromUser start');
    let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    let atManager = abilityAccessCtrl.createAtManager();
    try {
      const grantStatus: PermissionRequestResult =
        await atManager.requestPermissionsFromUser(context, ['ohos.permission.CAMERA']);
      if (grantStatus.authResults[0] === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
        // User authorized, can continue to access target operations
        Logger.info(TAG, 'Succeeded in getting permissions.');
        this.userGrant = true;
        this.isShowPermissionDialog = false;
      } else {
        // User denied permission
        if (grantStatus.dialogShownResults && grantStatus.dialogShownResults[0]) {
          // Dialog was shown but user denied
          this.isShowPermissionDialog = true;
          this.permissionMessage = 'Camera permission is required to use the scan function';
        } else {
          // Dialog was not shown, open permission setting
          this.openCameraPermissionSetting();
        }
      }
    } catch (error) {
      Logger.error(TAG, `Failed to requestPermissionsFromUser. Code: ${error.code}, message: ${error.message}`);
    }
  }

  // Request camera permission from user
  async requestCameraPermission() {
    let hasPermission = this.checkCameraPermissionGrant();
    if (hasPermission) {
      Logger.info(TAG, 'Camera permission already granted.');
      this.userGrant = true;
      this.isShowPermissionDialog = false;
    } else {
      Logger.info(TAG, 'Camera permission not granted, requesting...');
      await this.reqPermissionsFromUser();
    }
  }

  initCustomScan() {
    try {
      if (canIUse('SystemCapability.Multimedia.Scan.Core')) {
        let options: scanBarcode.ScanOptions = {
          scanTypes: [scanCore.ScanType.ALL],
          enableMultiMode: true,
          enableAlbum: true
        };
        if (canIUse('SystemCapability.Multimedia.Scan.ScanBarcode')) {
          customScan.init(options);
        }
      }
    } catch (error) {
      Logger.error(TAG, `Failed to init customScan. Code: ${error.code}, message: ${error.message}`);
    }
  }

  initCamera() {
    this.scanResult = [];
    let viewControl: customScan.ViewControl = {
      width: this.cameraWidth,
      height: this.cameraHeight,
      surfaceId: this.surfaceId
    };
    try {
      // request scan interface, callback via Promise
      if (canIUse('SystemCapability.Multimedia.Scan.ScanBarcode')) {
        customScan.start(viewControl)
          .then((result: Array<scanBarcode.ScanResult>) => {
            Logger.info(TAG, `result: ${JSON.stringify(result)}`);
            if (result.length) {
              // In practical application development, call customScan.stop() here
              // to pause the preview stream and process the QR code scanning results.
              this.scanResult = result;
            }
          }).catch((error: BusinessError) => {
          Logger.error(TAG, `Failed to start customScan. Code: ${error.code}, message: ${error.message}`);
        });
      }
    } catch (error) {
      Logger.error(TAG, `Failed to start customScan. Code: ${error.code}, message: ${error.message}`);
    }
  }

  customScanStop() {
    try {
      if (canIUse('SystemCapability.Multimedia.Scan.ScanBarcode')) {
        customScan.stop().catch((error: BusinessError) => {
          Logger.error(TAG, `Failed to stop customScan. Code: ${error.code}, message: ${error.message}`);
        });
      }
    } catch (error) {
      Logger.error(TAG, `Failed to stop customScan. Code: ${error.code}, message: ${error.message}`);
    }
  }

  @Builder
  headerRow() {
    Row() {
      Button() {
        SymbolGlyph($r('sys.symbol.arrow_left'))
          .fontSize($r('app.float.scan_header_icon_size'))
          .fontColor([$r('app.color.on_primary')])
      }
      .width($r('app.float.scan_header_button_size'))
      .height($r('app.float.scan_header_button_size'))
      .type(ButtonType.Circle)
      .backgroundColor($r('app.color.button_background_transparent'))
      .onClick(() => {
        this.onClose();
      })

      Button() {
        SymbolGlyph($r('sys.symbol.dot_grid_2x2'))
          .fontSize($r('app.float.scan_header_icon_size'))
          .fontColor([$r('app.color.on_primary')])
      }
      .width($r('app.float.scan_header_button_size'))
      .height($r('app.float.scan_header_button_size'))
      .type(ButtonType.Circle)
      .backgroundColor($r('app.color.button_background_transparent'))
    }
    .width(CommonConstants.FULL_WIDTH)
    .height($r('app.float.scan_header_height'))
    .padding({
      top: CommonConstants.SCAN_PADDING_TOP + this.windowInfo.statusBarTopVp,
      left: $r('app.float.scan_header_padding_horizontal'),
      right: $r('app.float.scan_header_padding_horizontal')
    })
    .justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder
  bottomFunctionBar() {
    Row() {
      // Payment button
      Column({ space: $r('app.float.bottom_function_space') }) {
        Row() {
          SymbolGlyph($r('sys.symbol.barcode_viewfinder'))
            .fontSize($r('app.float.scan_header_icon_size'))
            .fontColor([$r('app.color.on_primary')])
        }
        .width($r('app.float.bottom_function_icon_size'))
        .height($r('app.float.bottom_function_icon_size'))
        .backgroundColor($r('app.color.button_background_overlay'))
        .borderRadius($r('app.float.bottom_function_icon_radius'))
        .justifyContent(FlexAlign.Center)

        Text($r('app.string.scan_payment'))
          .fontSize($r('app.float.bottom_function_text_size'))
          .fontColor($r('app.color.on_primary'))
      }
      .onClick(() => {
        this.onPaymentClick();
      })

      // Album button
      Column({ space: $r('app.float.bottom_function_space') }) {
        Row() {
          SymbolGlyph($r('sys.symbol.picture_badge_cloud_fill'))
            .fontSize($r('app.float.scan_header_icon_size'))
            .fontColor([$r('app.color.on_primary')])
        }
        .width($r('app.float.bottom_function_icon_size'))
        .height($r('app.float.bottom_function_icon_size'))
        .backgroundColor($r('app.color.button_background_overlay'))
        .borderRadius($r('app.float.bottom_function_icon_radius'))
        .justifyContent(FlexAlign.Center)

        Text($r('app.string.scan_album'))
          .fontSize($r('app.float.bottom_function_text_size'))
          .fontColor($r('app.color.on_primary'))
      }
    }
    .width(CommonConstants.FULL_WIDTH)
    .height($r('app.float.bottom_function_bar_height'))
    .justifyContent(FlexAlign.SpaceEvenly)
    .margin({
      bottom: $r('app.float.bottom_function_bar_margin_bottom')
    })
  }

  @Builder
  bottomTabBar() {
    Row() {
      ForEach(this.scanList, (item: ScanModel, index: number) => {
        Column({ space: $r('app.float.tab_item_space') }) {
          Text(item.getText())
            .fontSize($r('app.float.tab_item_font_size'))
            .fontWeight(this.selectedTabIndex === index ? FontWeight.Medium : FontWeight.Regular)
            .fontColor(this.selectedTabIndex === index ? $r('app.color.on_primary') : $r('app.color.tab_unselected'))

          Row()
            .width($r('app.float.tab_indicator_size'))
            .height($r('app.float.tab_indicator_size'))
            .backgroundColor($r('app.color.accent_teal'))
            .borderRadius($r('app.float.tab_indicator_radius'))
            .visibility(this.selectedTabIndex === index ? Visibility.Visible : Visibility.None)
        }
        .justifyContent(FlexAlign.Center)
        .height($r('app.float.tab_item_height'))
        .onClick(() => {
          this.selectedTabIndex = index;
        })
      }, (index: number) => index.toString())
    }
    .width(CommonConstants.FULL_WIDTH)
    .height($r('app.float.tab_bar_height'))
    .justifyContent(FlexAlign.SpaceEvenly)
    .alignItems(VerticalAlign.Center)
    .padding({
      bottom: $r('app.float.tab_bar_padding_bottom')
    })
    .linearGradient({
      direction: GradientDirection.Top,
      colors: [
        [$r('app.color.gradient_overlay_start'), CommonConstants.LINEAR_BEGIN],
        [$r('app.color.gradient_overlay_end'), CommonConstants.LINEAR_END]
      ]
    })
  }

  @Builder
  backgroundSet() {
    Column()
      .width(CommonConstants.FULL_WIDTH)
      .height(CommonConstants.FULL_HEIGHT)
      .linearGradient({
        direction: GradientDirection.Bottom,
        colors: [
          [$r('app.color.gradient_dark_start'), CommonConstants.LINEAR_BEGIN],
          [$r('app.color.gradient_dark_end'), CommonConstants.LINEAR_END]
        ]
      })
  }

  build() {
    Stack() {
      if (this.userGrant) {
        Column() {
          XComponent({
            id: 'componentId',
            type: XComponentType.SURFACE,
            controller: this.mXComponentController
          })
            .onLoad(() => {
              Logger.info(TAG, 'Succeeded in loading, onLoad is called.');
              // Get XComponent surface id
              this.surfaceId = this.mXComponentController.getXComponentSurfaceId();
              Logger.info(TAG, `Succeeded in getting surfaceId: ${this.surfaceId}`);
              this.initCamera();
            })
            .width(CommonConstants.FULL_WIDTH)
            .height(CommonConstants.FULL_HEIGHT)
        }
        .width(CommonConstants.FULL_WIDTH)
      }

      Column() {
        if (!this.isCenterMode) {
          this.headerRow()
        } else {
          Blank()
        }

        Column() {
          this.bottomFunctionBar()

          this.bottomTabBar()
        }
      }
      .width(CommonConstants.FULL_WIDTH)
      .height(CommonConstants.FULL_HEIGHT)
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width(CommonConstants.FULL_WIDTH)
    .height(LayoutPolicy.matchParent)
    .background(this.backgroundSet())
    .ignoreLayoutSafeArea()
  }
}