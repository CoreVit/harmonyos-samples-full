/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { SymbolGlyphModifier } from '@kit.ArkUI';
import { deviceInfo } from '@kit.BasicServicesKit';
import {
CommonConstants,
getWindowInfoState,
MSVDataModel,
MSVTabs,
MSVTextIcon,
WidthBreakpointType,
WindowInfo
} from 'multishortvideobase';
import { IndividualTabsViewModel } from '../viewmodel/IndividualTabsViewModel';

@ComponentV2
export struct Individual {
  @Local windowInfo: WindowInfo = getWindowInfoState();
  @Consumer('pathStack') pathStack: NavPathStack = new NavPathStack();
  @Local data: MSVDataModel[] = [];
  @Consumer('isDark') isDark: boolean = false;
  @Consumer('showSideIndividual') showSideIndividual: boolean = false;
  @Provider('individualWidth') individualWidth: number = 0;

  aboutToAppear(): void {
    this.data = new IndividualTabsViewModel().getIndividualTabsData();
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Column({ space: deviceInfo.deviceType === '2in1' && !this.showSideIndividual ? 24 : 12 }) {
        Stack({ alignContent: Alignment.TopStart }) {
          Column()
            .width(CommonConstants.FULL_PERCENT)
            .height(CommonConstants.FULL_PERCENT)
            .linearGradient({
              direction: GradientDirection.Bottom,
              colors: [['#33000000', 0.0], ['#99000000', 1.0]]
            })

          Column() {
            Row({ space: 8 }) {
              Row() {
                Row({ space: 12 }) {
                  MSVTextIcon({ src: $r('app.media.ic_user_avatar'), iconSize: 48 })
                  Column({ space: 2 }) {
                    Text($r('app.string.author_id'))
                      .fontSize($r('sys.float.Body_L'))
                      .fontColor($r('sys.color.font_on_primary'))
                      .fontWeight($r('sys.float.font_weight_medium'))
                    Text($r('app.string.channel'))
                      .fontSize($r('sys.float.Caption_L'))
                      .fontColor($r('app.color.channel_color'))
                      .fontWeight($r('sys.float.font_weight_regular'))
                  }
                  .alignItems(HorizontalAlign.Start)
                }
                .margin({ left: 24 })
                .visibility(this.windowInfo.widthBp === WidthBreakpoint.WIDTH_SM &&
                  this.windowInfo.heightBp === HeightBreakpoint.HEIGHT_MD ? Visibility.Visible :
                  Visibility.None)
              }


              Row({ space: 8 }) {
                if (this.showSideIndividual) {
                  Row() {
                    SymbolGlyph($r('sys.symbol.xmark'))
                      .fontSize('18fp')
                      .fontColor(['#FFFFFF'])
                  }
                  .width(40)
                  .aspectRatio(1)
                  .justifyContent(FlexAlign.Center)
                  .alignItems(VerticalAlign.Center)
                  .backgroundColor($r('app.color.all_icon_bg_10'))
                  .borderRadius(CommonConstants.HALF_PERCENT)
                  .onClick(() => {
                    this.pathStack.pop();
                    this.showSideIndividual = false;
                  })
                } else if (this.windowInfo.widthBp < WidthBreakpoint.WIDTH_LG || deviceInfo.deviceType === 'tablet') {
                  Row() {
                    MSVTextIcon({ src: $r('app.media.ic_search'), iconSize: 24 })
                  }
                  .width(40)
                  .aspectRatio(1)
                  .justifyContent(FlexAlign.Center)
                  .alignItems(VerticalAlign.Center)
                  .backgroundColor($r('app.color.all_icon_bg_10'))
                  .borderRadius(CommonConstants.HALF_PERCENT)

                  Row() {
                    MSVTextIcon({ src: $r('app.media.ic_more'), iconSize: 24 })
                  }
                  .width(40)
                  .aspectRatio(1)
                  .justifyContent(FlexAlign.Center)
                  .alignItems(VerticalAlign.Center)
                  .backgroundColor($r('app.color.all_icon_bg_10'))
                  .borderRadius(CommonConstants.HALF_PERCENT)
                } else {
                  Search({ placeholder: $r('app.string.search_placeholder') })
                    .width(240)
                    .height(40)
                    .searchIcon(new SymbolGlyphModifier($r('sys.symbol.magnifyingglass')).fontColor(
                      [$r('sys.color.icon_on_secondary')]))
                    .backgroundColor($r('app.color.all_icon_bg_10'))
                    .placeholderColor($r('sys.color.white'))
                    .margin({ right: 8 })

                  Row() {
                    MSVTextIcon({ src: $r('app.media.ic_more'), iconSize: 24 })
                  }
                  .width(40)
                  .aspectRatio(1)
                  .justifyContent(FlexAlign.Center)
                  .alignItems(VerticalAlign.Center)
                  .backgroundColor($r('app.color.all_icon_bg_10'))
                  .borderRadius(CommonConstants.HALF_PERCENT)
                }
              }
              .visibility(
                deviceInfo.deviceType === 'tv' && !this.showSideIndividual ? Visibility.None : Visibility.Visible)

            }
            .width(CommonConstants.FULL_PERCENT)
            .height(deviceInfo.deviceType === '2in1' && this.showSideIndividual ? 40 : 56)
            .justifyContent(FlexAlign.SpaceBetween)
            .padding({
              right: this.showSideIndividual ?
                new WidthBreakpointType<number>(24, 24, 16, 16).getValue(this.windowInfo.widthBp) :
                deviceInfo.deviceType === 'tablet' ? 32 :
                  new WidthBreakpointType<number>(24, 24, 190, 190).getValue(this.windowInfo.widthBp),
              top: deviceInfo.deviceType === 'tv' ? 40 :
                new WidthBreakpointType<number>(0, 0, 0, 0).getValue(this.windowInfo.widthBp)
            })

            Row({ space: 12 }) {
              MSVTextIcon({ src: $r('app.media.ic_user_avatar'), iconSize: 48 })
              Column({ space: 2 }) {
                Text($r('app.string.author_id'))
                  .fontSize($r('sys.float.Body_L'))
                  .fontColor($r('sys.color.font_on_primary'))
                  .fontWeight($r('sys.float.font_weight_medium'))
                Text($r('app.string.channel'))
                  .fontSize($r('sys.float.Caption_L'))
                  .fontColor($r('app.color.channel_color'))
                  .fontWeight($r('sys.float.font_weight_regular'))
              }
              .alignItems(HorizontalAlign.Start)
            }
            .margin({
              left: deviceInfo.deviceType === 'tv' && !this.showSideIndividual ? 56 : 24,
              top: deviceInfo.deviceType === 'tv' ? 40 : 0
            })
            .alignItems(VerticalAlign.Center)
            .visibility(this.windowInfo.widthBp === WidthBreakpoint.WIDTH_SM &&
              this.windowInfo.heightBp === HeightBreakpoint.HEIGHT_MD ? Visibility.None :
              Visibility.Visible)
          }
          .padding({
            top: deviceInfo.deviceType === 'tv' ? 0 : deviceInfo.deviceType === '2in1' && this.showSideIndividual ? 56 :
              this.getUIContext().px2vp(this.windowInfo.avoidSystem?.topRect.height) ?? 36,
            bottom: this.windowInfo.widthBp === WidthBreakpoint.WIDTH_SM &&
              this.windowInfo.heightBp === HeightBreakpoint.HEIGHT_MD ? 20 : 0
          })
          .justifyContent(this.windowInfo.widthBp === WidthBreakpoint.WIDTH_SM &&
            this.windowInfo.heightBp === HeightBreakpoint.HEIGHT_MD ? FlexAlign.Center : FlexAlign.Start)
          .alignItems(HorizontalAlign.Start)
        }
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(this.windowInfo.widthBp === WidthBreakpoint.WIDTH_SM &&
        this.windowInfo.heightBp === HeightBreakpoint.HEIGHT_MD ? 92 : 228)
      .backgroundImage($r('app.media.ic_ind_background'))
      .backgroundImageSize(ImageSize.Cover)


      Column() {
        Column({ space: 12 }) {
          Row({ space: 16 }) {
            Row({ space: 4 }) {
              Text($r('app.string.likes_count'))
                .fontSize($r('sys.float.Body_L'))
                .fontColor(new WidthBreakpointType<ResourceColor>($r('sys.color.font_primary'),
                  $r('sys.color.font_primary'), $r('sys.color.white'),
                  $r('sys.color.white')).getValue(this.windowInfo.widthBp))
                .fontWeight($r('sys.float.font_weight_medium'))
              Text($r('app.string.likes'))
                .fontSize($r('sys.float.Body_M'))
                .fontColor(new WidthBreakpointType<ResourceColor>($r('sys.color.font_primary'),
                  $r('sys.color.font_primary'), $r('sys.color.font_on_secondary'),
                  $r('sys.color.font_on_secondary')).getValue(this.windowInfo.widthBp))
                .fontWeight($r('sys.float.font_weight_regular'))
            }

            Row({ space: 4 }) {
              Text($r('app.string.friends_count'))
                .fontSize($r('sys.float.Body_L'))
                .fontColor(new WidthBreakpointType<ResourceColor>($r('sys.color.font_primary'),
                  $r('sys.color.font_primary'), $r('sys.color.white'),
                  $r('sys.color.white')).getValue(this.windowInfo.widthBp))
                .fontWeight($r('sys.float.font_weight_medium'))
                .margin({ right: 4 })
              Text($r('app.string.friends'))
                .fontSize($r('sys.float.Body_M'))
                .fontColor(new WidthBreakpointType<ResourceColor>($r('sys.color.font_primary'),
                  $r('sys.color.font_primary'), $r('sys.color.font_on_secondary'),
                  $r('sys.color.font_on_secondary')).getValue(this.windowInfo.widthBp))
                .fontWeight($r('sys.float.font_weight_regular'))
            }

            Row({ space: 4 }) {
              Text($r('app.string.follow_count'))
                .fontSize($r('sys.float.Body_L'))
                .fontColor(new WidthBreakpointType<ResourceColor>($r('sys.color.font_primary'),
                  $r('sys.color.font_primary'), $r('sys.color.white'),
                  $r('sys.color.white')).getValue(this.windowInfo.widthBp))
                .fontWeight($r('sys.float.font_weight_medium'))
                .margin({ right: 4 })
              Text($r('app.string.follow'))
                .fontSize($r('sys.float.Body_M'))
                .fontColor(new WidthBreakpointType<ResourceColor>($r('sys.color.font_primary'),
                  $r('sys.color.font_primary'), $r('sys.color.font_on_secondary'),
                  $r('sys.color.font_on_secondary')).getValue(this.windowInfo.widthBp))
                .fontWeight($r('sys.float.font_weight_regular'))
            }

            Row({ space: 4 }) {
              Text($r('app.string.fans_count'))
                .fontSize($r('sys.float.Body_L'))
                .fontColor(new WidthBreakpointType<ResourceColor>($r('sys.color.font_primary'),
                  $r('sys.color.font_primary'), $r('sys.color.white'),
                  $r('sys.color.white')).getValue(this.windowInfo.widthBp))
                .fontWeight($r('sys.float.font_weight_medium'))
                .margin({ right: 4 })
              Text($r('app.string.fans'))
                .fontSize($r('sys.float.Body_M'))
                .fontColor(new WidthBreakpointType<ResourceColor>($r('sys.color.font_primary'),
                  $r('sys.color.font_primary'), $r('sys.color.font_on_secondary'),
                  $r('sys.color.font_on_secondary')).getValue(this.windowInfo.widthBp))
                .fontWeight($r('sys.float.font_weight_regular'))
            }

          }

          Row({ space: 4 }) {
            Text($r('app.string.introduction'))
              .fontColor(new WidthBreakpointType<ResourceColor>($r('sys.color.font_primary'),
                $r('sys.color.font_primary'), $r('sys.color.font_on_secondary'),
                $r('sys.color.font_on_secondary')).getValue(this.windowInfo.widthBp))
            MSVTextIcon({
              src: new WidthBreakpointType<Resource>($r('app.media.ic_modify'),
                $r('app.media.ic_modify'), $r('app.media.ic_modify_dark'),
                $r('app.media.ic_modify_dark')).getValue(this.windowInfo.widthBp), iconSize: 16
            })
          }

          Row({ space: 4 }) {
            Text($r('app.string.photographer'))
              .fontSize($r('sys.float.Body_S'))
              .fontColor(new WidthBreakpointType<ResourceColor>($r('sys.color.font_primary'),
                $r('sys.color.font_primary'), $r('sys.color.white'),
                $r('sys.color.white')).getValue(this.windowInfo.widthBp))
              .fontWeight($r('sys.float.font_weight_regular'))
              .padding({
                top: 2,
                right: 8,
                bottom: 2,
                left: 8
              })
              .backgroundColor(new WidthBreakpointType<ResourceColor>($r('app.color.tags_bg_xs'),
                $r('app.color.tags_bg_xs'), $r('app.color.tags_bg_md'),
                $r('app.color.tags_bg_md')).getValue(this.windowInfo.widthBp))
              .borderRadius(9.5)
            Text($r('app.string.add_tags'))
              .fontSize($r('sys.float.Body_S'))
              .fontColor(new WidthBreakpointType<ResourceColor>($r('sys.color.font_primary'),
                $r('sys.color.font_primary'), $r('sys.color.white'),
                $r('sys.color.white')).getValue(this.windowInfo.widthBp))
              .fontWeight($r('sys.float.font_weight_regular'))
              .padding({
                top: 2,
                right: 8,
                bottom: 2,
                left: 8
              })
              .backgroundColor(new WidthBreakpointType<ResourceColor>($r('app.color.tags_bg_xs'),
                $r('app.color.tags_bg_xs'), $r('app.color.tags_bg_md'),
                $r('app.color.tags_bg_md')).getValue(this.windowInfo.widthBp))
              .borderRadius(9.5)
          }
        }
        .alignItems(HorizontalAlign.Start)
        .margin({
          left: deviceInfo.deviceType === 'tv' ? 0 : 24,
          top: deviceInfo.deviceType === 'tv' ? 32 : 16
        })
        .visibility(this.showSideIndividual ? Visibility.None : Visibility.Visible)

        Column() {
          MSVTabs({
            data: this.data,
            useFloating: false,
            index: 0,
            showBarUnderline: deviceInfo.deviceType === 'tv' && !this.showSideIndividual ? false : true,
            lightColor: new WidthBreakpointType<ResourceColor>($r('sys.color.font_secondary'),
              $r('sys.color.font_secondary'), $r('sys.color.font_on_secondary'),
              $r('sys.color.font_on_secondary')).getValue(this.windowInfo.widthBp),
            selectedLightColor: $r('sys.color.font_emphasize'),
            darkColor: new WidthBreakpointType<ResourceColor>($r('sys.color.font_secondary'),
              $r('sys.color.font_secondary'), $r('sys.color.font_on_secondary'),
              $r('sys.color.font_on_secondary')).getValue(this.windowInfo.widthBp),
            selectedDarkColor: $r('sys.color.font_emphasize'),
            isDark: this.isDark,
            tabBarSpace: 24,
            barOverlap: false,
            onIndexChange: (index: number) => {
              if (index === 4) {
                this.isDark = false;
              } else {
                this.isDark = true;
              }
            }
          })
        }
        .layoutWeight(1)

      }
      .width(CommonConstants.FULL_PERCENT)
      .height(this.windowInfo.widthBp === WidthBreakpoint.WIDTH_SM &&
        this.windowInfo.heightBp === HeightBreakpoint.HEIGHT_MD ? 'calc(100% - 72vp)' :
        (this.windowInfo.widthBp > WidthBreakpoint.WIDTH_MD ?
          (deviceInfo.deviceType === 'tv' ? 'calc(100% - 196vp)' : 'calc(100% - 160vp)') :
          'calc(100% - 164vp)'))
      .borderRadius({
        topLeft: 20,
        topRight: 20
      })
      .padding({
        left: deviceInfo.deviceType === 'tv' && !this.showSideIndividual ? 56 : 0,
        right: deviceInfo.deviceType === 'tv' && !this.showSideIndividual ? 56 : 0
      })
      .layoutGravity(LocalizedAlignment.BOTTOM_START)
      .backgroundColor(new WidthBreakpointType<ResourceColor>(Color.White, Color.White, $r('app.color.bg_dark'),
        $r('app.color.bg_dark')).getValue(this.windowInfo.widthBp))
      .alignItems(HorizontalAlign.Start)

    }
    .width(CommonConstants.FULL_PERCENT)
    .height(LayoutPolicy.matchParent)
    .ignoreLayoutSafeArea()
    .onAreaChange((oldArea, newArea) => {
      this.individualWidth = Number(newArea.width)
    })
  }
}
