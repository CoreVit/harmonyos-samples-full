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

import Constants from '../constants/Constants';
import CommonConstants from '../../../common/CommonConstants';
import Logger from '../../../utils/Logger';

@Component
export struct VotingComponent {
  @State notice: ResourceStr = $r('app.string.voting_notice');
  @State leftOptionWidth: string = Constants.HALF_PERCENT;
  @State rightOptionWidth: string = Constants.HALF_PERCENT;
  @State isClick: boolean = false;
  @State points: number[][] = Constants.BEGIN_POINTS;
  @State fillOpacity: number = Constants.BEGIN_FILL_OPACITY;
  @StorageProp(CommonConstants.KEY_PREFIX_BREAKPOINT) currentBreakpoint: string = '';
  private pageInfos: NavPathStack = new NavPathStack();
  public leftOptionChoose: number = Constants.LEFT_COUNT;
  public rightOptionChoose: number = Constants.RIGHT_COUNT;
  public animateParam: AnimateParam = {
    duration: Constants.ANIMATE_DURATION,
    curve: Curve.EaseOut
  };

  changeState(option: string) {
    this.isClick = true;
    this.notice = $r('app.string.result_notice', option);
    this.fillOpacity = Constants.END_FILL_OPACITY;
    const leftOptionPercent: number =
      this.leftOptionChoose / (this.leftOptionChoose + this.rightOptionChoose) * Constants.PERCENTAGE;
    this.getUIContext().animateTo(this.animateParam, () => {
      this.leftOptionWidth = leftOptionPercent.toFixed(0) + '%';
      this.rightOptionWidth = (Constants.PERCENTAGE - leftOptionPercent).toFixed(0) + '%';
      this.points = Constants.END_POINTS;
    });
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
        left: this.currentBreakpoint === 'xs' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                                 $r('sys.float.padding_level12') :
                                                                                 $r('sys.float.padding_level16'),
        right: this.currentBreakpoint === 'xs' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                                  $r('sys.float.padding_level12') :
                                                                                  $r('sys.float.padding_level16')
      })
      .width('100%')
      .height(96)
      .zIndex(2)

      Row() {
        Column() {
          Flex({
            direction: FlexDirection.Row,
            justifyContent: FlexAlign.Start
          }) {
            Text($r('app.string.voting_component_voting_theme_image_text'))
              .fontSize($r('app.integer.voting_component_voting_theme_image_text_font_size'))
              .margin({
                top: 16,
                right: $r('app.integer.voting_component_voting_theme_image_margin_right')
              })
          }

          Stack() {
            Flex({
              direction: FlexDirection.Row,
              justifyContent: FlexAlign.Center
            }) {
              Stack() {
                Column()
                  .borderRadius({
                    topLeft: $r('app.integer.voting_component_fillet_radius'),
                    bottomLeft: $r('app.integer.voting_component_fillet_radius'),
                    topRight: $r('app.integer.voting_component_right_angle_radius'),
                    bottomRight: $r('app.integer.voting_component_right_angle_radius')
                  })
                  .backgroundColor($r('sys.color.multi_color_07'))
                  .opacity(this.fillOpacity)
                  .width(this.leftOptionWidth)
                  .height(50)
                Stack() {
                  if (!this.isClick) {
                    Text($r('app.string.left_option'))
                      .fontColor(Color.White)
                      .margin({ right: $r('app.integer.voting_component_text_center_margin') })
                  } else {
                    Column() {
                      Text(this.leftOptionWidth)
                        .fontColor(Constants.LEFT_COLOR)
                        .fontSize($r('app.integer.voting_component_upper_text_font_size'))
                      Text($r('app.string.left_option'))
                        .fontColor(Constants.LEFT_COLOR)
                        .fontSize($r('app.integer.voting_component_under_text_font_size'))
                    }
                  }
                }
              }.onClick(() => {
                if (this.isClick) {
                  return;
                }
                this.leftOptionChoose++;
                this.changeState(this.ResourceToString($r('app.string.left_option')));
              })

              Stack() {
                Column()
                  .borderRadius({
                    topLeft: $r('app.integer.voting_component_right_angle_radius'),
                    bottomLeft: $r('app.integer.voting_component_right_angle_radius'),
                    topRight: $r('app.integer.voting_component_fillet_radius'),
                    bottomRight: $r('app.integer.voting_component_fillet_radius')
                  })
                  .backgroundColor($r('sys.color.brand'))
                  .opacity(this.fillOpacity)
                  .width(this.rightOptionWidth)
                  .height(50)
                Stack() {
                  if (!this.isClick) {
                    Text($r('app.string.right_option'))
                      .fontColor(Color.White)
                      .margin({ left: $r('app.integer.voting_component_text_center_margin') })
                  } else {
                    Column() {
                      Text(this.rightOptionWidth)
                        .fontColor(Constants.RIGHT_COLOR)
                        .fontSize($r('app.integer.voting_component_upper_text_font_size'))
                      Text($r('app.string.right_option'))
                        .fontColor(Constants.RIGHT_COLOR)
                        .fontSize($r('app.integer.voting_component_under_text_font_size'))
                    }
                  }
                }
              }.onClick(() => {
                if (this.isClick) {
                  return;
                }
                this.rightOptionChoose++;
                this.changeState(this.ResourceToString($r('app.string.right_option')));
              })
            }

            Stack() {
              Polygon()
                .points(this.points)
                .fill($r('sys.color.background_secondary'))
                .antiAlias(true)
                .width($r('app.integer.voting_component_polygon_width'))
                .height($r('app.integer.voting_component_polygon_height'))
              Stack() {
                if (!this.isClick) {
                  Text() {
                    Span($r('app.string.voting_component_mid_text_left'))
                      .fontColor($r('sys.color.multi_color_08'))
                    Span($r('app.string.voting_component_mid_text_right'))
                      .fontColor($r('sys.color.brand'))
                  }
                  .backgroundColor($r('sys.color.background_secondary'))
                  .fontSize($r('app.integer.voting_component_mid_text_font_size'))
                  .fontStyle(FontStyle.Italic)
                  .fontWeight(Constants.MID_TEXT_FONT_WEIGHT)
                  .textAlign(TextAlign.Center)
                }
              }
              .backgroundColor($r('sys.color.background_secondary'))
            }
            .position({ x: this.leftOptionWidth })
            .markAnchor({ x: $r('app.string.voting_component_mid_gap_mark_anchor') })
          }
          .width($r('app.string.voting_component_parent_column_width'))

          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
            Text(this.notice)
              .fontSize(12)
            Stack() {
              if (this.isClick) {
                Text(this.leftOptionChoose + this.rightOptionChoose +
                this.ResourceToString($r('app.string.bottom_text_suffix')))
                  .fontSize(12)
              }
            }
          }
          .padding({ left: 4 })
        }
        .height($r('app.string.voting_component_parent_column_height'))
        .width(this.currentBreakpoint === 'lg' ? '60%' : $r('app.string.voting_component_parent_column_width'))
        .padding({
          left: this.currentBreakpoint === 'xs' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                                   $r('sys.float.padding_level12') :
                                                                                   $r('sys.float.padding_level16'),
          right: this.currentBreakpoint === 'xs' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                                    $r('sys.float.padding_level12') :
                                                                                    $r('sys.float.padding_level16')
        })
        .justifyContent(FlexAlign.Start)

        Column().width(this.currentBreakpoint === 'lg' ? '40%' : '100%')
      }

    }
    .backgroundColor($r('sys.color.background_secondary'))
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.pageInfos = context.pathStack;
    })

  }

  ResourceToString(resource: Resource): string {
    try {
      return this.getUIContext().getHostContext()!.resourceManager.getStringSync(resource.id);
    } catch (err) {
      Logger.error('VotingComponent', '%{public}s', 'getStringSync error: ' + err.code);
    }
    return '';
  }
}

@Builder
export function getPageVotingComponent(name: string): void {
  if (name === 'VotingComponent') {
    VotingComponent()

  }
}

export const wrappedBuilderVotingComponent: WrappedBuilder<[string, number]> = wrapBuilder(getPageVotingComponent);