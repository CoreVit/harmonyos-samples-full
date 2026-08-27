/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { preferences } from '@kit.ArkData';
import type { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from '../utils/Logger';
import type { SongItem } from '../model/music/SongItem';

const TAG = 'PreferencesUtil';
const PREFERENCE_NAME = 'myStore';
const CURRENT_SONG = 'currentSong';
const ACTION = 'action';

export class ActionData {
  public triggerAction: string = '';
  public songId: string = '';
}

export class PreferencesUtil {
  private static preferencesUtil: PreferencesUtil;

  public static getInstance(): PreferencesUtil {
    if (!PreferencesUtil.preferencesUtil) {
      PreferencesUtil.preferencesUtil = new PreferencesUtil();
    }
    return PreferencesUtil.preferencesUtil;
  }

  private getPreferences(context: Context): preferences.Preferences | undefined {
    try {
      return preferences.getPreferencesSync(context, { name: PREFERENCE_NAME });
    } catch (e) {
      Logger.error(TAG, `getPreferences err: ${e.code}, ${e.message}`);
      return undefined;
    }
  }

  private preferencesFlush(preferences: preferences.Preferences): void {
    try {
      preferences.flushSync();
      Logger.info(TAG, `preferencesFlush successfully.`);
    } catch (error) {
      Logger.error(TAG, `preferencesFlush error: ${error.code}, message is ${error.message}.`);
    }
  }

  private putValue(context: Context, key: string, value: preferences.ValueType): void {
    try {
      Logger.info(TAG, `putValue key: ${key},value: ${value}`);
      let pre = this.getPreferences(context);
      if (pre) {
        pre.putSync(key, value);
        this.preferencesFlush(pre);
        Logger.info(TAG, `putValue successfully.`);
      } else {
        Logger.info(TAG, `putValue error.`);
      }
    } catch (error) {
      Logger.error(TAG, `putValue error,code is ${error.code}, massage is ${error.message}.`);
    }
  }

  public putCurrentSong(context: Context, currentSong: SongItem): void {
    this.putValue(context, CURRENT_SONG, JSON.stringify(currentSong));
  }

  public getCurrentSong(context: Context): Promise<SongItem | undefined> {
    Logger.info(TAG, `getCurrentSong`);
    return new Promise((resolve, reject) => {
      try {
        let pre = preferences.getPreferencesSync(context, { name: PREFERENCE_NAME });
        let songStr = pre.getSync(CURRENT_SONG, '') as string;
        Logger.info(TAG, `getCurrentSong songStr: ${songStr}`);
        if (songStr === '') {
          resolve(undefined);
        } else {
          let currentSong = JSON.parse(songStr) as SongItem;
          resolve(currentSong);
        }
      } catch (err) {
        Logger.error(TAG, `getCurrentSong err: ${err.code}, ${err.message}`);
        reject(err);
      }
    });
  }

  public putCurrentAction(context: Context, triggerAction: string, songId?: string): void {
    const actionData = JSON.stringify({ triggerAction, songId: songId || '' });
    this.putValue(context, ACTION, actionData);
  }

  public getCurrentAction(context: Context): ActionData | undefined {
    Logger.info(TAG, `getCurrentAction`);
    try {
      preferences.removePreferencesFromCacheSync(context, PREFERENCE_NAME);
      let pre = preferences.getPreferencesSync(context, { name: PREFERENCE_NAME });
      let actionStr = pre.getSync(ACTION, '') as string;
      Logger.info(TAG, `getCurrentAction actionStr: ${actionStr}`);
      if (actionStr === '') {
        return undefined;
      }
      let actionData = JSON.parse(actionStr) as Record<string, string>;
      let result = new ActionData();
      result.triggerAction = actionData.triggerAction || '';
      result.songId = actionData.songId || '';
      return result;
    } catch (err) {
      let error = err as BusinessError;
      Logger.error(TAG, `getCurrentAction err, code: ${error.code}, message: ${error.message}`);
      return undefined;
    }
  }

  public clearCurrentAction(context: Context): void {
    try {
      let pre = preferences.getPreferencesSync(context, { name: PREFERENCE_NAME });
      pre.deleteSync(ACTION);
      pre.flushSync();
      Logger.info(TAG, `clearCurrentAction successfully`);
    } catch (err) {
      let error = err as BusinessError;
      Logger.error(TAG, `clearCurrentAction err, code: ${error.code}, message: ${error.message}`);
    }
  }
}
