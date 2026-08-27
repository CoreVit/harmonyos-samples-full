/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { PiPWindow } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { AVPlayer } from '../player/AVPlayer';
import Logger from '../utils/Logger';
import { BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { WindowUtil } from '../utils/WindowUtil';
import { CommonConstants } from '../constants/CommonConstants';

const TAG = CommonConstants.NAV_DESTINATION_NAME;

@Extend(Text)
function textType() {
  .fontColor($r('sys.color.font_primary'))
  .fontSize($r('sys.float.Subtitle_M'))
  .fontWeight(FontWeight.Medium)
}

@Extend(Text)
function msgType() {
  .fontColor($r('sys.color.font_secondary'))
  .fontSize($r('sys.float.Body_M'))
  .fontWeight(FontWeight.Regular)
}

@Extend(Row)
function twoTextRow() {
  .height(22)
  .width(CommonConstants.FULL_PERCENT)
  .justifyContent(FlexAlign.SpaceBetween)
}

@Extend(Divider)
function twoTextDivider() {
  .vertical(false)
  .color($r('sys.color.comp_divider'))
  .opacity(0.6)
}

@Extend(Column)
function dataListColumn() {
  .justifyContent(FlexAlign.SpaceBetween)
  .backgroundColor($r('sys.color.comp_background_primary'))
  .width(CommonConstants.FULL_PERCENT)
  .padding({
    right: $r('sys.float.corner_radius_level6'),
    left: $r('sys.float.corner_radius_level6')
  })
}

@Component
export struct VideoPlayComponent {
  @StorageLink(CommonConstants.KEY_PREFIX_BREAKPOINT) curBp: string = BreakpointTypeEnum.SM;
  @State curState: string = '';
  @State curError: ResourceStr = '';
  @State buttonAction: string = '';
  @State isAutoPull: boolean = false;
  @State hintMsgVisibility: boolean = false;
  @State navigationId: string = '';
  private mXComponentController = new XComponentController();
  private surfaceId = '';
  private player?: AVPlayer;
  private pipController: PiPWindow.PiPController | undefined = undefined;
  private scrollerForScroll: Scroller = new Scroller();

  aboutToDisappear(): void {
    this.destroyPipController();
    if (this.player) {
      this.player.stopAvPlayer();
      this.player = undefined;
    }
    WindowUtil.unRegisterBreakPoint();
  }

  changePipControllerStatusStart(): void {
    if (canIUse('SystemCapability.Window.SessionManager')) {
      let controlType: PiPWindow.PiPControlType = PiPWindow.PiPControlType.VIDEO_PLAY_PAUSE;
      let status: PiPWindow.PiPControlStatus = PiPWindow.PiPControlStatus.PLAY;
      this.pipController?.updatePiPControlStatus(controlType, status);
    }
  }

  async startPip(): Promise<void> {
    if (!this.pipController) {
      Logger.info(TAG, `pipController create error`);
      return;
    }
    try {
      await this.pipController.startPiP();
      this.changePipControllerStatusStart();
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `Invoke pipController failed, code is ${err.code}, message is ${err.message}`);
    }
  }

  async stopPip(): Promise<void> {
    if (!this.pipController) {
      Logger.info(TAG, `pipController is not exist`);
      return;
    }
    try {
      await this.pipController.stopPiP();
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `Invoke pipController failed, code is ${err.code}, message is ${err.message}`);
    }
  }

  async createPip(): Promise<void> {
    try {
      if (this.pipController) {
        this.pipController.off('stateChange');
        this.pipController.off('controlPanelActionEvent');
        await this.pipController.stopPiP();
      }
      await this.createPipController();
      await this.startPip();
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `Invoke pipController failed, code is ${err.code}, message is ${err.message}`);
    }
  }

  async createPipController(): Promise<void> {
    const context = this.getUIContext().getHostContext();
    if (!context) {
      Logger.error(TAG, `Create pipController failed, cause hostContext is undefined.`);
      return;
    }
    try {
      this.pipController = await PiPWindow.create({
        context: context,
        componentController: this.mXComponentController,
        navigationId: this.navigationId,
        templateType: PiPWindow.PiPTemplateType.VIDEO_PLAY,
        contentWidth: this.curBp === 'sm' ? 16 : this.curBp === 'md' ? 16 : 3,
        contentHeight: this.curBp === 'sm' ? 9 : this.curBp === 'md' ? 9 : 2
      });
      // Add initial state setup
      this.curState = 'STOPPED';

      this.pipController.on('stateChange', (state: PiPWindow.PiPState, reason: string) => {
        this.onStateChange(state, reason);
        if (state === PiPWindow.PiPState.STOPPED || state === PiPWindow.PiPState.STARTED) {
          this.player?.updatePlayStatus(true);
          this.player?.play()
          this.changePipControllerStatusStart();
        }
      });
      this.pipController.on('controlPanelActionEvent', (event: PiPWindow.PiPActionEventType, status?: number) => {
        this.onActionEvent(event, status);
        if (status === 0) {
          this.player?.updatePlayStatus(true);
        } else {
          this.player?.updatePlayStatus(false);
        }
      });
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `Create pipController failed, code is ${err.code}, message is ${err.message}`);
    }
  }

  destroyPipController(): void {
    if (!this.pipController) {
      return;
    }
    this.pipController.off('stateChange');
    this.pipController.off('controlPanelActionEvent');
    this.pipController = undefined;
  }

  onStateChange(state: PiPWindow.PiPState, reason: string): void {
    switch (state) {
      case PiPWindow.PiPState.ABOUT_TO_START:
        this.curState = 'ABOUT_TO_START';
        this.curError = $r('app.string.current_error_hint');
        break;
      case PiPWindow.PiPState.STARTED:
        this.curState = 'STARTED';
        this.curError = $r('app.string.current_error_hint');
        break;
      case PiPWindow.PiPState.ABOUT_TO_STOP:
        this.curState = 'ABOUT_TO_STOP';
        this.curError = $r('app.string.current_error_hint');
        break;
      case PiPWindow.PiPState.STOPPED:
        this.curState = 'STOPPED';
        this.curError = $r('app.string.current_error_hint');
        break;
      case PiPWindow.PiPState.ABOUT_TO_RESTORE:
        this.curState = 'ABOUT_TO_RESTORE';
        this.curError = $r('app.string.current_error_hint');
        break;
      case PiPWindow.PiPState.ERROR:
        this.curState = 'ERROR';
        this.curError = reason;
        break;
      default:
        break;
    }
    Logger.info(TAG, `onStateChange: ${this.curState}, reason: ${reason}`);
  }

  onActionEvent(event: PiPWindow.PiPActionEventType, status: number | undefined): void {
    switch (event) {
      case 'playbackStateChanged':
        if (status === 0) {
          this.player?.updatePlayStatus(false);
          this.player?.pause();
        } else {
          this.player?.updatePlayStatus(true);
          this.player?.play();
        }
        break;
      default:
        break;
    }
    this.buttonAction = event + `-status:${status}`;
    Logger.info(TAG, `onActionEvent: ${this.buttonAction} status:${status}}`);
  }

  showToast() {
    try {
      this.getUIContext().getPromptAction().showToast(({
        message: $r('app.string.notsupport'),
        duration: 2000
      }));
    } catch (error) {
      Logger.error(TAG, `showToast args error code is ${error.code}, message is ${error.message}}`);
    }
  }

  @Builder
  AutoPip() {
    Row() {
      Text($r('app.string.auto'))
        .textType()

      Toggle({ type: ToggleType.Switch, isOn: this.isAutoPull })
        .width($r('app.integer.auto_button_width'))
        .height($r('app.integer.auto_button_height'))
        .selectedColor($r('sys.color.brand'))
        .onChange(async (isOn: boolean) => {
          try {
            if (isOn) {
              if (this.curBp === 'xl') {
                this.showToast();
                return;
              }
            }
            this.isAutoPull = isOn;
            if (!this.pipController) {
              await this.createPipController();
            }
            this.pipController?.setAutoStartEnabled(this.isAutoPull);
            this.hintMsgVisibility = true;
          } catch (error) {
            const err: BusinessError = error as BusinessError;
            Logger.error(TAG, `Invoke pipController failed, code is ${err.code}, message is ${err.message}`);
          }
        })
    }
    .width(CommonConstants.FULL_PERCENT)
    .height($r('app.integer.auto_pip_height'))
    .backgroundColor($r('sys.color.comp_background_primary'))
    .borderRadius($r('sys.float.corner_radius_level8'))
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({
      left: $r('sys.float.corner_radius_level6'),
      right: $r('sys.float.corner_radius_level6')
    })
  }

  @Builder
  CallbackMessage() {
    Column() {
      Text($r('app.string.callback_message'))
        .fontSize($r('sys.float.Subtitle_L'))
        .width(CommonConstants.FULL_PERCENT)
        .fontColor($r('sys.color.font_secondary'))
        .padding({
          right: $r('sys.float.corner_radius_level6'),
          bottom: $r('sys.float.corner_radius_level6'),
          left: $r('sys.float.corner_radius_level6')
        })

      Column() {
        Column() {
          Column() {
            Row() {
              Text($r('app.string.current_status'))
                .textType()
              Text(this.curState)
                .msgType()
            }
            .twoTextRow()
          }
          .justifyContent(FlexAlign.Center)
          .height(this.curBp === 'sm' ? 48 : 56)

          Divider()
            .twoTextDivider()
        }
        .dataListColumn()
        .borderRadius({
          topLeft: $r('sys.float.corner_radius_level8'),
          topRight: $r('sys.float.corner_radius_level8')
        })

        Column() {
          Column() {
            Row() {
              Text($r('app.string.current_error'))
                .textType()
              Text(this.curError)
                .msgType()
            }
            .twoTextRow()
          }
          .justifyContent(FlexAlign.Center)
          .height(this.curBp === 'sm' ? 48 : 56)

          Divider()
            .twoTextDivider()
        }
        .dataListColumn()

        Column() {
          Column() {
            Row() {
              Text($r('app.string.current_action'))
                .textType()
              Text(this.buttonAction)
                .msgType()
            }
            .twoTextRow()
          }
          .justifyContent(FlexAlign.Center)
          .height(this.curBp === 'sm' ? 48 : 56)

          Divider()
            .twoTextDivider()
            .visibility(Visibility.Hidden)
        }
        .dataListColumn()
        .borderRadius({
          bottomLeft: $r('sys.float.corner_radius_level8'),
          bottomRight: $r('sys.float.corner_radius_level8')
        })
      }
    }
  }

  build() {
    NavDestination() {
      Column({ space: CommonConstants.SPACE }) {
        Stack() {
          RelativeContainer() {
            XComponent({
              id: 'video',
              type: XComponentType.SURFACE,
              controller: this.mXComponentController
            })
              .onLoad(() => {
                Logger.info(TAG, ` XComponent onLoad`);
                this.surfaceId = this.mXComponentController.getXComponentSurfaceId();
                this.player =
                  new AVPlayer(this.surfaceId, CommonConstants.AVPLAYER_TYPE, this.getUIContext().getHostContext()!);
                this.player.avPlayerFdSrc();
              })
              .onDestroy(() => {
                this.player?.stopAvPlayer();
                Logger.info(`[${TAG}] XComponent onDestroy`);
              })
              .size({
                width: CommonConstants.X_COMPONENT_WIDTH,
                height: '100%'
              })
              .backgroundColor($r('app.color.video_background_dark'))
              .align(Alignment.Bottom)
              .id('x_component')

            Row() {
              SymbolGlyph(this.curState === 'STOPPED' ? $r('sys.symbol.enlarge_window') :
                $r('sys.symbol.smal_window_playback'))
                .fontColor([$r('sys.color.icon_on_primary')])
                .fontSize($r('sys.float.Title_M'))
            }
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
            .backgroundColor($r('app.color.icon_background_dark'))
            .height(40)
            .aspectRatio(1)
            .alignRules({
              top: { anchor: '__container__', align: VerticalAlign.Top },
              right: { anchor: '__container__', align: HorizontalAlign.End }
            })
            .borderRadius($r('sys.float.corner_radius_level12'))
            .margin({
              top: $r('sys.float.padding_level16'),
              right: this.curBp === 'sm' ? $r('sys.float.padding_level6') : $r('sys.float.padding_level12')
            })
            .onClick(() => {
              if (this.curBp === 'xl') {
                this.showToast();
                return;
              }
              if (this.curState === 'STARTED') {
                this.stopPip();
                this.hintMsgVisibility = false;
                this.changePipControllerStatusStart();
              } else if (this.curState === 'STOPPED') {
                this.startPip();
                this.hintMsgVisibility = true;
                this.changePipControllerStatusStart();
              } else {
                if (this.pipController) {
                  this.startPip();
                } else {
                  this.createPip();
                }
                this.hintMsgVisibility = true;
                this.changePipControllerStatusStart();
              }
            })
          }
        }
        .backgroundColor($r('sys.color.background_primary'))
        .size({
          width: CommonConstants.X_COMPONENT_WIDTH,
          height: this.curBp === 'sm' ? '30%' : this.curBp === 'md' ? '45%' : '40%'
        })

        Scroll(this.scrollerForScroll) {
          Column({ space: CommonConstants.SPACE }) {
            this.AutoPip()
            this.CallbackMessage()
          }
          .height(CommonConstants.FULL_PERCENT)
          .justifyContent(FlexAlign.Start)
          .width(CommonConstants.NAV_DESTINATION_WIDTH)
        }
        .layoutWeight(CommonConstants.SCROLL_LAY_OUT_WEIGHT)
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
        .padding({
          right: $r('sys.float.corner_radius_level6'),
          left: $r('sys.float.corner_radius_level6')
        })
      }
      .width(CommonConstants.NAV_DESTINATION_WIDTH)
      .height(CommonConstants.NAV_DESTINATION_HEIGHT)
    }
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .hideTitleBar(true)
    .backgroundColor($r('sys.color.background_secondary'))
    .onBackPressed(() => {
      return true;
    })
  }
}