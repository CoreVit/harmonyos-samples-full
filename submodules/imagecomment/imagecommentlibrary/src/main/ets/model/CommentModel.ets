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

export class Comment {
  public id: number = 0;
  public name: Resource | string = '';
  public avatar: ResourceStr = '';
  public time: string = '';
  public comment: Resource | string = '';
  public images: ResourceStr[] = [];

  constructor(name: Resource | string, comment: Resource | string, avatar: ResourceStr, images: ResourceStr[],
    time: string) {
    this.name = name;
    this.comment = comment;
    this.avatar = avatar;
    this.images = images;
    this.time = time;
  }
}

class BasicDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private originDataArray: Comment[] = [];

  public totalCount(): number {
    return 0;
  }

  public getData(index: number): Comment {
    return this.originDataArray[index];
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  // Notify the LazyForEach component that it needs to add a subcomponent to the index corresponding to the index
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  // Notify the LazyForEach component that the data in the index corresponding to the index has changed,
  // and the subcomponent needs to be rebuilt
  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }

  // Notify the LazyForEach component that the subcomponent needs to be deleted at the index corresponding to the index
  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }
}

export class CommentData extends BasicDataSource {
  private comments: Array<Comment> = [];

  totalCount(): number {
    return this.comments.length;
  }

  getData(index: number): Comment {
    if (index < 0 || index >= this.comments.length) {
      return new Comment('', '', '', [], '');
    }
    return this.comments[index];
  }

  pushData(data: Comment): void {
    this.comments.push(data);
    this.notifyDataAdd(this.comments.length - 1);
  }

  addDataFirst(data: Comment): void {
    this.comments.unshift(data);
    this.notifyDataAdd(0);
  }
}