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
import { CommonConstants } from '../constants/CommonConstants';

export class TabBarListModel {
  loadTabs(): TabBarModel[] {
    return [
      {
        index: CommonConstants.TAB_MESSAGE_INDEX,
        img: $r('app.media.icon_message'),
        selectImg: $r('app.media.icon_message_selected'),
        title: $r('app.string.Message')
      },
      {
        index: CommonConstants.TAB_CONTACT_INDEX,
        img: $r('app.media.icon_contacts'),
        selectImg: $r('app.media.icon_contacts_selected'),
        title: $r('app.string.Contacts')
      },
      {
        index: CommonConstants.TAB_SOCIAL_INDEX,
        img: $r('app.media.icon_social_circle'),
        selectImg: $r('app.media.icon_social_circle_selected'),
        title: $r('app.string.SocialCircle')
      },
      {
        index: CommonConstants.TAB_MINE_INDEX,
        img: $r('app.media.icon_me'),
        selectImg: $r('app.media.icon_me_select'),
        title: $r('app.string.Me')
      }
    ]
  };
}

export interface TabBarModel {
  index: number;
  img: Resource;
  selectImg?: Resource;
  title: Resource;
}