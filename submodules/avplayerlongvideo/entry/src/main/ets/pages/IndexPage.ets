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

import { window } from '@kit.ArkUI';
import { emitter } from '@kit.BasicServicesKit';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { SOURCES } from '../model/VideoSourceModel';
import { VideoData } from '../model/VideoData';
import { WindowUtil } from '../common/utils/WindowUtil';
import { CommonConstants } from '../common/constants/CommonConstants';
import { KeyConstants } from '../common/constants/KeyConstants';
import { VideoList } from '../view/VideoList';
import { AVPlayer } from '../view/AVPlayer';
import Logger from '../common/utils/Logger';

const TAG = '[IndexPage]';

@Entry
@Component
struct IndexPage {
  @Provide('pageInfo') pageInfo: NavPathStack = new NavPathStack();
  @State isFullLandscapeScreen: boolean = false; // Whether the video is played in full screen
  @State sources: VideoData[] = SOURCES; // Local video sources
  @State currentIndex: number = 0; // The index of playing video
  @State isPageShow: boolean = false; // Whether the app is on the front end or back end
  @State showPopup: boolean = false; // Control pop-up display
  private swiperController: SwiperController = new SwiperController();
  private windowUtil: WindowUtil = WindowUtil.getInstance();
  @StorageProp(KeyConstants.KEY_DEVICE_WIDTH) screenWidth: number = 0; // Screen width
  @StorageProp(KeyConstants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageProp(KeyConstants.KEY_WIDTH_BREAKPOINT) widthBp: WidthBreakpoint = WidthBreakpoint.WIDTH_SM;
  @StorageProp(KeyConstants.KEY_HEIGHT_BREAKPOINT) heightBp: HeightBreakpoint = HeightBreakpoint.HEIGHT_LG;
  @StorageProp(KeyConstants.KEY_IS_HALF_FOLDED) isHalfFolded: boolean = false;
  @StorageProp(KeyConstants.KEY_CREASE_REGION) creaseRegion: number[] = [];

  async aboutToAppear(): Promise<void> {
    let context = this.getUIContext().getHostContext() as Context;
    try {
      // Set dark color mode
      context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
      // Set screen stay on during video play
      let windowClass = await window.getLastWindow(context);
      await windowClass.setWindowKeepScreenOn(true);
    } catch (exception) {
      Logger.error(TAG, `setWindowKeepScreenOn failed: code: ${exception.code}, message: ${exception.message}`);
    }
    this.windowUtil.setDecorVisible(false);
    this.windowUtil.setDecorHeight(56);
    this.windowUtil.registerOnWindowSizeChange((size) => {
      if (this.widthBp === WidthBreakpoint.WIDTH_MD && this.heightBp === HeightBreakpoint.HEIGHT_MD) {
        return;
      }
      if (size.width > size.height) {
        this.isFullLandscapeScreen = true;
      } else {
        this.isFullLandscapeScreen = false;
      }
    });
    if (this.widthBp === WidthBreakpoint.WIDTH_MD && this.heightBp === HeightBreakpoint.HEIGHT_SM) {
      this.isFullLandscapeScreen = true;
    }
    emitter.on(CommonConstants.PLAY_PREVIOUS_EVENT_ID, () => {
      this.playPrevious();
    });
    emitter.on(CommonConstants.PLAY_NEXT_EVENT_ID, () => {
      this.playNext();
    });
    AppStorage.setOrCreate(KeyConstants.KEY_IS_PIP_SHOW, false); // Whether to show picture in picture
  }

  aboutToDisappear(): void {
    this.windowUtil.setDecorVisible(true);
    this.windowUtil.registerOffWindowSizeChange();
    this.windowUtil.release();
    emitter.off(CommonConstants.PLAY_PREVIOUS_EVENT_ID);
    emitter.off(CommonConstants.PLAY_NEXT_EVENT_ID);
    this.DeleteAppStorage();
  }

  // [Start SwitchToBackEnd]
  onPageHide(): void {
    this.isPageShow = false;
  }

  // [End SwitchToBackEnd]

  // [Start SwitchToFront]
  onPageShow(): void {
    this.isPageShow = true;
  }

  // [End SwitchToFront]

  DeleteAppStorage(): void {
    AppStorage.delete(KeyConstants.KEY_CONTEXT);
    AppStorage.delete(KeyConstants.KEY_UI_CONTEXT);
    AppStorage.delete(KeyConstants.KEY_WINDOW_STAGE);
    AppStorage.delete(KeyConstants.KEY_DEVICE_WIDTH);
    AppStorage.delete(KeyConstants.KEY_DEVICE_HEIGHT);
    AppStorage.delete(KeyConstants.KEY_STATUS_BAR_HEIGHT);
    AppStorage.delete(KeyConstants.KEY_NAV_BAR_HEIGHT);
    AppStorage.delete(KeyConstants.KEY_WIDTH_BREAKPOINT);
    AppStorage.delete(KeyConstants.KEY_IS_PIP_SHOW);
    AppStorage.delete(KeyConstants.KEY_START_RENDER);
    AppStorage.delete(KeyConstants.KEY_DURATION_TIME);
    AppStorage.delete(KeyConstants.KEY_CURRENT_TIME);
  }

  // Full screen mode back to normal mode
  private handleFullScreenExit() {
    if (this.isFullLandscapeScreen) {
      this.isFullLandscapeScreen = false;
      this.windowUtil.enableWindowSystemBar();
      this.windowUtil.setLandscapeMultiWindow(false);
      if (this.widthBp > WidthBreakpoint.WIDTH_MD ||
        (this.widthBp === WidthBreakpoint.WIDTH_MD && this.heightBp === HeightBreakpoint.HEIGHT_MD)) {
        this.windowUtil.setMainWindowOrientation(window.Orientation.AUTO_ROTATION_RESTRICTED);
        return;
      }
      // [Start SetMainWindowPORTRAIT]
      this.windowUtil.setMainWindowOrientation(window.Orientation.USER_ROTATION_PORTRAIT);
      // [End SetMainWindowPORTRAIT]
    }
  }

  // Background control set to play previous
  private playPrevious() {
    if (this.currentIndex > 0) {
      this.swiperController.changeIndex(--this.currentIndex, false);
    }
  }

  // Background control set to play next
  private playNext() {
    if (this.currentIndex < this.sources.length - 1) {
      this.swiperController.changeIndex(++this.currentIndex, false);
    }
  }

  private getVideoHeight(): number | string {
    return this.isFullLandscapeScreen ? CommonConstants.HEIGHT_FULL_PERCENT :
      (this.widthBp < WidthBreakpoint.WIDTH_LG || this.heightBp === HeightBreakpoint.HEIGHT_LG) ?
        this.getUIContext().px2vp(this.screenWidth) / CommonConstants.ASPECT :
        WindowUtil.getInstance().isPhoneDevice() ? '65%' : CommonConstants.HEIGHT_FULL_PERCENT;
  }

  @Builder
  PopupTitle() {
    Row() {
      Text($r('app.string.more'))
        .fontSize($r('sys.float.Title_S'))
        .fontColor($r('sys.color.font_on_primary'))
        .fontWeight(FontWeight.Bold)
      Blank()
      Row() {
        SymbolGlyph($r('sys.symbol.xmark'))
          .fontSize('18fp')
          .fontColor([Color.White])
      }
      .width(40)
      .height(40)
      .border({
        width: 0,
        radius: 20
      })
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .onClick(() => {
        this.showPopup = false;
      })
      .backgroundColor('rgba(255, 255, 255, 0.1)')
    }
    .width('100%')
    .height(40)
    .alignItems(VerticalAlign.Center)
    .padding({ left: 16, right: 16 })
    .margin({ top: 16, bottom: 8 })
  }

  // Define pop-up content
  @Builder
  popupContent() {
    Column() {
      this.PopupTitle()

      // Set picture in picture
      Row() {
        Text($r('app.string.pip_start'))
          .width(160)
          .fontSize($r('app.float.size_15'))
          .fontWeight(FontWeight.Bold)
          .margin({ left: $r('app.float.size_8') })
          .fontColor($r('app.color.dialog_text_color'))
        Toggle({ type: ToggleType.Switch, isOn: AppStorage.get(KeyConstants.KEY_IS_PIP_SHOW) })
          .onChange((isOn: boolean) => {
            AppStorage.set(KeyConstants.KEY_IS_PIP_SHOW, isOn); // Update the status of the toggle
          })
          .height($r('app.float.size_20'))
          .margin({ right: $r('app.float.size_8') })
          .selectedColor($r('app.color.dialog_cancel_color'))
      }
      .width('95%')
      .height($r('app.float.size_44'))
      .borderRadius($r('app.float.size_20'))
      .justifyContent(FlexAlign.SpaceBetween)
    }
  }

  @Builder
  AppTitle() {
    Row({ space: 12 }) {
      Image($r('app.media.app_icon'))
        .width($r('app.float.size_24'))
        .height($r('app.float.size_24'))

      Text($r('app.string.title_name'))
        .fontSize($r('sys.float.Subtitle_M'))
        .fontColor($r('sys.color.font_on_primary'))
        .fontWeight(FontWeight.Medium)
    }
    .height(56)
    .position({
      x: 24,
      y: 0
    })
    .visibility(!this.isFullLandscapeScreen && this.windowUtil.isPCDevice() ? Visibility.Visible :
      Visibility.None)
  }

  @Builder
  VideoTitle() {
    Button({ type: ButtonType.Circle }) {
      Image($r('sys.media.ohos_ic_public_arrow_left'))
        .fillColor(Color.White)
        .width($r('app.float.size_24'))
        .height($r('app.float.size_24'))
    }
    .width($r('app.float.button_back_size'))
    .height($r('app.float.button_back_size'))
    .backgroundColor('rgba(255,255,255,0.1)')
    .position({
      x: '2%',
      y: !this.isHalfFolded ? (this.statusBarHeight !== 0 ? this.statusBarHeight : $r('app.float.back_position_y')) :
        this.creaseRegion[0] + this.creaseRegion[1]
    })
    .onClick(() => {
      this.handleFullScreenExit();
    })
    .visibility(this.isFullLandscapeScreen ? Visibility.Visible : Visibility.Hidden)

    Text(this.sources[this.currentIndex].name)
      .fontColor(Color.White)
      .fontWeight(FontWeight.Medium)
      .fontSize($r('app.float.size_24'))
      .position({
        x: $r('app.float.size_72'),
        y: !this.isHalfFolded ? (this.statusBarHeight !== 0 ? this.statusBarHeight + 4 : $r('app.float.size_30')) :
          this.creaseRegion[0] + this.creaseRegion[1] + 4
      })
      .visibility(this.isFullLandscapeScreen ? Visibility.Visible : Visibility.Hidden)
  }

  @Builder
  ImageDotGrid() {
    Text() {
      SymbolSpan($r('sys.symbol.dot_grid_2x2'))
        .fontSize($r('app.float.size_25'))
        .fontColor([Color.White])
    }
    .position({
      x: '96%',
      y: this.statusBarHeight !== 0 ? this.statusBarHeight : $r('app.float.size_27')
    })
    .markAnchor({ x: '100%', y: 0 })
    .padding($r('app.float.size_10'))
    .zIndex(1)
    .borderRadius($r('app.float.size_25'))
    .backgroundColor('rgba(255,255,255,0.1)')
    .onClick(() => {
      this.showPopup = !this.showPopup; // Click the button to switch the pop-up status
    })
    .bindSheet(this.showPopup, this.popupContent(), {
      height: '170vp',
      backgroundColor: $r('app.color.dialog_background_color'),
      showClose: false,
      onDisappear: () => {
        this.showPopup = false;
      }
    })
    .visibility(this.isFullLandscapeScreen ? Visibility.Hidden : Visibility.Visible)
  }

  @Builder
  VideoPlayer() {
    Stack() {
      Swiper(this.swiperController) {
        ForEach(this.sources, (item: VideoData, index: number) => {
          Stack() {
            AVPlayer({
              isFullLandscapeScreen: this.isFullLandscapeScreen,
              onFullScreenClick: (isLandscape?: boolean) => {
                if (isLandscape) {
                  this.isFullLandscapeScreen = true;
                  this.windowUtil.disableWindowSystemBar();
                  this.windowUtil.setLandscapeMultiWindow(true);
                  if (this.widthBp === WidthBreakpoint.WIDTH_MD && this.heightBp === HeightBreakpoint.HEIGHT_MD) {
                    return;
                  }
                  // [Start SetMainWindowLANDSCAPE]
                  this.windowUtil.setMainWindowOrientation(window.Orientation.USER_ROTATION_LANDSCAPE);
                  // [End SetMainWindowLANDSCAPE]
                }
              },
              curSource: item,
              curIndex: this.currentIndex,
              index: index,
              isPageShow: this.isPageShow,
            })
          }
        }, (item: string, index: number) => JSON.stringify(item) + index)
      }
      .width(CommonConstants.WIDTH_FULL_PERCENT)
      .height(this.getVideoHeight())
      .vertical(true)
      .loop(false)
      .indicator(false)
      .backgroundColor(Color.Black)
      .onAnimationStart((_index: number, targetIndex: number) => {
        this.currentIndex = targetIndex;
      })
      .onAnimationEnd(() => {
      })

      this.VideoTitle()
      this.ImageDotGrid()
      this.AppTitle()
    }
  }

  @Builder
  VideoScrollList() {
    VideoList({
      currentIndex: this.currentIndex,
      sources: this.sources,
      onItemClick: (index) => {
        this.swiperController.changeIndex(index, false);
        this.currentIndex = index;
      }
    })
      .visibility(this.isFullLandscapeScreen ? Visibility.None : Visibility.Visible)
  }

  @Builder
  VideoDetail() {
    Column() {
      GridRow({
        columns: {
          xs: 4,
          sm: 4,
          md: 8,
          lg: 12,
          xl: 12
        }
      }) {
        GridCol({
          span: {
            xs: 4,
            sm: 4,
            md: 8,
            lg: this.isFullLandscapeScreen || WindowUtil.getInstance().isPhoneDevice() ||
              this.heightBp === HeightBreakpoint.HEIGHT_LG ? 12 : 8,
            xl: this.isFullLandscapeScreen ? 12 : 8
          }
        }) {
          this.VideoPlayer()
        }

        GridCol({
          span: {
            xs: 4,
            sm: 4,
            md: 8,
            lg: this.isFullLandscapeScreen ? 0 :
              (WindowUtil.getInstance().isPhoneDevice() || this.heightBp === HeightBreakpoint.HEIGHT_LG ? 12 : 4),
            xl: this.isFullLandscapeScreen ? 0 : 4
          }
        }) {
          this.VideoScrollList()
        }
      }
    }
    .width(CommonConstants.WIDTH_FULL_PERCENT)
    .height(CommonConstants.HEIGHT_FULL_PERCENT)
  }

  build() {
    Navigation(this.pageInfo) {
      this.VideoDetail()
    }
    .mode(NavigationMode.Stack)
    .hideToolBar(true)
    .hideTitleBar(true)
    .hideBackButton(true)
    .width(CommonConstants.WIDTH_FULL_PERCENT)
    .height(CommonConstants.HEIGHT_FULL_PERCENT)
    .backgroundColor(Color.Black)
  }
}