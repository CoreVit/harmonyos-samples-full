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

import { media } from '@kit.MediaKit';
import { deviceInfo } from '@kit.BasicServicesKit';
import { KeyCode } from '@kit.InputKit';
import { CommonConstants, getWindowInfoState, MSVTextIcon, WidthBreakpointType, WindowInfo } from 'multishortvideobase';
import { Comment } from 'multishortvideocomment';
import { AdaptiveAVPlayer } from './AdaptiveAVPlayer';
import { AvDataSourceModel } from '../model/AvDataSourceModel';
import { AvDataSourceViewModel } from '../viewModel/AvDataSourceViewModel';


@ComponentV2
export struct AdaptiveVideo {
  @Local windowInfo: WindowInfo = getWindowInfoState();
  private avDataSource: AvDataSourceModel[] = [];
  private swiperController: SwiperController = new SwiperController();
  @Local curIndex: number = 0;
  @Local angle: number = 0;
  @Provider('duration') duration: number = 0;
  @Provider('currentTime') currentTime: number = 0;
  @Local showComment: boolean = false;
  @Local currentState: media.AVPlayerState = 'idle';
  @Consumer('showSideComment') showSideComment: boolean = false;
  @Consumer('showSideIndividual') showSideIndividual: boolean = false;
  @Consumer('pathStack') pathStack: NavPathStack = new NavPathStack();
  @Provider('windowSizeWidth') windowSizeWidth: Length = 0;
  @Provider('windowSizeHeight') windowSizeHeight: Length = 0;
  @Provider('commentCount') commentCount: Length = 0;

  aboutToAppear(): void {
    this.avDataSource = new AvDataSourceViewModel().getAvDataSource();
  }

  @Builder
  commentContentBuilder() {
    Comment()
  }

  build() {
    Column() {
      Swiper(this.swiperController) {
        Repeat<AvDataSourceModel>(this.avDataSource)
          .each((item: RepeatItem<AvDataSourceModel>) => {
            Stack({ alignContent: Alignment.BottomStart }) {
              AdaptiveAVPlayer({
                currentIndex: this.curIndex,
                index: item.index,
                currentSource: item.item.currentSource,
                onStateNotify: (state: media.AVPlayerState) => {
                  this.currentState = state;
                }
              })

              Column({ space: deviceInfo.deviceType === 'tv' ? 32 : 16 }) {
                Row({ space: 24 }) {
                  Column({ space: deviceInfo.deviceType === 'tv' ? 12 : 9 }) {
                    Row() {
                      if (this.windowInfo.widthBp === WidthBreakpoint.WIDTH_XS) {
                        MSVTextIcon({ src: $r('app.media.ic_user_avatar'), iconSize: 32 })
                          .margin({ right: 8 })
                      }
                      Text() {
                        Span(CommonConstants.AT_SYMBOL)
                          .fontSize(deviceInfo.deviceType === 'tv' ? 24 :
                            new WidthBreakpointType<number | Resource>($r('sys.float.Body_L'),
                              $r('sys.float.Body_L'), $r('sys.float.Body_L'), $r('sys.float.Body_L'),
                              15).getValue(this.windowInfo.widthBp))
                          .fontColor($r('sys.color.font_on_primary'))
                          .fontWeight($r('sys.float.font_weight_medium'))
                        Span($r('app.string.author_id'))
                          .fontSize(deviceInfo.deviceType === 'tv' ? 24 :
                            new WidthBreakpointType<number | Resource>($r('sys.float.Body_L'),
                              $r('sys.float.Body_L'), $r('sys.float.Body_L'), $r('sys.float.Body_L'),
                              15).getValue(this.windowInfo.widthBp))
                          .fontColor($r('sys.color.font_on_primary'))
                          .fontWeight($r('sys.float.font_weight_medium'))
                        if (this.windowInfo.widthBp !== WidthBreakpoint.WIDTH_XS) {
                          Span(CommonConstants.MIDDLE_DOT_SYMBOL)
                            .fontSize($r('sys.float.Body_M'))
                            .fontColor($r('sys.color.font_on_secondary'))
                            .fontWeight($r('sys.float.font_weight_regular'))
                          Span($r('app.string.release_time'))
                            .fontSize(deviceInfo.deviceType === 'tv' ? 16 : $r('sys.float.Body_M'))
                            .fontColor($r('sys.color.font_on_secondary'))
                            .fontWeight($r('sys.float.font_weight_regular'))
                        }
                      }
                      .textVerticalAlign(
                        deviceInfo.deviceType === 'tv' ? TextVerticalAlign.CENTER : TextVerticalAlign.TOP)
                    }
                    .alignItems(VerticalAlign.Center)

                    Text($r('app.string.body_text'))
                      .fontSize(deviceInfo.deviceType === 'tv' ? 24 :
                        new WidthBreakpointType<number | Resource>($r('sys.float.Body_M'),
                          $r('sys.float.Body_M'), $r('sys.float.Body_L'), $r('sys.float.Body_L')).getValue(
                          this.windowInfo.widthBp))
                      .fontColor($r('sys.color.font_on_primary'))
                      .fontWeight($r('sys.float.font_weight_regular'))
                      .lineHeight(deviceInfo.deviceType === 'tv' ? 32 : 22)
                      .textVerticalAlign(TextVerticalAlign.TOP)
                      .maxLines(new WidthBreakpointType<number>(2, 2, 2, 2, 1).getValue(this.windowInfo.widthBp))
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                  }
                  .layoutWeight(1)
                  .alignItems(HorizontalAlign.Start)
                  .margin({
                    bottom: this.windowInfo.widthBp === WidthBreakpoint.WIDTH_SM &&
                      this.windowInfo.heightBp === HeightBreakpoint.HEIGHT_MD ? 64 : 0
                  })

                  Column({ space: 16 }) {
                    if (this.windowInfo.widthBp !== WidthBreakpoint.WIDTH_XS) {
                      MSVTextIcon(
                        { src: $r('app.media.ic_user_avatar'), iconSize: deviceInfo.deviceType === 'tv' ? 56 : 44 })
                        .gesture(
                          TapGesture()
                            .onAction(() => {
                              if (this.showSideIndividual) {
                                return;
                              }
                              if (this.windowInfo.widthBp > WidthBreakpoint.WIDTH_SM) {
                                this.showSideIndividual = true;
                                this.pathStack.pushPathByName('IndividualByRouter', null);
                              } else {
                                this.pathStack.pushPathByName('IndividualByRouter', null);
                              }
                            }))
                    }
                    MSVTextIcon({
                      src: $r('app.media.ic_heart_fill'),
                      iconOnly: false,
                      content: '1557',
                      iconSize: deviceInfo.deviceType === 'tv' ? 40 :
                        new WidthBreakpointType<number>(32, 32, 32, 32, 24).getValue(this.windowInfo.widthBp),
                      fontSize: new WidthBreakpointType<number | Resource>($r('sys.float.Body_M'),
                        $r('sys.float.Body_M'), $r('sys.float.Body_M'), $r('sys.float.Body_M'),
                        15).getValue(this.windowInfo.widthBp)
                    })
                    MSVTextIcon({
                      src: $r('app.media.ic_message_fill'),
                      iconOnly: false,
                      content: '566',
                      iconSize: deviceInfo.deviceType === 'tv' ? 40 :
                        new WidthBreakpointType<number>(32, 32, 32, 32, 24).getValue(this.windowInfo.widthBp),
                      fontSize: new WidthBreakpointType<number | Resource>($r('sys.float.Body_M'),
                        $r('sys.float.Body_M'), $r('sys.float.Body_M'), $r('sys.float.Body_M'),
                        15).getValue(this.windowInfo.widthBp)
                    })
                      .gesture(
                        TapGesture()
                          .onAction(() => {
                            if (this.showSideComment || this.windowInfo.widthBp === WidthBreakpoint.WIDTH_XS) {
                              return;
                            }
                            if (this.windowInfo.widthBp > WidthBreakpoint.WIDTH_SM) {
                              this.showSideComment = true;
                              this.pathStack.pushPathByName('SplitComment', null);
                            } else {
                              this.showComment = true;
                            }
                          }))
                    if (this.windowInfo.widthBp !== WidthBreakpoint.WIDTH_XS) {
                      MSVTextIcon({
                        src: $r('app.media.ic_share'),
                        iconOnly: false,
                        content: '148',
                        iconSize: deviceInfo.deviceType === 'tv' ? 40 :
                          new WidthBreakpointType<number>(32, 32, 32, 32, 24).getValue(this.windowInfo.widthBp)
                      })
                    }
                  }
                  .margin({ bottom: this.windowInfo.widthBp === WidthBreakpoint.WIDTH_XS ? 15 : 0 })
                }
                .width(CommonConstants.FULL_PERCENT)
                .alignItems(VerticalAlign.Bottom)

                if (this.windowInfo.widthBp !== WidthBreakpoint.WIDTH_XS) {
                  Column() {
                    Row() {
                      Row({ space: 1.5 }) {
                        MSVTextIcon({ src: $r('app.media.ic_bg_music'), iconSize: 16 })
                        Text($r('app.string.original_music'))
                          .fontSize(deviceInfo.deviceType === 'tv' ? 14 : $r('sys.float.Body_M'))
                          .fontColor($r('sys.color.font_on_primary'))
                          .fontWeight($r('sys.float.font_weight_regular'))
                      }

                      MSVTextIcon(
                        { src: $r('app.media.ic_music_cover'), iconSize: deviceInfo.deviceType === 'tv' ? 40 : 32 })
                        .rotate({ angle: this.angle })
                        .animation({
                          duration: 3500,
                          iterations: -1,
                          curve: Curve.Linear,
                          playMode: PlayMode.Normal
                        })
                        .onAppear(() => {
                          this.angle = 360;
                        })
                    }
                    .width(CommonConstants.FULL_PERCENT)
                    .justifyContent(FlexAlign.SpaceBetween)

                    Progress({ value: this.currentTime, total: this.duration, type: ProgressType.Linear })
                      .width(CommonConstants.FULL_PERCENT)
                      .color($r('sys.color.white'))
                      .backgroundColor('#19ffffff')
                      .margin({
                        top: 10,
                        bottom: 10
                      })
                  }
                  .width(CommonConstants.FULL_PERCENT)
                  .visibility(this.windowInfo.widthBp === WidthBreakpoint.WIDTH_SM &&
                    this.windowInfo.heightBp === HeightBreakpoint.HEIGHT_MD ? Visibility.None :
                    Visibility.Visible)
                }
              }
              .width(CommonConstants.FULL_PERCENT)
              .padding({
                left: new WidthBreakpointType<number>(16, 16, 32, 32).getValue(this.windowInfo.widthBp),
                right: new WidthBreakpointType<number>(16, 16, 32, 32).getValue(this.windowInfo.widthBp)
              })
              .margin({
                bottom: this.windowInfo.widthBp === WidthBreakpoint.WIDTH_SM &&
                  this.windowInfo.heightBp === HeightBreakpoint.HEIGHT_MD ? 0 : deviceInfo.deviceType === '2in1' ? 24 :
                  deviceInfo.deviceType === 'tv' ? 32 :
                    new WidthBreakpointType<number>(88, 88, 88, 88, 45).getValue(this.windowInfo.widthBp)
              })
              .hitTestBehavior(HitTestMode.Transparent)
              .visibility((this.windowInfo.widthBp === WidthBreakpoint.WIDTH_XS &&
                this.currentState !== CommonConstants.AV_PLAYER_PAUSED_STATE) ?
                Visibility.None : Visibility.Visible)
            }
          })
          .key((item: AvDataSourceModel) => JSON.stringify(item))
          .virtualScroll({ totalCount: this.avDataSource.length })
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
      .height(LayoutPolicy.matchParent)
      .ignoreLayoutSafeArea()
      .cachedCount(2)
      .vertical(true)
      .loop(false)
      .curve(Curve.Ease)
      .duration(300)
      .indicator(false)
      .onKeyPreIme((event: KeyEvent) => {
        if (event.type === KeyType.Down) {
          if (event.keyCode === KeyCode.KEYCODE_DPAD_DOWN) {
            this.swiperController.showNext();
          }
          if (event.keyCode === KeyCode.KEYCODE_DPAD_UP) {
            this.swiperController.showPrevious();
          }
        }
        return false;
      })
      .onAnimationStart((index: number, targetIndex: number) => {
        this.curIndex = targetIndex;
      })
      .bindSheet($$this.showComment, this.commentContentBuilder(), {
        height: CommonConstants.SEVENTY_FIVE_PERCENT,
        title: { title: $r('app.string.comment_title', 5) },
        blurStyle: BlurStyle.Thick,
        showClose: true
      })
    }
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .ignoreLayoutSafeArea()
    .height(LayoutPolicy.matchParent)
    .onAreaChange((oldValve, newValve) => {
      this.windowSizeWidth = newValve.width;
      this.windowSizeHeight = newValve.height;
    })
  }
}