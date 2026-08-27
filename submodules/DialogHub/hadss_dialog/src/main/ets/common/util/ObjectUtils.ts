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

export class ObjectUtils {
  public static areSameClassPrototype(obj1: any, obj2: any): boolean {
    return Object.getPrototypeOf(obj1) === Object.getPrototypeOf(obj2);
  }

  public static createByPrototypeOf(obj: any): any {
    return (!obj) ?? Object.create(Object.getPrototypeOf(obj));
  }

  public static getEnumValue(obj: any) {
    let values: string[] = [];
    if (Object.getPrototypeOf(obj) === Object.prototype) {
      for (let key in obj) {
        values.push(obj[key]);
      }
    } else if (Object.getPrototypeOf(obj) === Array.prototype) {
      for (let i = 0; i < obj.length; i++) {
        for (let key in obj[i]) {
          values.push(obj[i][key]);
        }
      }
    }

    return values;
  }
}