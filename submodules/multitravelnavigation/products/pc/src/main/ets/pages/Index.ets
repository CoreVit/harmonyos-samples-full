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

import { Common, WindowUtil } from 'multitravelbase/Index';
import { uiObserver } from '@kit.ArkUI';
import { MapContainerPage } from 'mapcontainer';

@Entry
@Component
struct Index {
  @Env(SystemProperties.BREAK_POINT) breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;
  @StorageLink('multitravelnavigationsample_windowUtil') windowUtil: WindowUtil | undefined = undefined;

  build() {
    Column() {
      if (this.windowUtil) {
        MapContainerPage({
          layoutMode: 'embedded',
          mainWindowInfo: this.windowUtil.mainWindowInfo,
          getBreakpoint: () => this.breakpoint
        })
          .width(Common.FULL_WIDTH)
          .height(Common.FULL_HEIGHT)
      }
    }
    .height(Common.FULL_HEIGHT)
    .width(Common.FULL_WIDTH)
  }
}
