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

import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { CommonConstants } from '../common/constants/CommonConstants';
import { ListExchangeCtrl } from '../viewmodel/ListExchangeCtrl';
import { ListInfo } from '../viewmodel/ListInfo';
import { WindowUtil } from '../utils/WindowUtil';

@Component
export struct ListExchangeComponent {
  @StorageProp(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  @StorageProp(CommonConstants.AS_KEY_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  @StorageProp(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageLink(CommonConstants.AS_KEY_IS_LONG_PRESS) isLongPress: boolean = false;
  @Provide appInfoList: ListInfo[] = CommonConstants.MEMO_DATA;
  @Provide currentData: ListInfo = new ListInfo();
  @State listExchangeCtrl: ListExchangeCtrl<ListInfo> =
    new ListExchangeCtrl<ListInfo>(this.appInfoList, this.getUIContext());

  @Builder
  DeleteBuilder(item: ListInfo) {
    Button() {
      SymbolGlyph($r('sys.symbol.trash_fill'))
        .fontSize($r('sys.float.padding_level10'))
        .fontColor([$r('sys.color.background_primary')])
    }
    .height(40)
    .aspectRatio(1)
    .backgroundColor($r('sys.color.warning'))
    .margin({ left: $r('sys.float.padding_level8') })
    .onClick(() => {
      this.listExchangeCtrl.deleteItem(item);
    })
  }

  aboutToDisappear(): void {
    WindowUtil.unregisterBreakPoint();
  }

  build() {
    Column() {
      Text($r('app.string.list_exchange_deduction_sort'))
        .fontWeight(FontWeight.Bold)
        .fontSize($r('sys.float.Title_L'))
        .textAlign(TextAlign.Start)
        .fontColor($r('sys.color.font_primary'))
        .alignSelf(ItemAlign.Start)
        .height(56)
        .margin({
          left: new BreakpointType({
            sm: $r('sys.float.padding_level8'),
            md: $r('sys.float.padding_level12'),
            lg: $r('sys.float.padding_level16')
          }).getValue(this.curBp),
          top: 56
        })

      Row() {
        if (this.curBp !== 'sm') {
          Row() {
            Text($r('app.string.list_exchange_custom_sort'))
              .fontColor($r('sys.color.font_primary'))
              .fontSize($r('sys.float.Subtitle_M'))
              .fontWeight(500)

            SymbolGlyph($r('sys.symbol.chevron_forward'))
              .fontSize($r('sys.float.padding_level12'))
              .fontColor([$r('sys.color.font_tertiary')])
          }
          .height($r('sys.float.padding_level24'))
          .borderRadius($r('sys.float.padding_level8'))
          .backgroundColor($r('sys.color.comp_background_primary'))
          .layoutWeight(this.curBp === 'sm' ? 1 : this.curBp === 'md' ? 1 : 2 / 3)
          .justifyContent(FlexAlign.SpaceBetween)
          .margin({
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
          .padding({
            left: $r('sys.float.padding_level8'),
            right: $r('sys.float.padding_level8')
          })
        }

        if (this.curBp !== 'sm') {
          Divider()
            .strokeWidth(0.5)
            .vertical(true)
            .margin({ top: -124 - this.statusBarHeight })
            .height('calc(100% + 112vp)')
            .color($r('sys.color.comp_divider'))
        }

        List() {
          ForEach(this.appInfoList, (item: ListInfo) => {
            ListItem() {
              DeductionView({ listItemInfo: item })
            }
            .zIndex(this.currentData === item ? CommonConstants.COMPONENT_LEVEL1 : CommonConstants.COMPONENT_LEVEL2)
            .swipeAction({ end: this.DeleteBuilder(item) })
            .transition(TransitionEffect.OPACITY)
            .attributeModifier(this.listExchangeCtrl.getModifier(item))
            .gesture(
              GestureGroup(GestureMode.Sequence,
                LongPressGesture()
                  .onAction((_: GestureEvent) => {
                    this.currentData = item;
                    this.isLongPress = true;
                    this.listExchangeCtrl.onLongPress(item);
                  }),
                PanGesture()
                  .onActionUpdate((event: GestureEvent) => {
                    this.listExchangeCtrl.onMove(item, event.offsetY);
                  })
                  .onActionEnd((_: GestureEvent) => {
                    this.listExchangeCtrl.onDrop(item);
                  })
              ).onCancel(() => {
                if (!this.isLongPress) {
                  return;
                }
                this.listExchangeCtrl.onDrop(item);
              })
            )
          }, (item: ListInfo, index: number) => index + JSON.stringify(item))
        }
        .divider({
          strokeWidth: 0.5,
          color: $r('sys.color.comp_divider')
        })
        .margin({
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
        .scrollBar(BarState.Off)
        .borderRadius($r('sys.float.corner_radius_level8'))
        .layoutWeight(1)
      }
      .height('100%')
      .width('100%')
      .alignItems(VerticalAlign.Top)
      .padding({
        top: $r('sys.float.padding_level6')
      })
    }
    .backgroundColor($r('sys.color.background_secondary'))
    .padding({
      top: this.statusBarHeight,
      bottom: this.navigatorBarHeight
    })
  }
}

/**
 * ListItem Custom Component
 */
@Component
struct DeductionView {
  @ObjectLink listItemInfo: ListInfo;
  @Consume appInfoList: ListInfo[];
  @Consume currentData: ListInfo;

  build() {
    Row() {
      Image(this.listItemInfo.icon)
        .width($r('sys.float.padding_level12'))
        .height($r('sys.float.padding_level12'))
        .draggable(false)
      Text(this.listItemInfo.name)
        .fontSize($r('sys.float.Body_M'))
        .margin({ left: $r('sys.float.padding_level8') })
      Blank()
    }
    .backgroundColor($r('sys.color.comp_background_primary'))
    .width('100%')
    .height($r('sys.float.padding_level24'))
    .padding({
      left: $r('sys.float.padding_level6'),
      right: $r('sys.float.padding_level6')
    })
  }
}