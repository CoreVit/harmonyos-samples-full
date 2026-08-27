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
import { DialogDismissReason } from '../../common/constant/DialogDismissReason';
import { ListenerManager } from '../ListenerManager';
import { DialogLifeCycle } from './DialogLifeCycle';
import { SheetLifeCycle } from './SheetLifeCycle';


/**
 * dialog life cycle description.
 */
export class DialogLifeCycleHelper extends ListenerManager<DialogLifeCycle> {
  /**
   * dispatch dialog show life cycle.
   *
   */
  public dispatchShow(): void {
    this.listeners.forEach((lifecycle) => {
      lifecycle.onShow?.();
    });
  }

  /**
   * dispatch dialog willShow life cycle.
   *
   */
  public dispatchWillShow(): boolean {
    let willShow: boolean = true;
    this.listeners.forEach((lifecycle) => {
      if (lifecycle.onWillShow && !lifecycle.onWillShow()) {
        willShow = false;
      }
    });
    return willShow;
  }

  /**
   * dispatch dialog hide life cycle
   */
  public dispatchHide(): void {
    this.listeners.forEach((lifecycle) => {
      lifecycle.onHide?.();
    })
  }

  /**
   * dispatch dialog willHide life cycle
   * @returns the result of dialog hide
   */
  public dispatchWillHide(): boolean {
    let hide = true;
    for (let i = 0; i < this.listeners.length; i++) {
      let lifecycle = this.listeners[i];
      if (lifecycle.onWillHide && !lifecycle.onWillHide()) {
        hide = false;
        break;
      }
    }
    return hide;
  }

  /**
   * dispatch dialog dismiss life cycle.
   *
   */
  public dispatchDismiss(): void {
    this.listeners.forEach((lifecycle) => {
      lifecycle.onDismiss?.();
    });
  }

  /**
   * dispatch dialog willDismiss life cycle.
   *
   */
  public dispatchWillDismiss(reason: DialogDismissReason): boolean {
    let willDismiss: boolean = true;
    this.listeners.forEach((lifecycle) => {
      if (lifecycle.onWillDismiss && !lifecycle.onWillDismiss(reason)) {
        willDismiss = false;
      }
    });
    return willDismiss;
  }
}


export class SheetLifeCycleHelper extends ListenerManager<SheetLifeCycle> {
  public dispatchShow(): void {
    this.listeners.forEach((lifecycle) => {
      lifecycle.onShow?.();
    });
  }

  public dispatchWillShow(): boolean {
    let willShow: boolean = true;
    this.listeners.forEach((lifecycle) => {
      if (lifecycle.onWillShow && !lifecycle.onWillShow()) {
        willShow = false;
      }
    });
    return willShow;
  }

  public dispatchHide(): void {
    this.listeners.forEach((lifecycle) => {
      lifecycle.onHide?.();
    })
  }

  public dispatchWillHide(): boolean {
    let hide = true;
    for (let i = 0; i < this.listeners.length; i++) {
      let lifecycle = this.listeners[i];
      if (lifecycle.onWillHide && !lifecycle.onWillHide()) {
        hide = false;
        break;
      }
    }
    return hide;
  }

  public dispatchDismiss(): void {
    this.listeners.forEach((lifecycle) => {
      lifecycle.onDismiss?.();
    });
  }

  public dispatchWillDismiss(reason: DialogDismissReason): boolean {
    let willDismiss: boolean = true;
    this.listeners.forEach((lifecycle) => {
      if (lifecycle.onWillDismiss && !lifecycle.onWillDismiss(reason)) {
        willDismiss = false;
      }
    });
    return willDismiss;
  }

  public dispatchWillSpringBackWhenDismiss(action: SpringBackAction): void {
    this.listeners.forEach((lifecycle) => {
      lifecycle.onWillSpringBackWhenDismiss?.(action);
    });
  }

  public dispatchHeightDidChange(height: number): void {
    this.listeners.forEach((lifecycle) => {
      lifecycle.onHeightDidChange?.(height);
    });
  }

  public dispatchDetentsDidChange(detents: number): void {
    this.listeners.forEach((lifecycle) => {
      lifecycle.onDetentsDidChange?.(detents);
    });
  }

  public dispatchWidthDidChange(width: number): void {
    this.listeners.forEach((lifecycle) => {
      lifecycle.onWidthDidChange?.(width);
    });
  }

  public dispatchTypeDidChange(type: SheetType): void {
    this.listeners.forEach((lifecycle) => {
      lifecycle.onTypeDidChange?.(type);
    });
  }
}
