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

import { BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { CommonConstants } from '../common/constants/CommonConstants';
import { Comment } from '../model/CommentModel';
import { CommentImageListView } from './CommentImageListView';

@Component
export struct CommentView {
  @StorageLink(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  @Prop comment: Comment = new Comment('', '', '', [], '');

  build() {
    Column() {
      Row() {
        Image(this.comment.avatar)
          .width($r('app.integer.image_avatar_width'))
          .height($r('app.integer.image_avatar_height'))
          .borderRadius($r('app.integer.logo_border_radius'))
        Column() {
          Text(this.comment.name)
            .fontSize($r('sys.float.Body_L'))
            .width('100%')
            .margin({ top: $r('sys.float.padding_level4') })
          Text(this.comment.comment)
            .width('100%')
            .fontSize($r('sys.float.Body_L'))
            .margin({ top: $r('sys.float.padding_level4') })
          if (this.comment.images.length > 0) {
            CommentImageListView({ selectedImages: this.comment.images })
          }
          Text(this.comment.time)
            .width('100%')
            .fontSize($r('sys.float.Caption_L'))
            .margin({ top: $r('sys.float.Caption_M') })
        }
        .margin({ left: $r('sys.float.padding_level6') })
      }
      .alignItems(VerticalAlign.Top)
    }
    .margin({ top: $r('sys.float.padding_level8') })
    .width('100%')
  }
}