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
import { uiObserver } from '@kit.ArkUI';
import { WidthBreakpointType } from 'multishoppingbase';
import { LiveComment } from './LiveComment';
import { LiveContent } from './LiveContent';
import { LiveShopList } from './LiveShopList';
import { LiveUtil } from './LiveUtil';

/** Live page container (V2); all child components are V2. */
@ComponentV2
export struct LiveBroadCast {
  @Env(SystemProperties.BREAK_POINT) private breakpoint: uiObserver.WindowSizeLayoutBreakpointInfo;
  @Param public widthBp: WidthBreakpoint = WidthBreakpoint.WIDTH_SM;
  @Event public onOpenShopBag: () => void = () => {
  };
  @Event public onClose: () => void = () => {
  };

  private isSmOrMd(): boolean {
    const bp = this.widthBp;
    return bp === WidthBreakpoint.WIDTH_XS || bp === WidthBreakpoint.WIDTH_SM || bp === WidthBreakpoint.WIDTH_MD;
  }

  build() {
    Column() {
      Stack() {
        LiveContent({
          widthBp: this.widthBp
        })
          .width('100%')
          .height('100%')
        Column() {
          Stack() {
            Column() {
              LiveComment({
                widthBp: this.widthBp
              })
              LiveShopList({
                isSideListLayout: false,
                widthBp: this.widthBp,
                onOpenProductDetail: () => {
                  this.onOpenShopBag();
                }
              })
                .visibility(this.breakpoint.heightBreakpoint === HeightBreakpoint.HEIGHT_MD &&
                  this.breakpoint.widthBreakpoint === WidthBreakpoint.WIDTH_SM ? Visibility.None :
                  this.isSmOrMd() ? Visibility.Visible : Visibility.None)
            }
            .justifyContent(FlexAlign.End)
            .alignItems(HorizontalAlign.Start)
            .width('100%')
            .height('100%')

            Row() {
              LiveShopList({
                isSideListLayout: true,
                widthBp: this.widthBp,
                onOpenProductDetail: () => {
                  this.onOpenShopBag();
                }
              })
            }
            .visibility(this.breakpoint.heightBreakpoint === HeightBreakpoint.HEIGHT_MD ? Visibility.None :
              this.isSmOrMd() ? Visibility.None : Visibility.Visible)
            .justifyContent(FlexAlign.End)
            .alignItems(VerticalAlign.Bottom)
            .width('100%')
            .height('100%')
          }
          .layoutWeight(1)
          .padding({
            left: new WidthBreakpointType(16, 24, 32, 32).getValue(this.widthBp),
            right: new WidthBreakpointType(0, 0, 32, 32).getValue(this.widthBp)
          })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .layoutWeight(1)
      .width('100%')
      .background($r('app.color.live_stage_background'))

      LiveUtil({
        widthBp: this.widthBp,
        onOpenShopBag: this.onOpenShopBag
      })
    }
    .height('100%')
    .width('100%')
    .background($r('app.color.live_stage_background'))
  }
}
