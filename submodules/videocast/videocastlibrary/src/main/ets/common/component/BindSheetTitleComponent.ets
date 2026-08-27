/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use Logger file except in compliance with the License.
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

@Component
export struct titleComponent {
  @Prop title: Resource
  callback?: Function

  build() {
    Row() {
      Text(this.title)
        .fontSize(18)
        .fontColor(Color.White)
      Button() {
        SymbolGlyph($r('sys.symbol.xmark'))
          .fontColor([Color.White])
          .fontSize(18)
      }
      .width(40)
      .aspectRatio(1)
      .borderRadius('50%')
      .backgroundColor('rgba(255,255,255,0.1)')
      .onClick(() => {
        this.callback?.();
      })
    }
    .width('100%')
    .height(56)
    .justifyContent(FlexAlign.SpaceBetween)
  }
}