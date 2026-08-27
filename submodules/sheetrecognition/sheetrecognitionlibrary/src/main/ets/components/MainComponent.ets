/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */

import { LengthMetrics } from '@kit.ArkUI';
import { CommonConstants } from '../constants/CommonConstants';
import { BreakpointType } from '../utils/BreakpointSystem';
import { WindowUtil } from '../utils/WindowUtil';
import { SheetExtractionComponent } from './SheetExtractionComponent';

@Component
export struct MainComponent {
  @Provide(CommonConstants.KEY_PREFIX_SYSTEM_PATHSTACK) pathStack: NavPathStack = new NavPathStack();
  @StorageProp(CommonConstants.KEY_PREFIX_BREAKPOINT) currentBp: WidthBreakpoint = WidthBreakpoint.WIDTH_SM;
  @StorageLink(CommonConstants.KEY_PREFIX_STATUS_BAR_HEIGHT) topStatusBarHeight: number = 0;
  @StorageLink(CommonConstants.KEY_PREFIX_NAVIGATOR_BAR_HEIGHT) navBarHeight: number = 0;

  @Builder
  PageMap(name: string) {
    if (name === 'SheetExtraction') {
      SheetExtractionComponent()
    }
  }

  aboutToDisappear(): void {
    WindowUtil.unRegisterBreakPoint();
  }

  build() {
    Column() {
      Navigation(this.pathStack) {
        Column() {
          Button($r('app.string.btn_recognize_title'), { stateEffect: true, type: ButtonType.Capsule })
            .width(this.currentBp == WidthBreakpoint.WIDTH_SM ? CommonConstants.FULL_PERCENT :
                   CommonConstants.BTN_MAX_WIDTH)
            .height(CommonConstants.BTN_HEIGHT)
            .onClick(() => {
              this.pathStack.pushPath({ name: 'SheetExtraction' });
            })
        }
        .width(CommonConstants.FULL_PERCENT)
        .height(CommonConstants.FULL_PERCENT)
        .justifyContent(FlexAlign.End)
        .padding({
          right: this.currentBp === WidthBreakpoint.WIDTH_SM ? $r('sys.float.padding_level8') :
                 $r('sys.float.padding_level0'),
          left: this.currentBp === WidthBreakpoint.WIDTH_SM ? $r('sys.float.padding_level8') :
                $r('sys.float.padding_level0'),
          bottom: CommonConstants.BOTTOM_MARGIN
        })
      }
      .title($r('app.string.title'), {
        paddingStart: LengthMetrics.resource(new BreakpointType({
          sm: $r('app.float.margin_size_SM'),
          md: $r('app.float.margin_size_MD'),
          lg: $r('app.float.margin_size_LG'),
          xl: $r('app.float.margin_size_LG')
        }).getValue(this.currentBp))
      })
      .titleMode(NavigationTitleMode.Full)
      .mode(NavigationMode.Stack)
      .navDestination(this.PageMap)
    }
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .padding({
      top: this.topStatusBarHeight,
    })
  }
}

