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

import { display } from '@kit.ArkUI';
import { fileIo as fs } from '@kit.CoreFileKit';
import { image } from '@kit.ImageKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { ReadPageComponent, readerCore, bookParser } from '@kit.ReaderKit';
import { common, ConfigurationConstant } from '@kit.AbilityKit';
import { FontFileInfo } from '../common/FontFileInfo';
import Logger from '../utils/Logger';
import { BookUtils } from '../utils/BookUtils';
import { WindowAbility } from '../entryability/WindowAbility';
import CommonConstants from '../constants/CommonConstants';

interface paramType {
  filePath: string;
  resourceIndex: number;
  domPos: string;
}

const TAG: string = 'ReaderPage';

@Entry
@Component
struct Reader {
  @StorageLink(CommonConstants.KEY_WINDOW_WIDTH) windowWidth: number = 0;
  @StorageLink(CommonConstants.KEY_WINDOW_HEIGHT) windowHeight: number = 0;
  @StorageLink(CommonConstants.KEY_COLOR_MODE) @Watch('colorModeChange') colorMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET;
  /**
   * Display dialog box
   */
  @State showModalDialog: boolean = false;
  /**
   * Menu bar type index, 0 : catalog list, 1 : setting, 1 : close dialog
   */
  @State currentIndex: number = -1;
  @State catalogItemList: bookParser.CatalogItem[] = [];
  private currentData: readerCore.PageDataInfo | null = null;
  private defaultHandler: bookParser.BookParserHandler | null = null;
  @StorageLink(CommonConstants.KEY_CURRENT_BREAKPOINT) curBp: string = '';
  @StorageLink(CommonConstants.KEY_IS_WIDE) isW: boolean = false;
  private readerComponentController: readerCore.ReaderComponentController = new readerCore.ReaderComponentController();
  @State bookCover: PixelMap | null = null;
  @State bookTitle: string = '';
  @State author: string = '';
  @State fontSize: string = '18';
  @State lineHeight: string = '';
  private fontList: Array<FontFileInfo> =
    [new FontFileInfo(BookUtils.getString(this.getUIContext().getHostContext(), 'harmony_os_sans'),
      'fonts/HarmonyOS_Sans_Black.ttf'),
      new FontFileInfo(BookUtils.getString(this.getUIContext().getHostContext(), 'harmony_os_sans_thin'),
        'fonts/HarmonyOS_Sans_Thin.ttf')];
  @State selectFontPath: string = '';
  @State themeList: string[] = [
    'white',
    'yellow',
    'pink',
    'green',
    'dark',
    'whiteSky',
    'darkSky'
  ];
  private THEME_BUTTON_BACKGROUND: Record<string, Resource> = {
    'white': $r('app.color.ic_white_theme_button_background'),
    'yellow': $r('app.color.ic_yellow_theme_button_background'),
    'pink': $r('app.color.ic_pink_theme_button_background'),
    'green': $r('app.color.ic_green_theme_button_background'),
    'dark': $r('app.color.ic_dark_theme_button_background'),
    'whiteSky': $r('app.color.ic_white_theme_button_background'),
    'darkSky': $r('app.color.ic_dark_theme_button_background')
  }
  private THEME_PAGE_COLOR: Record<string, string> = {
    'white': '#FFFFFF',
    'yellow': '#BD9063',
    'pink': '#FFE4E5',
    'green': '#C5E7CE',
    'dark': '#202224',
    'whiteSky': '#FFFFFF',
    'darkSky': '#202224'
  }
  private themeBorderColor: Record<number, Resource> = {
    0: $r('app.color.ic_border_select_white'),
    1: $r('app.color.ic_border_select_yellow'),
    2: $r('app.color.ic_border_select_pink'),
    3: $r('app.color.ic_border_select_green'),
    4: $r('app.color.ic_border_select_white'),
    5: $r('app.color.ic_border_select_white'),
    6: $r('app.color.ic_border_select_white')
  }
  @State themeSelectIndex: number = 0;
  private readerSetting: readerCore.ReaderSetting = {
    fontName: BookUtils.getString(this.getUIContext().getHostContext(), 'system_font'),
    fontPath: '',
    fontSize: Number.parseInt(this.fontSize),
    fontColor: '#000000',
    fontWeight: 400,
    lineHeight: 1.9,
    nightMode: false,
    themeColor: 'rgba(248, 249, 250, 1)',
    themeBgImg: '',
    flipMode: '0',
    scaledDensity: this.getDefaultScaledDensity(),
    viewPortWidth: this.windowWidth,
    viewPortHeight: this.windowHeight
  };
  private screenDensityCallBack: Callback<number> | null = null;
  @State isLoading: boolean = true;
  @State isHalfFolded: boolean = false;
  onFoldStatusChange: (foldStatus: display.FoldStatus) => void = (foldStatus: display.FoldStatus) => {
    if (foldStatus === display.FoldStatus.FOLD_STATUS_FOLDED && this.curBp === 'sm') {
      this.isHalfFolded = true;
    } else if (foldStatus === display.FoldStatus.FOLD_STATUS_EXPANDED) {
      this.isHalfFolded = false;
    }
  }

  aboutToAppear(): void {
    this.isLoading = false;
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
          Logger.error('MultiDeviceCamera',
            `Failed to obtain fold status. Code: ${err.code}, message: ${err.message}`);
        }
      }
    } catch (error) {
      Logger.info(TAG,
        `isFoldable failed , Code: ${error.code}, message: ${error.message}`);
    }
    Logger.info(TAG, 'aboutToAppear');
    this.registerScreenDensityChange();
    this.registerListener();
    WindowAbility.getInstance().toggleWindowSystemBar([], this.getUIContext().getHostContext());
    let param = this.getUIContext().getRouter().getParams() as paramType;
    let filePath = param.filePath;
    let resourceIndex = param.resourceIndex;
    let domPos = param.domPos;
    this.startPlay(filePath, resourceIndex, domPos).catch(() => {
      Logger.error(TAG, `aboutToAppear startPlay failed`);
    });
  }

  getDefaultScaledDensity() {
    try {
      return display.getDefaultDisplaySync().scaledDensity > 0 ? display.getDefaultDisplaySync().scaledDensity : 1;
    } catch (error) {
      Logger.error(TAG, `getDefaultScaledDensity failed, error code: ${error.code}, message: ${error.message}.`);
    }
    return 1;
  }

  /**
   * The color mode of the system changed
   */
  colorModeChange() {
    if (this.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      this.readerSetting.nightMode = true;
      this.readerSetting.fontColor = '#ffffff';
      this.readerSetting.themeColor = '#202224';
    } else {
      this.readerSetting.nightMode = false;
      this.readerSetting.fontColor = '#000000';
      this.readerSetting.themeColor = '#FFFFFF';
    }
    try {
      this.readerComponentController.setPageConfig(this.readerSetting);
    } catch (error) {
      Logger.error(TAG,
        `colorModeChange setPageConfig failed, error code: ${error.code}, message: ${error.message}.`);
    }
  }

  /**
   * Register the screen density change callback.
   */
  registerScreenDensityChange() {
    this.screenDensityCallBack = () => {
      try {
        let displaySync = display.getDefaultDisplaySync();
        let scaledDensity = displaySync.scaledDensity;
        if (scaledDensity !== this.readerSetting.scaledDensity) {
          AppStorage.setOrCreate(CommonConstants.KEY_IS_DENSITY_CHANGE, true);
          this.getUIContext().getRouter().back();
        }
      } catch (error) {
        Logger.error(TAG,
          `registerScreenDensityChange getDefaultDisplaySync failed, error code: ${error.code}, message: ${error.message}.`);
      }
    }
    display.on('change', this.screenDensityCallBack);
  }

  /**
   * Resource request callback. Font files and theme background images can be stored
   * in the resources/rawfile directory or app sandbox path.
   */
  private resourceRequest: bookParser.CallbackRes<string, ArrayBuffer> = (filePath: string): ArrayBuffer => {
    Logger.info(TAG,
      'resourceRequest : filePath = ' + filePath + ', this.selectFontPath = ' + this.selectFontPath);
    if (filePath.length === 0) {
      return new ArrayBuffer(0);
    }
    let resourcePath = filePath;
    if (this.isFont(filePath)) {
      resourcePath = this.selectFontPath;
    }
    try {
      let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      let value: Uint8Array = context.resourceManager.getRawFileContentSync(resourcePath);
      Logger.info(TAG, 'resourceRequest : get other resource succeeded ');
      return value.buffer as ArrayBuffer;
    } catch (error) {
      let code = (error as BusinessError).code;
      let message = (error as BusinessError).message;
      Logger.error(TAG,
        `resourceRequest : get resource failed, error code: ${code}, message: ${message}.`);
    }
    // Obtain data from the sandbox path.
    return this.loadFileFromPath(resourcePath);
  }

  private registerListener(): void {
    this.readerComponentController.on('resourceRequest', this.resourceRequest);
    this.readerComponentController.on('pageShow', (data: readerCore.PageDataInfo): void => {
      Logger.info(TAG, 'pageshow: data is: ' + JSON.stringify(data));
      this.currentData = data;
      // Save the page data.
      AppStorage.setOrCreate(CommonConstants.KEY_CURRENT_DATA, this.currentData);
      if (data.state === readerCore.PageState.PAGE_ON_SHOW) {
        this.isLoading = false;
      }
    });
    WindowAbility.getInstance().onWindowSizeChange(() => {
      if (this.readerSetting.viewPortWidth != this.windowWidth ||
        this.readerSetting.viewPortHeight != this.windowHeight) {
        Logger.info(TAG, 'onWindowSizeChange is changed, update page config');
        // When the window size changes, update the current page viewport size.
        this.readerSetting.viewPortWidth = this.windowWidth;
        this.readerSetting.viewPortHeight = this.windowHeight;
        try {
          this.readerComponentController.setPageConfig(this.readerSetting);
        } catch (error) {
          Logger.error(TAG,
            `onWindowSizeChange failed, Code: ${error.code}, message: ${error.message}`);
        }
      }
    });
  }

  /**
   * @throws
   */
  private async startPlay(path: string, resourceIndex: number, domPos: string) {
    try {
      let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      let initPromise: Promise<void> = this.readerComponentController.init(context);
      let defaultHandler: Promise<bookParser.BookParserHandler> = bookParser.getDefaultHandler(path);
      let result: [bookParser.BookParserHandler, void] = await Promise.all([defaultHandler, initPromise]);
      this.defaultHandler = result[0];
      this.readerComponentController.registerBookParser(this.defaultHandler);
      this.readerComponentController.setPageConfig(this.readerSetting);
      this.readerComponentController.startPlay(resourceIndex || 0, domPos);
    } catch (error) {
      Logger.error(TAG, `startPlay failed, Code: ${error.code}, message: ${error.message}`);
    }
  }

  private async getBookInfo() {
    try {
      let bookInfo: bookParser.BookInfo | undefined = this.defaultHandler?.getBookInfo();
      if (bookInfo) {
        this.bookTitle = bookInfo.bookTitle || '';
        this.author = bookInfo?.bookCreator || '';
        // SpineIndex is not required for obtaining the book cover.
        let buffer = this.defaultHandler?.getResourceContent(-1, bookInfo.bookCoverImage);
        let imageSource: image.ImageSource = image.createImageSource(buffer);
        this.bookCover = await imageSource.createPixelMap();
        imageSource.release();
      }
      Logger.info(TAG, 'getBookInfo bookInfo is: ' + JSON.stringify(bookInfo));
    } catch (error) {
      Logger.error(TAG, `getBookInfo failed, Code: ${error.code}, message: ${error.message}`);
    }
  }

  aboutToDisappear(): void {
    try {
      display.off('change', this.screenDensityCallBack);
    } catch (error) {
      Logger.error(TAG, `aboutToDisappear display.off failed, Code: ${error.code}, message: ${error.message}`);
    }
    this.bookCover?.release();
    this.readerComponentController.off('pageShow');
    this.readerComponentController.off('resourceRequest');
    this.readerComponentController.releaseBook();
  }

  @Builder
  private buildCatalogItemList() {
    Column() {
      Row() {
        Stack({ alignContent: Alignment.Top }) {
          Image(this.bookCover)
            .draggable(false)
            .width(42)
            .aspectRatio(3 / 4)
            .borderRadius(2)
            .zIndex(1)
            .alt($r('app.media.default_cover'))

          Image($r('app.media.spines'))
            .draggable(false)
            .aspectRatio(3 / 4)
            .width(42)
            .borderRadius(2)
            .zIndex(2)
            .position({ x: 0, y: 0 })

          Image($r('app.media.cover_shadow'))
            .draggable(false)
            .width(42)
            .opacity(0.7)
            .aspectRatio(3)
            .position({ x: 0, y: 42 / 3 / 4 - 42 / 9 })
            .zIndex(0)
        }
        .width(42)
        .shadow({ radius: 18, color: '#4D000000' })
        .borderRadius(2)
        .aspectRatio(3 / 4)
        .visibility(this.bookTitle ? Visibility.Visible : Visibility.None)

        Text(this.bookTitle)
          .fontSize($r('sys.float.ohos_id_text_size_body1'))
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .margin({ right: 12, left: 12 })
          .fontWeight(FontWeight.Bold)
          .flexShrink(1)
          .fontColor('#E6000000')
          .height(40)
          .visibility(this.bookTitle ? Visibility.Visible : Visibility.None)
      }
      .padding({
        left: 16,
        right: 16
      })
      .width('100%')
      .margin({ bottom: 20 })
      .alignSelf(ItemAlign.Start)

      List() {
        ForEach(this.catalogItemList, (item: bookParser.CatalogItem) => {
          ListItem() {
            Column() {
              Row() {
                Row() {
                  Text(' · ')
                    .fontSize(14)
                    .fontColor($r('app.color.black_90_opacity'))
                  Text(item.catalogName)
                    .fontSize(14)
                    .fontColor($r('app.color.black_90_opacity'))
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .padding({ top: 8, bottom: 8 })
                    .maxLines(2)
                    .layoutWeight(1)
                }
              }
              .width('100%')
              .height(48)
              .justifyContent(FlexAlign.Center)
              .alignItems(VerticalAlign.Center)

              Divider()
            }
            .padding({
              left: item.catalogLevel ? item.catalogLevel * 26 : 16,
              right: 16,
              top: 6,
              bottom: 6
            })
            .onClick(async () => {
              this.jumpToCatalogItem(item);
            })
          }
        })
      }
      .scrollBar(BarState.Off)
      .width('100%')
      .height('100%')
    }
    .height('auto')
    .visibility(this.currentIndex === 0 ? Visibility.Visible : Visibility.None)
  }

  @Builder
  private buildSetting() {
    Scroll() {
      Column() {
        GridRow({
          columns: {
            xs: 2,
            sm: 2,
            md: 2,
            lg: 2,
            xl: 2,
          },
          gutter: { x: 16, y: 8 },
          breakpoints: { value: ['320vp', '600vp', '840vp', '1440vp', '1600vp'], },
          direction: GridRowDirection.Row
        }) {
          ForEach(this.fontList, (data: FontFileInfo) => {
            GridCol({ span: 1 }) {
              Column() {
                Text(data.getAlias())
                  .fontSize(14)
                  .borderRadius(12)
                  .borderWidth(1.5)
                  .width('100%')
                  .height(48)
                  .fontColor(this.selectFontPath !== data.getPath() ? Color.Black :
                    Color.Red)
                  .textAlign(TextAlign.Center)
                  .backgroundColor(this.selectFontPath !== data.getPath() ? $r('app.color.ic_text_input_bg') :
                    $r('app.color.ic_bg_font_selected'))
                  .borderColor(this.selectFontPath !== data.getPath() ? $r('app.color.color_transparent') :
                    $r('app.color.ic_border_select_white'))
              }
              .width('100%')
              .onClick(() => {
                this.selectFontPath = data.getPath();
                this.readerSetting.fontName = data.getAlias();
                this.readerSetting.fontPath = data.getPath();
                try {
                  this.readerComponentController.setPageConfig(this.readerSetting);
                } catch (error) {
                  Logger.info(TAG, `setFont failed, Code: ${error.code}, message: ${error.message}`);
                }
                Logger.info(TAG, 'getAlias: = ' + data.getAlias() + ' , getPath = ' + data.getPath());
              })
              .id(TAG + '_Stack_' + data.getAlias())
              .onAppear(() => {
                focusControl.requestFocus(TAG + '_Stack_' + data.getAlias());
              })
            }
          });
        }.margin({ top: 24, left: 16, right: 16 })

        Text()
          .width('92%')
          .height(1)
          .margin({ left: 16, top: 16, right: 16 })
          .backgroundColor($r('app.color.ic_bg_grey'))

        Row({ space: 12 }) {
          Radio({
            value: 'flipMode', group: 'radioGroup'
          })
            .height(20)
            .width(20)
            .checked(true)
            .radioStyle({
              checkedBackgroundColor: Color.Red,
            })
          .onClick(() => {
            this.readerSetting.flipMode = '0';
            try {
              this.readerComponentController.setPageConfig(this.readerSetting);
            } catch (error) {
              Logger.info(TAG, `setflipMode failed, Code: ${error.code}, message: ${error.message}`);
            }
          })
          Text($r('app.string.emulation_page'))
            .fontSize(16)
            .lineHeight(21)

          Radio({
            value: 'flipMode', group: 'radioGroup'
          })
            .height(20)
            .width(20)
            .checked(false)
            .radioStyle({
              checkedBackgroundColor: Color.Red,
            })
          .onClick(() => {
            this.readerSetting.flipMode = '1';
            try {
              this.readerComponentController.setPageConfig(this.readerSetting);
            } catch (error) {
              Logger.info(TAG, `setflipMode failed, Code: ${error.code}, message: ${error.message}`);
            }
          })
          Text($r('app.string.transversal_slip_page'))
            .fontSize(16)
            .lineHeight(21)
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)
        .padding({ left: 16, right: 16 })
        .margin({ top: 16 })

        Text()
          .width('92%')
          .height(1)
          .margin({ left: 16, top: 16, right: 16 })
          .backgroundColor($r('app.color.ic_bg_grey'))

        Scroll() {
          Row({ space: 12 }) {
            ForEach(this.themeList, (item: string, index: number) => {
              Stack() {
                Row()
                  .width('100%')
                  .height(40)
                  .borderWidth(this.themeSelectIndex !== index ? 1 : 2)
                  .borderColor(this.themeSelectIndex !== index ? $r('app.color.ic_border_unselect') :
                    this.themeBorderColor[this.themeSelectIndex])
                  .backgroundImage(this.getBackgroundImage(item))
                  .backgroundColor(this.THEME_BUTTON_BACKGROUND[item.toString()])
                  .backgroundImagePosition(Alignment.BottomEnd)
                  .backgroundImageSize(ImageSize.Cover)
                  .borderRadius(20)
                  .id(TAG + '_Row_' + index)
              }
              .width(`calc((100% - ${(this.themeList.length - 1) * 12}vp) / ${this.themeList.length})`)
              .constraintSize({
                minWidth: 60
              })
              .borderRadius(30)
              .borderStyle(BorderStyle.Solid)
              .onClick(() => {
                this.themeSelectIndex = index;
                this.readerSetting.themeColor = this.THEME_PAGE_COLOR[item];
                this.readerSetting.nightMode = false;
                if (index === 5) {
                  this.readerSetting.themeBgImg = 'white_sky_first.jpg';
                  this.readerSetting.fontColor = '#000000';
                } else if (index === 6) {
                  this.readerSetting.themeBgImg = 'dark_sky_first.jpg';
                  this.readerSetting.fontColor = '#ffffff';
                  this.readerSetting.nightMode = true;
                } else if (index == 4) {
                  this.readerSetting.themeBgImg = '';
                  this.readerSetting.nightMode = true;
                  this.readerSetting.fontColor = '#ffffff';
                } else {
                  this.readerSetting.themeBgImg = '';
                  this.readerSetting.fontColor = '#000000';
                }
                try {
                  this.readerSetting.scaledDensity = display.getDefaultDisplaySync().scaledDensity;
                  this.readerComponentController.setPageConfig(this.readerSetting);
                } catch (error) {
                  Logger.info(TAG, `setTheme failed, Code: ${error.code}, message: ${error.message}`);
                }
              })
              .id(TAG + '_Stack_' + index)
              .onAppear(() => {
                focusControl.requestFocus(TAG + '_Stack_' + index);
              })
            })
          }
          .constraintSize({
            minWidth: '100%'
          })
          .id(TAG + '_Row_1')
          .padding({
            left: 16,
            right: 16,
            top: 12,
            bottom: 12
          })
        }
        .margin({ top: 8 })
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)

        Text()
          .width('92%')
          .height(1)
          .margin({ left: 16, top: 8, right: 16 })
          .backgroundColor($r('app.color.ic_bg_grey'))

        TextInput({ placeholder: $r('app.string.font_size_placeholder'), text: this.fontSize })
          .margin({
            left: 16,
            top: 10,
            right: 16,
            bottom: 10
          })
          .backgroundColor($r('app.color.ic_text_input_bg'))
          .placeholderColor('#666666')
          .type(InputType.Number)
          .fontSize(16)
          .onChange((value: string) => {
            this.fontSize = value;
          })

        TextInput({ placeholder: $r('app.string.line_height_placeholder'), text: this.lineHeight })
          .margin({ left: 16, right: 16, bottom: 10 })
          .backgroundColor($r('app.color.ic_text_input_bg'))
          .placeholderColor('#666666')
          .type(InputType.NUMBER_DECIMAL)
          .fontSize(16)
          .onChange((value: string) => {
            this.lineHeight = value;
          })

        Button($r('app.string.update_font_size_and_line_height'))
          .onClick(() => {
            Logger.info(TAG,
              'click : update page setting, fontSize = ' + this.fontSize + ' ,lineHeight = ' + this.lineHeight);
            if (!isNaN(Number.parseInt(this.fontSize))) {
              this.readerSetting.fontSize = Number.parseInt(this.fontSize);
            }
            if (!isNaN(Number.parseInt(this.lineHeight))) {
              this.readerSetting.lineHeight = Number.parseInt(this.lineHeight);
            }
            try {
              this.readerComponentController.setPageConfig(this.readerSetting);
            } catch (error) {
              Logger.info(TAG,
                `set fontSize or lineHeight failed, Code: ${error.code}, message: ${error.message}`);
            }
          })
          .fontSize(16)
          .width('calc(100% - 32vp)')
          .fontColor(Color.Red)
          .backgroundColor($r('app.color.ic_text_input_bg'))
          .margin({ left: 16, right: 16, bottom: 30 })

      }
      .visibility(this.currentIndex === 1 ? Visibility.Visible : Visibility.None)
      .alignItems(HorizontalAlign.Center)
      .height('auto')
    }
    .scrollBar(BarState.Off)
  }

  @Builder
  private closeBtn() {
    Column() {
      Row() {
        Image($r('app.media.xmark'))
          .width(20)
          .height(20)
          .opacity(0.9)
      }
      .justifyContent(FlexAlign.Center)
      .width(42)
      .height(42)
      .borderRadius(42)
      .margin({ top: 16, right: 16 })
      .backgroundColor(Color.White)
      .onClick(() => {
        this.showModalDialog = false;
      })
    }
    .width('100%')
    .alignItems(HorizontalAlign.End)
    .backgroundColor('rgba(255,255,255,0.9)')
  }

  @Builder
  SheetBuilder() {
    this.closeBtn()
    Column() {
      Column() {
        Column() {
          // catalog list view
          this.buildCatalogItemList()
          // setting view
          this.buildSetting()
        }
      }
      .clip(true)
      .visibility(this.currentIndex < 0 ? Visibility.None : Visibility.Visible)
      .width('100%')
      .height(this.isHalfFolded ? 190 : 'calc(100%  - 36vp)')

      Column() {
        Row() {
          Button($r('app.string.catalog_list'))
            .backgroundColor($r('app.color.blue'))
            .fontColor(Color.White)
            .width('calc(50% - 6vp)')
            .height(40)
            .onClick(() => {
              this.jumpToCatalogList();
            })
          Button($r('app.string.setting'))
            .width('calc(50% - 6vp)')
            .height(40)
            .fontColor($r('app.color.blue'))
            .backgroundColor($r('app.color.black_5_opacity'))
            .onClick(() => {
              this.jumpToSetting();
            })
        }
        .height(40)
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
        .padding({ left: 16, right: 16 })
      }
    }
    .backgroundColor('rgba(255,255,255,0.05)')
    .width('100%')
    .height('calc(100% - 42vp)')
    .justifyContent(FlexAlign.End)
    .padding({ bottom: 44 })
    .onClick(() => {
      this.closeModal();
    })
  }

  build() {
    Stack() {
      Column() {
        Image($r('app.media.article'))
          .width('100%')
          .objectFit(ImageFit.Cover)
      }
      .margin({ top: 64 })
      .width('100%')
      .height('100%')
      .padding(16)

      ReadPageComponent({
        controller: this.readerComponentController,
        readerCallback: (err: BusinessError, data: readerCore.ReaderComponentController) => {
          this.readerComponentController = data;
          if (err) {
            Logger.info(TAG, `ReadPageComponent init failed, Code: ${err.code}, message: ${err.message}`);
          }
        }
      }).zIndex(1)
      // menu bar

      Row() {
        Text('加载中...')
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .zIndex(3)
      .visibility(this.isLoading ? Visibility.Visible : Visibility.None)
    }
    .width('100%')
    .height('100%')
    .onClick(() => {
      this.showModalDialog = true;
    })
    .backgroundColor($r('app.color.page_background'))
    .bindSheet($$this.showModalDialog, this.SheetBuilder(), {
      detents: [600],
      preferType: this.isW ? SheetType.CENTER : SheetType.BOTTOM,
      showClose: false,
    })
  }

  /**
   * close menu bar
   */
  private closeModal() {
    this.showModalDialog = false;
    this.currentIndex = -1;
  }

  private jumpToCatalogList() {
    this.currentIndex = 0;
    try {
      this.catalogItemList = this.defaultHandler?.getCatalogList() || [];
    } catch (error) {
      Logger.info(TAG, `getCatalogList failed, Code: ${error.code}, message: ${error.message}`);
    }
    this.getBookInfo();
    Logger.info(TAG, 'catalog list length: ' + this.catalogItemList.length);
  }

  private jumpToSetting() {
    this.currentIndex = 1;
  }

  private async jumpToCatalogItem(catalogItem: bookParser.CatalogItem) {
    const domPos = await this.getDomPos(catalogItem);
    const resourceIndex = this.getResourceItemByCatalog(catalogItem).index;
    this.readerComponentController.startPlay(resourceIndex, domPos).catch(() => {
      Logger.info(TAG, `startPlay failed`);
    });
    this.closeModal();
  }

  private async getDomPos(catalogItem: bookParser.CatalogItem): Promise<string> {
    try {
      const domPos: string = this.defaultHandler?.getDomPosByCatalogHref(catalogItem.href || '') || '';
      return domPos;
    } catch (error) {
      Logger.info(TAG, `getDomPos failed, Code: ${error.code}, message: ${error.message}`);
    }
    return Promise.reject();
  }

  private getResourceItemByCatalog(catalogItem: bookParser.CatalogItem): bookParser.SpineItem {
    let resourceFile = catalogItem.resourceFile || '';
    try {
      let spineList: bookParser.SpineItem[] = this.defaultHandler?.getSpineList() || [];
      let resourceItemArr = spineList.filter(item => item.href === resourceFile);
      if (resourceItemArr.length > 0) {
        Logger.info(TAG, 'getResourceItemByCatalog get resource ', JSON.stringify(resourceItemArr[0]));
        let resourceItem = resourceItemArr[0];
        return resourceItem;
      } else if (spineList.length > 0) {
        Logger.info(TAG, 'getResourceItemByCatalog get resource in resourceList', JSON.stringify(spineList[0]));
        return spineList[0];
      }
    } catch (error) {
      Logger.info(TAG, `getSpineList failed, Code: ${error.code}, message: ${error.message}`);
    }
    Logger.info(TAG, 'getResourceItemByCatalog get resource in escape');
    return {
      idRef: '',
      index: 0,
      href: '',
      properties: ''
    };
  }

  getBackgroundImage(themeType: string): Resource | string {
    if (themeType === 'whiteSky') {
      return $r('app.media.white_sky_icon');
    } else if (themeType === 'darkSky') {
      return $r('app.media.dark_sky_icon');
    }
    return '';
  }

  private isFont(filePath: string): boolean {
    let options = ['.ttf', '.woff2', '.otf'];
    let path = filePath.toLowerCase();
    let result = path.indexOf(options[0]) != -1 || path.indexOf(options[1]) != -1 || path.indexOf(options[2]) != -1;
    Logger.info(TAG, 'isFont = ' + result);
    return result;
  }

  private loadFileFromPath(filePath: string): ArrayBuffer {
    try {
      let stats = fs.statSync(filePath);
      let file = fs.openSync(filePath, fs.OpenMode.READ_ONLY);
      let buffer = new ArrayBuffer(stats.size);
      fs.readSync(file.fd, buffer);
      fs.closeSync(file);
      return buffer;
    } catch (error) {
      Logger.error(TAG, `loadFileFromPath failed, Code: ${error.code}, message: ${error.message}`);
      return new ArrayBuffer(0);
    }
  }

  /**
   * Remove the page transition animation to speed up the page access speed of the reader
   */
  pageTransition() {
    PageTransitionEnter({ duration: 0, curve: Curve.Sharp });
    PageTransitionExit({ duration: 0, curve: Curve.Sharp });
  }
}