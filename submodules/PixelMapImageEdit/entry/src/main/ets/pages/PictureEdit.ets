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
import { MyCustomDialog } from '../view/MyCustomDialog';
import { FoldedDialog } from '../view/FoldedDialog';
import CropView from '../view/CropView';
import AdjustContentView from '../view/AdjustContentView';
import ApplyFilterView from '../view/ApplyFilterView';
import TranslateView from '../view/TranslateView';
import ZoomView from '../view/ZoomView';
import { MainTabId } from '../viewModel/OptionViewModel';
import { EditStateViewModel } from '../viewModel/EditStateViewModel';
import Logger from '../utils/Logger';
import { BreakpointType, getValueByBreakpointSync } from '../utils/MultiDeviceUtil';
import { decodePixelMapFromImageSource, getResourceFd } from '../utils/DecodeUtil';
import { EditController } from '../utils/EditController';
import { CustomTransition } from '../utils/NavigationTransitionUtils';
import { CommonConstants } from '../common/constant/CommonConstants';
import { PixelMapManager } from './PixelMapManager';
import { EditMode, EditNavParam } from '../types/CommonTypes';
import { WindowMenuHelper } from '../viewModel/WindowMenuHelper';

@Component
export struct PictureEdit {
  // Current edited image displayed in preview area
  @Watch('onPixelMapChange')
  @State previewPixelMap?: image.PixelMap = undefined;
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
  @State editDialogTitle: Resource | string = '';
  @State containerWidth: number = 0;
  @State containerHeight: number = 0;
  @State initialAspectRatio: number = 1;
  @State currentAspectRatio: number = 1;
  @State currentPixelWidth: number = 0;
  @State currentPixelHeight: number = 0;
  // Central state management for all editing operations
  @Provide editState: EditStateViewModel = new EditStateViewModel();
  @StorageLink(CommonConstants.IS_FOLDED) @Watch('onFoldedChanged') isFolded: boolean = false;
  @StorageLink(CommonConstants.BREAKPOINT_KEY) currentBreakpoint: BreakpointType = 'sm';
  @StorageProp(CommonConstants.AVOID_AREA_TOP) safeAreaTop: number = 0;
  @StorageProp(CommonConstants.AVOID_AREA_BOTTOM) safeAreaBottom: number = 0;
  @StorageProp(CommonConstants.IS_PC_DEVICE) isPCDevice: boolean = false;
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
  private editDialogController: CustomDialogController = new CustomDialogController({
    builder: MyCustomDialog({
      title: this.editDialogTitle,
      cancel: () => {
        this.editController?.cancelLastEdit();
        this.editDialogController.close();
      },
      confirm: () => {
        this.editController?.confirmLastEdit();
        this.editDialogController.close();
      }
    }),
    autoCancel: false,
    alignment: DialogAlignment.Center,
    customStyle: true
  });
  private foldedDialogController: CustomDialogController = new CustomDialogController({
    builder: FoldedDialog({
      confirm: () => {
        this.pathStack?.pop();
        this.foldedDialogController.close();
      }
    }),
    onWillDismiss: (dismissDialogAction: DismissDialogAction) => {
      if (dismissDialogAction.reason !== DismissReason.CLOSE_BUTTON) {
        return;
      }
      dismissDialogAction.dismiss();
    },
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

  initTitleBarStyle() {
    try {
      const deviceTypeInfo: string = deviceInfo.deviceType;
      const isEnableMaterial: boolean =
        deviceTypeInfo === deviceInfo.DeviceTypes.TYPE_PHONE || deviceTypeInfo === deviceInfo.DeviceTypes.TYPE_TABLET;
      if (deviceInfo.sdkApiVersion > 23 && isEnableMaterial) {
        this.titleBarStyle.systemMaterialEffect = {
          materialType: hdsMaterial.MaterialType.ADAPTIVE,
          materialLevel: hdsMaterial.MaterialLevel.ADAPTIVE,
        }
      }
    } catch (err) {
      Logger.error(`initTitleBarStyle failed, err: ${JSON.stringify(err)}`);
    }
  }

  onFoldedChanged(): void {
    if (this.isFolded) {
      this.foldedDialogController.open();
    } else {
      this.foldedDialogController.close();
    }
  }

  onPixelMapChange(): void {
    if (this.previewPixelMap) {
      try {
        const info: image.ImageInfo = this.previewPixelMap.getImageInfoSync();
        this.currentAspectRatio = info.size.width / info.size.height;
        this.currentPixelWidth = info.size.width;
        this.currentPixelHeight = info.size.height;
      } catch (err) {
        Logger.error(`onPixelMapChange failed: ${JSON.stringify(err)}`);
      }
    }
  }

  aboutToAppear() {
    this.initTitleBarStyle();
    WindowMenuHelper.init(this.context, () => {
      this.updateMenuItems();
    });

    if (this.isFolded) {
      this.foldedDialogController.open();
    }

    AppStorage.setOrCreate(CommonConstants.KEY_PREFIX + 'isColorInfo', false);
    this.pixelInit();
  }

  updateMenuItems(): void {
    const iconType = this.isPCDevice ? IconStyleMode.SMALL : IconStyleMode.NORMAL;
    const items: HdsNavigationMenuItemOptions[] = [
      {
        content: {
          icon: $r('sys.symbol.arrow_counterclockwise'),
          isEnabled: true,
          type: iconType,
          action: () => {
            this.reset();
          }
        }
      },
      {
        content: {
          icon: $r('sys.symbol.save'),
          type: iconType,
          isEnabled: false,
          action: () => {
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
      maxCount: this.isPCDevice ? 5 : 2,
      value: items
    };
  }

  aboutToDisappear(): void {
    AppStorage.delete(CommonConstants.KEY_PREFIX + 'isColorInfo');
    this.pixelMapManager?.destroyPixelMapManager();
    this.imageSource?.release();
    if (this.imageFile) {
      try {
        fileIo.closeSync(this.imageFile);
      } catch (err) {
        Logger.error(`closeSync failed: ${JSON.stringify(err)}`);
      }
    }
    CustomTransition.unRegisterAnimationByID(this.navDestinationId);
  }

  reset() {
    this.editController?.resetAll();
  }

  private getImageWidth(): Length {
    if (this.isFirstEnter) {
      return this.currentBreakpoint === 'sm' ? '100%' : 'auto';
    }
    if (this.currentPixelWidth > 0) {
      return this.getUIContext().px2vp(this.currentPixelWidth);
    }
    if (this.currentBreakpoint === 'sm') {
      return this.containerWidth;
    }
    return this.containerHeight * this.currentAspectRatio;
  }

  private getImageHeight(): Length {
    if (this.isFirstEnter) {
      return this.currentBreakpoint === 'sm' ? 'auto' : '100%';
    }
    if (this.currentPixelHeight > 0) {
      return this.getUIContext().px2vp(this.currentPixelHeight);
    }
    if (this.currentBreakpoint !== 'sm') {
      return this.containerHeight;
    }
    return this.containerWidth / this.currentAspectRatio;
  }

  async pixelInit() {
    let file = await getResourceFd(this.getUIContext());
    if (!file) {
      Logger.error('pixelInit', 'Failed to get resource file');
      return;
    }
    this.imageFile = file;
    let imageSource = image.createImageSource(file.fd);
    let px = await decodePixelMapFromImageSource(imageSource);
    if (!px) {
      Logger.error('pixelInit', 'Failed to create PixelMap');
      return;
    }
    try {
      const pixelWidth: number = px.getImageInfoSync().size.width;
      const pixelHeight: number = px.getImageInfoSync().size.height;
      const pixelAspectRatio: number = pixelWidth / pixelHeight;
      const containerWidthPixel: number = this.getUIContext().vp2px(this.containerWidth);
      const containerHeightPixel: number = this.getUIContext().vp2px(this.containerHeight);
      let scaleX: number;
      let scaleY: number;
      if (this.currentBreakpoint === 'sm') {
        scaleX = containerWidthPixel / pixelWidth;
        scaleY = (containerWidthPixel / pixelAspectRatio) / pixelHeight;
        const scaledHeight: number = pixelHeight * scaleY;
        if (scaledHeight > containerHeightPixel) {
          const heightScale: number = containerHeightPixel / pixelHeight;
          scaleX = heightScale;
          scaleY = heightScale;
        }
      } else {
        scaleX = (containerHeightPixel * pixelAspectRatio) / pixelWidth;
        scaleY = containerHeightPixel / pixelHeight;
        const scaledWidth: number = pixelWidth * scaleX;
        if (scaledWidth > containerWidthPixel) {
          const widthScale: number = containerWidthPixel / pixelWidth;
          scaleX = widthScale;
          scaleY = widthScale;
        }
      }
      px.scaleSync(scaleX, scaleY);
      const scaledInfo: image.ImageInfo = px.getImageInfoSync();
      this.initialAspectRatio = scaledInfo.size.width / scaledInfo.size.height;
      this.currentAspectRatio = this.initialAspectRatio;
      this.currentPixelWidth = scaledInfo.size.width;
      this.currentPixelHeight = scaledInfo.size.height;
    } catch (err) {
      Logger.error(`pixelInit scale failed: ${JSON.stringify(err)}`);
    }

    this.imageSource = imageSource;
    this.pixelMapManager = new PixelMapManager(px, (pixelMap: image.PixelMap) => {
      this.previewPixelMap = pixelMap;
    });
    this.editController = new EditController(this.pixelMapManager, this.editState);
    this.editState.resetAll();
  }

  @Builder
  TabBuilderMenu(index: number, name: string | Resource) {
    Column() {
      if (CommonConstants.EDIT_MENU_ICONS[index].includes('svg')) {
        Image($r(`app.media.${CommonConstants.EDIT_MENU_ICONS[index]}`))
          .fillColor(this.editState.currentEditMode === index ? '#5291FF' : '#fff')
          .width(CommonConstants.TAB_MENU_WIDTH)
          .height(CommonConstants.TAB_MENU_WIDTH)
      } else {
        Text() {
          SymbolSpan($r(`sys.symbol.${CommonConstants.EDIT_MENU_ICONS[index]}`))
            .fontColor(this.editState.currentEditMode === index ? ['#5291FF', '#5291FF', '#5291FF'] :
              [Color.White, Color.White, Color.White])
            .fontWeight(FontWeight.Normal)
            .fontSize(24)
        }
        .width(CommonConstants.TAB_MENU_WIDTH)
        .height(CommonConstants.TAB_MENU_WIDTH)
      }

      Text(name)
        .fontColor(this.editState.currentEditMode === index ? '#5291FF' : Color.White)
        .fontSize($r('app.float.category_font_size'))
        .margin({ top: $r('app.float.category_margin_top') })
    }
    .width(CommonConstants.LAYOUT_FULL_SCREEN)
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
        .zIndex(999)
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
            .objectFit(this.isFirstEnter ? ImageFit.Contain : ImageFit.None)
            .opacity(this.isComparing ? 0 : 1)
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .clip(true)
        .onAreaChange((oldValue: Area, newValue: Area) => {
          const newWidth = Number(newValue.width);
          const newHeight = Number(newValue.height);
          if (newWidth !== this.containerWidth || newHeight !== this.containerHeight) {
            this.containerWidth = newWidth;
            this.containerHeight = newHeight;
          }
        })

        Image(this.pixelMapManager?.getInitPixelMap())
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Contain)
          .opacity(this.isComparing ? 1 : 0)
          .align(Alignment.Center)

        if (this.currentBreakpoint === 'md' || this.currentBreakpoint === 'lg') {
          Button($r('app.string.compare'), {
            type: ButtonType.Capsule,
          })
            .width(64)
            .height(28)
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
            })
        }
      }
      .width('100%')
      .flexGrow(1)
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
    .justifyContent(FlexAlign.Center)
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
            },
            onRotateImage: () => {
              this.editController?.rotateImage();
            },
            onMirrorImage: () => {
              this.editController?.mirrorImage();
            }
          })
        }
        .tabBar(this.TabBuilderMenu(MainTabId.CROP, $r('app.string.crop')))
        .height(getValueByBreakpointSync({
          sm: 152.00,
          md: 160,
        }, this.currentBreakpoint as BreakpointType))

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
        .clip(false)

        TabContent() {
          ApplyFilterView({ pixelMapManager: this.pixelMapManager })
        }
        .padding({
          bottom: getValueByBreakpointSync({
            sm: 19,
            lg: 0
          }, this.currentBreakpoint as BreakpointType)
        })
        .tabBar(this.TabBuilderMenu(MainTabId.FILTER, $r('app.string.filter')))

        TabContent() {
          TranslateView({
            onTranslateChange: (value: number, mode: SliderChangeMode) => {
              this.editController?.handleTranslateChange(value, mode);
            }
          })
        }
        .padding({
          bottom: getValueByBreakpointSync({
            sm: 19,
            lg: 0
          }, this.currentBreakpoint as BreakpointType)
        })
        .tabBar(this.TabBuilderMenu(MainTabId.TRANSLATE, $r('app.string.translate')))
        .clip(false)

        TabContent() {
          ZoomView({
            onZoomChange: (value: number, mode: SliderChangeMode) => {
              this.editController?.handleZoomChange(value, mode);
            }
          })
        }
        .padding({
          bottom: getValueByBreakpointSync({
            sm: 19,
            lg: 0
          }, this.currentBreakpoint as BreakpointType)
        })
        .clip(false)
        .tabBar(this.TabBuilderMenu(MainTabId.ZOOM, $r('app.string.zoom')))
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
        this.editState.lastEditMode = this.editState.currentEditMode;
        this.editState.currentEditMode = index;
        if (this.editState.lastEditMode === EditMode.CROP_MODE && this.editState.hasCropChanges()) {
          this.editDialogTitle = $r('app.string.save_crop');
          this.editDialogController.open();
        }
        if (this.editState.lastEditMode === EditMode.ADJUST_MODE && this.editState.hasAdjustChanges()) {
          this.editDialogTitle = $r('app.string.save_adjust');
          this.editDialogController.open();
        }
        if (this.editState.lastEditMode === EditMode.FILTER_MODE && this.editState.hasFilterChanges()) {
          this.editDialogTitle = $r('app.string.save_filter');
          this.editDialogController.open();
        }
      })
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
    })
  }

  build() {
    HdsNavDestination() {
      Stack() {
        this.buildOverlayLayer()
        if (!this.isShow) {
          Flex({
            direction: getValueByBreakpointSync({
              lg: FlexDirection.Row,
              sm: FlexDirection.Column
            }, this.currentBreakpoint as BreakpointType),
            alignItems: ItemAlign.Stretch
          }) {
            this.buildPreviewArea()
            this.buildEditTabs()
          }
          .padding({
            top: this.getUIContext().px2vp(this.safeAreaTop) + CommonConstants.NAVIGATION_HEIGHT,
            bottom: this.getUIContext().px2vp(this.safeAreaBottom)
          })
          .width('100%')
          .height('100%')
        }
      }
      .width('100%')
      .height('100%')
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
            ;
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
  }
}