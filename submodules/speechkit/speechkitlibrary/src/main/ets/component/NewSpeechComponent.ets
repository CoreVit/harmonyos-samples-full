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

import type { BusinessError } from '@kit.BasicServicesKit';
import { CircleShape } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { TextReader, ReadStateCode } from '@kit.SpeechKit';
import { BreakpointType } from '../utils/BreakpointSystem';
import { CommonConstants } from '../common/constants/CommonConstants';
import Logger from '../utils/Logger';

const TAG = 'NewSpeechComponent';

@Component
struct MyReaderIcon {
  @Link readState: ReadStateCode;

  build() {
    Column() {
      SymbolGlyph(this.readState === ReadStateCode.PLAYING ? $r('sys.symbol.AI_pause') : $r('sys.symbol.AI_play'))
        .fontSize($r('sys.float.Title_M'))
        .fontColor([$r('sys.color.font_primary')])
    }
  }
}

@Component
export struct NewSpeechComponent {
  @Consume(CommonConstants.AS_KEY_PATH_STACK) pathStack: NavPathStack;
  @StorageProp(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageProp(CommonConstants.AS_KEY_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  @StorageProp(CommonConstants.AS_KEY_BREAK_POINT) curBp: WidthBreakpoint = WidthBreakpoint.WIDTH_SM;
  /**
   * Articles to be loaded.
   */
  @State readInfoList: TextReader.ReadInfo[] = [];
  /**
   * The information of new
   */
  @State selectedReadInfo: TextReader.ReadInfo = this.readInfoList[0];
  /**
   * Playback status.
   */
  @State readState: ReadStateCode = ReadStateCode.WAITING;
  /**
   * The image of the new
   */
  @State articlePixelMap: image.PixelMap | undefined = undefined;
  /**
   * The imageSource of the media
   */
  private imageSource: image.ImageSource | undefined;
  /**
   * The id of the new
   */
  newsId: string = '001';
  private myScroller: Scroller = new Scroller();
  private stateChange = (state: TextReader.ReadState) => {
    Logger.info(TAG, `ReadState: ${JSON.stringify(state)}`,);
    if (this.readState === state.state) {
      return;
    }
    this.readState = state.state;
  };

  async aboutToAppear() {
    await this.getNewsThumbnail();
    this.generateReaderText();
    this.updateStatus();
    TextReader.on('stateChange', this.stateChange);
  }

  async aboutToDisappear(): Promise<void> {
    if (this.articlePixelMap) {
      this.articlePixelMap.release();
      this.articlePixelMap = undefined;
    }
    if (this.imageSource) {
      this.imageSource.release();
      this.imageSource = undefined;
    }
    try {
      TextReader.stop()
        .catch((err: BusinessError) => {
          Logger.error(TAG, `TextReader stop Failed. Cause: ${err.code}, ${err.message}`);
        })
      TextReader.off('stateChange', this.stateChange);
    } catch (err) {
      Logger.error(TAG, `TextReader release Failed. Cause: ${err.code}, ${err.message}`);
    }
  }

  updateStatus(): void {
    try {
      const state = TextReader.queryReadState();
      if (state.state === ReadStateCode.PLAYING) {
        this.readState = ReadStateCode.PLAYING;
      } else {
        this.readState = ReadStateCode.WAITING;
      }
    } catch (err) {
      Logger.error(TAG, `queryReadState get exception.`);
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

  async getNewsThumbnail() {
    try {
      const resourceMgr = this.getUIContext().getHostContext()?.resourceManager;
      if (resourceMgr) {
        const fileData = await resourceMgr.getMediaContent($r('app.media.news_image').id);
        this.imageSource = image.createImageSource(fileData.buffer);
        this.articlePixelMap = await this.imageSource.createPixelMap();
      }
    } catch (error) {
      Logger.error(TAG, `callback getMediaContent failed, error code: ${error.code}, message: ${error.message}.`);
    }
  }

  generateReaderText() {
    Logger.info(TAG, `ReadStateCode: ${JSON.stringify(this.readState)}`)
    const readInfoList: TextReader.ReadInfo[] = [{
      id: this.newsId,
      title: {
        text: this.getString($r('app.string.news_title').id),
        isClickable: true
      },
      author: {
        text: this.getString($r('app.string.news_author').id),
        isClickable: false
      },
      date: {
        text: this.getString($r('app.string.reader_date').id),
        isClickable: false
      },
      image: this.articlePixelMap,
      categoryObject: {
        id: this.newsId,
        name: this.getString($r('app.string.news_author').id),
        image: this.articlePixelMap ?? ''
      },
      bodyInfo: this.getString($r('app.string.news_part1').id) + this.getString($r('app.string.news_part2').id) +
      this.getString($r('app.string.news_part3').id)
    }];
    this.readInfoList = readInfoList;
    this.selectedReadInfo = readInfoList[0];
  }

  async startReadNews() {
    try {
      // The playback is already in progress. Pull up the playback panel.
      if (this.readState === ReadStateCode.PLAYING) {
        TextReader.showPanel();
        return;
      }
      await TextReader.start(this.readInfoList, this.selectedReadInfo?.id);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `startReadNews failed, cause: ${err.code}, ${err.message}`);
    }
  }

  build() {
    NavDestination() {
      Column() {
        RelativeContainer() {
          Button({ type: ButtonType.Circle }) {
            SymbolGlyph($r('sys.symbol.chevron_backward'))
              .fontSize($r('sys.float.Title_M'))
              .fontColor([$r('sys.color.font_primary')])
          }
          .focusable(true)
          .focusOnTouch(true)
          .height($r('app.float.news_detail_title_back_icon_width'))
          .width($r('app.float.news_detail_title_back_icon_width'))
          .aspectRatio(1)
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .onClick(() => {
            this.pathStack.pop();
          })
          .id('back_icon')
          .alignRules({
            left: { 'anchor': '__container__', align: HorizontalAlign.Start },
            center: { anchor: '__container__', align: VerticalAlign.Center }
          })

          Text($r('app.string.news'))
            .fontSize($r('app.float.title_new_detail_font_size'))
            .fontWeight(CommonConstants.FONT_WEIGHT_700)
            .lineHeight($r('app.float.title_new_detail_line_height'))
            .fontColor($r('sys.color.font_primary'))
            .id('title_text')
            .margin({ left: $r('app.float.title_new_detail_margin_left') })
            .textAlign(TextAlign.Start)
            .alignRules({
              left: { anchor: 'back_icon', align: HorizontalAlign.End },
              center: { anchor: '__container__', align: VerticalAlign.Center }
            })

          MyReaderIcon({ readState: this.readState })
            .width($r('app.float.news_detail_title_back_icon_width'))
            .height($r('app.float.news_detail_title_back_icon_width'))
            .padding($r('app.float.news_detail_title_back_icon_padding'))
            .backgroundColor($r('app.color.play_icon_background'))
            .clipShape(new CircleShape({ width: '40vp', height: '40vp' }))
            .onClick(async () => {
              this.startReadNews();
            })
            .id('icon_reader')
            .alignRules({
              right: { anchor: '__container__', align: HorizontalAlign.End },
              center: { anchor: '__container__', align: VerticalAlign.Center }
            })
        }
        .height('56vp')

        Scroll(this.myScroller) {
          Column() {
            Text($r('app.string.news_title'))
              .width(CommonConstants.FULL_WIDTH)
              .fontWeight(CommonConstants.FONT_WEIGHT_500)
              .fontColor($r('sys.color.font_primary'))
              .fontSize($r('app.float.news_detail_title_font_size'))
              .margin({ top: $r('app.float.news_detail_title_margin_top') })
              .textAlign(TextAlign.Start)

            Row() {
              Image($r('app.media.news_icon'))
                .width($r('app.float.news_detail_news_icon_width'))
                .height($r('app.float.news_detail_news_icon_width'))
                .clipShape(new CircleShape({ width: '32vp', height: '32vp' }))
              Column() {
                Text($r('app.string.news_author'))
                  .fontSize($r('app.float.news_detail_subtitle_font_size'))
                  .fontWeight(CommonConstants.FONT_WEIGHT_500)
                  .textAlign(TextAlign.Start)
                Text($r('app.string.news_create_time'))
                  .fontSize($r('app.float.news_detail_author_font_size'))
                  .fontWeight(CommonConstants.FONT_WEIGHT_400)
                  .fontColor($r('sys.color.ohos_id_color_text_tertiary'))
              }
              .margin({ left: $r('app.float.news_detail_author_area_margin_left') })
              .alignItems(HorizontalAlign.Start)
            }
            .width(CommonConstants.FULL_WIDTH)
            .margin({ top: $r('app.float.news_detail_title_area_margin_top') })
            .justifyContent(FlexAlign.Start)

            Text($r('app.string.news_part1'))
              .fontSize($r('app.float.news_detail_content_font_size'))
              .lineHeight($r('app.float.news_detail_content_line_height'))
              .width(CommonConstants.FULL_WIDTH)
              .textAlign(TextAlign.Start)
              .fontWeight(CommonConstants.FONT_WEIGHT_400)
              .margin({
                top: $r('app.float.news_detail_content1_margin_top')
              })

            Row() {
              Image($r('app.media.news_image'))
                .objectFit(ImageFit.Fill)
                .borderRadius($r('app.float.button_new_detail_radius_pc'))
                .width(new BreakpointType({
                  sm: CommonConstants.NEWS_IMAGE_WIDTH_SM,
                  md: CommonConstants.NEWS_IMAGE_WIDTH_MD,
                  lg: CommonConstants.NEWS_IMAGE_WIDTH_LG
                }).getValue(this.curBp))
                .height(new BreakpointType({
                  sm: $r('app.float.news_detail_image_height_sm'),
                  md: $r('app.float.news_detail_image_height_md'),
                  lg: $r('app.float.news_detail_image_height_lg')
                }).getValue(this.curBp))
            }
            .justifyContent(FlexAlign.Center)
            .margin({ top: $r('app.float.news_detail_image_margin_top') })

            Text($r('app.string.news_part2'))
              .fontSize($r('app.float.news_detail_content_font_size'))
              .lineHeight($r('app.float.news_detail_content_line_height'))
              .width(CommonConstants.FULL_WIDTH)
              .textAlign(TextAlign.Start)
              .fontWeight(CommonConstants.FONT_WEIGHT_400)
              .margin({ top: $r('app.float.news_detail_image_margin_top') })
            Text($r('app.string.news_part3'))
              .fontSize($r('app.float.news_detail_content_font_size'))
              .lineHeight($r('app.float.news_detail_content_line_height'))
              .width(CommonConstants.FULL_WIDTH)
              .textAlign(TextAlign.Start)
              .fontWeight(CommonConstants.FONT_WEIGHT_400)
              .margin({
                top: $r('app.float.news_detail_image_margin_top'),
                bottom: $r('app.float.news_detail_image_margin_top')
              })
          }
        }
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.Off)
        .margin({
          bottom: this.navigatorBarHeight,
        })
      }
    }
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
    .hideTitleBar(true)
    .backgroundColor($r('sys.color.background_secondary'))
  }
}
