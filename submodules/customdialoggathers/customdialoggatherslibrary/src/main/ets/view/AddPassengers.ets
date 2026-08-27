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

import { BusinessError } from '@kit.BasicServicesKit';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { CommonConstants } from '../common/constants/CommonConstants';
import { PersonList, personList } from '../viewmodel/BindContentModel';
import Logger from '../utils/Logger';

const TAG = '[AddPassengers]';

@Builder
export function AddPassengersBuilder() {
  AddPassengers()
}

@Component
export struct AddPassengers {
  @StorageLink(CommonConstants.AS_KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageLink(CommonConstants.AS_KEY_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  @StorageLink(CommonConstants.AS_KEY_BREAK_POINT) curBp: string = BreakpointTypeEnum.SM;
  private personList: Array<PersonList> = personList;

  getResourceString(resource: Resource): string {
    let resourceString: string = '';
    try {
      let hostContext = this.getUIContext().getHostContext();
      if (hostContext) {
        resourceString = hostContext.resourceManager.getStringSync(resource.id);
      }
    } catch (error) {
      const err = error as BusinessError;
      Logger.error(TAG, `getResourceString catch error, code: ${err.code}, message: ${err.message}`);
    }
    return resourceString;
  }

  @Builder
  MyBuilder() {
    Column() {
      Column() {
        Row() {
          Text($r('app.string.passenger'))
            .fontSize($r('sys.float.Subtitle_L'))
            .fontColor($r('sys.color.font_primary'))
            .width(CommonConstants.FULL_PERCENT)
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bold)
            .padding({ top: $r('sys.float.padding_level5') })
        }
        .height($r('app.integer.passenger_text_height'))
        .margin({
          top: $r('sys.float.padding_level4'),
          bottom: $r('sys.float.padding_level4')
        })

        Row() {
          Button({ type: ButtonType.Circle }) {
            SymbolGlyph($r('sys.symbol.plus'))
              .fontColor([$r('sys.color.comp_background_primary')])
              .fontSize($r('sys.float.Subtitle_L'))
          }
          .backgroundColor($r('sys.color.brand'))
          .height($r('sys.float.Title_M'))
          .aspectRatio(1)
          .margin({ right: $r('sys.float.padding_level4') })

          Text($r('app.string.add_person'))
            .fontColor($r('sys.color.brand'))
            .fontSize($r('sys.float.Body_L'))
            .fontWeight(FontWeight.Medium)
        }
        .width(CommonConstants.FULL_PERCENT)
        .height($r('app.integer.button_height'))
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .backgroundColor($r('sys.color.comp_background_primary'))
        .borderRadius($r('sys.float.corner_radius_level6'))
        .margin({
          top: $r('sys.float.padding_level4'),
          bottom: $r('sys.float.padding_level6')
        })

        Column() {
          ForEach(this.personList, (item: PersonList, index: number) => {
            Row() {
              Row() {
                SymbolGlyph($r('sys.symbol.square_and_pencil'))
                  .fontColor([$r('sys.color.icon_tertiary')])
                  .fontSize($r('sys.float.Subtitle_M'))
                  .margin({
                    right: $r('sys.float.padding_level8')
                  })
                Column() {
                  Text(item.name)
                    .fontColor($r('sys.color.font_primary'))
                    .fontSize($r('sys.float.Subtitle_M'))
                    .fontWeight(FontWeight.Medium)
                  Text(item.cardNum)
                    .fontColor($r('sys.color.font_tertiary'))
                    .fontSize($r('sys.float.Subtitle_S'))
                    .fontWeight(FontWeight.Regular)
                    .margin($r('sys.float.padding_level1'))
                }
                .alignItems(HorizontalAlign.Start)
              }

              if (index % 2 === 0) {
                Checkbox()
                  .select(true)
              } else {
                Checkbox()
                  .select(false)
              }
            }
            .borderRadius({
              topLeft: index === 0 ? $r('sys.float.corner_radius_level6') : 0,
              topRight: index === 0 ? $r('sys.float.corner_radius_level6') : 0,
              bottomLeft: index === 3 ? $r('sys.float.corner_radius_level6') : 0,
              bottomRight: index === 3 ? $r('sys.float.corner_radius_level6') : 0
            })
            .backgroundColor($r('sys.color.comp_background_primary'))
            .height(64)
            .width(CommonConstants.FULL_PERCENT)
            .justifyContent(FlexAlign.SpaceBetween)
            .padding({
              left: $r('sys.float.padding_level8'),
              right: $r('sys.float.padding_level8')
            })
          }, (item: PersonList) => (item.name).toString())
        }
        .height($r('app.integer.button_height'))
        .width(CommonConstants.FULL_PERCENT)
        .borderRadius($r('sys.float.corner_radius_level6'))
        .backgroundColor($r('sys.color.comp_background_primary'))
      }

      Button($r('app.string.confirmed'))
        .width('100%')
        .backgroundColor($r('sys.color.brand'))
        .fontSize($r('sys.float.Body_L'))
        .height($r('app.integer.button_height_small'))
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .height(CommonConstants.FULL_PERCENT)
    .width(CommonConstants.FULL_PERCENT)
    .backgroundColor($r('sys.color.background_secondary'))
    .padding({
      right: $r('sys.float.padding_level8'),
      left: $r('sys.float.padding_level8'),
    })
  }

  build() {
    NavDestination() {
      this.MyBuilder()
    }
    .title(this.getResourceString($r('app.string.select_person')))
    .backgroundColor($r('sys.color.background_secondary'))
    .padding({
      right: new BreakpointType({
        sm: $r('sys.float.padding_level0'),
        md: $r('sys.float.padding_level0'),
        lg: $r('sys.float.padding_level2')
      }).getValue(this.curBp),
      bottom: this.navigatorBarHeight,
      left: new BreakpointType({
        sm: $r('sys.float.padding_level0'),
        md: $r('sys.float.padding_level0'),
        lg: $r('sys.float.padding_level8')
      }).getValue(this.curBp)
    })
  }
}