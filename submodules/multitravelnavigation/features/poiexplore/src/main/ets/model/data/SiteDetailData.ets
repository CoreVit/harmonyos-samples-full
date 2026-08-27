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

export class SiteInfo {
  public imgSource: Resource = $r('app.media.img_somewhere1');
  public siteName: ResourceStr = $r('app.string.attraction1');
  public siteBrief: ResourceStr = $r('app.string.site_brief_great_scenery');
  public siteCount: number = 0;
  public sitePrice: ResourceStr = $r('app.string.site_price_60');
  public isFree: boolean = false;
  public countInfo?: ResourceStr = '';

  public constructor(imgSource: Resource, siteName: ResourceStr, siteBrief: ResourceStr,
    siteCount: number, sitePrice: ResourceStr, isFree: boolean, countInfo?: ResourceStr) {
    this.imgSource = imgSource;
    this.siteName = siteName;
    this.siteBrief = siteBrief;
    this.siteCount = siteCount;
    this.sitePrice = sitePrice;
    this.isFree = isFree;
    if (countInfo) {
      this.countInfo = countInfo;
    }
  }
}

export const SITE_LIST: SiteInfo[] = [
  new SiteInfo($r('app.media.img_somewhere2'), $r('app.string.attraction1'), $r('app.string.site_brief_great_scenery'),
    45, $r('app.string.site_price_60'), false, $r('app.string.site_discount_75')),
  new SiteInfo($r('app.media.img_somewhere3'), $r('app.string.attraction2'), $r('app.string.site_brief_many_shops'),
    20, $r('app.string.site_price_32'), false, $r('app.string.site_discount_75')),
  new SiteInfo($r('app.media.img_somewhere4'), $r('app.string.attraction3'), $r('app.string.site_brief_crowded'),
    0, $r('app.string.site_price_free'), true),
  new SiteInfo($r('app.media.img_somewhere5'), $r('app.string.attraction4'), $r('app.string.site_brief_snack_shops'),
    24, $r('app.string.site_price_32'), false, $r('app.string.site_discount_75')),
  new SiteInfo($r('app.media.img_somewhere5'), $r('app.string.site_name_optics_valley'),
    $r('app.string.site_brief_snack_shops'), 24, $r('app.string.site_price_32'), false,
    $r('app.string.site_discount_75')),
  new SiteInfo($r('app.media.img_somewhere5'), $r('app.string.site_name_optics_valley'),
    $r('app.string.site_brief_snack_shops'), 24, $r('app.string.site_price_32'), false,
    $r('app.string.site_discount_75')),
  new SiteInfo($r('app.media.img_somewhere5'), $r('app.string.site_name_optics_valley'),
    $r('app.string.site_brief_snack_shops'), 24, $r('app.string.site_price_32'), false,
    $r('app.string.site_discount_75')),
];
