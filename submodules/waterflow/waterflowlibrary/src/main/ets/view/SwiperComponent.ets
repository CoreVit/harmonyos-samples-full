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
import { swiperImage } from '../model/HomeViewModel';

@Component
export default struct SwiperComponent {
  @StorageProp(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;

  build() {
    Swiper() {
      ForEach(swiperImage, (item: Resource) => {
        Image(item)
          .objectFit(ImageFit.Cover)
          .width(CommonConstants.FULL_WIDTH)
          .borderRadius($r('app.float.swiper_radius'))
          .backgroundColor(Color.White)
      }, (item: Resource) => JSON.stringify(item))
    }
    .indicator(false)
    .autoPlay(true)
    .itemSpace(new BreakpointType({ sm: 8, md: 16, lg: 24 }).getValue(this.curBp))
    .width(CommonConstants.FULL_WIDTH)
    .displayCount(new BreakpointType({ sm: 1, md: 2, lg: 2 }).getValue(this.curBp))
    .nextMargin(new BreakpointType({ sm: 0, md: 40, lg: 80 }).getValue(this.curBp))
    .prevMargin(new BreakpointType({ sm: 0, md: 40, lg: 80 }).getValue(this.curBp))
    .padding({
      left: new BreakpointType({ sm: 16, md: 0, lg: 0 }).getValue(this.curBp),
      right: new BreakpointType({ sm: 16, md: 0, lg: 0 }).getValue(this.curBp)
    })
  }
}