/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

interface PageAnimation {
  onEnterStart: () => void;
  onEnterFinish: () => void;
  onExitFinish: () => void;
  onExitStart: () => void;
}

export class CustomTransition {
  private static animation: Map<string, PageAnimation> = new Map();

  public static registerAnimationByID(id: string, pageAnimation: PageAnimation): void {
    if (!id || !pageAnimation) {
      return;
    }
    CustomTransition.animation.set(id, pageAnimation);
  }

  public static unRegisterAnimationByID(id: string): void {
    if (id && CustomTransition.animation.has(id)) {
      CustomTransition.animation.delete(id);
    }
  }

  public static getAnimationById(id: string): PageAnimation | undefined {
    if (!id) {
      return undefined;
    }
    return CustomTransition.animation.get(id);
  }
}
