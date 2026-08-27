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
import { IndexTabItemModel } from './IndexTabItemModel';

export function getDefaultTabItems(): IndexTabItemModel[] {
  return [
    new IndexTabItemModel($r('app.string.tab_home'), $r('sys.symbol.house'), $r('sys.symbol.house_fill')),
    new IndexTabItemModel(
      $r('app.string.tab_category'),
      $r('sys.symbol.square_grid_2x2'),
      $r('sys.symbol.square_fill_grid_2x2')
    ),
    new IndexTabItemModel($r('app.string.tab_discover'), $r('sys.symbol.fast'), $r('sys.symbol.fast_fill')),
    new IndexTabItemModel($r('app.string.tab_cart'),  $r('sys.symbol.bag'), $r('sys.symbol.bag_fill')),
    new IndexTabItemModel($r('app.string.tab_my'),  $r('sys.symbol.person'), $r('sys.symbol.person_fill')),
  ];
}

