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

import Logger from '../utils/Logger';
import { IProductItem } from './ProductItem';

const TAG = '[WaterFlowDataSource]';

/**
 * Water flow data source.
 */
export class WaterFlowDataSource implements IDataSource {
  public dataArray: IProductItem[] = [];
  private listeners: DataChangeListener[] = [];

  constructor(dataArray: IProductItem[]) {
    if (!dataArray) {
      Logger.error(TAG, 'Constructor parameter dataArray is null or undefined');
      return;
    }
    for (let i = 0; i < dataArray.length; i++) {
      this.dataArray.push(dataArray[i]);
    }
  }

  /**
   * Set water flow data array.
   *
   * @param {IProductItem[]} productDataArray Displaying water flow Data.
   */
  public setDataArray(productDataArray: IProductItem[]): void {
    if (!productDataArray) {
      Logger.error(TAG, 'setDataArray parameter productDataArray is null or undefined');
      return;
    }
    this.dataArray = productDataArray;
  }

  /**
   * Get the total number of data records.
   */
  public totalCount(): number {
    return this.dataArray.length;
  }

  /**
   * Get the data corresponding to the index.
   *
   * @param {number} index Data index.
   * @returns Return IProductItem.
   */
  public getData(index: number): IProductItem | undefined {
    if (index < 0 || index >= this.dataArray.length) {
      Logger.error(TAG, `Index out of bounds: ${index}`);
      return undefined;
    }
    return this.dataArray[index];
  }

  /**
   * Register a controller that changes data.
   *
   * @param {DataChangeListener} listener Data change listener
   */
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  /**
   * Register a controller that changes data.
   *
   * @param {DataChangeListener} listener  Data change listener
   */
  unregisterDataChangeListener(listener: DataChangeListener): void {
    let pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }

  public addMoreData(productDataArray: IProductItem[]): void {
    if (!productDataArray || productDataArray.length === 0) {
      Logger.error(TAG, 'addMoreData parameter productDataArray is null, undefined or empty');
      return;
    }
    let idIndex = this.dataArray.length;
    for (let tmp of productDataArray) {
      tmp.id = idIndex + 1;
      this.dataArray.push(tmp);
      idIndex++;
    }
    this.notifyDataAdd(this.dataArray.length - 1);
  }

  public refreshData(productDataArray: IProductItem[]) {
    if (!productDataArray) {
      Logger.error(TAG, 'refreshData parameter productDataArray is null or undefined');
      this.dataArray = [];
      this.listeners.forEach(listener => {
        listener.onDataReloaded();
      })
      return;
    }
    this.dataArray = [];
    for (let tmp of productDataArray) {
      this.dataArray.push(tmp);
    }
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  public deleteItem(id: number): void {
    let delIndex = -1;
    for (let i = 0; i < this.dataArray.length; i++) {
      if (this.dataArray[i].id === id) {
        delIndex = i;
        this.dataArray.splice(delIndex, 1);
        this.notifyDataDelete(delIndex);
        break;
      }
    }
  }
}