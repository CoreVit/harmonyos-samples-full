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

import { AVCastPicker } from '@kit.AVSessionKit';
import { KeyConstants } from '../common/constants/KeyConstants';
import { StyleConstants } from '../common/constants/StyleConstants';
import { BreakpointType, BreakpointTypeEnum } from '../common/utils/BreakpointSystem';
import { SongItem } from '../songdatacontroller/SongData';

@Component
export struct TopAreaComponent {
  @StorageLink(KeyConstants.KEY_SONG_LIST) songList: SongItem[] = [];
  @StorageProp(KeyConstants.KEY_BREAKPOINT) currentBreakpoint: string = BreakpointTypeEnum.SM;
  @StorageProp(KeyConstants.KEY_SELECT_INDEX) @Watch('getIsDark') selectIndex: number = 0;
  @State isDark: boolean = true;
  @State color: Color = Color.White

  getIsDark() {
    this.isDark = this.songList[this.selectIndex].isDarkBackground;
    this.color = this.isDark ? Color.White : Color.Black
  }

  build() {
    Row() {
      AVCastPicker({ normalColor: this.color, activeColor: this.color })
        .width(new BreakpointType({
          sm: $r('app.float.common_iamge'),
          md: $r('app.float.common_iamge'),
          lg: $r('app.float.control_image_lg')
        }).getValue(this.currentBreakpoint))
        .height(new BreakpointType({
          sm: $r('app.float.common_iamge'),
          md: $r('app.float.common_iamge'),
          lg: $r('app.float.control_image_lg')
        }).getValue(this.currentBreakpoint))
    }
    .height($r('app.float.info_margin_top_sm'))
    .width(StyleConstants.FULL_WIDTH)
    .justifyContent(FlexAlign.End)
  }
}