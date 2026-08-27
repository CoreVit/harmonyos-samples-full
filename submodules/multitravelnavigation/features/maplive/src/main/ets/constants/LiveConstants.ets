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

export class LiveConstants {
  /**
   * Live view id.
   */
  public static readonly LIVE_VIEW_ID: number = 0;

  /**
   * Capsule background color.
   */
  public static readonly CAPSULE_COLOR: string = '#FF0A59F7';

  /**
   * Capsule icon.
   */
  public static readonly CAPSULE_ICON: string = 'circle_map.png';

  /**
   * Live view title resource.
   */
  public static readonly LIVE_VIEW_TITLE: Resource = $r('app.string.live_view_title');

  /**
   * Live view content resource.
   */
  public static readonly LIVE_VIEW_CONTENT: Resource = $r('app.string.live_view_content');

  /**
   * Live view destination resource.
   */
  public static readonly LIVE_VIEW_DESTINATION: Resource = $r('app.string.live_view_destination');

  /**
   * Live view distance color.
   */
  public static readonly LIVE_VIEW_DISTANCE_COLOR: string = '#FF0A59F7';

  /**
   * Capsule title resource.
   */
  public static readonly CAPSULE_TITLE: Resource = $r('app.string.capsule_title');

  /**
   * Capsule content resource.
   */
  public static readonly CAPSULE_CONTENT: Resource = $r('app.string.capsule_content');

  /**
   * Capsule keep time.
   */
  public static readonly TIME: number = 1;

  /**
   * Live view already exists error code.
   */
  public static readonly LIVE_VIEW_ALREADY_EXISTS: number = 1003500006;

  /**
   * Live view does not exist error code.
   */
  public static readonly LIVE_VIEW_NOT_EXISTS: number = 1003500009;
}
