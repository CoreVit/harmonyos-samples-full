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
import { AVPlayerController } from '../controller/AVPlayerController';
import { VideoData } from '../model/VideoData';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { CommonConstants } from '../common/Constants';
import { AVPlayerControllerView } from './AVPlayerControllerView';
import Logger from '../utils/Logger';

const TAG = 'VideoPlayingView';

@Component
export struct VideoPlayingView {
  @State @Watch('avPlayerStateChange') avPlayerController?: AVPlayerController = undefined;
  @StorageLink(CommonConstants.KEY_PREFIX + 'currentBreakpoint') curBp: string = BreakpointTypeEnum.SM;
  @StorageProp(CommonConstants.KEY_PREFIX + 'statusBarHeight') statusBarHeight: number = 0;
  @StorageProp(CommonConstants.KEY_PREFIX + 'naviIndicatorHeight') naviIndicatorHeight: number = 0;
  @Link @Watch('videoIndexChange') videoIndex: number;
  @StorageLink(CommonConstants.KEY_PREFIX + 'pageStack') pageStack: NavPathStack = new NavPathStack();
  @Prop videoList: VideoData[];
  @State surfaceID: string = '';
  @State currentTime: number = 0;
  @State durationTime: number = 0;
  @State isPlaying: boolean = false;
  @State isShowAVPlayerController: boolean = false;
  @State avPlayerControllerTimeID: number = 0;
  private xComponentController = new XComponentController();
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;

  /**
   * Listen to the callback for the change of video playback status
   */
  public async avPlayerStateChange() {
    if (this.avPlayerController) {
      this.currentTime = this.avPlayerController.currentTime;
      this.durationTime = this.avPlayerController.durationTime;
      this.isPlaying = this.avPlayerController.state === 'playing';
      if (this.avPlayerController.state === 'completed') {
        this.nextVideo();
      }
    }
  }

  /**
   * Initialize AVPlayer
   */
  private async initAVPlayer(context: common.UIAbilityContext) {
    this.surfaceID = this.xComponentController.getXComponentSurfaceId();
    if (this.surfaceID !== '' && this.videoIndex >= 0 && this.videoIndex < this.videoList.length) {
      this.avPlayerController =
        await AVPlayerController.create(this.surfaceID, this.videoList[this.videoIndex].url, this.context);
    }
  }

  /**
   * Release AVPlayer
   */
  private async releaseAVPlayer(context: common.UIAbilityContext) {
    if (this.avPlayerController) {
      Logger.info(TAG, 'releaseAVPlayer')
      await this.avPlayerController.releasePlayer(context);
      this.avPlayerController = undefined;
    }
  }

  /**
   * Listen for the callback for the change of the video playback index
   */
  public async videoIndexChange() {
    Logger.info(TAG, `videoIndexChange index is: ${this.videoIndex}`)
    await this.releaseAVPlayer(this.context);
    await this.initAVPlayer(this.context);
  }

  /**
   * Displays the video playback control component
   */
  private showAVPlayerController() {
    this.isShowAVPlayerController = true;
    clearTimeout(this.avPlayerControllerTimeID);
    this.avPlayerControllerTimeID = setTimeout(() => {
      this.isShowAVPlayerController = false;
    }, 2000);
  }

  /**
   * Displays the video playback control component
   */
  private nextVideo() {
    if (this.videoIndex < this.videoList.length - 1) {
      this.videoIndex += 1;
    } else {
      this.videoIndex = 0;
    }
  }

  async aboutToDisappear(): Promise<void> {
    await this.releaseAVPlayer(this.context);
    clearTimeout(this.avPlayerControllerTimeID);
  }

  build() {
    Stack() {
      Column() {
        if (!(this.curBp === BreakpointTypeEnum.LG || this.curBp === BreakpointTypeEnum.XL)) {
          Blank()
            .backgroundColor(Color.Black)
            .width('100%')
            .height(this.statusBarHeight)
        }
        XComponent({
          id: 'player',
          type: XComponentType.SURFACE,
          controller: this.xComponentController
        })
          .width('100%')
          .aspectRatio(16 / 9)
          .onLoad(async () => {
            await this.initAVPlayer(this.context);
          })
      }
      .backgroundColor(Color.Black)
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height(this.curBp === BreakpointTypeEnum.LG || this.curBp === BreakpointTypeEnum.XL ? '100%' : 'auto')

      Column() {
        if (!(this.curBp === BreakpointTypeEnum.LG || this.curBp === BreakpointTypeEnum.XL)) {
          Blank()
            .backgroundColor(Color.Black)
            .width('100%')
            .height(this.statusBarHeight)
        }
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween }) {
          Row() {
            Row() {
              SymbolGlyph($r('sys.symbol.chevron_left'))
                .fontSize(24)
                .fontColor([$r('sys.color.icon_on_primary')])
            }
            .width(40)
            .height(40)
            .backgroundColor('rgba(255,255,255,0.1)')
            .borderRadius(20)
            .justifyContent(FlexAlign.Center)
            .margin({ top: $r('sys.float.padding_level4'), bottom: $r('sys.float.padding_level4') })
            .onClick(async () => {
              this.pageStack.pop();
              await this.releaseAVPlayer(this.context);
            })

            Blank()
          }
          .width('100%')

          AVPlayerControllerView({
            currentTime: this.currentTime,
            durationTime: this.durationTime,
            isPlaying: this.isPlaying,
            isShowAVPlayerController: this.isShowAVPlayerController,
            avPlayerControllerTimeID: this.avPlayerControllerTimeID,
            avPlayerController: this.avPlayerController
          })
            .visibility(this.isShowAVPlayerController ? Visibility.Visible : Visibility.Hidden)
        }
        .size(this.curBp === BreakpointTypeEnum.LG ? { width: '100%', height: '100%' } : { width: '100%' })
        .aspectRatio(this.curBp === BreakpointTypeEnum.LG ? undefined : 16 / 9)
        .padding({
          left: new BreakpointType({
            sm: $r('sys.float.padding_level8'),
            md: $r('sys.float.padding_level12'),
            lg: $r('sys.float.padding_level16')
          }).getValue(this.curBp),
          right: new BreakpointType({
            sm: $r('sys.float.padding_level8'),
            md: $r('sys.float.padding_level12'),
            lg: $r('sys.float.padding_level16')
          }).getValue(this.curBp),
          top: (this.curBp === BreakpointTypeEnum.LG || this.curBp === BreakpointTypeEnum.XL) ? this.statusBarHeight :
            'auto',
        })
        .onClick(() => {
          this.showAVPlayerController();
        })
      }
      .width('100%')
      .height('auto')
    }
    .height(this.curBp === BreakpointTypeEnum.LG || this.curBp === BreakpointTypeEnum.XL ? '100%' : 'auto')
    .width('100%')
  }
}