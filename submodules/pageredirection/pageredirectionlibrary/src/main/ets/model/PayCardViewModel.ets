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

export class PayCardViewModel {
  private payCardSelectList: SelectProjectItem[] = [];

  constructor() {
    let selectItems1: SelectItem[] = [];
    selectItems1.push(new SelectItem('1', $r('app.media.pay_product_1')))
    selectItems1.push(new SelectItem('2', $r('app.media.pay_product_2')))
    selectItems1.push(new SelectItem('3', $r('app.media.pay_product_3')))
    this.payCardSelectList.push(new SelectProjectItem($r('app.string.SELECT_NAME_LIST1'), selectItems1));

    let selectItems2: SelectItem[] = [];
    selectItems2.push(new SelectItem('1', null))
    selectItems2.push(new SelectItem('2', null))
    this.payCardSelectList.push(new SelectProjectItem($r('app.string.SELECT_NAME_LIST2'), selectItems2));

    let selectItems3: SelectItem[] = [];
    selectItems3.push(new SelectItem('1', null))
    this.payCardSelectList.push(new SelectProjectItem($r('app.string.SELECT_NAME_LIST3'), selectItems3));
  }

  getPayCardSelectList(): SelectProjectItem[] {
    return this.payCardSelectList;
  }
}

export class SelectProjectItem {
  private name: Resource;
  private selectItemList: SelectItem[];

  constructor(name: Resource, selectItemList: SelectItem[]) {
    this.name = name;
    this.selectItemList = selectItemList;
  }

  getName(): Resource {
    return this.name;
  }

  getSelectItemList(): SelectItem[] {
    return this.selectItemList;
  }
}

export class SelectItem {
  private name: string;
  private image: Resource | null;

  constructor(name: string, image: Resource | null) {
    this.name = name;
    this.image = image;
  }

  getName(): string {
    return this.name;
  }

  getImage(): Resource | null {
    return this.image;
  }
}