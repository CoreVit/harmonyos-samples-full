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
import { MailType } from '../model/dataType';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';

@Extend(Text)
function textStyle() {
  .backgroundColor($r('app.color.mail_side_bg_color'))
  .fontColor($r('app.color.mail_side_font_color'))
  .fontSize($r('sys.float.Caption_M'))
  .textAlign(TextAlign.Center)
}

@Component
export struct MailSideBar {
  build() {
    Column() {
      AccountInfo()
      MailStatusList()
    }
    .width('100%')
  }
}

@Component
struct AccountInfo {
  @State accountList: string[] = [
    'xxxxxxxxxxxxx',
    'xxxxxxxxxxxxx',
  ]
  @StorageProp(Constants.KEY_BREAKPOINT) curBp: string = BreakpointTypeEnum.SM;

  @Builder
  accountInfo() {
    Column() {
      Row() {
        Text($r('app.string.account'))
          .fontSize($r('sys.float.Body_L'))
          .fontColor($r('sys.color.font_primary'))
          .fontWeight(FontWeight.Medium)
        Blank()
        Text($r('app.string.addAccount'))
          .fontSize($r('sys.float.Body_L'))
          .fontColor($r('sys.color.brand'))
          .fontWeight(FontWeight.Medium)
      }
      .width('100%')
      .height($r('app.float.item_height_48'))
    }
    .margin({ top: $r('app.float.mail_account_margin_top') })
  }

  build() {
    Column() {
      this.accountInfo()
      List() {
        ForEach(this.accountList, (item: string, index: number | undefined) => {
          ListItem() {
            Row() {
              Text()
                .width($r('app.float.tag_circle_size'))
                .height($r('app.float.tag_circle_size'))
                .borderRadius($r('sys.float.corner_radius_level4'))
                .backgroundColor(index === 0 ? '#61cfbe' : '#fec700')
              Text(item)
                .fontSize($r('sys.float.Body_L'))
                .fontColor($r('sys.color.font_primary'))
                .margin({ left: $r('sys.float.padding_level6') })
              Blank()
              if (index === 0) {
                SymbolGlyph($r('sys.symbol.checkmark'))
                  .fontSize($r('sys.float.Subtitle_L'))
                  .fontColor([$r('sys.color.brand')])
              } else {
                Text('9')
                  .width($r('app.float.text_circle_size'))
                  .height($r('app.float.text_circle_size'))
                  .borderRadius($r('sys.float.corner_radius_level9'))
                  .textStyle()
              }
            }.width('100%')
            .height($r('app.float.item_height'))
          }
        }, (item: string) => item.toString())
      }
      .width('100%')
      .height('100%')
      .divider({ strokeWidth: 0.5, color: $r('sys.color.comp_divider') })
    }
    .padding({
      left: new BreakpointType({
        sm: $r('sys.float.padding_level8'),
        md: $r('sys.float.padding_level12'),
        lg: $r('sys.float.padding_level16')
      }).getValue(this.curBp),
      right: new BreakpointType({
        sm: $r('sys.float.padding_level8'),
        md: $r('sys.float.padding_level12'),
        lg: $r('sys.float.padding_level16')
      }).getValue(this.curBp),
    })
  }
}

@Component
struct MailStatusList {
  @State mailState: MailType[] = [
    new MailType($r('app.string.recvBox'), 3, $r('app.media.inbox')),
    new MailType($r('app.string.unRead'), 5, $r('app.media.unread')),
    new MailType($r('app.string.sended'), 9, $r('app.media.ic_favourites')),
    new MailType($r('app.string.allFolders'), 0, $r('app.media.allFolders'))
  ]

  @Builder
  accountInfo() {
    Row() {
      Text($r('app.string.account'))
        .fontSize($r('sys.float.Body_M'))
        .fontColor($r('sys.color.font_tertiary'))

      Text($r('app.string.addAccount'))
        .fontSize($r('sys.float.Body_M'))
        .fontColor($r('sys.color.brand'))
    }
    .backgroundColor(Color.Red)
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .height($r('app.float.item_height_48'))
  }

  build() {
    List() {
      ListItem() {
        this.accountInfo()
      }

      ForEach(this.mailState, (item: MailType, index: number | undefined) => {
        ListItem() {
          Row() {
            Image(item.src)
              .width($r('app.float.button_height_small'))
              .height($r('app.float.button_height_small'))
            Text(item.type)
              .fontSize($r('sys.float.Body_L'))
              .margin({ left: $r('sys.float.padding_level8') })
              .fontColor(index === 0 ? '#000' : '#e5000000')
              .fontWeight(FontWeight.Medium)
            Blank()
            if (index === this.mailState.length - 1) {
              Image($r('app.media.ic_settings_arrow'))
                .width($r('app.float.button_height_small'))
                .height($r('app.float.button_height_small'))
                .rotate({ angle: 90 })
            } else {
              Text(item.num.toString())
                .fontColor($r('app.color.text_color'))
                .fontSize($r('sys.float.Body_M'))
            }
          }.width('100%')
        }.padding({ left: $r('sys.float.padding_level8'), right: $r('sys.float.padding_level12') })
        .height($r('app.float.item_height'))
        .backgroundColor(index === 0 ? $r('app.color.item_selected_color') : undefined)
        .borderRadius($r('sys.float.corner_radius_level8'))
      }, (item: MailType, index: number) => {
        return index + JSON.stringify(item);
      })
    }
    .width('100%')
    .height('100%')
    .padding({ left: $r('sys.float.padding_level4'), right: $r('sys.float.padding_level4') })
    .margin({ top: $r('sys.float.padding_level4') })
    .divider({ strokeWidth: 1, startMargin: $r('sys.float.padding_level6'), endMargin: $r('sys.float.padding_level6') })
  }
}