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

import { CommonDialog } from '../../model/dialog/base/CommonDialog';
import { util } from '@kit.ArkTS';
import { SheetDialog } from '../../model/dialog/base/SheetDialog';
import { ObjectUtils } from './ObjectUtils';
import { DialogHub } from '../../model/DialogHub';
import { displaySync } from '@kit.ArkGraphics2D';
import { catchError } from './catchError';
import { DHubLogger } from '../../log/DHubLogger';

export class CommonUtils {
  private static syncUtil: displaySync.DisplaySync = displaySync.create();

  /**
   * Check if the dialog is a SheetDialog
   * @param dialog CommonDialog
   * @returns true: the dialog is a SheetDialog; false : the dialog is not a SheetDialog
   */
  public static isSheetDialog(dialog?: CommonDialog | null | undefined): boolean {
    return dialog?.constructor.name === SheetDialog.name;
  }

  /**
   * Generates a unique popup ID that identifies the popup object.
   * @param id
   * @returns string unique id
   */
  public static generateUniqueId(id?: number | string): string {
    let uniqueId = util.generateRandomUUID(false); // Timestamp + randomly generated uuid
    return id ? `${id}_` + uniqueId : uniqueId;
  }

  /**
   * If dst contains the same key in src, copy the value from src to dst
   * @param src the source element
   * @param dst the target element
   */
  public static simpleCopy<T extends Object, F extends Object>(src: T, dst: F) {
    for (let key of Reflect.ownKeys(src)) {
      if (Reflect.has(dst, key)) {
        Reflect.set(dst, key, Reflect.get(src, key));
      }
    }
  }

  public static copyOptions<T extends F, F extends Object>(dst: T, src: F, isFilterUndefined = false,
    isDeepCopy = false) {
    for (let key of Reflect.ownKeys(src)) {
      let newValue: ESObject = Reflect.get(src, key);
      let oldValue: ESObject = Reflect.get(dst, key) ?? ObjectUtils.createByPrototypeOf(newValue);

      if (!isFilterUndefined || newValue !== undefined) {
        if (isDeepCopy && typeof newValue === 'object' && typeof oldValue === 'object') {
          CommonUtils.copyOptions(oldValue, newValue, isFilterUndefined, isDeepCopy);
          Reflect.set(dst, key, oldValue);
        } else {
          Reflect.set(dst, key, newValue);
        }
      }
    }
  }

  public static str2Hex(color: string) {
    if (color.startsWith('rgb')) {
      let arr = color.split('(')[1].split(')')[0].split(',');
      let r = parseInt(arr[0], 10).toString(16);
      let g = parseInt(arr[1], 10).toString(16);
      let b = parseInt(arr[2], 10).toString(16);
      let a = arr[3] ? Math.round(parseFloat(arr[3]) * 255).toString(16) : '';
      r = r.length === 2 ? r : '0' + r;
      g = g.length === 2 ? g : '0' + g;
      b = b.length === 2 ? b : '0' + b;
      a = a.length === 2 ? a : (a.length === 0 ? '' : '0' + a);
      return '#' + a + r + g + b;
    }
    return color;
  }

  public static num2Hex(color: number) {
    return '#' + color.toString(16);
  }

  @catchError()
  public static res2Hex(color: Resource) {
    return '#' + DialogHub.getUIContext().getHostContext()?.resourceManager.getColorSync(color.id).toString(16);
  }

  public static resourceColor2Hex(resourceColor: ResourceColor): string {
    if (typeof (resourceColor) === 'number') {
      return CommonUtils.num2Hex(resourceColor);
    } else if (typeof (resourceColor) === 'string') {
      return CommonUtils.str2Hex(resourceColor);
    } else {
      return CommonUtils.res2Hex(resourceColor);
    }
  }

  public static hex2rgba(hex: string) {
    let color = hex.substring(1);
    let rgba = [255, 255, 255, 255];
    if (color.length >= 6) {
      rgba[2] = parseInt('0x' + color.slice(color.length - 2, color.length));
      rgba[1] = parseInt('0x' + color.slice(color.length - 4, color.length - 2));

      rgba[0] = parseInt('0x' + color.slice(color.length - 6, color.length - 4));

      let alpha = parseInt('0x' + color.slice(0, color.length - 6));
      rgba[3] = (isNaN(alpha) || alpha > 255 || alpha < 0) ? 255 : alpha;
    }
    return rgba;
  }

  @catchError()
  public static doSomethingNextFrame(action: () => void, condition?: () => boolean) {
    let callback = () => {};
    if (condition === undefined) {
      callback = () => {
        action();
        CommonUtils.syncUtil.off('frame', callback);
        CommonUtils.syncUtil.stop();
        DHubLogger.debug('displaySync Stop');
      }
    } else {
      callback = () => {
        DHubLogger.debug('displaySync Start Get Condition');
        const needStop = condition();
        if (needStop) {
          action();
          CommonUtils.syncUtil.off('frame', callback);
          CommonUtils.syncUtil.stop();
          DHubLogger.debug('displaySync Stop');
        }
      }
    }
    CommonUtils.syncUtil.on('frame', callback)
    DialogHub.getUIContext().runScopedTask(()=>{
      DHubLogger.debug('displaySync Start')
      CommonUtils.syncUtil.start();
    })
  }
}