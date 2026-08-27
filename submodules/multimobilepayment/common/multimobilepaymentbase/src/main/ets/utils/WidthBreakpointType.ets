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

export class WidthBreakpointType<T> {
  private sm: T;
  private md: T;
  private lg: T;
  private xl: T;

  constructor(sm: T, md: T, lg: T, xl: T) {
    this.sm = sm;
    this.md = md;
    this.lg = lg;
    this.xl = xl;
  }

  getValue(widthBp: number): T {
    switch (widthBp) {
      case 0:
      case 1:
        return this.sm;
      case 2:
        return this.md;
      case 3:
        return this.lg;
      case 4:
        return this.xl;
      default:
        return this.sm;
    }
  }
}