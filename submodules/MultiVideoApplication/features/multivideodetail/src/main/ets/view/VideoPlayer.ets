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

import { display } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { AvPlayerUtil,
  CommonConstants,
  Logger,
  WindowInfo,
  WindowUtil } from 'multivideobase';
import { DetailConstants } from '../constants/DetailConstants';

const TAG = '[VideoPlayer]';

@Component
export struct VideoPlayer {
  @StorageLink(CommonConstants.WINDOW_UTIL) windowUtil: WindowUtil | undefined = undefined;
  @State currentTime: string = DetailConstants.INITIAL_TIME;
  @State totalTime: string = DetailConstants.INITIAL_TIME;
  @StorageLink(CommonConstants.IS_HALF_FOLDED) isHalfFolded: boolean = false;
  @StorageLink(CommonConstants.CREASE_REGION) creaseRegion: number[] = [];
  @State progress: number = 0;
  @State avplayerState: string = '';
  @StorageLink(CommonConstants.IS_FULL_SCREEN) isFullScreen: boolean = false;
  @ObjectLink mainWindowInfo: WindowInfo;
  @Link videoHeight: number;
  @Link isShowingSideBar: boolean;
  @Link foldStatus: display.FoldStatus;
  @Consume('pageInfo') pageInfo: NavPathStack;
  @Consume('inOnPc') isOnPc: boolean;
  @Consume('isClick') isClick: boolean;
  onEnterFullScreen: () => void = () => {}
  onExitFullScreen: () => void = () => {}
  private avPlayerUtil?: AvPlayerUtil = AvPlayerUtil.getInstance(this.getUIContext());
  private xComponentController: XComponentController = new XComponentController();
  private onPlayerStateChange: () => void = () => {
    if (this.avPlayerUtil) {
      this.currentTime = this.avPlayerUtil.getCurrentTime();
      this.totalTime = this.avPlayerUtil.getTotalTime();
      this.progress = this.avPlayerUtil.getProgress();
      this.avplayerState = this.avPlayerUtil.getAvplayerState();
    }
  };
  private onFoldStatusChange: Callback<display.FoldStatus> = (data: display.FoldStatus) => {
    this.foldStatus = data;
    if (canIUse('SystemCapability.Window.SessionManager')) {
      if (data === display.FoldStatus.FOLD_STATUS_HALF_FOLDED) {
        try {
          let orientation: display.Orientation = display.getDefaultDisplaySync().orientation;
          if ((orientation === display.Orientation.LANDSCAPE ||
            orientation === display.Orientation.LANDSCAPE_INVERTED) &&
            this.mainWindowInfo.widthBp === WidthBreakpoint.WIDTH_MD) {
            this.isHalfFolded = true;
            // Full-screen playback.
            if (!this.isFullScreen) {
              this.onEnterFullScreen();
            }
          }
        } catch (error) {
          let err = error as BusinessError;
          Logger.error(TAG, `getDefaultDisplaySync failed, errCode = ${err.code}, errMessage = ${err.message}.`)
        }
      } else {
        this.isHalfFolded = false;
      }
    }
  };

  aboutToAppear(): void {
    this.avPlayerUtil = AvPlayerUtil.getInstance(this.getUIContext());
    this.avPlayerUtil?.addStateChangeListener(this.onPlayerStateChange);
    this.onPlayerStateChange();
    if (canIUse('SystemCapability.Window.SessionManager')) {
      try {
        display.on('foldStatusChange', this.onFoldStatusChange);
      } catch (error) {
        let err = error as BusinessError;
        Logger.error(TAG, `onFoldStatusChange failed, errCode = ${err.code}, errMessage = ${err.message}.`);
      }
    }
  }

  aboutToDisappear(): void {
    this.avPlayerUtil?.removeStateChangeListener(this.onPlayerStateChange);
    if (canIUse('SystemCapability.Window.SessionManager')) {
      try {
        display.off('foldStatusChange');
      } catch (error) {
        let err = error as BusinessError;
        Logger.error(TAG, `onFoldStatusChange failed, errCode = ${err.code}, errMessage = ${err.message}.`);
      }
    }
  }

  build() {
    Stack({ alignContent: this.isFullScreen ? Alignment.Center : Alignment.Bottom }) {
      Flex({
        direction: FlexDirection.Column,
        justifyContent: this.isHalfFolded ? FlexAlign.Start : FlexAlign.Center,
        alignItems: ItemAlign.Start
      }) {
        Column() {
          XComponent({
            id: 'home',
            type: XComponentType.SURFACE,
            controller: this.xComponentController
          })
            .onLoad(() => {
              this.avPlayerUtil?.createAvPlayer(this.xComponentController.getXComponentSurfaceId(),
                CommonConstants.PRODUCT_VIDEO_NAME);
              AppStorage.setOrCreate(CommonConstants.DETAIL_SURFACE_ID,
                this.xComponentController.getXComponentSurfaceId());
            })
            .width(this.isFullScreen ? -1 : this.videoHeight + '%')
            .aspectRatio(1.78)
        }
        .justifyContent(FlexAlign.Center)
        .height(this.isHalfFolded ? (this.creaseRegion.length > 0 ? this.creaseRegion[0] : 'auto') :
          (this.isFullScreen ? '100%' : 'auto'))
        .width('100%')
      }
      .width('100%')
      .onClick(() => {
        if (this.isShowingSideBar) {
          this.isShowingSideBar = false;
        } else {
          this.avPlayerUtil?.playerStateControl();
        }
      })
      .priorityGesture(
        TapGesture({ count: 2 })
          .onAction((event: GestureEvent) => {
            if (event) {
              if (this.isHalfFolded) {
                this.isHalfFolded = false;
              }
              if (this.isFullScreen) {
                this.isClick = false;
                this.onExitFullScreen();
              } else {
                this.isClick = true;
                this.onEnterFullScreen();
              }
            }
          })
      )

      Column() {
        Row() {
          TimeText({ time: this.currentTime })
            .margin({
              left: '24vp',
              right: '2vp'
            })

          Slider({
            min: 0,
            max: 100,
            step: 1,
            value: this.progress
          })
            .onChange((value: number, mode: SliderChangeMode) => {
              this.avPlayerUtil?.sliderChange(value, mode);
            })
            .layoutWeight(1)
            .selectedColor($r('app.color.vd_slider_selected'))

          TimeText({ time: this.totalTime })
            .margin({
              left: '2vp',
              right: '24vp'
            })
        }
        .width('100%')
        .height('40vp')
        .alignItems(VerticalAlign.Center)
        .visibility(this.isFullScreen ? Visibility.Visible : Visibility.None)

        Row() {
          Row() {
            Image(this.avplayerState === 'playing' ? $r('app.media.ic_public_pause') : $r('app.media.ic_public_play'))
              .height('24vp')
              .width('24vp')
              .margin({ left: '24vp' })
              .onClick(() => {
                this.avPlayerUtil?.playerStateControl();
              })
            this.ImgIcon($r('app.media.ic_public_play_next'))
            this.ImgIcon($r('app.media.ic_public_view_list_white'))
          }
          .margin({
            top: this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM ? '4vp' : '16vp',
            bottom: this.mainWindowInfo.widthBp <=  WidthBreakpoint.WIDTH_SM ? '19vp' : '28vp'
          })

          Blank()

          Row() {
            this.TextButton($r('app.string.selections'), ()=>{
              this.isShowingSideBar = !this.isShowingSideBar;
            })
            this.TextButton($r('app.string.super'))
            this.TextButton($r('app.string.super'))
          }
          .margin({
            top: this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM ? '4vp' : '16vp',
            bottom: this.mainWindowInfo.widthBp <=  WidthBreakpoint.WIDTH_SM ? '19vp' : '28vp'
          })
        }
        .height('60vp')
        .width('100%')
        .visibility(this.isFullScreen ? Visibility.Visible : Visibility.None)
      }
      .height(this.isFullScreen ? '100%' : 'auto')
      .width('100%')
      .justifyContent(FlexAlign.End)
      .visibility(this.isFullScreen && !this.isShowingSideBar ? Visibility.Visible : Visibility.None)
      .priorityGesture(
        TapGesture({ count: 2 })
          .onAction((event: GestureEvent) => {
            if (event) {
              if (this.isHalfFolded) {
                this.isHalfFolded = false;
              }
              if (this.isFullScreen) {
                this.isClick = false;
                this.onExitFullScreen();
              } else {
                this.isClick = true;
                this.onEnterFullScreen();
              }
            }
          })
      )

      Row() {
        TimeText({ time: this.currentTime })
          .margin({
            left: '24vp',
            right: '2vp'
          })

        Slider({
          min: 0,
          max: 100,
          step: 1,
          value: this.progress
        })
          .onChange((value: number, mode: SliderChangeMode) => {
            this.avPlayerUtil?.sliderChange(value, mode);
          })
          .layoutWeight(1)
          .selectedColor($r('app.color.vd_slider_selected'))

        TimeText({ time: this.totalTime })
          .margin({
            left: '2vp',
            right: '8vp'
          })

        Image($r('app.media.ic_public_enlarge'))
          .height('24vp')
          .width('24vp')
          .margin({ right: '24vp' })
          .fillColor($r('app.color.vd_white'))
          .onClick(() => {
            this.isClick = true;
            this.onEnterFullScreen();
          })
      }
      .width('100%')
      .height('40vp')
      .alignItems(VerticalAlign.Center)
      .visibility(this.isFullScreen || (this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM &&
        this.mainWindowInfo.heightBp <= HeightBreakpoint.HEIGHT_MD &&
        this.videoHeight < DetailConstants.INITIAL_VIDEO_HEIGHT) ? Visibility.None : Visibility.Visible)


      Row() {
        SymbolGlyph($r('sys.symbol.chevron_left'))
          .fontSize('24fp')
          .fontColor([$r('app.color.vd_white')])
      }
      .width('40vp')
      .height('40vp')
      .justifyContent(FlexAlign.Center)
      .backgroundColor(this.isOnPc ? $r('app.color.vd_transparent') : $r('app.color.vd_player_back_button_background'))
      .borderRadius('50%')
      .position({
        x: this.isOnPc ? '16vp' : this.mainWindowInfo.widthBp < WidthBreakpoint.WIDTH_LG ? '24vp' : '32vp',
        y: (this.isHalfFolded && this.isFullScreen) ? this.creaseRegion[0] + 24 : this.isOnPc ? '12vp' : this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM &&
          this.mainWindowInfo.heightBp <= HeightBreakpoint.HEIGHT_MD ? '24vp' : '36vp'
      })
      .visibility((this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM &&
        this.mainWindowInfo.heightBp <= HeightBreakpoint.HEIGHT_MD &&
        this.videoHeight < DetailConstants.INITIAL_VIDEO_HEIGHT) || this.isShowingSideBar ? Visibility.None :
        Visibility.Visible)
      .onClick(() => {
        this.isClick = false;
        if (this.isHalfFolded) {
          this.isHalfFolded = false;
        }
        if (this.isFullScreen) {
          this.onExitFullScreen();
        } else {
          this.pageInfo.pop();
        }
      })
    }
    .height(this.isFullScreen && this.mainWindowInfo.widthBp <= WidthBreakpoint.WIDTH_SM &&
      this.mainWindowInfo.heightBp <= HeightBreakpoint.HEIGHT_MD && this.isShowingSideBar ? '130vp' : 'auto')
    .layoutWeight(this.isFullScreen ? 1 : 0)
    .width('100%')
    .backgroundColor($r('app.color.vd_black'))
    .focusable(false)
  }

  @Builder
  ImgIcon(img: ResourceStr = '') {
    Image(img)
      .height('24vp')
      .width('24vp')
      .margin({ left: '24vp' })
  }

  @Builder
  TextButton(content: ResourceStr = '', callback?: Function) {
    Text(content)
      .fontSize('12fp')
      .fontWeight(FontWeight.Normal)
      .fontColor($r('app.color.vd_white'))
      .margin({ right: '24vp' })
      .onClick(() => {
        callback && callback()
      })
  }
}

@Component
struct TimeText {
  @Link time: string;

  build() {
    Text(this.time)
      .fontSize('9fp')
      .fontColor($r('app.color.vd_white'))
      .lineHeight('12vp')
      .width('38vp')
  }
}