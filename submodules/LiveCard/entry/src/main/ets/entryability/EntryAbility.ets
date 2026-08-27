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

import { ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { Logger } from '../utils/Logger';
import { MediaService } from '../viewmodel/music/MediaService';
import CardActionHandler from '../utils/CardActionHandler';
import RouterUtil from '../utils/RouterUtil';
import { WindowUtil } from '../utils/WindowUtil';
import FormUtils from '../utils/FormUtils';
import { Constants } from '../common/CommonConstants';
import { SongRdbHelper } from '../database/SongRdbHelper';

const TAG = 'EntryAbility';

export default class EntryAbility extends UIAbility {
  private windowUtil?: WindowUtil;
  onCreate(want: Want): void {
    Logger.info(TAG, 'Ability onCreate');
    
    AppStorage.setOrCreate(Constants.KEY_CONTEXT, this.context);
    
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
      CardActionHandler.setContext(this.context);
      this.callee.on('cardAction', CardActionHandler.getHandler());
      FormUtils.initFormRdb(this.context);
    } catch (err) {
      Logger.error(TAG, 'Failed to set colorMode. Cause: %{public}s', err);
    }

    MediaService.getInstance().initialize(this.context).catch((err: BusinessError) => {
      Logger.error(TAG, `mediaService initialize error,code is ${err.code}, message is ${err.message}`);
    });

    this.openPageByWant(want);
  }

  onNewWant(want: Want): void {
    this.openPageByWant(want);
  }

  onDestroy(): void {
    Logger.info(TAG, 'Ability onDestroy');
    try {
      this.callee.off('cardAction');
      MediaService.getInstance().destroy();
      let isPlay = AppStorage.get(Constants.KEY_IS_PLAY) as boolean;
      Logger.info(TAG, `onDestroy isPlay ${isPlay}`);
      if (isPlay) {
        FormUtils.updateCardPlayStatusCached(false);
      }
      SongRdbHelper.getInstance(this.context).release();
      FormUtils.closeFormRdb(this.context);
    } catch (err) {
      Logger.error(TAG, `onDestroy err: ${err.code}, ${err.message}`);
    }
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    Logger.info(TAG, '%{public}s', 'Ability onWindowStageCreate');
    try {
      this.windowUtil = new WindowUtil(windowStage.getMainWindowSync());
      AppStorage.setOrCreate(Constants.KEY_WINDOW_UTIL, this.windowUtil);
    } catch (err) {
      Logger.error(TAG, 'Failed to get the MainWindowSync. Cause: %{public}s', err);
    }
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        Logger.error(TAG, 'Failed to load the content. Cause: %{public}s', err.name);
        return;
      }
      Logger.info(TAG, 'Succeeded in loading the content.');
      if (this.windowUtil) {
        this.windowUtil.setUIContext();
        this.windowUtil.updateWindowInfo();
      }
    });
  }

  onWindowStageDestroy(): void {
    Logger.info(TAG, '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    Logger.info(TAG, '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    Logger.info(TAG, '%{public}s', 'Ability onBackground');
    RouterUtil.getInstance().clearPages();
  }

  private openPageByWant(want: Want): void {
    if (want && want.parameters && want.parameters.routeName) {
      let routeName = want.parameters.routeName as string;
      if (routeName !== '' && routeName.length >= 0 && routeName.length <= 20) {
        RouterUtil.getInstance().pushPage(routeName);
      }
    }
  }
}