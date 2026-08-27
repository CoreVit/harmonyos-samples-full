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

import curves from '@ohos.curves';
import { CommonConstants } from '../common/constants/CommonConstants';
import Logger from '../utils/Logger';
import { ListItemModifier } from './AttributeModifier';

const TAG: string = '[ListExchangeCtrl]';

/**
 * Operation Status Enumeration
 */
enum OperationStatus {
  IDLE,
  PRESSING,
  MOVING,
  DROPPING,
  DELETE
}

/**
 * List item toggle control
 */
@Observed
export class ListExchangeCtrl<T> {
  private deductionData: T[];
  private modifier: ListItemModifier[];
  private dragRefOffset: number = 0;
  private offsetY: number = 0;
  public operationStatus: OperationStatus = OperationStatus.IDLE;
  private mContext: UIContext;

  constructor(deductionData: T[], context: UIContext) {
    this.mContext = context;
    this.deductionData = deductionData;
    this.modifier = [];
    deductionData.forEach(() => {
      this.modifier.push(new ListItemModifier());
    })
  }

  /**
   * Gets the properties of the ListItem
   * @param item
   * @returns Returns the custom property object
   */
  getModifier(item: T): ListItemModifier {
    const index: number = this.deductionData.indexOf(item);
    if (index < 0 || index >= this.modifier.length) {
      Logger.warn(TAG, `getModifier: Invalid index ${index} for modifier array (length: ${this.modifier.length})`);
      return new ListItemModifier();
    }
    return this.modifier[index];
  }

  /**
   * List long press function
   * @param item
   */
  onLongPress(item: T): void {
    const index: number = this.deductionData.indexOf(item);
    this.dragRefOffset = 0;
    this.mContext.animateTo({ curve: Curve.Friction, duration: CommonConstants.ANIMATE_DURATION }, () => {
      this.operationStatus = OperationStatus.PRESSING;
      if (index >= 0 && index < this.modifier.length) {
        this.modifier[index].hasShadow = true;
        this.modifier[index].scale = 1.04;
      }
    })
  }

  /**
   * ListItem move function
   * @param item
   * @param offsetY
   */
  onMove(item: T, offsetY: number): void {
    // Get the index of the current component
    const index: number = this.deductionData.indexOf(item);
    this.offsetY = offsetY - this.dragRefOffset;
    this.modifier[index].offsetY = this.offsetY;
    const direction: number = this.offsetY > 0 ? 1 : -1;
    // Animation of zooming out and restoring the covered sub-component when dragging is triggered
    const curveValue: ICurve = curves.initCurve(Curve.Sharp);
    const value: number = curveValue.interpolate(Math.abs(this.offsetY) / CommonConstants.ITEM_HEIGHT);
    // Calculate Scaling
    const shrinkScale: number = 1 - value / 10;
    if (index + 1 >= 0 && index + 1 < this.modifier.length) {
      this.modifier[index + 1].scale = direction > 0 ? shrinkScale : 1;
    }
    if (index - 1 >= 0 && index - 1 < this.modifier.length) {
      this.modifier[index - 1].scale = direction > 0 ? 1 : shrinkScale;
    }
    // Toggle Actions for List Items
    if (Math.abs(this.offsetY) > CommonConstants.ITEM_HEIGHT / 2) {
      this.mContext.animateTo({ curve: Curve.Friction, duration: CommonConstants.ANIMATE_DURATION }, () => {
        this.offsetY -= direction * CommonConstants.ITEM_HEIGHT;
        this.dragRefOffset += direction * CommonConstants.ITEM_HEIGHT;
        if (index >= 0 && index < this.modifier.length) {
          this.modifier[index].offsetY = this.offsetY;
        }
        this.changeItem(index, index + direction);
      })
    }
  }

  /**
   * ListItem place function
   * @param item
   */
  onDrop(item: T): void {
    Logger.info(TAG, `onDrop start`);
    const index: number = this.deductionData.indexOf(item);
    this.dragRefOffset = 0;
    this.offsetY = 0;
    AppStorage.setOrCreate(CommonConstants.AS_KEY_IS_LONG_PRESS, false);

    /**
     * Resumes the zoomed-out subcomponent that is being dragged and provides the animation
     * Construct an interpolator spring curve object
     * Initial velocity is 0,Quality is 1,Stiffness is 400,Damping is 38
     */
    this.mContext.animateTo({ curve: curves.interpolatingSpring(0, 1, 400, 38) }, () => {
      this.operationStatus = OperationStatus.DROPPING;
      if (index + 1 >= 0 && index + 1 < this.modifier.length) {
        this.modifier[index + 1].scale = 1;
      }
      if (index - 1 >= 0 && index - 1 < this.modifier.length) {
        this.modifier[index - 1].scale = 1;
      }
    })

    /**
     * Restores the zoom-in and shadow effects of the dragged subcomponent and provides animations
     * Construct an interpolator spring curve object
     * Initial velocity is 14,Quality is 1,Stiffness is 170,Damping is 17
     */
    this.mContext.animateTo({ curve: curves.interpolatingSpring(14, 1, 170, 17) }, () => {
      this.operationStatus = OperationStatus.IDLE;
      if (index >= 0 && index < this.modifier.length) {
        this.modifier[index].hasShadow = false;
        this.modifier[index].scale = 1;
        this.modifier[index].offsetY = 0;
      }
    })
    Logger.info(TAG, `onDrop end`);
  }

  /**
   * ListItem Swap Position
   * @param index
   * @param newIndex
   */
  changeItem(index: number, newIndex: number): void {
    const tmp: T[] = this.deductionData.splice(index, 1);
    if (tmp.length > 0 && tmp[0]) {
      this.deductionData.splice(newIndex, 0, tmp[0]);
    }
    const tmp2: ListItemModifier[] = this.modifier.splice(index, 1);
    if (tmp2.length > 0 && tmp2[0]) {
      this.modifier.splice(newIndex, 0, tmp2[0]);
    }
  }

  /**
   * Delete List Item
   * @param item
   */
  deleteItem(item: T): void {
    const index: number = this.deductionData.indexOf(item);
    if (index < 0 || index >= this.deductionData.length) {
      return;
    }
    this.dragRefOffset = 0;
    this.mContext.animateTo({
      curve: Curve.Friction, duration: CommonConstants.ANIMATE_DURATION, onFinish: () => {
        this.mContext.animateTo({
          curve: Curve.Friction, duration: CommonConstants.ANIMATE_DURATION, onFinish: () => {
            this.operationStatus = OperationStatus.IDLE;
          }
        }, () => {
          this.modifier.splice(index, 1);
          this.deductionData.splice(index, 1);
        })
      }
    }, () => {
      this.operationStatus = OperationStatus.DELETE;
      if (index >= 0 && index < this.modifier.length) {
        this.modifier[index].offsetX = CommonConstants.LIST_ITEM_LEFT_OFFSET;
        this.modifier[index].opacity = 0;
      }
    })
  }
}