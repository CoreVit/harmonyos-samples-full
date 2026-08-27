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
import { uiObserver } from '@kit.ArkUI';
import { MobilePhoneItem, MobilePhoneSection } from '../model/MobilePhoneListModel';
import { MobilePhoneListState } from '../viewmodel/MobilePhoneListState';
import { WidthBreakpointType } from 'multishoppingbase';

@ComponentV2
export struct MobilePhoneList {
  private context: Context = this.getUIContext().getHostContext()!;
  @Env(SystemProperties.BREAK_POINT) private breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;
  @Local private state: MobilePhoneListState = new MobilePhoneListState(this.context);
  @Consumer('mainPageMap') private mainPageMap: NavPathStack = new NavPathStack();

  build() {
    List() {
      ForEach(this.state.sections, (section: MobilePhoneSection, sectionIndex: number) => {
        ListItem() {
          Column() {
            Row() {
              Text(section.name)
                .font({ size: 16, weight: FontWeight.Medium })
                .textAlign(TextAlign.Start)
            }
            .height(48)
            .width('100%')

            GridRow({
              columns: new WidthBreakpointType(3, 6, 8, 8).getValue(this.breakpoint.widthBreakpoint),
              gutter: {
                x: 24,
                y: new WidthBreakpointType(8, 8, 16, 12).getValue(this.breakpoint.widthBreakpoint)
              }
            }) {
              ForEach(section.items, (item: MobilePhoneItem, itemIndex: number) => {
                GridCol({ span: 1 }) {
                  Column() {
                    Image(item.image)
                      .width('100%')
                      .aspectRatio(1)
                    Text(item.name)
                      .fontSize(12)
                      .fontWeight(FontWeight.Normal)
                      .maxLines(2)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                  }
                }
              }, (item: MobilePhoneItem, itemIndex: number) => `${item.name}-${itemIndex}`)
            }
            .padding({
              left: (this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_XS ||
                this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM) ? 12 : 0,
              right: (this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_XS ||
                this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM) ? 12 : 0
            })
          }
          .backgroundColor($r('app.color.surface_primary'))
          .border({ radius: 12 })
          .width('100%')
          .padding({
            left: (this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_LG ||
              this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_XL) ? 16 : 12,
            right: (this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_LG ||
              this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_XL) ? 16 : 12,
            bottom: 12
          })
          .margin({
            top: (this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_LG ||
              this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_XL) ? 16 : 12
          })
        }
        .onClick(()=>{
          this.mainPageMap.pushPath({name:'ProductDetail'})
        })
      }, (section: MobilePhoneSection, sectionIndex: number) => `${section.name}-${sectionIndex}`)
    }
    .padding({
      right: (this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_XS ||
        this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM) ? 16 :
        (this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_MD ? 24 : 32)
    })
    .margin({ bottom: 12 })
  }
}
