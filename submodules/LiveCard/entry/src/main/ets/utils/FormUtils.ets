/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import type { BusinessError } from '@kit.BasicServicesKit';
import { formBindingData, formProvider } from '@kit.FormKit';
import { Logger } from './Logger';
import { FormInfo } from '../model/common/FormInfo';
import { FormRdbHelper } from '../database/FormRdbHelper';
import { SongRdbHelper } from '../database/SongRdbHelper';
import { SongItem } from '../model/music/SongItem';
import { FormControlData } from '../model/music/FormControlData';
import { ExerciseState } from '../model/exercise/ExerciseCardConstant';
import { Constants } from '../common/CommonConstants';
import MusicFileStore from '../database/MusicFileStore';
import ExerciseFileStore from '../database/ExerciseFileStore';

const TAG = 'FormUtils';

interface UpdateData {
  isCollected?: boolean;
  isNeedRequestUpdate?: boolean;
  formId?: string;
}

class FormUtils {
  private cachedMusicFormIds: string[] = [];

  private refreshMusicFormCache(formList: FormInfo[]): void {
    this.cachedMusicFormIds = formList.map((formInfo) => formInfo.formId);
    Logger.info(TAG, `refreshMusicFormCache, count: ${this.cachedMusicFormIds.length}`);
  }

  public updateCardPlayStatusCached(isPlay: boolean): void {
    if (this.cachedMusicFormIds.length === 0) {
      Logger.warn(TAG, 'updateCardPlayStatusCached: no cached formIds, skip');
      return;
    }

    class CardUpdateData {
      public isPlay: boolean = isPlay;
    }

    let data = new CardUpdateData();
    this.cachedMusicFormIds.forEach((formId) => {
      this.updateForm(formId, data);
    });
  }

  public initFormRdb(context: Context): void {
    FormRdbHelper.getInstance(context);
  }

  public closeFormRdb(context: Context): void {
    FormRdbHelper.getInstance(context);
  }

  public insertFormData(context: Context, data: FormInfo): Promise<number> {
    return FormRdbHelper.getInstance(context).insertForm(data);
  }

  public getFormInfoById(context: Context, formId: string): Promise<FormInfo | undefined> {
    return FormRdbHelper.getInstance(context).queryFormById(formId);
  }

  public deleteFormInfo(context: Context, formId: string): void {
    FormRdbHelper.getInstance(context).deleteForm(formId);
  }

  public async updateCardCollectStatus(context: Context, isCollected: boolean): Promise<void> {
    let updateData: UpdateData = {
      isCollected: isCollected,
    };
    let formList: FormInfo[] = await FormRdbHelper.getInstance(context).queryFormByName('MusicCard');
    this.refreshMusicFormCache(formList);
    formList.forEach((formInfo) => {
      this.updateForm(formInfo.formId, updateData);
    });
  }

  public async updateCardPlayStatus(context: Context, isPlay: boolean): Promise<void> {
    class CardUpdateData {
      public isPlay: boolean = isPlay;
    }

    let data = new CardUpdateData();
    let formList: FormInfo[] = await FormRdbHelper.getInstance(context).queryFormByName('MusicCard');
    this.refreshMusicFormCache(formList);
    Logger.info(TAG, `updateCardPlayStatus formList length:  ${formList.length}`);
    formList.forEach((formInfo) => {
      this.updateForm(formInfo.formId, data);
    });
  }

  public async updateMusicControlCards(context: Context, songItem: SongItem, isPlay: boolean): Promise<void> {
    let isCollected = await SongRdbHelper.getInstance(context).isCollected(songItem.id);

    let formList: FormInfo[] = await FormRdbHelper.getInstance(context).queryFormByName('MusicCard');
    this.refreshMusicFormCache(formList);
    let formData = new FormControlData();
    formData.isPlay = isPlay;
    formData.singer = songItem.singer;
    formData.title = songItem.title;
    formData.songId = songItem.id;
    formData.musicCover = songItem.label;
    formData.isCollected = isCollected;

    formList.forEach((formInfo) => {
      this.updateForm(formInfo.formId, formData);
    });
  }

  public async updateMusicControlSingle(context: Context, formId: string): Promise<void> {

    let isPlay = (AppStorage.get(Constants.KEY_IS_PLAY) as boolean) ?? false;
    let songItem: SongItem = AppStorage.get(Constants.KEY_CURRENT_SONG) as SongItem;

    if (!songItem) {
      let storedSong = MusicFileStore.readCurrentSong(context);
      songItem = storedSong ? storedSong : new SongItem();
    }

    let collectedSongList: SongItem[] = await SongRdbHelper.getInstance(context).queryCollectedSongs();

    let formData = new FormControlData();
    formData.isPlay = isPlay;
    formData.formId = formId;
    formData.singer = songItem.singer;
    formData.title = songItem.title;
    formData.songId = songItem.id;
    formData.musicCover = songItem.label;
    formData.isCollected = collectedSongList.findIndex((item) => item.id === songItem.id) >= 0;

    Logger.info(TAG, `updateMusicControlSingle formId: ${formData.formId}`);

    this.updateForm(formData.formId, formData);
  }

  public updateMusicControlCard(formId: string, needUpdate: boolean): void {
    Logger.info(TAG, `updateMusicControlCard formId:${formId},needUpdate:${needUpdate}`);
    let updateData: UpdateData = {
      isNeedRequestUpdate: needUpdate,
      formId: formId,
    };
    this.updateForm(formId, updateData);
  }

  async updateExerciseCardState(context: Context, state: number): Promise<void> {
    ExerciseFileStore.writeExerciseState(context, state);
    Logger.info(TAG, `updateExerciseCardState state: ${state}`);

    let formList: FormInfo[] = await FormRdbHelper.getInstance(context).queryFormByName('ExerciseCard');
    formList.forEach((formInfo) => {
      class ExerciseUpdateData {
        public currentState: number = state;
        public calories: number = 0;
      }
      this.updateForm(formInfo.formId, new ExerciseUpdateData());
    });
  }

  async resetExerciseCard(context: Context): Promise<void> {
    await this.updateExerciseCardState(context, ExerciseState.NOT_STARTED);
  }

  async updateSleepCardState(context: Context, state: boolean): Promise<void> {
    try {
      Logger.info(TAG, `updateExerciseCardState state: ${state}`);
      let formList: FormInfo[] = await FormRdbHelper.getInstance(context).queryFormByName('SleepCard');
      formList.forEach((formInfo) => {
        class SleepUpdateData {
          public isSleep: boolean = state;
        }
        this.updateForm(formInfo.formId, new SleepUpdateData());
      });
    } catch (err) {
      let error = err as BusinessError;
      Logger.error(TAG, `updateSleepCardState err, code: ${error.code}, message: ${error.message}`);
    }
  }

  private updateForm(formId: string, updateData: object): void {
    let formMsg: formBindingData.FormBindingData = formBindingData.createFormBindingData(updateData);
    formProvider
      .updateForm(formId, formMsg)
      .then(() => {
        Logger.info(TAG, `updateForm success formId:  ${formId}`);
      })
      .catch((error: BusinessError) => {
        Logger.error(TAG, `updateForm failed, code: ${error.code}, message: ${error.message}`);
      });
  }

}

export default new FormUtils();