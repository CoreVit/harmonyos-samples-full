/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import WaveWheelConstants from '../common/constant/WaveWheelConstant';
import type { SimpleWaveWheelOption } from 'wavewheel';

export interface WaveWheelTaskOption extends SimpleWaveWheelOption {
  selected?: boolean
}

export class TaskViewModel {
  private allWaveWheelOptions: WaveWheelTaskOption[] = [];
  private static instance: TaskViewModel | null = null;

  private constructor() {
    this.initDefaultOptions();
  }

  public static getInstance(): TaskViewModel {
    if (!TaskViewModel.instance) {
      TaskViewModel.instance = new TaskViewModel();
    }
    return TaskViewModel.instance;
  }

  private initDefaultOptions(): void {
    this.allWaveWheelOptions = WaveWheelConstants.waveWheelOptions.map((option: SimpleWaveWheelOption) => {
      let taskOption: WaveWheelTaskOption = {
        id: option.id,
        title: option.title,
        icon: option.icon,
        useSysImg: option.useSysImg,
        enable: option.enable,
        selected: false
      };
      return taskOption;
    });
  }

  getAllWaveWheelOptions(): WaveWheelTaskOption[] {
    return this.allWaveWheelOptions;
  }

  getSelectedWaveWheelOptions(): WaveWheelTaskOption[] {
    return this.allWaveWheelOptions.filter(option => option.selected);
  }

  getSelectedSimpleOptions(): SimpleWaveWheelOption[] {
    return this.allWaveWheelOptions
      .filter(option => option.selected)
      .map(option => {
        return {
          id: option.id,
          title: option.title,
          icon: option.icon,
          useSysImg: option.useSysImg,
          enable: option.enable
        } as SimpleWaveWheelOption;
      });

  }

  updateSelectedOptions(selectedIds: string[]): void {
    this.allWaveWheelOptions.forEach(option => {
      option.selected = selectedIds.includes(option.id);
    });
  }
}
