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

import { curves } from '@kit.ArkUI'
import CommonConstants from '../../common/CommonConstants';
import { ListDetailPageExtraInfo } from '../../utils/commonutils/ExtraInfo'
import { getResourceString } from '../../utils/commonutils/ResourceString';
import { BreakpointTypeEnum } from '../../utils/windowutils/BreakpointSystem';

@Builder
export function ListLongTakeTransitionPageOneBuilder() {
  ListLongTakeTransitionPageOne()
}

interface ListContent {
  title: string | Resource;
  content: Resource;
}

@Component
export default struct ListLongTakeTransitionPageOne {
  @StorageProp(CommonConstants.KEY_PREFIX_BREAKPOINT) currentBreakpoint: string = BreakpointTypeEnum.SM;
  private pageInfos: NavPathStack = new NavPathStack();
  @State transitionEffect: TransitionEffect = TransitionEffect.IDENTITY;
  private uiContext: UIContext = this.getUIContext();
  private listContent: ListContent[] =
    [
      { title: getResourceString($r('app.string.memorandum'), this) + 1, content: $r('app.string.DetailPage_text') },
      { title: getResourceString($r('app.string.memorandum'), this) + 2, content: $r('app.string.DetailPage_text') },
      { title: getResourceString($r('app.string.memorandum'), this) + 3, content: $r('app.string.DetailPage_text') },
      { title: getResourceString($r('app.string.memorandum'), this) + 4, content: $r('app.string.DetailPage_text') },
      { title: getResourceString($r('app.string.memorandum'), this) + 5, content: $r('app.string.DetailPage_text') },
      { title: getResourceString($r('app.string.memorandum'), this) + 6, content: $r('app.string.DetailPage_text') },
      { title: getResourceString($r('app.string.memorandum'), this) + 7, content: $r('app.string.DetailPage_text') },
      { title: getResourceString($r('app.string.memorandum'), this) + 8, content: $r('app.string.DetailPage_text') },
    ];

  private onButtonClicked(indexValue: string, title: string | Resource, content: Resource): void {
    this.transitionEffect = TransitionEffect.OPACITY
      .combine(TransitionEffect.scale({ x: 0.9, y: 0.9 }))
      .animation({ curve: curves.interpolatingSpring(0, 1, 195, 23) })

    let param = new ListDetailPageExtraInfo(indexValue, title, content);
    this.uiContext.animateTo({ curve: curves.interpolatingSpring(0, 1, 328, 36) }, () => {
      this.pageInfos.pushPath({ name: 'ListLongTakeTransitionPageTwo', param }, false);
    })
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Top }) {
        Row() {
          Button({ type: ButtonType.Circle }) {
            SymbolGlyph($r('sys.symbol.chevron_backward'))
              .fontColor([$r('sys.color.icon_primary')])
              .fontSize($r('sys.float.Title_M'))
          }
          .height(40)
          .aspectRatio(1)
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .onClick(() => this.pageInfos.pop())

          Text($r('app.string.list_title'))
            .margin({ left: $r('sys.float.padding_level4') })
            .font({ size: 20, weight: 700 })
            .fontColor($r('sys.color.font_primary'))
        }
        .padding({
          top: 40,
          left: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                                   $r('sys.float.padding_level12') :
                                                                                   $r('sys.float.padding_level16'),
          right: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                                    $r('sys.float.padding_level12') :
                                                                                    $r('sys.float.padding_level16')
        })
        .width('100%')
        .height(96)
        .zIndex(2)
        .backgroundBlurStyle(BlurStyle.COMPONENT_THICK)

        Scroll() {
          List({ space: 12 }) {
            ListItem().height(80)
            if (this.currentBreakpoint !== 'sm') {
              ListItem().height(80)
            }
            ForEach(this.listContent, (item: ListContent, index: number) => {
              ListItem() {
                MyButton({
                  listContent: item,
                  indexValue: index.toString(),
                  onButtonClicked: (indexValue: string) => {
                    this.onButtonClicked(indexValue, item.title, item.content);
                  }
                })
              }
            }, (name: string) => name)
          }
          .lanes(this.currentBreakpoint === 'sm' ? 1 : 2, 0)
          .height('100%')
          .width('100%')
          .alignListItem(ListItemAlign.Center)
          .padding({
            top: 16,
            left: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                                     22 : 26,
            right: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                                      22 : 26,
            bottom: 20
          })
          .scrollBar(BarState.Off)
        }
        .scrollBarWidth(0)
        .scrollBar(BarState.Off)
        .size({
          width: '100%',
          height: '100%'
        })
        .edgeEffect(EdgeEffect.Spring)
      }

    }
    .hideTitleBar(true)
    .transition(this.transitionEffect)
    .backgroundColor($r('sys.color.gray_01'))
    .title(getResourceString($r('app.string.list_title'), this))
    .onReady((context: NavDestinationContext) => {
      this.pageInfos = context.pathStack;
    })
    .onBackPressed(() => {
      this.transitionEffect = TransitionEffect.IDENTITY;
      this.pageInfos.pop(true);
      return true;
    })
  }
}

@Component
export struct MyButton {
  @Prop listContent: ListContent;
  @Prop indexValue: string;
  @State scaleValue: number = 1;
  public onButtonClicked: (index: string) => void = (_index: string) => {
  };
  private uiContext: UIContext = this.getUIContext();

  private onTouchProcess(event?: TouchEvent): void {
    if (!event) {
      return;
    }
    if (event.type === TouchType.Down) {
      this.uiContext.animateTo({ curve: curves.interpolatingSpring(0, 1, 350, 35) }, () => {
        this.scaleValue = 0.95;
      })
    } else if (event.type === TouchType.Up) {
      this.uiContext.animateTo({ curve: curves.interpolatingSpring(0, 1, 350, 35) }, () => {
        this.scaleValue = 1;
      })
    } else if (event.type === TouchType.Cancel) {
      this.uiContext.animateTo({ curve: curves.interpolatingSpring(0, 1, 350, 35) }, () => {
        this.scaleValue = 1;
      })
    }
  }

  build() {
    Column({ space: 10 }) {
      Row({ space: 5 }) {
        Line()
          .startPoint([0, 0])
          .endPoint([0, 20])
          .strokeWidth(5)
          .stroke(Color.Yellow)
          .strokeLineCap(LineCapStyle.Round)
        Text(this.listContent.title)
          .fontWeight(FontWeight.Medium)
          .fontSize(16)
      }

      Text(this.listContent.content)
        .fontColor($r('sys.color.font_primary'))
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .fontSize(14)
    }
    .alignItems(HorizontalAlign.Start)
    .padding({
      left: 20,
      right: 20,
      top: 20,
      bottom: 20
    })
    .width('97%')
    .backgroundColor($r('sys.color.comp_background_primary'))
    .clip(true)
    .borderRadius(20)
    .scale({
      x: this.scaleValue,
      y: this.scaleValue
    })
    .geometryTransition(this.indexValue, { follow: true })
    .onTouch((event?: TouchEvent) => {
      this.onTouchProcess(event);
    })
    .onClick(() => {
      this.onButtonClicked?.(this.indexValue);
    })
  }
}