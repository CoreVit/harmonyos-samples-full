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
import { uiObserver } from '@kit.ArkUI';
import { PipWindowUtil, WidthBreakpointType } from 'multishoppingbase';
import { ProductSwiperState } from '../viewmodel/ProductSwiperState';

@ComponentV2
export struct ProductSwiper {
  private context: Context = this.getUIContext().getHostContext()!;
  @Env(SystemProperties.BREAK_POINT) private breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;
  @Local private state: ProductSwiperState = new ProductSwiperState(this.context);
  /** Passed from ProductDetail; avoids @Consumer in deep tree (split-screen / nested nav misses Provider). */
  @Param public mainPageMap: NavPathStack = new NavPathStack();
  private pipWindowUtil: PipWindowUtil | undefined = PipWindowUtil.getPipWindowUtil(this.getUIContext());

  /**
   * Always await PiP teardown when util exists: getIsShowingPip() can lag (STARTED not yet fired) or race
   * with user closing the panel, so branching on it caused pushPath to run before PiP released the nav stack.
   */
  private navigateToLive(): void {
    void this.openLiveAfterPipReleased();
  }

  private async openLiveAfterPipReleased(): Promise<void> {
    const stack: NavPathStack = this.mainPageMap;
    try {
      if (this.pipWindowUtil !== undefined) {
        await this.pipWindowUtil.stopPip();
      }
    } catch (_e) {
    }
    // Defer push to next microtask so Navigation applies after PiP window teardown on the UI thread.
    Promise.resolve().then((): void => {
      stack.pushPath({ name: 'LiveBroadCastPage' });
    });
  }

  @Builder
  private pictureIndicator(text: string) {
    Text(text)
      .fontSize(12)
      .fontWeight(FontWeight.Normal)
      .margin({ right: 8 })
  }

  build() {
    Column() {
      Stack({
        alignContent: new WidthBreakpointType(Alignment.End, Alignment.End, Alignment.TopEnd, Alignment.TopEnd)
          .getValue(this.breakpoint.widthBreakpoint)
      }) {
        Swiper() {
          ForEach(this.state.detailResources, (item: Resource, index: number) => {
            Image(this.state.detailResources[index])
              .width('100%')
          }, (item: Resource, index: number) => `detail-${index}`)
        }
        .align(Alignment.Center)
        .indicator(false)
        .displayCount(1)
        .nextMargin(new WidthBreakpointType(0, 160, 0, 0).getValue(this.breakpoint.widthBreakpoint))
        .prevMargin(new WidthBreakpointType(0, 160, 0, 0).getValue(this.breakpoint.widthBreakpoint))
        .height('100%')
        .width('100%')
        .onChange((index: number) => {
          this.state.currentSwiperIndex = index;
        })

        Column() {
          Image($r('app.media.ic_public_living'))
            .width(24)
            .height(24)
            .borderRadius(8)
          Text(this.state.livingText)
            .fontSize(10)
            .lineHeight(14)
            .fontWeight(FontWeight.Normal)
        }
        .zIndex(10)
        .margin({
          right: new WidthBreakpointType(16, 24, 32, 32).getValue(this.breakpoint.widthBreakpoint),
          top: new WidthBreakpointType(0, 0, 64, 64).getValue(this.breakpoint.widthBreakpoint),
        })
        .borderWidth(1)
        .borderRadius(8)
        .borderColor($r('app.color.living_badge_border'))
        .backgroundColor($r('app.color.living_badge_background'))
        .justifyContent(FlexAlign.SpaceEvenly)
        .height(72)
        .width(56)
        .responseRegion({
          x: -8,
          y: -8,
          width: 72,
          height: 88
        })
        .onClick(() => {
          this.navigateToLive();
        })
      }
      .width('100%')
      .layoutWeight(new WidthBreakpointType(-1, -1, 1, 1).getValue(this.breakpoint.widthBreakpoint))
      .aspectRatio(new WidthBreakpointType(1.2, 2.2, -1, -1).getValue(this.breakpoint.widthBreakpoint))

      Row() {
        Column() {
          Text(`${this.state.currentSwiperIndex + 1}/${this.state.detailResources.length}`)
            .fontSize(12)
            .fontWeight(FontWeight.Normal)
        }
        .width(42)
        .height(24)
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .borderRadius(12)
        .justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .justifyContent(FlexAlign.End)
      .padding({
        right: new WidthBreakpointType(16, 24, 32, 32).getValue(this.breakpoint.widthBreakpoint)
      })

      Row() {
        this.pictureIndicator(this.state.indicatorTexts[0])
        SymbolGlyph($r('sys.symbol.chevron_right'))
          .fontSize(12)
          .margin({ right: 8 })
          .fontColor([$r('app.color.text_muted')])
        this.pictureIndicator(this.state.indicatorTexts[1])
        SymbolGlyph($r('sys.symbol.chevron_right'))
          .fontSize(12)
          .fontColor([$r('app.color.text_muted')])
      }
      .padding({ left: 16, right: 16 })
      .backgroundColor($r('sys.color.comp_background_tertiary'))
      .width(120)
      .height(24)
      .borderRadius(12)
      .margin({ top: 8, bottom: 16 })

      Row() {
        List({
          space: new WidthBreakpointType(8, 12, 16, 16).getValue(this.breakpoint.widthBreakpoint)
        }) {
          ForEach(this.state.smallResources, (item: Resource, index: number) => {
            ListItem() {
              Image(this.state.smallResources[index])
                .width(new WidthBreakpointType(60, 60, 72, 72).getValue(this.breakpoint.widthBreakpoint))
                .height(new WidthBreakpointType(60, 60, 72, 72).getValue(this.breakpoint.widthBreakpoint))
                .borderRadius(8)
                .borderWidth(index === this.state.currentSwiperIndex ? 1 : 0)
            }
          }, (item: Resource, index: number) => `small-${index}`)
        }
        .scrollBar(BarState.Off)
        .listDirection(Axis.Horizontal)
      }
      .height(new WidthBreakpointType(76, 76, 88, 88).getValue(this.breakpoint.widthBreakpoint))
      .width('100%')
      .padding({
        left: new WidthBreakpointType(16, 24, 32, 32).getValue(this.breakpoint.widthBreakpoint),
        right: new WidthBreakpointType(16, 24, 32, 32).getValue(this.breakpoint.widthBreakpoint)
      })
    }
    .background($r('app.color.surface_primary'))
    .alignItems(HorizontalAlign.Center)
    .padding({
      bottom: new WidthBreakpointType(0, 0, 32, 32).getValue(this.breakpoint.widthBreakpoint),
    })
  }
}
