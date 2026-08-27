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

import { Constants } from '../common/Constants';
import { BreakpointType, BreakpointTypeEnum } from '../common/utils/BreakpointSystem';
import { VideoViewModel } from '../viewmodel/VideoViewModel';

@Component
export struct VideoInfoView {
  @StorageLink(Constants.KEY_BREAKPOINT) currentWidthBreakpoint: string = BreakpointTypeEnum.SM;
  @Link secondLevelIndex: number;
  private videoViewModel = new VideoViewModel();
  private iteration: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16];

  build() {
    Grid() {
      ForEach(this.iteration, () => {
        GridItem() {
          Column() {
            Image(this.videoViewModel.getVideo(this.secondLevelIndex))
              .objectFit(ImageFit.Fill)
              .width('100%')
              .borderRadius($r('sys.float.corner_radius_level6'))

            Row()
              .height($r('app.float.size_16'))
              .width('50%')
              .borderRadius($r('sys.float.corner_radius_level6'))
              .backgroundColor($r('sys.color.ohos_id_color_click_effect'))
              .margin({
                top: new BreakpointType({
                  sm: $r('sys.float.padding_level5'),
                  md: $r('sys.float.padding_level5'),
                  lg: $r('sys.float.padding_level6'),
                  xl: $r('sys.float.padding_level6')
                }).getValue(this.currentWidthBreakpoint),
                bottom: $r('sys.float.padding_level3')
              })

            Row()
              .height($r('app.float.size_14'))
              .width('100%')
              .borderRadius($r('sys.float.corner_radius_level6'))
              .backgroundColor($r('sys.color.ohos_id_color_hover'))
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.SpaceBetween)
        }
      }, (item: number, index: number) => index + JSON.stringify(item))
    }
    .layoutWeight(1)
    .scrollBar(BarState.Off)
    .columnsTemplate(new BreakpointType({
      sm: '1fr 1fr',
      md: '1fr 1fr 1fr',
      lg: '1fr 1fr 1fr 1fr',
      xl: '1fr 1fr 1fr'
    })
      .getValue(this.currentWidthBreakpoint))
    .width('100%')
    .rowsGap(new BreakpointType({
      sm: $r('sys.float.padding_level6'),
      md: $r('sys.float.padding_level8'),
      lg: $r('sys.float.padding_level8'),
      xl: $r('sys.float.padding_level8')
    }).getValue(this.currentWidthBreakpoint))
    .columnsGap(new BreakpointType({
      sm: $r('sys.float.padding_level8'),
      md: $r('sys.float.padding_level6'),
      lg: $r('sys.float.padding_level8'),
      xl: $r('sys.float.padding_level8'),
    }).getValue(this.currentWidthBreakpoint))
    .padding({
      left: new BreakpointType({
        sm: $r('sys.float.padding_level8'),
        md: $r('sys.float.padding_level12'),
        lg: $r('app.float.padding_level18'),
        xl: $r('sys.float.padding_level12')
      }).getValue(this.currentWidthBreakpoint),
      right: new BreakpointType({
        sm: $r('sys.float.padding_level8'),
        md: $r('sys.float.padding_level12'),
        lg: $r('app.float.padding_level18'),
        xl: $r('sys.float.padding_level12')
      }).getValue(this.currentWidthBreakpoint),
      top: $r('sys.float.padding_level6'),
      bottom: new BreakpointType({
        sm: $r('sys.float.padding_level3'),
        md: $r('sys.float.padding_level3'),
        lg: $r('sys.float.padding_level10'),
        xl: $r('sys.float.padding_level10')
      }).getValue(this.currentWidthBreakpoint)
    })
  }
}