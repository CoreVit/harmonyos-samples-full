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

import { CommonConstants, MSVDataModel, WindowInfo, getWindowInfoState } from 'multishortvideobase';
import { add, follow, friends, message, mine, recommend } from '../components/Builders';
import { TVTabs } from '../components/TvTabs';
import { MainTabsViewModel } from '../viewmodel/MainTabsViewModel';

@Entry
@ComponentV2
struct Index {
  @Local windowInfo: WindowInfo = getWindowInfoState();
  @Local data: MSVDataModel[] = [];
  @Provider('isDark') isDark: boolean = false;
  @Provider('pathStack') pathStack: NavPathStack = new NavPathStack();
  @Provider('showSideComment') showSideComment: boolean = false;
  @Provider('showSideIndividual') showSideIndividual: boolean = false;
  @Provider('currentBottomIndex') currentBottomIndex: number = 2;

  aboutToAppear(): void {
    this.data = new MainTabsViewModel().getMainTabsData();
  }

  build() {
    Navigation(this.pathStack) {
      Stack({ alignContent: Alignment.Top }) {
        TVTabs()
          .zIndex(1)
        Column() {
          if (this.currentBottomIndex === 2) {
            recommend()
          } else if (this.currentBottomIndex === 3) {
            follow()
          } else if (this.currentBottomIndex === 4) {
            friends()
          } else if (this.currentBottomIndex === 5) {
            add()
          } else if (this.currentBottomIndex === 6) {
            message()
          } else if (this.currentBottomIndex === 7) {
            mine()
          }
        }
      }
      .hitTestBehavior(this.showSideComment || this.showSideIndividual ? HitTestMode.Block :
        HitTestMode.Default)
      .gesture(TapGesture())
      .onGestureRecognizerJudgeBegin((event, current) => {
        if (current) {
          if (current.getType() === GestureControl.GestureType.TAP_GESTURE ||
            current.getType() === GestureControl.GestureType.CLICK) {
            if (this.showSideComment || this.showSideIndividual) {
              this.pathStack.pop();
              this.showSideComment = false;
              this.showSideIndividual = false;
              return GestureJudgeResult.REJECT;
            } else {
              return GestureJudgeResult.CONTINUE;
            }
          }
        }
        return GestureJudgeResult.CONTINUE;
      })
    }
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .navBarWidthRange([880, '100%'])
    .navBarWidth(880)
    .hideBackButton(true)
    .hideTitleBar(true)
    .divider(null)
    .mode(this.showSideComment || this.showSideIndividual ? NavigationMode.Split : NavigationMode.Stack)
    .enableModeChangeAnimation(false)
  }
}