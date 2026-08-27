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

import { DetailConstants } from '../constants/DetailConstants';

export class UserItemModel {
  private id: string = '0';
  private name: string;
  private imageSrc: Resource;
  private comment: ResourceStr;
  private commentImageSrc: Resource | undefined;
  private time: ResourceStr;

  constructor(id: string, name: string, imageSrc: Resource, comment: ResourceStr, commentImageSrc: Resource | undefined,
    time: ResourceStr) {
    this.id = id;
    this.name = name;
    this.imageSrc = imageSrc;
    this.comment = comment;
    this.commentImageSrc = commentImageSrc;
    this.time = time;
  }

  getId(): string {
    return this.id;
  }

  getName(): string {
    return this.name;
  }

  getImageSrc(): Resource {
    return this.imageSrc;
  }

  getComment(): ResourceStr {
    return this.comment;
  }

  getCommentImageSrc(): Resource | undefined {
    return this.commentImageSrc;
  }

  getTime(): ResourceStr {
    return this.time;
  }
}

export default class UserItemListModel {
  private userItemListModel: UserItemModel[] = [];

  constructor(userItemListModel: UserItemModel[]) {
    this.userItemListModel = userItemListModel;
  }

  loadUserItemData(dataType: string): void {
    this.clearUserItemList();
    if (dataType === DetailConstants.USER_INFO_LIST_TYPE) {
      this.userItemListModel.push(new UserItemModel('0', DetailConstants.USER_INFO_NAMES[0], $r('app.media.user_profile_1'),
        DetailConstants.USER_INFO_COMMENTS[0], undefined, DetailConstants.USER_INFO_DATE));
      this.userItemListModel.push(new UserItemModel('1', DetailConstants.USER_INFO_NAMES[1], $r('app.media.user_profile_2'),
        DetailConstants.USER_INFO_COMMENTS[1], $r('app.media.comment_2'), DetailConstants.USER_INFO_DATE));
      this.userItemListModel.push(new UserItemModel('2', DetailConstants.USER_INFO_NAMES[2], $r('app.media.user_profile_3'),
        DetailConstants.USER_INFO_COMMENTS[2], $r('app.media.comment_3'), DetailConstants.USER_INFO_DATE));
    } else if (dataType === DetailConstants.USER_SELF_INFO_TYPE) {
      this.userItemListModel.push(new UserItemModel('0', '', $r('app.media.user_profile_1'), '', undefined, ''));
    }
  }

  getUserItemListModel(): UserItemModel[] {
    return this.userItemListModel.slice();
  }

  clearUserItemList(): void {
    this.userItemListModel = [];
  }
}
