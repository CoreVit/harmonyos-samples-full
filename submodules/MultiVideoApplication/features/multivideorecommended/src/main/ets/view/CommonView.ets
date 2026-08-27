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

import { BreakpointType, WindowInfo } from 'multivideobase';
import { MainPageConstants } from '../constants/MainPageConstants';

@Builder
export function VideoImgRating(rating: string, isOnTv: boolean = false) {
  Row() {
    Text(rating)
      .fontSize('7fp')
      .fontWeight(FontWeight.Normal)
      .fontColor($r('app.color.mp_white'))
      .height('12vp')
      .width('20vp')
      .margin({
        right: '8vp',
        bottom: '8vp'
      })
      .backgroundColor($r('app.color.mp_badge_overlay_background'))
      .borderRadius(2)
      .textAlign(TextAlign.Center)
  }
  .justifyContent(FlexAlign.End)
  .width('100%')
  .visibility(rating === '' || isOnTv ? Visibility.None : Visibility.Visible)
}

@Component
export struct VideoTitle {
  @Consume('inOnTv') isOnTv: boolean;
  @Consume('currentTopIndex') currentTopIndex: number = 0;
  public title: ResourceStr = '';

  build() {
    Text(this.title)
      .fontWeight(FontWeight.Normal)
      .fontSize(this.isOnTv ? '18fp' : '14fp')
      .lineHeight(this.isOnTv ? '24vp' : '21vp')
      .margin({ top: '4vp' })
      .fontColor(this.isOnTv || this.currentTopIndex === 2 ? $r('app.color.mp_text_title_on_immersive') :
        $r('app.color.mp_text_title'))
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .maxLines(1)
      .opacity(this.isOnTv ? 0.9: 1)
  }
}

@Component
export struct VideoContent {
  @Consume('inOnTv') isOnTv: boolean;
  @Consume('currentTopIndex') currentTopIndex: number = 0;
  public content: ResourceStr = '';

  build() {
    Text(this.content)
      .fontSize(this.isOnTv ? '16fp' : '12fp')
      .lineHeight(this.isOnTv ? '21vp' : '18vp')
      .opacity(this.isOnTv ? 0.6: 1)
      .fontWeight(FontWeight.Normal)
      .maxLines(1)
      .margin({ top: '2vp' })
      .fontColor(this.isOnTv ? $r('app.color.mp_text_primary') :
        this.currentTopIndex === 2 ? $r('app.color.mp_text_body_on_immersive') : $r('app.color.mp_text_body'))
      .textOverflow({ overflow: TextOverflow.Ellipsis })
  }
}

@Component
export struct SubtitleComponent {
  @Consume('inOnTv') isOnTv: boolean;
  @ObjectLink mainWindowInfo: WindowInfo;
  @Consume('currentTopIndex') currentTopIndex: number = 0;
  public title: ResourceStr = '';

  build() {
    Text(this.title)
      .fontSize(this.isOnTv ? '26fp' : '16fp')
      .fontWeight(this.isOnTv ? 700 : 500)
      .fontColor(this.isOnTv || this.currentTopIndex === 2 ? $r('app.color.mp_text_title_on_immersive') :
        $r('app.color.mp_text_primary'))
      .lineHeight(this.isOnTv ? '35vp' : '22vp')
      .width('100%')
      .padding({
        left: new BreakpointType('16vp', '16vp', '24vp', '36vp', '36vp').getValue(this.mainWindowInfo.widthBp),
        right: new BreakpointType('16vp', '16vp', '24vp', '36vp', '36vp').getValue(this.mainWindowInfo.widthBp)
      })
      .opacity(this.isOnTv ? 0.9 : 1)
  }
}

@Builder
export function VideoImgComponent(imgSrc: ResourceStr = '', index: number = 0) {
  Image(imgSrc)
    .focusable(true)
    .groupDefaultFocus(index === 0 ? true : false)
    .objectFit(ImageFit.Cover)
    .width('100%')
    .height('100%')
    .draggable(false)
    .borderRadius(12)
}

@Component
export struct VideoImgPlay {
  @ObjectLink mainWindowInfo: WindowInfo;

  build() {
    Column() {
      Image($r('app.media.new_video_play'))
        .height(this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '32vp' : '24vp')
        .width(this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '32vp' : '24vp')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}

@Builder
export function MembershipTag(tagText: ResourceStr = 'SVIP') {
  Stack() {
    Image($r('app.media.newMarkGray'))
      .width('45vp')
      .height('20vp')
    Text(tagText)
      .fontColor($r('app.color.mp_white'))
      .fontSize('12vp')
  }
  .margin({
    top: '5vp',
    right: '7vp'
  })
}

/**
 * Returns tab index for focus navigation based on direction name.
 */
export function getTabIndex(direction: string): number {
  const index = MainPageConstants.DIRECTION_LIST.indexOf(direction);
  return index >= 0 ? index + 1 : 0;
}