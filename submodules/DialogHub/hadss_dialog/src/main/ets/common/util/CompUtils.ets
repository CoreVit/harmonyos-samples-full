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

import { DHubLogger } from '../../log/DHubLogger';
import { DialogError } from '../../log/ErrorCode';

export class CompUtils {
  static judgeID(uiContext: UIContext, id: string): boolean {
    DHubLogger.debug(`judgeID ${id} start`);
    let node = uiContext.getFrameNodeById(id);
    if (node === null) {
      DHubLogger.error(DialogError.NODE_ID_WITHOUT, id);
      return false
    } else {
      return true
    }
  }


  /**
   * Determine whether are a node of type NavDestination or whether ancestor has a node of type NavDestination
   * @param uiContext
   * @param targetId
   */
  static isIdValid(uiContext: UIContext, id: string) {
    let node = uiContext.getFrameNodeById(id);
    if (!node) {
      DHubLogger.error(DialogError.NODE_ID_WITHOUT, id);
      return false;
    }
    while (node) {
      if (node.getNodeType() == 'NavDestination') {
        return true;
      }
      node = node.getParent();
    }
    return true;
  }
}