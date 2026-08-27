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

import motion from '@ohos.multimodalAwareness.motion';
import {
  CommonConstants,
  MSVTabs,
  MSVDataModel,
  WindowInfo,
  getWindowInfoState,
  WidthBreakpointType,
  Logger
} from 'multishortvideobase';
import { MainTabsViewModel } from '../viewmodel/MainTabsViewModel';

const TAG = 'defaultIndex';

@Entry
@ComponentV2
struct Index {
  @Local windowInfo: WindowInfo = getWindowInfoState();
  @Local data: MSVDataModel[] = [];
  @Provider('isDark') isDark: boolean = false;
  @Provider('pathStack') pathStack: NavPathStack = new NavPathStack();
  @Provider('showSideComment') showSideComment: boolean = false;
  @Provider('showSideIndividual') showSideIndividual: boolean = false;
  @Provider('subTabIndex') subTabIndex: number = 4;
  @Provider('holdingHandStatus') holdingHandStatus: motion.HoldingHandStatus =
    motion.HoldingHandStatus.RIGHT_HAND_HELD;

  aboutToAppear(): void {
    this.data = new MainTabsViewModel().getMainTabsData();
    try {
      motion.on('holdingHandChanged', this.motionCb())
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `getMainWindowSync failed. Code: ${err.code}, message: ${err.message}`);
    }
  }

  aboutToDisappear(): void {
    try {
      motion.off('holdingHandChanged', this.motionCb())
    } catch (error) {
      let err = error as BusinessError;
      Logger.error(TAG, `getMainWindowSync failed. Code: ${err.code}, message: ${err.message}`);
    }
  }

  motionCb() {
    return (status: motion.HoldingHandStatus) => {
      if (status === motion.HoldingHandStatus.RIGHT_HAND_HELD || status === motion.HoldingHandStatus.LEFT_HAND_HELD) {
        this.holdingHandStatus = status;
      }
    }
  }

  build() {
    Navigation(this.pathStack) {
      MSVTabs({
        data: this.data,
        isDark: this.isDark,
        barBottomMargin: this.windowInfo.widthBp === WidthBreakpoint.WIDTH_SM &&
          this.windowInfo.heightBp === HeightBreakpoint.HEIGHT_MD ? 16 : 0,
        onIndexChange: (index: number) => {
          if (index === 0 && this.subTabIndex === 4) {
            this.isDark = false;
          } else if (index === 4) {
            this.isDark = new WidthBreakpointType<boolean>(true, true, false, false).getValue(this.windowInfo.widthBp)
          } else {
            this.isDark = true;
          }
        }
      })
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
    .navBarWidthRange([new WidthBreakpointType<number>(410, 410, 700, 700).getValue(this.windowInfo.widthBp), '100%'])
    .navBarWidth(new WidthBreakpointType<number>(410, 410, 700, 700).getValue(this.windowInfo.widthBp))
    .hideBackButton(true)
    .hideTitleBar(true)
    .divider(null)
    .navBarPosition(
      this.holdingHandStatus === motion.HoldingHandStatus.RIGHT_HAND_HELD ? NavBarPosition.Start : NavBarPosition.End)
    .mode(this.showSideComment || this.showSideIndividual ? NavigationMode.Split : NavigationMode.Stack)
    .enableModeChangeAnimation(false)

  }
}