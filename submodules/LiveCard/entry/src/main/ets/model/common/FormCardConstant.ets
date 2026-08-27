/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// [Start card_communication_constant]
export const ENTRY_ABILITY = 'LiveCardAbility';
export const ENTRY_FORM_ABILITY = 'EntryFormAbility';

export enum FormCarAction {
  CALL = 'call',
  ROUTER = 'router',
  MESSAGE = 'message'
}

export enum CardActionType {
  PLAY_ACTION = 'playAction',
  COLLECT_ACTION = 'collectAction',
  REQUEST_UPDATE = 'requestUpdate',
  EXERCISE_ACTION = 'exerciseAction',
}
// [End card_communication_constant]

export enum PlayActionType {
  PAUSE = '0',
  PLAY = '1',
  PREVIOUS = '2',
  NEXT = '3',
}

export enum CollectAction {
  COLLECTED = '1',
  UNCOLLECTED = '0',
}

export class LiveCardScale {
  public static readonly DELIVERY_WIDTH = 1.45;
  public static readonly DELIVERY_HEIGHT = 1.45;
  public static readonly EXERCISE_WIDTH = 1.4;
  public static readonly EXERCISE_HEIGHT = 1.4;
  public static readonly MUSIC_WIDTH = 1.1;
  public static readonly MUSIC_HEIGHT = 1.5;
  public static readonly SLEEP_WIDTH = 1.25;
  public static readonly SLEEP_HEIGHT = 1.5;
}

export const LIVE_CARD_DURATION: number = 3500;
