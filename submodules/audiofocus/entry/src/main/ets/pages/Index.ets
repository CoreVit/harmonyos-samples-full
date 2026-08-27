/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { audio } from '@kit.AudioKit';
import { display, window } from '@kit.ArkUI';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { AppRouter } from '../common/util/AppRouter';
import { SegmentButtonComponent } from '../component/SegmentButton';
import { CustomButton } from '../component/CustomButton';
import { CommonConstants } from '../common/constants/CommonConstants';
import Logger from '../common/util/Logger';

const TAG = '[Index]';

interface SceneButton {
  buttonName: ResourceStr;
  pageName: string;
}

@Entry
@Component
struct Index {
  @StorageLink(CommonConstants.KEY_CURRENT_BREAK_POINT) curBp: string = '';
  @StorageLink(CommonConstants.KEY_IS_W) isW: boolean = false;
  @StorageLink(CommonConstants.KEY_IS_L) isL: boolean = false;
  @StorageLink(CommonConstants.KEY_HIDE_SPLIT) hideSplit: boolean = false;
  @Watch('onCurrentColorModeChange') @StorageLink(CommonConstants.KEY_CURRENT_COLOR_MODE)
  currentColorMode: ConfigurationConstant.ColorMode = ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET;
  @State isHalfFolded: boolean = false;
  windowStage: window.WindowStage = AppStorage.get(CommonConstants.KEY_WINDOW_STAGE) as window.WindowStage;
  mainWin: window.Window | undefined = undefined;
  private isCurrentPage: boolean = true;
  private buttonList: SceneButton[] = [
    {
      buttonName: $r('app.string.video_scene_button'),
      pageName: 'videoScenePage'
    },
    {
      buttonName: $r('app.string.audio_scene_button'),
      pageName: 'audioScenePage'
    },
    {
      buttonName: $r('app.string.short_video_scene_button'),
      pageName: 'shortVideoScenePage'
    },
    {
      buttonName: $r('app.string.embedded_short_video_scene'),
      pageName: 'embeddedShortVideoScenePage'
    },
    {
      buttonName: $r('app.string.voip_chart_button'),
      pageName: 'voIPScenePage'
    },
    {
      buttonName: $r('app.string.sound_pool_button'),
      pageName: 'soundPoolScenePage'
    },
    {
      buttonName: $r('app.string.multi_audio_stream_play_scene'),
      pageName: 'multiAudioStreamPlayScenePage'
    },
    {
      buttonName: $r('app.string.mute_playback'),
      pageName: 'mutePlayback'
    }
  ];
  onFoldStatusChange: (foldStatus: display.FoldStatus) => void = (foldStatus: display.FoldStatus) => {
    if (foldStatus === display.FoldStatus.FOLD_STATUS_FOLDED && this.curBp === 'sm') {
      this.isHalfFolded = true;
    } else if (foldStatus === display.FoldStatus.FOLD_STATUS_EXPANDED) {
      this.isHalfFolded = false;
    }
  }

  onCurrentColorModeChange() {
    try {
      this.mainWin = this.windowStage.getMainWindowSync();
    } catch (err) {
      Logger.error(TAG, `getMainWindowSync failed, code is ${err.code}, message is ${err.message}`);
    }
    if (this.isCurrentPage && this.mainWin) {
      if (this.currentColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT) {
        let sysBarProps: window.SystemBarProperties = {
          statusBarColor: '#F1F3F5',
          statusBarContentColor: '#000000'
        };
        this.mainWin.setWindowSystemBarProperties(sysBarProps).then(() => {
          Logger.info(TAG, '[StaticUtils] Succeeded in setting the system bar properties.');
        }).catch((err: BusinessError) => {
          Logger.error(TAG, `setting system bar properties failed, code is ${err.code}, message is ${err.message}`);
        });
      } else if (this.currentColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
        let sysBarProps: window.SystemBarProperties = {
          statusBarColor: '#000000',
          statusBarContentColor: '#F1F3F5'
        };
        this.mainWin.setWindowSystemBarProperties(sysBarProps).then(() => {
          Logger.info(TAG, '[StaticUtils] Succeeded in setting the system bar properties.');
        }).catch((err: BusinessError) => {
          Logger.error(TAG, `setting system bar properties failed, code is ${err.code}, message is ${err.message}`);
        });
      }
    }
  }

  aboutToAppear(): void {
    AppStorage.setOrCreate<audio.AudioConcurrencyMode>(
      CommonConstants.KEY_AUDIO_CONCURRENCY_MODE, audio.AudioConcurrencyMode.CONCURRENCY_DEFAULT);
    try {
      if (display.isFoldable()) {
        try {
          display.on('foldStatusChange', this.onFoldStatusChange);
          let foldStatus = display.getFoldStatus();
          if (foldStatus === display.FoldStatus.FOLD_STATUS_FOLDED && this.curBp === 'sm') {
            this.isHalfFolded = true;
          }
        } catch (error) {
          let err = error as BusinessError;
          Logger.error('foldStatusChange Failed',
            `Code: ${err.code}, message: ${err.message}`);
        }
      }
    } catch (error) {
      let err = error as BusinessError;
      Logger.error('Failed',
        `Code: ${err.code}, message: ${err.message}`);
    }
  }

  @Builder
  NavigationTitle() {
    Column() {
      Text($r('app.string.audio_demo_title'))
        .fontColor($r('sys.color.font_primary'))
        .fontSize(24)
        .lineHeight(32)
        .fontWeight(700)
        .width('100%')
    }
    .height(56)
    .padding({
      left: 16,
      right: 16,
      top: 16
    })
    .margin({ bottom: 12 })
    .alignItems(HorizontalAlign.Start)
  }

  build() {
    Navigation(AppRouter.getInstance().getPathStack()) {
      Column() {
        this.NavigationTitle()
        // Used to customize the focus policy selection for AudioSession
        Column() {
          SegmentButtonComponent()
            .width('100%')
        }
        .padding({ left: 16, right: 16 })
        .width('100%')
        .height(40)
        .margin({ bottom: 12 })

        Scroll() {
          Column({ space: 12 }) {
            GridRow({
              gutter: 12,
              columns: {
                xs: 1,
                sm: 1,
                md: 2,
                lg: 2,
                xl: 2
              },
              breakpoints: {
                value: ['320vp', '600vp', '840vp', '1440vp', '1600vp'],
                reference: BreakpointsReference.WindowSize
              }
            }) {
              ForEach(this.buttonList, (item: SceneButton) => {
                GridCol() {
                  CustomButton({
                    buttonName: item.buttonName,
                    buttonOnClick: () => {
                      AppRouter.pushByName(item.pageName, null)
                    }
                  });
                }
              }, (item: SceneButton) => item.pageName)
            }
          }
          .padding({ left: 16, right: 16 })
          .layoutWeight(1)
          .justifyContent(FlexAlign.End)
        }

        .padding({ bottom: 12 })
        .scrollBar(BarState.Off)
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Start)
    }
    .onNavBarStateChange((isVisible)=>{
      if(isVisible){
        this.isCurrentPage = true;
      }else {
        this.isCurrentPage = false;
      }
    })
    .backgroundColor($r('sys.color.background_secondary'))
    .mode(this.hideSplit ? NavigationMode.Split : NavigationMode.Stack)
    .hideTitleBar(true)
    .navBarWidth(400)
  }
}