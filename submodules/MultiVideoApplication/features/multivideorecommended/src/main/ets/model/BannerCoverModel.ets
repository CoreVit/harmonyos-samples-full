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

import { BreakpointType } from 'multivideobase';
import { MainPageConstants } from '../constants/MainPageConstants';

export class BannerCoverModel {
  private id: string = '0';
  private imgSrc: Resource;
  private imgSrcSm: Resource;
  private height: BreakpointType<Resource>;
  private description: ResourceStr[];
  private fontSize: BreakpointType<Resource[]>;
  private fontWeight: number[];
  private lineHeight: BreakpointType<Resource[]>;
  private leftPosition: BreakpointType<string[]>;
  private topPosition: BreakpointType<string[]>;
  private isLeftCenter: BreakpointType<boolean>;
  private isTopCenter: BreakpointType<boolean>;

  constructor(id: string, imgSrc: Resource, imgSrcSm: Resource, height: BreakpointType<Resource>,
    description: ResourceStr[], fontSize: BreakpointType<Resource[]>, fontWeight: number[],
    lineHeight: BreakpointType<Resource[]>, leftPosition: BreakpointType<string[]>,
    topPosition: BreakpointType<string[]>, isLeftCenter: BreakpointType<boolean>,
    isTopCenter: BreakpointType<boolean>) {
    this.id = id;
    this.imgSrc = imgSrc;
    this.imgSrcSm = imgSrcSm;
    this.height = height;
    this.description = description;
    this.fontSize = fontSize;
    this.fontWeight = fontWeight;
    this.lineHeight = lineHeight;
    this.leftPosition = leftPosition;
    this.topPosition = topPosition;
    this.isLeftCenter = isLeftCenter;
    this.isTopCenter = isTopCenter;
  }

  getId(): string {
    return this.id;
  }

  getImgSrc(): Resource {
    return this.imgSrc;
  }

  getImgSrcSm(): Resource {
    return this.imgSrcSm;
  }

  getHeight(): BreakpointType<Resource> {
    return this.height;
  }

  getDescription(): ResourceStr[] {
    return this.description;
  }

  getFontSize(): BreakpointType<Resource[]> {
    return this.fontSize;
  }

  getFontWeight(): number[] {
    return this.fontWeight;
  }

  getLineHeight(): BreakpointType<Resource[]> {
    return this.lineHeight;
  }

  getLeftPosition(): BreakpointType<string[]> {
    return this.leftPosition;
  }

  getTopPosition(): BreakpointType<string[]> {
    return this.topPosition;
  }

  getIsLeftCenter(): BreakpointType<boolean> {
    return this.isLeftCenter;
  }

  getIsTopCenter(): BreakpointType<boolean> {
    return this.isTopCenter;
  }
}

export class BannerCoverListModel {
  private bannerCoverListModel: BannerCoverModel[] = [];

  constructor(bannerCoverListModel: BannerCoverModel[]) {
    this.bannerCoverListModel = bannerCoverListModel;
  }

  loadBannerCoverData(): void {
    this.clearBannerCoverList();
    const defaultHeight = new BreakpointType($r('app.float.banner_height_sm'), $r('app.float.banner_height_sm'),
      $r('app.float.banner_height_md'), $r('app.float.banner_height_lg'), $r('app.float.banner_height_xl'));
    const defaultFontSize = new BreakpointType([$r('app.float.banner_text_1_font_sm'), $r('app.float.banner_text_2_font_sm')],
      [$r('app.float.banner_text_1_font_sm'), $r('app.float.banner_text_2_font_sm')],
      [$r('app.float.banner_text_1_font_md'), $r('app.float.banner_text_2_font_md')],
      [$r('app.float.banner_text_1_font_lg'), $r('app.float.banner_text_2_font_lg')],
      [$r('app.float.banner_text_1_font_lg'), $r('app.float.banner_text_2_font_lg')]);
    const defaultLineHeight = new BreakpointType([$r('app.float.banner_text_1_height_sm'), $r('app.float.banner_text_2_height_sm')],
      [$r('app.float.banner_text_1_height_sm'), $r('app.float.banner_text_2_height_sm')],
      [$r('app.float.banner_text_1_height_md'), $r('app.float.banner_text_2_height_md')],
      [$r('app.float.banner_text_1_height_lg'), $r('app.float.banner_text_2_height_lg')],
      [$r('app.float.banner_text_1_height_lg'), $r('app.float.banner_text_2_height_lg')]);

    this.bannerCoverListModel = [
      new BannerCoverModel('0', $r('app.media.ic_banner_1'), $r('app.media.ic_banner_1_sm'), defaultHeight,
        MainPageConstants.BANNER_TEXT_4, defaultFontSize, [700, 500], defaultLineHeight,
        new BreakpointType([], [], [''], [], []), new BreakpointType([''], [''], [], [], []),
        new BreakpointType(true, true, true, true, true), new BreakpointType(true, true, true, true, true)),
      new BannerCoverModel('1', $r('app.media.ic_banner_3'), $r('app.media.ic_banner_3_sm'), defaultHeight,
        MainPageConstants.BANNER_TEXT_2, defaultFontSize, [700, 500], defaultLineHeight,
        new BreakpointType([], [], [MainPageConstants.BANNER_TEXT_2_LEFT_MD], [MainPageConstants.BANNER_TEXT_2_LEFT_LG],
          [MainPageConstants.BANNER_TEXT_2_LEFT_LG]),
        new BreakpointType(MainPageConstants.BANNER_TEXT_2_TOP_SM, MainPageConstants.BANNER_TEXT_2_TOP_SM,
          MainPageConstants.BANNER_TEXT_2_TOP_MD, MainPageConstants.BANNER_TEXT_2_TOP_LG,
          MainPageConstants.BANNER_TEXT_2_TOP_LG),
        new BreakpointType(true, true, false, false, false),
        new BreakpointType(false, false, false, false, false)),
      new BannerCoverModel('2', $r('app.media.ic_banner_2'), $r('app.media.ic_banner_2_sm'), defaultHeight,
        MainPageConstants.BANNER_TEXT_1, defaultFontSize, [700, 500], defaultLineHeight,
        new BreakpointType([], [], [MainPageConstants.BANNER_TEXT_1_LEFT_MD], [], []),
        new BreakpointType(MainPageConstants.BANNER_TEXT_1_TOP_SM, MainPageConstants.BANNER_TEXT_1_TOP_SM,
          MainPageConstants.BANNER_TEXT_1_TOP_MD, MainPageConstants.BANNER_TEXT_1_TOP_LG,
          MainPageConstants.BANNER_TEXT_1_TOP_LG),
        new BreakpointType(true, true, false, true, true),
        new BreakpointType(false, false, false, false, false)),
      new BannerCoverModel('3', $r('app.media.ic_banner_3'), $r('app.media.ic_banner_3_sm'), defaultHeight,
        MainPageConstants.BANNER_TEXT_2, defaultFontSize, [700, 500], defaultLineHeight,
        new BreakpointType([], [], [MainPageConstants.BANNER_TEXT_2_LEFT_MD], [MainPageConstants.BANNER_TEXT_2_LEFT_LG],
          [MainPageConstants.BANNER_TEXT_2_LEFT_LG]),
        new BreakpointType(MainPageConstants.BANNER_TEXT_2_TOP_SM, MainPageConstants.BANNER_TEXT_2_TOP_SM,
          MainPageConstants.BANNER_TEXT_2_TOP_MD, MainPageConstants.BANNER_TEXT_2_TOP_LG,
          MainPageConstants.BANNER_TEXT_2_TOP_LG),
        new BreakpointType(true, true, false, false, false),
        new BreakpointType(false, false, false, false, false)),
      new BannerCoverModel('4', $r('app.media.ic_banner_4'), $r('app.media.ic_banner_4'), defaultHeight,
        MainPageConstants.BANNER_TEXT_3, defaultFontSize, [700, 500], defaultLineHeight,
        new BreakpointType([], [], [''], [], []), new BreakpointType([''], [''], [], [], []),
        new BreakpointType(true, true, true, true, true), new BreakpointType(true, true, true, true, true)),
      new BannerCoverModel('5', $r('app.media.ic_banner_1'), $r('app.media.ic_banner_1_sm'), defaultHeight,
        MainPageConstants.BANNER_TEXT_4, defaultFontSize, [700, 500], defaultLineHeight,
        new BreakpointType([], [], [''], [], []), new BreakpointType([''], [''], [], [], []),
        new BreakpointType(true, true, true, true, true), new BreakpointType(true, true, true, true, true))
    ];
  }

  getBannerCoverListModel(): BannerCoverModel[] {
    return this.bannerCoverListModel.slice();
  }

  clearBannerCoverList(): void {
    this.bannerCoverListModel = [];
  }
}
