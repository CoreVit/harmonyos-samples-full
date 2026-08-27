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

import { AdaptiveVideo } from 'multishortvideoadaptivevideo';
import { CommonConstants, MSVEmptyComponent } from 'multishortvideobase';
import { Individual } from 'multishortvideoindividual';


@Builder
export function friends() {
  NavDestination() {
    MSVEmptyComponent()
  }
  .width(CommonConstants.FULL_PERCENT)
  .height(CommonConstants.FULL_PERCENT)
  .title($r('app.string.friend_title'))
}

@Builder
export function add() {
  NavDestination() {
    MSVEmptyComponent()
  }
  .width(CommonConstants.FULL_PERCENT)
  .height(CommonConstants.FULL_PERCENT)
  .title($r('app.string.add_title'))
}

@Builder
export function message() {
  NavDestination() {
    MSVEmptyComponent()
  }
  .width(CommonConstants.FULL_PERCENT)
  .height(CommonConstants.FULL_PERCENT)
  .title($r('app.string.message_title'))
}


@Builder
export function mine() {
  Column() {
    Individual()
  }
  .width(CommonConstants.FULL_PERCENT)
  .height(CommonConstants.FULL_PERCENT)
  .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
}

@Builder
export function recommend() {
  Column() {
    AdaptiveVideo()
  }
  .width(CommonConstants.FULL_PERCENT)
  .height(CommonConstants.FULL_PERCENT)
  .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  .backgroundColor(Color.Black)
}


@Builder
export function follow() {
  NavDestination() {
    MSVEmptyComponent()
  }
  .width(CommonConstants.FULL_PERCENT)
  .height(CommonConstants.FULL_PERCENT)
  .title($r('app.string.follow'))
}

