/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { fileIo } from '@kit.CoreFileKit';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { CommonConstants } from '../common/CommonConstants';
import MediaFileUri from '../media/MediaFileUri';
import { UrisParam } from './PickerComponent';
import Logger from '../utils/Logger';

const TAG = 'ViewMedia';

@Builder
export function ViewMediaBuilder(name: string, params: UrisParam) {
  ViewMedia();
}

@Component
struct ViewMedia {
  @State myFileSizes: number[] = [];
  @State myFileNames: string[] = [];
  @State myFileTypes: number[] = [];
  @State controls: Array<boolean> = [];
  @State myUris: string[] = [];
  @StorageLink(CommonConstants.AS_KEY_MY_FILE_NAME) myFileName: string = '';
  @StorageLink(CommonConstants.AS_KEY_MY_FILE_SIZE) myFileSize: number = 0;
  @StorageLink('showPauses') showPauses: Array<number> = [];
  @StorageProp(CommonConstants.AS_KEY_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  @StorageProp(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageProp(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  mediaFileUri: MediaFileUri = new MediaFileUri();
  scroller: Scroller = new Scroller();
  controllers: Array<VideoController> = [];
  @Consume(CommonConstants.AS_KEY_PATH_STACK) pageStack: NavPathStack;

  aboutToAppear(): void {
    if (this.pageStack.getParamByName('ViewMedia').length === 0) {
      return;
    }
    let uriParams: UrisParam = this.pageStack.getParamByName('ViewMedia')[0] as UrisParam;
    this.myUris = uriParams.uris;
    this.getImagesInfo();
    this.myFileName = this.myFileNames[0];
    this.myFileSize = this.myFileSizes[0];
    Logger.info(TAG, 'onPageShow getFilenameByUriForMedia begin');
    AppStorage.setOrCreate(CommonConstants.AS_KEY_MY_FILE_NAME, this.myFileName);
    AppStorage.setOrCreate(CommonConstants.AS_KEY_MY_FILE_SIZE, this.myFileSize);
  }

  async getMediaNameByUri(myUri: string, index: number) {
    Logger.info(TAG, 'getMediaNameByUri getFilenameByUriForMedia begin');
    this.myFileName = (myUri.split('/').pop()) as string;
    this.myFileNames[index] = this.myFileName;
  }

  getImagesInfo() {
    for (let index = 0; index < this.myUris.length; index++) {
      Logger.info(TAG,
        'getFilenameByUriForMedia  getImagesInfo  index: ' + index + '===' + JSON.stringify(this.myUris[index]));
      this.controllers[index] = new VideoController();
      this.controls[index] = false;
      this.getMediaNameByUri(this.myUris[index], index);
      this.myFileSizes[index] = this.mediaFileUri.myGetFileSize(this.myUris[index], fileIo.OpenMode.READ_ONLY);
    }
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          Button({ type: ButtonType.Circle }) {
            SymbolGlyph($r('sys.symbol.chevron_backward'))
              .fontSize($r('sys.float.Title_M'))
              .fontColor([$r('sys.color.font_primary')])
          }
          .focusable(true)
          .focusOnTouch(true)
          .id('back2Index')
          .height(40)
          .aspectRatio(1)
          .backgroundColor($r('sys.color.comp_background_tertiary'))
          .onClick(() => {
            this.pageStack.pop();
          })

          // File name and information.
          Column() {
            Row() {
              Text(this.myFileName)
                .focusable(true)
                .focusOnTouch(true)
                .fontSize($r('app.float.text_font_size'))
                .fontFamily('HarmonyHeiTi-Bold')
                .fontColor($r('sys.color.font_primary'))
                .textAlign(TextAlign.Start)
                .fontWeight(CommonConstants.TEXT_FONT_WEIGHT)
                .lineHeight($r('app.float.text_height'))
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .width(CommonConstants.FULL_PERCENT)
            .align(Alignment.Start)
            .margin({
              top: CommonConstants.MARGIN_TOP,
              bottom: CommonConstants.MARGIN_ZERO_POINT_THREE_PERCENT
            })

            Row() {
              Text('size: ' + JSON.stringify(this.myFileSize) + 'B')
                .focusable(true)
                .focusOnTouch(true)
                .opacity(CommonConstants.TEXT_OPACITY)
                .fontFamily('HarmonyHeiTi')
                .fontSize($r('app.float.text_font_size_14'))
                .fontColor($r('sys.color.font_primary'))
                .textAlign(TextAlign.Start)
                .lineHeight($r('app.float.text_height_19'))
                .fontWeight(CommonConstants.TEXT_FONT_WEIGHT_400)
            }
            .width(CommonConstants.FULL_PERCENT)
            .margin({
              top: CommonConstants.MARGIN_ZERO_POINT_THREE_PERCENT,
              bottom: CommonConstants.MARGIN_ZERO_POINT_FIVE_PERCENT
            })
            .align(Alignment.Start)
          }
          .margin({ left: $r('sys.float.padding_level4') })
          .width(CommonConstants.FORTY_FIVE_PERCENT)
        }
        .padding({
          left: new BreakpointType({
            sm: $r('sys.float.padding_level8'),
            md: $r('sys.float.padding_level12'),
            lg: $r('sys.float.padding_level16')
          }).getValue(this.curBp),
          right: new BreakpointType({
            sm: $r('sys.float.padding_level8'),
            md: $r('sys.float.padding_level12'),
            lg: $r('sys.float.padding_level16')
          }).getValue(this.curBp)
        })
        .height(56)
        .width(CommonConstants.FULL_PERCENT)
        .zIndex(2)

        Column() {
          Scroll(this.scroller) {
            Column() {
              List() {
                ForEach(this.myUris, (uri: string, index: number) => {
                  ListItem() {
                    Column() {
                      Image(uri)
                        .borderRadius(16)
                        .margin({
                          bottom: new BreakpointType({
                            sm: $r('sys.float.padding_level6'),
                            md: $r('sys.float.padding_level8'),
                            lg: $r('sys.float.padding_level10')
                          }).getValue(this.curBp)
                        })
                        .onClick(() => {
                          if (index !== undefined) {
                            this.myFileSize = this.myFileSizes[index];
                            this.myFileName = this.myFileNames[index];
                          }
                          AppStorage.setOrCreate(CommonConstants.AS_KEY_MY_FILE_NAME, this.myFileName);
                          AppStorage.setOrCreate(CommonConstants.AS_KEY_MY_FILE_SIZE, this.myFileSize);
                          Logger.info(TAG, 'Obtain the name and size of the clicked image.');
                        })
                      if (uri.endsWith('.mp4')) {
                        Stack({ alignContent: Alignment.Center }) {
                          Video({
                            src: uri,
                            controller: this.controllers[index],
                            previewUri: $r('app.media.img')
                          })
                            .foregroundBlurStyle(
                              this.controls[index] === false ? BlurStyle.Thin : BlurStyle.NONE,
                              this.controls[index] === false ? {
                                colorMode: ThemeColorMode.SYSTEM,
                                adaptiveColor: AdaptiveColor.DEFAULT,
                                blurOptions: { grayscale: [50, 50] },
                                scale: 0.5
                              } : {})
                            .margin({
                              bottom: new BreakpointType({
                                sm: $r('sys.float.padding_level6'),
                                md: $r('sys.float.padding_level8'),
                                lg: $r('sys.float.padding_level10')
                              }).getValue(this.curBp)
                            })
                            .onStart(() => {
                              this.controls[index] = true;
                            })
                            .onFinish(() => {
                              this.controls[index] = false;
                            })
                            .onPause(() => {
                              this.controls[index] = false;
                            })
                            .autoPlay(false)
                            .controls(this.controls[index])
                            .borderRadius(16)

                          Image($r('app.media.ic_PAUSE'))
                            .width(40)
                            .height(40)
                            .onClick(() => {
                              this.controllers[index].start();
                              this.showPauses[index] = 0;

                              this.myFileSize = this.myFileSizes[index];
                              this.myFileName = this.myFileNames[index];
                              AppStorage.setOrCreate(CommonConstants.AS_KEY_MY_FILE_NAME, this.myFileName);
                              AppStorage.setOrCreate(CommonConstants.AS_KEY_MY_FILE_SIZE, this.myFileSize);
                            })
                            .visibility(this.controls[index] === false ? Visibility.Visible : Visibility.Hidden)
                        }
                        .onClick(() => {
                          this.myFileSize = this.myFileSizes[index];
                          this.myFileName = this.myFileNames[index];

                          AppStorage.setOrCreate(CommonConstants.AS_KEY_MY_FILE_NAME, this.myFileName);
                          AppStorage.setOrCreate(CommonConstants.AS_KEY_MY_FILE_SIZE, this.myFileSize);
                        })
                      }
                    }
                    .height(CommonConstants.FULL_PERCENT)
                  }
                  .height(190)
                }, (item: string) => item)
              }
              .lanes(new BreakpointType({ sm: 1, md: 2, lg: 4 }).getValue(this.curBp), 20)
              .width(CommonConstants.FULL_PERCENT)
              .height(new BreakpointType({
                sm: 190 * this.myUris.length,
                md: 190 * Math.ceil(this.myUris.length / 2),
                lg: 190
              }).getValue(this.curBp))
              .id('picScroller')
              .scrollBar(BarState.Auto)
            }
            .padding({
              top: CommonConstants.ONE_POINT_FIVE_PERCENT,
              left: new BreakpointType({
                sm: $r('sys.float.padding_level8'),
                md: $r('sys.float.padding_level12'),
                lg: $r('sys.float.padding_level16')
              }).getValue(this.curBp),
              right: new BreakpointType({
                sm: $r('sys.float.padding_level8'),
                md: $r('sys.float.padding_level12'),
                lg: $r('sys.float.padding_level16')
              }).getValue(this.curBp)
            })
          }
          .padding({ bottom: this.navigatorBarHeight })
        }
        .align(Alignment.Start)
        .layoutWeight(1)
      }
      .backgroundColor($r('sys.color.gray_01'))
      .height(CommonConstants.FULL_PERCENT)
      .padding({ top: this.statusBarHeight })
    }
    .hideTitleBar(true)
  }
}