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

import { emitter } from '@kit.BasicServicesKit';
import { preferences } from '@kit.ArkData';
import { CommonConstants, ImageAndName, THEMES } from '../common/CommonConstants';
import Logger from '../utils/Logger';
import ThemeDesktop from './ThemeDesktop';
import { BreakpointType } from '../utils/BreakpointSystem';

const TAG: string = '[PreferencesComponent]';
const PREFERENCES_NAME = 'theme.db';
const THEME_NAMES: string[] = ['default', 'simplicity', 'pomeloWhtie'];
let preferenceTheme: preferences.Preferences | null = null;

@Component
export struct PreferencesComponent {
  @State nowTheme: string = '';
  @State themeDatas: Array<ImageAndName> = [];
  @StorageProp(CommonConstants.KEY_PREFIX + 'Breakpoint') currentBreakpoint: string = 'sm';
  @StorageProp(CommonConstants.KEY_PREFIX + 'StatusBarHeight') topRectHeight: number = 0;

  async aboutToAppear() {
    await this.getPreferencesFromStorage();
    this.nowTheme = await this.getPreference();
    const index = THEME_NAMES.indexOf(this.nowTheme);
    if (index >= 0 && index < THEMES.length) {
      this.themeDatas = THEMES[index];
    }
  }

  async getPreferencesFromStorage() {
    let context = this.getUIContext().getHostContext() as Context;
    try {
      preferenceTheme = await preferences.getPreferences(context, PREFERENCES_NAME);
    } catch (err) {
      Logger.error(TAG, `Get preferences from storage error. Code: ${err.code}, message: ${err.message}`);
    }
  }

  async putPreference(data: string) {
    if (preferenceTheme !== null && data && data !== '') {
      try {
        await preferenceTheme.put('theme', data);
        await preferenceTheme.flush();
      } catch (err) {
        Logger.error(`Put preference error. Code: ${err.code}, message: ${err.message}`);
      }
    }
  }

  async getPreference(): Promise<string> {
    let theme: string = '';
    if (preferenceTheme !== null) {
      try {
        theme = await preferenceTheme.get('theme', 'default') as string;
        return theme;
      } catch (err) {
        Logger.error(`Get preference error. Code: ${err.code}, message: ${err.message}`);
      }
    }
    return theme;
  }

  changeTheme(themeNum: number) {
    if (themeNum < 0 || themeNum >= THEMES.length) {
      return;
    }
    this.themeDatas = THEMES[themeNum];
    this.putPreference(THEME_NAMES[themeNum]);
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.title'))
          .fontSize(25)
          .layoutWeight(5)
          .fontColor($r('sys.color.font_primary'))
          .fontWeight(FontWeight.Bold)
        Button({ type: ButtonType.Circle }) {
          SymbolGlyph($r('sys.symbol.swap'))
            .rotate({ angle: '90deg' })
            .fontSize($r('sys.float.Title_M'))
            .fontColor([$r('sys.color.icon_primary')])
            .bindMenu([
              {
                value: THEME_NAMES[0],
                action: () => {
                  this.changeTheme(0);
                }
              },
              {
                value: THEME_NAMES[1],
                action: () => {
                  this.changeTheme(1);
                }
              },
              {
                value: THEME_NAMES[2],
                action: () => {
                  this.changeTheme(2);
                }
              }
            ])
        }
        .height(40)
        .aspectRatio(1)
        .backgroundColor($r('sys.color.comp_background_tertiary'))
      }
      .width('100%')
      .height(50)
      .backgroundColor($r('sys.color.background_secondary'))

      ThemeDesktop({ themeDatas: $themeDatas })
    }
    .padding({
      left: new BreakpointType({
        sm: $r('sys.float.padding_level8'), md: $r('sys.float.padding_level12'),
        lg: $r('sys.float.padding_level16')
      }).getValue(this.currentBreakpoint),
      right: new BreakpointType({
        sm: $r('sys.float.padding_level8'), md: $r('sys.float.padding_level12'),
        lg: $r('sys.float.padding_level16')
      }).getValue(this.currentBreakpoint),
      top: this.topRectHeight,
    })
    .backgroundColor($r('sys.color.background_secondary'))
    .width('100%')
    .height('100%')
  }
}
