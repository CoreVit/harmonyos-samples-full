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

export class TabItem {
  public id: number;
  public name: string | Resource;

  constructor(id: number, name: string | Resource) {
    this.id = id;
    this.name = name;
  }
}

export class BottomTabModel {
  public id: number;
  public selectImage: Resource;
  public defaultImage: Resource;
  public middleMode: boolean;
  public title: string | Resource;
  public isSelected: boolean = false;

  constructor(id: number, selectImage: Resource, defaultImage: Resource, title: string | Resource, middleMode = false) {
    this.id = id;
    this.selectImage = selectImage;
    this.defaultImage = defaultImage;
    this.title = title;
    this.middleMode = middleMode;
  }
}

export class ClassifyModel {
  public classifyId: number;
  public classifyName: string | Resource;

  constructor(classifyId: number, classifyName: string | Resource) {
    this.classifyId = classifyId;
    this.classifyName = classifyName;
  }
}