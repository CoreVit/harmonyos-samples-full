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

export const enum LyricScrollEffect {
  Line,
  LetterGradient,
  LetterScaleGradient,
  LetterStar,
}

export const enum LyricTopPosition {
  Top,
  Middle,
}

export class LyricFile {
  public static readonly KRC: string = '.krc';
  public static readonly LRC: string = '.lrc';
}

export class Rectangle {
  private left: number;
  private top: number;
  private right: number;
  private bottom: number;

  constructor(left: number, top: number, right: number, bottom: number) {
    this.left = left;
    this.top = top;
    this.right = right;
    this.bottom = bottom;
  }

  public isIn(x: number, y: number): boolean {
    return x >= this.left && x <= this.right && y >= this.top && y <= this.bottom;
  }

  public toString(): string {
    return `[Rectangle] = ${this.left}, ${this.top}, ${this.right},${this.bottom}`;
  }
}