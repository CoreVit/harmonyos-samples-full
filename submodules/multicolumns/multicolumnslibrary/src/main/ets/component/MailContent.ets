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

import { Constants } from '../common/Constants';
import { OperateTabs } from '../model/dataType';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';

@Component
export struct MailContent {
  @State buttonList: OperateTabs[] = [
    new OperateTabs($r('sys.symbol.envelope_badge_arrow_left'), $r('app.string.reply')),
    new OperateTabs($r('sys.symbol.envelope_on_envelope_badge_arrow_left'), $r('app.string.replyAll')),
    new OperateTabs($r('sys.symbol.rectangle_and_arrowshape_turn_up_right'), $r('app.string.send')),
    new OperateTabs($r('sys.symbol.trash'), $r('app.string.delete')),
    new OperateTabs($r('sys.symbol.dot_grid_2x2'), $r('app.string.more')),
  ]
  @StorageProp(Constants.KEY_BREAKPOINT) curBp: string = BreakpointTypeEnum.SM;
  @StorageProp(Constants.KEY_NAV_INDICATOR_HEIGHT) navIndicatorHeight: number = 0;
  @StorageProp(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;

  build() {
    NavDestination() {
      Column() {
        Column() {
          Text($r('app.string.mailDetailTitle'))
            .fontSize($r('sys.float.Title_M'))
            .margin({ left: this.curBp === BreakpointTypeEnum.SM ? Constants.PADDING_32 + Constants.BACK_SIZE : 0 })
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.font_primary'))

          Row() {
            Text($r('app.string.recUser'))
              .fontSize($r('sys.float.Body_M'))
              .fontWeight(FontWeight.Regular)
              .fontColor($r('sys.color.font_primary'))
            Text($r('app.string.mailDesc'))
              .padding({ left: $r('sys.float.padding_level2') })
              .fontSize($r('sys.float.Body_L'))
              .fontWeight(FontWeight.Medium)
              .fontColor($r('sys.color.font_primary'))
              .maxLines(1)
              .layoutWeight(1)
              .maxFontSize($r('sys.float.Body_L'))
              .minFontSize($r('sys.float.Caption_S'))
              .constraintSize({
                minWidth: Constants.MAIL_TEXT_MIN,
                maxWidth: '100%'
              })
              .ellipsisMode(EllipsisMode.END)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
            Blank()
            SymbolGlyph($r('sys.symbol.chevron_down'))
              .fontSize($r('sys.float.Title_M'))
              .fontColor([$r('sys.color.icon_secondary')])
          }
          .alignItems(VerticalAlign.Center)
          .width('100%')
          .height($r('app.float.item_height_48'))

          Text($r('app.string.postMaster'))
            .fontSize($r('sys.float.Title_S'))
            .fontColor($r('sys.color.font_primary'))
            .lineHeight($r('app.float.line_height_23'))
          Text($r('app.string.postTime'))
            .margin({ top: $r('sys.float.padding_level1') })
            .fontColor($r('sys.color.font_tertiary'))

          Scroll() {
            Column() {
              Text($r('app.string.textData')).fancyText()
              Text($r('app.string.bodyTextPartOne')).fancyText()
              Text('').fancyText()
              Image($r('app.media.orange'))
                .width('100%')
                .height($r('app.float.content_image_height'))
                .borderRadius($r('sys.float.corner_radius_level5'))
              Text('').fancyText()
              Text($r('app.string.bodyTextPartTwo')).fancyText()
              Text($r('app.string.bodyTextPartThree')).fancyText()
            }
            .alignItems(HorizontalAlign.Center)
          }
          .margin({ top: $r('sys.float.padding_level10') })
          .layoutWeight(1)
          .width('100%')
          .scrollBar(BarState.Off)
        }
        .layoutWeight(1)
        .padding({
          left: new BreakpointType({
            sm: $r('sys.float.padding_level8'),
            md: $r('sys.float.padding_level12'),
            lg: $r('sys.float.padding_level16')
          }).getValue(this.curBp),
          right: new BreakpointType({
            sm: $r('sys.float.padding_level8'),
            md: $r('sys.float.padding_level12'),
            lg: $r('sys.float.padding_level16'),
          }).getValue(this.curBp),
        })
        .alignItems(HorizontalAlign.Start)

        Row() {
          ForEach(this.buttonList, (item: OperateTabs) => {
            Column() {
              SymbolGlyph(item.src)
                .fontColor([$r('sys.color.ohos_id_color_text_secondary')])
                .fontSize($r('sys.float.Title_M'))
              Text(item.name)
                .fontColor($r('sys.color.ohos_id_color_text_secondary'))
                .fontSize($r('sys.float.Caption_M'))
                .lineHeight($r('app.float.line_height_12'))
            }
          }, (item: OperateTabs, index: number) => {
            return index + JSON.stringify(item);
          })
        }
        .justifyContent(FlexAlign.SpaceAround)
        .width('100%')
        .height($r('app.float.item_height'))
      }
      .width('100%')
      .height('100%')
    }
    .padding({
      top: this.statusBarHeight === 0 ? Constants.PADDING_16 : this.statusBarHeight + Constants.PADDING_CUSTOM,
      bottom: this.navIndicatorHeight,
    })
    .backgroundColor($r('sys.color.background_secondary'))
    .width('100%')
    .height('100%')
    .hideTitleBar(true)
  }
}

@Extend(Text)
function fancyText() {
  .fontColor($r('sys.color.font_primary'))
  .fontSize($r('sys.float.Body_L'))
  .fontWeight(FontWeight.Regular)
  .lineHeight($r('app.float.line_height_25'))
}