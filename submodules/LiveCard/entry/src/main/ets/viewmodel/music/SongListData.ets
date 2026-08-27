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

import { SongItem } from '../../model/music/SongItem';

const songTitlesArr: string[] = [
  'app.string.dream_it_possible',
  'app.string.china_is_promising',
];
const songSingersArr: string[] = [
  'app.string.Delacey',
  'app.string.ming_yi',
];

export function getSongListData(): SongItem[] {
  let songTitles: string[] = songTitlesArr;
  let songSingers: string[] = songSingersArr;
  return [
    {
      id: '1',
      title: songTitles[0],
      singer: songSingers[0],
      mark: '1',
      label: $r('app.media.ic_dream'),
      src: 'Delacey - Dream It Possible.mp3',
      lyric: 'lrcfiles/DreamItPossible.lrc',
      isCollected: false,
    },
    {
      id: '2',
      title: songTitles[1],
      singer: songSingers[1],
      mark: '2',
      label: $r('app.media.cover1'),
      src: 'boisterous.mp3',
      lyric: '',
      isCollected: false,
    }
  ];
}