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

export class ShareIndex {
  public title: ResourceStr;
  public index: string;
  public priceLimit: string;

  constructor(title: ResourceStr, index: string, priceLimit: string) {
    this.title = title;
    this.index = index;
    this.priceLimit = priceLimit;
  }
}

export class StockForm {
  public title: ResourceStr; // Stock Name
  public stockNumber: ResourceStr; // Stock Number
  public latestPrice: number; // Latest Price
  public highsAndLows: number; // HighLow
  public priceLimit: ResourceStr; // Price Limit
  public gross: ResourceStr; // Gross
  public impressions: ResourceStr; // Impressions
  public plate: ResourceStr // Stock sector
  public plateFontColor: ResourceColor; // Font color of the stock section
  public plateBackgroundColor: ResourceColor; // Background color of the stock section
  public volumeTransaction: ResourceStr; // volume of transaction
  public amplitude: ResourceStr; // Amplitude
  public changeHands: ResourceStr; // Change Hands
  public peg: number; // P/E ratio (price-to-earnings ratio)
  public pb: number; // pb(price/book value ratio)

  constructor(title: ResourceStr, stockNumber: ResourceStr, latestPrice: number, highsAndLows: number,
    priceLimit: ResourceStr, gross: ResourceStr, impressions: ResourceStr, plate: ResourceStr,
    plateFontColor: ResourceColor, plateBackgroundColor: ResourceColor, volumeTransaction: ResourceStr,
    amplitude: ResourceStr, changeHands: ResourceStr, peg: number, pb: number) {
    this.title = title;
    this.stockNumber = stockNumber;
    this.latestPrice = latestPrice;
    this.highsAndLows = highsAndLows;
    this.priceLimit = priceLimit;
    this.gross = gross;
    this.impressions = impressions;
    this.plate = plate;
    this.plateFontColor = plateFontColor;
    this.plateBackgroundColor = plateBackgroundColor;
    this.volumeTransaction = volumeTransaction;
    this.amplitude = amplitude;
    this.changeHands = changeHands;
    this.peg = peg;
    this.pb = pb;
  }
}

export interface StockDetailsParams {
  item?: StockForm;
  isPcStockTable: boolean;
}

export interface StockFormItem {
  title: ResourceStr;
  value: ResourceStr;
  color: ResourceStr;
}

export class StockInForm {
  public items: StockFormItem[];

  constructor(items: StockFormItem[]) {
    this.items = items;
  }
}

export class TransactionDetails {
  public title: ResourceStr;
  public price: string;
  public amount: number;

  constructor(title: ResourceStr, price: string, amount: number) {
    this.title = title;
    this.price = price;
    this.amount = amount;
  }
}

