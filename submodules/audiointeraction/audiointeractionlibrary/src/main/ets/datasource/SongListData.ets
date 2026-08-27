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

import { SongItem } from '../songdatacontroller/SongData';

const songList: SongItem[] = [
  {
    id: 1,
    title: 'Dream It Possible',
    singer: 'Delacey',
    mark: $r('app.media.ic_vip'),
    label: $r('app.media.ic_dream'),
    src: 'Delacey - Dream It Possible.pcm',
    index: 0,
    lyric: 'lrcfiles/DreamItPossible.lrc',
    isDarkBackground: true
  },
  {
    id: 2,
    title: 'Dream It Possible',
    singer: 'Delacey',
    mark: $r('app.media.ic_vip'),
    label: $r('app.media.ic_dream'),
    src: 'Delacey - Dream It Possible.pcm',
    index: 1,
    lyric: 'lrcfiles/DreamItPossible.lrc',
    isDarkBackground: true
  },
  {
    id: 3,
    title: 'Dream It Possible',
    singer: 'Delacey',
    mark: $r('app.media.ic_vip'),
    label: $r('app.media.ic_dream'),
    src: 'Delacey - Dream It Possible.pcm',
    index: 2,
    lyric: 'lrcfiles/DreamItPossible.lrc',
    isDarkBackground: true
  }
]

export { songList }