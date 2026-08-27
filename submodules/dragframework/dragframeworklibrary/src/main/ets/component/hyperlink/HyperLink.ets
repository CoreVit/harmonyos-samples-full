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

import { unifiedDataChannel, uniformTypeDescriptor } from '@kit.ArkData';
import { SubHeader, TextModifier } from '@kit.ArkUI';
import { Constants } from '../../common/Constants';
import { ConfigMapKey, ResourceUtil } from '../../common/ResourceUtil';
import Logger from '../../common/utils/Logger';

const TAG: string = '[HyperLink]';

@Builder
export function PageHyperLinkBuilder() {
  HyperLinkDrag();
}

@Component
struct HyperLinkDrag {
  @State dropContent: ResourceStr = '';
  @State url: string = '';
  @State type: string = '';
  @State primaryModifier: TextModifier =
    new TextModifier().fontColor(Color.Gray).fontSize($r('sys.float.Subtitle_L')).fontWeight(FontWeight.Medium);
  @Consume(Constants.KEY_PATH_STACK) pageStack: NavPathStack;
  @StorageProp(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          Column() {
            Hyperlink(ResourceUtil.getRawFileStringByKey(ConfigMapKey.HUAWEI_DEVELOPER_URL),
              'This is huawei developer.')
              .draggable(true)
              .margin({ top: $r('sys.float.padding_level4') })
            Hyperlink(ResourceUtil.getRawFileStringByKey(ConfigMapKey.HUAWEI_DEVECO_STUDIO_URL),
              'This is huawei DevEco Studio.')
              .draggable(true)
              .margin({
                top: $r('sys.float.padding_level4'),
                bottom: $r('sys.float.padding_level4')
              })
          }
          .width('100%')
          .constraintSize({ maxWidth: '100%' })
          .alignItems(HorizontalAlign.Start)
          .backgroundColor($r('sys.color.comp_background_primary'))
          .borderRadius($r('sys.float.corner_radius_level8'))
          .padding({
            left: $r('sys.float.padding_level8'),
            right: $r('sys.float.padding_level8'),
            top: $r('sys.float.padding_level4'),
            bottom: $r('sys.float.padding_level4')
          })
          .margin({
            left: $r('sys.float.padding_level8'),
            right: $r('sys.float.padding_level8'),
            top: $r('sys.float.padding_level4')
          })

          SubHeader({
            primaryTitle: $r('app.string.hyperlink_text_column_name'),
            primaryTitleModifier: this.primaryModifier
          })
          Column() {
            Text(this.dropContent)
              .fontSize($r('sys.float.Body_L'))
              .lineHeight(Constants.LINE_HEIGHT)
              .width('100%')
              .constraintSize({ maxWidth: '100%' })
              .margin({
                left: $r('sys.float.padding_level8'),
                right: $r('sys.float.padding_level8'),
                top: $r('sys.float.padding_level4')
              })
          }
          .height(Constants.COLUMN_HEIGHT)
          .width('100%')
          .constraintSize({ maxWidth: '100%' })
          .backgroundColor($r('sys.color.comp_background_primary'))
          .borderRadius($r('sys.float.corner_radius_level8'))
          .allowDrop([uniformTypeDescriptor.UniformDataType.HYPERLINK])
          .onDrop((event: DragEvent) => {
            let dragData: UnifiedData | undefined;
            try {
              dragData = event.getData() as UnifiedData;
            } catch (err) {
              Logger.error(TAG, `event.getData failed. code: ${err.code ?? ''}, message: ${err.message ?? ''}`);
              return;
            }
            if (dragData === undefined) {
              return;
            }
            let record = dragData.getRecords();
            let size = record.length;
            if (size < 1) {
              this.dropContent = $r('app.string.none_data');
              return;
            }
            let type = record[0].getType();
            this.type = type;
            let hyperLink = (record[0]) as unifiedDataChannel.Hyperlink;
            event.setResult(DragResult.DROP_DISABLED);
            this.url = hyperLink.url;
            this.dropContent = $r('app.string.data_detail', hyperLink.url, hyperLink.description);
          })
          .margin({
            left: $r('sys.float.padding_level8'),
            right: $r('sys.float.padding_level8')
          })

          SubHeader({
            primaryTitle: $r('app.string.hyperlink_none_text_column_name'),
            primaryTitleModifier: this.primaryModifier
          })
          Stack() {
            Column() {
              SymbolGlyph($r('sys.symbol.nosign'))
                .fontColor([$r('sys.color.icon_tertiary')])
                .fontSize($r('sys.float.Title_M'))
                .margin({
                  bottom: $r('sys.float.padding_level4')
                })
              Text($r('app.string.area_none_drag'))
                .fontColor($r('sys.color.font_tertiary'))
                .fontSize($r('sys.float.Body_L'))
                .fontFamily('HarmonyHeiTi')
            }
          }
          .allowDrop([uniformTypeDescriptor.UniformDataType.TEXT])
          .onDrop((event: DragEvent) => {
            event.setResult(DragResult.DROP_DISABLED);
          })
          .height(Constants.COLUMN_HEIGHT)
          .width('100%')
          .constraintSize({ maxWidth: '100%' })
          .borderRadius($r('sys.float.corner_radius_level8'))
          .backgroundColor($r('sys.color.comp_background_primary'))
          .margin({
            left: $r('sys.float.padding_level8'),
            right: $r('sys.float.padding_level8')
          })
        }
        .backgroundColor($r('sys.color.background_secondary'))
        .margin({
          bottom: $r('sys.float.padding_level8')
        })
      }
    }
    .title($r('app.string.hyperlink_title'))
    .backgroundColor($r('sys.color.background_secondary'))
  }
}