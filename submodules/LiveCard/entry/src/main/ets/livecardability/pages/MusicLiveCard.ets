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

import { formInfo, formProvider } from '@kit.FormKit';
import { SongItem } from '../../model/music/SongItem';
import { collectAlignRules } from '../../model/music/MusicConstants';
import { Logger } from '../../utils/Logger';
import { ColorConstants } from '../../common/ColorConstants';
import { BorderRadius, CardPadding, FONT_STYLES, IconSize, SPACING } from '../../common/CommonConstants';
import {
  COVER_CONFIGS,
  CoverConfig,
  DANCE_FRAME_IMAGES,
  SWITCH_FRAME_IMAGES,
  SWITCH_FRAME_IMAGES_STR
} from '../../model/music/MusicLiveCardConstant';
import ImageUtils from '../../utils/ImageUtils';
import { LIVE_CARD_DURATION, LiveCardScale } from '../../model/common/FormCardConstant';

const TAG: string = '[MusicLiveForm]';

// 原始数据常量
const IMG_W = 4000;
const IMG_H = 2456;
const IMG_RATIO = IMG_W / IMG_H; // 约 1.628

@Entry({ useSharedStorage: true })
@Component
struct MusicLiveCard {
  @LocalStorageProp('formId') formId: string = '';
  @LocalStorageProp('currentSong') currentSong: SongItem = new SongItem();
  @LocalStorageProp('previousSong') previousSong?: SongItem = undefined;
  @LocalStorageProp('formRect') formRect?: formInfo.Rect = undefined;
  @LocalStorageProp('borderRadius') formRadius: number = 0;
  @LocalStorageLink('triggerAction') @Watch('onTriggerActionChange') triggerAction: string = '';
  @State @Watch('frameChange') currentCoverFrame: number = 0;
  private currentConfig: CoverConfig = COVER_CONFIGS[0];
  @State currentImages: Resource[] = [];
  @State totalFrames: number = 0;
  @State frameDuration: number = LIVE_CARD_DURATION;
  private coverSyncTimer: number = -1;
  private switchFrameImages: Resource[] = SWITCH_FRAME_IMAGES;

  private danceFrameImages: Resource[] = DANCE_FRAME_IMAGES;

  @State rotateAngle: number = 0;
  private rotateTimer: number = -1;
  @State imageStr: string[] = SWITCH_FRAME_IMAGES_STR;

  private canvasSettings: RenderingContextSettings = new RenderingContextSettings(true);
  private canvasContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.canvasSettings);
  private canvasWidth: number = 0;
  private canvasHeight: number = 0;
  private cachedAlbumImage?: ImageBitmap;

  @State offsetX: number = 0;
  @State showAlbumImage: boolean = false;

  frameChange(): void {
    this.drawCanvasFrame();
  }

  aboutToAppear(): void {
    Logger.info(TAG, `MusicExtensionPage aboutToAppear triggerAction: ${this.triggerAction}`);
    this.initAnimationByAction();
    if (this.formRect) {
      this.offsetX = calcAlbumShift(this.formRect.width, this.formRect.height,
        LiveCardScale.MUSIC_WIDTH, LiveCardScale.MUSIC_HEIGHT);
    }
  }

  onTriggerActionChange(): void {
    Logger.info(TAG, `onTriggerActionChange triggerAction: ${this.triggerAction}`);
    this.initAnimationByAction();
    this.startCoverSync();
  }

  initAnimationByAction(): void {
    if (!this.triggerAction) {
      Logger.info(TAG, 'initAnimationByAction: triggerAction is empty, skip init');
      return;
    }
    if (this.triggerAction === 'PLAY') {
      this.currentImages = this.danceFrameImages;
      this.totalFrames = this.danceFrameImages.length;
      this.startRotate();
    } else if (this.triggerAction === 'PREVIOUS' || this.triggerAction === 'NEXT') {
      this.currentImages = this.switchFrameImages;
      this.totalFrames = this.switchFrameImages.length;
    }
    Logger.info(TAG, `initAnimationByAction: triggerAction=${this.triggerAction}, totalFrames=${this.totalFrames}`);
  }

  aboutToDisappear(): void {
    this.stopCoverSync();
    this.stopRotate();
    this.cachedAlbumImage = undefined;
  }

  startRotate(): void {
    if (this.rotateTimer !== -1) {
      return;
    }
    this.rotateTimer = setInterval(() => {
      this.rotateAngle = (this.rotateAngle + 3) % 360;
    }, 50);
  }

  stopRotate(): void {
    if (this.rotateTimer !== -1) {
      clearInterval(this.rotateTimer);
      this.rotateTimer = -1;
    }
  }

  startCoverSync(): void {
    if (this.totalFrames === 0 || this.frameDuration === 0) {
      return;
    }
    this.stopCoverSync();
    const frameInterval = Math.max(16, Math.floor(this.frameDuration / this.totalFrames));
    this.coverSyncTimer = setInterval(() => {
      if (this.currentCoverFrame === this.totalFrames - 1) {
        clearInterval(this.coverSyncTimer);
      } else if (this.currentCoverFrame < this.totalFrames - 1) {
        this.currentCoverFrame++;
      }
    }, frameInterval);
  }

  stopCoverSync(): void {
    if (this.coverSyncTimer !== -1) {
      clearInterval(this.coverSyncTimer);
      this.coverSyncTimer = -1;
    }
  }

  getMainAlbumCover(): Resource {
    if ((this.triggerAction === 'PREVIOUS' || this.triggerAction === 'NEXT') && this.previousSong) {
      return this.previousSong.label;
    }
    return this.currentSong.label;
  }

  getCurrentCoverConfig(): CoverConfig {
    if (this.triggerAction === 'PREVIOUS' || this.triggerAction === 'NEXT') {
      this.currentConfig = COVER_CONFIGS[this.currentCoverFrame] || COVER_CONFIGS[0];
    } else {
      this.currentConfig = { x: 0, y: 0, rotateX: 0, rotateY: 0, rotateZ: 0, scale: 1, visible: false };
    }
    return this.currentConfig;
  }

  private drawCanvasFrame(): void {
    if (!this.canvasContext || this.currentCoverFrame >= this.imageStr.length) {
      return;
    }
    const currentOffsetX = this.offsetX * this.currentCoverFrame / this.imageStr.length;
    const canvasW = this.canvasContext.width;
    const canvasH = this.canvasContext.height;
    const ctx = this.canvasContext;
    ctx.clearRect(0, 0, canvasW, canvasH);

    const offsetX = (canvasW - this.canvasWidth) / 2;
    const offsetY = (canvasH - this.canvasHeight) / 2;

    const config = this.getCurrentCoverConfig();
    if (config.visible) {
      const albumSize = this.canvasHeight * 0.3;
      const albumX = this.canvasWidth * config.x / 100 - currentOffsetX;
      const albumY = this.canvasHeight * config.y / 100;
      const centerX = albumX + albumSize / 2 + offsetX;
      const centerY = albumY + albumSize / 2 + offsetY;

      ctx.save();
      ctx.beginPath();
      ctx.rect(offsetX - currentOffsetX, offsetY, this.canvasWidth, this.canvasHeight);
      ctx.clip();
      ctx.translate(centerX, centerY);

      const radX = config.rotateX * Math.PI / 180;
      const radY = config.rotateY * Math.PI / 180;
      const radZ = config.rotateZ * Math.PI / 180;

      ctx.transform(
        Math.cos(radZ) * config.scale,
        Math.sin(radZ) * config.scale,
        -Math.sin(radZ) * config.scale,
        Math.cos(radZ) * config.scale,
        0,
        0
      );

      const scaleX = Math.cos(radY);
      const scaleY = Math.cos(radX);
      ctx.scale(scaleX, scaleY);

      ctx.beginPath();
      ctx.arc(0, 0, albumSize / 2, 0, Math.PI * 2);
      ctx.clip();

      const albumImage = this.cachedAlbumImage ?? ImageUtils.getImageBitmapByMediaResource(
        this.getUIContext().getHostContext() as Context,
        this.currentSong.label);
      if (!this.cachedAlbumImage) {
        this.cachedAlbumImage = albumImage;
      }
      ctx.drawImage(albumImage, -albumSize / 2, -albumSize / 2, albumSize, albumSize);

      ctx.restore();
    }
    ctx.save();
    const frameImage = ImageUtils.getImageBitmapByRawfileResource(
      this.getUIContext().getHostContext() as Context,
      this.imageStr[this.currentCoverFrame]);
    ctx.drawImage(frameImage, offsetX - currentOffsetX, offsetY, this.canvasWidth, this.canvasHeight);
    ctx.restore();
  }



  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      RelativeContainer() {
        Image($rawfile('music/background.png'))
          .objectFit(ImageFit.Cover)
          .clip(true)
          .width('100%')
          .height('100%');
        Row() {
          Stack({ alignContent: Alignment.Center }) {
            Image($rawfile('music/album_background.png'))
              .height('100%')
              .width('100%');
            Image($rawfile('music/album.png'))
              .height('60%')
              .width('60%')
              .offset({
                y: '1.5%'
              });
            if (this.currentSong.id !== '') {
              Image(this.getMainAlbumCover())
                .objectFit(ImageFit.Cover)
                .height('35%')
                .width('35%')
                .visibility(this.showAlbumImage ? Visibility.Visible : Visibility.Hidden)
                .offset({
                  y: '1.5%'
                })
                .borderRadius('100%')
                .rotate({
                  angle: this.rotateAngle,
                  centerX: '50%',
                  centerY: '50%'
                })
                .onComplete(() => {
                  this.showAlbumImage = true;
                });
            }
          }
          .height('100%')
          .borderRadius(BorderRadius.SMALL + 6)
          .aspectRatio(1);

          Column() {
            Row() {
              Text($r(this.currentSong.title))
                .fontSize(FONT_STYLES.titleLarge.fontSize)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis });
            }
            .justifyContent(FlexAlign.Center)
            .width('100%')
            .height(24);
            Row() {
              SymbolGlyph(this.currentSong.isCollected ? $r('sys.symbol.heart_fill') : $r('sys.symbol.heart'))
                .fontSize(IconSize.MEDIUM)
                .symbolEffect(new ReplaceSymbolEffect(EffectScope.WHOLE), true)
                .fontColor([ColorConstants.ICON_LIGHT])
                .alignRules(collectAlignRules);

              SymbolGlyph($r('sys.symbol.backward_fill'))
                .fontSize(IconSize.MEDIUM)
                .margin({ left: SPACING.buttonPadding })
                .fontColor([ColorConstants.ICON_LIGHT]);
              SymbolGlyph($r('sys.symbol.pause_fill'))
                .fontSize(IconSize.MEDIUM)
                .margin({ left: SPACING.medium, right: SPACING.medium })
                .symbolEffect(new ReplaceSymbolEffect(EffectScope.WHOLE), true)
                .fontColor([ColorConstants.ICON_LIGHT])
                .padding(SPACING.small)
                .borderRadius(BorderRadius.BUTTON)
                .backgroundColor(ColorConstants.BUTTON_BG_LIGHT);
              SymbolGlyph($r('sys.symbol.fast_forward'))
                .fontSize(IconSize.MEDIUM)
                .margin({ right: SPACING.buttonPadding })
                .fontColor([ColorConstants.ICON_LIGHT]);
              SymbolGlyph($r('sys.symbol.repeat'))
                .fontSize(IconSize.MEDIUM)
                .fontColor([ColorConstants.ICON_LIGHT]);
            }
            .justifyContent(FlexAlign.Center)
            .margin({ top: SPACING.small })
            .width('100%');
          }
          .height('100%')
          .layoutWeight(1)
          .padding({ top: CardPadding.CARD });
        };
      }
      .height(this.formRect?.height)
      .width(this.formRect?.width)
      .borderRadius(this.formRadius)
      .clip(true)
      .margin({
        left: this.formRect?.left,
        top: this.formRect?.top,
      });


      if (this.triggerAction === 'PLAY') {
        Image(this.danceFrameImages[this.currentCoverFrame])
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Contain)
          .onAppear(() => {
            Logger.info(TAG, `PLAY Image onAppear`);
            this.startCoverSync();
          });
      } else {
        Canvas(this.canvasContext)
          .width('100%')
          .height('100%')
          .onReady(() => {
            if (this.canvasContext.width / this.canvasContext.height > IMG_RATIO) {
              this.canvasHeight = this.canvasContext.height;
              this.canvasWidth = this.canvasHeight * IMG_RATIO;
            } else {
              this.canvasWidth = this.canvasContext.width;
              this.canvasHeight = this.canvasWidth / IMG_RATIO;
            }
            this.drawCanvasFrame();
            this.startCoverSync();
          });
      }

      Stack({ alignContent: Alignment.Center }) {
        Image($rawfile('music/album_btn.png'))
          .height('25%')
          .objectFit(ImageFit.Contain)
          .offset({
            y: '-10%',
            x: '28%'
          });
      }
      .position({ left: this.formRect?.left, top: this.formRect?.top })
      .height(this.formRect?.height)
      .width(this.formRect?.height)
      .hitTestBehavior(HitTestMode.Transparent);
    }
    .onClick(() => {
      formProvider.cancelOverflow(this.formId).catch(() => {
        Logger.error(TAG, `cancelOverflow error`);
      });
    })
    .width('100%')
    .height('100%');
  }
}

const albumOffsetRatio: number = 0.22;

export function calcAlbumShift(cardWidth: number, cardHeight: number,
  containerWidthRatio: number, containerHeightRatio: number): number {
  const keyframeAspectRatio = 4000 / 2456;
  const containerAspectRatio = (containerWidthRatio * cardWidth) / (containerHeightRatio * cardHeight);
  let displayedKeyframeWidth: number;
  if (keyframeAspectRatio >= containerAspectRatio) {
    displayedKeyframeWidth = keyframeAspectRatio * cardHeight * containerHeightRatio;
  } else {
    displayedKeyframeWidth = containerWidthRatio * cardWidth;
  }

  const keyframeLeftShift = (cardWidth - cardHeight) / 2 - albumOffsetRatio * displayedKeyframeWidth;
  return keyframeLeftShift;
}