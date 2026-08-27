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

import { CommonConstants } from '../constants/CommonConstants'
import { ArkTSFunModel } from '../model/ProductModel';
import { OrderConfirm } from '../view/OrderConfirm';
import { webview } from '@kit.ArkWeb';
import { ComponentContent, PromptAction } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { BreakpointTypeEnum } from '../utils/BreakpointSystem';
import Logger from '../utils/Logger';
import { WindowUtil } from '../utils/WindowUtil';

const TAG: string = '[PageRedirectionComponent]';

@Builder
function buildOrderConfirm(params: Record<string, string | Function>) {
  Column() {
    OrderConfirm({
      detailStr: params.detailStr as string,
      callBack: params.callBack as Function
    })
  }
  .width(CommonConstants.FULL_PERCENT)
  .borderRadius($r('sys.float.corner_radius_level5'))
  .clip(true)
  .height('80%')
}


@Component
export struct PageRedirectionComponent {
  @StorageProp(CommonConstants.KEY_PREFIX_NAVIGATOR_BAR_HEIGHT) navBarHeight: number = 0;
  @StorageProp(CommonConstants.KEY_PREFIX_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageProp(CommonConstants.KEY_PREFIX_BREAKPOINT) curBp: string = BreakpointTypeEnum.SM;
  @StorageProp(CommonConstants.KEY_PREFIX_SYSTEM_SYSTEMLANGUAGE) @Watch('systemLanguageChange') systemLanguage: string =
    '';
  @State webCanBack: boolean = false;
  @State webCanForward: boolean = false;
  @State controller: webview.WebviewController = new webview.WebviewController();
  @Provide(CommonConstants.KEY_PREFIX_SYSTEM_PATHSTACK) pathStack: NavPathStack = new NavPathStack();
  private uiContext = this.getUIContext();
  private promptAction: PromptAction = this.uiContext.getPromptAction();
  private contentNode: ComponentContent<Record<string, string | Function>> | undefined = undefined;
  private urlTrustList: string = '{"UrlPermissionList":[{"host":"resfile"}]}';
  private whiteMethods: Array<string> = ['setLanguage', 'setTopHeight'];
  closeDialog = () => {
    if (this.contentNode) {
      this.promptAction.closeCustomDialog(this.contentNode);
    }
  }

  aboutToDisappear(): void {
    WindowUtil.unRegisterBreakPoint();
  }

  systemLanguageChange() {
    try {
      let jsMethod: string = `setLanguage('${this.systemLanguage}')`;
      // Check the trustlist
      if (this.whiteMethods.indexOf(jsMethod.split('(')[0]) === -1) {
        Logger.error('SystemLanguageChange privacy security', 'input method not in whiteList');
        return;
      }
      this.controller.runJavaScript(jsMethod);
    } catch (error) {
      Logger.error(TAG, 'runJavaScript failed ' + JSON.stringify(error));
    }
  }

  @Builder
  PagesMap(name: string, param: object) {
    if (name === 'OrderConfirm') {
      OrderConfirm(param)
    }
  }

  arkTSObj: ArkTSFunModel = {
    jumpOrderConfirm: (detailStr: string) => this.jumpOrderConfirm(detailStr)
  };

  aboutToAppear() {
    webview.WebviewController.setWebDebuggingAccess(false);
  }

  onBackPress() {
    if (this.webCanBack) {
      try {
        this.controller.backward();
        return true;
      } catch (error) {
        Logger.error(TAG, 'backward failed ' + JSON.stringify(error));
        return false;
      }
    }
    return false;
  }

  jumpOrderConfirm(detailStr: string): void {
    let params: Record<string, string | Function> = {
      'detailStr': detailStr,
      'callBack': this.closeDialog,
      'curBp': this.curBp
    }
    this.contentNode = new ComponentContent(this.uiContext, wrapBuilder(buildOrderConfirm), params);
    try {
      this.promptAction.openCustomDialog(this.contentNode, {
        alignment: this.curBp === 'sm' ? DialogAlignment.Bottom : DialogAlignment.Center
      });
    } catch (error) {
      Logger.error(TAG, 'openCustomDialog failed ' + JSON.stringify(error));
    }
  }

  build() {
    Navigation(this.pathStack) {
      Stack() {
        Web({
          src: this.getUIContext().getHostContext()!.resourceDir + '/product_list.html',
          controller: this.controller
        })
          .height('100%')
          .javaScriptProxy({
            object: this.arkTSObj,
            name: 'arkTSFunObj',
            methodList: ['jumpOrderConfirm'],
            controller: this.controller,
            permission: javascriptProxyPermission
          })
          .onControllerAttached(() => {
            try {
              this.controller.setPathAllowingUniversalAccess([this.getUIContext().getHostContext()!.resourceDir])
              this.controller.setUrlTrustList(this.urlTrustList);
            } catch (error) {
              Logger.error(TAG,
                `onControllerAttached fail, ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
            }
          })
          .onConfirm(() => {
            try {
              this.uiContext.getPromptAction().showToast({
                message: $r('app.string.toast_msg'),
                duration: CommonConstants.TOAST_DURATION
              });
            } catch (error) {
              const err: BusinessError = error as BusinessError;
              Logger.error(TAG, `showToast failed, ErrorCode: ${err.code}, Message: ${err.message}`)
            }
            return false;
          })
          .onPageEnd(() => {
            try {
              this.webCanBack = this.controller.accessBackward();
              this.webCanForward = this.controller.accessForward();
              let setTopHeight: string = `setTopHeight(${this.statusBarHeight},${this.navBarHeight})`;
              let setLanguage: string = `setLanguage('${this.systemLanguage}')`;
              // Check the trustlist
              if (this.whiteMethods.indexOf(setTopHeight.split('(')[0]) === -1 ||
                this.whiteMethods.indexOf(setLanguage.split('(')[0]) === -1) {
                Logger.error('privacy security', 'input method not in whiteList');
                return;
              }
              this.controller.runJavaScript(setTopHeight);
              this.controller.runJavaScript(setLanguage);
            } catch (error) {
              Logger.error(TAG,
                `onPageEnd fail, ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
            }
          })
          .darkMode(WebDarkMode.Auto)
          .mixedMode(MixedMode.None)

        Column() {
          Row() {
            SymbolGlyph($r('sys.symbol.arrow_left'))
              .fontSize($r('sys.float.Title_M'))
              .fontColor(this.webCanBack ? [$r('sys.color.font_secondary')] : [$r('sys.color.font_tertiary')])
              .enabled(this.webCanBack)
              .onClick(() => {
                try {
                  this.controller.backward();
                } catch (error) {
                  const err: BusinessError = error as BusinessError;
                  Logger.error(TAG, `backward failed, ErrorCode: ${err.code}, Message: ${err.message}`)
                }
              })

            SymbolGlyph($r('sys.symbol.arrow_right'))
              .fontSize($r('sys.float.Title_M'))
              .fontColor(this.webCanForward ? [$r('sys.color.font_secondary')] : [$r('sys.color.font_tertiary')])
              .enabled(this.webCanForward)
              .onClick(() => {
                try {
                  this.controller.forward();
                } catch (error) {
                  const err: BusinessError = error as BusinessError;
                  Logger.error(TAG, `backward failed, ErrorCode: ${err.code}, Message: ${err.message}`)
                }
              })

            SymbolGlyph($r('sys.symbol.house'))
              .fontSize($r('sys.float.Title_M'))
              .fontColor([$r('sys.color.font_secondary')])
              .onClick(() => {
                try {
                  this.controller.backward();
                } catch (error) {
                  const err: BusinessError = error as BusinessError;
                  Logger.error(TAG, `backward failed, ErrorCode: ${err.code}, Message: ${err.message}`)
                }
              })
          }
          .justifyContent(FlexAlign.SpaceAround)
          .width(CommonConstants.FULL_PERCENT)
          .height($r('app.float.navi_height'))
        }
        .height(56 + this.navBarHeight)
        .width('100%')
        .backgroundBlurStyle(BlurStyle.COMPONENT_THICK)
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
      .alignContent(Alignment.Bottom)
    }
    .hideTitleBar(true)
    .mode(NavigationMode.Stack)
    .navDestination(this.PagesMap)
  }
}

export const javascriptProxyPermission = `{
    "javascriptProxyPermission": {
      "urlPermissionList": [
        {
          "scheme": "resource",
          "host": "resfile",
          "port": "",
          "path": ""
        }
      ],
      "methodList": [
        {
          "methodName": "jumpOrderConfirm",
          "urlPermissionList": [
            {
              "scheme": "https",
              "host": "xxx.com",
              "port": "",
              "path": ""
            },
              {
              "scheme": "resource",
              "host": "resfile",
              "port": "",
              "path": ""
            },
          ]
        }
      ]
    }
  }`;