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

import { InfDialog } from '../../../../../model/dialog/interface/InfDialog';
import { DefaultContent } from '../../DefaultContent';

export enum IconPosition {
  LEFT,
  RIGHT
}

export interface PopupItem {
  icon?: string;
  text: string;
  itemClick?: Function | undefined
}

export interface SheetItem {
  icon?: string;
  text: string;
  itemClick?: Function | undefined
}

export class ButtonItemParams {
  public text: string = '';
  public buttonStyleMode?: ButtonStyleMode = ButtonStyleMode.EMPHASIZED;
  public fontColor?: ResourceColor = '#FFFFFF';
  public backgroundColor?: ResourceColor = '#FF0A59F7';
  public border?: BorderOptions = {
    style: BorderStyle.Solid,
    color: '#FF000000'
  };
  public width?: Length;
  public itemClick?: Function
}

export class IconHorizontalToastContent extends DefaultContent {
  public icon: string = '';
  public button: string = '';
  public buttonBuilder: WrappedBuilder<[]> | null = null;
  public buttonCallback: (dialog: InfDialog) => void = () => {
  };
  public ignoreContainerStyle: boolean = false;
  public dialog?: InfDialog | undefined;
}

export class IconVerticalToastContent extends DefaultContent {
  public icon: string = '';
}

export class MenuPopupContent extends DefaultContent {
  public popupList: Array<PopupItem> = [];
  public showIcon: boolean = true;
  public iconPosition: IconPosition = IconPosition.LEFT;
  public width?: Length;
  public dialog?: InfDialog;
}

export class ActionSheetContent extends DefaultContent {
  public sheetList: Array<SheetItem> = [];
  public showBtnButton: boolean = true;
  public isTransparent: boolean = false;
  public title?: SheetTitleOptions | CustomBuilder;
  public dialog?: InfDialog;
}

export class ConfirmHorizontalDialogContent extends DefaultContent {
  public title: string = '';
  public text: string = '';
  public textBuilder: WrappedBuilder<ESObject> | null = null;
  public textBuilderParams: ESObject;
  public textAlign: TextAlign = TextAlign.Center;
  public buttons: Array<ButtonItemParams> | null = null;
  public buttonSpace: number = 10;
  public buttonAlign: FlexAlign = FlexAlign.Center;
  public dialog?: InfDialog;
}

export class ConfirmVerticalDialogContent extends DefaultContent {
  public title: string = ''
  public text: string = '';
  public textBuilder: WrappedBuilder<ESObject> | null = null;
  public textBuilderParams: ESObject;
  public textAlign: TextAlign = TextAlign.Center;
  public buttons: Array<ButtonItemParams> | null = null;
  public buttonSpace: number = 4;
  public full?: boolean;
  public dialog?: InfDialog;
}