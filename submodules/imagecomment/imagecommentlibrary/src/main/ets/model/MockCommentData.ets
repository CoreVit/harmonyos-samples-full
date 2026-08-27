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

import { Comment, CommentData } from './CommentModel';

export function mockData(): CommentData {
  const commentList: CommentData = new CommentData();
  commentList.pushData(new Comment($r('app.string.name_one'), $r('app.string.comment_one'), $r('app.media.app_logo1'),
    [$r('app.media.landscape1')], '2024-02-07 13:25'));
  commentList.pushData(new Comment($r('app.string.name_two'), $r('app.string.comment_two'), $r('app.media.app_logo2'),
    [$r('app.media.landscape2'), $r('app.media.landscape3')], '2024-01-03 14:55'));
  return commentList;
}