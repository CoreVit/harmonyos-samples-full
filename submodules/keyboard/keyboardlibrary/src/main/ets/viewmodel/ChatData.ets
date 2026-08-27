/*
* Copyright (C) 2024 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
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

/**
 * Interface of chat.
 */
export interface Chat {
  sender: string;
  message: Resource;
}

/**
 * Information of chat.
 */
export const chatList: Chat[] = [
  {
    sender: 'myself',
    message: $r('app.string.chat_message1')
  },
  {
    sender: 'others',
    message: $r('app.string.chat_message2')
  },
  {
    sender: 'others',
    message: $r('app.string.chat_message3')
  },
  {
    sender: 'myself',
    message: $r('app.string.chat_message4')
  },
  {
    sender: 'myself',
    message: $r('app.string.chat_message5')
  },
  {
    sender: 'others',
    message: $r('app.string.chat_message6')
  }
];