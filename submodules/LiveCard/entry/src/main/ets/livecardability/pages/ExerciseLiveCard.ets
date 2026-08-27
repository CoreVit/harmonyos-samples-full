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

import { formBindingData, formInfo, formProvider } from '@kit.FormKit';
import { ColorConstants } from '../../common/ColorConstants';
import { CELEBRATE_IMAGES, ExerciseState, STRETCHING_IMAGES } from '../../model/exercise/ExerciseCardConstant';
import { Logger } from '../../utils/Logger';
import { BorderRadius } from '../../common/CommonConstants';

const TAG = 'ExerciseLiveCard';

@Entry({ useSharedStorage: true })
@Component
struct ExerciseLiveCard {
  @LocalStorageProp('formRect') rect?: formInfo.Rect = undefined;
  @LocalStorageProp('borderRadius') radius: number = 0;
  @LocalStorageProp('exerciseState') @Watch('stateChange') currentState: number = ExerciseState.NOT_STARTED;
  @LocalStorageProp('formId') formId: string = '';
  private targetCalories: number = 300;
  @State calories: number = 0;
  @State progressWidth: number = 0;
  private caloriesTimer: number = -1;
  @State celebrateImages: ImageFrameInfo[] = CELEBRATE_IMAGES;
  @State currentImagesIndex: number = 0;
  private imageSyncTimer: number = -1;
  @State exerciseImages: ImageFrameInfo[] = STRETCHING_IMAGES;
  @State currentImages: ImageFrameInfo[] = [];
  private progressBarWidth: number = 100;

  @State imageScale: number = 0.8;
  @State imagesOffsetY: number = 0;
  private timeoutTimer: number = -1;
  private minScale: number = 0.8;
  private maxScale: number = 1.0;

  aboutToAppear(): void {
    this.initImages();
    this.updateScale();
    this.imageScale = this.minScale;
    if (this.currentState === ExerciseState.COMPLETED) {
      this.sendCompletedMessage();
    }
  }

  stateChange(): void {
    this.initImages();
    this.updateScale();
  }

  updateScale(): void {
    if (this.currentState === ExerciseState.COMPLETED) {
      this.minScale = 0.7;
      this.maxScale = 0.9;
    } else {
      this.minScale = 0.8;
      this.maxScale = 1.0;
    }
  }

  initImages(): void {
    switch (this.currentState) {
      case ExerciseState.IN_PROGRESS:
      case ExerciseState.NOT_STARTED:
        this.currentImages = this.exerciseImages;
        return;
      case ExerciseState.COMPLETED:
        this.currentImages = this.celebrateImages;
        return;
    }
  }

  aboutToDisappear(): void {
    this.stopImageSync();
    this.stopCaloriesAnimation();
    this.stopCompletedMessage();
  }

  startCaloriesAnimation(): void {
    this.stopCaloriesAnimation();
    this.calories = 0;
    this.progressWidth = 0;

    let steps = this.targetCalories;
    let duration = 1500;
    let stepValue = this.targetCalories / steps;
    let interval = duration / steps;

    this.caloriesTimer = setInterval(() => {
      this.calories += stepValue;
      this.progressWidth = (this.calories / this.targetCalories) * this.progressBarWidth;

      if (this.calories >= this.targetCalories) {
        this.calories = this.targetCalories;
        this.progressWidth = this.progressBarWidth;
        this.stopCaloriesAnimation();
      }
    }, interval);
  }

  stopCaloriesAnimation(): void {
    if (this.caloriesTimer !== -1) {
      clearInterval(this.caloriesTimer);
      this.caloriesTimer = -1;
    }
  }

  sendCompletedMessage(): void {
    this.timeoutTimer = setTimeout(() => {
      let formMsg: formBindingData.FormBindingData = formBindingData.createFormBindingData({
        calories: this.targetCalories
      });
      formProvider.updateForm(this.formId, formMsg).catch((err: BusinessError) => {
        Logger.error(TAG, `updateForm error ${err.code} ${err.message}`);
      });
    }, 1000);
  }

  stopCompletedMessage(): void {
    if (this.timeoutTimer !== -1) {
      clearTimeout(this.timeoutTimer);
      this.timeoutTimer = -1;
    }
  }

  startImage(): void {
    this.getUIContext().keyframeAnimateTo({
      iterations: 1,
      expectedFrameRateRange: {
        min: 10,
        max: 120,
        expected: 60,
      },
      onFinish: (() => {
        formProvider.cancelOverflow(this.formId).catch((err: BusinessError) => {
          Logger.error(TAG, `cancelOverflow error ${err.code} ${err.message}`);
        });
      })
    }, [
      {
        duration: 150,
        event: () => {
          this.imageScale = this.maxScale;
          this.imagesOffsetY = -5;
        }
      },
      {
        duration: 3000,
        event: () => {
          this.startImageSync();
        }
      },
      {
        duration: 200,
        event: () => {
          this.imageScale = this.minScale;
          this.imagesOffsetY = 0;
        }
      }
    ])
  }

  startImageSync(): void {
    this.stopImageSync();
    let totalFrames = this.currentImages.length;
    if (totalFrames <= 1) {
      return;
    }
    let duration = 3000 / totalFrames;
    this.imageSyncTimer = setInterval(() => {
      if (this.currentImagesIndex === totalFrames - 1) {
        this.stopImageSync();
      } else {
        this.currentImagesIndex = (this.currentImagesIndex + 1) % totalFrames;
      }
    }, duration);
  }

  stopImageSync(): void {
    if (this.imageSyncTimer !== -1) {
      clearInterval(this.imageSyncTimer);
      this.imageSyncTimer = -1;
    }
  }

  needShowGif(): boolean {
    return this.currentState === ExerciseState.COMPLETED && this.currentImagesIndex > this.currentImages.length - 3;
  }

  build() {
    Stack() {
      Image($rawfile('exercise/background.png'))
        .objectFit(ImageFit.Cover)
        .borderRadius(this.radius)
        .clip(true)
        .width(this.rect?.width)
        .height(this.rect?.height);
      Image($rawfile('exercise/animate/cheer_overflow.gif'))
        .visibility(this.needShowGif() ? Visibility.Visible : Visibility.Hidden)
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
        .scale({
          x: this.imageScale,
          y: this.imageScale
        })
        .offset({
          y: `${this.imagesOffsetY}%`
        });
      if (this.currentImages.length > 0) {
        Image(this.currentImages[this.currentImagesIndex].src)
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Contain)
          .scale({
            x: this.imageScale,
            y: this.imageScale
          })
          .offset({
            y: `${this.imagesOffsetY}%`
          })
          .onAppear(() => {
            this.startImage();
            if (this.currentState === ExerciseState.COMPLETED) {
              this.startCaloriesAnimation();
            }
          });
      }
      RelativeContainer() {
        if (this.currentState !== ExerciseState.COMPLETED) {
          Column() {
            Row() {
              SymbolGlyph($r('sys.symbol.figure_run'))
                .fontSize(16)
                .fontColor([ColorConstants.EXERCISE_ORANGE]);
              Text(this.currentState === ExerciseState.NOT_STARTED ? $r('app.string.exercise_start_button') :
                $r('app.string.exercise_end_button'))
                .fontColor(ColorConstants.EXERCISE_ORANGE)
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .lineHeight(16)
                .margin({ left: 10 });
            }
            .justifyContent(FlexAlign.Center)
            .padding({
              top: 8,
              bottom: 8,
            })
            .backgroundColor(0xBFFFFFFF)
            .borderRadius(BorderRadius.BUTTON)
            .width('100%')
          }
          .padding({
            left: 16,
            right:16,
            bottom: 14
          })
          .alignRules({
            left: { anchor: '__container__', align: HorizontalAlign.Start },
            bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
          });
        } else {
          Column() {
            Column() {
              Row() {
                Text() {
                  Span(`${Math.round(this.calories)}`)
                    .fontWeight(FontWeight.Bold)
                    .fontSize(18);
                  Span($r('app.string.exercise_unit_kcal'))
                    .fontWeight(FontWeight.Normal)
                    .fontSize(10);
                }
                .fontColor(Color.White);
              };

              Row() {
                SymbolGlyph($r('sys.symbol.flame_fill_1'))
                  .fontSize(14)
                  .fontColor([0xf64b29]);
                Stack({ alignContent: Alignment.Start }) {
                  Row()
                    .height(14)
                    .width(this.progressBarWidth)
                    .borderRadius(80)
                    .linearGradient({
                      direction: GradientDirection.Bottom,
                      colors: [[0xfbe2da, 0.0], [0xfef0ec, 0.5], [0xfbe2da, 1.0]]
                    });
                  Row()
                    .height(14)
                    .width(this.progressWidth)
                    .borderRadius(80)
                    .backgroundColor(0xf64b29);
                }
                .margin({ left: '10px' });
              };
            }.alignItems(HorizontalAlign.Start);
          }
          .alignItems(HorizontalAlign.Center)
          .padding({
            left: 16,
            right:16,
            bottom: 14
          })
          .width('100%')
          .alignRules({
            left: { anchor: '__container__', align: HorizontalAlign.Start },
            bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
          });
        }
      }
      .borderRadius(this.radius)
      .clip(true)
      .width(this.rect?.width)
      .height(this.rect?.height);
    }
    .onClick(() => {
      formProvider.cancelOverflow(this.formId).catch(() => {
        Logger.error(TAG, `cancelOverflow error`);
      });
    })
    .width('100%')
    .height('100%');
  }
}