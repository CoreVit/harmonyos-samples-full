/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { image } from '@kit.ImageKit';
import { fileIo } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import {
  CustomTransitionDelegate,
  HdsNavigation,
  HdsNavigationMenuContentOptions,
  HdsNavigationMenuItemOptions,
  HdsNavigationTitleMode,
  IconStyleMode,
  TitleBarStyleOptions
} from '@kit.UIDesignKit';
import Logger from '../utils/Logger';
import type { BreakpointType } from '../utils/MultiDeviceUtil';
import { StatusBarUtil } from '../utils/StatusBarUtil';
import { getValueByBreakpointSync } from '../utils/MultiDeviceUtil';
import { CustomTransition } from '../utils/NavigationTransitionUtils';
import { PictureEdit } from './PictureEdit';
import { CommonConstants } from '../common/constant/CommonConstants';
import type { EditNavParam, ImageInfoItem, ImageRect } from '../types/CommonTypes';
import { WindowMenuHelper } from '../viewModel/WindowMenuHelper';
import { IndexViewModel } from '../viewModel/IndexViewModel';
import { inspector } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State navPathStack: NavPathStack = new NavPathStack();
  @State isShow: boolean = false;
  @State imageRect: ImageRect = {
    width: 0,
    height: 0,
    x: 0,
    y: 0
  };
  @State imageInfoArr: ImageInfoItem[] = [];
  @State titleBarMenu: HdsNavigationMenuContentOptions = {
    maxCount: 5,
    value: []
  };
  @StorageLink(CommonConstants.BREAKPOINT_KEY) currentBreakpoint: BreakpointType = 'sm';
  @StorageLink(CommonConstants.IS_PC_DEVICE) isPCDevice: boolean = false;
  @StorageLink(CommonConstants.IS_FULLSCREEN) @Watch('onFullScreenStateChanged') isFullScreen: boolean = false;
  @StorageLink(CommonConstants.IS_FOLDED) isFolded: boolean = false;
  private imageSource?: image.ImageSource;
  private imageFile?: fileIo.File;
  private context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
  private titleBarStyle: TitleBarStyleOptions = IndexViewModel.initTitleBarStyle();
  private listener: inspector.ComponentObserver = this.getUIContext().getUIInspector().createComponentObserver('HDS_NAVIGATION');

  onFullScreenStateChanged(): void {
    this.updateMenuItems();
  }

  updateMenuItems(): void {
    const iconType = this.isPCDevice ? IconStyleMode.SMALL : IconStyleMode.NORMAL;
    const items: HdsNavigationMenuItemOptions[] = [
      {
        content: {
          icon: $r('sys.symbol.info_circle'),
          isEnabled: true,
          action: (): void => {
            this.isShow = !this.isShow;
          },
          type: iconType
        }
      },
      {
        content: {
          icon: $r('sys.symbol.square_and_pencil'),
          type: iconType,
          isEnabled: true,
          action: async (): Promise<void> => {
            try {
              const snapshot = await this.getUIContext().getComponentSnapshot().get('indexPreviewImage');
              this.navPathStack.pushPath({
                name: 'Edit',
                param: { imageRect: this.imageRect, sourcePixelMap: snapshot } as EditNavParam
              });
            } catch (error) {
              Logger.error(`getComponentSnapshot failed.`);
            }
          }
        }
      }
    ];

    if (this.isPCDevice) {
      WindowMenuHelper.appendTo(items, {
        context: this.context,
        onFullScreenChange: () => {
          this.updateMenuItems();
        }
      });
    }

    this.titleBarMenu = {
      maxCount: 5,
      value: items
    };
  }

  async initData(): Promise<void> {
    const result = await IndexViewModel.initData(this.getUIContext());
    if (!result.imageFile || !result.imageSource) {
      return;
    }
    this.imageFile = result.imageFile;
    this.imageSource = result.imageSource;
    this.imageInfoArr = result.imageInfoArr;
  }

  private transitionDelegate: CustomTransitionDelegate = (
    from: NavContentInfo,
    to: NavContentInfo,
    operation: NavigationOperation): NavigationAnimatedTransition | undefined => {

    const customAnimation: NavigationAnimatedTransition = {
      transition: (transitionProxy: NavigationTransitionProxy): void => {
        const toAnimation = to.navDestinationId ? CustomTransition.getAnimationById(to.navDestinationId) : undefined;
        const fromAnimation =
          from.navDestinationId ? CustomTransition.getAnimationById(from.navDestinationId) : undefined;
        if (operation === NavigationOperation.PUSH) {
          toAnimation?.onEnterStart();
          fromAnimation?.onExitStart();
          this.getUIContext().animateTo({
            duration: CommonConstants.TRANSITION_DURATION, onFinish: () => {
              transitionProxy.finishTransition();
            }
          }, () => {
            toAnimation?.onEnterFinish();
            fromAnimation?.onExitFinish();
          });
        } else {
          fromAnimation?.onEnterFinish();
          toAnimation?.onExitFinish();
          this.getUIContext().animateTo({
            duration: CommonConstants.TRANSITION_DURATION, onFinish: () => {
              transitionProxy.finishTransition();
            }
          }, () => {
            toAnimation?.onEnterFinish();
            fromAnimation?.onEnterStart();
          });
        }
      }
    };
    return customAnimation;
  };

  aboutToAppear(): void {
    this.initData();
    this.listener.on('draw', StatusBarUtil.setWindowStatusBarProperties);
    WindowMenuHelper.init(this.context, () => {
      this.updateMenuItems();
    });
  }

  aboutToDisappear(): void {
    WindowMenuHelper.release();
    this.imageSource?.release();
    this.listener.off('draw', StatusBarUtil.setWindowStatusBarProperties);
    if (this.imageFile) {
      try {
        fileIo.closeSync(this.imageFile);
      } catch (error) {
        const err: BusinessError = error as BusinessError;
        Logger.error(`closeSync failed, error ${err.code}: ${err.message}`);
      }
    }
  }

  @Builder
  infoBuilder() {
    Column() {
      Row() {
        Text($r('app.string.picture_information'))
          .fontSize(20)
          .fontWeight(700)
          .lineHeight(27)
          .fontColor($r(`app.color.picture_information_title_color`));

        Row() {
          SymbolGlyph($r('sys.symbol.xmark'))
            .fontColor([$r(`app.color.picture_information_button_x_color`)])
            .fontSize(18);
        }
        .width(40)
        .height(40)
        .borderRadius(20)
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .backgroundColor($r(`app.color.picture_information_button_bg_color`))
        .onClick(() => {
          this.isShow = false;
        });
      }
      .width('100%')
      .height(CommonConstants.NAVIGATION_HEIGHT)
      .justifyContent(FlexAlign.SpaceBetween);

      Blank()
        .height(10)

      Scroll() {
        List() {
          ForEach(this.imageInfoArr, (item: ImageInfoItem) => {
            ListItem() {
              Row() {
                Text(item.label)
                  .fontSize(16)
                  .fontWeight(500)
                  .lineHeight(21)
                  .fontColor($r(`app.color.picture_information_list_item_color`));
                Text(item.value + '')
                  .fontSize(14)
                  .lineHeight(19)
                  .fontColor($r(`app.color.picture_information_list_val_color`));
              }
              .width('100%')
              .height('100%')
              .justifyContent(FlexAlign.SpaceBetween)
              .padding({ left: 12, right: 12 });
            }
            .width('100%')
            .height(48);
          }, (item: ImageInfoItem) => item.label);
        }
        .divider({
          strokeWidth: 0.5,
          color: $r(`app.color.picture_information_divider_color`),
          startMargin: 12,
          endMargin: 12
        })
        .width('100%')
        .height('100%')
        .constraintSize({ maxHeight: 345 })
        .borderRadius(16)
        .scrollBar(BarState.Auto)
        .scrollBarWidth(5)
        .edgeEffect(EdgeEffect.Spring)
        .backgroundColor($r(`app.color.picture_information_inner_bg_color`));
      }
      .layoutWeight(this.isFolded ? 1 : 0)
      .padding({
        bottom: this.currentBreakpoint === 'sm' && !this.isFolded ? 44 : 16,
      });
    }
    .padding({
      top: 8,
      right: 16,
      left: 16
    })
    .backgroundColor($r(`app.color.picture_information_bg_color`))
    .width(this.currentBreakpoint === 'sm' ? '100%' : 480);
  }

  @Builder
  pageMap(name: string) {
    if (name === 'Edit') {
      PictureEdit();
    }
  }

  build() {
    HdsNavigation(this.navPathStack) {
      Column() {
        Image($rawfile('low.jpg'))
          .id('indexPreviewImage')
          .width(getValueByBreakpointSync({ sm: '100%', md: 'auto', lg: 'auto' }, this.currentBreakpoint))
          .height(getValueByBreakpointSync({ sm: 'auto', md: '100%', lg: '100%' }, this.currentBreakpoint))
          .objectFit(ImageFit.Contain)
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
          .onAreaChange((_: Area, newValue: Area) => {
            this.imageRect = {
              width: newValue.width as number,
              height: newValue.height as number,
              x: newValue.position.x as number,
              y: newValue.position.y as number
            };
          });
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .bindSheet($$this.isShow, this.infoBuilder(), {
        height: SheetSize.FIT_CONTENT,
        preferType: getValueByBreakpointSync({
          sm: SheetType.BOTTOM,
          md: SheetType.CENTER,
          lg: SheetType.CENTER
        }, this.currentBreakpoint),
        showClose: false
      });
    }
    .titleBar({
      style: this.titleBarStyle,
      avoidLayoutSafeArea: true,
      content: {
        title: {
          mainTitle: $r('app.string.preview')
        },
        menu: this.titleBarMenu
      }
    })
    .titleMode(HdsNavigationTitleMode.MINI)
    .hideBackButton(true)
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Black)
    .hideToolBar(true)
    .mode(NavigationMode.Stack)
    .navDestination(this.pageMap)
    .customNavContentTransition(this.transitionDelegate)
    .id('HDS_NAVIGATION')
  }
}