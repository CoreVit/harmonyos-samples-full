/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { wrappedBuilderTurningAnimation } from '../feature/pageTurningAnimation/view/PageTurningAnimation';
import { wrappedBuilderPageListSlideToHistory } from '../feature/pageListSlideToHistory/view/PageListSlideToHistory';
import { wrappedBuilderStatusBarChange } from '../feature/pageStatusBarChange/view/PageStatusBarChange';
import { wrappedBuilderWaterRipples } from '../feature/pageWaterRipples/view/PageWaterRipples';
import { wrappedBuilderMarqueeView } from '../feature/pageMarqueeView/view/Marquee';
import { wrappedBuilderSwiperSmooth } from '../feature/swiperSmoothVariation/view/SwiperSmoothVariation';
import { wrappedBuilderPaintComponent } from '../feature/pagePaintComponent/view/PagePaintComponent';
import { wrappedBuilderDigitalScroll } from '../feature/digitalScrollAnimation/view/DigitalScrollExample';
import { wrappedBuilderVotingComponent } from '../feature/votingComponent/pages/VotingComponent';

export class GlobalBuilderContext {
  private static instance: GlobalBuilderContext;
  private _objects = new Map<string, Object>();

  public static getContext(): GlobalBuilderContext {
    if (!GlobalBuilderContext.instance) {
      GlobalBuilderContext.instance = new GlobalBuilderContext();
      GlobalBuilderContext.instance.setObject('PageTurningAnimation', wrappedBuilderTurningAnimation);
      GlobalBuilderContext.instance.setObject('PageListSlideToHistory', wrappedBuilderPageListSlideToHistory);
      GlobalBuilderContext.instance.setObject('PageStatusBarChange', wrappedBuilderStatusBarChange);
      GlobalBuilderContext.instance.setObject('PageWaterRipples', wrappedBuilderWaterRipples);
      GlobalBuilderContext.instance.setObject('PageWaterMarqueeView', wrappedBuilderMarqueeView);
      GlobalBuilderContext.instance.setObject('SwiperSmoothVariation', wrappedBuilderSwiperSmooth);
      GlobalBuilderContext.instance.setObject('PagePaintComponent', wrappedBuilderPaintComponent);
      GlobalBuilderContext.instance.setObject('DigitalScrollExample', wrappedBuilderDigitalScroll);
      GlobalBuilderContext.instance.setObject('VotingComponent', wrappedBuilderVotingComponent);
    }
    return GlobalBuilderContext.instance;
  }

  public getObject(value: string): Object | undefined {
    return this._objects.get(value);
  }

  public setObject(key: string, objectClass: Object): void {
    this._objects.set(key, objectClass);
  }
}