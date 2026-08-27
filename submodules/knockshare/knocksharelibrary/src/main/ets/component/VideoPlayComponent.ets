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
import { KnockController } from '../controller/KnockController';
import { VideoPlayingView } from '../view/VideoPlayingView';
import { EpisodeChoose } from '../view/EpisodeChoose';
import { VIDEO_SOURCES } from '../model/VideoData';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { RouterParam, CommonConstants } from '../common/Constants';
import Logger from '../utils/Logger';

const TAG = '[KnockShareSample]';

@Builder
export function VideoPlayBuilder() {
  VideoPlay();
}

@Component
export struct VideoPlay {
  @StorageProp(CommonConstants.KEY_PREFIX + 'statusBarHeight') statusBarHeight: number = 0;
  @StorageProp(CommonConstants.KEY_PREFIX + 'naviIndicatorHeight') naviIndicatorHeight: number = 0;
  @StorageLink(CommonConstants.KEY_PREFIX + 'currentBreakpoint') curBp: string = BreakpointTypeEnum.SM;
  @StorageLink(CommonConstants.KEY_PREFIX + 'pageStack') pageStack: NavPathStack = new NavPathStack();
  @State videoEpisode: number[] = [];
  @State immersiveStatus: boolean = false;
  @State @Watch('videoIndexChange') videoIndex: number = -1;
  private knockController: KnockController | undefined = undefined;
  private context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;

  aboutToAppear(): void {
    Logger.info(TAG, `aboutToAppear videoIndex is ${this.videoIndex}`);
    VIDEO_SOURCES.forEach((_item, index: number) => {
      this.videoEpisode.push(index + 1);
    })
    this.knockController = KnockController.getInstance(this.context);
    this.knockController?.immersiveListening(this.videoIndex, this.context);
  }

  videoIndexChange() {
    this.knockController?.immersiveListening(this.videoIndex, this.context);
  }

  onBackPress(): boolean | void {
    this.pageStack.pop();
    return true;
  }

  onPageShow(): void {
    this.knockController?.immersiveListening(this.videoIndex, this.context);
  }

  onPageHide(): void {
    this.knockController?.immersiveDisableListening();
  }

  aboutToDisappear(): void {
    this.knockController?.immersiveDisableListening();
  }

  build() {
    NavDestination() {
      Column() {
        Flex({
          direction: this.curBp === BreakpointTypeEnum.LG || this.curBp === BreakpointTypeEnum.XL ? FlexDirection.Row :
            FlexDirection.Column
        }) {
          VideoPlayingView({
            videoList: VIDEO_SOURCES,
            videoIndex: this.videoIndex
          })
            .width(this.curBp === BreakpointTypeEnum.LG ? '70%' : '100%')
            .height(this.curBp === BreakpointTypeEnum.LG ? '100%' : 'auto')
          Column() {
            Row() {
              Text($r('app.string.play_list'))
                .height(24)
                .fontWeight(FontWeight.Bold)
                .fontSize(18)
                .fontColor('#ffffff')
                .alignSelf(ItemAlign.End)
            }
            .height(56)
            .padding({ bottom: $r('sys.float.padding_level4') })
            .width('100%')

            EpisodeChoose({ numberTest: this.videoEpisode, videoIndex: this.videoIndex })
          }
          .layoutWeight((this.curBp === BreakpointTypeEnum.LG || this.curBp === BreakpointTypeEnum.XL) ? undefined : 1)
          .backgroundColor('#202224')
          .width((this.curBp === BreakpointTypeEnum.LG || this.curBp === BreakpointTypeEnum.XL) ? '30%' : '100%')
          .height((this.curBp === BreakpointTypeEnum.LG || this.curBp === BreakpointTypeEnum.XL) ? '100%' : undefined)
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
              'auto'
          })
        }
        .width('100%')
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      let param = context.pathInfo.param as RouterParam;
      if (param && param.videoIndex != -1) {
        this.videoIndex = param.videoIndex;
      }
    })
  }
}