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
import { AccountConstants } from '../constants/AccountConstants';

export class AccountModel {
  private messageList: Message[];
  private summaryList: Summary[];

  constructor() {
    this.messageList = [
      { tag: $r('app.string.message_announcement'), content: $r('app.string.message_announcement_content'), tagFontColor: $r('app.color.alert'), tagBgColor: $r('app.color.alert10') },
      { tag: $r('app.string.message_transaction'), content: $r('app.string.message_transaction_content'), tagFontColor: $r('app.color.background_emphasize'), tagBgColor: $r('app.color.comp_emphasize_tertiary') },
      { tag: $r('app.string.message_selection'), content: $r('app.string.message_selection_content'), tagFontColor: $r('app.color.confirm'), tagBgColor: $r('app.color.confirm20') },
    ]
    this.summaryList = [
      { name: $r('app.string.account_demand'), amount: AccountConstants.DEMAND_AMOUNT },
      { name: $r('app.string.account_investment'), amount: AccountConstants.INVESTMENT_AMOUNT },
      { name: $r('app.string.account_monthly_interest_due'), amount: AccountConstants.LIABILITY_AMOUNT }
    ]
  }

  getMessageList(): Message[] {
    return this.messageList;
  }

  getSummaryList(): Summary[] {
    return this.summaryList;
  }
}

export interface Message {
  tag: Resource;
  content: Resource;
  tagFontColor: Resource;
  tagBgColor: Resource;
}

export interface Summary {
  name: Resource;
  amount: string;
}
