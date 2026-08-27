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
import { BaseOption } from './BaseOption';
import { SheetLifeCycle } from '../../../../model/lifecycle/SheetLifeCycle';

/**
 * Popup window properties, based on BuilderOption
 * */
@Observed
export class SheetOption extends BaseOption {
  public height?: SheetSize | Dimension;
  public detents?: [(SheetSize | Dimension), (SheetSize | Dimension)?, (SheetSize | Dimension)?];
  public preferType?: SheetType;
  public showClose?: boolean | Resource;
  public dragBar?: boolean;
  public blurStyle?: BlurStyle;
  public title?: SheetTitleOptions | CustomBuilder;
  public enableOutsideInteractive?: boolean;
  public scrollSizeMode?: ScrollSizeMode;
  // The target component ID attribute to be bound and the uniqueId of the component
  public targetCompId?: string;
  public targetCompUniqueId?: number;
  // developer defined lifeCycle
  public lifeCycleConfig: SheetLifeCycle = {};
  // Native life cycle for direct Executor calls
  public sheetLifeCycleConfig: SheetLifeCycle = {};
  public backgroundColor: ResourceColor = 'rgb(241,243,245)';
  public borderWidth: number = 1;
  public borderColor: ResourceColor = Color.White;
  public shadow: ShadowOptions = {
    radius: 20,
    color: '#29000000',
    offsetY: 8
  };
}