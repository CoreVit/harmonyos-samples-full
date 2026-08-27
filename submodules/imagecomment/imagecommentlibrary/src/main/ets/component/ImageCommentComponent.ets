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

import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { CommonConstants } from '../common/constants/CommonConstants';
import { Comment, CommentData } from '../model/CommentModel';
import { CommentInputDialog } from '../view/CommentInputDialog';
import { CommentView } from '../view/CommentItemView';
import { mockData } from '../model/MockCommentData';

@Component
export struct ImageCommentComponent {
  @StorageLink(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  @State commentList: CommentData = new CommentData();
  @State textInComment: string = '';
  @State imageInComment: string[] = [];
  @StorageProp(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageProp(CommonConstants.AS_KEY_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CommentInputDialog({
      textInComment: $textInComment,
      imagesInComment: $imageInComment,
      publish: () => this.publishComment()
    }),
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    customStyle: true
  });

  aboutToAppear(): void {
    this.commentList = mockData();
  }

  aboutToDisappear() {
    this.dialogController = null;
  }

  publishComment(): void {
    const comment: Comment =
      new Comment($r('app.string.name_mine'), this.textInComment, $r('app.media.app_mine_logo'), this.imageInComment,
        this.getCurrentDate());
    this.commentList.addDataFirst(comment);
  }

  getCurrentDate(): string {
    const date: Date = new Date();
    return `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()} ${date.getHours()}:${date.getMinutes()}`;
  }

  build() {
    GridRow({
      columns: {
        sm: 4,
        md: 10,
        lg: 10
      }
    }) {
      GridCol({
        span: {
          sm: 4,
          md: 6,
          lg: 6
        }
      }) {
        Column() {
          Column() {
            Text($r('app.string.image_comment_title'))
              .fontWeight(FontWeight.Bold)
              .fontSize($r('sys.float.Title_L'))
              .width('100%')
              .fontColor($r('sys.color.font_primary'))
              .padding({
                left: new BreakpointType({
                  sm: $r('sys.float.padding_level8'),
                  md: $r('sys.float.padding_level12'),
                  lg: $r('sys.float.padding_level16')
                }).getValue(this.curBp),
              })
              .margin({
                top: $r('sys.float.padding_level32'),
                bottom: $r('sys.float.padding_level6')
              })
          }
          .padding({
            top: this.statusBarHeight,
            bottom: new BreakpointType({
              sm: $r('sys.float.padding_level0'),
              md: $r('sys.float.padding_level32'),
              lg: $r('sys.float.padding_level16')
            }).getValue(this.curBp),
          })

          Column() {
            Image($r('app.media.launch_advert'))
              .width('100%')
              .aspectRatio(16 / 9)
              .objectFit(ImageFit.Cover)
              .borderRadius(new BreakpointType({ sm: 0, md: 16, lg: 16 }).getValue(this.curBp))
              .padding({
                left: new BreakpointType({
                  sm: $r('sys.float.padding_level6'),
                  md: $r('sys.float.padding_level12'),
                  lg: $r('sys.float.padding_level16')
                }).getValue(this.curBp),
                right: new BreakpointType({
                  sm: $r('sys.float.padding_level6'),
                  md: $r('sys.float.padding_level12'),
                  lg: $r('sys.float.padding_level16')
                }).getValue(this.curBp)
              })
          }
        }
        .border({
          width: {
            right: new BreakpointType({
              sm: $r('sys.float.padding_level0'),
              md: $r('app.integer.border_width'),
              lg: $r('app.integer.border_width')
            }
            ).getValue(this.curBp)
          },
          color: { right: $r('sys.color.comp_divider') }
        })
        .backgroundColor($r('sys.color.background_secondary'))
        .height(new BreakpointType({ sm: '40%', md: '100%', lg: '100%' }).getValue(this.curBp))
      }

      GridCol({
        span: {
          sm: 4,
          md: 4,
          lg: 4
        }
      }) {
        Flex({ direction: FlexDirection.Column }) {
          Text($r('app.string.hot_comment'))
            .height($r('app.integer.text_hot_comment_height'))
            .width('100%')
            .padding({ left: $r('sys.float.padding_level8') })
          List() {
            LazyForEach(this.commentList, (comment: Comment) => {
              CommentView({ comment })
            }, (item: string) => item);
          }
          .cachedCount(2)
          .padding({
            left: $r('sys.float.padding_level8'),
            right: $r('sys.float.padding_level8')
          })
          .margin({ bottom: $r('sys.float.padding_level8') })
          .scrollBar(BarState.Off)
          .width('100%')
          .flexGrow(1)

          Row() {
            Column() {
              Text($r('app.string.text_input_hint'))
                .fontColor($r('sys.color.font_secondary'))
                .borderRadius($r('app.integer.text_input_hint_border_radius'))
                .height($r('app.integer.text_input_hint_height'))
                .width('100%')
                .padding({ left: $r('sys.float.padding_level8') })
                .backgroundColor($r('sys.color.comp_background_tertiary'))
                .onClick(() => {
                  if (this.dialogController !== null) {
                    this.dialogController.open();
                  }
                })
            }
            .padding({
              left: $r('sys.float.padding_level8'),
              right: $r('sys.float.padding_level8'),
              bottom: this.navigatorBarHeight
            })
          }
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .height(new BreakpointType({ sm: 96, md: 76, lg: 76 }).getValue(this.curBp))
          .width('100%')
          .border({
            width: { top: $r('app.integer.border_width') },
            color: { top: $r('sys.color.comp_divider') }
          })
          .padding({ top: $r('sys.float.padding_level2') })
        }
        .margin({ top: this.statusBarHeight })
      }
      .height(new BreakpointType({ sm: '60%', md: '100%', lg: '100%' }).getValue(this.curBp))
      .backgroundColor($r('sys.color.background_primary'))
    }
  }
}