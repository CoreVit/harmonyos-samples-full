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

import { ListItemProp } from '../viewmodel/ListItemProp';
import { AnimateCallback, CustomTransition } from '../utils/customtransition/CustomNavigationUtils';
import CommonConstants from '../common/CommonConstants';
import { BreakpointTypeEnum } from '../utils/windowutils/BreakpointSystem';
import { WindowUtil } from '../utils/windowutils/WindowUtil';
import Logger from '../utils/Logger';

const TAG: string = 'TransitionsCollectionComponent';

@Component
export struct TransitionsCollectionComponent {
  @State navList: ListItemProp[] = CommonConstants.navList;
  @Provide(CommonConstants.KEY_PREFIX_TRANSITIONS_NAV_PATH_STACK) pageInfos: NavPathStack = new NavPathStack();
  @StorageProp(CommonConstants.KEY_PREFIX_BREAKPOINT) currentBreakpoint: string = BreakpointTypeEnum.SM;
  @StorageProp(CommonConstants.KEY_PREFIX_NAVIGATOR_BAR_HEIGHT) navigatorBarHeight: number = 0;
  // The name of the page that allows custom transitions.
  private allowedCustomTransitionFromPageNames: string[] =
    ['CardLongTakeTransitionPageOne', 'LeftToRightTransitionPageOne',
      'VideoLongTakeTransitionWithCustomNavigationPageOne',
      'BookFlipLongTakeTransitionPageOne', 'NavigationInteractiveTransitionPageOne'];
  // The name of the page that allows custom transitions.
  private allowedCustomTransitionToPageNames: string[] =
    ['CardLongTakeTransitionPageTwo', 'LeftToRightTransitionPageTwo',
      'VideoLongTakeTransitionWithCustomNavigationPageTwo',
      'BookFlipLongTakeTransitionPageTwo', 'BookFlipLongTakeTransitionPageThree',
      'NavigationInteractiveTransitionPageTwo'
    ];
  @State isEnabled: boolean = true;

  aboutToDisappear(): void {
    WindowUtil.unRegisterBreakPoint();
  }

  private isCustomTransitionEnabled(fromName: string, toName: string): boolean {
    // Both click and return require custom transitions, so they need to be judged separately.
    if ((this.allowedCustomTransitionFromPageNames.includes(fromName) &&
      this.allowedCustomTransitionToPageNames.includes(toName)) ||
      (this.allowedCustomTransitionFromPageNames.includes(toName) &&
        this.allowedCustomTransitionToPageNames.includes(fromName))) {
      return true;
    }
    return false;
  }

  @Builder
  TitleBuilder() {
    Row() {
      Text($r('app.string.EntryAbility_label'))
        .fontColor($r('sys.color.font_primary'))
        .width('100%')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
    }
    .height(128)
    .padding({ top: this.navigatorBarHeight })
    .clip(true)
    .width('100%')
    .alignItems(VerticalAlign.Center)
  }

  build() {
    Navigation(this.pageInfos) {
      Scroll() {
        Column() {
          this.TitleBuilder()
          ForEach(this.navList, (item: ListItemProp) => {
            Row() {
              Text(item.title)
                .width('100%')
                .fontSize('14fp')
                .fontColor($r('sys.color.font_primary'))
            }
            .height(14)
            .margin({
              top: 24,
              left: 12
            })

            List() {
              ForEach(item.children, (itemChild: ListItemProp, index: number) => {
                ListItem() {
                  Column() {
                    Row() {
                      Text(itemChild.title)
                        .height(48)
                        .fontWeight(FontWeight.Medium)
                        .padding({ left: 12 })
                        .fontSize(16)
                        .fontColor($r('sys.color.font_primary'))
                      Blank()
                      Row()
                        .width(10)
                        .height(10)
                        .margin({ right: 20 })
                        .border({
                          width: {
                            top: 2,
                            right: 2
                          },
                          color: $r('sys.color.font_primary')
                        })
                        .rotate({ angle: 45 })
                    }
                    .width('100%')

                    if (itemChild.hasUnderLine === true) {
                      if (this.currentBreakpoint !== 'sm' && index === 6) {
                      } else {
                        Row()
                          .height(0.5)
                          .backgroundColor($r('sys.color.comp_divider'))
                          .width('93%')
                      }
                    }
                  }
                  .onClick(() => {
                    this.pageInfos.pushPath({ name: itemChild.name }, false);
                  })

                }
              }, (item: ListItemProp, index: number) => item.name)
            }
            .lanes(item.onLine ? 1 : (this.currentBreakpoint === 'sm' ? 1 : 2))
            .margin({
              top: 14,
              bottom: 18
            })
            .borderRadius(16)
            .backgroundColor($r('sys.color.comp_background_primary'))
          }, (item: ListItemProp, index: number) => index.toString())
        }
        .padding({
          left: 24,
          right: 24
        })
        .width('100%')
      }
      .scrollBar(BarState.Off)
      .scrollable(ScrollDirection.Vertical)
    }
    .mode(NavigationMode.Stack)
    .hideBackButton(true)
    .backgroundColor($r('sys.color.background_secondary'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .enabled(this.isEnabled)
    .customNavContentTransition((from: NavContentInfo, to: NavContentInfo, operation: NavigationOperation) => {
      if ((!from || !to) || (!from.name || !to.name) || (!from.navDestinationId || !to.navDestinationId)) {
        return undefined;
      }
      let fromParam: AnimateCallback = CustomTransition.getInstance().getAnimateParam(from.navDestinationId);
      let toParam: AnimateCallback = CustomTransition.getInstance().getAnimateParam(to.navDestinationId);
      CustomTransition.getInstance().operation = operation;
      // Follow the hand interaction transition.
      if (CustomTransition.getInstance().isInteractive) {
        let customAnimation: NavigationAnimatedTransition = {
          onTransitionEnd: () => {
            this.isEnabled = true;
            CustomTransition.getInstance().recoverState();
            CustomTransition.getInstance().proxy = undefined;
          },
          transition: (transitionProxy: NavigationTransitionProxy) => {
            CustomTransition.getInstance().proxy = transitionProxy;
            this.isEnabled = false;
            if (fromParam?.onInteractive) {
              fromParam?.onInteractive?.();
            }
            if (toParam?.onInteractive) {
              toParam?.onInteractive?.();
            }
          },
          isInteractive: true
        };
        return customAnimation;
      }

      // User-defined transition routes are controlled by the from and to names.
      if (!this.isCustomTransitionEnabled(from.name, to.name)) {
        return undefined;
      }

      // For the scene where button A is clicked to go to the custom transition and button B is clicked to go to the
      // default transition,
      // it is necessary to judge whether the animation is registered to decide whether to go to the custom transition.
      // fromPage and toPage rigisterNavParam do not pass animation parameters, go to the default transition.
      if (!fromParam.animation && !toParam.animation) {
        return undefined;
      }

      // After all judgments are completed, construct customAnimation to the system side call, execute the custom
      // transition animation.
      let customAnimation: NavigationAnimatedTransition = {
        onTransitionEnd: (isSuccess: boolean) => {
          Logger.info(TAG, `current transition result is ${isSuccess}`);
          this.isEnabled = true;
        },
        timeout: 1000,
        transition: (transitionProxy: NavigationTransitionProxy) => {
          this.isEnabled = false;
          if (fromParam.animation) {
            fromParam.animation(transitionProxy);
          }
          if (toParam.animation) {
            toParam.animation(transitionProxy);
          }
        }
      };
      return customAnimation;
    })
  }
}