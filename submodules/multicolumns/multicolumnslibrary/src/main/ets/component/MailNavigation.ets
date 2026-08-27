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
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { MailContent } from './MailContent';

@Component
export struct MailNavigation {
  @State pathInfo: NavPathStack = new NavPathStack();
  @State mailList: string[] = ['1', '1', '1', '1', '1', '1'];
  @State selectedIndex: number = 2;
  @StorageProp(Constants.KEY_BREAKPOINT) currentBreakPoint: string = BreakpointTypeEnum.MD;
  @StorageProp(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageProp(Constants.KEY_NAV_INDICATOR_HEIGHT) navIndicatorHeight: number = 0;
  private mailListSize: number = this.mailList.length;

  @Builder
  myRouter(name: string) {
    if (name === 'mailContent') {
      MailContent()
    }
  }

  @Builder
  NavigationMenus() {
    if (this.currentBreakPoint !== BreakpointTypeEnum.MD) {
      Row() {
        SymbolGlyph($r('sys.symbol.plus'))
          .fontColor([$r('sys.color.icon_primary')])
          .fontSize($r('sys.float.Title_M'))
        SymbolGlyph($r('sys.symbol.dot_grid_2x2'))
          .fontColor([$r('sys.color.icon_primary')])
          .fontSize($r('sys.float.Title_M'))
          .margin({ left: $r('sys.float.padding_level12') })
      }
      .alignItems(VerticalAlign.Center)
      .height($r('app.float.item_height'))
      .padding({ top: this.statusBarHeight + Constants.PADDING_CUSTOM, right: Constants.PADDING_16 })
    }
  }

  @Builder
  NavigationTitle() {
    Column() {
      Text($r('app.string.recvBox'))
        .fontColor($r('sys.color.font_primary'))
        .fontSize($r('sys.float.Title_L'))
        .fontWeight(FontWeight.Medium)
      Text($r('app.string.inboxSubtitle'))
        .fontColor($r('sys.color.font_tertiary'))
        .fontSize($r('sys.float.Subtitle_S'))
        .margin({ top: $r('sys.float.padding_level2'), left: $r('sys.float.padding_level1') })
    }
    .alignItems(HorizontalAlign.Start)
    .height($r('app.float.mail_inbox_height'))
    .width('100%')
    .padding({
      top: $r('app.float.mail_inbox_margin_top'),
      left: new BreakpointType({
        sm: $r('sys.float.padding_level8'),
        md: $r('sys.float.padding_level12'),
        lg: $r('sys.float.padding_level16')
      }).getValue(this.currentBreakPoint),
      right: new BreakpointType({
        sm: $r('sys.float.padding_level8'),
        md: $r('sys.float.padding_level12'),
        lg: $r('sys.float.padding_level16')
      }).getValue(this.currentBreakPoint),
    })
  }

  aboutToAppear() {
    this.pathInfo.pushPath({ name: 'mailContent' })
  }

  build() {
    Navigation(this.pathInfo) {
      Stack({ alignContent: Alignment.BottomEnd }) {
        Column() {
          Search({ placeholder: $r('app.string.searchMail') })
          List() {
            ForEach(this.mailList, (item: string, index: number) => {
              ListItem() {
                Column() {
                  Row() {
                    Text($r('app.string.nonSense'))
                      .fontSize($r('sys.float.Body_L'))
                      .lineHeight($r('app.float.line_height_22'))
                      .fontColor($r('sys.color.font_primary'))
                    Blank()
                    Text($r('app.string.date'))
                      .fontSize($r('sys.float.Body_S'))
                      .opacity(0.6)
                  }.width('100%')

                  Column() {
                    Text($r('app.string.textPartOne'))
                      .lineHeight($r('app.float.line_height_19'))
                      .fontSize($r('sys.float.Body_M'))
                      .fontColor($r('sys.color.font_primary'))
                    Text($r('app.string.textPartTwo'))
                      .fontSize($r('sys.float.Body_M'))
                      .fontColor($r('sys.color.font_tertiary'))
                      .lineHeight($r('app.float.line_height_19'))
                  }
                  .width('100%')
                  .alignItems(HorizontalAlign.Start)
                }
                .height($r('app.float.mail_mail_height'))
                .justifyContent(FlexAlign.Center)
              }
              .padding({ left: $r('sys.float.padding_level6'), right: $r('sys.float.padding_level6') })
              .margin({
                bottom: index === this.mailListSize - 1 ? this.navIndicatorHeight : 0
              })
              .backgroundColor(index === this.selectedIndex ? $r('app.color.item_selected_color') : undefined)
              .borderRadius($r('sys.float.corner_radius_level5'))
            }, (item: string) => item.toString())
          }
          .scrollBar(BarState.Off)
          .divider({
            strokeWidth: 0.5,
            startMargin: $r('sys.float.padding_level6'),
            endMargin: $r('sys.float.padding_level6'),
            color: $r('sys.color.comp_divider')
          })
          .height('100%')
          .width('100%')
          .layoutWeight(1)
        }
        .height('100%')
        .width('100%')
        .padding({
          left: new BreakpointType({
            sm: $r('sys.float.padding_level8'),
            md: $r('sys.float.padding_level12'),
            lg: $r('sys.float.padding_level16')
          }).getValue(this.currentBreakPoint),
          right: new BreakpointType({
            sm: $r('sys.float.padding_level8'),
            md: $r('sys.float.padding_level12'),
            lg: $r('sys.float.padding_level16')
          }).getValue(this.currentBreakPoint),
        })

        if (this.currentBreakPoint !== BreakpointTypeEnum.LG && this.currentBreakPoint !== BreakpointTypeEnum.XL) {
          Image($r('app.media.ic_public_list_add_light'))
            .width($r('app.float.image_size_48'))
            .height($r('app.float.image_size_48'))
            .margin({
              right: $r('sys.float.padding_level16'),
              bottom: this.currentBreakPoint === BreakpointTypeEnum.SM ? $r('sys.float.padding_level32') :
                $r('sys.float.padding_level24')
            })
        }
      }
    }
    .navBarWidth(new BreakpointType({
      sm: Constants.NAV_BAR_WIDTH_SM,
      md: Constants.NAV_BAR_WIDTH_MD,
      lg: Constants.NAV_BAR_WIDTH_LG,
      xl: Constants.NAV_BAR_WIDTH_XL
    }).getValue(this.currentBreakPoint))
    .navDestination(this.myRouter)
    .menus(this.NavigationMenus)
    .width('100%')
    .title({ builder: this.NavigationTitle, height: $r('app.float.mail_title_height') })
    .hideBackButton(true)
  }
}