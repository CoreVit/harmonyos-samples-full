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
import { BreakpointType, BreakpointTypeEnum } from '../common/utils/BreakpointSystem';
import { CommonConstants } from '../common/constants/CommonConstants';
import { ResourceUtil } from '../common/utils/ResourceUtil';
import { AVCastController } from '../controller/AVCastController';
import { VideoPlayerController } from '../controller/VideoPlayerController';
import { VideoSessionController } from '../controller/VideoSessionController';
import { VideoData, NET_SOURCES, LOC_SOURCES } from '../model/VideoData';
import { RemoteControlPage } from './RemoteControlPage';
import { EpisodeChoose } from '../view/CommonView';
import { VideoCastingView } from '../view/VideoCastingView';
import { VideoPlayingView } from '../view/VideoPlayingView';

@Component
export struct VideoPlay {
  @StorageLink(CommonConstants.KEY_PREFIX + 'Breakpoint') currentWidthBreakpoint: string = 'sm';
  @StorageLink(CommonConstants.KEY_PREFIX + 'StatusBarHeight') statusBarHeight: number = 0;
  @StorageLink('castAvSessionController') avSessionController ?: VideoSessionController = undefined;
  @StorageLink('castAvPlayerController') avPlayerController ?: VideoPlayerController = undefined;
  @StorageLink(CommonConstants.KEY_PREFIX + 'AvCastController') avCastController ?: AVCastController = undefined;
  @StorageLink('deviceName') deviceName: string = '';
  @StorageLink('castingList') castingList: string[] = [];
  @Consume remoteControlPathStack: NavPathStack;
  @Prop videoType: string = '';
  @State videoPlayPathStack: NavPathStack = new NavPathStack();
  @State volume: number = 20;
  @State videoIndex: number = 0;
  @State castIndex: number = 0;
  @State videoList: VideoData[] = [];
  @State videoEpisode: number[] = [];

  @Builder
  PageMap(name: string, param: number) {
    if (param === -1) {
      RemoteControlPage({
        videoList: this.videoList, castIndex: this.videoIndex, videoType: this.videoType
      });
    } else {
      RemoteControlPage({
        videoList: this.videoList,
        castIndex: this.videoIndex,
        avplayerTime: param,
        videoType: this.videoType,
        handleCastIndexChange: (index: number) => {
          this.castIndex = index
        }
      });
    }
  }

  aboutToAppear(): void {
    if (this.videoType === 'network') {
      this.videoList = NET_SOURCES;
      let urlArray: string[] = ResourceUtil.getVideoUrlByRawFileContent(this.getUIContext().getHostContext()!);
      for (let index = 0; index < urlArray.length; index++) {
        this.videoList[index].url = urlArray[index];
      }
    } else {
      this.videoList = LOC_SOURCES;
    }
    this.videoList.forEach((item, index: number) => {
      this.videoEpisode.push(index + 1);
    })
    if (this.avCastController) {
      this.castIndex = this.avCastController.castIndex;
    }
  }

  build() {
    NavDestination() {
      Navigation(this.remoteControlPathStack) {
        WithTheme({ colorMode: ThemeColorMode.DARK }) {
          Flex({
            direction: (this.currentWidthBreakpoint === BreakpointTypeEnum.LG ||
              this.currentWidthBreakpoint === BreakpointTypeEnum.XL) ? FlexDirection.Row : FlexDirection.Column
          }) {
            Column() {
              VideoPlayingView({
                videoList: this.videoList,
                videoIndex: this.videoIndex,
                videoPlayPathStack: this.videoPlayPathStack,
                videoType: this.videoType
              })
                .visibility(this.castingList.includes(this.videoType) ? Visibility.None : Visibility.Visible)
              VideoCastingView({
                videoList: this.videoList,
                castIndex: this.castIndex,
                videoPlayPathStack: this.videoPlayPathStack,
                videoType: this.videoType
              })
                .visibility(this.castingList.includes(this.videoType) ? Visibility.Visible : Visibility.None)
                .onClick(() => {
                  this.remoteControlPathStack.pushPath({ name: 'detail' });
                })
            }
            .justifyContent(FlexAlign.Center)
            .size((this.currentWidthBreakpoint === BreakpointTypeEnum.LG ||
              this.currentWidthBreakpoint === BreakpointTypeEnum.XL) ? { width: '70%', height: '100%' } :
              { width: '100%' })
            .aspectRatio((this.currentWidthBreakpoint === BreakpointTypeEnum.LG ||
              this.currentWidthBreakpoint === BreakpointTypeEnum.XL) ? undefined : 1920 / 1080)
            .backgroundColor(Color.Black)
            .padding({
              top: (this.currentWidthBreakpoint === BreakpointTypeEnum.LG ||
                this.currentWidthBreakpoint === BreakpointTypeEnum.XL) ? this.statusBarHeight : 0
            })

            Column() {
              Row() {
                Text($r('app.string.episode_choose'))
                  .height(24)
                  .fontWeight(FontWeight.Bold)
                  .fontSize(18)
                  .fontColor('#E5FFFFFF')
              }
              .alignItems(VerticalAlign.Center)
              .height(56)
              .width('100%')

              EpisodeChoose({
                numberTest: this.videoEpisode, videoIndex: this.videoIndex, callback: (index: number) => {
                  this.videoIndex = index
                }
              })
                .visibility(this.castingList.includes(this.videoType) ? Visibility.None : Visibility.Visible)

              EpisodeChoose({
                numberTest: this.videoEpisode, videoIndex: this.castIndex, callback: (index: number) => {
                  this.castIndex = index;
                }
              })
                .visibility(this.castingList.includes(this.videoType) ? Visibility.Visible : Visibility.None)

            }
            .size((this.currentWidthBreakpoint === BreakpointTypeEnum.LG ||
              this.currentWidthBreakpoint === BreakpointTypeEnum.XL) ? { width: '30%', height: '100%' } :
              { width: '100%' })
            .layoutWeight(1)
            .backgroundColor($r('sys.color.gray_02'))
            .padding({
              right: new BreakpointType({
                sm: $r('sys.float.padding_level8'),
                md: $r('sys.float.padding_level12'),
                lg: $r('sys.float.padding_level16')
              }).getValue(this.currentWidthBreakpoint),
              left: new BreakpointType({
                sm: $r('sys.float.padding_level8'),
                md: $r('sys.float.padding_level12'),
                lg: $r('sys.float.padding_level16')
              }).getValue(this.currentWidthBreakpoint),
              top: (this.currentWidthBreakpoint === BreakpointTypeEnum.LG ||
                this.currentWidthBreakpoint === BreakpointTypeEnum.XL) ? this.statusBarHeight : 0
            })
          }
          .width('100%')
          .height('100%')
          .padding({
            top: (this.currentWidthBreakpoint === BreakpointTypeEnum.LG ||
              this.currentWidthBreakpoint === BreakpointTypeEnum.XL) ? 0 : this.statusBarHeight
          })
        }

      }
      .width('100%')
      .backgroundColor(Color.Black)
      .height('100%')
      .hideTitleBar(true)
      .mode(NavigationMode.Stack)
      .navDestination(this.PageMap)
    }
    .backgroundColor(Color.Black)
    .width('100%')
    .height('100%')
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.videoPlayPathStack = context.pathStack;
    })
    .onBackPressed(() => {
      if (this.avPlayerController) {
        this.avPlayerController.releasePlayer();
        this.avPlayerController = undefined;
      }
      if (this.castingList.length === 0) {
        if (this.avSessionController) {
          this.avSessionController.destroyAvSessionListener(this.getUIContext()
            .getHostContext() as common.UIAbilityContext);
          this.avSessionController = undefined;
        }
      }
      return false;
    })
  }
}

