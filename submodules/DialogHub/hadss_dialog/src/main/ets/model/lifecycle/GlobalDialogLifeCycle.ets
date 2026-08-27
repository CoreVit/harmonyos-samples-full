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
import { CommonDialog } from '../dialog/base/CommonDialog';

export interface GlobalDialogLifeCycle {
  /**
   * pop up
   *
   */
  onShow?: (dialog: CommonDialog) => void;

  /**
   * About to pop up
   *
   */
  onWillShow?: (dialog: CommonDialog) => boolean;

  /**
   * lifecycle after the dialog hide
   * @param dialog
   */
  onHide?: (dialog: CommonDialog) => void;

  /**
   * lifecycle before the dialog hide
   * @param dialog
   * @returns whether the dialog will hide
   */
  onWillHide?: (dialog: CommonDialog) => boolean;

  /**
   * close
   *
   */
  onDismiss?: (dialog: CommonDialog) => void;

  /**
   * About to close
   *
   */
  onWillDismiss?: (dialog: CommonDialog, reason: DialogDismissReason) => boolean;
}

