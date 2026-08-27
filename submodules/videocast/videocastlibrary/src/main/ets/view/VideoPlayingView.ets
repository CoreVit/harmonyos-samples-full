/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import { promptAction } from '@kit.ArkUI';
import { AVCastPicker, AVCastPickerState, AVCastPickerStyle, avSession } from '@kit.AVSessionKit';
import type { BusinessError } from '@kit.BasicServicesKit';
import { AVPlayerControllerView, VolumeControllerView } from './AVPlayerControllerView';
import { BreakpointType, BreakpointTypeEnum } from '../common/utils/BreakpointSystem';
import { CommonConstants, VideoPlayParam } from '../common/constants/CommonConstants';
import { AVCastController } from '../controller/AVCastController';
import { VideoPlayerController } from '../controller/VideoPlayerController';
import { VideoSessionController } from '../controller/VideoSessionController';
import { VideoData } from '../model/VideoData';
import Logger from '../common/utils/Logger';

const TAG = 'VideoPlayingView';

@Component
export struct VideoPlayingView {
  @StorageLink(CommonConstants.KEY_PREFIX + 'Breakpoint') currentWidthBreakpoint: string = 'sm';
  @StorageLink(CommonConstants.KEY_PREFIX + 'NaviIndicatorHeight') naviIndicatorHeight: number = 0;
  @StorageLink('castAvPlayerController') @Watch('avPlayerStateChange') avPlayerController?: VideoPlayerController =
    undefined;
  @StorageLink(CommonConstants.KEY_PREFIX + 'AvCastController') avCastController?: AVCastController = undefined;
  @StorageLink('deviceName') deviceName: string = '';
  @StorageLink('castingList') castingList: string[] = [];
  @StorageLink('castAvSessionController') @Watch('avSessionControllerChange') avSessionController ?: VideoSessionController =
    undefined;
  @StorageLink('avplayerContinueIndex') avplayerContinueIndex: number = 0;
  @Consume('remoteControlPathStack') remoteControlPathStack: NavPathStack;
  @Prop videoType: string;
  @Prop videoList: VideoData[];
  @Link @Watch('videoIndexChange') videoIndex: number;
  @State surfaceID: string = '';
  @State currentTime: number = 0;
  @State durationTime: number = 0;
  @State isPlaying: boolean = false;
  @State volumeValue: number = 0;
  @State isShowVolumeController: boolean = false;
  @State isShowAVPlayerController: boolean = false;
  @State avPlayerControllerTimeID: number = 0;
  @State connectionState: avSession.ConnectionState = avSession.ConnectionState.STATE_DISCONNECTED;
  public videoPlayPathStack: NavPathStack = new NavPathStack();
  private xComponentController = new XComponentController();
  @State showLoading: boolean = false;
  private switchable: boolean = true;

  aboutToDisappear(): void {
    clearTimeout(this.avPlayerControllerTimeID);
  }

  avSessionControllerChange() {
    if (this.avSessionController) {
      this.deviceName = this.avSessionController.deviceName;
      this.connectionState = this.avSessionController.connectionState;
    }
  }

  async avPlayerStateChange() {
    if (this.avPlayerController) {
      this.currentTime = this.avPlayerController.currentTime;
      this.durationTime = this.avPlayerController.durationTime;
      this.isPlaying = this.avPlayerController.state === 'playing';
      if (this.isPlaying === true) {
        this.showLoading = false;
      }

      this.volumeValue = this.avPlayerController.volume;
      if (this.avPlayerController.state === 'prepared') {
        this.showLoading = true;
        if (!this.avSessionController) {
          await this.initAVSession();
        } else {
          await this.configSession(false);
        }
      }

      if (this.avPlayerController.state === 'completed') {
        this.nextVideo();
      }
      if (this.avPlayerController.state === 'stopped') {
        this.showLoading = false;
      }

      if (this.avPlayerController.state === 'error') {
        this.showLoading = false;
      }
    }
  }

  async initAVPlayer() {
    this.surfaceID = this.xComponentController.getXComponentSurfaceId();
    this.avPlayerController =
      await VideoPlayerController.create(this.surfaceID, this.videoType, this.videoList[this.videoIndex].url);
    this.showLoading = true;
  }

  async initAVSession() {
    if (this.avPlayerController) {
      this.avSessionController =
        await VideoSessionController.create(this.getUIContext().getHostContext() as common.UIAbilityContext);
      if (this.avSessionController) {
        await this.configSession(true);
      }
    }
  }

  /**
   * Configures AV session with player controller.
   * Sets up metadata, playback state, and event listeners.
   * Handles playNext/playPrevious commands and state synchronization.
   */
  async configSession(isInit: boolean) {
    if (!this.avSessionController || !this.avPlayerController) {
      return;
    }
    if (!isInit) {
      this.avSessionController.releaseAvSessionListener();
    }
    if (!this.videoList || this.videoIndex < 0 || this.videoIndex >= this.videoList.length) {
      return;
    }
    await this.avSessionController.setAVMetadata(this.videoList[this.videoIndex],
      this.videoList[this.videoIndex].duration);
    this.avSessionController.setAvSessionListener(this.avPlayerController);
    this.avSessionController.initAvSessionPlayState(this.avPlayerController);
    try {
      this.avSessionController.videoSession.on('playNext', () => {
        if (this.switchable) {
          this.switchable = false;
          this.nextVideo();
        }
      });
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `listen playNext event failed, code: ${err.code}, meeeage: ${err.message}`);
    }
    await this.initAVCastPicker(this.avSessionController.videoSession);
    this.avPlayerController.onStateChange(async (newState: string) => {
      this.avSessionController?.setAvSessionState(newState);
    });
    this.avPlayerController.onSpeedChange(async (newSpeed: number) => {
      this.avSessionController?.setAvSessionSpeed(newSpeed);
    });
    this.avPlayerController.onPositionChange(async (newPosition: number) => {
      this.avSessionController?.setAvSessionPosition(newPosition);
    });
  }

  /**
   * Initializes AV casting device picker and handles device connection changes.
   * Manages remote/local device connections and playback transitions.
   * @param videoSession: The AV session to configure for casting.
   */
  async initAVCastPicker(videoSession: avSession.AVSession) {
    try {
      await videoSession.setExtras({
        requireAbilityList: ['url-cast']
      })
      videoSession.on('outputDeviceChange', async (connectState: avSession.ConnectionState,
        device: avSession.OutputDeviceInfo) => {
        Logger.info(TAG, `connectState ${JSON.stringify(connectState)}`);
        if (device.devices.length > 0) {
          if (this.avSessionController) {
            this.avSessionController.connectionState = connectState;
            this.avSessionController.deviceName = device.devices[0].deviceName;
          }
          // The linked device is a remote device.
          if (device.devices[0].castCategory === avSession.AVCastCategory.CATEGORY_REMOTE &&
            connectState === avSession.ConnectionState.STATE_CONNECTED) {
            this.remoteControlPathStack.replacePath({ name: 'detail', param: this.currentTime });
            this.castingList.push(this.videoType);
            await this.releaseAVPlayer();
            // The linked device is the local device.
          } else if (device.devices[0].castCategory === avSession.AVCastCategory.CATEGORY_REMOTE &&
            connectState === avSession.ConnectionState.STATE_DISCONNECTED) {
            if (this.avCastController) {
              await this.avCastController.releaseAVCast();
              if (this.avSessionController) {
                await this.avSessionController.stopCasting();
              }
              this.avCastController = undefined;
            }
          } else if (device.devices[0].castCategory === avSession.AVCastCategory.CATEGORY_LOCAL) {
            this.remoteControlPathStack.clear();
            this.castingList = [];
            let videoPlayParam = new VideoPlayParam(this.videoType, 0, this.avplayerContinueIndex);
            this.videoPlayPathStack.replacePath({ name: 'detail', param: videoPlayParam });
            if (this.avCastController) {
              await this.avCastController.releaseAVCast();
              if (this.avSessionController) {
                await this.avSessionController.stopCasting();
              }
              this.avCastController = undefined;
            }
          }
        }
      })
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `initAVCastPicker failed, error code: ${err.code}, message: ${err.message}`);
    }

  }

  async releaseAVPlayer() {
    if (this.avPlayerController) {
      {
        await this.avPlayerController.releasePlayer();
        this.avPlayerController = undefined;
      }
    }
  }

  async releaseAVSession() {
    if (this.avSessionController) {
      await this.avSessionController.destroyAvSessionListener(this.getUIContext()
        .getHostContext() as common.UIAbilityContext);
      this.avSessionController = undefined;
    }
  }

  async videoIndexChange() {
    if (!this.castingList.includes(this.videoType)) {
      await this.releaseAVPlayer();
      await this.initAVPlayer();
    }
    this.switchable = true;
  }

  /**
   * Shows AV player controls temporarily.
   * Hides controls automatically after 2 seconds.
   */
  showAVPlayerController() {
    this.isShowAVPlayerController = true;
    clearTimeout(this.avPlayerControllerTimeID);
    this.avPlayerControllerTimeID = setTimeout(() => {
      this.isShowAVPlayerController = false;
    }, 2000);
  }

  nextVideo() {
    if (this.videoIndex < this.videoList.length - 1) {
      this.videoIndex += 1;
    } else {
      this.videoIndex = 0;
    }
    this.switchable = true;
    this.showLoading = true;
  }

  /**
   * Load XComponent.
   */
  async onDidBuild() {
    await this.releaseAVPlayer();
    if (!this.castingList.includes(this.videoType)) {
      await this.initAVPlayer();
    }
  }

  build() {
    RelativeContainer() {
      Stack() {
        XComponent({
          id: 'player',
          type: XComponentType.SURFACE,
          controller: this.xComponentController
        })
          .width('100%')
          .aspectRatio(1920 / 1080)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center },
          })
        LoadingProgress()
          .color(Color.White)
          .width(50)
          .height(50)
          .visibility(this.showLoading && this.videoType === 'network' ? Visibility.Visible : Visibility.None)
      }
      .width('100%')
      .height('100%')

      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween }) {
        Row() {
          Row() {
            SymbolGlyph($r('sys.symbol.chevron_left'))
              .fontSize(24)
              .fontColor([Color.White])
          }
          .width(40)
          .height(40)
          .backgroundColor('rgba(255,255,255,0.1)')
          .borderRadius(20)
          .justifyContent(FlexAlign.Center)
          .onClick(async () => {
            await this.releaseAVPlayer();
            if (this.castingList.length === 0) {
              await this.releaseAVSession();
            }
            this.videoPlayPathStack.pop();
          })

          Blank()

          Button() {
            AVCastPicker({
              normalColor: Color.White,
              pickerStyle: AVCastPickerStyle.STYLE_PANEL,
              sessionType: 'video',
              onStateChange: ((state: AVCastPickerState) => {
                if (state === AVCastPickerState.STATE_APPEARING) {
                  this.isShowAVPlayerController = true;
                  clearTimeout(this.avPlayerControllerTimeID);
                } else {
                  this.avPlayerControllerTimeID = setTimeout(() => {
                    this.isShowAVPlayerController = false;
                  }, 2000)
                }
              })
            })
              .width(24)
              .height(24)
          }
          .width(40)
          .height(40)
          .backgroundColor('rgba(255,255,255,0.1)')
          .borderRadius(20)
          .visibility((this.isShowAVPlayerController && this.castingList.length === 0) ? Visibility.Visible :
            Visibility.Hidden)
          .hitTestBehavior(this.currentWidthBreakpoint === BreakpointTypeEnum.XL ? HitTestMode.Block :
            HitTestMode.Default)
          .onClick(() => {
            if (this.currentWidthBreakpoint === BreakpointTypeEnum.XL) {
              try {
                this.getUIContext().getPromptAction().showToast({
                  message: $r('app.string.cast_hit'),
                  duration: 2000,
                  showMode: promptAction.ToastShowMode.DEFAULT,
                })
              } catch (error) {
                const err = error as BusinessError;
                Logger.error(TAG, `showToast failed, error: ${err.code}, message: ${err.message}`);
              }
            }
          })

        }
        .width('100%')
        .height(56)
        .alignItems(VerticalAlign.Center)
        .linearGradient({
          direction: GradientDirection.Top,
          colors: [['rgba(0,0,0,0)', 0.0], ['rgba(0,0,0,0.1)', 1.0]]
        })
        .padding({
          left: new BreakpointType({
            sm: $r('sys.float.padding_level8'),
            md: $r('sys.float.padding_level12'),
            lg: $r('sys.float.padding_level16')
          }).getValue(this.currentWidthBreakpoint),
          right: new BreakpointType({
            sm: $r('sys.float.padding_level8'),
            md: $r('sys.float.padding_level12'),
            lg: $r('sys.float.padding_level16')
          }).getValue(this.currentWidthBreakpoint)
        })

        VolumeControllerView({
          volumeValue: this.volumeValue
        })
          .visibility(this.isShowVolumeController ? Visibility.Visible : Visibility.Hidden)
          .alignSelf(ItemAlign.Center)
        AVPlayerControllerView({
          currentTime: this.currentTime,
          durationTime: this.durationTime,
          isPlaying: this.isPlaying,
          isShowAVPlayerController: this.isShowAVPlayerController,
          avPlayerControllerTimeID: this.avPlayerControllerTimeID
        })
          .visibility(this.isShowAVPlayerController ? Visibility.Visible : Visibility.Hidden)
          .linearGradient({
            direction: GradientDirection.Bottom,
            colors: [['rgba(0,0,0,0)', 0.0], ['rgba(0,0,0,0.1)', 1.0]]
          })
          .padding({
            left: new BreakpointType({
              sm: $r('sys.float.padding_level8'),
              md: $r('sys.float.padding_level12'),
              lg: $r('sys.float.padding_level16')
            }).getValue(this.currentWidthBreakpoint),
            right: new BreakpointType({
              sm: $r('sys.float.padding_level8'),
              md: $r('sys.float.padding_level12'),
              lg: $r('sys.float.padding_level16')
            }).getValue(this.currentWidthBreakpoint)
          })
      }
      .onClick(() => {
        this.showAVPlayerController();
      })
      .gesture(
        PanGesture()
          .onActionStart((event: GestureEvent | undefined) => {
            if (event!.velocityX < 10 && event!.velocityY != 0) {
              this.isShowVolumeController = true;
            }
            ;
          })
          .onActionUpdate((event: GestureEvent | undefined) => {
            if (!event || !this.avPlayerController) {
              return;
            }
            this.showAVPlayerController();
            if (event.velocityX < 10 && event.velocityY != 0) {
              this.isShowVolumeController = true;
              if (this.volumeValue - (event.velocityY / 1000) > 0 && this.volumeValue - (event.velocityY / 1000) < 1) {
                this.avPlayerController.setAVPlayerVolume(this.volumeValue - (event!.velocityY / 10000));
              }
            }
          })
          .onActionEnd(() => {
            setTimeout(() => {
              this.isShowVolumeController = false;
            }, 100)
          })
      )
    }
    .width('100%')
    .height('100%')
    .padding({
      bottom: (this.currentWidthBreakpoint === BreakpointTypeEnum.LG ||
        this.currentWidthBreakpoint === BreakpointTypeEnum.XL) ?
        (this.naviIndicatorHeight !== 0 ? this.naviIndicatorHeight : 8) : 0
    })
  }
}