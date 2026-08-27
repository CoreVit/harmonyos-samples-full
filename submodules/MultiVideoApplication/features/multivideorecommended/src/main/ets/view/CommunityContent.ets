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

import { BreakpointType, CommonConstants, DeviceApiVersionUtil, WindowInfo, WindowUtil } from 'multivideobase';
import { BannerView } from './BannerView';
import { IconView } from './IconView';
import { PopularVideo } from './PopularVideo';
import { NewVideoRelease } from './NewVideoRelease';
import { DailyVideo } from './DailyVideo';
import { PreviousVideo } from './PreviousVideo';
import NewVideoReleaseCoverListViewModel from '../viewmodel/NewVideoReleaseCoverViewModel';
import PopularVideoCoverListViewModel from '../viewmodel/PopularVideoCoverViewModel';
import DailyVideoCoverListViewModel from '../viewmodel/DailyVideoCoverViewModel';
import PreviousVideoCoverListViewModel from '../viewmodel/PreviousVideoCoverViewModel';
import IconCoverListViewModel from '../viewmodel/IconCoverViewModel';
import BannerCoverListViewModel from '../viewmodel/BannerCoverViewModel';

@Component
export struct CommunityContent {
  @ObjectLink mainWindowInfo: WindowInfo;
  @State newVideoReleaseCoverList: NewVideoReleaseCoverListViewModel = new NewVideoReleaseCoverListViewModel();
  @State popularVideoCoverList: PopularVideoCoverListViewModel = new PopularVideoCoverListViewModel();
  @State dailyVideoCoverList: DailyVideoCoverListViewModel = new DailyVideoCoverListViewModel();
  @State previousVideoCoverList: PreviousVideoCoverListViewModel = new PreviousVideoCoverListViewModel();
  @State iconCoverList: IconCoverListViewModel = new IconCoverListViewModel();
  @State bannerCoverList: BannerCoverListViewModel = new BannerCoverListViewModel();
  @Consume('currentTopIndex') currentTopIndex: number = 0;
  @Consume('inOnPc') isOnPc: boolean;
  @StorageLink(CommonConstants.WINDOW_UTIL) windowUtil: WindowUtil | undefined = undefined;
  // The current vertical sliding distance of the list.
  @State currentYOffset: number = 0;
  // Whether the list slide to the bottom
  @State isReachingEnd: boolean = false;
  @State currentIndex: number = 0;
  @State decorWidth: number = 0;
  @Prop hdsTabsHeight: number;
  @Prop hdsTabsAvoidHeight: number;

  build() {
    Column() {
      BannerView({ mainWindowInfo: this.mainWindowInfo, bannerCoverList: this.bannerCoverList })
      IconView({ mainWindowInfo: this.mainWindowInfo, iconCoverList: this.iconCoverList })
      PopularVideo({
        mainWindowInfo: this.mainWindowInfo,
        popularVideoCoverList: this.popularVideoCoverList
      })
      NewVideoRelease({ mainWindowInfo: this.mainWindowInfo, newVideoReleaseCoverList: this.newVideoReleaseCoverList })
      DailyVideo({ mainWindowInfo: this.mainWindowInfo, dailyVideoCoverList: this.dailyVideoCoverList })
      PreviousVideo({ mainWindowInfo: this.mainWindowInfo, previousVideoCoverList: this.previousVideoCoverList })
    }
    // Set the background image to cover the side and top tabs.
    .backgroundImage(this.currentTopIndex === 2 ? new BreakpointType($r('app.media.immersive_background_sm'),
      $r('app.media.immersive_background_sm'), $r('app.media.immersive_background_md'),
      $r('app.media.immersive_background_lg'),
      $r('app.media.immersive_background_lg')).getValue(this.mainWindowInfo.widthBp) : $r('app.media.white_background'))
    // Set the size of the background image.
    .backgroundImageSize({
      width: '100%',
      height: new BreakpointType('384vp', '384vp', '420vp', '720vp', '720vp').getValue(this.mainWindowInfo.widthBp)
    })
    // Set the uniform background color.
    .backgroundColor(this.currentTopIndex === 2 ? (this.mainWindowInfo.widthBp !== WidthBreakpoint.WIDTH_MD ?
      $r('app.color.mp_home_content_background') : $r('app.color.mp_home_content_background_md')) : $r('app.color.mp_page_background'))
    .width('100%')
    .padding({
      bottom: DeviceApiVersionUtil.isApiVersionAfter23() && !this.isOnPc ?
        this.hdsTabsHeight + this.hdsTabsAvoidHeight :
        this.mainWindowInfo.widthBp >= WidthBreakpoint.WIDTH_LG ? '24vp' : '0vp'
    })
  }
}