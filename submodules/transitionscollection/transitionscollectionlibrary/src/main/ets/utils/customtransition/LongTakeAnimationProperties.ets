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

import { ComponentAttrUtils, RectInfoInPx } from '../commonutils/ComponentAttrUtils';
import { CardUtil } from '../commonutils/CardUtil';
import { CustomTransition } from './CustomNavigationUtils';
import { BusinessError } from '@kit.BasicServicesKit';
import CommonConstants from '../../common/CommonConstants';
import Logger from '../Logger';

const TAG: string = '[LongTakeAnimationProperties]';

// Encapsulate the custom mirror transition animation, so that if other interfaces also need to customize a mirror
// transition, they can be reused directly and reduce the workload.
@Observed
export class LongTakeAnimationProperties {
  public navDestinationBgColor: ResourceColor = CommonConstants.INIT_OVERLAY_COLOR;
  public snapShotOpacity: number = 1;
  public postPageOpacity: number = 0;
  public translateX: number = 0;
  public translateY: number = 0;
  public scaleValue: number = 1;
  public clipWidth: Dimension = '100%';
  public clipHeight: Dimension = '100%';
  public radius: number = 16;
  public positionXValue: number = 0;
  public positionYValue: number = 0;
  public snapShotSize: SizeOptions = { width: '100%', height: '100%' };
  public snapShotPositionX: number = 0;
  public snapShotPositionY: number = 0;
  private animationCount: number = 0;
  private initScale: number = 1;
  private initTranslateX: number = 0;
  private initTranslateY: number = 0;
  private initClipWidth: Dimension = 0;
  private initClipHeight: Dimension = 0;
  private initPositionValueX: number = 0;
  private initPositionValueY: number = 0;
  private cardItemInfoPx: RectInfoInPx = new RectInfoInPx();
  private recoverPrePage: () => void = () => {
  };
  private clickedCardId: string = '';
  private uiContext: UIContext = AppStorage.get<UIContext>(CommonConstants.KEY_PREFIX_SYSTEM_UICONTEXT) as UIContext;
  private statusBarHeight = AppStorage.get(CommonConstants.KEY_PREFIX_STATUS_BAR_HEIGHT) as number;
  private screenWidth = AppStorage.get(CommonConstants.KEY_PREFIX_NAVIGATOR_SCREEN_WIDTH) as number;

  public init(prePageCardId: string, prePageOnFinish: () => void): void {
    this.clickedCardId = prePageCardId;
    this.recoverPrePage = prePageOnFinish;
    try {
      this.cardItemInfoPx = ComponentAttrUtils.getRectInfoById(this.uiContext, prePageCardId);
    } catch (error) {
      Logger.error(TAG,
        `Get ui context fail. Cause: ${(error as BusinessError).message}`);
    }
  }

  private initParams(): void {
    try {
      if (!this.uiContext) {
        Logger.error(TAG, 'uiContext is null');
        return;
      }

      if (!this.cardItemInfoPx || this.cardItemInfoPx.width <= 0 || this.cardItemInfoPx.height <= 0) {
        Logger.error(TAG, 'cardItemInfoPx is invalid');
        return;
      }

      let postNode = this.uiContext.getFrameNodeById(CardUtil.getPostPageImageId(this.clickedCardId));
      if (!postNode) {
        Logger.error(TAG, 'postNode is null');
        return;
      }

      let postNodePositionXVp: number = postNode.getPositionToWindowWithTransform().x;
      let postNodePositionYVp: number = postNode.getPositionToWindowWithTransform().y;
      let postNodeWidthPx: number = postNode.getMeasuredSize().width;
      let postNodeHeightPx: number = postNode.getMeasuredSize().height;

      if (postNodeWidthPx <= 0 || postNodeHeightPx <= 0) {
        Logger.error(TAG, 'postNode size is invalid');
        return;
      }

      Logger.info(TAG, 'the size is ' + postNodeWidthPx + ' and ' +
        postNodeHeightPx + ' and ' + this.uiContext.vp2px(postNodePositionXVp) + ' and ' +
      this.uiContext.vp2px(postNodePositionYVp));

      this.initPositionValueX = -postNodePositionXVp;
      this.initPositionValueY = -postNodePositionYVp;
      this.snapShotPositionY = postNodePositionYVp - this.statusBarHeight;
      this.snapShotPositionX = postNodePositionXVp;

      // First calculate the ratio of the width and height of the card to the width and height of the window.
      this.initScale = this.cardItemInfoPx.width / postNodeWidthPx;
      if (!CardUtil.isLargeSize()) {
        this.initTranslateX =
          this.uiContext.px2vp(this.cardItemInfoPx.left + this.cardItemInfoPx.width / 2) - this.screenWidth / 2;
        this.initClipWidth = '100%';
        this.initClipHeight = this.uiContext.px2vp((this.cardItemInfoPx.height) / this.initScale);
        this.snapShotSize = { width: '100%' };
        this.initTranslateY = this.uiContext.px2vp(this.cardItemInfoPx.top -
          ((this.uiContext.vp2px(this.initClipHeight) - this.uiContext.vp2px(this.initClipHeight) * this.initScale) /
            2));
      } else {
        this.initClipHeight = this.uiContext.px2vp(this.cardItemInfoPx.height / this.initScale);
        this.initTranslateY = this.uiContext.px2vp(this.cardItemInfoPx.top -
          ((this.uiContext.vp2px(this.initClipHeight) - this.uiContext.vp2px(this.initClipHeight) * this.initScale) /
            2));
        this.initClipWidth = this.uiContext.px2vp((this.cardItemInfoPx.width) / this.initScale);
        this.snapShotSize = { width: this.uiContext.px2vp(postNodeWidthPx) };
        this.initTranslateX =
          this.uiContext.px2vp(this.cardItemInfoPx.left + this.cardItemInfoPx.width / 2) - this.screenWidth / 2;
      }
      Logger.info(TAG,
        'the value is initScale: ' + this.initScale + ' initTranslateX ' +
        this.initTranslateX + ' initClipWidth ' + this.initClipWidth + ' initClipHeight ' + this.initClipHeight +
          ' initTranslateY ' + this.initTranslateY + ' initPositionValue ' + this.initPositionValueY);
    } catch (error) {
      Logger.error(TAG,
        `Init params fail. Cause: ${(error as BusinessError).message}`);
    }
  }

  public doAnimation(transitionProxy: NavigationTransitionProxy): void {
    if (CustomTransition.getInstance().operation === NavigationOperation.PUSH) {
      this.initParams();
      this.doEnterAnimation(transitionProxy);
    } else if (CustomTransition.getInstance().operation === NavigationOperation.POP) {
      this.doBackAnimation(transitionProxy);
    }
  }

  public doEnterAnimation(transitionProxy: NavigationTransitionProxy): void {
    this.scaleValue = this.initScale;
    this.translateX = this.initTranslateX;
    this.clipWidth = this.initClipWidth;
    this.clipHeight = this.initClipHeight;
    this.translateY = this.initTranslateY;
    this.positionYValue = this.initPositionValueY;
    this.positionXValue = this.initPositionValueX;

    let animationCount = ++this.animationCount;

    this.uiContext.animateTo({
      duration: 350,
      curve: Curve.EaseInOut,
      onFinish: () => {
        if (animationCount === this.animationCount) {
          this.radius = 0;
        }
        transitionProxy.finishTransition();
      }
    }, () => {
      this.scaleValue = 1.0;
      this.translateX = 0;
      this.translateY = 0;
      this.clipWidth = '100%';
      this.clipHeight = '100%';
      this.positionYValue = 0;
      this.positionXValue = 0;
      this.radius = 34;
      this.navDestinationBgColor = CommonConstants.FINAL_OVERLAY_COLOR;
    });

    this.uiContext.animateTo({
      delay: 50,
      duration: 100,
      curve: Curve.Sharp
    }, () => {
      this.snapShotOpacity = 0;
    });

    this.uiContext.animateTo({
      duration: 100,
      curve: Curve.Sharp
    }, () => {
      this.postPageOpacity = 1.0;
    });
  }

  public doBackAnimation(transitionProxy?: NavigationTransitionProxy): void {
    ++this.animationCount;

    this.uiContext.animateTo({
      duration: 350,
      curve: Curve.EaseInOut,
      onFinish: () => {
        this.recoverPrePage();
        transitionProxy?.finishTransition()
      }
    }, () => {
      this.scaleValue = this.initScale;
      this.translateX = this.initTranslateX;
      this.clipWidth = this.initClipWidth;
      this.clipHeight = this.initClipHeight;
      this.translateY = this.initTranslateY;
      this.radius = 16;
      this.positionXValue = this.initPositionValueX;
      this.positionYValue = this.initPositionValueY;
      this.navDestinationBgColor = CommonConstants.INIT_OVERLAY_COLOR;
    });

    this.uiContext.animateTo({
      duration: 50,
      delay: 150,
      curve: Curve.Friction
    }, () => {
      this.snapShotOpacity = 1;
    });

    this.uiContext.animateTo({
      duration: 50,
      delay: 200,
      curve: Curve.Friction
    }, () => {
      this.postPageOpacity = 0;
    });
  }

  // When you do not go through the custom transition, you need to set the state to the normal final state.
  public setFinalStatus(): void {
    this.navDestinationBgColor = CommonConstants.INIT_OVERLAY_COLOR;
    this.clipWidth = '100%';
    this.clipHeight = '100%';
    this.snapShotOpacity = 0;
    this.postPageOpacity = 1;
    this.radius = 0;
  }
}