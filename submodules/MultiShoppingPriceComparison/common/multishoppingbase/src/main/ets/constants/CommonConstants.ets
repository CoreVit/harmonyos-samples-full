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
interface CommonConstantsInterface {
  breakpointsSmName: string;
  breakpointsMdName: string;
  breakpointsLgName: string;
  breakpointsXlName: string;
  breakpointsSmSize: number;
  breakpointsMdSize: number;
  breakpointsLgSize: number;
  breakpointsXlSize: number;
  breakpointsInitializeName: string;
  breakpointIdInitializeName: string;
}

/**
 * Common constants for all features.
 */
export const commonConstants: CommonConstantsInterface = {
  /**
   * Breakpoint sm.
   */
  breakpointsSmName: 'sm',

  /**
   * Breakpoint md.
   */
  breakpointsMdName: 'md',

  /**
   * Breakpoint lg.
   */
  breakpointsLgName: 'lg',

  /**
   * Breakpoint xl.
   */
  breakpointsXlName: 'xl',

  /**
   * The break point value of sm device.
   */
  breakpointsSmSize: 0,

  /**
   * The break point value of md device.
   */
  breakpointsMdSize: 600,

  /**
   * The break point value of lg device.
   */
  breakpointsLgSize: 840,

  /**
   * The break point value of xl device.
   */
  breakpointsXlSize: 1320,

  /**
   * Initialize device breakpoints.
   */
  breakpointsInitializeName: 'md',

  /**
   * Initialize device breakpoint Id.
   */
  breakpointIdInitializeName: 'unknown'
};