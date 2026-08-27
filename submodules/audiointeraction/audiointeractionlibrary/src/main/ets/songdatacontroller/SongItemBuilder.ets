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

import { BusinessError } from '@kit.BasicServicesKit';
import { resourceManager } from '@kit.LocalizationKit';
import { KeyConstants } from '../common/constants/KeyConstants';
import Logger from '../common/utils/Logger';
import { SongItem } from './SongData';

const TAG: string = '[SongItemBuilder]';

export default class SongItemBuilder {
  private context: UIContext | undefined = AppStorage.get(KeyConstants.KEY_UI_CONTEXT);
  private rawFileDescriptor?: resourceManager.RawFileDescriptor;
  private songItem: SongItem | null = null;

  public async build(songItem: SongItem): Promise<SongItem> {
    this.songItem = songItem;
    if (!this.context || !this.context.getHostContext()) {
      return this.songItem;
    }
    const rawFileDescriptor = await this.context.getHostContext()!.resourceManager.getRawFd(songItem.src)
      .catch((error: BusinessError) => {
        Logger.error(TAG, `resourceManager error code ${error.code} message ${error.message}`);
      })
    if (rawFileDescriptor) {
      this.rawFileDescriptor = rawFileDescriptor;
    }
    Logger.info(TAG, 'MediaAssetBuilder build rawFileDescriptor');
    return this.songItem;
  }

  public getRawFileDescriptor(): resourceManager.RawFileDescriptor | undefined {
    Logger.info(TAG, `getRawFileDescriptor succeed.`);
    return this.rawFileDescriptor;
  }

  public async release(): Promise<void> {
    if (!this.context || !this.context.getHostContext()) {
      return;
    }
    try {
      if (this.context && this.context !== null && this.songItem !== null) {
        this.context.getHostContext()!.resourceManager.closeRawFd(this.songItem.src);
      }
      this.songItem = null;
    } catch (error) {
      Logger.error(TAG, `Failed to release. Code:${error.code}, message:${error.message}`);
    }
  }
}