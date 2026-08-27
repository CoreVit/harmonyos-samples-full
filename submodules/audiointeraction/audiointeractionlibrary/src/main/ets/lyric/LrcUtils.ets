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

import Logger from '../common/utils/Logger';
import { LrcEntry, Word } from './LrcEntry';

const TAG: string = '[LrcUtils]';

/**
 * KRC format lyrics.
 */
const krcLineRegex = new RegExp('\\[(\\d+),(\\d+)\\](.*)');
const krcWordRegex1 = new RegExp('<(\\d+),(\\d+),(\\d+)>([^<]*)', 'g');
const krcWordRegex2 = new RegExp('<(\\d+),(\\d+),(\\d+)>(.*)');

/**
 * Analysis of the lrc structure,
 * similar to the following: [00:21.98] prime embryo outlines the blue and white pen dark to light.
 *
 * @param text
 * @returns
 */
export function parseLrcLyric(text: string): Array<LrcEntry> {
  if (!text) {
    return [];
  }
  const LRC_TIME_REGEX = /\[(\d{2}):(\d{2})(?:\.(\d{2,3}))?\]/g;
  const LRC_LINE_REGEX = /(\[\d{2}:\d{2}(?:\.\d{2,3})?\])+/g;
  const lines = text.trim().split('\n');
  const lrcEntries: LrcEntry[] = [];

  for (const line of lines) {
    if (!line.trim()) {
      continue;
    }
    const timeMatches = Array.from(line.matchAll(LRC_TIME_REGEX));
    const lyricText = line.replace(LRC_LINE_REGEX, '').trim();
    if (timeMatches.length > 0 && lyricText) {
      for (const match of timeMatches) {
        const minutes = parseInt(match[1], 10);
        const seconds = parseInt(match[2], 10);
        const milliseconds = match[3] ?
          parseInt(match[3].padEnd(3, '0'), 10) : 0;
        const timeInMilliseconds = (minutes * 60 + seconds) * 1000 + milliseconds;
        lrcEntries.push({
          lineStartTime: timeInMilliseconds,
          lineDuration: 0,
          lineWords: lyricText,
          words: []
        });
      }
    }
  }
  if (lrcEntries.length > 0) {
    lrcEntries.sort((a, b) => a.lineStartTime - b.lineStartTime);
    for (let i = 0; i < lrcEntries.length; i++) {
      if (i === lrcEntries.length - 1) {
        lrcEntries[i].lineDuration = Number.MAX_SAFE_INTEGER;
      } else {
        lrcEntries[i].lineDuration =
          lrcEntries[i + 1].lineStartTime - lrcEntries[i].lineStartTime;
      }
    }
  } else {
    Logger.error(TAG, 'Failed to parse the lyrics.');
  }
  return lrcEntries;
}

/**
 * Resolve the lyrics of Cool Dog, similar to the following structure.
 * [494, 228] < 0, 38, 0 > for < 38, 38, 0 > song < 76, 38, 0 >:
 * < 114, 38, 0 > Zhou < 152, 38, 0 > Jie < 190, 38, 0 > L\n.
 *
 * @param lyricText
 * @returns
 */
export function parseKrcLyric(lyricText: string): LrcEntry[] {
  const lines: string[] = lyricText.split('\n');
  const lyricLines: LrcEntry[] = [];

  for (const line of lines) {
    const matches = line.match(krcLineRegex);
    if (matches) {
      const lineStartTime = Number.parseInt(matches[1]);
      const lineDuration = Number.parseInt(matches[2]);
      const lineWordsText = matches[3];
      const words: Word[] = [];
      const wordsMatches = lineWordsText.match(krcWordRegex1);
      let lineWords: string = '';
      if (wordsMatches) {
        for (const wordMatch of wordsMatches) {
          const wordMatches = wordMatch.match(krcWordRegex2);
          if (wordMatches) {
            const wordStartTime = Number.parseInt(wordMatches[1]);
            const wordDuration = Number.parseInt(wordMatches[2]);
            const wordText = wordMatches[4];
            lineWords += wordText;
            words.push({
              text: wordText,
              wordStartTime: wordStartTime,
              duration: wordDuration
            });
          }
        }
      }
      lyricLines.push({
        lineStartTime: lineStartTime,
        lineDuration: lineDuration,
        lineWords: lineWords,
        words: words
      });
    }
  }
  lyricLines.sort((a, b) => {
    return a.lineStartTime - b.lineStartTime;
  })
  return lyricLines;
}

/**
 * The angle is converted into radians.
 * Because the trigonometric function of Math needs to pass in the radian system instead of the angle value,
 * the angle needs to be converted into radians. Angle / 180 * π
 *
 * @param angle
 * @returns
 */
export function angleToRadian(angle: number): number {
  return angle * Math.PI / 180;
}