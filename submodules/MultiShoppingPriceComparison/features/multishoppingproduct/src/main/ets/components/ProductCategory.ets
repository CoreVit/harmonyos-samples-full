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
import { ProductCategoryState } from '../viewmodel/ProductCategoryState';

@ComponentV2
export struct ProductCategory {
  private context: Context = this.getUIContext().getHostContext()!;
  @Env(SystemProperties.BREAK_POINT) private breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;
  @Local private state: ProductCategoryState = new ProductCategoryState(this.context);

  build() {
    List() {
      ForEach(this.state.navList, (item: string, index: number) => {
        ListItem() {
          Stack({ alignContent: Alignment.Start }) {
            Row() {
              Text(item)
                .fontSize(14)
                .lineHeight(19)
                .fontWeight(FontWeight.Normal)
                .fontColor(this.state.currentIndex === index ? '#CF0A2C' : $r('app.color.text_tertiary'))
            }
            .width('100%')
            .height('100%')
            .justifyContent(FlexAlign.Start)
            .padding({
              left: (this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_XS ||
                this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM) ? 16 :
                (this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_MD ? 24 : 32)
            })
            .onClick(() => {
              this.state.select(index);
            })

            Divider()
              .vertical(true)
              .strokeWidth('2vp')
              .height(19)
              .color('#CF0A2C')
              .visibility(index === this.state.currentIndex ? Visibility.Visible : Visibility.None)
          }
          .width('100%')
          .height(48)
          .margin({
            bottom: index === this.state.navList.length - 1 ? 70 : 0
          })
        }
      }, (item: string, index: number) => `${item}${index}`)
    }
    .scrollBar(BarState.Off)
    .width('100%')
    .height('100%')
  }
}
