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

import { ReplyDataModel } from './ReplyDataModel';

export class CommentDataModel {
  public id?: number;
  public pic?: PixelMap | ResourceStr | DrawableDescriptor;
  public name?: ResourceStr;
  public likes?: ResourceStr;
  public content?: ResourceStr;
  public date?: ResourceStr;
  public location?: ResourceStr;
  public replys?: ReplyDataModel[];

  constructor(id?: number, pic?: PixelMap | ResourceStr | DrawableDescriptor, name?: ResourceStr, likes?: ResourceStr,
    content?: ResourceStr, date?: ResourceStr,
    location?: ResourceStr, replys?: ReplyDataModel[]) {
    this.id = id;
    this.pic = pic;
    this.name = name;
    this.likes = likes;
    this.content = content;
    this.date = date;
    this.location = location;
    this.replys = replys;
  }
}

