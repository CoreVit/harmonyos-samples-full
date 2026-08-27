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
  public xs?: T;
  public sm: T;
  public md: T;
  public lg: T;
  public xl: T;

  constructor(sm: T, md: T, lg: T, xl: T, xs?: T) {
    this.xs = xs;
    this.sm = sm;
    this.md = md;
    this.lg = lg;
    this.xl = xl;
  }

  getValue(widthBp: WidthBreakpoint): T {
    let value: T;
    switch (widthBp) {
      case WidthBreakpoint.WIDTH_XS:
        value = this.xs ?? this.sm;
        break;
      case WidthBreakpoint.WIDTH_SM:
        value = this.sm;
        break;
      case WidthBreakpoint.WIDTH_MD:
        value = this.md;
        break;
      case WidthBreakpoint.WIDTH_LG:
        value = this.lg;
        break;
      case WidthBreakpoint.WIDTH_XL:
        value = this.xl;
        break;
      default:
        value = this.sm;
        break;
    }
    return value;
  }
}

