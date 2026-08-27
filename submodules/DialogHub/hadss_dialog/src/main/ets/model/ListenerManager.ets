/*
 * Copyright (c) 2022-2025 Huawei Device Co., Ltd.
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

export abstract class ListenerManager<T> {
  protected listeners: Array<T>;

  constructor() {
    this.listeners = [];
  }

  /**
   * Add listener in manager.
   */
  public addListener(listener: T) {
    this.listeners.push(listener);
  }

  /**
   * Remove listener in manager.
   */
  public removeListener(listener: T) {
    let index = this.listeners.indexOf(listener);
    this.listeners.splice(index, 1);
  }

  /**
   * Remove all listeners in manager.
   */
  public removeAllListener() {
    this.listeners.splice(0, this.listeners.length);
    this.listeners.length = 0;
  }
}