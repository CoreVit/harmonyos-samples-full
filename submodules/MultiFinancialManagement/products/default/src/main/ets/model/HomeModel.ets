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

export class HomeModel {
  private businessList: Menu[];

  constructor() {
    this.businessList = [
      { id: 1, name: $r('app.string.account_inquiry'), icon: $r('sys.symbol.yuan_clipboard_fill'), isMain: true },
      { id: 2, name: $r('app.string.transfer_remittance'), icon: $r('sys.symbol.coins_badge_coin_fill'), isMain: true },
      { id: 3, name: $r('app.string.borrow_loan'), icon: $r('sys.symbol.copper_coin_and_hand_fill'), isMain: true },
      { id: 4, name: $r('app.string.asset_overview'), icon: $r('sys.symbol.data_proportion_fill'), isMain: true },
      { id: 5, name: $r('app.string.fund_investment'), icon: $r('sys.symbol.externaldrive_fill_3') },
      { id: 6, name: $r('app.string.wealth_management_products'), icon: $r('sys.symbol.bag_fill') },
      { id: 7, name: $r('app.string.view_bills'), icon: $r('sys.symbol.eye') },
      { id: 8, name: $r('app.string.branch_information'), icon: $r('sys.symbol.worldclock_fill') },
      { id: 9, name: $r('app.string.wealth_no_1'), icon: $r('sys.symbol.fast_fill') },
      { id: 10, name: $r('app.string.investment_calendar'), icon: $r('sys.symbol.calendar_fill') },
      { id: 11, name: $r('app.string.pension'), icon: $r('sys.symbol.heart_house_fill') },
      { id: 12, name: $r('app.string.life_payments'), icon: $r('sys.symbol.person_badge_heart_fill') },
      { id: 13, name: $r('app.string.deposit_products'), icon: $r('sys.symbol.doc_text_fill') },
      { id: 14, name: $r('app.string.loans'), icon: $r('sys.symbol.creditcard_fill') },
      { id: 15, name: $r('app.string.make_repayment'), icon: $r('sys.symbol.checkmark_clipboard_fill') },
      { id: 16, name: $r('app.string.account_application'), icon: $r('sys.symbol.folder_fill') },
      { id: 17, name: $r('app.string.announcements'), icon: $r('sys.symbol.bell_fill') },
      { id: 18, name: $r('app.string.income_expense_ledger'), icon: $r('sys.symbol.doc_plaintext_fill') },
      { id: 19, name: $r('app.string.community'), icon: $r('sys.symbol.person_2_fill') },
      { id: 20, name: $r('app.string.more'), icon: $r('sys.symbol.square_fill_grid_2x2') }
    ]
  }

  getBusinessList(): Menu[] {
    return this.businessList;
  }
}

export interface Menu {
  id: number;
  name: Resource;
  icon: Resource;
  isMain?: boolean;
}
