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

import { BottomTabModel, ClassifyModel, TabItem } from './TabItem';

export function initTabData(): TabItem[] {
  let tabDataArray: TabItem[] = [];
  tabItemData.forEach((item: TabItem) => {
    tabDataArray.push(new TabItem(item.id, item.name));
  })
  return tabDataArray;
}

export function initTabDataNew(): TabItem[] {
  let tabDataArray: TabItem[] = [];
  tabItemDataNew.forEach((item: TabItem) => {
    tabDataArray.push(new TabItem(item.id, item.name));
  })
  return tabDataArray;
}

export function initDoubleTabData(): TabItem[] {
  let tabDataArray: TabItem[] = [];
  doubleTabItemData.forEach((item: TabItem) => {
    tabDataArray.push(new TabItem(item.id, item.name));
  })
  return tabDataArray;
}

export function initTabTuData(): BottomTabModel[] {
  let tabTuDataArray: BottomTabModel[] = [];
  tabTuItemData.forEach((item: BottomTabModel) => {
    tabTuDataArray.push(new BottomTabModel(item.id, item.defaultImage, item.selectImage, item.title, item.middleMode));
  })
  return tabTuDataArray;
}

export function initSideData(): ClassifyModel[] {
  let tabDataArray: ClassifyModel[] = [];
  classifyData.forEach((item: ClassifyModel) => {
    tabDataArray.push(new ClassifyModel(item.classifyId, item.classifyName));
  })
  return tabDataArray;
}

const tabItemDataNew: TabItem[] = [
  new TabItem(0, $r('app.string.tab1')),
  new TabItem(1, $r('app.string.tab2')),
  new TabItem(2, $r('app.string.tab3')),
  new TabItem(3, $r('app.string.tab4')),
];

const doubleTabItemData: TabItem[] = [
  new TabItem(0, $r('app.string.sub1')),
  new TabItem(1, $r('app.string.sub2')),
  new TabItem(2, $r('app.string.sub3')),
  new TabItem(3, $r('app.string.sub4')),
  new TabItem(4, $r('app.string.sub5')),
  new TabItem(5, $r('app.string.sub6')),
  new TabItem(6, $r('app.string.sub7')),
  new TabItem(7, $r('app.string.sub8')),
  new TabItem(8, $r('app.string.sub9'))
];

const tabItemData: TabItem[] = [
  new TabItem(0, $r('app.string.follow')),
  new TabItem(1, $r('app.string.recommended')),
  new TabItem(2, $r('app.string.book')),
  new TabItem(3, $r('app.string.novel')),
  new TabItem(4, $r('app.string.caricature')),
  new TabItem(5, $r('app.string.listen_book')),
  new TabItem(6, $r('app.string.making_friends')),
  new TabItem(7, $r('app.string.live_broadcast')),
  new TabItem(8, $r('app.string.video'))
];

const tabTuItemData: BottomTabModel[] = [
  new BottomTabModel(0, $r('sys.symbol.house'), $r('sys.symbol.house'), $r('app.string.tab_homepage')),
  new BottomTabModel(1, $r('sys.symbol.star'), $r('sys.symbol.star'), $r('app.string.activity')),
  new BottomTabModel(2, $r('sys.symbol.plus_circle_fill'), $r('sys.symbol.plus_circle_fill'), '', true),
  new BottomTabModel(3, $r('sys.symbol.dot_2_message'), $r('sys.symbol.dot_2_message'), $r('app.string.message')),
  new BottomTabModel(4, $r('sys.symbol.person'), $r('sys.symbol.person'), $r('app.string.tab_mine'))
];

const classifyData: ClassifyModel[] = [
  new ClassifyModel(0, $r('app.string.popular_course')),
  new ClassifyModel(1, $r('app.string.latest_courses')),
  new ClassifyModel(2, 'HarmonyOS',),
  new ClassifyModel(3, $r('app.string.wonderful_activity')),
  new ClassifyModel(4, $r('app.string.developer_said')),
  new ClassifyModel(5, $r('app.string.back_end_development')),
  new ClassifyModel(6, $r('app.string.front_end_development'))
];