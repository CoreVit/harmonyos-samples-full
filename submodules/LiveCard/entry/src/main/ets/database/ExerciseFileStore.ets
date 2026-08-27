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
import { Logger } from '../utils/Logger';

const TAG = 'ExerciseFileStore';

const EXERCISE_STATE_FILE = 'exercise_state.json';

class ExerciseStateStore extends FileStore {
  getFileName(): string {
    return EXERCISE_STATE_FILE;
  }

  write(context: Context, state: number): void {
    class ExerciseStateParams {
      public state: number = state
    }
    let data = new ExerciseStateParams();
    this.writeJsonSync(context, data);
    Logger.info(TAG, `writeExerciseState: ${state}`);
  }

  read(context: Context): number | undefined {
    let obj = this.readJsonSync(context);
    if (obj) {
      return (obj as Record<string, number>).state;
    }
    return undefined;
  }
}

class ExerciseFileStore {
  private exerciseStateStore: ExerciseStateStore = new ExerciseStateStore();

  writeExerciseState(context: Context, state: number): void {
    this.exerciseStateStore.write(context, state);
  }

  readExerciseState(context: Context): number | undefined {
    return this.exerciseStateStore.read(context);
  }
}

export default new ExerciseFileStore();