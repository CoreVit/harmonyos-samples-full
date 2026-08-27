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

export const CELEBRATE_IMAGES: ImageFrameInfo[] = [
  { src: $rawfile('exercise/animate/cheer_frame_03.png') },
  { src: $rawfile('exercise/animate/cheer_frame_04.png') },
  { src: $rawfile('exercise/animate/cheer_frame_05.png') },
  { src: $rawfile('exercise/animate/cheer_frame_06.png') },
  { src: $rawfile('exercise/animate/cheer_frame_07.png') },
  { src: $rawfile('exercise/animate/cheer_frame_08.png') },
  { src: $rawfile('exercise/animate/cheer_frame_09.png') },
  { src: $rawfile('exercise/animate/cheer_frame_10.png') },
  { src: $rawfile('exercise/animate/cheer_frame_11.png') },
  { src: $rawfile('exercise/animate/cheer_frame_12.png') },
  { src: $rawfile('exercise/animate/cheer_frame_13.png') },
  { src: $rawfile('exercise/animate/cheer_frame_14.png') },
  { src: $rawfile('exercise/animate/cheer_frame_15.png') },
  { src: $rawfile('exercise/animate/cheer_frame_16.png') },
  { src: $rawfile('exercise/animate/cheer_frame_17.png') },
  { src: $rawfile('exercise/animate/cheer_frame_18.png') },
  { src: $rawfile('exercise/animate/cheer_frame_19-20.png') },
  { src: $rawfile('exercise/animate/cheer_frame_19-20.png') },
];

export const STRETCHING_IMAGES: ImageFrameInfo[] = [
  { src: $rawfile('exercise/animate/exercise_overflow_frame_02.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_03.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_04.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_05.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_06.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_07.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_08.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_09.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_10.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_11.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_12.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_13.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_14.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_15.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_16.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_17.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_18.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_19.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_20.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_21.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_22.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_23.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_24.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_25.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_26.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_27.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_28.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_29.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_30.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_31.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_32.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_33.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_34.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_35.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_36.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_37.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_38.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_39.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_40.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_41.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_42.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_43.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_44.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_45.png') },
  { src: $rawfile('exercise/animate/exercise_overflow_frame_46.png') },
];

export enum ExerciseState {
  NOT_STARTED = 0,
  IN_PROGRESS = 1,
  COMPLETED = 2
}

export enum ExerciseAction {
  START_EXERCISE = 'startExercise',
  END_EXERCISE = 'endExercise',
  RESET_EXERCISE = 'resetExercise'
}
