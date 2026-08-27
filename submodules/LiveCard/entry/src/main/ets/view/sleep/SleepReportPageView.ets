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

import {
  SLEEP_DETAIL_INFO_LIST,
  SleepDetail,
  STAGE_COLORS,
  STAGE_LEGENDS,
  STAGE_LEGENDS_PERCENT,
  TIME_TABS,
  TimeTab
} from '../../model/sleep/SleepConstants';
import { HeaderSection } from '../common/HeaderSection';
import { WindowInfo } from '../../utils/WindowUtil';
import { DateFormatter } from '../../utils/DateFormatter';
import { ColorConstants, SleepStageColors } from '../../common/ColorConstants';
import {
  BorderRadius,
  CardPadding,
  COMMON_DIMENSIONS,
  CommonPadding,
  Constants,
  DataView,
  FONT_STYLES,
  FontStyleItem,
  IconSize,
  SPACING
} from '../../common/CommonConstants';
import FormUtils from '../../utils/FormUtils';
import { Logger } from '../../utils/Logger';
import RouterUtil from '../../utils/RouterUtil';

const TAG = 'SleepReportPage';

@Builder
export function SleepReportPageViewBuilder() {
  SleepReportPageViewWithBg();
}

@Component
struct SleepReportPageViewWithBg {
  @StorageProp(Constants.KEY_WINDOW_INFO) windowInfo?: WindowInfo = undefined;
  @State isLargeWindow: boolean = this.windowInfo !== undefined && this.windowInfo.widthBp > WidthBreakpoint.WIDTH_MD;

  aboutToAppear(): void {
    const context = this.getUIContext().getHostContext();
    if (context) {
      FormUtils.updateSleepCardState(context, true);
    }
  }

  build() {
    NavDestination() {
      if (this.windowInfo !== undefined && this.windowInfo.widthBp > WidthBreakpoint.WIDTH_MD) {
        Stack({ alignContent: Alignment.Top }) {
          Image($r('app.media.sleep_report_bg'))
            .width('100%')
            .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
            .objectFit(ImageFit.Contain);

          Column()
            .width('100%')
            .height('100%')
            .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
            .backgroundColor($r('sys.color.mask_fourth'));

          Stack({ alignContent: Alignment.Bottom }) {
            SleepReportPageView();
          }
          .clip(true)
          .borderRadius(BorderRadius.CONTAINER)
          .width('37.5%')
          .height('100%');
        }
        .width('100%')
        .height('100%');
      } else {
        SleepReportPageView();
      }
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .backgroundColor($r('sys.color.comp_background_gray'))
    .hideTitleBar(true)
    .onBackPressed(() => {
      RouterUtil.getInstance().closeApp();
      return false;
    });
  }
}

@Component
struct SleepReportPageView {
  @StorageProp(Constants.KEY_WINDOW_INFO) windowInfo?: WindowInfo = undefined;
  @State selectedTabIndex: number = 0;
  @State sleepScore: number = 80;
  @State sleepDetailInfo: SleepDetail[] = SLEEP_DETAIL_INFO_LIST;

  aboutToAppear(): void {
    Logger.info(TAG, `SleepReportPageView aboutToAppear success`);
  }

  private getPadding(): Padding {
    let width = CommonPadding.SMALL;
    if (this.windowInfo) {
      if (this.windowInfo.widthBp >= WidthBreakpoint.WIDTH_LG) {
        width = CommonPadding.SMALL;
      } else if (this.windowInfo.widthBp >= WidthBreakpoint.WIDTH_MD) {
        width = CommonPadding.MEDIUM;
      }
    }

    return { left: width, right: width };
  }

  build() {
    NavDestination() {
      Column() {
        HeaderSection($r('app.string.sleep_title'));
        this.TimeTabSection();
        Scroll() {
          Column() {
            this.SleepDataCard();
            this.AnalysisCard();
          };
        }
        .margin({ top: CardPadding.SECTION })
        .layoutWeight(1)
        .scrollBar(BarState.Off);
        this.BottomAction();
      }
      .width('100%')
      .height('100%');
    }
    .padding(this.getPadding())
    .backgroundColor($r('sys.color.comp_background_gray'))
    .hideTitleBar(true);
  }

  @Builder
  TimeTabSection() {
    Row() {
      ForEach(TIME_TABS, (tab: TimeTab, index: number) => {
        Text(tab.label)
          .fontWeight(FontWeight.Medium)
          .maxFontSize(14)
          .minFontSize(8)
          .layoutWeight(1)
          .textStyle(FONT_STYLES.bodyMedium)
          .textAlign(TextAlign.Center)
          .fontColor(this.selectedTabIndex === index ?
            $r('sys.color.font_primary') : $r('sys.color.font_secondary'))
          .padding({ top: SPACING.iconPadding, bottom: SPACING.iconPadding,
            left: CardPadding.SECTION, right: CardPadding.SECTION })
          .backgroundColor(this.selectedTabIndex === index ?
            $r('sys.color.comp_background_primary_contrary') : Color.Transparent)
          .borderRadius(BorderRadius.BUTTON)
          .border(this.selectedTabIndex === index ?
            { width: 1, color: ColorConstants.BORDER_DEFAULT } : undefined);
      }, (index: number) => index.toString());
    }
    .justifyContent(FlexAlign.Start)
    .backgroundColor($r('sys.color.comp_background_tertiary'))
    .borderRadius(BorderRadius.BUTTON);
  }

  @Builder
  SleepDataCard() {
    Column() {
      this.DateSelector();
      this.SleepDurationStats();
      this.SleepStageChart();
      this.SleepHeartRate();
      this.DataLink();
    }
    .width('100%')
    .padding(CardPadding.CARD)
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .borderRadius(BorderRadius.CARD)
    .shadow({ radius: BorderRadius.MEDIUM, color: ColorConstants.SHADOW_CARD, offsetX: 0, offsetY: 2 })
    .alignItems(HorizontalAlign.Start);
  }

  @Builder
  DateSelector() {
    Row() {
      Text(DateFormatter.formatMonthDayWeek(new Date(2026, 7, 12)))
        .textStyle(FONT_STYLES.bodyMedium)
        .fontWeight(FontWeight.Normal)
        .fontColor($r('sys.color.font_secondary'));
      SymbolGlyph($r('sys.symbol.chevron_down'))
        .fontSize(FONT_STYLES.bodyMedium.fontSize)
        .fontColor([$r('sys.color.font_secondary')])
        .margin({ left: SPACING.small });
    };
  }

  @Builder
  SleepDurationStats() {
    Column() {
      Row() {
        Column() {
          Text() {
            Span('7')
              .fontSize(FONT_STYLES.valueLarge.fontSize + 6)
              .lineHeight(DataView.DIVIDER_HEIGHT)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('sys.color.font_primary'));
            Span($r('app.string.sleep_unit_hour'))
              .fontSize(FONT_STYLES.bodySmall.fontSize)
              .lineHeight(FONT_STYLES.bodySmall.lineHeight)
              .fontWeight(FontWeight.Normal)
              .fontColor($r('sys.color.font_secondary'));
            Span('15')
              .fontSize(FONT_STYLES.valueLarge.fontSize + 6)
              .lineHeight(DataView.DIVIDER_HEIGHT)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('sys.color.font_primary'));
            Span($r('app.string.sleep_unit_minute'))
              .fontSize(FONT_STYLES.bodySmall.fontSize)
              .lineHeight(FONT_STYLES.bodySmall.lineHeight)
              .fontWeight(FontWeight.Normal)
              .fontColor($r('sys.color.font_secondary'));
          };

          Text($r('app.string.sleep_duration_title'))
            .textStyle(FONT_STYLES.bodySmall)
            .fontWeight(FontWeight.Normal)
            .fontColor($r('sys.color.font_secondary'))
            .margin({ top: SPACING.small });
        }
        .alignItems(HorizontalAlign.Start);

        if (this.windowInfo && this.windowInfo.widthBp > WidthBreakpoint.WIDTH_SM) {
          Line()
            .width(COMMON_DIMENSIONS.dividerWidth)
            .height(DataView.DIVIDER_HEIGHT)
            .margin({ left: DataView.STATS_LEFT_MARGIN })
            .backgroundColor($r('sys.color.comp_divider'));
        }

        Column() {
          Text() {
            Span('31')
              .fontSize(FONT_STYLES.valueLarge.fontSize + 6)
              .lineHeight(DataView.DIVIDER_HEIGHT)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('sys.color.font_primary'));
            Span($r('app.string.sleep_unit_minute'))
              .fontSize(FONT_STYLES.bodySmall.fontSize)
              .lineHeight(FONT_STYLES.bodySmall.lineHeight)
              .fontWeight(FontWeight.Normal)
              .fontColor($r('sys.color.font_secondary'));
          };
          Text($r('app.string.sleep_nap_title'))
            .textStyle(FONT_STYLES.bodySmall)
            .fontWeight(FontWeight.Normal)
            .fontColor($r('sys.color.font_secondary'))
            .margin({ top: SPACING.small });
        }
        .alignItems(HorizontalAlign.Start)
        .margin({ left: DataView.STATS_LEFT_MARGIN });
      }
      .justifyContent(this.windowInfo && this.windowInfo.widthBp > WidthBreakpoint.WIDTH_SM ?
        FlexAlign.Center : FlexAlign.Start)
      .width('100%');

      Text() {
        Span($r('app.string.sleep_total_sleep_format'));
        Span('8');
        Span($r('app.string.sleep_unit_hour'));
        Span('3');
        Span($r('app.string.sleep_unit_minute'));
      }
      .textStyle(FONT_STYLES.bodySmall)
      .fontColor($r('sys.color.font_secondary'))
      .padding({ top: SPACING.small, bottom: SPACING.small,
        left: SPACING.medium, right: SPACING.medium })
      .borderRadius(BorderRadius.SMALL)
      .margin({ top: SPACING.medium });
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .margin({ top: CardPadding.SECTION });
  }

  @Builder
  SleepStageChart() {
    Column() {
      Image($r('app.media.sleep_detail'))
        .width('100%')
        .objectFit(ImageFit.Contain);
    }
    .width('100%')
    .margin({
      top: SPACING.medium
    });
  }

  @Builder
  SleepHeartRate() {
    Row() {
      Text($r('app.string.sleep_heart_rate_title'))
        .textStyle(FONT_STYLES.titleMedium)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.font_primary'));
      Blank();
      Text() {
        Span('64-90 ')
          .spanStyle(FONT_STYLES.bodyLarge)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_primary'));
        Span($r('app.string.sleep_heart_rate_range_format'))
          .fontColor($r('sys.color.font_secondary'))
          .fontWeight(FontWeight.Normal)
          .spanStyle(FONT_STYLES.bodySmall);
      };
    }
    .width('100%')
    .padding(SPACING.medium)
    .backgroundColor($r('sys.color.comp_background_tertiary'))
    .borderRadius(BorderRadius.MEDIUM)
    .margin({ top: CardPadding.SECTION });
  }

  @Builder
  DataLink() {
    Column() {
      Text($r('app.string.sleep_view_health_data'))
        .fontSize(FONT_STYLES.bodyMedium.fontSize)
        .lineHeight(FONT_STYLES.bodyMedium.lineHeight)
        .fontColor(ColorConstants.ACCENT_PURPLE)
        .margin({ top: SPACING.medium })
        .onClick(() => {
        });
    }
    .width('100%');
  }

  @Builder
  AnalysisCard() {
    Row() {
      Text($r('app.string.sleep_analysis_title'))
        .textStyle(FONT_STYLES.titleLarge)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('sys.color.font_primary'))
        .margin({
          top: 24,
          bottom: CardPadding.SECTION
        });
    }
    .width('100%');
    Column() {
      Row() {
        Text('70')
          .textStyle({fontSize: 30, lineHeight: 40})
          .fontWeight(FontWeight.Bold)
          .fontColor($r('sys.color.font_primary'));
        Text($r('app.string.sleep_score_over_users_format'))
          .textStyle(FONT_STYLES.bodySmall)
          .fontColor($r('sys.color.font_secondary'))
          .margin({ left: SPACING.iconPadding, bottom: 6 });
      }
      .alignItems(VerticalAlign.Bottom);

      Row() {
        ForEach([0, 1, 2, 3, 4], (index: number) => {
          SymbolGlyph($r('sys.symbol.star_fill'))
            .fontSize(FONT_STYLES.titleMedium.fontSize)
            .fontColor([index < 3 ? ColorConstants.ACCENT_STAR_YELLOW : ColorConstants.ACCENT_STAR_INACTIVE])
            .margin({ right: SPACING.small });
        }, (index: number) => index.toString());
      }
      .margin({ top: SPACING.iconPadding });

      Row() {
        Text($r('app.string.sleep_analysis_quality_avg'))
          .maxLines(2)
          .textStyle(FONT_STYLES.bodyMedium)
          .fontWeight(FontWeight.Normal)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontColor($r('sys.color.font_secondary'));
      }
      .margin({ top: SPACING.medium });

      Column() {
        Row() {
          Column() {
            ForEach(STAGE_LEGENDS_PERCENT, (item: string, index: number) => {
              Row({ space: SPACING.medium }) {
                Circle()
                  .width(SPACING.iconPadding)
                  .height(SPACING.iconPadding)
                  .fill(Object.values(STAGE_COLORS)[index]);
                Text(STAGE_LEGENDS[index])
                  .textStyle(FONT_STYLES.bodySmall)
                  .fontColor($r('sys.color.font_secondary'))
                  .margin({ left: SPACING.small });
                Text(item)
                  .textStyle(FONT_STYLES.bodySmall)
                  .fontColor($r('sys.color.font_primary'));
              }
              .width('100%')
              .justifyContent(FlexAlign.Start);
            }, (index: number) => index.toString());
          }
          .layoutWeight(1);

          Stack() {
            DataPanel({ values: [15, 50, 35], max: 100, type: DataPanelType.Circle })
              .closeEffect(true)
              .strokeWidth(DataView.DATA_PANEL_STROKE)
              .width(DataView.DATA_PANEL_SIZE)
              .height(DataView.DATA_PANEL_SIZE)
              .valueColors([SleepStageColors.DEEP, SleepStageColors.LIGHT, SleepStageColors.REM]);

            Text($r('app.string.sleep_ratio'))
              .textStyle(FONT_STYLES.bodySmall)
              .fontWeight(FontWeight.Normal)
              .maxLines(1)
              .maxFontSize(12)
              .minFontSize(8)
              .width(DataView.DATA_PANEL_SIZE - DataView.DATA_PANEL_STROKE * 4)
              .fontColor($r('sys.color.font_secondary'));
          }
          .alignContent(Alignment.Center)
          .width(DataView.DATA_PANEL_SIZE)
          .height(DataView.DATA_PANEL_SIZE);
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween);

        Column() {
          ForEach(this.sleepDetailInfo, (item: SleepDetail, index: number) => {
            if (index !== 0) {
              Line()
                .width('100%')
                .height(COMMON_DIMENSIONS.dividerWidth)
                .backgroundColor($r('sys.color.comp_divider'));
            }
            Row() {
              Column() {
                Text() {
                  Span(item.title);
                  Span(' ');
                  Span(item.value);
                }
                .textStyle({
                  fontSize: FONT_STYLES.titleMedium.fontSize,
                  lineHeight: FONT_STYLES.titleMedium.lineHeight + 2
                })
                .fontWeight(FontWeight.Medium)
                .fontColor($r('sys.color.font_primary'));
                Text(item.unit)
                  .textStyle(FONT_STYLES.bodyMedium)
                  .fontWeight(FontWeight.Normal)
                  .fontColor($r('sys.color.font_secondary'))
                  .margin({ top: 2 });
              }
              .alignItems(HorizontalAlign.Start);
              Row() {
                Text(item.state)
                  .textStyle(FONT_STYLES.bodyMedium)
                  .fontWeight(FontWeight.Normal)
                  .fontColor($r('sys.color.font_secondary'));
                SymbolGlyph($r('sys.symbol.chevron_forward'))
                  .fontSize(FONT_STYLES.bodyMedium.fontSize)
                  .fontWeight(FontWeight.Normal)
                  .fontColor([$r('sys.color.font_secondary')]);
              };
            }
            .justifyContent(FlexAlign.SpaceBetween)
            .width('100%')
            .padding({ top: 10.5, bottom: 10.5 });
          }, (index: number) => index.toString());
        }
        .margin({
          top: SPACING.medium
        });
      };
    }
    .width('100%')
    .padding(CardPadding.CARD)
    .margin({bottom: CardPadding.SECTION})
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .borderRadius(BorderRadius.CARD)
    .alignItems(HorizontalAlign.Start);
  }

  @Builder
  BottomAction() {
    Row() {
      Column() {
        Image($r('app.media.sleep_hand_write_icon'))
          .height(IconSize.STANDARD)
          .width(IconSize.STANDARD);
        Text($r('app.string.sleep_manual_input'))
          .margin({ top: 2 })
          .fontColor($r('sys.color.font_secondary'))
          .textStyle({fontSize: IconSize.SMALL, lineHeight: 13})
          .fontWeight(FontWeight.Medium);
      }
      .width('100%')
      .layoutWeight(1)
      .padding(SPACING.small);
      Column() {
        Image($r('app.media.sleep_record_sleep_icon'))
          .height(IconSize.STANDARD)
          .width(IconSize.STANDARD);
        Text($r('app.string.sleep_record'))
          .margin({ top: 2 })
          .fontColor($r('sys.color.font_secondary'))
          .textStyle({fontSize: IconSize.SMALL, lineHeight: 13})
          .fontSize(IconSize.SMALL);
      }
      .width('100%')
      .layoutWeight(1)
      .padding(SPACING.small);
    }
    .margin({
      top: 12,
      bottom: 12
    })
    .width('100%');
  }
}

@Extend(Text)
function textStyle(textStyle: FontStyleItem) {
  .fontSize(textStyle.fontSize)
  .lineHeight(textStyle.lineHeight)
}
@Extend(Span)
function spanStyle(textStyle: FontStyleItem) {
  .fontSize(textStyle.fontSize)
  .lineHeight(textStyle.lineHeight)
}