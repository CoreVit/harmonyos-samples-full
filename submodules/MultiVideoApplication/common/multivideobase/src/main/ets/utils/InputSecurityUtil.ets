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

export class InputSecurityUtil {
  private static readonly MAX_INPUT_LENGTH: number = 50;

  /**
   * Sanitizes external text input by removing control chars and capping length.
   */
  static sanitizeSearchInput(raw: string): string {
    const normalized: string = raw.replace(/[\u0000-\u001F\u007F]/g, '');
    return normalized.slice(0, InputSecurityUtil.MAX_INPUT_LENGTH);
  }
}
