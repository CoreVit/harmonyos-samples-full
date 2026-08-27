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
import { DialogHub } from '../../model/DialogHub';
import { LengthUnit } from '@kit.ArkUI';
import { catchError } from './catchError';

export class DimensionUtils {
  public static length2px(length: Length, reference?: number): number {
    if (typeof (length) == 'string') {
      return DimensionUtils.stirng2Px(length as string, reference);
    } else if (typeof (length) == 'object') {
      return DimensionUtils.resource2Px(length as Resource);
    }
    return DialogHub.getUIContext().vp2px(length as number);
  }

  public static length2vp(length: Length, reference?: number): number {
    return DialogHub.getUIContext().px2vp(DimensionUtils.length2px(length, reference));
  }

  public static stirng2Px(str: string, reference?: number): number {
    if (str.indexOf('%') >= 0) {
      reference = reference ?? 0;
      return (reference * (parseInt(str) / 100));
    } else if (str.indexOf('px') >= 0) {
      return parseInt(str);
    } else if (str.indexOf('fp') >= 0) {
      return DialogHub.getUIContext().fp2px(parseInt(str));
    } else if (str.indexOf('lpx') >= 0) {
      return DialogHub.getUIContext().lpx2px(parseInt(str));
    } else {
      return DialogHub.getUIContext().vp2px(parseInt(str));
    }
  }

  @catchError()
  public static resource2Px(res: Resource): number {
    let resourceVpx = DialogHub.getUIContext().getHostContext()?.resourceManager.getNumber(res.id) ?? 0;
    return resourceVpx;
  }

  public static dimension2LengthMetrics(len: Dimension): LengthMetrics {
    let lenNum = 0;
    let lenUnit: LengthUnit = LengthUnit.VP;
    if (typeof len === 'string') {
      if (len.endsWith('vp')) {
        lenNum = parseInt(len.substring(0, len.length - 2));
        lenUnit = LengthUnit.VP;
      } else if (len.endsWith('px')) {
        lenNum = parseInt(len.substring(0, len.length - 2));
        lenUnit = LengthUnit.PX;
      } else if (len.endsWith('fp')) {
        lenNum = parseInt(len.substring(0, len.length - 2));
        lenUnit = LengthUnit.FP;
      } else if (len.endsWith('lpx')) {
        lenNum = parseInt(len.substring(0, len.length - 3));
        lenUnit = LengthUnit.LPX;
      } else if (len.endsWith('%')) {
        lenNum = parseInt(len.substring(0, len.length - 1));
        lenUnit = LengthUnit.PERCENT;
      } else {
        // use default value 0vp
      }
    } else if (typeof len == 'number') {
      lenNum = len;
      lenUnit = LengthUnit.VP;
    } else {
      lenNum = DimensionUtils.resource2Px(len);
      lenUnit = LengthUnit.PX;
    }
    return {
      value: lenNum,
      unit: lenUnit
    };
  }
}