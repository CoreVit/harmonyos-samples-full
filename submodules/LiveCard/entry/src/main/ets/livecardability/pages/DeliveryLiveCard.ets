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

import { formInfo } from '@kit.FormKit';
import { RectShape } from '@kit.ArkUI';
import { UIExtensionContentSession } from '@kit.AbilityKit';
import { GyroscopeUtil, GyroscopeData } from '../../utils/GyroscopeUtil';
import { Logger } from '../../utils/Logger';
import { formProvider } from '@kit.FormKit';
import { DeliveryTextView } from '../../view/delivery/DeliveryTextView';

const TAG = 'DeliveryLiveCard';

// [Start delivery_livecard_full]
// [Start delivery_livecard_page]
@Entry({ useSharedStorage: true })
@Component
struct DeliveryLiveCard {
  @LocalStorageProp('formRect') rect?: formInfo.Rect = undefined;
  @LocalStorageProp('borderRadius') radius: number = 0;
  // [StartExclude delivery_livecard_page]
  @State gyroTranslateX: number = 0;
  @State gyroTranslateY: number = 0;
  @State gyroTranslateZ: number = 0;
  @State normTranslateX: number = 0;
  // [EndExclude delivery_livecard_page]
  @State ballSize: number = 0.3;
  @State ballTranslateX: number = 150;
  @State ballY: number = 0;
  // [StartExclude delivery_livecard_page]
  @State isGyroscopeOn: boolean = true;
  // [StartExclude delivery_livecard_full]
  @LocalStorageProp('session') session?: UIExtensionContentSession = undefined;
  // [EndExclude delivery_livecard_full]
  @LocalStorageProp('formId') formId: string = '';
  private accumulatedY: number = 0;
  private readonly threshold: number = 0.15;
  private lastUpdateTime: number = 0;
  private readonly updateInterval: number = 16;
  private targetBallX: number = 0;
  private targetBallSize: number = 1;
  @State sensitivity: number = 0.05;
  private readonly maxGyroValue: number = 2.0;
  private readonly img: Resource = $rawfile('delivery/fuzzball.webp');
  private readonly driveAnimeDuration1: number = 800; // ms
  private readonly driveAnimeDuration2: number = 500; // ms

  // [Start delivery_gyro_appear]
  aboutToDisappear(): void {
    GyroscopeUtil.unsubscribe();
  }
  // [End delivery_gyro_appear]

  // [Start delivery_subscribe_gyroscope]
  subscribeGyroscope() {
    GyroscopeUtil.subscribe((data: GyroscopeData) => {
      this.gyroTranslateX = Math.max(-this.maxGyroValue, Math.min(this.maxGyroValue, data.y));
      this.gyroTranslateY = Math.max(-this.maxGyroValue, Math.min(this.maxGyroValue, data.x));
      this.gyroTranslateZ = Math.max(-this.maxGyroValue, Math.min(this.maxGyroValue, data.z));
      this.gyroMethod();
    });
  }
  // [End delivery_subscribe_gyroscope]

  // [Start delivery_ball_position]
  private updateBallPosition(): void {
    const normalizedValue = this.accumulatedY;
    // [StartExclude delivery_ball_position]
    // [StartExclude delivery_livecard_full]
    Logger.info(TAG, `updateBallPosition: normalizedValue=${normalizedValue.toFixed(4)}, threshold=${this.threshold}`);
    // [EndExclude delivery_livecard_full]
    // [EndExclude delivery_ball_position]

    if (normalizedValue > this.threshold) {
      const t = Math.min((normalizedValue - this.threshold) / (1 - this.threshold), 1);
      this.targetBallX = t * 100; // towards right
      this.targetBallSize = 1 - t * 0.35;
      // [StartExclude delivery_ball_position]
      // [StartExclude delivery_livecard_full]
      Logger.info(TAG, `right direction: t=${t.toFixed(4)}, targetBallX=${this.targetBallX.toFixed(2)}, ` +
        `targetBallSize=${this.targetBallSize.toFixed(4)}`);
      // [EndExclude delivery_livecard_full]
      // [EndExclude delivery_ball_position]
    } else if (normalizedValue < -this.threshold) {
      const t = Math.min((-normalizedValue - this.threshold) / (1 - this.threshold), 1);
      this.targetBallX = -t * 50; // towards left
      this.targetBallSize = 1 + t * 0.3;
      // [StartExclude delivery_ball_position]
      // [StartExclude delivery_livecard_full]
      Logger.info(TAG, `left direction: t=${t.toFixed(4)}, targetBallX=${this.targetBallX.toFixed(2)}, ` +
        `targetBallSize=${this.targetBallSize.toFixed(4)}`);
      // [EndExclude delivery_livecard_full]
      // [EndExclude delivery_ball_position]
    } else {
      this.targetBallX = 0;
      this.targetBallSize = 1;
      // [StartExclude delivery_ball_position]
      // [StartExclude delivery_livecard_full]
      Logger.info(TAG, 'center: targetBallX=0, targetBallSize=1');
      // [EndExclude delivery_livecard_full]
      // [EndExclude delivery_ball_position]
    }
    // [StartExclude delivery_ball_position]
    // [StartExclude delivery_livecard_full]
    Logger.info(TAG, `current: ballX=${this.ballTranslateX.toFixed(2)}, ballSize=${this.ballSize.toFixed(4)}, ` +
      `target: ballX=${this.targetBallX.toFixed(2)}, ballSize=${this.targetBallSize.toFixed(4)}`);
    // [EndExclude delivery_livecard_full]
    // [EndExclude delivery_ball_position]
  }
  // [End delivery_ball_position]

  // [Start delivery_animate_to]
  private animateBall(duration: number = 100): void {
    if (duration > 0) {
      this.getUIContext().animateTo({
        duration: duration,
        curve: Curve.Linear
      }, () => {
        this.ballTranslateX = this.targetBallX;
        this.ballSize = this.targetBallSize;
      });
    } else {
      this.ballTranslateX = this.targetBallX;
      this.ballSize = this.targetBallSize;
    }
  }
  // [End delivery_animate_to]


  private startDriveIn(): void {
    Logger.info(TAG, `startDriveIn`);
    this.getUIContext().animateTo({
      duration: this.driveAnimeDuration2,
      curve: Curve.EaseOut
    }, () => {
      this.ballTranslateX = 0;
      this.ballSize = 1;
    });
  }
  // [EndExclude delivery_livecard_page]
  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Image($rawfile('delivery/background.png'))
        .borderRadius(this.radius)
        .width(this.rect?.width || 0)
        .height(this.rect?.height || 0)
        .margin({
          top: this.rect?.top,
          left: this.rect?.left
        });
      // [Start delivery_ball_transform]
      Stack() {
        Image(this.img)
          .width('100%')
          .height('100%')
          .scale({
            x: this.ballSize,
            y: this.ballSize
          })
          .translate({
            x: this.ballTranslateX,
            y: this.ballY
          })
          // [StartExclude delivery_livecard_page]
          .onAppear(() => {
            Logger.info(TAG, `Fuzzball start driving.`);
            this.getUIContext().keyframeAnimateTo({
              delay: 0,
              iterations: 1,
              expectedFrameRateRange: {min: 30, max: 120, expected: 60},
              onFinish: () => {
                this.subscribeGyroscope();
                this.startDriveIn();
              }
            },
            [
              { // drive out
                duration: this.driveAnimeDuration1,
                curve: Curve.EaseInOut,
                event: () => {
                  this.ballTranslateX = -((this.rect?.width ?? 400) * 0.2);
                  this.ballSize = 1.5;
                }
              },
              {
                duration: 300,
                curve: Curve.Friction,
                event: () => {}
              }
            ])
          })
          // [EndExclude delivery_livecard_page]
      }
      // [End delivery_ball_transform]
      // [StartExclude delivery_livecard_page]
      .borderRadius(this.radius)
      .clipShape(this.rect ? new RectShape({
        width: this.rect.width + this.rect.left,
        height: this.rect.height * 1.5
      }) : undefined)
      .width('100%')
      .height('100%');

      Column() {
        DeliveryTextView(this.rect?.width || 0, this.rect?.height || 0);
      }
        .margin({
          top: this.rect?.top || 0,
          left: this.rect?.left || 0
        });
      // [EndExclude delivery_livecard_page]
    }
    .onClick(() => {
      formProvider.cancelOverflow(this.formId).catch(() => {
        Logger.error(TAG, `cancelOverflow error`);
      });
    })
    .width('100%')
    .height('100%');
  }

  // [StartExclude delivery_livecard_page]
  private gyroMethod() {
    const clampedY = this.gyroTranslateX;
    const clampedZ = this.gyroTranslateZ;

    this.accumulatedY += (clampedY - clampedZ) * this.sensitivity;
    this.accumulatedY = Math.max(-1, Math.min(1, this.accumulatedY));
    // [StartExclude delivery_gyro_appear]
    // [StartExclude delivery_livecard_full]
    Logger.info(TAG, `accumulatedY: ${this.accumulatedY.toFixed(4)}`);
    // [EndExclude delivery_livecard_full]
    // [EndExclude delivery_gyro_appear]

    const now = Date.now();
    if (now - this.lastUpdateTime < this.updateInterval) {
      return;
    }
    this.lastUpdateTime = now;
    // [StartExclude delivery_gyro_appear]
    // [StartExclude delivery_livecard_full]
    Logger.info(TAG, 'trigger updateBallPosition');
    // [EndExclude delivery_livecard_full]
    // [EndExclude delivery_gyro_appear]
    this.updateBallPosition();
    this.animateBall(0);
  }
  // [EndExclude delivery_livecard_page]
}
// [End delivery_livecard_page]
// [End delivery_livecard_full]