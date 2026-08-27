/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { BusinessError } from '@kit.BasicServicesKit';
import { resourceManager } from '@kit.LocalizationKit';
import { Constants } from '../Constants';
import Logger from './Logger';

const TAG: string = '[ResourceUtil]';

export class ResourceUtil {
  /**
   * Obtains the character string corresponding to the specified resource ID.
   *
   * @param resource resource.
   * @returns resource string
   */
  public static getString(resource: Resource): string {
    let resourceString: string = '';
    if (ResourceUtil.isEmptyObj(resource)) {
      Logger.error(TAG, 'Resource is invalid');
      return resourceString;
    }
    const resourceManager = ResourceUtil.getResourceManager();
    if (!resourceManager) {
      Logger.error(TAG, 'Context resourceManager unavailable');
      return resourceString;
    }
    try {
      resourceString = resourceManager.getStringSync(resource.id);
    } catch (error) {
      const err = error as BusinessError;
      Logger.error(TAG, `Failed to get resource. Cause :${err.code},  Message: ${err.message}.`);
    }
    return resourceString;
  }

  /**
   * Obtains the character string corresponding to the specified resource ID.
   *
   * @param resource resource.
   * @param ...args format array data
   * @returns resource format string
   */
  public static getFormatString(resource: Resource, ...args: Array<string | number>): string {
    let resourceString: string = '';
    if (ResourceUtil.isEmptyObj(resource)) {
      Logger.error(TAG, 'Resource is invalid');
      return resourceString;
    }
    const resourceManager = ResourceUtil.getResourceManager();
    if (!resourceManager) {
      Logger.error(TAG, 'Context resourceManager unavailable');
      return resourceString;
    }
    try {
      resourceString = resourceManager.getStringSync(resource.id, ...args);
    } catch (error) {
      const err = error as BusinessError;
      Logger.error(TAG, `Failed to get resource. Cause :${err.code},  Message: ${err.message}.`);
    }
    return resourceString;
  }

  /**
   * Obtains the resourceManager.
   *
   * @returns resourceManager or undefined
   */
  private static getResourceManager(): resourceManager.ResourceManager | undefined {
    const context: UIContext | undefined = AppStorage.get(Constants.KEY_UI_CONTEXT);
    const hostContext = context?.getHostContext();
    const resourceManager = hostContext?.resourceManager;
    return resourceManager;
  }

  /**
   * Check whether the object is empty.
   *
   * @param obj Objects to be checked.
   * @returns Return true if the object is empty or has no properties; Otherwise return false.
   */
  private static isEmptyObj(obj: Object): boolean {
    if (obj === null || typeof obj !== 'object') {
      return true;
    }
    return Object.keys(obj).length === 0;
  }
}