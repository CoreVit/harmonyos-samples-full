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
import Logger from './Logger';

interface BreakpointMap<V> {
  xs?: V;
  sm: V;
  md?: V;
  lg?: V;
  xl?: V;
}

export type BreakpointType = 'xs' | 'sm' | 'md' | 'lg' | 'xl';

/**
 * @throws error when breakpointMap or breakpoint are undefined, or found no valid result.
 */
export const getValueByBreakpointSync = <V>(breakpointMap: BreakpointMap<V>, breakpoint: BreakpointType): V => {
  if (!breakpointMap || !breakpoint) {
    Logger.error(`getValueByBreakpointSync got unvalid breakpoints`);
    throw new Error('breakpointMap and breakpoint cannot be null or undefined');
  }
  let result: V | undefined;
  switch (breakpoint) {
    case 'xs':
      result = breakpointMap.xs ?? breakpointMap.sm;
      break;
    case 'sm':
      result = breakpointMap.sm;
      break;
    case 'md':
      result = breakpointMap.md ?? breakpointMap.sm;
      break;
    case 'lg':
      result = breakpointMap.lg ?? breakpointMap.md ?? breakpointMap.sm;
      break;
    case 'xl':
      result = breakpointMap.xl ?? breakpointMap.lg ?? breakpointMap.md ?? breakpointMap.sm;
      break;
    default:
      result = breakpointMap.sm;
      break;
  }
  if (result === undefined) {
    throw new Error(`No value found for breakpoint: ${breakpoint}`);
  }
  return result;
};
