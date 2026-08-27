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
import { audio } from '@kit.AudioKit';
import { common } from '@kit.AbilityKit';
import { display } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { AudioRenderController } from '../../../common/util/AudioRenderController';
import { AudioCapturerController } from '../../../common/util/AudioCapturerController';
import { AVSessionController } from '../../../common/util/AVSessionController';
import Logger from '../../../common/util/Logger';
import { PermissionUtil } from '../../../common/util/PermissionUtil';
import { CommonConstants } from '../../../common/constants/CommonConstants';

const TAG = 'VoIPScene';

@Builder
export function VoIPScenePageBuilder() {
  VoIPScenePage();
}

@Component
export struct VoIPScenePage {
  @StorageLink(CommonConstants.KEY_VOIP_CALL_STATE) @Watch('callStateChange') voipCallState: voipCall.VoipCallState =
    voipCall.VoipCallState.VOIP_CALL_STATE_IDLE;
  private callId: string = '12345678910';
  private captureFileName: string = 'captureTest.pcm'
  private renderFileName: string = 'voip_audio.pcm';
  private audioRenderController: AudioRenderController = new AudioRenderController();
  private audioCapturerController: AudioCapturerController = new AudioCapturerController();
  private avSessionController: AVSessionController = new AVSessionController();
  private audioSessionManager: audio.AudioSessionManager = audio.getAudioManager().getSessionManager();
  @State isHalfFolded: boolean = false;
  @StorageLink(CommonConstants.KEY_CURRENT_BREAK_POINT) curBp: string = '';
  @State isPadding: boolean = false;
  onFoldStatusChange: (foldStatus: display.FoldStatus) => void = (foldStatus: display.FoldStatus) => {
    if (foldStatus === display.FoldStatus.FOLD_STATUS_FOLDED && this.curBp === 'sm') {
      this.isHalfFolded = true;
    } else if (foldStatus === display.FoldStatus.FOLD_STATUS_EXPANDED) {
      this.isHalfFolded = false;
    }
  }

  aboutToAppear() {
    this.registerVoIPCallUiEvent();
    this.initAVResource();
    PermissionUtil.checkPermissions(['ohos.permission.MICROPHONE']);
    try {
      if (display.isFoldable()) {
        try {
          display.on('foldStatusChange', this.onFoldStatusChange);
          let foldStatus = display.getFoldStatus();
          if (foldStatus === display.FoldStatus.FOLD_STATUS_FOLDED && this.curBp === 'sm') {
            this.isHalfFolded = true;
          }
        } catch (error) {
          let err = error as BusinessError;
          Logger.error('foldStatusChange Failed',
            `Code: ${err.code}, message: ${err.message}`);
        }
      }
    } catch (error) {
      let err = error as BusinessError;
      Logger.error('Get isFoldable Failed',
        `Code: ${err.code}, message: ${err.message}`);
    }
    if (this.curBp === 'xl' || this.curBp === 'lg') {
      this.isPadding = true;
    }
  }

  aboutToDisappear() {
    this.releaseAVResource();
    try {
      voipCall.off('voipCallUiEvent');
    } catch (error) {
      Logger.error(TAG, `off voipCallUiEvent fail. error message is ${error.message}`);
    }
    try {
      voipCall.reportCallStateChange(AppStorage.get(CommonConstants.KEY_VOIP_CALL_ID),
        voipCall.VoipCallState.VOIP_CALL_STATE_DISCONNECTED);
    } catch (error) {
      Logger.error(TAG, `reportCallStateChange failed,code is ${error.code},message is ${error.message}}`);
    }
    AppStorage.setOrCreate(CommonConstants.KEY_VOIP_CALL_STATE,
      voipCall.VoipCallState.VOIP_CALL_STATE_DISCONNECTED);
  }

  // [Start voip_stream_usage]
  async initAVResource() {
    // Create an instance of AudioRenderer and set the audio stream type to STREAM_USAGE_VOICE_COMMUNICATION
    this.audioRenderController.createAndInitAudioRender(this.avSessionController, this.renderFileName,
      audio.StreamUsage.STREAM_USAGE_VOICE_COMMUNICATION);
    // Create an AudioRCapturer instance and set the audio stream type to SOURCE_TYPE_VOICE_COMMUNICATION
    this.audioCapturerController.createAndInitAudioCapturer(this.avSessionController, this.captureFileName,
      audio.SourceType.SOURCE_TYPE_VOICE_COMMUNICATION);
    Logger.info('initAVResource SUCCESS');
  }

  // [End voip_stream_usage]

  async releaseAVResource() {
    if (this.audioRenderController) {
      await this.audioRenderController.releaseAudioRender(this.renderFileName);
    }
    if (this.audioCapturerController) {
      await this.audioCapturerController.releaseAudioCapturer();
    }
    // Deactivate an audio session
    try {
      this.audioSessionManager.deactivateAudioSession().then(() => {
        Logger.info('deactivateAudioSession SUCCESS');
      });
    } catch (error) {
      Logger.error(TAG, `deactivateAudioSession fail. error message is ${error.message}`);
    }

    Logger.info('releaseAVResource SUCCESS');
  }

  registerVoIPCallUiEvent() {
    try {
      voipCall.on('voipCallUiEvent', async (voipCallUiEventInfo) => {
        Logger.info('voipCallUiEvent: ' + voipCallUiEventInfo);
        if (voipCallUiEventInfo.voipCallUiEvent === voipCall.VoipCallUiEvent.VOIP_CALL_EVENT_VOICE_ANSWER) {
          await voipCall.reportCallStateChange(
            voipCallUiEventInfo.callId, voipCall.VoipCallState.VOIP_CALL_STATE_ANSWERED);
          setTimeout(async () => {
            await voipCall.reportCallStateChange(voipCallUiEventInfo.callId,
              voipCall.VoipCallState.VOIP_CALL_STATE_ACTIVE, voipCall.VoipCallType.VOIP_CALL_VOICE);
            AppStorage.setOrCreate(CommonConstants.KEY_VOIP_CALL_STATE, voipCall.VoipCallState.VOIP_CALL_STATE_ACTIVE);
          }, 2000);
        } else if ((voipCallUiEventInfo.voipCallUiEvent === voipCall.VoipCallUiEvent.VOIP_CALL_EVENT_REJECT) ||
          (voipCallUiEventInfo.voipCallUiEvent === voipCall.VoipCallUiEvent.VOIP_CALL_EVENT_HANGUP)) {
          await voipCall.reportCallStateChange(
            voipCallUiEventInfo.callId, voipCall.VoipCallState.VOIP_CALL_STATE_DISCONNECTED);
          AppStorage.setOrCreate(CommonConstants.KEY_VOIP_CALL_STATE,
            voipCall.VoipCallState.VOIP_CALL_STATE_DISCONNECTED);
        } else if (voipCallUiEventInfo.voipCallUiEvent === voipCall.VoipCallUiEvent.VOIP_CALL_EVENT_MUTED) {
          await voipCall.reportCallAudioEventChange(
            voipCallUiEventInfo.callId, voipCall.CallAudioEvent.AUDIO_EVENT_MUTED);
          AppStorage.setOrCreate(CommonConstants.KEY_VOIP_CALL_MUTE_STATE, true);
        } else if (voipCallUiEventInfo.voipCallUiEvent === voipCall.VoipCallUiEvent.VOIP_CALL_EVENT_UNMUTED) {
          await voipCall.reportCallAudioEventChange(
            voipCallUiEventInfo.callId, voipCall.CallAudioEvent.AUDIO_EVENT_UNMUTED);
          AppStorage.setOrCreate(CommonConstants.KEY_VOIP_CALL_MUTE_STATE, false);
        } else if (voipCallUiEventInfo.voipCallUiEvent === voipCall.VoipCallUiEvent.VOIP_CALL_EVENT_SPEAKER_ON) {
          await voipCall.reportCallAudioEventChange(
            voipCallUiEventInfo.callId, voipCall.CallAudioEvent.AUDIO_EVENT_SPEAKER_ON);
        } else if (voipCallUiEventInfo.voipCallUiEvent === voipCall.VoipCallUiEvent.VOIP_CALL_EVENT_SPEAKER_OFF) {
          await voipCall.reportCallAudioEventChange(
            voipCallUiEventInfo.callId, voipCall.CallAudioEvent.AUDIO_EVENT_SPEAKER_OFF);
        }
      });
    } catch (error) {
      Logger.error(TAG, `voipCallUiEvent failed,code is ${error.code},message is ${error.message}}`);
    }
  }

  callStateChange() {
    if (this.voipCallState === voipCall.VoipCallState.VOIP_CALL_STATE_ACTIVE) {
      // Set the audio concurrency mode
      let strategy: audio.AudioSessionStrategy = {
        concurrencyMode: AppStorage.get(CommonConstants.KEY_AUDIO_CONCURRENCY_MODE) as audio.AudioConcurrencyMode
      };
      // Activate the audio session
      this.audioSessionManager.activateAudioSession(strategy).then(() => {
        Logger.info('activateAudioSession succeed');
      })
        .catch(() => {
          Logger.error(TAG, 'activateAudioSession failed');
        });

      this.audioRenderController.mediaPlay();
      this.audioCapturerController.mediaPlay();
    } else if (this.voipCallState === voipCall.VoipCallState.VOIP_CALL_STATE_DISCONNECTED) {
      this.audioRenderController.mediaStop();
      this.audioCapturerController.mediaStop();
      // Deactivate an audio session
      this.audioSessionManager.deactivateAudioSession()
        .then(() => {
          Logger.info('deactivateAudioSession succeed');
        })
        .catch(() => {
          Logger.error(TAG, 'deactivateAudioSession failed');
        });

      setTimeout(() => {
        AppStorage.get<common.UIAbilityContext>(CommonConstants.KEY_VOIP_CALL_ABILITY_CONTEXT)?.terminateSelf()
          .then(() => {
            Logger.info(TAG, 'AppStorage get VoIPCallAbilityContext succeed');
          })
          .catch(() => {
            Logger.error(TAG, 'AppStorage get VoIPCallAbilityContext failed');
          });
      }, 1000);
    }
  }

  build() {
    NavDestination() {
      Column() {
        Button($r('app.string.activate_the_incoming_call_scene'))
          .onClick(async () => {
            let voipCallAttribute: voipCall.VoipCallAttribute = {
              callId: this.callId,
              voipCallType: voipCall.VoipCallType.VOIP_CALL_VOICE,
              userName: 'Jack',
              userProfile: image.createPixelMapSync(new ArrayBuffer(100), { size: { width: 90, height: 90 } }),
              abilityName: 'VoIPCallAbility',
              voipCallState: voipCall.VoipCallState.VOIP_CALL_STATE_RINGING
            };
            try {
              await voipCall.reportIncomingCall(voipCallAttribute);
            } catch (error) {
              Logger.error(TAG, `reportIncomingCall failed,code is ${error.code},message is ${error.message}}`);
            }
            AppStorage.setOrCreate(CommonConstants.KEY_VOIP_CALL_ID, this.callId);
            AppStorage.setOrCreate(CommonConstants.KEY_VOIP_CALL_STATE, voipCall.VoipCallState.VOIP_CALL_STATE_RINGING);
          })
          .type(ButtonType.ROUNDED_RECTANGLE)
          .fontColor($r('sys.color.font_emphasize'))
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .fontWeight(FontWeight.Medium)
          .constraintSize({ maxWidth: 448 })
          .width('100%')
      }
      .padding({ left: 16, right: 16, bottom: this.isHalfFolded ? 16 : this.isPadding ? 16 : 0 })
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.End)
    }
    .backgroundColor($r('sys.color.background_secondary'))
    .title($r('app.string.voip_chart_button'))
  }
}