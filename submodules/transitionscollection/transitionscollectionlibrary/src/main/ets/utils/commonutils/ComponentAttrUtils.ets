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

import { componentUtils, UIContext } from '@kit.ArkUI';
import CommonConstants from '../../common/CommonConstants';
import Logger from '../Logger';


export class ComponentAttrUtils {
  // Gets the location information of a component based on its id.
  public static getRectInfoById(context: UIContext, id: string): RectInfoInPx {
    if (!context || !id) {
      throw CommonConstants.EMPTY_OBJECT_EXCEPTION;
    }
    try {
      let componentInfo: componentUtils.ComponentInfo = context.getComponentUtils().getRectangleById(id);
      if (!componentInfo) {
        throw CommonConstants.EMPTY_OBJECT_EXCEPTION;
      }
      let rstRect: RectInfoInPx = new RectInfoInPx();
      const widthScaleGap = componentInfo.size.width * (1 - componentInfo.scale.x) / 2;
      const heightScaleGap = componentInfo.size.height * (1 - componentInfo.scale.y) / 2;
      rstRect.left = componentInfo.translate.x + componentInfo.windowOffset.x + widthScaleGap;
      rstRect.top = componentInfo.translate.y + componentInfo.windowOffset.y + heightScaleGap;
      rstRect.right =
        componentInfo.translate.x + componentInfo.windowOffset.x + componentInfo.size.width - widthScaleGap;
      rstRect.bottom =
        componentInfo.translate.y + componentInfo.windowOffset.y + componentInfo.size.height - heightScaleGap;
      rstRect.width = rstRect.right - rstRect.left;
      rstRect.height = rstRect.bottom - rstRect.top;
      return {
        left: rstRect.left,
        right: rstRect.right,
        top: rstRect.top,
        bottom: rstRect.bottom,
        width: rstRect.width,
        height: rstRect.height
      };
    } catch (error) {
      Logger.error('ComponentAttrUtils', 'componentInfo failed ' + JSON.stringify(error));
      return {
        left: 0,
        right: 0,
        top: 0,
        bottom: 0,
        width: 0,
        height: 0
      };
    }

  }
}

export class RectInfoInPx {
  public left: number = 0;
  public top: number = 0;
  public right: number = 0;
  public bottom: number = 0;
  public width: number = 0;
  public height: number = 0;
}

export class RectJson {
  public $rect: number[] = [];
}