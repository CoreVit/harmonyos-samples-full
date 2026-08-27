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
import { StockForm, StockInForm, TransactionDetails } from '@stock/base';

const STOCK_FORM_DATA: StockForm[] = [
  new StockForm($r('app.string.somebody_technology'), '60**39', 904, +0.04, '+0.53%', '310511', '1232',
    $r('app.string.securities_margin_trading'), $r('app.color.securities_tag_font_color'),
    $r('app.color.securities_tag_background_color'), '12.5', '8.88%', '18.81%', 123, 1.5),
  new StockForm($r('app.string.certain_estate_company'), '60**19', 182104, +3.04, '+0.19%', '30176', '550',
    $r('app.string.securities_margin_trading'), $r('app.color.securities_tag_font_color'),
    $r('app.color.securities_tag_background_color'), '15.5', '8.98%', '15.81%', 112, 1.1),
  new StockForm($r('app.string.certain_pharmaceutical_company'), '30**89', 1520, -0.16, '-1.04%', '19593', '3461',
    $r('app.string.growth_enterprise_market'), $r('app.color.growth_tag_font_color'),
    $r('app.color.growth_tag_background_color'), '13.5', '6.58%', '19.81%', 116, 1.9),
  new StockForm($r('app.string.somebody_technology'), '60**99', 2001, +3.04, '+0.19%', '7071', '4890',
    $r('app.string.securities_margin_trading'), $r('app.color.securities_tag_font_color'),
    $r('app.color.securities_tag_background_color'), '10.5', '8.86%', '13.81%', 105, 1.5),
  new StockForm($r('app.string.certain_estate_company'), '30**59', 2432, +0.16, '+1.04%', '6953', '1321',
    $r('app.string.growth_enterprise_market'), $r('app.color.growth_tag_font_color'),
    $r('app.color.growth_tag_background_color'), '19.9', '6.88%', '12.81%', 108, 1.2)
];

const STOCK_INFORM_LIST_DATA: StockInForm[] = [
  new StockInForm([
    { title: $r('app.string.now_begins'), value: '19.86', color: $r('app.color.price_rise_color') },
    { title: $r('app.string.yesterday_close'), value: '19.84', color: $r('app.color.text_primary_color') },
    { title: $r('app.string.turnover_rate'), value: '0.39%', color: $r('app.color.text_primary_color') }
  ]),
  new StockInForm([
    { title: $r('app.string.tallest'), value: '19.86', color: $r('app.color.price_rise_color') },
    { title: $r('app.string.lowest'), value: '19.84', color: $r('app.color.price_fall_color') },
    { title: $r('app.string.PEG'), value: '95.32', color: $r('app.color.text_primary_color') }
  ]),
  new StockInForm([
    { title: $r('app.string.turnover'), value: $r('app.string.text_hands'), color: $r('app.color.text_primary_color') },
    {
      title: $r('app.string.volume_transaction'),
      value: $r('app.string.turnover_value'),
      color: $r('app.color.text_primary_color')
    },
    {
      title: $r('app.string.total_value'),
      value: $r('app.string.text_billion'),
      color: $r('app.color.text_primary_color')
    }
  ]),
  new StockInForm([
    { title: $r('app.string.now_begins'), value: '19.86', color: $r('app.color.price_rise_color') },
    { title: $r('app.string.yesterday_close'), value: '19.84', color: $r('app.color.text_primary_color') },
    { title: $r('app.string.turnover_rate'), value: '0.39%', color: $r('app.color.text_primary_color') }
  ])
];

const CYCLE_TITLE_DATA: ResourceStr[] = [
  $r('app.string.time_share'), $r('app.string.five_days'), $r('app.string.daily_k'), $r('app.string.week_k'),
  $r('app.string.month_k'), $r('app.string.season_k'), $r('app.string.half_year_k'), $r('app.string.year_k')
];

const OTHER_TITLE_DATA: ResourceStr[] = [
  $r('app.string.discussion'), $r('app.string.must_read'), $r('app.string.research_report'),
  $r('app.string.capital'), $r('app.string.datum'), $r('app.string.announcements'),
  $r('app.string.finance'), $r('app.string.information'), $r('app.string.related_fund')
];

const STOCK_TITLE_DATA: Resource[] = [
  $r('app.string.stock_name'), $r('app.string.latest_price'), $r('app.string.highs_and_lows'),
  $r('app.string.price_limit'), $r('app.string.gross'), $r('app.string.impressions'),
  $r('app.string.volume_transaction'), $r('app.string.amplitude'), $r('app.string.change_hands'),
  $r('app.string.PEG'), $r('app.string.PB')
];

const PC_STOCK_TITLE_DATA: Resource[] = [
  $r('app.string.stock_name'), $r('app.string.price_limit_and_latest_price'),
];

const BUY_SELL_SHARES_DATA: TransactionDetails[] = [
  new TransactionDetails($r('app.string.text_buy'), '20.05', 11),
  new TransactionDetails($r('app.string.text_buy'), '20.04', 22),
  new TransactionDetails($r('app.string.text_buy'), '20.03', 33),
  new TransactionDetails($r('app.string.text_buy'), '20.02', 55),
  new TransactionDetails($r('app.string.text_buy'), '20.01', 66)
];

export class StockDetailDataService {
  private stockFormList: StockForm[] = STOCK_FORM_DATA;
  private stockInFormList: StockInForm[] = STOCK_INFORM_LIST_DATA;
  private cycleTitleList: ResourceStr[] = CYCLE_TITLE_DATA;
  private otherTitleList: ResourceStr[] = OTHER_TITLE_DATA;
  private stockTitleList: Resource[] = STOCK_TITLE_DATA;
  private pcStockTitleList: Resource[] = PC_STOCK_TITLE_DATA;
  private buySellSharesList: TransactionDetails[] = BUY_SELL_SHARES_DATA;

  getStockFormList(): StockForm[] {
    return this.stockFormList;
  }

  getStockInFormList(): StockInForm[] {
    return this.stockInFormList;
  }

  getStockFormByIndex(index: number): StockForm | undefined {
    if (index >= 0 && index < this.stockFormList.length) {
      return this.stockFormList[index];
    }
    return undefined;
  }

  getStockInFormByIndex(index: number): StockInForm | undefined {
    if (index >= 0 && index < this.stockInFormList.length) {
      return this.stockInFormList[index];
    }
    return undefined;
  }

  getStockFormCount(): number {
    return this.stockFormList.length;
  }

  getStockInFormCount(): number {
    return this.stockInFormList.length;
  }

  getCycleTitleList(): ResourceStr[] {
    return this.cycleTitleList;
  }

  getOtherTitleList(): ResourceStr[] {
    return this.otherTitleList;
  }

  getStockTitleList(): Resource[] {
    return this.stockTitleList;
  }

  getPcStockTitleList(): Resource[] {
    return this.pcStockTitleList;
  }

  getBuySellSharesList(): TransactionDetails[] {
    return this.buySellSharesList;
  }
}