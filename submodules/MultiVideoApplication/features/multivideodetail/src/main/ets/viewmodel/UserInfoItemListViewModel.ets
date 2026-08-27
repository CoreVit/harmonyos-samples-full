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
import UserItemListModel, { UserItemModel } from '../model/UserItemModel';

@Observed
export class UserInfoItemViewModel {
  @Track private id: string = '0';
  @Track private name: string = '';
  @Track private imageSrc: ResourceStr = '';
  @Track private comment: ResourceStr = '';
  @Track private commentImageSrc: Resource | undefined = undefined;
  @Track private time: ResourceStr = '';

  updateItem(userItemModel: UserItemModel): void {
    this.id = userItemModel.getId();
    this.name = userItemModel.getName();
    this.imageSrc = userItemModel.getImageSrc();
    this.comment = userItemModel.getComment();
    this.commentImageSrc = userItemModel.getCommentImageSrc();
    this.time = userItemModel.getTime();
  }

  getId(): string {
    return this.id;
  }

  getName(): string {
    return this.name;
  }

  getImageSrc(): ResourceStr {
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

@Observed
export class UserInfoItemArray extends Array<UserInfoItemViewModel> {
}

@Observed
export default class UserInfoItemListViewModel {
  @Track private items: UserInfoItemArray = new UserInfoItemArray();

  loadUserInfoListData(): void {
    this.clearUserInfoListData();
    let userInfoList = new UserItemListModel([]);
    userInfoList.loadUserItemData(DetailConstants.USER_INFO_LIST_TYPE);
    for (let item of userInfoList.getUserItemListModel()) {
      let userInfoItemViewModel = new UserInfoItemViewModel();
      userInfoItemViewModel.updateItem(item);
      this.items.push(userInfoItemViewModel);
    }
  }

  getItems(): UserInfoItemArray {
    return this.items.slice();
  }

  clearUserInfoListData(): void {
    this.items = new UserInfoItemArray();
  }
}
