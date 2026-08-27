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


export enum MyWidthBreakpoint {
  /**
   * Window width < 320vp type.
   *
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @atomicservice
   * @since 13
   */
  /**
   * Window width < 320vp type.
   *
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @crossplatform
   * @atomicservice
   * @since 22
   */
  WIDTH_XS = 0,
  /**
   * Window width >= 320vp and < 600vp type.
   *
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @atomicservice
   * @since 13
   */
  /**
   * Window width >= 320vp and < 600vp type.
   *
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @crossplatform
   * @atomicservice
   * @since 22
   */
  WIDTH_SM = 1,
  /**
   * Window width >= 600vp and < 840vp type.
   *
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @atomicservice
   * @since 13
   */
  /**
   * Window width >= 600vp and < 840vp type.
   *
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @crossplatform
   * @atomicservice
   * @since 22
   */
  WIDTH_MD = 2,
  /**
   * Window width >= 840vp and < 1000vp type.
   *
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @atomicservice
   * @since 13
   */
  /**
   * Window width >= 840vp and < 1000vp type.
   *
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @crossplatform
   * @atomicservice
   * @since 22
   */
  WIDTH_HP = 3,

  /**
   * Window width >= 1000vp and < 1440vp type.
   *
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @crossplatform
   * @atomicservice
   * @since 22
   */
  WIDTH_LG = 4,
  /**
   * Window width >= 1440vp type.
   *
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @atomicservice
   * @since 13
   */
  WIDTH_XL = 5

}

/**
 * Type of window height breakpoint.
 *
 * @enum {number}
 * @syscap SystemCapability.ArkUI.ArkUI.Full
 * @atomicservice
 * @since 13
 */
/**
 * Type of window height breakpoint.
 *
 * @enum {number}
 * @syscap SystemCapability.ArkUI.ArkUI.Full
 * @crossplatform
 * @atomicservice
 * @since 22
 */
export enum MyHeightBreakpoint {
  /**
   * Window aspectRatio < 0.8 type.
   *
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @atomicservice
   * @since 13
   */
  /**
   * Window aspectRatio < 0.8 type.
   *
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @crossplatform
   * @atomicservice
   * @since 22
   */
  HEIGHT_SM = 0,
  /**
   * Window aspectRatio >= 0.8 and < 1.2 type.
   *
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @atomicservice
   * @since 13
   */
  /**
   * Window aspectRatio >= 0.8 and < 1.2 type.
   *
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @crossplatform
   * @atomicservice
   * @since 22
   */
  HEIGHT_MD = 1,
  /**
   * Window aspectRatio >= 1.2 type.
   *
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @atomicservice
   * @since 13
   */
  /**
   * Window aspectRatio >= 1.2 type.
   *
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @crossplatform
   * @atomicservice
   * @since 22
   */
  HEIGHT_LG = 2
}

export class BreakPointInfo {
  public static getWindowWidthBreakpoint(widthVp: number): MyWidthBreakpoint {
    if (widthVp < 320) {
      return MyWidthBreakpoint.WIDTH_XS;
    }
    if (widthVp < 600) {
      return MyWidthBreakpoint.WIDTH_SM;
    }
    if (widthVp < 840) {
      return MyWidthBreakpoint.WIDTH_MD;
    }
    if (widthVp < 1000) {
      return MyWidthBreakpoint.WIDTH_HP;
    }

    if (widthVp < 1440) {
      return MyWidthBreakpoint.WIDTH_LG;
    }
    return MyWidthBreakpoint.WIDTH_XL;
  }

  public static getWindowHeightBreakpoint(widthVp: number, heightVp: number): MyHeightBreakpoint {
    if (widthVp === 0) {
      return MyHeightBreakpoint.HEIGHT_SM;
    }
    let ratio = heightVp / widthVp;
    if (ratio < 0.8) {
      return MyHeightBreakpoint.HEIGHT_SM;
    }
    if (ratio < 1.2) {
      return MyHeightBreakpoint.HEIGHT_MD;
    }
    return MyHeightBreakpoint.HEIGHT_LG;
  }
}