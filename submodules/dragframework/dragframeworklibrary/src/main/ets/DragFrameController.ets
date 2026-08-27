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
import { common, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { EventUtil } from './common/utils/EventUtil';
import { WindowUtil } from './common/utils/WindowUtil';

export class DragFrameController {
  public static initWindowConfig(windowStage: window.WindowStage): void {
    WindowUtil.initialize(windowStage);
  }

  public static removeWindowConfig(): void {
    WindowUtil.unregisterBreakPoint();
  }

  public static subscribeEvent(context: common.UIAbilityContext, want: Want) {
    EventUtil.subscribeEvent(context, want);
  }

  public static unsubscribeEvent(context: common.UIAbilityContext) {
    EventUtil.unsubscribeEvent(context);
  }
}