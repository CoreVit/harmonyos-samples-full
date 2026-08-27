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

import { hdsMaterial } from '@kit.UIDesignKit';
import { HdsTabs } from '@hms.hds.hdsBaseComponent';
import { CommonConstants } from '../constants/CommonConstants';
import { MSVDataModel } from '../model/MSVDataModel';

@ComponentV2
struct MSVTabContent {
  @Local stackId: string = 'MSVTabContent';
  @BuilderParam content: BuilderCallback;

  build() {
    Stack() {
      this.content()
    }
    .id(this.stackId)
  }
}

@ComponentV2
export struct MSVTabs {
  @Require @Param data: MSVDataModel[];
  @Local activeIndex: number = 0;
  @Param useFloating: boolean = true;
  @Param index: number = 0;
  @Param showBarUnderline: boolean = false;
  @Param lightColor: ResourceColor = $r('sys.color.icon_on_secondary');
  @Param selectedLightColor: ResourceColor = $r('sys.color.icon_on_primary');
  @Param darkColor: ResourceColor = $r('sys.color.icon_primary');
  @Param selectedDarkColor: ResourceColor = $r('sys.color.icon_emphasize');
  @Param isDark: boolean = false;
  @Param tabBarSpace: Length = 16;
  @Param barBottomMargin: Length = 28;
  @Param barOverlap: boolean = true;
  @Param barPosition: BarPosition = BarPosition.Start;
  @Param barFontsize: number | string | Resource = $r('sys.float.Body_L');
  @Param onIndexChange: (index: number) => void = () => {
  };

  aboutToAppear(): void {
    this.activeIndex = this.index;
  }

  @Builder
  MSVTabContent(data: MSVDataModel[]) {
    ForEach(data, (tabItem: MSVDataModel, index: number) => {
      TabContent() {
        if (tabItem.content) {
          MSVTabContent({ content: tabItem.content })
        }
      }
      .tabBar(this.MSVTabBar(tabItem, index))
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    }, (tabItem: MSVDataModel) => JSON.stringify(tabItem.content))
  }

  @Builder
  MSVTabBar(params: MSVDataModel, currentIndex: number) {
    if (params.iconOnly) {
      Image(this.isDark ? params.iconDark : params.icon)
        .width(params.iconSize)
        .aspectRatio(1)

    } else {
      Column() {
        Column() {
          Text(params.text)
            .fontSize(this.barFontsize)
            .fontWeight($r('sys.float.font_weight_medium'))
            .fontColor(this.activeIndex === currentIndex ?
              (this.isDark ? this.selectedDarkColor : this.selectedLightColor) :
              (this.isDark ? this.darkColor : this.lightColor)
            )
        }
        .padding({
          top: 8,
          bottom: 8
        })
        .border({
          width: { bottom: this.showBarUnderline && (this.activeIndex === currentIndex) ? 1 : 0 },
          color: this.isDark ? this.selectedDarkColor : this.selectedLightColor
        })
      }
      .height(CommonConstants.FULL_PERCENT)
      .justifyContent(FlexAlign.Center)
      .margin({
        left: Number(this.tabBarSpace) / 2, right: Number(this.tabBarSpace) / 2
      })
    }
  }

  build() {
    if (canIUse('SystemCapability.UIDesign.HDSComponent.Core') && this.useFloating) {
      HdsTabs({ index: this.activeIndex }) {
        this.MSVTabContent(this.data)
      }
      .barPosition(BarPosition.End)
      .barOverlap(this.barOverlap)
      .barFloatingStyle({
        barSideMargin: 16,
        barBottomMargin: this.barBottomMargin,
        systemMaterialEffect: {
          materialType: hdsMaterial.MaterialType.IMMERSIVE,
          materialLevel: hdsMaterial.MaterialLevel.ADAPTIVE
        }
      })
      .barHeight(44)
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      .onChange((index: number) => {
        this.activeIndex = index;
        this.onIndexChange(index);
      })
    } else {
      Tabs({ index: this.activeIndex }) {
        this.MSVTabContent(this.data)
      }
      .barPosition(this.barPosition)
      .barOverlap(this.barOverlap)
      .barBackgroundBlurStyle(BlurStyle.NONE)
      .barHeight(56)
      .barMode(BarMode.Scrollable, { margin: 8 })
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      .onChange((index: number) => {
        this.activeIndex = index;
        this.onIndexChange(index);
      })
    }
  }
}

