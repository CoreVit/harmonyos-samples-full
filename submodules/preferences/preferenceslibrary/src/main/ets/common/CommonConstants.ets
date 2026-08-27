/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

export interface ImageAndName {
  image: Resource;
  name: ResourceStr;
  color: Resource;
}

/*
 * Public constants.
 */
export class CommonConstants {
  /*
 * AppStorage key prefix.
 */
  public static readonly KEY_PREFIX: string = 'preference';
}

export const THEMES: Array<ImageAndName>[] = [
  [
    { image: $r('sys.symbol.phone'), name: $r('app.string.dialer'), color: $r('sys.color.font_primary') },
    { image: $r('sys.symbol.bag_badge_plus'), name: $r('app.string.shopping'), color: $r('sys.color.font_primary') },
    {
      image: $r('sys.symbol.checkmark_square_on_square'),
      name: $r('app.string.notes'),
      color: $r('sys.color.font_primary')
    },
    { image: $r('sys.symbol.envelope'), name: $r('app.string.settings'), color: $r('sys.color.font_primary') },
    { image: $r('sys.symbol.camera'), name: $r('app.string.camera'), color: $r('sys.color.font_primary') },
    { image: $r('sys.symbol.picture_on_square_1'), name: $r('app.string.album'), color: $r('sys.color.font_primary') },
    { image: $r('sys.symbol.headphones'), name: $r('app.string.music'), color: $r('sys.color.font_primary') },
    { image: $r('sys.symbol.template'), name: $r('app.string.video'), color: $r('sys.color.font_primary') },
    { image: $r('sys.symbol.local_badge_plus'), name: $r('app.string.map'), color: $r('sys.color.font_primary') },
    { image: $r('sys.symbol.creditcard'), name: $r('app.string.wallet'), color: $r('sys.color.font_primary') },
    { image: $r('sys.symbol.key_shield'), name: $r('app.string.safe'), color: $r('sys.color.font_primary') },
    { image: $r('sys.symbol.dot_circle_on_line'), name: $r('app.string.browser'), color: $r('sys.color.font_primary') },

  ],
  [
    { image: $r('sys.symbol.phone_badge_waveform_3'), name: $r('app.string.dialer'), color: $r('sys.color.brand') },
    { image: $r('sys.symbol.store'), name: $r('app.string.shopping'), color: $r('sys.color.brand') },
    { image: $r('sys.symbol.doc_text_badge_checkmark'), name: $r('app.string.notes'), color: $r('sys.color.brand') },
    {
      image: $r('sys.symbol.envelope_badge_arrow_left'),
      name: $r('app.string.settings'),
      color: $r('sys.color.brand')
    },
    { image: $r('sys.symbol.camera_audionote'), name: $r('app.string.camera'), color: $r('sys.color.brand') },
    { image: $r('sys.symbol.camera_aperture'), name: $r('app.string.album'), color: $r('sys.color.brand') },
    { image: $r('sys.symbol.music_note_phone'), name: $r('app.string.music'), color: $r('sys.color.brand') },
    { image: $r('sys.symbol.play_round_rectangle'), name: $r('app.string.video'), color: $r('sys.color.brand') },
    {
      image: $r('sys.symbol.location_north_up_right'),
      name: $r('app.string.map'),
      color: $r('sys.color.brand')
    },
    {
      image: $r('sys.symbol.card_badge_yuansign_arrow_counterclockwise'),
      name: $r('app.string.wallet'),
      color: $r('sys.color.brand')
    },
    { image: $r('sys.symbol.key_horizontal'), name: $r('app.string.safe'), color: $r('sys.color.brand') },
    { image: $r('sys.symbol.pc_ic_tab_index'), name: $r('app.string.browser'), color: $r('sys.color.brand') },
  ],
  [
    {
      image: $r('sys.symbol.phone_arrow_down_left_circle_fill'),
      name: $r('app.string.dialer'),
      color: $r('sys.color.alert')
    },
    { image: $r('sys.symbol.cart_fill'), name: $r('app.string.shopping'), color: $r('sys.color.alert') },
    {
      image: $r('sys.symbol.checkmark_square_on_square_fill'),
      name: $r('app.string.notes'),
      color: $r('sys.color.alert')
    },
    {
      image: $r('sys.symbol.envelope_badge_dot_fill'),
      name: $r('app.string.settings'),
      color: $r('sys.color.alert')
    },
    { image: $r('sys.symbol.camera_fill'), name: $r('app.string.camera'), color: $r('sys.color.alert') },
    { image: $r('sys.symbol.picture_on_square'), name: $r('app.string.album'), color: $r('sys.color.alert') },
    { image: $r('sys.symbol.headphones_fill'), name: $r('app.string.music'), color: $r('sys.color.alert') },
    { image: $r('sys.symbol.template_fill'), name: $r('app.string.video'), color: $r('sys.color.alert') },
    {
      image: $r('sys.symbol.local_badge_plus_fill'),
      name: $r('app.string.map'),
      color: $r('sys.color.alert')
    },
    { image: $r('sys.symbol.creditcard_fill'), name: $r('app.string.wallet'), color: $r('sys.color.alert') },
    { image: $r('sys.symbol.key_shield_fill'), name: $r('app.string.safe'), color: $r('sys.color.alert') },
    {
      image: $r('sys.symbol.dot_circle_on_line_fill'),
      name: $r('app.string.browser'),
      color: $r('sys.color.alert')
    },
  ]
]