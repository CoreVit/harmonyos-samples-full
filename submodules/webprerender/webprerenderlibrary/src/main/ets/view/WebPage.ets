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

import { BuilderNode, FrameNode, NodeController, UIContext } from '@kit.ArkUI';
import { webview } from '@kit.ArkWeb';
import { BusinessError } from '@kit.BasicServicesKit';
import { Constants } from '../common/Constants';
import { ConfigMapKey, ResourceUtil } from '../common/ResourceUtil';
import Logger from '../common/utils/Logger';

const TAG = '[WebPageView]';

class Data {
  public url: string =
    ResourceUtil.getRawFileStringByKey(ConfigMapKey.GALLERY_URL);
  public controller: WebviewController = new webview.WebviewController();
}

@Component
struct WebPageView {
  @Prop @Require data: Data;
  @State currentProgress: number = 0;
  private total: number = 100;

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Web({ src: this.data.url, controller: this.data.controller })
        .geolocationAccess(false)
        .onControllerAttached(() => {
          try {
            // Set the whitelist to allow access to only the trust web page.
            this.data.controller.setUrlTrustList(Constants.URL_TRUST);
          } catch (error) {
            const err: BusinessError = error as BusinessError;
            Logger.error(TAG, `ErrorCode: ${err.code},  Message: ${err.message}.`);
          }
        })
        .onSslErrorEventReceive((event) => {
          Logger.error(TAG, `OnSslErrorEventReceive: ssl check failed. ${event?.error?.toString()}`);
          event.handler.handleCancel();
        })
        .width($r('app.string.full_height_width'))
        .height($r('app.string.full_height_width'))
        .domStorageAccess(true)
        .onProgressChange((event) => {
          this.currentProgress = event.newProgress;
        })
      Progress({ value: this.currentProgress, type: ProgressType.Linear }).width($r('app.string.full_height_width'))
        .visibility(this.currentProgress === this.total ? Visibility.Hidden : Visibility.Visible)
    }
    .width($r('app.string.full_height_width'))
    .height($r('app.string.full_height_width'))
  }
}

@Builder
function webBuilder(data: Data) {
  WebPageView({ data: data })
}

let wrap = wrapBuilder<Data[]>(webBuilder);

export class MyNodeController extends NodeController {
  private rootNode: BuilderNode<Data[]> | null = null;

  makeNode(_uiContext: UIContext): FrameNode | null {
    if (this.rootNode !== null) {
      return this.rootNode.getFrameNode();
    }
    return null;
  }

  initWeb(url: string, uiContext: UIContext, control: WebviewController) {
    if (this.rootNode != null) {
      return;
    }
    this.rootNode = new BuilderNode(uiContext);
    this.rootNode.build(wrap, { url: url, controller: control });
  }

  removeNode() {
    this.rootNode?.dispose();
  }
}

let nodeMap: Map<string, MyNodeController | undefined> = new Map();

let controllerMap: Map<string, WebviewController | undefined> = new Map();

export const createNWeb = (url: string, uiContext: UIContext) => {
  let baseNode = new MyNodeController();
  let controller = new webview.WebviewController();
  baseNode.initWeb(url, uiContext, controller);
  controllerMap.set(url, controller)
  nodeMap.set(url, baseNode);
}

export const getNWeb = (url: string): MyNodeController | undefined => {
  return nodeMap.get(url);
}

export const destroyWeb = () => {
  nodeMap.forEach((nodeController: MyNodeController | undefined) => {
    nodeController?.removeNode();
  });
  nodeMap.clear();
  controllerMap.clear();
}