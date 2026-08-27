/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { image } from '@kit.ImageKit';
import {
  hdsMaterial,
  HdsNavDestination,
  HdsNavigationMenuContentOptions,
  HdsNavigationMenuItemOptions,
  IconStyleMode,
  ScrollEffectType,
  TitleBarStyleOptions
} from '@kit.UIDesignKit';
import { deviceInfo } from '@kit.BasicServicesKit';
import { fileIo } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import { stylusInteraction } from '@kit.Penkit';
import { ComponentContent, inspector } from '@kit.ArkUI';
import promptAction from '@ohos.promptAction';
// [Start import_wavewheel]
import type { SimpleWaveWheelOption, WaveWheelCallback } from 'wavewheel';
import { WaveWheelController } from 'wavewheel';
import { WaveWheelSettingViewBuilder, clearTempOptions } from '../view/WaveWheelSettingView';
// [End import_wavewheel]
import { AlertDialogBuilder } from '../view/AlertDialog';
import { FoldedDialog } from '../view/FoldedDialog';
import { NoPermissionDialog } from '../view/NoPermissionDialog';
import { UnsavedDialog } from '../view/UnsavedDialog';
import CropView from '../view/CropView';
import AdjustContentView from '../view/AdjustContentView';
import ApplyFilterView from '../view/ApplyFilterView';
import TranslateView from '../view/TranslateView';
import ZoomView from '../view/ZoomView';
import { EmptyOptionDialog } from '../view/PictureEditDialog';
import { AdjustType, MainTabId } from '../viewModel/OptionViewModel';
import { WindowMenuHelper } from '../viewModel/WindowMenuHelper';
import { EditStateViewModel } from '../viewModel/EditStateViewModel';
import Logger from '../utils/Logger';
import type { BreakpointType } from '../utils/MultiDeviceUtil';
import { getValueByBreakpointSync } from '../utils/MultiDeviceUtil';
import { decodePixelMapFromImageSource, getResourceFd } from '../utils/DecodeUtil';
import { EditController } from '../utils/EditController';
import { CustomTransition } from '../utils/NavigationTransitionUtils';
import { CommonConstants } from '../common/constant/CommonConstants';
import { StatusBarUtil } from '../utils/StatusBarUtil';
import { saveImageToGallery } from '../utils/ImageSaveUtil';
import {
  calculateBaseDisplaySize,
  getImageWidth,
  getImageHeight,
  getImageFitAndClip,
  BaseDisplaySize,
  ImageFitConfig
} from '../utils/PictureEditLayoutUtil';
import { PixelMapManager } from './PixelMapManager';
import { EditMode } from '../types/CommonTypes';
import type { EditNavParam } from '../types/CommonTypes';

const TAG = `PictureEdit`;

// [Start define_struct_picture_edit]
@Component
export struct PictureEdit {
  // [StartExclude define_struct_picture_edit]
  // Current edited image displayed in preview area
  @State previewPixelMap?: image.PixelMap = undefined;
  // Cropped version for crop operation preview
  @State previewCropPixelMap?: image.PixelMap = undefined;
  @State overlayPixelMap: image.PixelMap | null = null;
  @State overlayWidth: number = 0;
  @State overlayHeight: number = 0;
  @State overlayX: number = 0;
  @State overlayY: number = 0;
  // Controls overlay layer visibility during transitions
  @State isShow: boolean = true;
  // Tracks first entry for placeholder image display
  @State isFirstEnter: boolean = true;
  // Toggles between original and edited image comparison
  @State isComparing: boolean = false;
  @State containerWidth: number = 0;
  @State containerHeight: number = 0;
  @State isSettingSheetVisible: boolean = false;
  @State isSettingsDirty: boolean = false;
  @State dialogController: promptAction.DialogController = new promptAction.DialogController();
  @State dialogContentNode: ComponentContent<object> | undefined = undefined;
  // Central state management for all editing operations
  @Provide editState: EditStateViewModel = new EditStateViewModel();
  @StorageLink(CommonConstants.IS_FOLDED) @Watch('onFoldedChanged') isFolded: boolean = false;
  @StorageLink(CommonConstants.BREAKPOINT_KEY) currentBreakpoint: BreakpointType = 'sm';
  @StorageProp(CommonConstants.AVOID_AREA_TOP) safeAreaTop: number = 0;
  @StorageProp(CommonConstants.AVOID_AREA_BOTTOM) safeAreaBottom: number = 0;
  @StorageProp(CommonConstants.IS_PC_DEVICE) isPCDevice: boolean = false;
  // [EndExclude define_struct_picture_edit]
  @StorageProp(CommonConstants.KEY_SIMPLE_WAVE_WHEEL_OPTIONS) simpleWaveWheelOptions: SimpleWaveWheelOption[] = [];
  // [End define_struct_picture_edit]
  @State titleBarMenu: HdsNavigationMenuContentOptions = {
    maxCount: 5,
    value: []
  };
  private imageSource?: image.ImageSource;
  private imageFile?: fileIo.File;
  private pixelMapManager?: PixelMapManager;
  private editController?: EditController;
  private pathStack: NavPathStack | null = null;
  private navDestinationId: string = '';
  private context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
  private listener: inspector.ComponentObserver = this.getUIContext().getUIInspector().createComponentObserver('HDS_NAV_DESTI');
  private foldedDialogController: CustomDialogController = new CustomDialogController({
    builder: FoldedDialog({
      confirm: () => {
        this.pathStack?.pop();
        this.foldedDialogController.close();
      }
    }),
    onWillDismiss: (dismissDialogAction: DismissDialogAction): void => {
      if (dismissDialogAction.reason !== DismissReason.CLOSE_BUTTON) {
        return;
      }
      dismissDialogAction.dismiss();
    },
    autoCancel: false,
    alignment: DialogAlignment.Center,
    customStyle: true
  });
  private noPermissionDialogController: CustomDialogController = new CustomDialogController({
    builder: NoPermissionDialog({
      confirm: () => {
        this.noPermissionDialogController.close();
      }
    }),
    onWillDismiss: (dismissDialogAction: DismissDialogAction): void => {
      if (dismissDialogAction.reason !== DismissReason.CLOSE_BUTTON) {
        return;
      }
      dismissDialogAction.dismiss();
    },
    autoCancel: false,
    alignment: DialogAlignment.Center,
    customStyle: true
  });
  private unsavedDialogController: CustomDialogController = new CustomDialogController({
    builder: UnsavedDialog({
      cancel: () => {
        this.isSettingSheetVisible = true;
        this.isSettingsDirty = false;
      },
      confirm: () => {
        clearTempOptions();
        this.isSettingsDirty = false;
      }
    }),
    autoCancel: false,
    alignment: DialogAlignment.Center,
    customStyle: true
  });
  private titleBarStyle: TitleBarStyleOptions = {
    scrollEffectOpts: {
      enableScrollEffect: false,
      scrollEffectType: ScrollEffectType.COMMON_BLUR,
    },
    originalStyle: {
      contentStyle: {
        titleStyle: {
          mainTitleColor: Color.White,
        },
        menuStyle: {
          iconColor: Color.White,
        },
        backIconStyle: {
          iconColor: Color.White,
        }
      }
    }
  };

  initTitleBarStyle(): void {
    try {
      let customMaterialLevel = hdsMaterial.MaterialLevel.ADAPTIVE;
      let materialTypes: hdsMaterial.MaterialType[] = hdsMaterial.getSystemMaterialTypes();
      if (materialTypes.indexOf(hdsMaterial.MaterialType.IMMERSIVE) >= 0) {
        customMaterialLevel = hdsMaterial.MaterialLevel.EXQUISITE;
      }

      const deviceTypeInfo: string = deviceInfo.deviceType;
      const isEnableMaterial: boolean =
        deviceTypeInfo === deviceInfo.DeviceTypes.TYPE_PHONE || deviceTypeInfo === deviceInfo.DeviceTypes.TYPE_TABLET;
      if (deviceInfo.sdkApiVersion >= 23 && isEnableMaterial) {
        this.titleBarStyle.systemMaterialEffect = {
          materialType: hdsMaterial.MaterialType.ADAPTIVE,
          materialLevel: customMaterialLevel,
        };
      }
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(`initTitleBarStyle failed, error ${err.code}: ${err.message}`);
    }
  }

  onFoldedChanged(): void {
    if (this.isFolded) {
      this.foldedDialogController.open();
    } else {
      this.foldedDialogController.close();
    }
  }

  // [Start get_instance]
  private wavewheelController: WaveWheelController = WaveWheelController.getInstance();
  emptyOptionDialogController: CustomDialogController = new CustomDialogController({
    builder: EmptyOptionDialog({
      onGoToSetting: () => {
        this.isSettingSheetVisible = true;
      }
    }),
    autoCancel: false,
    alignment: DialogAlignment.Center,
    customStyle: true
  });
  // [End get_instance]
  // [Start empty_option_callback]
  private emptyOptionCallback = (_: stylusInteraction.SqueezeEvent): void => {
    this.emptyOptionDialogController.close();
    this.emptyOptionDialogController.open();
  };
  // [End empty_option_callback]

  private handleWaveWheelRoomChange(targetMode: EditMode, targetAdjustIndex?: number): void {
    this.editState.handleWaveWheelRoomChange(targetMode, () => this.onConfirm(), targetAdjustIndex);
  }

  // [Start create_wavewheel_callback]
  private createWaveWheelCallback(key: string, mode: EditMode, adjustType?: AdjustType): WaveWheelCallback {
    return (id: string, x: number, y: number) => {
      Logger.debug(TAG, `id2callback ${key} id = ${id} x = ${x} y = ${y}`);
      if (adjustType !== undefined) {
        this.handleWaveWheelRoomChange(mode, adjustType);
      } else {
        this.handleWaveWheelRoomChange(mode);
      }
    };
  }
  // [End create_wavewheel_callback]

  // [Start init_wavewheel]
  private initWaveWheel(): void {
    // add wavewheel options
    const id2callback: Map<string, WaveWheelCallback> = new Map();
    // id from entry/src/main/ets/common/constant/WaveWheelConstant.ets
    interface CallbackConfig {
      key: string;
      mode: EditMode,
      adjustType?: AdjustType
    }

    const configs: CallbackConfig[] = [
      { key: 'crop', mode: EditMode.CROP_MODE },
      { key: 'brightness', mode: EditMode.ADJUST_MODE, adjustType: AdjustType.BRIGHTNESS },
      { key: 'transparency', mode: EditMode.ADJUST_MODE, adjustType: AdjustType.OPACITY },
      // [StartExclude init_wavewheel]
      { key: 'saturation', mode: EditMode.ADJUST_MODE, adjustType: AdjustType.SATURATION },
      { key: 'camera_filters', mode: EditMode.FILTER_MODE },
      { key: 'square_portrait_svg', mode: EditMode.TRANSLATE_MODE },
      { key: 'checkered_magnifyingglass', mode: EditMode.ZOOM_MODE }
      // [EndExclude init_wavewheel]
    ];
    configs.forEach((config) => {
      id2callback.set(config.key, this.createWaveWheelCallback(config.key, config.mode, config.adjustType));
    })

    const totalOptions = this.wavewheelController.setWaveWheelOptionsBySimple(this.simpleWaveWheelOptions, id2callback);
    Logger.debug(TAG, `totalOptions=${totalOptions} simpleLen=${this.simpleWaveWheelOptions.length}`);
    this.wavewheelController.setEmptyOptionCallback(this.emptyOptionCallback);
  }
  // [End init_wavewheel]

  // [Start about_to_appear]
  // [Start wavewheel_init]
  aboutToAppear(): void {
    // [StartExclude wavewheel_init]
    this.initTitleBarStyle();
    WindowMenuHelper.init(this.context, () => {
      this.updateMenuItems();
    });
    this.listener.on('draw', StatusBarUtil.setWindowStatusBarProperties);
    if (this.isFolded) {
      this.foldedDialogController.open();
    }

    AppStorage.setOrCreate(CommonConstants.KEY_PREFIX + 'isColorInfo', false);
    this.pixelInit();
    // [EndExclude wavewheel_init]
    this.initWaveWheel();
    this.dialogContentNode = new ComponentContent(this.getUIContext(), wrapBuilder(AlertDialogBuilder));
    this.getUIContext().getPromptAction().openCustomDialogWithController(this.dialogContentNode, this.dialogController)
      .catch((err: BusinessError) => {
        Logger.error(TAG, `failed to open usage guide dialog error ${err.code}: ${err.message}`);
      });
    this.wavewheelController.start();
  }
  // [End wavewheel_init]
  // [End about_to_appear]

  updateMenuItems(): void {
    const iconType = this.isPCDevice ? IconStyleMode.SMALL : IconStyleMode.NORMAL;
    const items: HdsNavigationMenuItemOptions[] = [
      {
        content: {
          icon: $r('sys.symbol.arrow_counterclockwise'),
          isEnabled: true,
          type: iconType,
          action: (): void => {
            this.reset();
          }
        }
      },
      {
        content: {
          icon: $r('sys.symbol.save'),
          type: iconType,
          isEnabled: this.editState.isEdited(),
          action: (): void => {
            saveImageToGallery(this.previewPixelMap, this.context, this.getUIContext());
          }
        }
      },
      {
        content: {
          icon: $r('sys.symbol.info_circle'),
          type: iconType,
          isEnabled: true,
          action: (): void => {
            let uiContext = this.getUIContext();
            uiContext.getPromptAction().openCustomDialogWithController(this.dialogContentNode, this.dialogController)
              .catch((err: BusinessError) => {
                Logger.error(TAG, `failed to open custom dialog with controller error ${err.code}: ${err.message}`);
              });
          }
        }
      },
      {
        content: {
          icon: $r('sys.symbol.square_grid_2x2'),
          type: iconType,
          isEnabled: true,
          action: (): void => {
            this.isSettingSheetVisible = true;
          }
        }
      }
    ];

    if (this.isPCDevice) {
      WindowMenuHelper.appendTo(items, {
        context: this.context,
        onFullScreenChange: () => {
          this.updateMenuItems();
        }
      });
    }

    this.titleBarMenu = {
      maxCount: this.isPCDevice ? 5 : 4,
      value: items
    };
  }

  // [Start about_to_disappear]
  aboutToDisappear(): void {
    AppStorage.delete(CommonConstants.KEY_PREFIX + 'isColorInfo');
    WindowMenuHelper.release();
    this.pixelMapManager?.destroyPixelMapManager();
    this.imageSource?.release();
    this.listener.off('draw', StatusBarUtil.setWindowStatusBarProperties);
    if (this.imageFile) {
      try {
        fileIo.closeSync(this.imageFile);
      } catch (error) {
        const err: BusinessError = error as BusinessError;
        Logger.error(`closeSync failed, error ${err.code}: ${err.message}`);
      }
    }
    CustomTransition.unRegisterAnimationByID(this.navDestinationId);
    this.wavewheelController?.stop();
  }
  // [End about_to_disappear]

  onConfirm(): void {
    if (this.previewPixelMap) {
      this.editController?.confirmEdit(this.previewPixelMap);
    } else {
      Logger.error(TAG, '@onConfirm, previewPixelMap is null/undefined');
    }
  }

  reset(): void {
    this.editController?.resetEdit();
    this.checkEditState();
  }

  checkEditState(): void {
    this.updateMenuItems();
  }

  private calculateBaseDisplaySize(): BaseDisplaySize {
    return calculateBaseDisplaySize(
      this.containerWidth, this.containerHeight, this.editState,
      this.previewPixelMap, this.currentBreakpoint,
      (px: number) => this.getUIContext().px2vp(px)
    );
  }

  private getImageWidth(): Length {
    return getImageWidth(this.editState, this.containerWidth, this.currentBreakpoint);
  }

  private getImageHeight(): Length {
    return getImageHeight(this.editState, this.containerHeight, this.currentBreakpoint);
  }

  private getImageFitAndClip(): ImageFitConfig {
    return getImageFitAndClip(this.editState);
  }

  async pixelInit(): Promise<void> {
    let file = await getResourceFd(this.getUIContext());
    if (!file) {
      Logger.error('pixelInit', 'Failed to get resource file');
      return;
    }
    this.imageFile = file;
    let imageSource: image.ImageSource | undefined;
    try {
      imageSource = image.createImageSource(file.fd);
      let px = await decodePixelMapFromImageSource(imageSource);
      if (!px) {
        Logger.error('pixelInit', 'Failed to create PixelMap');
        return;
      }
      this.imageSource = imageSource;
      this.pixelMapManager = new PixelMapManager(px, (pixelMap: image.PixelMap) => {
        this.previewPixelMap = pixelMap;
        this.previewCropPixelMap = pixelMap;
        PixelMapManager.logPixelMetrics(pixelMap, 'notifyPreview');
        if (!this.isFirstEnter) {
          this.checkEditState();
        }
      });
      this.editController = new EditController(this.pixelMapManager, this.editState);
      this.editState.reset();
    } finally {
      if (imageSource) {
        try {
          imageSource.release();
        } catch (e) {
          Logger.error('pixelInit', 'Failed to release ImageSource');
        }
      }
    }
  }

  @Builder
  settingViewBuilder() {
    WaveWheelSettingViewBuilder(() => {
      this.isSettingSheetVisible = false;
      this.initWaveWheel();
    }, (dirty: boolean) => {
      this.isSettingsDirty = dirty;
    });
  }

  @Builder
  TabBuilderMenu(index: number, name: string | Resource) {
    Column() {
      if (CommonConstants.EDIT_MENU_ICONS[index].includes('svg')) {
        Image($r(`app.media.${CommonConstants.EDIT_MENU_ICONS[index]}`))
          .fillColor(this.editState.currentEditMode === index ? '#5291FF' : '#FFFFFF')
          .width(CommonConstants.TAB_MENU_WIDTH)
          .height(CommonConstants.TAB_MENU_WIDTH);
      } else {
        Text() {
          SymbolSpan($r(`sys.symbol.${CommonConstants.EDIT_MENU_ICONS[index]}`))
            .fontColor(this.editState.currentEditMode === index ? ['#5291FF', '#5291FF', '#5291FF'] :
              [Color.White, Color.White, Color.White])
            .fontWeight(FontWeight.Normal)
            .fontSize(24);
        }
        .width(CommonConstants.TAB_MENU_WIDTH)
        .height(CommonConstants.TAB_MENU_WIDTH);
      }

      Text(name)
        .fontColor(this.editState.currentEditMode === index ? '#5291FF' : Color.White)
        .fontSize($r('app.float.category_font_size'))
        .margin({ top: $r('app.float.category_margin_top') });
    }
    .width(CommonConstants.LAYOUT_FULL_SCREEN);
  }

  @Builder
  buildOverlayLayer() {
    if (this.isShow) {
      Image(this.overlayPixelMap)
        .geometryTransition('previewTransition')
        .width(this.overlayWidth > 0 ? this.overlayWidth : '100%')
        .height(this.overlayHeight > 0 ? this.overlayHeight : '100%')
        .position({ x: this.overlayX, y: this.overlayY })
        .objectFit(ImageFit.Cover)
        .zIndex(999);
    }
  }

  @Builder
  buildPreviewArea() {
    Column() {
      Stack({
        alignContent: getValueByBreakpointSync({
          sm: Alignment.TopStart,
          md: Alignment.TopEnd,
          lg: Alignment.TopStart
        }, this.currentBreakpoint as BreakpointType)
      }) {
        Column() {
          Image(this.isFirstEnter ? $rawfile('low.jpg') : this.previewPixelMap)
            .geometryTransition('previewTransition')
            .width(this.getImageWidth())
            .height(this.getImageHeight())
            .objectFit(this.getImageFitAndClip().fit)
            .opacity(this.isComparing ? 0 : 1);
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .clip(true)
        .onAreaChange((_: Area, newValue: Area) => {
          const newWidth = Number(newValue.width);
          const newHeight = Number(newValue.height);
          if (newWidth !== this.containerWidth || newHeight !== this.containerHeight) {
            this.containerWidth = newWidth;
            this.containerHeight = newHeight;
          }
        });

        Image(this.pixelMapManager?.getInitPixelMap())
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Contain)
          .opacity(this.isComparing ? 1 : 0)
          .align(Alignment.Center);

        if (this.currentBreakpoint === 'md' || this.currentBreakpoint === 'lg') {
          Button($r('app.string.compare'), {
            type: ButtonType.Capsule,
          })
            .height(28)
            .padding({ left: 12, right: 12 })
            .backgroundColor('rgba(77, 77, 77, 1)')
            .margin({
              top: 12,
              right: this.currentBreakpoint === 'md' ? 24 : 0,
              left: this.currentBreakpoint === 'lg' ? 32 : 0
            })
            .onTouch((event: TouchEvent) => {
              if (event.type === TouchType.Down) {
                this.isComparing = true;
              } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
                this.isComparing = false;
              }
            });
        }
      }
      .width('100%')
      .flexGrow(1);
    }
    .padding({
      top: 0,
      left: 12,
      right: 12,
      bottom: 8
    })
    .width(getValueByBreakpointSync({
      sm: '100%',
      md: '100%'
    }, this.currentBreakpoint as BreakpointType))
    .flexGrow(1)
    .justifyContent(FlexAlign.Center);
  }

  @Builder
  buildEditTabs() {
    Column() {
      Tabs({ barPosition: BarPosition.End, index: this.editState.currentEditMode }) {
        TabContent() {
          CropView({
            pixelMapManager: this.pixelMapManager,
            onCropImage: (proportion) => {
              this.editController?.cropImage(proportion);
              this.checkEditState();
            },
            onRotateImage: () => {
              this.editController?.rotateImage();
              this.checkEditState();
            },
            onMirrorImage: () => {
              this.editController?.mirrorImage();
              this.checkEditState();
            }
          });
        }
        .tabBar(this.TabBuilderMenu(MainTabId.CROP, $r('app.string.crop')))
        .height(getValueByBreakpointSync({
          sm: 152.00,
          md: 160,
        }, this.currentBreakpoint as BreakpointType));

        TabContent() {
          AdjustContentView({ pixelMapManager: this.pixelMapManager });
        }
        .padding({
          bottom: getValueByBreakpointSync({
            sm: 19,
            lg: 0
          }, this.currentBreakpoint as BreakpointType)
        })
        .height('344vp')
        .tabBar(this.TabBuilderMenu(MainTabId.ADJUST, $r('app.string.adjust')))
        .clip(false);

        TabContent() {
          ApplyFilterView({ pixelMapManager: this.pixelMapManager });
        }
        .padding({
          bottom: getValueByBreakpointSync({
            sm: 19,
            lg: 0
          }, this.currentBreakpoint as BreakpointType)
        })
        .tabBar(this.TabBuilderMenu(MainTabId.FILTER, $r('app.string.filter')));

        TabContent() {
          TranslateView({
            onTranslateChange: (value: number, mode: SliderChangeMode) => {
              this.editController?.handleTranslateChange(value, mode);
              this.checkEditState();
            }
          });
        }
        .padding({
          bottom: getValueByBreakpointSync({
            sm: 19,
            lg: 0
          }, this.currentBreakpoint as BreakpointType)
        })
        .tabBar(this.TabBuilderMenu(MainTabId.TRANSLATE, $r('app.string.translate')))
        .clip(false);

        TabContent() {
          ZoomView({
            onZoomChange: (value: number, mode: SliderChangeMode) => {
              this.editController?.handleZoomChange(value, mode);
              this.checkEditState();
            }
          });
        }
        .padding({
          bottom: getValueByBreakpointSync({
            sm: 19,
            lg: 0
          }, this.currentBreakpoint as BreakpointType)
        })
        .clip(false)
        .tabBar(this.TabBuilderMenu(MainTabId.ZOOM, $r('app.string.zoom')));
      }
      .barHeight(getValueByBreakpointSync({
        lg: 452,
        sm: 52
      }, this.currentBreakpoint as BreakpointType))
      .barWidth(getValueByBreakpointSync<Length>({
        sm: '100%',
        lg: 60
      }, this.currentBreakpoint as BreakpointType)
      )
      .scrollable(false)
      .clip(false)
      .vertical(
        getValueByBreakpointSync({
          lg: true,
          sm: false
        }, this.currentBreakpoint as BreakpointType)
      )
      .onChange((index: number) => {
        this.editState.handleTabChange(index, this.pixelMapManager, this.previewPixelMap,
          () => {
            const baseSize = this.calculateBaseDisplaySize();
            this.editState.setBaseDisplaySize(baseSize.width, baseSize.height);
          },
          () => this.editState.clearBaseDisplaySize(),
          () => this.onConfirm());
      });
    }
    .width(
      getValueByBreakpointSync<string | number>({
        lg: 212,
        sm: '100%'
      }, this.currentBreakpoint as BreakpointType))
    .height(
      getValueByBreakpointSync<string | number>({
        sm: 232,
        lg: 680
      }, this.currentBreakpoint as BreakpointType))
    .flexShrink(0)
    .backgroundColor(Color.Black)
    .margin({
      bottom: this.isFolded ? 12 : 0,
      right: getValueByBreakpointSync({
        sm: 0,
        lg: 32
      }, this.currentBreakpoint)
    });
  }

  build() {
    HdsNavDestination() {
      Stack() {
        this.buildOverlayLayer();
        if (!this.isShow) {
          Flex({
            direction: getValueByBreakpointSync({
              lg: FlexDirection.Row,
              sm: FlexDirection.Column
            }, this.currentBreakpoint as BreakpointType),
            alignItems: ItemAlign.Stretch
          }) {
            this.buildPreviewArea();
            this.buildEditTabs();
          }
          .padding({
            top: this.getUIContext().px2vp(this.safeAreaTop) + CommonConstants.NAVIGATION_HEIGHT,
            bottom: this.getUIContext().px2vp(this.safeAreaBottom)
          })
          .width('100%')
          .height('100%');
        }
      }
      .width('100%')
      .height('100%')
      .bindSheet($$this.isSettingSheetVisible, this.settingViewBuilder(), {
        height: 550,
        title: { title: $r('app.string.wheel_menu_settings') },
        onWillDisappear: () => {
          if (this.isSettingsDirty) {
            this.unsavedDialogController.open();
          } else {
            this.isSettingSheetVisible = false;
          }
        }
      });
    }
    .titleBar({
      style: this.titleBarStyle,
      avoidLayoutSafeArea: true,
      content: {
        title: {
          mainTitle: $r('app.string.edit')
        },
        menu: this.titleBarMenu
      },
    })
    .backgroundColor(Color.Black)
    .hideTitleBar(false)
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
      const param = context.pathInfo.param as EditNavParam;
      this.navDestinationId = context.navDestinationId as string;
      this.overlayPixelMap = param.sourcePixelMap as PixelMap;
      this.overlayWidth = param.imageRect.width;
      this.overlayHeight = param.imageRect.height;
      this.overlayX = param.imageRect.x;
      this.overlayY = param.imageRect.y;
      if (context.navDestinationId) {
        CustomTransition.registerAnimationByID(context.navDestinationId, {
          onEnterStart: (): void => {
            this.isShow = true;
          },
          onEnterFinish: (): void => {
            this.isShow = false;
            setTimeout(() => {
              this.isFirstEnter = false;
            }, CommonConstants.TRANSITION_DELAY);
          },
          onExitFinish: (): void => {
            this.isShow = false;
          },
          onExitStart: (): void => {
            this.isShow = true;
          }
        });
      }
    })
    .onHover((isHover: boolean, event: HoverEvent) => {
      if (isHover) {
        if (event.sourceTool === SourceTool.Pen) {
          let x = event.windowX;
          let y = event.windowY;
          if (x === undefined || y === undefined) {
            return;
          }
          this.wavewheelController.updatePosition({ x: x, y: y });
        }
      }

    })
    .onTouch((event: TouchEvent) => {
      if (event.sourceTool === SourceTool.Pen) {
        let x = event.touches[0].windowX; // vp
        let y = event.touches[0].windowY; // vp
        if (x === undefined || y === undefined) {
          return;
        }
        this.wavewheelController.updatePosition({ x: x, y: y });
      }
    })
    .id('HDS_NAV_DESTI')
  }
}