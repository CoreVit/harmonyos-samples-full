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

import { rpc } from '@kit.IPCKit';
import type { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from './Logger';
import FormUtils from './FormUtils';
import { SongRdbHelper } from '../database/SongRdbHelper';
import { CardActionType, CollectAction, PlayActionType } from '../model/common/FormCardConstant';
import { ExerciseAction, ExerciseState } from '../model/exercise/ExerciseCardConstant';
import { MediaService } from '../viewmodel/music/MediaService';

const TAG = 'CardActionHandler';

class CardActionHandler {
  private context: Context | undefined = undefined;

  setContext(context: Context): void {
    this.context = context;
  }

  getHandler(): (data: rpc.MessageSequence) => null {
    return this.cardActionCall;
  }

  private cardActionCall = (data: rpc.MessageSequence): null => {
    try {
      let params: Record<string, string> = JSON.parse(data.readString());
      Logger.info(TAG, `cardActionCall actionType: ${params.actionType}`);

      switch (params.actionType) {
        case CardActionType.PLAY_ACTION:
          this.handlePlayAction(params);
          break;
        case CardActionType.COLLECT_ACTION:
          this.handleCollectAction(params);
          break;
        case CardActionType.REQUEST_UPDATE:
          this.handleRequestUpdate(params);
          break;
        case CardActionType.EXERCISE_ACTION:
          this.handleExerciseAction(params);
          break;
        default:
          Logger.warn(TAG, `Unknown actionType: ${params.actionType}`);
      }
    } catch (err) {
      let error = err as BusinessError;
      Logger.error(TAG, `cardActionCall err, code: ${error.code}, message: ${error.message}`);
    }
    return null;
  };

  private handlePlayAction(params: Record<string, string>): void {
    if (params.playActionType) {
      let playActionType: PlayActionType = params.playActionType as PlayActionType;
      MediaService.getInstance().initAndPlayByAction(playActionType);
    }
  }

  private handleCollectAction(params: Record<string, string>): void {
    if (params.collectActionType && this.context && params.songId) {
      let songRdbHelper = SongRdbHelper.getInstance(this.context);
      if (params.collectActionType === CollectAction.COLLECTED) {
        songRdbHelper.updateCollected(params.songId, CollectAction.COLLECTED);
        FormUtils.updateCardCollectStatus(this.context, true);
        this.context.eventHub.emit('collected', params.songId, CollectAction.COLLECTED);
      } else {
        songRdbHelper.updateCollected(params.songId, CollectAction.UNCOLLECTED);
        FormUtils.updateCardCollectStatus(this.context, false);
        this.context.eventHub.emit('collected', params.songId, CollectAction.UNCOLLECTED);
      }
    }
  }

  private handleRequestUpdate(params: Record<string, string>): void {
    if (params.formId && this.context) {
      FormUtils.updateMusicControlSingle(this.context, params.formId);
    }
  }

  private handleExerciseAction(params: Record<string, string>): void {
    if (params.exerciseAction && this.context) {
      switch (params.exerciseAction) {
        case ExerciseAction.START_EXERCISE:
          FormUtils.updateExerciseCardState(this.context, ExerciseState.IN_PROGRESS);
          break;
        case ExerciseAction.END_EXERCISE:
          FormUtils.updateExerciseCardState(this.context, ExerciseState.COMPLETED);
          break;
        case ExerciseAction.RESET_EXERCISE:
          FormUtils.resetExerciseCard(this.context);
          break;
      }
    }
  }
}

export default new CardActionHandler();