/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { CommonConstants } from '../common/CommonConstants';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { TabItem } from '../viewmodel/TabItem';

@Builder
export function DrawerTabBuilder() {
  DrawerTab();
}

@Component
struct DrawerTab {
  @State navList: TabItem[] = [
    new TabItem(0, '0'),
    new TabItem(1, '1'),
    new TabItem(2, '2'),
    new TabItem(3, '3'),
    new TabItem(4, '4'),
    new TabItem(5, '5'),
  ];
  @State active: string = '0';
  @State show: boolean = false;
  @StorageLink(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  @StorageProp(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageProp(CommonConstants.AS_KEY_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  @Consume(CommonConstants.AS_KEY_PATH_STACK) pathStack: NavPathStack;

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.TopEnd }) {
        SideBarContainer(SideBarContainerType.Overlay) {
          Column() {
            List() {
              ForEach(this.navList, (item: TabItem, index: number) => {
                ListItem() {
                  Column() {
                    Row() {
                      Image(this.active === item.name.toString() ? $r('app.media.activeList') : $r('app.media.list'))
                        .width(24)
                        .height(24)
                      Text($r('app.string.list_name'))
                        .fontColor($r('sys.color.font_primary'))
                        .fontSize($r('sys.float.Subtitle_M'))
                        .fontWeight(FontWeight.Medium)
                        .margin({ left: $r('sys.float.padding_level8') })
                    }
                    .height(48)
                    .width('100%')

                    if (this.navList.length - 1 !== index) {
                      Row()
                        .height(0.5)
                        .backgroundColor('#0D000000')
                        .width('90%')
                    }
                  }
                  .onClick(() => {
                    this.active = item.name.toString();
                  })
                  .margin({
                    right: $r('sys.float.padding_level2'),
                    bottom: $r('sys.float.padding_level2')
                  })
                  .padding({ left: $r('sys.float.padding_level8') })
                  .justifyContent(FlexAlign.Start)
                  .width('100%')
                  .height(48)
                  .borderRadius($r('sys.float.corner_radius_level8'))
                  .backgroundColor(this.active === item.name.toString() ? $r('sys.color.comp_emphasize_tertiary') : undefined)
                }
              }, (item: TabItem) => JSON.stringify(item.id))
            }
            .height('auto')
            .width('100%')
            .layoutWeight(1)

            Blank()
            Row() {
              SymbolGlyph($r('sys.symbol.plus_circle_fill'))
                .fontSize($r('sys.float.Title_M'))
                .fontColor([$r('sys.color.icon_tertiary')])
              Text($r('app.string.add_list')).margin({ left: $r('sys.float.padding_level4') })
                .fontColor($r('sys.color.font_primary'))
            }
            .width('100%')
            .padding({
              top: $r('sys.float.padding_level6'),
              bottom: $r('sys.float.padding_level6')
            })
          }
          .width('100%')
          .height('100%')
          .padding({
            top: this.statusBarHeight + CommonConstants.IMAGE_SIZE + CommonConstants.PADDING_36,
            bottom: this.navigatorBarHeight,
            left: new BreakpointType({ sm: 16, md: 24, lg: 32 }).getValue(this.curBp),
            right: new BreakpointType({ sm: 16, md: 24, lg: 32 }).getValue(this.curBp)
          })
          .backgroundColor($r('sys.color.comp_background_primary'))

          Column() {
            Text($r('app.string.content'))
              .width('100%')
              .height('100%')
              .fontSize($r('sys.float.Title_L'))
              .textAlign(TextAlign.Center)
              .fontColor($r('sys.color.font_primary'))
          }
          .onClick(() => {
            this.getUIContext().animateTo({
              duration: CommonConstants.ANIMATION_DURATION,
              curve: Curve.EaseOut,
              playMode: PlayMode.Normal,
            }, () => {
              this.show = false;
            })
          })
          .width('100%')
          .height('110%')
          .backgroundColor($r('sys.color.background_secondary'))
        }
        .divider({ strokeWidth: 0.5, color: $r('sys.color.comp_divider') })
        .showSideBar(this.show)
        .onChange((value: boolean) => {
          this.show = value;
        })
        .sideBarWidth(new BreakpointType({ sm: '50%', md: '30%', lg: '20%' }).getValue(this.curBp))
        .minSideBarWidth(new BreakpointType({ sm: '50%', md: '30%', lg: '20%' }).getValue(this.curBp))
        .width('100%')
        .height('100%')
        .controlButton({
          top: this.statusBarHeight +
            new BreakpointType({ sm: 8, md: 14, lg: 20 }).getValue(this.curBp),
          left: new BreakpointType({ sm: 16, md: 24, lg: 32 }).getValue(this.curBp),
          icons: { shown: $r('sys.symbol.line_3_horizontal'), hidden: $r('sys.symbol.line_3_horizontal') },
          width: 24,
          height: 24
        })

        Button({ type: ButtonType.Circle }) {
          SymbolGlyph($r('sys.symbol.xmark'))
            .fontColor([$r('sys.color.icon_primary')])
            .fontSize($r('sys.float.Title_M'))
        }
        .height(CommonConstants.INDEX_TITLE_HEIGHT)
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .aspectRatio(1)
        .margin({
          top: this.statusBarHeight + CommonConstants.PADDING_TOP_SMALL,
          right: $r('sys.float.padding_level12')
        })
        .onClick(() => {
          this.pathStack.pop();
        })
      }
      .height('100%')
    }
    .hideTitleBar(true)
    .backgroundColor($r('sys.color.background_secondary'))
  }
}