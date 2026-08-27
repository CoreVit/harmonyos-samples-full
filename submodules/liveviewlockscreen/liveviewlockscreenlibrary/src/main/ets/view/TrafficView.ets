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
import { ConfigurationConstant } from '@kit.AbilityKit';
import { Constants } from '../common/Constants';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { TrafficInfoView } from './TrafficInfoView';

@Component
export struct TrafficView {
  @StorageLink(Constants.KEY_PREFIX + 'NaviIndicatorHeight') naviIndicatorHeight: number = 0;
  @StorageLink(Constants.KEY_PREFIX + 'CurrentWidthBreakpoint') currentWidthBreakpoint: string = BreakpointTypeEnum.SM;
  @StorageLink(Constants.KEY_PREFIX + 'CurrentHeightBreakpoint') currentHeightBreakpoint: string =
    BreakpointTypeEnum.LG;
  @StorageLink('LiveViewColorMode') colorMode: ConfigurationConstant.ColorMode =
    AppStorage.get('LiveViewColorMode') ?? ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET;
  private uiContext: UIContext = this.getUIContext();
  private updateInterval: number | undefined;

  aboutToDisappear(): void {
    if (this.updateInterval !== undefined) {
      clearInterval(this.updateInterval);
      this.updateInterval = undefined;
    }
  }

  build() {
    Column() {
      Row() {
        Column() {
          Column() {
            Row() {
              Image($r('app.media.big_arrow'))
                .objectFit(ImageFit.Contain)
                .height(new BreakpointType({ sm: 80, md: 70, lg: 70, }).getValue(this.currentWidthBreakpoint))
              Column() {
                Text($r('app.string.traffic_info_meter'))
                  .fontColor(Color.White)
                  .fontWeight(FontWeight.Bold)
                  .alignSelf(ItemAlign.Start)
                  .fontSize(40)
                  .margin({
                    top: $r('sys.float.padding_level8'),
                    left: $r('sys.float.padding_level8'),
                  })
                Text($r('app.string.road_name'))
                  .fontColor(Color.White)
                  .fontWeight(FontWeight.Regular)
                  .alignSelf(ItemAlign.Start)
                  .fontSize(24)
                  .margin({
                    left: $r('sys.float.padding_level8'),
                  })
              }
            }
            .borderRadius({
              topLeft: new BreakpointType({ sm: 0, md: 16, lg: 16, }).getValue(this.currentWidthBreakpoint),
              topRight: new BreakpointType({ sm: 0, md: 16, lg: 16, }).getValue(this.currentWidthBreakpoint),
            })
            .backgroundColor($r('app.color.Index_background_first'))
            .width(new BreakpointType({ sm: '100%', md: '50%', lg: '30%', }).getValue(this.currentWidthBreakpoint))
            .padding({
              bottom: $r('sys.float.padding_level8'),
              top: new BreakpointType({
                sm: $r('sys.float.padding_level16'),
                md: $r('sys.float.padding_level0'),
                lg: $r('sys.float.padding_level0'),
              }).getValue(this.currentWidthBreakpoint),
              left: new BreakpointType({
                sm: $r('sys.float.padding_level8'),
                md: $r('sys.float.padding_level12'),
                lg: $r('sys.float.padding_level16'),
              }).getValue(this.currentWidthBreakpoint),
            })

            Row() {
              Text($r('app.string.then'))
                .fontColor(Color.White)
                .fontWeight(FontWeight.Regular)
                .alignSelf(ItemAlign.Start)
                .fontSize(22)
                .margin({
                  left: $r('sys.float.padding_level8'),
                  right: $r('sys.float.padding_level2'),
                })
              Image($r('app.media.little_arrow'))
                .objectFit(ImageFit.Contain)
                .height(25)
            }
            .borderRadius({
              bottomLeft: new BreakpointType({ sm: 0, md: 16, lg: 16, }).getValue(this.currentWidthBreakpoint),
              bottomRight: new BreakpointType({ sm: 0, md: 16, lg: 16, }).getValue(this.currentWidthBreakpoint),
            })
            .padding({
              bottom: $r('sys.float.padding_level2'),
              top: $r('sys.float.padding_level2'),
            })
            .width(new BreakpointType({ sm: '100%', md: '50%', lg: '30%', }).getValue(this.currentWidthBreakpoint))
            .backgroundColor($r('app.color.Index_background_second'))

            if (this.currentWidthBreakpoint !== BreakpointTypeEnum.SM) {
              Image($r('app.media.traffic_info_speed'))
                .objectFit(ImageFit.Contain)
                .height(80)
                .position({
                  top: 0,
                  left: this.currentWidthBreakpoint === BreakpointTypeEnum.MD ? '51%' : '31%',
                })
            }
          }

          Row() {
            if (this.currentWidthBreakpoint === BreakpointTypeEnum.SM) {
              Image($r('app.media.traffic_info_speed'))
                .objectFit(ImageFit.Contain)
                .height(70)
            }
            Image($r('app.media.traffic_info_label'))
              .objectFit(ImageFit.Contain)
              .height(new BreakpointType({ sm: 70, md: 80, lg: 80, }).getValue(this.currentWidthBreakpoint))
          }
          .width(new BreakpointType({ sm: '100%', md: '40%', lg: '30%', }).getValue(this.currentWidthBreakpoint))
        }
        .margin({
          left: new BreakpointType({
            sm: $r('sys.float.padding_level0'),
            md: $r('sys.float.padding_level12'),
            lg: $r('sys.float.padding_level16'),
          }).getValue(this.currentWidthBreakpoint),
          top: new BreakpointType({
            sm: $r('sys.float.padding_level0'),
            md: $r('sys.float.padding_level16'),
            lg: $r('sys.float.padding_level16'),
          }).getValue(this.currentWidthBreakpoint),
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)

      Blank()

      Row() {
        Stack({ alignContent: Alignment.Top }) {
          Image($rawfile('traffic_light.svg'))
            .objectFit(ImageFit.Contain)
            .width(new BreakpointType({ sm: '20%', md: '15%', lg: '10%', }).getValue(this.currentWidthBreakpoint))
            .position({
              left: '70%',
              top: 30
            })
        }
        .width('100%')
      }

      Blank()
      Blank()

      Row() {
        Column() {
          Divider()
            .strokeWidth(4)
            .color($r('sys.color.font_tertiary'))
            .width($r('sys.float.padding_level24'))
            .lineCap(LineCapStyle.Round)
            .margin({
              top: $r('sys.float.padding_level3'),
              bottom: $r('sys.float.padding_level7')
            })

          TrafficInfoView()
        }
        .height(100)
        .width(new BreakpointType({ sm: '100%', md: '300vp', lg: '360vp', }).getValue(this.currentWidthBreakpoint))
        .borderColor($r('sys.color.comp_divider'))
        .borderRadius({
          topLeft: $r('sys.float.corner_radius_level12'),
          topRight: $r('sys.float.corner_radius_level12'),
          bottomLeft: new BreakpointType({
            sm: $r('sys.float.padding_level0'),
            md: $r('sys.float.corner_radius_level12'),
            lg: $r('sys.float.corner_radius_level12'),
          }).getValue(this.currentWidthBreakpoint),
          bottomRight: new BreakpointType({
            sm: $r('sys.float.padding_level0'),
            md: $r('sys.float.corner_radius_level12'),
            lg: $r('sys.float.corner_radius_level12'),
          }).getValue(this.currentWidthBreakpoint),
        })
        .backgroundColor($r('sys.color.background_secondary'))
        .shadow(ShadowStyle.OUTER_DEFAULT_XS)
        .position({
          bottom: 0,
          left: new BreakpointType({
            sm: $r('sys.float.padding_level0'),
            md: $r('sys.float.corner_radius_level12'),
            lg: $r('sys.float.corner_radius_level16'),
          }).getValue(this.currentWidthBreakpoint),
        })
        .padding({
          bottom: new BreakpointType({
            sm: this.uiContext.px2vp(this.naviIndicatorHeight),
            md: 0,
            lg: 0,
          }).getValue(this.currentWidthBreakpoint),
        })
        .margin({
          bottom: new BreakpointType({
            sm: 0,
            md: this.uiContext.px2vp(this.naviIndicatorHeight),
            lg: this.uiContext.px2vp(this.naviIndicatorHeight),
          }).getValue(this.currentWidthBreakpoint),
        })
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundImageSize(ImageSize.Cover)
    .backgroundImagePosition(Alignment.Center)
  }
}