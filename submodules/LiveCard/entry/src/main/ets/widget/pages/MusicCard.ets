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

import ActionUtils from '../../utils/ActionUtils';
import { CollectAction, LIVE_CARD_DURATION, LiveCardScale, PlayActionType } from '../../model/common/FormCardConstant';
import { collectAlignRules } from '../../model/music/MusicConstants';
import { ColorConstants } from '../../common/ColorConstants';
import { BorderRadius, CardPadding, FONT_STYLES, IconSize, SPACING } from '../../common/CommonConstants';

let storageUpdateCall = new LocalStorage();

@Entry(storageUpdateCall)
@Component
struct MusicCard {
  @LocalStorageProp('formId') formId: string = '';
  @LocalStorageProp('isNeedRequestUpdate') @Watch('requestData') isNeedRequestUpdate: boolean = false;
  @LocalStorageProp('isPlay') isPlay: boolean = false;
  @LocalStorageProp('title') title: string = 'SongName';
  @LocalStorageProp('isCollected') isCollected: boolean = false;
  @LocalStorageProp('musicCover') @Watch('coverUpdate') musicCover: Resource = $r('app.media.ic_dream');
  @LocalStorageProp('singer') singer: string = 'Singer';
  @LocalStorageProp('songId') songId: string = '';
  @LocalStorageProp('isRequestingOverflow') @Watch('requestOverFlowStateChange') isRequestingOverflow: boolean = false;

  @State cover: Resource = $r('app.media.ic_dream');

  aboutToAppear(): void {
    this.updateCover();
  }

  coverUpdate(): void {
    if (!this.isRequestingOverflow) {
      this.updateCover();
    }
  }

  requestOverFlowStateChange() {
    if (!this.isRequestingOverflow) {
      this.updateCover();
    }
  }

  requestingStateChange() {
    this.updateCover();
  }

  updateCover() {
    this.cover = this.musicCover;
  }

  requestData(): void {
    ActionUtils.updateControlCardAction(this, this.formId);
  }

  build() {
    RelativeContainer() {
      Image($rawfile('music/background.png'))
        .objectFit(ImageFit.Cover)
        .width('100%')
        .height('100%');

      Image($rawfile('music/music_hanhan.png'))
        .objectFit(ImageFit.Contain)
        .offset({
          x: '-5%',
          y: '-25%'
        })
        .height('150%')
        .width('110%');
      Row() {
        Stack({ alignContent: Alignment.Center }) {
          Image($rawfile('music/album_background.png'))
            .height('100%')
            .width('100%');

          Image($rawfile('music/album.png'))
            .height('60%')
            .width('60%')
            .offset({
              y: '1.5%',
              x: '-0.5'
            });
          Image(this.cover)
            .objectFit(ImageFit.Cover)
            .height('35%')
            .width('35%')
            .offset({
              y: '1.5%',
              x: '-0.5'
            })
            .borderRadius('100%');
          Image($rawfile('music/album_btn.png'))
            .height('25%')
            .objectFit(ImageFit.Contain)
            .offset({
              y: '-10%',
              x: '28%'
            });
        }
        .height('100%')
        .borderRadius(BorderRadius.SMALL + 6)
        .aspectRatio(1)
        .id('musicCover');

        Column() {
          Row() {
            Text($r(this.title))
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
            SymbolGlyph(this.isCollected ? $r('sys.symbol.heart_fill') : $r('sys.symbol.heart'))
              .fontSize(IconSize.MEDIUM)
              .symbolEffect(new ReplaceSymbolEffect(EffectScope.WHOLE), true)
              .fontColor([ColorConstants.ICON_LIGHT])
              .alignRules(collectAlignRules)
              .onClick(() => {
                if (this.isCollected) {
                  ActionUtils.collectAction(this, CollectAction.UNCOLLECTED, this.formId, this.songId);
                } else {
                  ActionUtils.collectAction(this, CollectAction.COLLECTED, this.formId, this.songId);
                }
              });

            SymbolGlyph($r('sys.symbol.backward_fill'))
              .fontSize(IconSize.MEDIUM)
              .margin({ left: SPACING.buttonPadding })
              .fontColor([ColorConstants.ICON_LIGHT])
              .onClick(() => {
                this.isRequestingOverflow = true;
                ActionUtils.updateRequestOverflowState(this, true);
                ActionUtils.playByAction(this, PlayActionType.PREVIOUS, this.formId);
                ActionUtils.requestOverFlowWithAction(this, LiveCardScale.MUSIC_WIDTH,
                  LiveCardScale.MUSIC_HEIGHT, LIVE_CARD_DURATION, 'PREVIOUS', this.songId);
              });
            SymbolGlyph(this.isPlay ? $r('sys.symbol.pause_fill') : $r('sys.symbol.play_fill'))
              .fontSize(IconSize.MEDIUM)
              .margin({ left: SPACING.medium, right: SPACING.medium })
              .symbolEffect(new ReplaceSymbolEffect(EffectScope.WHOLE), true)
              .fontColor([ColorConstants.ICON_LIGHT])
              .padding(SPACING.small)
              .borderRadius(BorderRadius.BUTTON)
              .backgroundColor(ColorConstants.BUTTON_BG_LIGHT)
              .onClick(() => {
                if (this.isPlay) {
                  ActionUtils.playByAction(this, PlayActionType.PAUSE, this.formId);
                } else {
                  ActionUtils.playByAction(this, PlayActionType.PLAY, this.formId);
                  ActionUtils.requestOverFlowWithAction(this, LiveCardScale.MUSIC_WIDTH,
                    LiveCardScale.MUSIC_HEIGHT, LIVE_CARD_DURATION, 'PLAY', this.songId);
                }
              });
            SymbolGlyph($r('sys.symbol.fast_forward'))
              .fontSize(IconSize.MEDIUM)
              .margin({ right: SPACING.buttonPadding })
              .fontColor([ColorConstants.ICON_LIGHT])
              .onClick(() => {
                this.isRequestingOverflow = true;
                ActionUtils.updateRequestOverflowState(this, true);
                ActionUtils.playByAction(this, PlayActionType.NEXT, this.formId);
                ActionUtils.requestOverFlowWithAction(this, LiveCardScale.MUSIC_WIDTH,
                  LiveCardScale.MUSIC_HEIGHT, LIVE_CARD_DURATION, 'NEXT', this.songId);
              });
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
    .height('100%')
    .width('100%')
    .onClick(() => {
      ActionUtils.jumpAppPage(this, 'MusicPage');
    });
  }
}