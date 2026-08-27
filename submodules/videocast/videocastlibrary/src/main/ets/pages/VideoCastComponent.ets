/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { common } from '@kit.AbilityKit';
import { promptAction, window } from '@kit.ArkUI';
import { avSession } from '@kit.AVSessionKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { CommonConstants, VideoPlayParam } from '../common/constants/CommonConstants';
import { BreakpointType } from '../common/utils/BreakpointSystem';
import Logger from '../common/utils/Logger';
import { AVCastController } from '../controller/AVCastController';
import { VideoPlayerController } from '../controller/VideoPlayerController';
import { VideoSessionController } from '../controller/VideoSessionController';
import { VideoPlay } from './VideoPlayPage';

const TAG = '[VideoCastComponent]';

@Component
export struct VideoCastComponent {
  @StorageLink(CommonConstants.KEY_PREFIX + 'Breakpoint') currentWidthBreakpoint: string = 'sm';
  @StorageLink('castAvSessionController') avSessionController ?: VideoSessionController = undefined;
  @StorageLink('castingList') castingList: string[] = [];
  @StorageLink('castAvPlayerController') avPlayerController?: VideoPlayerController = undefined;
  @StorageLink(CommonConstants.KEY_PREFIX + 'AvCastController') @Watch('avCastControllerChange')
  avCastPlayerController?: AVCastController = undefined;
  @Provide remoteControlPathStack: NavPathStack = new NavPathStack();
  @State ifShowBack: boolean = false;
  @State avCastControllerState?: avSession.PlaybackState = avSession.PlaybackState.PLAYBACK_STATE_INITIAL;
  @State videoPlayPathStack: NavPathStack = new NavPathStack();

  aboutToAppear(): void {
    this.avSessionController = undefined;
    this.avPlayerController = undefined;
    this.avCastPlayerController = undefined;
    this.castingList = [];

    window.getLastWindow(this.getUIContext().getHostContext()).then((windowClass: window.Window) => {
      try {
        windowClass.setWindowSystemBarProperties({ statusBarContentColor: '#ffffff' }).then(() => {
          Logger.info(TAG, 'testTag', 'Succeeded in setting the system bar properties.');
        }).catch((err: BusinessError) => {
          Logger.error(TAG,
            `Failed to set the system bar properties. Cause: error code: ${err.code}, message: ${err.message}`);
        });
      } catch (err) {
        Logger.error(TAG,
          `Failed to set the system bar properties. Cause: error code: ${err.code}, message: ${err.message}`);
      }
    }).catch((err: BusinessError) => {
      Logger.error(TAG, `GetLastWindow failed. Cause: error code: ${err.code}, message: ${err.message}`);
    });
  }

  aboutToDisappear(): void {
    this.avSessionController?.destroyAvSessionListener(this.getUIContext().getHostContext() as common.UIAbilityContext);
    this.avPlayerController?.releasePlayer();
    this.avCastPlayerController?.releaseAVCast();
  }

  avCastControllerChange() {
    this.avCastControllerState = this.avCastPlayerController?.state;
  }

  @Builder
  PageMap(name: string, param: VideoPlayParam) {
    VideoPlay({ videoType: param.videoType, videoIndex: param.videoIndex })
  }

  @Builder
  VideoCard(image: Resource, title: string, describe: string) {
    Column() {
      Image(image)
        .width('100%')
        .aspectRatio(16 / 9)
        .borderRadius(10)
      Column() {
        Text($r(title))
          .fontSize(14)
          .fontColor('#E5FFFFFF')
          .width('100%')
          .height(21)
          .margin({
            bottom: 2
          })
        Text($r(describe))
          .fontSize(12)
          .fontColor('#99FFFFFF')
          .width('100%')
          .textOverflow({ overflow: TextOverflow.Clip })
          .lineHeight(18)
      }
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .width('100%')
      .margin({
        top: 9
      })
    }
  }

  pushPathHandle(videoType: string) {
    const castingList: string[] = AppStorage.get('castingList') || [];
    let videoPlayParam = new VideoPlayParam(videoType);
    if (!this.avCastPlayerController || castingList.includes(videoPlayParam.videoType)) {
      this.videoPlayPathStack.pushPath({ name: 'detail', param: videoPlayParam });
    } else {
      try {
        this.getUIContext().getPromptAction().showToast({
          message: $r('app.string.cast_play_hit'),
          duration: 2000,
          showMode: promptAction.ToastShowMode.DEFAULT,
        })
      } catch (error) {
        const err = error as BusinessError;
        Logger.error(TAG, `showToast failed, error: ${err.code}, message: ${err.message}`);
      }
    }
  }

  build() {
    Navigation(this.videoPlayPathStack) {
      RelativeContainer() {
        Column() {
          Row() {
            Text($r('app.string.title'))
              .fontSize(30)
              .fontWeight(FontWeight.Bold)
              .fontColor('#E5FFFFFF')
          }
          .height(112)
          .width('100%')
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
            }).getValue(this.currentWidthBreakpoint),
            bottom: 8
          })
          .alignItems(VerticalAlign.Bottom)

          Column() {
            Text($r('app.string.subtitle'))
              .height(48)
              .fontSize(16)
              .fontWeight(500)
              .fontColor('#E5FFFFFF')
            GridRow({
              columns: {
                sm: 2,
                md: 4,
                lg: 4
              },
              gutter: { x: { sm: 8, md: 12, lg: 16 } }
            }) {
              GridCol({ span: 1 }) {
                this.VideoCard($r('app.media.video_cover_0'), 'app.string.online_video',
                  'app.string.online_video_describe')
              }
              .width('100%')
              .onClick(() => {
                this.pushPathHandle('network');
              })

              GridCol({ span: 1 }) {
                this.VideoCard($r('app.media.video_cover_1'), 'app.string.local_video',
                  'app.string.local_video_describe')
              }
              .width('100%')
              .onClick(() => {
                this.pushPathHandle('localWork');
              })
            }
            .width('100%')
          }
          .alignItems(HorizontalAlign.Start)
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
          .width('100%')
          .layoutWeight(1)
          .backgroundColor(Color.Black)
        }
        .onClick(() => {
          this.ifShowBack = false;
        })

        Row() {
          SymbolGlyph($r('sys.symbol.wireless_projection'))
            .fontSize(28)
            .fontColor([Color.White])
        }
        .width(56)
        .height(56)
        .backgroundColor('#0A59F7')
        .borderRadius(28)
        .justifyContent(FlexAlign.Center)
        .alignRules({
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
          right: { anchor: '__container__', align: HorizontalAlign.End },
        })
        .offset({
          x: -26,
          y: -202
        })
        .onClick(() => {
          this.ifShowBack = true;
        })
        .visibility(!this.ifShowBack && this.castingList.length !== 0 ? Visibility.Visible : Visibility.None)

        Column() {
          Row() {
            SymbolGlyph($r('sys.symbol.arrowshape_turn_up_left'))
              .fontSize(28)
              .fontColor(['#E5FFFFFF'])
          }
          .width(48)
          .height(48)
          .backgroundColor('rgba(255,255,255,0.1)')
          .borderRadius('50%')
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            if (this.castingList && this.castingList.length > 0) {
              let videoPlayParam = new VideoPlayParam(this.castingList[0], 0, this.avCastPlayerController?.castIndex);
              this.videoPlayPathStack.replacePath({ name: 'detail', param: videoPlayParam });
              this.remoteControlPathStack.replacePath({ name: 'detail', param: -1 });
            }
          })

          Row() {
            SymbolGlyph($r('sys.symbol.wireless_projection'))
              .fontSize(28)
              .fontColor([Color.White])
          }
          .onClick(() => {
            this.ifShowBack = false;
          })
          .width(56)
          .height(56)
          .backgroundColor('#317AF7')
          .borderRadius('50%')
          .justifyContent(FlexAlign.Center)

          Row() {
            SymbolGlyph(this.avCastControllerState === avSession.PlaybackState.PLAYBACK_STATE_PLAY ?
              $r('sys.symbol.pause_circle') : $r('sys.symbol.play_circle'))
              .fontSize(28)
              .fontColor(['#E5FFFFFF'])
          }
          .onClick(() => {
            if (this.avCastControllerState === avSession.PlaybackState.PLAYBACK_STATE_PLAY &&
              this.avCastPlayerController) {
              this.avCastPlayerController.setAVCastPause();
            } else if (this.avCastControllerState === avSession.PlaybackState.PLAYBACK_STATE_PAUSE &&
              this.avCastPlayerController) {
              this.avCastPlayerController.setAVCastPlay();
            }
          })
          .width(48)
          .height(48)
          .backgroundColor('rgba(255,255,255,0.1)')
          .borderRadius('50%')
          .justifyContent(FlexAlign.Center)
        }
        .backgroundColor('#202224')
        .borderRadius(30)
        .width(60)
        .height(188)
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({
          top: 8,
          bottom: 8
        })
        .alignRules({
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
          right: { anchor: '__container__', align: HorizontalAlign.End },
        })
        .offset({
          x: -24,
          y: -136
        })
        .visibility(this.ifShowBack && this.castingList.length !== 0 ? Visibility.Visible : Visibility.None)
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .mode(NavigationMode.Stack)
    .navDestination(this.PageMap)
    .hideToolBar(true)
    .backgroundColor(Color.Black)
  }
}