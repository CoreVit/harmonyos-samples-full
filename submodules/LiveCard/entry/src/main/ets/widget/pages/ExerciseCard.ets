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

import ActionUtils from '../../utils/ActionUtils';
import {
  CardActionType,
  ENTRY_ABILITY,
  FormCarAction,
  LIVE_CARD_DURATION,
  LiveCardScale
} from '../../model/common/FormCardConstant';
import { ColorConstants } from '../../common/ColorConstants';
import { BorderRadius } from '../../common/CommonConstants';
import { ExerciseAction, ExerciseState } from '../../model/exercise/ExerciseCardConstant';

let storageUpdateCall = new LocalStorage();

@Entry(storageUpdateCall)
@Component
struct ExerciseCard {
  @LocalStorageProp('currentState') currentState: number = ExerciseState.NOT_STARTED;
  @LocalStorageProp('calories') @Watch('stateChange') calories: number = 0;
  private progressBarWidth: number = 100;
  @State imgScale: number = 0.8;

  stateChange() {
    if (this.calories === 0) {
      this.imgScale = 0.8;
    } else {
      this.imgScale = 0.7;
    }
  }

  build() {
    RelativeContainer() {
      Image(this.calories === 0 ? $rawfile('exercise/animate/exercise_overflow_frame_02.png') :
        $rawfile('exercise/animate/cheer_frame_19-20.png'))
        .width('140%')
        .height('140%')
        .offset({
          x: '-20%',
          y: '-20%'
        })
        .scale({
          x: this.imgScale,
          y: this.imgScale
        })
        .objectFit(ImageFit.Contain);
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
          .padding({ top: 8, bottom: 8 })
          .backgroundColor(0xBFFFFFFF)
          .borderRadius(BorderRadius.BUTTON)
          .width('100%');
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
                Span(`${this.calories}`)
                  .fontWeight(FontWeight.Bold)
                  .fontSize(18);
                Span($r('app.string.exercise_unit_kcal'))
                  .fontWeight(FontWeight.Normal)
                  .fontSize(12);
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
                  .width(this.calories / 300 * this.progressBarWidth)
                  .borderRadius(80)
                  .backgroundColor(0xf64b29);
              }
              .margin({ left: '10px' });
            };
          }
          .alignItems(HorizontalAlign.Start);
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
    .backgroundImage($rawfile('exercise/background.png'))
    .backgroundImageSize(ImageSize.Cover)
    .width('100%')
    .height('100%')
    .onClick(() => {
      switch (this.currentState) {
        case ExerciseState.NOT_STARTED: {
          this.currentState = ExerciseState.IN_PROGRESS;
          postCardAction(this, {
            action: FormCarAction.CALL,
            abilityName: ENTRY_ABILITY,
            params: {
              method: 'cardAction',
              actionType: CardActionType.EXERCISE_ACTION,
              exerciseAction: ExerciseAction.START_EXERCISE
            }
          });
          ActionUtils.requestOverFlow(this, LiveCardScale.EXERCISE_WIDTH,
            LiveCardScale.EXERCISE_HEIGHT, LIVE_CARD_DURATION);
          return;
        }
        case ExerciseState.IN_PROGRESS: {
          postCardAction(this, {
            action: FormCarAction.CALL,
            abilityName: ENTRY_ABILITY,
            params: {
              method: 'cardAction',
              actionType: CardActionType.EXERCISE_ACTION,
              exerciseAction: ExerciseAction.END_EXERCISE
            }
          });
          ActionUtils.requestOverFlow(this, LiveCardScale.EXERCISE_WIDTH,
            LiveCardScale.EXERCISE_HEIGHT, LIVE_CARD_DURATION);
          return;
        }
        case ExerciseState.COMPLETED: {
          ActionUtils.jumpAppPage(this, 'ExercisePage');
          postCardAction(this, {
            action: FormCarAction.CALL,
            abilityName: ENTRY_ABILITY,
            params: {
              method: 'cardAction',
              actionType: CardActionType.EXERCISE_ACTION,
              exerciseAction: ExerciseAction.RESET_EXERCISE
            }
          });
          return;
        }
      }
    });
  }
}