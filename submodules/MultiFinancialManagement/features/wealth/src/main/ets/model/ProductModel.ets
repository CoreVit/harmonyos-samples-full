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

export class ProductModel {
  private tagList: TagInfo[];
  private featureList: FeatureInfo[];

  constructor() {
    this.tagList = [
      { text: $r('app.string.financial_detail_tag_low_risk'), fontColor: $r('app.color.font_emphasize'), bgColor: $r('app.color.brand20'), icon: $r('sys.symbol.checkmark_shield_fill') },
      { text: $r('app.string.financial_detail_tag_min_purchase'), fontColor: $r('app.color.alert'), bgColor: $r('app.color.alert20') },
      { text: $r('app.string.financial_detail_tag_sufficient_quota'), fontColor: $r('app.color.confirm'), bgColor: $r('app.color.confirm20') }
    ];
    this.featureList = [
      { title: $r('app.string.financial_detail_feature_title_1'), desc: $r('app.string.financial_detail_feature_desc_1') },
      { title: $r('app.string.financial_detail_feature_title_2'), desc: $r('app.string.financial_detail_feature_desc_2') }
    ];
  }

  getTagList(): TagInfo[] {
    return this.tagList;
  }
  getFeatureList(): FeatureInfo[] {
    return this.featureList;
  }
}

export interface TagInfo {
  text: ResourceStr;
  fontColor: ResourceColor;
  bgColor: ResourceColor;
  icon?: Resource;
}

export interface FeatureInfo {
  title: ResourceStr;
  desc: ResourceStr;
}
