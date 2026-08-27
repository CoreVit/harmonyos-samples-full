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

import { CommonConstants, WindowUtil } from 'multivideobase';
import DailyVideoCoverListViewModel from '../viewmodel/DailyVideoCoverViewModel';
import NewVideoReleaseCoverListViewModel from '../viewmodel/NewVideoReleaseCoverViewModel';
import PopularVideoCoverListViewModel from '../viewmodel/PopularVideoCoverViewModel';
import TVBannerCoverListViewModel from '../viewmodel/TVBannerCoverViewModel';
import TVPreviousVideoCoverListViewModel from '../viewmodel/TVPreviousVideoCoverViewModel';
import { DailyVideo } from './DailyVideo';
import { NewVideoRelease } from './NewVideoRelease';
import { PopularVideo } from './PopularVideo';
import { TVBannerView } from './TVBannerView';
import { TVPreviousVideo } from './TVPreviousVideo';
import { TVTopBarView } from './TVTopBarView';

@Component
export struct TVMainPageContent {
  @StorageLink(CommonConstants.WINDOW_UTIL) windowUtil: WindowUtil | undefined = undefined;
  @State currentTopIndexForTv: number = 0;
  @State newVideoReleaseCoverList: NewVideoReleaseCoverListViewModel = new NewVideoReleaseCoverListViewModel();
  @State popularVideoCoverList: PopularVideoCoverListViewModel = new PopularVideoCoverListViewModel();
  @State dailyVideoCoverList: DailyVideoCoverListViewModel = new DailyVideoCoverListViewModel();
  @State tvPreviousVideoCoverList: TVPreviousVideoCoverListViewModel = new TVPreviousVideoCoverListViewModel();
  @State tvBannerCoverList: TVBannerCoverListViewModel = new TVBannerCoverListViewModel();

  build() {
    Column() {
      TVBannerView({ mainWindowInfo: this.windowUtil?.mainWindowInfo, tvBannerCoverList: this.tvBannerCoverList })
      TVTopBarView({ currentTVTopIndexForTv: this.currentTopIndexForTv })
      Column() {
        PopularVideo({
          mainWindowInfo: this.windowUtil?.mainWindowInfo,
          popularVideoCoverList: this.popularVideoCoverList
        })
        NewVideoRelease({
          mainWindowInfo: this.windowUtil?.mainWindowInfo,
          newVideoReleaseCoverList: this.newVideoReleaseCoverList
        });
        DailyVideo({ mainWindowInfo: this.windowUtil?.mainWindowInfo, dailyVideoCoverList: this.dailyVideoCoverList })
        TVPreviousVideo({
          mainWindowInfo: this.windowUtil?.mainWindowInfo,
          tvPreviousVideoCoverList: this.tvPreviousVideoCoverList
        })
      }
      .visibility(this.currentTopIndexForTv === 0 ? Visibility.Visible : Visibility.None)
    }
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
    .width('100%')
  }
}