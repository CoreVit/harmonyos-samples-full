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

@Component
export struct CommentImageListView {
  @State selectedImages: ResourceStr[] = [];

  build() {
    List({ space: 8 }) {
      ForEach(this.selectedImages, (image: string, index: number) => {
        ListItem() {
          Image(image)
            .width($r('app.integer.image_comment_image_width'))
            .height($r('app.integer.image_comment_image_height'))
            .objectFit(ImageFit.Cover)
            .borderRadius($r('app.integer.border_radius'))
        }
      }, (image: string, index: number) => JSON.stringify(index))
    }
    .margin({ top: $r('sys.float.padding_level4') })
    .scrollBar(BarState.Off)
    .width('85%')
    .listDirection(Axis.Horizontal)
    .alignSelf(ItemAlign.Start)
  }
}