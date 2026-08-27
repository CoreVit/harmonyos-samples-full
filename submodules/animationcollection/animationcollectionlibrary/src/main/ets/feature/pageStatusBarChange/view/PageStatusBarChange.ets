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
import CommonConstants from '../../../common/CommonConstants';


@Component
export struct PageStatusBarChange {
  @State scrollOffset: number = 0;
  @State headOpacity: number = 0;
  @State isTop: Boolean = true;
  @State titleBackgroundColor: Resource = $r('app.color.start_window_background');
  private opacityComputeRadix: number = 35;
  private columnSpace: number = 15;
  private scroller: Scroller = new Scroller();
  @StorageProp(CommonConstants.KEY_PREFIX_BREAKPOINT) currentBreakpoint: string = '';
  private pageInfos: NavPathStack = new NavPathStack();

  @Builder
  contentsBuilder(name: Resource, img: Resource, top?: boolean) {
    Column() {
      Text(name)
        .fontColor($r('sys.color.font_primary'))
        .fontSize(16)
        .margin({
          top: top ? $r('app.float.top_interval_sixty') : 0,
          bottom: this.currentBreakpoint === 'sm' ? $r('app.float.bottom_interval_minus_five') : 5
        })
        .width(CommonConstants.FULL_PERCENT)
        .textAlign(TextAlign.Start)
      Image(img)
        .borderRadius($r('app.float.borderRadius_twelve'))
        .objectFit(ImageFit.Cover)
        .aspectRatio(1.3)
        .margin({
          top: $r('app.float.top_interval_ten'),
          bottom: $r('app.float.top_interval_ten')
        })
    }

  }

  build() {
    NavDestination() {
      Row() {
        Button({ type: ButtonType.Circle }) {
          SymbolGlyph($r('sys.symbol.chevron_backward'))
            .fontColor([$r('sys.color.icon_primary')])
            .fontSize($r('sys.float.Title_M'))
        }
        .height(40)
        .aspectRatio(1)
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .onClick(() => this.pageInfos.pop())

        Text('')
          .margin({ left: $r('sys.float.padding_level4') })
          .font({ size: 20, weight: 700 })
          .fontColor($r('sys.color.font_primary'))
      }
      .padding({
        top: 40,
        left: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                                 $r('sys.float.padding_level12') :
                                                                                 $r('sys.float.padding_level16'),
        right: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                                  $r('sys.float.padding_level12') :
                                                                                  $r('sys.float.padding_level16')
      })
      .width('100%')
      .height(96)
      .zIndex(2)

      Stack() {
        Column({ space: this.columnSpace }) {
          List({ space: 12, scroller: this.scroller }) {
            ListItem() {
              this.contentsBuilder($r('app.string.text_shopping'), $r('app.media.shopping'), true)
            }

            ListItem() {
              if (this.currentBreakpoint === 'sm') {
                this.contentsBuilder($r('app.string.text_happy'), $r('app.media.happly'))

              } else {
                this.contentsBuilder($r('app.string.text_happy'), $r('app.media.happly'), true)
              }

            }

            ListItem() {
              if (this.currentBreakpoint === 'sm') {
                this.contentsBuilder($r('app.string.text_relaxation'), $r('app.media.relaxation'))

              } else {
                this.contentsBuilder($r('app.string.text_relaxation'), $r('app.media.relaxation'), true)
              }

            }

            ListItem() {
              if (this.currentBreakpoint === 'sm') {
                this.contentsBuilder($r('app.string.text_relaxation'), $r('app.media.relaxation'))

              } else {
                this.contentsBuilder($r('app.string.text_relaxation'), $r('app.media.relaxation'), true)
              }
            }

            ListItem() {
              this.contentsBuilder($r('app.string.text_relaxation'), $r('app.media.relaxation'))
            }

            ListItem() {
              this.contentsBuilder($r('app.string.text_relaxation'), $r('app.media.relaxation'))
            }

            ListItem() {
              this.contentsBuilder($r('app.string.text_relaxation'), $r('app.media.relaxation'))
            }

            ListItem() {
              this.contentsBuilder($r('app.string.text_relaxation'), $r('app.media.relaxation'))
            }

            ListItem() {
              this.contentsBuilder($r('app.string.text_relaxation'), $r('app.media.relaxation'))
            }

            ListItem() {
              this.contentsBuilder($r('app.string.text_relaxation'), $r('app.media.relaxation'))
            }

            ListItem() {
              this.contentsBuilder($r('app.string.text_relaxation'), $r('app.media.relaxation'))
            }

            ListItem() {
              this.contentsBuilder($r('app.string.text_relaxation'), $r('app.media.relaxation'))
            }

            ListItem() {
              this.contentsBuilder($r('app.string.text_relaxation'), $r('app.media.relaxation'))
            }

            ListItem() {
              this.contentsBuilder($r('app.string.text_relaxation'), $r('app.media.relaxation'))
            }

            ListItem() {
              this.contentsBuilder($r('app.string.text_relaxation'), $r('app.media.relaxation'))
            }

            ListItem() {
              this.contentsBuilder($r('app.string.text_relaxation'), $r('app.media.relaxation'))
            }

            ListItem() {
              this.contentsBuilder($r('app.string.text_relaxation'), $r('app.media.relaxation'))
            }

            ListItem() {
              this.contentsBuilder($r('app.string.text_relaxation'), $r('app.media.relaxation'))
            }

            ListItem() {
              this.contentsBuilder($r('app.string.text_relaxation'), $r('app.media.relaxation'))
            }

          }
          .scrollBar(BarState.Off)
          .lanes(this.currentBreakpoint === 'sm' ? 1 : this.currentBreakpoint === 'md' ? 2 : 4, 12)
          .onDidScroll(() => {
            this.scrollOffset = this.scroller.currentOffset().yOffset;
            if (this.scrollOffset <= this.opacityComputeRadix) {
              this.isTop = true;
            } else {
              this.isTop = false;
            }
          })
        }
        .padding({
          left: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                                   $r('sys.float.padding_level12') :
                                                                                   $r('sys.float.padding_level16'),
          right: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                                    $r('sys.float.padding_level12') :
                                                                                    $r('sys.float.padding_level16'),
          bottom: 100
        })
        .width(CommonConstants.FULL_PERCENT)

        Header({
          titleBackgroundColor: $r('app.color.transparent_color'),
          isTop: this.isTop
        });
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
      .backgroundColor($r('sys.color.background_primary'))
      .alignContent(Alignment.Top)
    }
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.pageInfos = context.pathStack;
    })

  }
}

@Component
struct Header {
  @Prop titleBackgroundColor: Resource;
  @Prop isTop: Boolean;
  @StorageProp('currentBreakpoint') currentBreakpoint: string = '';
  private opacityTopValue: number = 0;
  private opacityUnTopValue: number = 1;

  build() {
    Stack() {
      Row() {
        SymbolGlyph($r('sys.symbol.list_bullet'))
          .fontColor([$r('sys.color.font_primary')])
          .fontSize($r('sys.float.Title_L'))
      }
      .width('100%')
      .margin({ left: 48, right: 16 })
      .justifyContent(FlexAlign.Start)
      .zIndex(2)

      Row() {
        Text($r('app.string.text_mine'))
          .fontColor($r('sys.color.font_primary'))
          .fontSize($r('app.float.font_size_twenty_two'))
          .opacity(this.isTop ? this.opacityTopValue : this.opacityUnTopValue)
          .zIndex(1)
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .height($r('app.float.width_and_height_sixty'))
    .width(CommonConstants.FULL_PERCENT)
    .backgroundColor($r('sys.color.background_primary'))
  }
}

@Builder
export function getPageStatusBarChange(name: string): void {
  if (name === 'PageStatusBarChange') {
    PageStatusBarChange()

  }
}

export const wrappedBuilderStatusBarChange: WrappedBuilder<[string, number]> = wrapBuilder(getPageStatusBarChange);