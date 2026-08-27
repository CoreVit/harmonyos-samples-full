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
 *
 */

import { media } from '@kit.MediaKit';
import { common } from '@kit.AbilityKit';
import { AdaptiveImmersion, getWindowInfoState, Logger, WidthBreakpointType, WindowInfo } from 'multishortvideobase';
import { CommonConstants } from 'multishortvideobase';
import { KeyCode } from '@kit.InputKit';

const TAG = 'AdaptiveAVPlayer';

@ComponentV2
export struct AdaptiveAVPlayer {
  @Local windowInfo: WindowInfo = getWindowInfoState();
  @Param currentIndex: number = -1;
  @Param index: number = 0;
  @Param currentSource: string = '';
  @Local surfaceWidth: Length = '100%';
  @Local surfaceHeight: Length = '100%';
  @Local videoPosition: Position = {};
  @Local currentState: media.AVPlayerState = 'idle';
  @Event onStateNotify: (state: media.AVPlayerState) => void = () => {};
  @Local currentTime: string = '';
  @Consumer('currentTime') currentProgress: number = 0;
  @Consumer('duration') duration: number = 0;
  @Local bottomTabHeight: number = 0
  private avPlayer: media.AVPlayer | undefined = undefined;
  private xComponentController: XComponentController = new XComponentController();
  private surfaceId: string = '';
  private hasPrepared: boolean = false;
  private isInitializing: boolean = false;
  @Local oriSurfaceWidth: Length = '100%';
  @Local oriSurfaceHeight: Length = '100%';
  @Consumer('windowSizeWidth') windowSizeWidth: Length = 0;
  @Consumer('windowSizeHeight') windowSizeHeight: Length = 0;
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;

  @Monitor('currentIndex')
  onIndexChange() {
    if (this.currentIndex !== this.index) {
      this.avPlayer?.pause().catch(() => {
        Logger.error(TAG, 'Pause AVPlayer failed.');
      })
    } else {
      this.changePortraitVideo();
      if (this.hasPrepared) {
        if (this.canPlay()) {
          this.avPlayer?.play().catch(() => {
            Logger.error(TAG, 'Play AVPlayer failed');
          })
        }
      } else {
        this.initAVPlayer()
      }
    }
  }

  @Monitor('windowSizeWidth', 'windowSizeHeight')
  onWindowSizeChange() {
    this.changePortraitVideo();
  }

  build() {
    RelativeContainer() {
      Stack() {
        Column() {
          XComponent({
            id: 'AdaptiveAVPlayer',
            type: XComponentType.SURFACE,
            controller: this.xComponentController
          })
            .width(this.surfaceWidth)
            .height(this.surfaceHeight)
            .position(this.videoPosition)
            .onLoad(() => {
              this.surfaceId = this.xComponentController.getXComponentSurfaceId();
              this.initAVPlayer();
            })
            .gesture(TapGesture({ count: 1 })
              .onAction((_event: GestureEvent) => {
                this.controlPlayOrPause();
              }))
        }
        .width(CommonConstants.FULL_PERCENT)
        .height(CommonConstants.FULL_PERCENT)
        .defaultFocus(true)
        .onKeyEvent((event: KeyEvent) => {
          if (event.type === KeyType.Up && event.keyCode === KeyCode.KEYCODE_SPACE) {
            this.controlPlayOrPause();
          }
        })

        if (this.currentState === CommonConstants.AV_PLAYER_PAUSED_STATE) {
          if (this.windowInfo.widthBp === WidthBreakpoint.WIDTH_XS) {
            Row() {
              SymbolGlyph($r('sys.symbol.play_fill'))
                .fontSize(14)
                .fontColor(['#FFFFFF'])
            }
            .width(28)
            .aspectRatio(1)
            .alignItems(VerticalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .borderRadius(CommonConstants.HALF_PERCENT)
            .backgroundColor('#33FFFFFF')
            .onClick(() => {
              if (this.canPlay()) {
                this.avPlayer?.play().catch(() => {
                  Logger.error(TAG, 'Play AVPlayer failed.');
                })
              }
            })
          } else {
            Image($r('app.media.ic_pause'))
              .height(new WidthBreakpointType<number>(56, 56, 56, 56).getValue(this.windowInfo.widthBp))
              .onClick(() => {
                if (this.canPlay()) {
                  this.avPlayer?.play().catch(() => {
                    Logger.error(TAG, 'Play AVPlayer failed.');
                  })
                }
              })
          }
        }
      }
      .width('100%')
      .height('100%')
      .alignSelf(ItemAlign.Center)
      .align(Alignment.Center)
      .alignContent(Alignment.Center)
    }
  }

  initAVPlayer() {
    if (this.isInitializing) {
      return;
    }
    this.isInitializing = true;
    media.createAVPlayer().then((avplayer: media.AVPlayer) => {
      if (avplayer === undefined) {
        Logger.error(TAG, `Create AVPlayer failed.`);
        return;
      }
      this.avPlayer = avplayer;
      this.addAVPlayerCallback();
      this.avPlayer.fdSrc = this.context.resourceManager.getRawFdSync(this.currentSource);
    }).catch(() => {
      Logger.error(TAG, `Create AVPlayer failed.`);
    })
  }

  aboutToDisappear(): void {
    this.removeAVPlayerCallback();
    this.avPlayer?.release().catch(() => {
      Logger.error(TAG, `Release AVPlayer failed.`);
    })
    this.context.resourceManager.closeRawFdSync(this.currentSource);
  }

  private canPlay(): boolean {
    return (this.avPlayer?.state === CommonConstants.AV_PLAYER_PREPARED_STATE ||
      this.avPlayer?.state === CommonConstants.AV_PLAYER_PAUSED_STATE ||
      this.avPlayer?.state === CommonConstants.AV_PLAYER_COMPLETED_STATE)
  }

  private addAVPlayerCallback() {
    this.avPlayer?.on('stateChange', this.onStateChange);
    this.avPlayer?.on('videoSizeChange', this.videoSizeChange);
    this.avPlayer?.on('timeUpdate', this.onTimeUpdateFunction);
  }

  private removeAVPlayerCallback() {
    this.avPlayer?.off('stateChange', this.onStateChange);
    this.avPlayer?.off('videoSizeChange', this.videoSizeChange);
    this.avPlayer?.off('timeUpdate', this.onTimeUpdateFunction);
  }

  private onStateChange: (state: media.AVPlayerState) => void = async (state: media.AVPlayerState) => {
    if (this.avPlayer === undefined) {
      return;
    }
    this.currentState = state;
    if (this.currentIndex === this.index) {
      this.onStateNotify(state);
    }
    switch (state) {
      case CommonConstants.AV_PLAYER_INITIALIZED_STATE:
        this.hasPrepared = true;
        this.isInitializing = false;
        this.avPlayer.surfaceId = this.surfaceId;
        this.avPlayer.prepare().catch(() => {
        }).then(() => {
        }, (err: BusinessError) => {
          Logger.error(TAG, `Invoke prepare failed, code is ${err.code}, message is ${err.message}`);
          this.avPlayer?.reset().catch(() => {
            Logger.error(TAG, `Reset avPlayer failed.`);
          });
        });
        break;
      case CommonConstants.AV_PLAYER_PREPARED_STATE:
        this.avPlayer.videoScaleType = media.VideoScaleType.VIDEO_SCALE_TYPE_FIT_CROP;
        this.avPlayer.loop = true;
        this.duration = this.avPlayer.duration;
        if (this.currentIndex === this.index) {
          this.avPlayer?.play().catch(() => {
            Logger.error(TAG, `Play avPlayer failed.`);
          });
        }
        break;
      case CommonConstants.AV_PLAYER_COMPLETED_STATE:
        this.avPlayer.stop().catch(() => {
          Logger.error(TAG, `Stop avPlayer failed.`);
        });
        break;
      case CommonConstants.AV_PLAYER_ERROR_STATE:
        this.isInitializing = false;
        this.avPlayer.reset().catch(() => {
          Logger.error(TAG, `Reset avPlayer failed.`);
        })
        break;
      default:
        break;
    }
  }
  private onTimeUpdateFunction: (updateTime: number) => void = (updateTime: number) => {
    this.currentProgress = updateTime;
  }
  private videoSizeChange: (width: number, height: number) => void = (width: number, height: number) => {
    this.oriSurfaceWidth = width;
    this.oriSurfaceHeight = height;
    if (this.currentIndex === this.index) {
      this.changePortraitVideo();
    }
  }

  private async changePortraitVideo() {
    try {
      const immersionInfo = AdaptiveImmersion
        .getImmersionInfo({ width: this.oriSurfaceWidth as number, height: this.oriSurfaceHeight as number },
          { width: this.windowSizeWidth as number, height: this.windowSizeHeight as number }, 0, this.bottomTabHeight);
      if (immersionInfo) {
        Logger.info(TAG, `changePortraitVideo immersionInfo = ${JSON.stringify(immersionInfo)}`);
        this.surfaceWidth = immersionInfo.videoSize.width;
        this.surfaceHeight = immersionInfo.videoSize.height;
        this.videoPosition =
          immersionInfo.videoPosition;
      }
    } catch (err) {
      Logger.error(TAG, `changePortraitVideo error = ${JSON.stringify(err)}`);
    }
  }

  private controlPlayOrPause() {
    if (this.currentState === CommonConstants.AV_PLAYER_PLAYING_STATE) {
      this.avPlayer?.pause().catch(() => {
        Logger.error(TAG, `Pause AVPlayer failed.`);
      });
    } else if (this.currentState === CommonConstants.AV_PLAYER_PAUSED_STATE) {
      if (this.canPlay()) {
        this.avPlayer?.play().catch(() => {
          Logger.error(TAG, `Play AVPlayer failed.`);
        });
      }
    }
  }
}
