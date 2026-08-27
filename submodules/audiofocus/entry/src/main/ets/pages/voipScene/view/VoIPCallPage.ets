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

import { voipCall } from '@kit.CallServiceKit';
import { window } from '@kit.ArkUI';
import Logger from '../../../common/util/Logger';
import { CommonConstants } from '../../../common/constants/CommonConstants';

const TAG = 'VoIPCallPage';

@Builder
export function VoipCallPagePageBuilder() {
  VoipCallPage()
}

@Entry
@Component
struct VoipCallPage {
  @State username: string = 'Jack';
  @StorageLink(CommonConstants.KEY_VOIP_CALL_STATE) voipCallState: voipCall.VoipCallState =
    AppStorage.get(CommonConstants.KEY_VOIP_CALL_STATE) as voipCall.VoipCallState;
  @StorageLink(CommonConstants.KEY_VOIP_CALL_MUTE_STATE) voipCallMuteState: boolean = false;
  windowStage: window.WindowStage = AppStorage.get(CommonConstants.KEY_WINDOW_STAGE) as window.WindowStage;
  // How to get the main window
  mainWin: window.Window = this.windowStage.getMainWindowSync();
  @StorageLink(CommonConstants.KEY_IS_W) isW: boolean = false;

  aboutToAppear(): void {
    const callId = AppStorage.get(CommonConstants.KEY_VOIP_CALL_ID) as string;
    if (callId.startsWith('short_video_call_')) {
      this.username = 'Short Videos';
    }
  }

  onBackPress() {
    try {
      voipCall.reportCallStateChange(AppStorage.get(CommonConstants.KEY_VOIP_CALL_ID),
        voipCall.VoipCallState.VOIP_CALL_STATE_DISCONNECTED);
    } catch (error) {
      Logger.error(TAG, `reportCallStateChange failed,code is ${error.code},message is ${error.message}}`);
    }
    AppStorage.setOrCreate(CommonConstants.KEY_VOIP_CALL_STATE,
      voipCall.VoipCallState.VOIP_CALL_STATE_DISCONNECTED);
  }

  build() {
    Column() {
      Column() {
        Text(this.username)
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 10 })
          .align(Alignment.Top)
          .fontColor(Color.White)
          .margin({ top: 28 })
        Text(this.getCallStateLabel(this.voipCallState))
          .fontSize(18)
          .margin({ top: 5 })
          .fontColor(Color.White)
      }

      Column() {
        Row() {
          if (this.voipCallState === voipCall.VoipCallState.VOIP_CALL_STATE_RINGING) {
            Column() {
              Image($r('app.media.message_on_message_fill'))
                .width(32)
                .height(32)
              Text($r('app.string.text_message'))
                .fontSize(14)
                .margin({ top: 5, bottom: 32 })
                .fontColor(Color.White)

              Image($r('app.media.ic_public_hangup'))
                .width(56)
                .height(56)
                .onClick(async () => {
                  Logger.info('reject call clicked');
                  try {
                    await voipCall.reportCallStateChange(AppStorage.get(CommonConstants.KEY_VOIP_CALL_ID),
                      voipCall.VoipCallState.VOIP_CALL_STATE_DISCONNECTED);
                  } catch (error) {
                    Logger.error(TAG,
                      `reportCallStateChange failed,code is ${error.code},message is ${error.message}}`);
                  }
                  AppStorage.setOrCreate(CommonConstants.KEY_VOIP_CALL_STATE,
                    voipCall.VoipCallState.VOIP_CALL_STATE_DISCONNECTED);
                })
            }

            Column() {
              Image($r('app.media.alarm_fill_1'))
                .width(32)
                .height(32)
              Text($r('app.string.remind'))
                .fontSize(14)
                .margin({ top: 5, bottom: 32 })
                .fontColor(Color.White)
              Image($r('app.media.ic_public_answer'))
                .width(56)
                .height(56)
                .onClick(async () => {
                  Logger.info('answer call clicked');
                  try {
                    await voipCall.reportCallStateChange(AppStorage.get(CommonConstants.KEY_VOIP_CALL_ID),
                      voipCall.VoipCallState.VOIP_CALL_STATE_ACTIVE);
                  } catch (error) {
                    Logger.error(TAG,
                      `reportCallStateChange failed,code is ${error.code},message is ${error.message}}`);
                  }
                  AppStorage.setOrCreate(CommonConstants.KEY_VOIP_CALL_STATE,
                    voipCall.VoipCallState.VOIP_CALL_STATE_ACTIVE);
                })
            }
            .margin({ left: 100 })
          } else if (this.voipCallState === voipCall.VoipCallState.VOIP_CALL_STATE_ACTIVE) {
            Image($r(this.voipCallMuteState ? 'app.media.ic_public_mute_on' : 'app.media.ic_public_mute'))
              .width(56)
              .height(56)
              .onClick(async () => {
                Logger.info('mute button clicked');
                this.voipCallMuteState = !this.voipCallMuteState;
                try {
                  await voipCall.reportCallAudioEventChange(AppStorage.get(CommonConstants.KEY_VOIP_CALL_ID),
                    this.voipCallMuteState ? voipCall.CallAudioEvent.AUDIO_EVENT_MUTED :
                      voipCall.CallAudioEvent.AUDIO_EVENT_UNMUTED);
                } catch (error) {
                  Logger.error(TAG,
                    `reportCallAudioEventChange failed,code is ${error.code},message is ${error.message}}`);
                }
              })
            Image($r('app.media.ic_public_hangup'))
              .width(56)
              .height(56)
              .onClick(async () => {
                Logger.info('hangup call clicked');
                try {
                  await voipCall.reportCallStateChange(AppStorage.get(CommonConstants.KEY_VOIP_CALL_ID),
                    voipCall.VoipCallState.VOIP_CALL_STATE_DISCONNECTED);
                } catch (error) {
                  Logger.error(TAG, `reportCallStateChange failed,code is ${error.code},message is ${error.message}}`);
                }
                AppStorage.setOrCreate(CommonConstants.KEY_VOIP_CALL_STATE,
                  voipCall.VoipCallState.VOIP_CALL_STATE_DISCONNECTED);
              })
              .margin({ left: 100 })
          }
        }
        .width(this.isW ? '50%' : '70%')
        .padding({ left: this.isW ? 16 : 0, right: this.isW ? 16 : 0 })
        .justifyContent(FlexAlign.SpaceBetween)
      }
    }
    .padding({ bottom: 36 })
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor('rgba(0,0,0,0.8)')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .width('100%')
    .height('100%')
  }

  getCallStateLabel(voipCallState: voipCall.VoipCallState): ResourceStr {
    if (voipCallState === voipCall.VoipCallState.VOIP_CALL_STATE_RINGING) {
      return $r('app.string.call');
    } else if (voipCallState === voipCall.VoipCallState.VOIP_CALL_STATE_ACTIVE) {
      return $r('app.string.on_the_phone');
    } else if (voipCallState === voipCall.VoipCallState.VOIP_CALL_STATE_DIALING) {
      return $r('app.string.dialing');
    } else if (voipCallState === voipCall.VoipCallState.VOIP_CALL_STATE_DISCONNECTED) {
      return $r('app.string.the_call_is_over');
    }
    return '';
  }
}