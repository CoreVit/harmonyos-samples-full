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

import { deviceInfo } from '@kit.BasicServicesKit';
import { CommonConstants, getWindowInfoState, MSVTextIcon, WidthBreakpointType, WindowInfo } from 'multishortvideobase';
import { CommentDataModel } from '../model/CommentDataModel';
import { ReplyDataModel } from '../model/ReplyDataModel';
import { CommentViewModel } from '../viewmodel/CommentViewModel';

@ComponentV2
export struct Comment {
  @Local windowInfo: WindowInfo = getWindowInfoState();
  @Local commentData: CommentDataModel[] = [];
  @Local commentInput: string = '';
  @Consumer('commentCount') commentCount: Length = 0;
  controller: TextInputController = new TextInputController();

  aboutToAppear(): void {
    this.commentData = new CommentViewModel().getCommentList();
    this.commentCount = this.commentData.length;
  }

  build() {
    RelativeContainer() {
      List() {
        Repeat<CommentDataModel>(this.commentData)
          .each((item: RepeatItem<CommentDataModel>) => {
            ListItem() {
              Column() {
                Row() {
                  Row({ space: 12 }) {
                    MSVTextIcon({ src: item.item.pic, iconSize: deviceInfo.deviceType === 'tv' ? 44 : 32 })
                    Row({ space: 4 }) {
                      Text(item.item.name)
                        .fontSize(deviceInfo.deviceType === 'tv' ? 22 : $r('sys.float.Body_M'))
                        .fontColor(new WidthBreakpointType<ResourceColor>($r('sys.color.font_primary'),
                          $r('sys.color.font_primary'), $r('sys.color.font_on_primary'),
                          $r('sys.color.font_on_primary')).getValue(this.windowInfo.widthBp))
                        .fontWeight($r('sys.float.font_weight_medium'))
                      if (item.item.id === 0) {
                        Row() {
                          Text($r('app.string.author'))
                            .fontSize(deviceInfo.deviceType === 'tv' ? 14 : $r('sys.float.Caption_M'))
                            .fontColor(new WidthBreakpointType<ResourceColor>($r('app.color.font_emphasize_light'),
                              $r('app.color.font_emphasize_light'), $r('app.color.font_emphasize_dark'),
                              $r('app.color.font_emphasize_dark')).getValue(this.windowInfo.widthBp))
                            .fontWeight($r('sys.float.font_weight_regular'))
                            .textVerticalAlign(TextVerticalAlign.CENTER)
                            .padding({
                              top: 1,
                              right: 4,
                              bottom: 1,
                              left: 4,
                            })
                        }
                        .border({
                          width: 1, color: new WidthBreakpointType<ResourceColor>($r('app.color.font_emphasize_light'),
                            $r('app.color.font_emphasize_light'), $r('app.color.font_emphasize_dark'),
                            $r('app.color.font_emphasize_dark')).getValue(this.windowInfo.widthBp)
                        })
                        .borderRadius(4)
                      }
                    }
                  }
                  .alignItems(VerticalAlign.Center)

                  Row({ space: 4 }) {
                    Text(item.item.likes)
                      .fontSize($r('sys.float.Caption_L'))
                      .fontColor(new WidthBreakpointType<ResourceColor>($r('sys.color.font_secondary'),
                        $r('sys.color.font_secondary'), $r('sys.color.font_on_secondary'),
                        $r('sys.color.font_on_secondary')).getValue(this.windowInfo.widthBp))
                      .fontWeight($r('sys.float.font_weight_regular'))
                    MSVTextIcon({
                      src: new WidthBreakpointType<Resource>($r('app.media.ic_heart'),
                        $r('app.media.ic_heart'), $r('app.media.ic_heart_light'),
                        $r('app.media.ic_heart_light')).getValue(this.windowInfo.widthBp),
                      iconSize: deviceInfo.deviceType === 'tv' ? 28 : 16
                    })
                  }
                }
                .width(CommonConstants.FULL_PERCENT)
                .padding({
                  top: 4,
                  bottom: 4,
                })
                .justifyContent(FlexAlign.SpaceBetween)
                .alignItems(VerticalAlign.Center)

                Column() {
                  Text(item.item.content)
                    .fontSize(deviceInfo.deviceType === 'tv' ? 24 : $r('sys.float.Body_L'))
                    .fontColor(new WidthBreakpointType<ResourceColor>($r('sys.color.font_primary'),
                      $r('sys.color.font_primary'), $r('sys.color.font_on_primary'),
                      $r('sys.color.font_on_primary')).getValue(this.windowInfo.widthBp))
                    .fontWeight($r('sys.float.font_weight_regular'))
                    .padding({
                      top: 9.5,
                      bottom: 9.5
                    })

                  Row({ space: 8 }) {
                    Text() {
                      Span(item.item.date)
                        .fontSize(deviceInfo.deviceType === 'tv' ? 16 : $r('sys.float.Caption_L'))
                        .fontColor(new WidthBreakpointType<ResourceColor>($r('sys.color.font_secondary'),
                          $r('sys.color.font_secondary'), $r('sys.color.font_on_secondary'),
                          $r('sys.color.font_on_secondary')).getValue(this.windowInfo.widthBp))
                        .fontWeight($r('sys.float.font_weight_regular'))
                      Span(CommonConstants.MIDDLE_DOT_SYMBOL)
                        .fontSize($r('sys.float.Caption_L'))
                        .fontColor(new WidthBreakpointType<ResourceColor>($r('sys.color.font_secondary'),
                          $r('sys.color.font_secondary'), $r('sys.color.font_on_secondary'),
                          $r('sys.color.font_on_secondary')).getValue(this.windowInfo.widthBp))
                        .fontWeight($r('sys.float.font_weight_regular'))
                      Span(item.item.location)
                        .fontSize(deviceInfo.deviceType === 'tv' ? 16 : $r('sys.float.Caption_L'))
                        .fontColor(new WidthBreakpointType<ResourceColor>($r('sys.color.font_secondary'),
                          $r('sys.color.font_secondary'), $r('sys.color.font_on_secondary'),
                          $r('sys.color.font_on_secondary')).getValue(this.windowInfo.widthBp))
                        .fontWeight($r('sys.float.font_weight_regular'))
                    }


                    Row() {
                      Text($r('app.string.reply'))
                        .fontSize(deviceInfo.deviceType === 'tv' ? 16 : $r('sys.float.Caption_L'))
                        .fontColor(new WidthBreakpointType<ResourceColor>($r('sys.color.font_primary'),
                          $r('sys.color.font_primary'), $r('sys.color.font_on_primary'),
                          $r('sys.color.font_on_primary')).getValue(this.windowInfo.widthBp))
                        .fontWeight($r('sys.float.font_weight_regular'))
                        .padding({
                          top: 4,
                          right: 8,
                          bottom: 4,
                          left: 8
                        })
                    }
                    .margin({
                      top: 8,
                      bottom: 8
                    })
                    .borderRadius(14)
                    .backgroundColor(new WidthBreakpointType<ResourceColor>($r('sys.color.comp_background_tertiary'),
                      $r('sys.color.comp_background_tertiary'), $r('app.color.search_icon_bg'),
                      $r('app.color.search_icon_bg')).getValue(this.windowInfo.widthBp))

                  }
                  .alignItems(VerticalAlign.Center)

                  if (item.item.replys && item.item.replys.length > 0) {
                    Repeat<ReplyDataModel>(item.item.replys)
                      .each((replysItem: RepeatItem<ReplyDataModel>) => {
                        Column({ space: 8 }) {
                          Text() {
                            Span(replysItem.item.name)
                              .fontSize(deviceInfo.deviceType === 'tv' ? 22 : $r('sys.float.Body_M'))
                              .fontColor(new WidthBreakpointType<ResourceColor>($r('sys.color.font_primary'),
                                $r('sys.color.font_primary'), $r('sys.color.font_on_primary'),
                                $r('sys.color.font_on_primary')).getValue(this.windowInfo.widthBp))
                              .fontWeight($r('sys.float.font_weight_medium'))
                            Span('：')
                              .fontSize(deviceInfo.deviceType === 'tv' ? 22 : $r('sys.float.Body_M'))
                              .fontColor(new WidthBreakpointType<ResourceColor>($r('sys.color.font_primary'),
                                $r('sys.color.font_primary'), $r('sys.color.font_on_primary'),
                                $r('sys.color.font_on_primary')).getValue(this.windowInfo.widthBp))
                              .fontWeight($r('sys.float.font_weight_medium'))
                            Span(replysItem.item.content)
                              .fontSize(deviceInfo.deviceType === 'tv' ? 22 : $r('sys.float.Body_M'))
                              .fontColor(new WidthBreakpointType<ResourceColor>($r('sys.color.font_primary'),
                                $r('sys.color.font_primary'), $r('sys.color.font_on_primary'),
                                $r('sys.color.font_on_primary')).getValue(this.windowInfo.widthBp))
                              .fontWeight($r('sys.float.font_weight_medium'))
                          }
                          Text($r('app.string.view_all_reply'))
                            .fontSize(deviceInfo.deviceType === 'tv' ? 16 : $r('sys.float.Body_S'))
                            .fontColor(new WidthBreakpointType<ResourceColor>($r('app.color.font_emphasize_light'),
                              $r('app.color.font_emphasize_light'), $r('app.color.font_emphasize_dark'),
                              $r('app.color.font_emphasize_dark')).getValue(this.windowInfo.widthBp))
                            .fontWeight($r('sys.float.font_weight_medium'))
                        }
                        .width(CommonConstants.FULL_PERCENT)
                        .alignItems(HorizontalAlign.Start)
                        .padding({
                          top: 12,
                          right: 16,
                          bottom: 12,
                          left: 16
                        })
                        .borderRadius(8)
                        .backgroundColor(
                          new WidthBreakpointType<ResourceColor>($r('sys.color.comp_background_tertiary'),
                            $r('sys.color.comp_background_tertiary'), $r('app.color.search_icon_bg'),
                            $r('app.color.search_icon_bg')).getValue(this.windowInfo.widthBp))
                      })
                      .key((item: ReplyDataModel) => JSON.stringify(item))
                  }

                }
                .width(CommonConstants.FULL_PERCENT)
                .alignItems(HorizontalAlign.Start)
                .padding({ left: 44 })

              }
              .width(CommonConstants.FULL_PERCENT)
              .padding({ top: 8, bottom: 8 })
            }

          })
          .key((item: CommentDataModel) => JSON.stringify(item))
          .virtualScroll({ totalCount: this.commentData.length })
        ListItem() {
          Row() {
            Text($r('app.string.nothing_more'))
              .fontSize($r('sys.float.Caption_L'))
              .fontColor(new WidthBreakpointType<ResourceColor>($r('sys.color.font_secondary'),
                $r('sys.color.font_secondary'), $r('sys.color.font_on_secondary'),
                $r('sys.color.font_on_secondary')).getValue(this.windowInfo.widthBp))
              .fontWeight($r('sys.float.font_weight_regular'))
          }
          .width(CommonConstants.FULL_PERCENT)
          .padding({
            top: 20,
            bottom: 30
          })
          .margin({ bottom: 56 })
          .justifyContent(FlexAlign.Center)
        }
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
      .scrollBar(BarState.Off)
      .padding({
        left: 16,
        right: 16,
      })

      Row() {
        Row({ space: 16 }) {
          TextInput({
            text: this.commentInput!!,
            placeholder: $r('app.string.leave_comment'),
            controller: this.controller
          })
            .placeholderColor(new WidthBreakpointType<ResourceColor>($r('sys.color.black'),
              $r('sys.color.black'), $r('sys.color.font_on_secondary'),
              $r('sys.color.font_on_secondary')).getValue(this.windowInfo.widthBp))
            .backgroundColor(new WidthBreakpointType<ResourceColor>($r('app.color.text_input_bg_xs'),
              $r('app.color.text_input_bg_xs'), $r('app.color.text_input_bg_md'),
              $r('app.color.text_input_bg_md')).getValue(this.windowInfo.widthBp))
            .placeholderFont({ size: deviceInfo.deviceType === 'tv' ? 24 : 16 })
            .caretColor(Color.Blue)
            .layoutWeight(1)
            .height(deviceInfo.deviceType === 'tv' ? 54 : 40)
            .fontSize(14)
            .fontColor(Color.Black)

          Row() {
            MSVTextIcon({
              src: new WidthBreakpointType<Resource>($r('app.media.ic_send'),
                $r('app.media.ic_send'), $r('app.media.ic_paper_plane'),
                $r('app.media.ic_paper_plane')).getValue(this.windowInfo.widthBp),
              iconSize: deviceInfo.deviceType === 'tv' ? 32 : 24
            })
          }
          .width(deviceInfo.deviceType === 'tv' ? 54 : 40)
          .aspectRatio(1)
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
          .backgroundColor(new WidthBreakpointType<ResourceColor>($r('sys.color.white'),
            $r('sys.color.white'), $r('app.color.icon_bg_dark'),
            $r('app.color.icon_bg_dark')).getValue(this.windowInfo.widthBp))
          .borderRadius(CommonConstants.HALF_PERCENT)

        }
        .width(CommonConstants.FULL_PERCENT)
        .height(deviceInfo.deviceType === 'tv' ? 70 : 56)
        .padding({
          left: 12,
          right: 16,
        })
        .alignItems(VerticalAlign.Center)
      }
      .padding({
        bottom: this.windowInfo.widthBp === WidthBreakpoint.WIDTH_SM &&
          this.windowInfo.heightBp === HeightBreakpoint.HEIGHT_MD ? 0 :
          new WidthBreakpointType<number>(28, 28, 28, 28, 0).getValue(this.windowInfo.widthBp)
      })
      .border({
        width: { top: new WidthBreakpointType<number>(1, 1, 0, 0).getValue(this.windowInfo.widthBp) },
        color: '#0C000000'
      })
      .alignRules({
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
        left: { anchor: '__container__', align: HorizontalAlign.Start }
      })
      .backgroundColor(new WidthBreakpointType<ResourceColor>($r('sys.color.white'),
        $r('sys.color.white'), $r('app.color.write_comment_bg'),
        $r('app.color.write_comment_bg')).getValue(this.windowInfo.widthBp))
      .backgroundBlurStyle(
        this.windowInfo.widthBp > WidthBreakpoint.WIDTH_MD ? BlurStyle.BACKGROUND_THIN : BlurStyle.NONE, { scale: 0.5 })
    }
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
  }
}
