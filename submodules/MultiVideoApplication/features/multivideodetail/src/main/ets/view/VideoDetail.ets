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

import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { KeyCode } from '@kit.InputKit';
import { display, window } from '@kit.ArkUI';
import {
  AvPlayerUtil,
  DeviceScreen,
  ImmersiveType,
  Logger,
  WindowUtil,
  BreakpointConstants,
  DisplayUtil,
  WindowInfo,
  BreakpointVisibilityUtil,
  SetDecorButtonStyleUtil,
  CommonConstants
} from 'multivideobase';
import { SelfComment } from './SelfComment';
import { AllComments } from './AllComments';
import { VideoDetailView } from './VideoDetailView';
import { DetailConstants } from '../constants/DetailConstants';
import UserInfoItemListViewModel from '../viewmodel/UserInfoItemListViewModel';
import UserSelfItemViewModel from '../viewmodel/UserSelfItemViewModel';

const TAG = '[VideoDetail]';

@Component
export struct VideoDetail {
  @StorageLink(CommonConstants.WINDOW_UTIL) windowUtil: WindowUtil | undefined = undefined;
  @StorageLink(CommonConstants.IS_HALF_FOLDED) @Watch('onHalfFoldedChange') isHalfFolded: boolean = false;
  @StorageLink(CommonConstants.IS_FULL_SCREEN) @Watch('onFullScreenChange') isFullScreen: boolean = false;
  @ObjectLink mainWindowInfo: WindowInfo;
  @Consume('pageInfo') pageInfo: NavPathStack;
  @Consume('currentTopIndex') currentTopIndex: number = 0;
  @Consume('inOnPc') isOnPc: boolean;
  @State commentImgHeight: string = DetailConstants.INITIAL_COMMENT_IMAGE_HEIGHT;
  @State commentImgWidth: string = DetailConstants.INITIAL_COMMENT_IMAGE_WIDTH;
  @State relatedVideoHeight: number = DetailConstants.INITIAL_RELATED_VIDEO_HEIGHT;
  @State videoHeight: number = DetailConstants.INITIAL_VIDEO_HEIGHT;
  @State currentYOffset: number = 0;
  @State isHidingSelfComment: boolean = false;
  @Provide('immersiveTypeBefore') immersiveTypeBefore: WindowStatusType = window.WindowStatusType.UNDEFINED;
  @Provide('immersiveTypeCurrent') immersiveTypeCurrent: WindowStatusType = window.WindowStatusType.UNDEFINED;
  @Provide('isClick') isClick: boolean = false;
  @State userInfoItemListViewModel: UserInfoItemListViewModel = new UserInfoItemListViewModel();
  @State userSelfItemViewModel: UserSelfItemViewModel = new UserSelfItemViewModel();
  @State commentInput: string = '';
  private widthBpBefore: WidthBreakpoint = this.mainWindowInfo.widthBp;
  private heightBpBefore: HeightBreakpoint = this.mainWindowInfo.heightBp;
  private windowWidthBefore: number = this.mainWindowInfo.windowSize.width;
  private windowHeightBefore: number = this.mainWindowInfo.windowSize.height;
  private isExitByTap: boolean = false;
  private avPlayerUtil?: AvPlayerUtil = AvPlayerUtil.getInstance(this.getUIContext());
  public screenHeight: number = 0;
  private mainWindow?: window.Window;
  @StorageLink(CommonConstants.SYSTEM_COLOR_MODE_VERSION) @Watch('onSystemColorModeVersionChange') systemColorModeVersion: number = 0;

  onSystemColorModeVersionChange(): void {
    this.syncDecorButtonStyle();
  }

  private syncDecorButtonStyle(): void {
    const ctx = this.getUIContext().getHostContext() as common.UIAbilityContext;
    if ((this.mainWindowInfo.windowStatusType === window.WindowStatusType.FLOATING ||
      this.mainWindowInfo.windowStatusType === window.WindowStatusType.MAXIMIZE) && this.isFullScreen) {
      if (!this.isOnPc) {
        try {
          let windowStatus = this.windowUtil?.mainWindow.getWindowStatus();
          if (windowStatus === window.WindowStatusType.FLOATING) {
            SetDecorButtonStyleUtil.setDecorButtonForDark(this.windowUtil);
          } else {
            SetDecorButtonStyleUtil.setDecorButtonForNormal(this.windowUtil, ctx);
          }
        } catch (error) {
          let err = error as BusinessError;
          Logger.error(TAG, `Window getWindowStatus failed, errCode = ${err.code}, errMessage = ${err.message}.`);
        }
      } else {
        SetDecorButtonStyleUtil.setDecorButtonForDark(this.windowUtil);
      }
    } else {
      SetDecorButtonStyleUtil.setDecorButtonForNormal(this.windowUtil, ctx);
    }
  }
  private breakpointFlags() {
    return BreakpointVisibilityUtil.getFlags(this.mainWindowInfo);
  }

  private isPortraitBreakpoint(widthBp: WidthBreakpoint, heightBp: HeightBreakpoint): boolean {
    return widthBp === WidthBreakpoint.WIDTH_SM && heightBp === HeightBreakpoint.HEIGHT_LG;
  }

  private isLandscapeBreakpoint(widthBp: WidthBreakpoint, heightBp: HeightBreakpoint, windowWidth: number,
    windowHeight: number): boolean {
    return (widthBp === WidthBreakpoint.WIDTH_MD && heightBp === HeightBreakpoint.HEIGHT_SM) ||
      (widthBp === WidthBreakpoint.WIDTH_LG && heightBp === HeightBreakpoint.HEIGHT_SM &&
        (windowHeight / windowWidth) < DetailConstants.LANDSCAPE_RATIO_THRESHOLD);
  }

  /**
   * Handles window size changes and updates orientation for video playback.
   */
  private onWindowSizeChange: (windowSize: window.Size) => void = () => {
    if ((this.mainWindowInfo.windowStatusType === window.WindowStatusType.FLOATING ||
        this.mainWindowInfo.windowStatusType === window.WindowStatusType.MAXIMIZE) && this.isFullScreen) {
      if (!this.isOnPc) {
        try {
          let windowStatus = this.windowUtil?.mainWindow.getWindowStatus();
          if (windowStatus === window.WindowStatusType.FLOATING) {
            SetDecorButtonStyleUtil.setDecorButtonForDark(this.windowUtil);
          } else {
            SetDecorButtonStyleUtil.setDecorButtonForNormal(this.windowUtil,
              this.getUIContext().getHostContext() as common.UIAbilityContext);
          }
        } catch (error) {
          let err = error as BusinessError;
          Logger.error(TAG, `Window getWindowStatus failed, errCode = ${err.code}, errMessage = ${err.message}.`);
        }
      } else {
        SetDecorButtonStyleUtil.setDecorButtonForDark(this.windowUtil);
      }
    }
    if (this.isExitByTap && this.isPortraitBreakpoint(this.mainWindowInfo.widthBp, this.mainWindowInfo.heightBp)) {
      return;
    } else {
      this.isExitByTap = false;
    }
    if (this.isClick) {
      if (this.isPortraitBreakpoint(this.mainWindowInfo.widthBp, this.mainWindowInfo.heightBp) ||
        this.isLandscapeBreakpoint(this.mainWindowInfo.widthBp, this.mainWindowInfo.heightBp,
          this.mainWindowInfo.windowSize.width, this.mainWindowInfo.windowSize.height)) {
        this.windowUtil?.setWindowOrientation(window.Orientation.AUTO_ROTATION_LANDSCAPE_RESTRICTED);
      } else {
        this.windowUtil?.setWindowOrientation(window.Orientation.AUTO_ROTATION_UNSPECIFIED);
      }
    } else {
      if (this.isFullScreen) {
        if (this.isLandscapeBreakpoint(this.widthBpBefore, this.heightBpBefore, this.windowWidthBefore,
          this.windowHeightBefore) &&
          this.isPortraitBreakpoint(this.mainWindowInfo.widthBp, this.mainWindowInfo.heightBp)) {
          this.exitFullScreen();
        } else if (!this.isLandscapeBreakpoint(this.widthBpBefore, this.heightBpBefore, this.windowWidthBefore,
          this.windowHeightBefore) &&
          (this.isPortraitBreakpoint(this.mainWindowInfo.widthBp, this.mainWindowInfo.heightBp) ||
            this.isLandscapeBreakpoint(this.mainWindowInfo.widthBp, this.mainWindowInfo.heightBp,
              this.mainWindowInfo.windowSize.width, this.mainWindowInfo.windowSize.height))) {
          this.windowUtil?.setWindowOrientation(window.Orientation.AUTO_ROTATION_LANDSCAPE_RESTRICTED);
        } else {
          if (!this.isHalfFolded) {
            this.windowUtil?.setWindowOrientation(window.Orientation.AUTO_ROTATION_UNSPECIFIED);
          }
        }
      } else {
        if (this.isLandscapeBreakpoint(this.mainWindowInfo.widthBp, this.mainWindowInfo.heightBp,
          this.mainWindowInfo.windowSize.width, this.mainWindowInfo.windowSize.height)) {
          try {
            let windowStatus = this.windowUtil?.mainWindow.getWindowStatus();
            if (windowStatus === window.WindowStatusType.FULL_SCREEN) {
              this.enterFullScreen();
            }
          } catch (error) {
            let err = error as BusinessError;
            Logger.error(TAG, `Window getWindowStatus failed, errCode = ${err.code}, errMessage = ${err.message}.`);
          }
        } else {
          this.windowUtil?.setWindowOrientation(window.Orientation.AUTO_ROTATION_RESTRICTED);
        }
      }
    }
    this.widthBpBefore = this.mainWindowInfo.widthBp;
    this.heightBpBefore = this.mainWindowInfo.heightBp;
    this.windowWidthBefore = this.mainWindowInfo.windowSize.width;
    this.windowHeightBefore = this.mainWindowInfo.windowSize.height;
  };

  private onHalfFoldedChange(): void {
    if (this.isHalfFolded) {
      this.windowUtil?.setWindowOrientation(window.Orientation.AUTO_ROTATION_LANDSCAPE_RESTRICTED);
    } else {
      if (this.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_MD &&
        this.mainWindowInfo.heightBp === HeightBreakpoint.HEIGHT_MD) {
        this.windowUtil?.setWindowOrientation(window.Orientation.AUTO_ROTATION_UNSPECIFIED);
      }
    }
  }

  private onFullScreenChange(): void {
    if (this.isFullScreen) {
      if (this.isPortraitBreakpoint(this.mainWindowInfo.widthBp, this.mainWindowInfo.heightBp)) {
        this.windowUtil?.setWindowOrientation(window.Orientation.AUTO_ROTATION_LANDSCAPE_RESTRICTED);
      } else {
        if (!this.isHalfFolded) {
          this.windowUtil?.setWindowOrientation(window.Orientation.AUTO_ROTATION_UNSPECIFIED);
        }
      }
    } else {
      if (this.isLandscapeBreakpoint(this.mainWindowInfo.widthBp, this.mainWindowInfo.heightBp,
        this.mainWindowInfo.windowSize.width, this.mainWindowInfo.windowSize.height)) {
        this.windowUtil?.setWindowOrientation(window.Orientation.USER_ROTATION_PORTRAIT);
        this.isExitByTap = true;
      } else {
        this.windowUtil?.setWindowOrientation(window.Orientation.AUTO_ROTATION_UNSPECIFIED);
      }
    }

    // The navigation bar is hidden in full-screen playback. Otherwise, the navigation bar is displayed.
    this.windowUtil?.setSystemBarEnabled(!this.isFullScreen);
  }

  /**
   * Enters fullscreen immersive playback; updates immersive state before switching window mode.
   */
  enterFullScreen(): void {
    try {
      if (this.windowUtil !== undefined) {
        this.immersiveTypeBefore = this.windowUtil.mainWindow.getWindowStatus();
      }
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Window getWindowStatus failed, errCode = ${err.code}, errMessage = ${err.message}.`);
    }
    this.windowUtil?.setImmersiveType(ImmersiveType.FULLSCREEN_IMMERSIVE);
    this.isFullScreen = true;
  }

  /**
   * Exits fullscreen and restores window to maximized or floating when applicable.
   */
  exitFullScreen(): void {
    this.isFullScreen = false;
    try {
      if (this.windowUtil !== undefined) {
        this.immersiveTypeCurrent = this.windowUtil.mainWindow.getWindowStatus();
      }
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Window getWindowStatus failed, errCode = ${err.code}, errMessage = ${err.message}.`);
    }
    if (this.immersiveTypeCurrent === window.WindowStatusType.FULL_SCREEN &&
      this.immersiveTypeBefore === window.WindowStatusType.MAXIMIZE) {
      this.windowUtil?.mainWindow.maximize(window.MaximizePresentation.EXIT_IMMERSIVE)
        .catch((err: BusinessError) => {
          Logger.error(TAG,
            `Window maximize failed, errCode = ${err.code}, errMessage = ${err.message}.`);
        });
    } else if (this.immersiveTypeCurrent === window.WindowStatusType.FULL_SCREEN &&
      this.immersiveTypeBefore === window.WindowStatusType.FLOATING) {
      this.windowUtil?.recover();
    }
    SetDecorButtonStyleUtil.setDecorButtonForNormal(this.windowUtil,
      this.getUIContext().getHostContext() as common.UIAbilityContext);
    if (!this.isOnPc) {
      try {
        this.windowUtil?.mainWindow.setWindowDecorVisible(true);
      } catch (error) {
        let err = error as BusinessError;
        Logger.error(TAG, `setWindowDecorVisible failed, errCode = ${err.code}, errMessage = ${err.message}.`);
      }
    }
  }

  aboutToAppear() {
    if (this.windowUtil !== undefined) {
      this.windowUtil.setWindowOrientation(window.Orientation.AUTO_ROTATION_UNSPECIFIED);
      this.immersiveTypeCurrent = this.windowUtil.mainWindow.getWindowStatus();
    }
    DisplayUtil.getFoldCreaseRegion(this.getUIContext());
    this.screenHeight = DeviceScreen.getDeviceHeight();
    this.mainWindow = this.windowUtil?.mainWindow;
    this.mainWindow?.on('windowSizeChange', this.onWindowSizeChange);
  }

  async aboutToDisappear() {
    this.isFullScreen = false;
    this.avPlayerUtil?.release();
    this.mainWindow?.off('windowSizeChange', this.onWindowSizeChange);
    this.windowUtil?.setWindowOrientation(window.Orientation.FOLLOW_DESKTOP);
  }

  build() {
    NavDestination() {
      GridRow({
        columns: {
          sm: 4,
          md: 12,
          lg: 12,
          xl: 12
        }
      }) {
        GridCol({
          span: {
            sm: 4,
            md: 12,
            lg: 12,
            xl: 12
          }
        }) {
          SideBarContainer() {
            Column() {
              // Sidebar area.
              Stack() {
                Scroll() {
                  AllComments({
                    commentImgHeight: this.commentImgHeight,
                    commentImgWidth: this.commentImgWidth,
                    mainWindowInfo: this.mainWindowInfo,
                    userInfoItemListViewModel: this.userInfoItemListViewModel
                  })
                }
                .align(Alignment.Top)
                .scrollBar(BarState.Off)
                .width('100%')
                .padding({ bottom: '12vp' })
                .backgroundColor($r('app.color.vd_page_background'))

                Column()
                  .width('100%')
                  .height(this.getTopHeight())
                  .backgroundColor($r('app.color.vd_page_background'))
                  .visibility(this.isOnPc ? Visibility.Visible : Visibility.None)
              }
              .layoutWeight(1)
              .alignContent(Alignment.Top)

              SelfComment({
                currentYOffset: this.currentYOffset,
                mainWindowInfo: this.mainWindowInfo,
                userSelfItemViewModel: this.userSelfItemViewModel,
                commentInput: this.commentInput
              })
            }
            .visibility(this.breakpointFlags().isWidthBpAboveMdAndHeightBpBelowLg ? Visibility.Visible :
              Visibility.None)
            .justifyContent(FlexAlign.Start)
            .height('100%')
            .width('100%')
            .backgroundColor($r('app.color.vd_page_background'))
            .onAreaChange((newValue: Area) => {
              if (newValue.width !== 0) {
                // Handling when the width of the sidebar changes.
                let sidebarWidthVp: number = this.getUIContext().px2vp(this.mainWindowInfo.windowSize.width) *
                  DetailConstants.SIDE_BAR_WIDTH_RATIO;
                let height: number = DetailConstants.COMMENT_IMAGE_MIN_HEIGHT_NUMBER +
                  (Number(newValue.width) - DetailConstants.SIDE_BAR_MIN_WIDTH_NUMBER) /
                    (sidebarWidthVp - DetailConstants.SIDE_BAR_MIN_WIDTH_NUMBER) *
                    (DetailConstants.COMMENT_IMAGE_MAX_HEIGHT_NUMBER - DetailConstants.COMMENT_IMAGE_MIN_HEIGHT_NUMBER);
                let width: number = DetailConstants.COMMENT_IMAGE_MIN_WIDTH_NUMBER +
                  (Number(newValue.width) - DetailConstants.SIDE_BAR_MIN_WIDTH_NUMBER) /
                    (sidebarWidthVp - DetailConstants.SIDE_BAR_MIN_WIDTH_NUMBER) *
                    (DetailConstants.COMMENT_IMAGE_MAX_WIDTH_NUMBER - DetailConstants.COMMENT_IMAGE_MIN_WIDTH_NUMBER);
                this.commentImgHeight = JSON.stringify(height);
                this.commentImgWidth = JSON.stringify(width);
              }
            })

            Column() {
              // Content area.
              VideoDetailView({
                screenHeight: this.screenHeight,
                relatedVideoHeight: this.relatedVideoHeight,
                videoHeight: this.videoHeight,
                currentYOffset: this.currentYOffset,
                isHidingSelfComment: this.isHidingSelfComment,
                mainWindowInfo: this.mainWindowInfo,
                onEnterFullScreen: () => {
                  this.enterFullScreen();
                },
                onExitFullScreen: () => {
                  this.exitFullScreen();
                },
                userInfoItemListViewModel: this.userInfoItemListViewModel
              })
                .layoutWeight(1)

              SelfComment({
                currentYOffset: this.currentYOffset,
                mainWindowInfo: this.mainWindowInfo,
                userSelfItemViewModel: this.userSelfItemViewModel,
                commentInput: this.commentInput
              })
                .visibility(this.breakpointFlags().isWidthBpAboveMdAndHeightBpBelowLg || this.isFullScreen ?
                  Visibility.None : Visibility.Visible)
            }
            .height('100%')
            .width('100%')
          }
          .showSideBar(this.breakpointFlags().isWidthBpAboveMdAndHeightBpBelowLg && !this.isFullScreen ? true : false)
          .showControlButton(false)
          .autoHide(false)
          .sideBarPosition(SideBarPosition.End)
          .sideBarWidth('400vp')
          .minSideBarWidth('400vp')
          .maxSideBarWidth(this.getUIContext().px2vp(this.mainWindowInfo.windowSize.width * 0.4))
        }
        .height('100%')
      }
      .width('100%')
      .height('100%')
      .onBreakpointChange((breakPoints) => {
        if (breakPoints !== BreakpointConstants.BREAKPOINT_LG && breakPoints !== BreakpointConstants.BREAKPOINT_XL &&
          this.videoHeight < DetailConstants.INITIAL_VIDEO_HEIGHT) {
          this.relatedVideoHeight = 0;
        } else if (breakPoints === BreakpointConstants.BREAKPOINT_LG ||
          breakPoints === BreakpointConstants.BREAKPOINT_XL) {
          this.relatedVideoHeight = DetailConstants.INITIAL_RELATED_VIDEO_HEIGHT;
        } else {
          Logger.info(TAG, `No specific function.`);
        }
      })
    }
    .hideTitleBar(true)
    .onShown(() => {
      if (this.avPlayerUtil?.getAvplayerState() !== DetailConstants.AV_PLAYER_PLAYING_STATE) {
        this.avPlayerUtil?.playerStateControl();
      }
      if (canIUse('SystemCapability.Window.SessionManager')) {
        let isDisplayFoldable: boolean = false;
        try {
          isDisplayFoldable = display.isFoldable();
        } catch (error) {
          let err = error as BusinessError;
          Logger.error(TAG, `Get display isFoldable failed, errCode = ${err.code}, errMessage = ${err.message}.`);
        }
        if (this.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_MD && isDisplayFoldable) {
          this.isHalfFolded = false;
        }
      }
    })
    .onKeyEvent((event?: KeyEvent) => {
      //If the key type is pressed, the subsequent code will not be executed,
      // and the specific key logic will be executed when released.
      if (!event || event.type !== KeyType.Down) {
        return;
      }
      // Space key controls pause/play.
      if (event.keyCode === KeyCode.KEYCODE_SPACE) {
        this.avPlayerUtil?.playerStateControl();
      } else if (event.keyCode === KeyCode.KEYCODE_ESCAPE) {
        //Press ESC to exit full screen.
        if (this.isFullScreen) {
          this.exitFullScreen();
        }
      } else if (event.keyCode === KeyCode.KEYCODE_DPAD_RIGHT) {
        //Right-click fast forward
        this.avPlayerUtil?.fastForward();
      } else if (event.keyCode === KeyCode.KEYCODE_DPAD_LEFT) {
        //Left click to go back quickly
        this.avPlayerUtil?.rewind();
      } else {
        return;
      }
    })
    .onBackPressed(() => {
      if (this.isFullScreen) {
        this.isClick = false;
        this.exitFullScreen();
        return true;
      }
      return false;
    })
  }

  getTopHeight(): number {
    if (!(this.mainWindowInfo.heightBp < HeightBreakpoint.HEIGHT_LG &&
      this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG)) {
      return 0;
    }
    let decorHeight: number | undefined = undefined;
    try {
      decorHeight = this.windowUtil?.mainWindow.getTitleButtonRect().height;
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `Failed to get decorHeight, errCode = ${err.code}, errMessage = ${err.message}.`);
    }
    if (decorHeight !== undefined) {
      return decorHeight;
    } else {
      return 0;
    }
  }
}