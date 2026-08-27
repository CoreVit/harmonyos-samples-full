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

import { formBindingData, formInfo, formProvider } from '@kit.FormKit';
import { LIVE_CARD_DURATION } from '../../model/common/FormCardConstant';
import { Logger } from '../../utils/Logger';

const TAG = 'SleepLiveCard';

class FrameItem {
  public src: Resource;
  public weight: number;

  constructor(src: Resource, weight: number = 1) {
    this.src = src;
    this.weight = weight;
  }
}

@Entry({ useSharedStorage: true })
@Component
struct SleepLiveCard {
  @LocalStorageProp('formId') formId: string = '';
  @LocalStorageProp('formRect') rect?: formInfo.Rect = undefined;
  @LocalStorageProp('borderRadius') radius: number = 0;
  @State isSleep: boolean = true;
  private imageSyncTimer: number = -1;

  private hanhanFrames: FrameItem[] = [
    new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame01-17.png'), 17),
    new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame18.png')),
    new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame19.png')),
    new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame20.png')),
    new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame21.png')),
    new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame22.png')),
    new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame23.png')),
    new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame24.png')),
    new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame25.png')),
    new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame26.png')),
    new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame27.png')),
    new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame28-38.png'), 11),
    new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame39.png')),
    new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame40.png')),
    new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame41.png')),
    new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame42.png')),
    new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame43.png')),
    new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame44.png')),
    new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame45.png')),
    new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame46.png')),
    new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame47.png'), 2.5),
    new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame48.png'), 2.5),
    new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame49.png'), 2.5),
    new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame50.png'), 2.5),
    new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame51.png'), 2.5),
    new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame52.png'), 2.5),
    new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame53.png'), 2.5),
    new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame54.png'), 2.5),
    new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame55.png'), 2.5),
    new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame56.png'), 2.5),
    new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame57.png'), 2.5),
    new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame58.png'), 2.5),
    new FrameItem($rawfile('sleep/animate/sleep_hanhan_frame59.png')),
    new FrameItem($r('app.media.sleep_hanhan_frame60')),
    new FrameItem($r('app.media.sleep_hanhan_frame61')),
    new FrameItem($r('app.media.sleep_hanhan_frame62')),
    new FrameItem($r('app.media.sleep_hanhan_frame63')),
    new FrameItem($r('app.media.sleep_hanhan_frame64')),
    new FrameItem($r('app.media.sleep_hanhan_frame65')),
    new FrameItem($r('app.media.sleep_hanhan_frame68_70'), 3),
    new FrameItem($r('app.media.sleep_hanhan_frame71_73'), 3),
    new FrameItem($r('app.media.sleep_hanhan_frame74_76'), 3),
    new FrameItem($r('app.media.sleep_hanhan_frame77_79'), 3),
    new FrameItem($r('app.media.sleep_hanhan_frame80_85'), 6),
    new FrameItem($r('app.media.sleep_hanhan_frame86_88'), 3),
    new FrameItem($r('app.media.sleep_hanhan_frame89_95'), 7),
  ];

  private cloverFrames: FrameItem[] = [
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame01.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame02.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame03.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame04.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame05.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame06.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame07.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame08.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame09.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame10.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame11.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame12.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame13.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame14.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame15.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame16.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame17.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame18.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame19.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame20.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame21.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame22.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame23-27.png'), 5),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame28-30.png'), 3),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame31-35.png'), 5),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame36.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame37.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame38.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame39.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame40.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame41.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame42.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame43.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame44.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame45.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame46.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame47.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame48.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame49.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame50.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame51.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame52.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame53.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame54.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame55.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame56.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame57.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame58.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame59.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame60.png')),
    new FrameItem($rawfile('sleep/animate/sleep_balloon_frame61-62.png'), 2),
  ];

  @State currentHanhanFrameIndex: number = 0;
  @State currentCloverFrameIndex: number = 0;
  private hanhanCumulativeTime: number[] = [];
  private cloverCumulativeTime: number[] = [];
  private animStartTime: number = 0;
  private readonly hanhanSleepFrameIndex: number = 19;

  initCumulativeTimes(): void {
    this.hanhanCumulativeTime = this.buildCumulativeTime(this.hanhanFrames);
    this.cloverCumulativeTime = this.buildCumulativeTime(this.cloverFrames);
  }

  startImageSync(): void {
    this.stopCoverSync();
    this.animStartTime = Date.now();
    this.imageSyncTimer = setInterval(() => {
      const elapsed = Date.now() - this.animStartTime;
      if (elapsed >= LIVE_CARD_DURATION) {
        this.currentHanhanFrameIndex = this.hanhanFrames.length - 1;
        this.currentCloverFrameIndex = this.cloverFrames.length - 1;
        clearInterval(this.imageSyncTimer);
        return;
      }
      const newHanhanFrame = this.getFrameByElapsed(elapsed, this.hanhanCumulativeTime, this.hanhanFrames.length);
      const newCloverFrame = this.getFrameByElapsed(elapsed, this.cloverCumulativeTime, this.cloverFrames.length);
      if (newHanhanFrame > this.currentHanhanFrameIndex) {
        this.currentHanhanFrameIndex = newHanhanFrame;
        if (this.currentHanhanFrameIndex >= this.hanhanSleepFrameIndex) {
          this.isSleep = false;
        }
      }
      if (newCloverFrame > this.currentCloverFrameIndex) {
        this.currentCloverFrameIndex = newCloverFrame;
      }
    }, 16);
  }

  aboutToAppear(): void {
    this.initCumulativeTimes();
    let timeoutId = setTimeout(() => {
      let formMsg: formBindingData.FormBindingData = formBindingData.createFormBindingData({
        isSleep: false
      });
      formProvider.updateForm(this.formId, formMsg).catch((err: BusinessError) => {
        Logger.error(TAG, `updateForm error, code: ${err.code} message: ${err.message}`);
      });
      clearTimeout(timeoutId);
    }, 1000);
  }

  aboutToDisappear(): void {
    this.stopCoverSync();
  }

  private buildCumulativeTime(frames: FrameItem[]): number[] {
    const totalWeight = frames.reduce((sum: number, f: FrameItem) => sum + f.weight, 0);
    let cumulative = [0];
    for (let i = 0; i < frames.length; i++) {
      cumulative.push(cumulative[i] + frames[i].weight / totalWeight * LIVE_CARD_DURATION);
    }
    return cumulative;
  }

  private getFrameByElapsed(elapsed: number, cumulativeTime: number[], totalFrames: number): number {
    for (let i = 1; i < cumulativeTime.length; i++) {
      if (elapsed < cumulativeTime[i]) {
        return i - 1;
      }
    }
    return totalFrames - 1;
  }

  stopCoverSync(): void {
    if (this.imageSyncTimer !== -1) {
      clearInterval(this.imageSyncTimer);
      this.imageSyncTimer = -1;
    }
  }

  build() {
    Stack() {
      RelativeContainer() {
        Column() {
          Stack()
            .aspectRatio(1)
            .layoutWeight(1);
          Row() {
            Text(this.isSleep ? $r('app.string.sleep_status_sleeping') : $r('app.string.sleep_status_wakeup'))
              .fontColor(this.isSleep ? '#8D68FC' : '#27C2D7')
              .maxLines(1)
              .layoutWeight(1)
              .minFontSize('16px')
              .maxFontSize('36px');
            SymbolGlyph($r('sys.symbol.checkmark_circle_fill'))
              .fontColor([this.isSleep ? '#8D68FC' : '#27C2D7'])
              .fontSize('36px');
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .backgroundColor('#A6FFFDFD')
          .width('90%')
          .borderRadius('50%')
          .padding({
            top: 5,
            right: 7,
            left: 7,
            bottom: 5
          });
        }
        .width('45%')
        .alignItems(HorizontalAlign.Center)
        .padding(12)
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          right: { anchor: '__container__', align: HorizontalAlign.End }
        });
        // Clover
        Image(this.cloverFrames[this.currentCloverFrameIndex].src)
          .objectFit(ImageFit.Cover)
          .width('100%')
          .height('100%');
      }
      .backgroundImage($rawfile('sleep/background.png'))
      .backgroundImageSize(ImageSize.Cover)
      .borderRadius(this.radius)
      .clip(true)
      .width(this.rect?.width)
      .height(this.rect?.height);
      RelativeContainer() {
        Image(this.hanhanFrames[this.currentHanhanFrameIndex].src)
          .objectFit(ImageFit.Contain)
          .width('130%')
          .height('150%')
          .offset({
            x: '-20%',
            y: '-25%'
          })
          .onAppear(() => {
            this.startImageSync();
          });
      }
      .borderRadius(this.radius)
      .width(this.rect?.width)
      .height(this.rect?.height);
    }
    .onClick(() => {
      formProvider.cancelOverflow(this.formId).catch(() => {
        Logger.error(TAG, `cancelOverflow error`);
      });
    })
    .alignContent(Alignment.Center)
    .width('100%')
    .height('100%');
  }
}