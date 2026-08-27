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

import { common } from '@kit.AbilityKit';

/**
 * Split-screen / multi-ability: {@link AppStorage} is process-wide. Fixed keys would share one
 * PiP/AVPlayer instance across UIAbility windows → black screen and PiP errors. Scope keys by host ability name.
 */
export function abilityScopedAppStorageKey(uiContext: UIContext, baseKey: string): string {
  const host = uiContext.getHostContext() as common.UIAbilityContext | undefined;
  const suffix = host?.abilityInfo?.name ?? 'default';
  return `${baseKey}_${suffix}`;
}
