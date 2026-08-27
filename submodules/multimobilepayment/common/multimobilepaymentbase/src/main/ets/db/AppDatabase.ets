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

import { PaymentData } from '../data/PaymentData';

/**
 * Application database singleton class
 * Manages static data for business items, tabs, quick actions, images, and scan modes
 */
export class AppDatabase {
  private static instance: AppDatabase;
  private businessList: PaymentData[] = [];
  private tabList: PaymentData[] = [];
  private quickActionList: PaymentData[] = [];
  private imageList: PaymentData[] = [];
  private wealthList: PaymentData[] = [];
  private scanList: PaymentData[] = [];

  /**
   * Get the singleton instance of AppDatabase
   * @returns AppDatabase instance
   */
  public static getInstance(): AppDatabase {
    if (!AppDatabase.instance) {
      AppDatabase.instance = new AppDatabase();
    }
    return AppDatabase.instance;
  }

  private constructor() {
    this.initData();
  }

  /**
   * Initialize all data lists
   */
  private initData(): void {
    this.businessList = [
      { text: $r('app.string.fund'), icon: $r('sys.symbol.Investment_stable_value_add') },
      { text: $r('app.string.wealth'), icon: $r('sys.symbol.financial_management') },
      { text: $r('app.string.credit_card'), icon: $r('sys.symbol.creditcard') },
      { text: $r('app.string.bills'), icon: $r('sys.symbol.list_square_bill') },
      { text: $r('app.string.metals'), icon: $r('sys.symbol.display_products') },
      { text: $r('app.string.deposit'), icon: $r('sys.symbol.yuansign_arrow_counterclockwise') },
      { text: $r('app.string.loan'), icon: $r('sys.symbol.phone_recharge_1') },
      { text: $r('app.string.profit'), icon: $r('sys.symbol.yuansign_circle_and_hand') },
      { text: $r('app.string.profit'), icon: $r('sys.symbol.yuansign_circle_and_hand') },
      { text: $r('app.string.profit'), icon: $r('sys.symbol.yuansign_circle_and_hand') },
      { text: $r('app.string.profit'), icon: $r('sys.symbol.yuansign_circle_and_hand') },
      { text: $r('app.string.profit'), icon: $r('sys.symbol.yuansign_circle_and_hand') },
      { text: $r('app.string.profit'), icon: $r('sys.symbol.yuansign_circle_and_hand') },
      { text: $r('app.string.profit'), icon: $r('sys.symbol.yuansign_circle_and_hand') },
      { text: $r('app.string.profit'), icon: $r('sys.symbol.yuansign_circle_and_hand') },
      { text: $r('app.string.more'), icon: $r('sys.symbol.ellipsis_circle') }
    ];
    this.tabList = [
      { text: $r('app.string.tab_home'), icon: $r('sys.symbol.house_fill') },
      { text: $r('app.string.tab_wealth'), icon: $r('sys.symbol.financial_management') },
      { text: $r('app.string.tab_life'), icon: $r('sys.symbol.bolt_fill') },
      { text: $r('app.string.tab_message'), icon: $r('sys.symbol.ellipsis_message_fill') },
      { text: $r('app.string.tab_mine'), icon: $r('sys.symbol.person_crop_circle_fill_1') }
    ];
    // Quick action list - corresponds to 4 quick actions in the design
    this.quickActionList = [
      { text: $r('app.string.scan'), icon: $r('sys.symbol.line_viewfinder') },
      { text: $r('app.string.payment_code'), icon: $r('sys.symbol.yuansign_arrow_2_squarepath') },
      { text: $r('app.string.travel'), icon: $r('sys.symbol.paperplane_fill') },
      { text: $r('app.string.card_bag'), icon: $r('sys.symbol.bank_card') }
    ];
    // Image list - wealth selection
    this.imageList = [
      { text: '', icon: $r('app.media.image01') },
      { text: '', icon: $r('app.media.image02') },
      { text: '', icon: $r('app.media.image03') },
      { text: '', icon: $r('app.media.image04') }
    ];
    this.wealthList = [
      { text: '', icon: $r('app.media.wealth_image01') },
      { text: '', icon: $r('app.media.wealth_image02') },
      { text: '', icon: $r('app.media.wealth_image03') },
      { text: '', icon: $r('app.media.wealth_image04') },
      { text: '', icon: $r('app.media.wealth_image05') },
      { text: '', icon: $r('app.media.wealth_image06') },
      { text: '', icon: $r('app.media.wealth_image07') },
      { text: '', icon: $r('app.media.wealth_image08') },
      { text: '', icon: $r('app.media.wealth_image09') },
      { text: '', icon: $r('app.media.wealth_image10') },
      { text: '', icon: $r('app.media.wealth_image11') },
      { text: '', icon: $r('app.media.wealth_image12') },
      { text: '', icon: $r('app.media.wealth_image13') },
      { text: '', icon: $r('app.media.wealth_image14') },
      { text: '', icon: $r('app.media.wealth_image15') },
      { text: '', icon: $r('app.media.wealth_image16') }
    ];
    this.scanList = [
      { text: $r('app.string.mode_scan'), icon: undefined },
      { text: $r('app.string.mode_recognize'), icon: undefined },
      { text: $r('app.string.mode_ar'), icon: undefined }
    ];
  }

  /**
   * Get the list of business items
   * @returns Array of PaymentData containing business information
   */
  public getBusinessList(): PaymentData[] {
    return this.businessList;
  }

  /**
   * Get the list of tab items
   * @returns Array of PaymentData containing tab information
   */
  public getTabList(): PaymentData[] {
    return this.tabList;
  }

  /**
   * Get the list of quick action items
   * @returns Array of PaymentData containing quick action information
   */
  public getQuickActionList(): PaymentData[] {
    return this.quickActionList;
  }

  /**
   * Get the list of image items
   * @returns Array of PaymentData containing image information
   */
  public getImageList(): PaymentData[] {
    return this.imageList;
  }

  /**
   * Get the list of wealth image items
   * @returns Array of PaymentData containing image information
   */
  public getWealthList(): PaymentData[] {
    return this.wealthList;
  }

  /**
   * Get the list of scan mode items
   * @returns Array of PaymentData containing scan mode information
   */
  public getScanList(): PaymentData[] {
    return this.scanList;
  }
}