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

import { EditableLeftIconType, EditableTitleBar } from '@kit.ArkUI';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { CommonConstants } from '../common/constants/CommonConstants';
import { ListDataConstants } from '../common/constants/ListDataConstants';
import MenuItemComponent from '../view/MenuItemComponent';
import { WaterFlowDataSource } from '../model/WaterFlowDataSource';

@Component
export struct GridNextSwiperIndex {
  @StorageLink(CommonConstants.AS_KEY_BREAK_POINT) @Watch('updateCrossCount') curBp: string = BreakpointTypeEnum.SM;
  @Consume(CommonConstants.AS_KEY_PATH_STACK) pathStack: NavPathStack;
  private swiperController: SwiperController = new SwiperController();
  private waterFlowDataSource: WaterFlowDataSource = new WaterFlowDataSource();
  @State sections: WaterFlowSections = new WaterFlowSections();
  twoColumnSection: SectionOptions = {
    itemsCount: 12,
    crossCount: new BreakpointType({
      sm: 3,
      md: 4,
      lg: 4
    }).getValue(this.curBp),
    onGetItemMainSizeByIndex: () => {
      return CommonConstants.WATER_FLOW_ITEM_HEIGHT;
    }
  };

  private updateCrossCount(): void {
    this.twoColumnSection.crossCount = new BreakpointType({
      sm: 3,
      md: 4,
      lg: 4
    }).getValue(this.curBp);
    this.sections.update(0, this.twoColumnSection);
  }

  aboutToAppear(): void {
    this.waterFlowDataSource.setDataArray(ListDataConstants.WATER_FLOW_DATA);
    this.sections.push(this.twoColumnSection);
  }

  @Builder
  imageProperty(item: Resource): void {
    Image(item)
      .height(CommonConstants.FULL_PERCENT)
      .width(CommonConstants.FULL_PERCENT)
      .borderRadius($r('sys.float.corner_radius_level6'))
  }

  build() {
    NavDestination() {
      Column() {
        EditableTitleBar({
          leftIconStyle: EditableLeftIconType.Back,
          title: $r('app.string.grid_nest_swiper'),
          isSaveIconRequired: false,
          onCancel: () => {
            this.pathStack.pop();
          }
        })
          .padding({
            right: new BreakpointType({
              sm: $r('sys.float.padding_level0'),
              md: $r('sys.float.padding_level2'),
              lg: $r('sys.float.padding_level4')
            }).getValue(this.curBp),
            left: new BreakpointType({
              sm: $r('sys.float.padding_level0'),
              md: $r('sys.float.padding_level2'),
              lg: $r('sys.float.padding_level4')
            }).getValue(this.curBp)
          })
        Swiper(this.swiperController) {
          ForEach(ListDataConstants.GRID_ICON_LIST,
            (item: string[], index) => {
              MenuItemComponent({
                nameList: item,
                imageList: (index >= 0 && index < ListDataConstants.SWIPER_IMAGE_LIST.length) ?
                  ListDataConstants.SWIPER_IMAGE_LIST[index] :
                  ListDataConstants.SWIPER_IMAGE_LIST[index % ListDataConstants.SWIPER_IMAGE_LIST.length]
              })
            }, (item: string[], index: number) => item[index].toString())
        }
        .indicator(false)
        .disableSwipe(true)
        .loop(true)
        .onGestureSwipe((index: number) => {
          this.getUIContext().animateTo({
            duration: CommonConstants.SWIPER_DURATION,
            curve: Curve.Smooth,
            playMode: PlayMode.Normal,
            onFinish: () => {
            }
          }, () => {
          });
        })
        .onAnimationStart((_: number, targetIndex: number) => {
          this.getUIContext().animateTo({
            duration: CommonConstants.SWIPER_DURATION,
            curve: Curve.Smooth,
            playMode: PlayMode.Normal,
            onFinish: () => {
            }
          }, () => {
          });
        })
        .backgroundColor($r('sys.color.comp_background_primary'))
        .borderRadius($r('sys.float.corner_radius_level6'))
        .height(new BreakpointType({
          sm: CommonConstants.SWIPER_HEIGHT_SM_SIZE,
          md: CommonConstants.SWIPER_HEIGHT_MD_SIZE,
          lg: CommonConstants.SWIPER_HEIGHT_LG_SIZE
        }).getValue(this.curBp))
        .margin({
          top: $r('sys.float.padding_level4'),
          left: new BreakpointType({
            sm: $r('sys.float.padding_level8'),
            md: $r('sys.float.padding_level12'),
            lg: $r('sys.float.padding_level16')
          }).getValue(this.curBp),
          right: new BreakpointType({
            sm: $r('sys.float.padding_level8'),
            md: $r('sys.float.padding_level12'),
            lg: $r('sys.float.padding_level16')
          }).getValue(this.curBp)
        })

        WaterFlow({ sections: this.sections }) {
          LazyForEach(this.waterFlowDataSource, (item: Resource) => {
            FlowItem() {
              this.imageProperty(item)
            }
          }, (item: Resource) => item.id.toString())
        }
        .cachedCount(2)
        .padding({ left: $r('sys.float.padding_level8'), right: $r('sys.float.padding_level8') })
        .margin({ top: $r('sys.float.padding_level8') })
        .layoutWeight(CommonConstants.WATER_FLOW_LAYOUT_WEIGHT)
        .rowsGap($r('sys.float.padding_level8'))
        .columnsGap($r('app.float.water_flow_gap_size'))
        .padding({
          left: new BreakpointType({
            sm: $r('sys.float.padding_level8'),
            md: $r('sys.float.padding_level12'),
            lg: $r('sys.float.padding_level16')
          }).getValue(this.curBp),
          right: new BreakpointType({
            sm: $r('sys.float.padding_level8'),
            md: $r('sys.float.padding_level12'),
            lg: $r('sys.float.padding_level16')
          }).getValue(this.curBp),
        })
      }
      .height(CommonConstants.FULL_PERCENT)
      .backgroundColor($r('sys.color.background_secondary'))
    }
    .hideTitleBar(true)
  }
}

