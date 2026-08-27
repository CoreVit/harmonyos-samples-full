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

import { SymbolGlyphModifier } from '@kit.ArkUI';

export class TabsBarModel {
  private static cachedTabBarStyleList?: BottomTabBarStyle[];

  public static getTabBarByPage(): BottomTabBarStyle[] {
    if (!TabsBarModel.cachedTabBarStyleList) {
      const tabBarStyleList: BottomTabBarStyle[] = []
      BAR_ITEMS.forEach((item: BarItem) => {
        const tabBarStyle = new BottomTabBarStyle({
          normal: new SymbolGlyphModifier(item.normalSymbolResource)
            .renderingStrategy(SymbolRenderingStrategy.SINGLE)
            .fontColor([item.normalColor]),
          selected: new SymbolGlyphModifier(item.selectedSymbolResource)
            .renderingStrategy(SymbolRenderingStrategy.SINGLE)
            .fontColor([item.selectedColor])
        }, item.label)
          .labelStyle({
            unselectedColor: item.normalColor,
            selectedColor: item.selectedColor,
          });
        tabBarStyleList.push(tabBarStyle);
      });
      TabsBarModel.cachedTabBarStyleList = tabBarStyleList;
    }
    return TabsBarModel.cachedTabBarStyleList;
  }
}

const BAR_ITEMS: BarItem[] = [
  {
    label: $r('app.string.tab_home'),
    normalColor: $r('sys.color.icon_primary'),
    normalSymbolResource: $r('sys.symbol.house_fill'),
    selectedColor: $r('sys.color.icon_emphasize'),
    selectedSymbolResource: $r('sys.symbol.house_fill'),
  },
  {
    label: $r('app.string.tab_video'),
    normalColor: $r('sys.color.icon_primary'),
    normalSymbolResource: $r('sys.symbol.play_hexagon_fill'),
    selectedColor: $r('sys.color.icon_emphasize'),
    selectedSymbolResource: $r('sys.symbol.play_hexagon_fill'),
  },
  {
    label: $r('app.string.tab_shopping'),
    normalColor: $r('sys.color.icon_primary'),
    normalSymbolResource: $r('sys.symbol.bag_fill_1'),
    selectedColor: $r('sys.color.icon_emphasize'),
    selectedSymbolResource: $r('sys.symbol.bag_fill_1'),
  },
  {
    label: $r('app.string.tab_mine'),
    normalColor: $r('sys.color.icon_primary'),
    normalSymbolResource: $r('sys.symbol.person_crop_circle_fill'),
    selectedColor: $r('sys.color.icon_emphasize'),
    selectedSymbolResource: $r('sys.symbol.person_crop_circle_fill'),
  },
]

export const SCROLLER_LIST: Scroller[] = new Array(4).fill(null).map(() => new Scroller());

interface BarItem {
  normalSymbolResource: Resource,
  selectedSymbolResource: Resource,
  label: ResourceStr,
  normalColor: ResourceColor;
  selectedColor: ResourceColor;
}