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

import { CommentDataModel } from '../model/CommentDataModel';
import { ReplyDataModel } from '../model/ReplyDataModel';

export class CommentViewModel {
  private commentList: CommentDataModel[] = [];

  constructor() {
    let temp: ReplyDataModel[] = [];
    temp.push(new ReplyDataModel(1, $r('app.string.name_03'), $r('app.string.comment_reply')));
    this.commentList.push(
      new CommentDataModel(0, $r('app.media.ic_user_avatar'), $r('app.string.name_01'), $r('app.string.likes_01'),
        $r('app.string.content_01'), $r('app.string.date_01'), $r('app.string.location_01'), temp));
    this.commentList.push(
      new CommentDataModel(1, $r('app.media.ic_user01'), $r('app.string.name_02'), $r('app.string.likes_02'),
        $r('app.string.content_02'), $r('app.string.date_02'), $r('app.string.location_02'),));
    this.commentList.push(
      new CommentDataModel(2, $r('app.media.ic_user02'), $r('app.string.name_03'), $r('app.string.likes_03'),
        $r('app.string.content_03'), $r('app.string.date_03'), $r('app.string.location_03'),));
    this.commentList.push(
      new CommentDataModel(3, $r('app.media.ic_user03'), $r('app.string.name_04'), $r('app.string.likes_04'),
        $r('app.string.content_04'), $r('app.string.date_04'), $r('app.string.location_04'),));
    this.commentList.push(
      new CommentDataModel(4, $r('app.media.ic_user04'), $r('app.string.name_05'), $r('app.string.likes_05'),
        $r('app.string.content_05'), $r('app.string.date_05'), $r('app.string.location_05'),));
  }

  getCommentList(): CommentDataModel[] {
    return this.commentList;
  }
}