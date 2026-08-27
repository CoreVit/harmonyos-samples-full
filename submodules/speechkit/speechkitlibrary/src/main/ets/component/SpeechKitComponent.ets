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

import { TextReader } from '@kit.SpeechKit';
import { BreakpointType } from '../utils/BreakpointSystem';
import { CommonConstants } from '../common/constants/CommonConstants';
import { NewSpeechComponent } from './NewSpeechComponent';
import Logger from '../utils/Logger';
import { WindowUtil } from '../utils/WindowUtil';

const TAG = 'SpeechKitComponent';

@Component
export struct SpeechKitComponent {
  @StorageProp(CommonConstants.AS_KEY_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  @StorageProp(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageProp(CommonConstants.AS_KEY_BREAK_POINT) curBp: WidthBreakpoint = WidthBreakpoint.WIDTH_SM;
  @Provide(CommonConstants.AS_KEY_PATH_STACK) pathStack: NavPathStack = new NavPathStack();

  @Builder
  PagesMap(name: string, _: number) {
    if (name === 'NewSpeechComponent') {
      NewSpeechComponent()
    }
  }

  aboutToAppear(): void {
    this.initReaderComponent();
  }

  async initReaderComponent() {
    const readerParam: TextReader.ReaderParam = {
      isVoiceBrandVisible: true,
      businessBrandInfo: {
        panelName: this.getString($r('app.string.xiaoyi_reader').id),
      }
    };
    const context: Context | undefined = this.getUIContext().getHostContext();
    if (!context) {
      return;
    }
    if (!canIUse('SystemCapability.AI.Component.TextReader')) {
      return;
    }
    try {
      await TextReader.init(context, readerParam);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `initReaderComponent failed, cause: ${err.code}, ${err.message}}`);
    }
  }

  async aboutToDisappear(): Promise<void> {
    WindowUtil.unregisterBreakPoint();
    try {
      await TextReader.release();
    } catch (err) {
      Logger.error(TAG, `TextReader release Failed. Cause: ${err.code}, ${err.message}`);
    }
  }

  getString(resId: number): string {
    const hostContext = this.getUIContext().getHostContext();
    if (hostContext) {
      try {
        return hostContext.resourceManager.getStringSync(resId);
      } catch (err) {
        Logger.error(TAG, `getStringSync get exception.`);
      }
    }
    return '';
  }

  build() {
    Navigation(this.pathStack) {
      Column() {
        Column() {
          Text($r('app.string.reading_component'))
            .fontSize($r('app.float.title_reader_component_font_size'))
            .fontWeight(CommonConstants.FONT_WEIGHT_700)
            .lineHeight($r('app.float.title_reader_component_line_height'))
            .textAlign(TextAlign.Start)
          Text($r('app.string.the_service_of_audio_scene'))
            .fontSize($r('app.float.sub_title_reader_component_font_size'))
            .fontWeight(CommonConstants.FONT_WEIGHT_400)
            .lineHeight($r('app.float.sub_title_reader_component_line_height'))
            .fontColor($r('sys.color.font_secondary'))
        }
        .width(CommonConstants.FULL_WIDTH)
        .alignItems(HorizontalAlign.Start)
        .margin({ top: $r('app.float.title_reader_area_margin_top') })

        Column() {
          Button($r('app.string.news'), { type: ButtonType.Normal, stateEffect: true })
            .width(new BreakpointType({
              sm: $r('app.float.button_new_detail_width_sm'),
              md: $r('app.float.button_new_detail_width_md'),
              lg: $r('app.float.button_new_detail_width_md')
            }).getValue(this.curBp))
            .borderRadius(new BreakpointType({
              sm: $r('app.float.button_new_detail_radius'),
              md: $r('app.float.button_new_detail_radius'),
              lg: $r('app.float.button_new_detail_radius'),
              xl: $r('app.float.button_new_detail_radius_pc')
            }).getValue(this.curBp))
            .onClick(() => {
              this.pathStack.pushPathByName('NewSpeechComponent', null);
            })
        }
        .width(CommonConstants.FULL_WIDTH)
        .height('80%')
        .justifyContent(FlexAlign.End)
      }
      .height(CommonConstants.FULL_HEIGHT)
      .width(CommonConstants.FULL_WIDTH)
      .padding({
        top: this.statusBarHeight,
        bottom: this.navigatorBarHeight,
        right: new BreakpointType({
          sm: $r('app.float.home_page_margin_right_sm'),
          md: $r('app.float.home_page_margin_right_md'),
          lg: $r('app.float.home_page_margin_right_lg')
        }).getValue(this.curBp),
        left: new BreakpointType({
          sm: $r('app.float.home_page_margin_right_sm'),
          md: $r('app.float.home_page_margin_right_md'),
          lg: $r('app.float.home_page_margin_right_lg')
        }).getValue(this.curBp)
      })
    }
    .navDestination(this.PagesMap)
    .hideTitleBar(true)
    .mode(NavigationMode.Stack)
    .titleMode(NavigationTitleMode.Full)
    .backgroundColor($r('sys.color.background_secondary'))
  }
}
