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

import { ConfigurationConstant, common } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { audio } from '@kit.AudioKit';
import { voipCall } from '@kit.CallServiceKit';
import { avSession } from '@kit.AVSessionKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';
import { AVSessionController } from '../../../common/util/AVSessionController';
import Logger from '../../../common/util/Logger';
import { WindowUtil } from '../../../common/util/WindowUtil';
import { AVDataSource } from '../viewModel/AVDataSource';
import { SOURCES } from '../viewModel/DataModel';
import { VideoData } from '../model/VideoData';
import { VideoPlayer } from './VideoPlayer';
import { AvPlayerController } from '../../../common/util/AVPlayerController';
import { CommonConstants } from '../../../common/constants/CommonConstants';
import { PermissionUtil } from '../../../common/util/PermissionUtil';
import { AudioRenderController } from '../../../common/util/AudioRenderController';
import { AudioCapturerController } from '../../../common/util/AudioCapturerController';

@Builder
export function ShortVideoScenePageBuilder() {
  ShortVideoScenePage()
}

const TAG = '[ShortVideoScene]';
AppStorage.setOrCreate(CommonConstants.KEY_IS_FULL_LAND_SCAPE_SCREEN, false);
AppStorage.setOrCreate(CommonConstants.KEY_VOIP_CALL_STATE, voipCall.VoipCallState.VOIP_CALL_STATE_IDLE);

@Component
export struct ShortVideoScenePage {
  @State buttonX: number = 320;
  @State buttonY: number = 8;
  @State startX: number = 0;
  @State startY: number = 0;
  @State initialButtonX: number = 0;
  @State initialButtonY: number = 0;
  @State isPulsing: boolean = false;
  @State isPicking: boolean = false;
  @State curIndex: number = 0;
  private swiperController: SwiperController = new SwiperController();
  private windowUtil: WindowUtil = WindowUtil.getInstance();
  private audioRoutingManager: audio.AudioRoutingManager = audio.getAudioManager().getRoutingManager();
  private audioSessionManager: audio.AudioSessionManager = audio.getAudioManager().getSessionManager();
  private audioRenderController: AudioRenderController = new AudioRenderController();
  private audioCapturerController: AudioCapturerController = new AudioCapturerController();
  private callId: string = 'short_video_call_' + Date.now();
  private renderFileName: string = 'voip_audio_render.pcm';
  private captureFileName: string = 'voip_audio_capture.pcm';
  @StorageLink(CommonConstants.KEY_IS_FULL_LAND_SCAPE_SCREEN) isFullLandscapeScreen: boolean = false;
  @StorageLink(CommonConstants.KEY_VOIP_CALL_STATE) @Watch('handleCallStateChange') voipCallState:
    voipCall.VoipCallState = voipCall.VoipCallState.VOIP_CALL_STATE_IDLE;
  @StorageLink(CommonConstants.KEY_IS_VOIP_FULL_SCREEN) @Watch('handleCallStateChange') isVoIPFullScreen: boolean =
    false;
  @State avSessionController: AVSessionController = new AVSessionController();
  @State source: AVDataSource = new AVDataSource(SOURCES)
  @State avPlayerController: AvPlayerController = new AvPlayerController();
  windowStage: window.WindowStage = AppStorage.get(CommonConstants.KEY_WINDOW_STAGE) as window.WindowStage;
  // How to get the main window
  mainWin: window.Window | undefined = undefined;
  uiContext: UIContext | undefined = undefined;

  async aboutToAppear() {
    PermissionUtil.checkPermissions(['ohos.permission.MICROPHONE']);
    try {
      this.mainWin = this.windowStage.getMainWindowSync();
    } catch (err) {
      Logger.error(TAG, `getMainWindowSync failed, code is ${err.code}, message is ${err.message}`);
    }
    this.uiContext = this.getUIContext();
    Logger.info(TAG, `source is ${JSON.stringify(this.source.dataArray)}`)
    this.windowUtil.registerOnWindowSizeChange((size) => {
      if (size.width > size.height) {
        this.isFullLandscapeScreen = true;
      } else {
        this.isFullLandscapeScreen = false;
      }
    });
    let sysBarProps: window.SystemBarProperties = {
      statusBarColor: '#000000',
      statusBarContentColor: '#FFFFFF'
    };
    if (this.mainWin) {
      this.mainWin.setWindowSystemBarProperties(sysBarProps).then(() => {
        Logger.info(TAG, '[StaticUtils] Succeeded in setting the system bar properties.');
      }).catch((err: BusinessError) => {
        Logger.error(TAG, `setting system bar properties failed, code is ${err.code}, message is ${err.message}`);
      });
    }
    let videoMetadata: avSession.AVMetadata = { assetId: '0', title: 'shortVideoScene', artist: 'none' }
    await this.avSessionController.registerSessionListener(this.avPlayerController);
    await this.avSessionController.createAndActiveSession(videoMetadata, 'EntryAbility', 'video');
    this.registerVoIPCallUiEvent();
    this.initAVResource();
    AppStorage.setOrCreate(CommonConstants.KEY_VOIP_CALL_STATE, voipCall.VoipCallState.VOIP_CALL_STATE_IDLE);
  }

  aboutToDisappear(): void {
    if (this.avSessionController) {
      this.avSessionController.avSessionRelease();
    }
    if (this.avPlayerController) {
      this.avPlayerController.videoRelease()
      this.avPlayerController.deactivateAudioSession();
    }
    let context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
    let colorMode: ConfigurationConstant.ColorMode | undefined = context.config.colorMode;
    if (colorMode && this.mainWin) {
      let sysBarProps: window.SystemBarProperties = {
        statusBarColor: '#F1F3F5',
        statusBarContentColor: '#000000'
      };
      this.mainWin.setWindowSystemBarProperties(sysBarProps).then(() => {
        Logger.info(TAG, '[StaticUtils] Succeeded in setting the system bar properties.');
      }).catch((err: BusinessError) => {
        Logger.error(TAG, `setting system bar properties failed, code is ${err.code}, message is ${err.message}`);
      });
    }
    // Release VoIP audio resources.
    this.releaseAVResource();
    try {
      voipCall.off('voipCallUiEvent'); // Cancel VoIP event monitoring.
    } catch (error) {
      Logger.error(TAG, `off voipCallUiEvent fail. error message is ${error.message}`);
    }
  }

  // Subscribe to voipCallUiEvent event.
  registerVoIPCallUiEvent() {
    try {
      voipCall.on('voipCallUiEvent', async (voipCallUiEventInfo) => {
        Logger.info(TAG, 'voipCallUiEvent: ' + JSON.stringify(voipCallUiEventInfo));
        if (voipCallUiEventInfo.voipCallUiEvent === voipCall.VoipCallUiEvent.VOIP_CALL_EVENT_VOICE_ANSWER) {
          await voipCall.reportCallStateChange(
            voipCallUiEventInfo.callId, voipCall.VoipCallState.VOIP_CALL_STATE_ANSWERED);
          setTimeout(async () => {
            await voipCall.reportCallStateChange(voipCallUiEventInfo.callId,
              voipCall.VoipCallState.VOIP_CALL_STATE_ACTIVE, voipCall.VoipCallType.VOIP_CALL_VOICE);
            this.voipCallState = voipCall.VoipCallState.VOIP_CALL_STATE_ACTIVE;
            AppStorage.setOrCreate(CommonConstants.KEY_VOIP_CALL_STATE,
              voipCall.VoipCallState.VOIP_CALL_STATE_ACTIVE);
          }, 2000);
        } else if ((voipCallUiEventInfo.voipCallUiEvent === voipCall.VoipCallUiEvent.VOIP_CALL_EVENT_REJECT) ||
          (voipCallUiEventInfo.voipCallUiEvent === voipCall.VoipCallUiEvent.VOIP_CALL_EVENT_HANGUP)) {
          await voipCall.reportCallStateChange(
            voipCallUiEventInfo.callId, voipCall.VoipCallState.VOIP_CALL_STATE_DISCONNECTED);
          this.voipCallState = voipCall.VoipCallState.VOIP_CALL_STATE_DISCONNECTED;
          AppStorage.setOrCreate(CommonConstants.KEY_VOIP_CALL_STATE,
            voipCall.VoipCallState.VOIP_CALL_STATE_DISCONNECTED);

          // Reset to IDLE state after 2 seconds to restore the button to its default transparent color.
          setTimeout(() => {
            this.voipCallState = voipCall.VoipCallState.VOIP_CALL_STATE_IDLE;
            AppStorage.setOrCreate(CommonConstants.KEY_VOIP_CALL_STATE,
              voipCall.VoipCallState.VOIP_CALL_STATE_IDLE);
            Logger.info(TAG, 'VoIP call state reset to IDLE after hangup from notification');
          }, 2000);
        }
      });
    } catch (error) {
      Logger.error(TAG, `voipCallUiEvent failed, code is ${error.code}, message is ${error.message}`);
    }
  }

  // Initialize audio resources.
  async initAVResource() {
    /**
     * Short video scene: Set the communication device to speaker before creating the audio renderer,
     * so that the Stream-USAGE_VOICE_COMMUNICATION stream type will also use speaker output.
     */
    await this.setCommunicationDeviceToSpeaker();
    // Create an audio renderer to play the other party's voice.
    this.audioRenderController.createAndInitAudioRender(this.avSessionController, this.renderFileName,
      audio.StreamUsage.STREAM_USAGE_VOICE_COMMUNICATION);
    // Create an audio collector for recording local speech.
    this.audioCapturerController.createAndInitAudioCapturer(this.avSessionController, this.captureFileName,
      audio.SourceType.SOURCE_TYPE_VOICE_COMMUNICATION);
    Logger.info(TAG, 'VoIP AVResource init SUCCESS (speaker mode)');
  }

  // Release audio resources.
  async releaseAVResource() {
    // Release audio renderer resources.
    if (this.audioRenderController) {
      await this.audioRenderController.releaseAudioRender(this.renderFileName);
    }
    // Release audio collector resources.
    if (this.audioCapturerController) {
      await this.audioCapturerController.releaseAudioCapturer();
    }
    // Disable audio session.
    this.audioSessionManager.deactivateAudioSession()
      .then(() => {
        Logger.info(TAG, 'VoIP audio session deactivate SUCCESS');
      }).catch((error: BusinessError) => {
      Logger.error(TAG, `VoIP audio session deactivate fail. error message is ${error.message}`);
    })
  }

  // [Start voipCall_state_change]
  // VoIP call status change event.
  async handleCallStateChange() {
    if (this.voipCallState === voipCall.VoipCallState.VOIP_CALL_STATE_ACTIVE) {
      // [StartExclude voipCall_state_change]
      // Call activation, display pulse animation and start audio.
      this.uiContext?.animateTo({
        duration: 1000,
        iterations: -1,
        curve: Curve.EaseInOut
      }, () => {
        this.isPulsing = true;
      });

      // Set speaker output.
      await this.setCommunicationDeviceToSpeaker();

      // Waiting for the device switch to take effect.
      await new Promise<void>(resolve => setTimeout(resolve, 100));
      // [EndExclude voipCall_state_change]
      let concurrencyMode: audio.AudioConcurrencyMode = audio.AudioConcurrencyMode.CONCURRENCY_DEFAULT;

      if (this.isVoIPFullScreen) {
        // Short video pause.
        concurrencyMode = audio.AudioConcurrencyMode.CONCURRENCY_PAUSE_OTHERS;
        this.avPlayerController.mediaPause();
      } else {
        // Reduce the volume of short videos.
        concurrencyMode = audio.AudioConcurrencyMode.CONCURRENCY_DUCK_OTHERS;
      }

      let strategy: audio.AudioSessionStrategy = {
        concurrencyMode: concurrencyMode // Audio concurrent mode.
      };
      try {
        // Activate audio session.
        await this.audioSessionManager.activateAudioSession(strategy);
        Logger.info(TAG, 'VoIP audio session activate SUCCESS');
      } catch (error) {
        Logger.error(TAG, `VoIP audio session activate fail. error message is ${error.message}`);
      }
      // [StartExclude voipCall_state_change]
      // Reset the speaker to ensure it takes effect after AudioSession activation.
      await this.setCommunicationDeviceToSpeaker();

      // Play VoIP audio.
      await this.audioRenderController.mediaPlay();

      // Set the volume to maximum.
      await this.audioRenderController.setVolume(1.0);
      Logger.info(TAG, 'VoIP audio volume set to max (1.0)');

      // Set the speakers again after starting the audio renderer to ensure they take effect.
      await this.setCommunicationDeviceToSpeaker();
      this.audioCapturerController.mediaPlay();
      // [EndExclude voipCall_state_change]
    } else if (this.voipCallState === voipCall.VoipCallState.VOIP_CALL_STATE_DISCONNECTED) {
      // [StartExclude voipCall_state_change]
      // VoIP call disconnected, stop pulse animation, and stop audio.
      this.uiContext?.animateTo({
        duration: 300,
        curve: Curve.EaseOut
      }, () => {
        this.isPulsing = false;
      });

      // Restore default volume.
      await this.audioRenderController.setVolume(0.8);
      Logger.info(TAG, 'VoIP audio volume restored to 0.8');
      // Stop audio rendering and collection.
      this.audioRenderController.mediaStop();
      this.audioCapturerController.mediaStop();

      // Restore default communication device settings.
      this.restoreCommunicationDevice();
      // [EndExclude voipCall_state_change]
      // Stop VoIP call Ability.
      setTimeout(() => {
        this.voipCallState = voipCall.VoipCallState.VOIP_CALL_STATE_IDLE;
        AppStorage.setOrCreate(CommonConstants.KEY_VOIP_CALL_STATE, voipCall.VoipCallState.VOIP_CALL_STATE_IDLE);
        AppStorage.get<common.UIAbilityContext>(CommonConstants.KEY_VOIP_CALL_ABILITY_CONTEXT)?.terminateSelf()
          .catch(() => {
            Logger.error(TAG, 'AppStorage get VoIPCallAbilityContext failed');
          })
      }, 1000);

      // After a VoIP call hangs up, play a short video.
      this.avPlayerController.mediaPlay();
    }
  }

  // [End voipCall_state_change]

  // Set communication device as speaker to avoid switching to earpiece during calls.
  async setCommunicationDeviceToSpeaker() {
    try {
      // SPEAKER：representing speaker devices.
      await this.audioRoutingManager.setCommunicationDevice(audio.CommunicationDeviceType.SPEAKER, true);
      Logger.info(TAG, 'Set communication device to speaker SUCCESS');
    } catch (error) {
      Logger.error(TAG, `Set communication device failed: ${error}`);
    }
  }

  // Restore default communication device settings.
  async restoreCommunicationDevice() {
    try {
      await this.audioRoutingManager.setCommunicationDevice(audio.CommunicationDeviceType.SPEAKER, false);
      Logger.info(TAG, 'Communication device restored to default');
    } catch (error) {
      Logger.error(TAG, `Restore communication device failed: ${error}`);
    }
  }

  // [Start active_voipCall]
  // Activate VoIP incoming message.
  async startVoIPCall() {
    this.callId = 'short_video_call_' + Date.now();

    let voipCallAttribute: voipCall.VoipCallAttribute = {
      callId: this.callId,
      voipCallType: voipCall.VoipCallType.VOIP_CALL_VOICE,
      userName: 'Short Video User',
      userProfile: image.createPixelMapSync(new ArrayBuffer(100), { size: { width: 90, height: 90 } }),
      abilityName: 'VoIPCallAbility',
      voipCallState: voipCall.VoipCallState.VOIP_CALL_STATE_RINGING
    };

    try {
      // Initiate a call request.
      await voipCall.reportIncomingCall(voipCallAttribute);
      this.voipCallState = voipCall.VoipCallState.VOIP_CALL_STATE_RINGING;
      AppStorage.setOrCreate(CommonConstants.KEY_VOIP_CALL_STATE, voipCall.VoipCallState.VOIP_CALL_STATE_RINGING);
      AppStorage.setOrCreate(CommonConstants.KEY_VOIP_CALL_ID, this.callId);
      Logger.info(TAG, 'VoIP call reportIncomingCall SUCCESS');
    } catch (error) {
      Logger.error(TAG, `reportIncomingCall failed, code is ${error.code}, message is ${error.message}`);
    }
  }
  // [End active_voipCall]

  // Hang up VoIP call.
  async hangupVoIPCall() {
    Logger.info(TAG, 'Hanging up VoIP call from ShortVideo');
    try {
      // Report call disconnection status.
      await voipCall.reportCallStateChange(this.callId, voipCall.VoipCallState.VOIP_CALL_STATE_DISCONNECTED);
      this.voipCallState = voipCall.VoipCallState.VOIP_CALL_STATE_DISCONNECTED;
      AppStorage.setOrCreate(CommonConstants.KEY_VOIP_CALL_STATE,
        voipCall.VoipCallState.VOIP_CALL_STATE_DISCONNECTED);
      Logger.info(TAG, 'VoIP call hangup SUCCESS');
      // Reset VoIP to idle state after 2 seconds.
      setTimeout(() => {
        this.voipCallState = voipCall.VoipCallState.VOIP_CALL_STATE_IDLE;
        AppStorage.setOrCreate(CommonConstants.KEY_VOIP_CALL_STATE, voipCall.VoipCallState.VOIP_CALL_STATE_IDLE);
      }, 2000);
    } catch (error) {
      Logger.error(TAG, `Hangup VoIP call failed, code is ${error.code}, message is ${error.message}`);
    }
  }

  getButtonColor(): ResourceColor {
    if (this.voipCallState === voipCall.VoipCallState.VOIP_CALL_STATE_IDLE) {
      return 'rgba(0, 0, 0, 0.5)'; // Idle state.
    } else if (this.voipCallState === voipCall.VoipCallState.VOIP_CALL_STATE_RINGING ||
      this.voipCallState === voipCall.VoipCallState.VOIP_CALL_STATE_ANSWERED ||
      this.voipCallState === voipCall.VoipCallState.VOIP_CALL_STATE_ACTIVE) {
      return '#4CAF50'; // On the call.
    } else if (this.voipCallState === voipCall.VoipCallState.VOIP_CALL_STATE_DISCONNECTED) {
      return '#F44336'; // The call has been hung up.
    }
    return 'rgba(0, 0, 0, 0.5)';
  }

  build() {
    NavDestination() {
      Stack() {
        Column() {
          Stack() {
            // [Start ShortVideoList]
            Swiper(this.swiperController) {
              LazyForEach(this.source, (item: VideoData, index: number) => {
                VideoPlayer({
                  curSource: item,
                  curIndex: this.curIndex,
                  index: index,
                  avSessionController: this.avSessionController,
                  avPlayerController: this.avPlayerController
                })
              })
            }
            // [StartExclude ShortVideoList]
            .vertical(true)
            .loop(true)
            .curve(Curve.Ease)
            .duration(300)
            .indicator(false)
            .onAnimationStart((index: number, targetIndex: number, extraInfo: SwiperAnimationEvent) => {
              Logger.info(TAG, `onAnimationStart index:${index} , targetIndex: ${targetIndex},extraInfo: ${extraInfo}`);
              this.curIndex = targetIndex;
            })
            // [EndExclude ShortVideoList]
            .onScrollStateChanged((state: ScrollState) => {
              AppStorage.setOrCreate(CommonConstants.KEY_IS_SCROLLING, true);
              if (state === ScrollState.Idle) {
                AppStorage.setOrCreate(CommonConstants.KEY_IS_SCROLLING, false);
              }
              Logger.info(TAG, `scroll state is ${state}`)
            })
            // [End ShortVideoList]
          }
        }
        .height('100%')

        Stack() {
          if (this.isPulsing) {
            Circle()
              .width(60)
              .height(60)
              .fill(this.getButtonColor())
              .opacity(0.3)
          }

          Circle()
            .width(55)
            .height(55)
            .fill(this.getButtonColor())

          Image($r('app.media.phone'))
            .width(35)
            .height(35)
            .fillColor($r('app.color.start_window_background'))
        }
        .width(60)
        .height(60)
        .position({ x: this.buttonX, y: this.buttonY })
        .gesture(
          PanGesture()
            .onActionStart((event: GestureEvent) => {
              this.isPicking = true;
              this.startX = event.fingerList[0].localX;
              this.startY = event.fingerList[0].localY;
              this.initialButtonX = this.buttonX;
              this.initialButtonY = this.buttonY;
            })
            .onActionUpdate((event: GestureEvent) => {
              let currentX = event.fingerList[0].localX;
              let currentY = event.fingerList[0].localY;
              this.buttonX = this.initialButtonX + (currentX - this.startX);
              this.buttonY = this.initialButtonY + (currentY - this.startY);
            })
            .onActionEnd(() => {
              this.isPicking = false;
            })
        )
        .onClick(() => {
          if (this.voipCallState === voipCall.VoipCallState.VOIP_CALL_STATE_IDLE ||
            this.voipCallState === voipCall.VoipCallState.VOIP_CALL_STATE_DISCONNECTED) {
            this.startVoIPCall();
          } else {
            this.hangupVoIPCall();
          }
        })
      }
    }
    .title($r('app.string.short_video_scene_button'))
    .hideTitleBar(true)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .backgroundColor(Color.Black)
  }
}