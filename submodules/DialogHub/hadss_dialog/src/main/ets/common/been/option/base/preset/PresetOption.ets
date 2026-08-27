/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { ToastOption } from '../ToastOption'
import {
  ActionSheetContent,
  ConfirmHorizontalDialogContent,
  ConfirmVerticalDialogContent,
  IconHorizontalToastContent,
  IconVerticalToastContent, MenuPopupContent,
} from './PresetContent';
import {
  IconHorizontalToastBuilder,
  IconVerticalToastBuilder,
  MenuPopupBuilder,
  ActionSheetBuilder,
  ConfirmHorizontalDialogBuilder,
  ConfirmVerticalDialogBuilder
} from './PresetBuilderContent';
import { PopupOption } from '../PopupOption';
import { SheetOption } from '../SheetOption';
import { CustomOption } from '../CustomOption';

export class IconHorizontalToastOption extends ToastOption {
  public customContent: WrappedBuilder<[ESObject]> = wrapBuilder(IconHorizontalToastBuilder);
  public customContentParam: IconHorizontalToastContent = new IconHorizontalToastContent('');
}

export class IconVerticalToastOption extends ToastOption {
  public customContent: WrappedBuilder<[ESObject]> = wrapBuilder(IconVerticalToastBuilder);
  public customContentParam: IconVerticalToastContent = new IconVerticalToastContent('');
}

export class MenuPopupOption extends PopupOption {
  public customContent: WrappedBuilder<[ESObject]> = wrapBuilder(MenuPopupBuilder);
  public customContentParam: MenuPopupContent = new MenuPopupContent('');
}

export class ActionSheetOption extends SheetOption{
  public customContent: WrappedBuilder<[ESObject]> = wrapBuilder(ActionSheetBuilder);
  public customContentParam: ActionSheetContent = new ActionSheetContent('');
}

export class ConfirmHorizontalDialogOption extends CustomOption {
  public customContent: WrappedBuilder<[ESObject]> = wrapBuilder(ConfirmHorizontalDialogBuilder);
  public customContentParam: ConfirmHorizontalDialogContent = new ConfirmHorizontalDialogContent('');
}

export class ConfirmVerticalDialogOption extends CustomOption {
  public customContent: WrappedBuilder<[ESObject]> = wrapBuilder(ConfirmVerticalDialogBuilder);
  public customContentParam: ConfirmVerticalDialogContent = new ConfirmVerticalDialogContent('');
}