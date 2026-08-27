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

import { FileStore } from './FileStore';
import { ActionData } from './PreferencesUtil';
import { SongItem } from '../model/music/SongItem';
import { Logger } from '../utils/Logger';

const TAG = 'MusicFileStore';

const TRIGGER_ACTION_FILE = 'trigger_action.json';
const CURRENT_SONG_FILE = 'current_song.json';

class TriggerActionStore extends FileStore {
  getFileName(): string {
    return TRIGGER_ACTION_FILE;
  }

  write(context: Context, triggerAction: string, songId: string): void {
    let actionData: ActionData = new ActionData();
    actionData.triggerAction = triggerAction;
    actionData.songId = songId;
    this.writeJsonSync(context, actionData);
    Logger.info(TAG, `storeTriggerAction: ${triggerAction}, songId: ${songId}`);
  }

  read(context: Context): ActionData | undefined {
    let obj = this.readJsonSync(context);
    if (obj) {
      let actionData = obj as ActionData;
      Logger.info(TAG, `getTriggerAction: ${actionData.triggerAction}, songId: ${actionData.songId}`);
      return actionData;
    }
    return undefined;
  }

  clear(context: Context): void {
    this.deleteFileSync(context);
  }
}

class CurrentSongStore extends FileStore {
  getFileName(): string {
    return CURRENT_SONG_FILE;
  }

  write(context: Context, songItem: SongItem): void {
    this.writeJsonSync(context, songItem);
    Logger.info(TAG, `writeCurrentSong: ${songItem.title}`);
  }

  read(context: Context): SongItem | undefined {
    let obj = this.readJsonSync(context);
    if (obj) {
      return obj as SongItem;
    }
    return undefined;
  }
}

class MusicFileStore {
  private triggerActionStore: TriggerActionStore = new TriggerActionStore();
  private currentSongStore: CurrentSongStore = new CurrentSongStore();

  storeTriggerAction(context: Context, triggerAction: string, songId: string): void {
    this.triggerActionStore.write(context, triggerAction, songId);
  }

  getTriggerAction(context: Context): ActionData | undefined {
    return this.triggerActionStore.read(context);
  }

  clearTriggerAction(context: Context): void {
    this.triggerActionStore.clear(context);
  }

  writeCurrentSong(context: Context, songItem: SongItem): void {
    this.currentSongStore.write(context, songItem);
  }

  readCurrentSong(context: Context): SongItem | undefined {
    return this.currentSongStore.read(context);
  }
}

export default new MusicFileStore();