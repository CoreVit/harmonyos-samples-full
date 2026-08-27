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

import { LIVE_CARD_RATIO } from '../common/CommonConstants';
import { CardActionType, ENTRY_ABILITY, FormCarAction, PlayActionType,
  ENTRY_FORM_ABILITY,
  CollectAction,
  LIVE_CARD_DURATION
} from '../model/common/FormCardConstant';

// [Start card_action_utils]
class ActionUtils {
  // [StartExclude card_action_utils]
  public playByAction(component: object, type: PlayActionType, formId: string): void {
    postCardAction(component, {
      action: FormCarAction.CALL,
      abilityName: ENTRY_ABILITY,
      params: {
        method: 'cardAction',
        actionType: CardActionType.PLAY_ACTION,
        playActionType: type,
        formId: formId,
      },
    });
  }

  public updateControlCardAction(component: object, formId: string): void {
    postCardAction(component, {
      action: FormCarAction.CALL,
      abilityName: ENTRY_ABILITY,
      params: {
        method: 'cardAction',
        actionType: CardActionType.REQUEST_UPDATE,
        formId: formId,
      },
    });
  }

  public collectAction(component: object, type: CollectAction, formId: string, songId: string): void {
    if (type && songId !== '') {
      postCardAction(component, {
        action: FormCarAction.CALL,
        abilityName: ENTRY_ABILITY,
        params: {
          method: 'cardAction',
          actionType: CardActionType.COLLECT_ACTION,
          collectActionType: type,
          formId: formId,
          songId: songId,
        },
      });
    }
  }

  public updateRequestOverflowState(component: object, state: boolean): void {
    postCardAction(component, {
      action: FormCarAction.MESSAGE,
      abilityName: ENTRY_FORM_ABILITY,
      params: {
        message: 'updateRequestOverflowState',
        state: state
      },
    });
  }
  // [EndExclude card_action_utils]

  // [Start card_jump_page]
  public jumpAppPage(component: object, pageName: string): void {
    if (pageName !== '') {
      postCardAction(component, {
        action: FormCarAction.ROUTER,
        abilityName: ENTRY_ABILITY,
        params: {
          routeName: pageName,
        },
      });
    }
  }
  // [End card_jump_page]

  // [Start card_request_overflow]
  public requestOverFlow(component: object, widthRatio: number, heightRatio: number, duration: number): void {
    if (widthRatio <= LIVE_CARD_RATIO && heightRatio <= LIVE_CARD_RATIO && duration <= LIVE_CARD_DURATION) {
      postCardAction(component, {
        action: FormCarAction.MESSAGE,
        abilityName: ENTRY_FORM_ABILITY,
        params: {
          message: 'requestOverflow',
          widthRatio: widthRatio,
          heightRatio: heightRatio,
          duration: duration
        },
      });
    }
  }
  // [End card_request_overflow]

  // [StartExclude card_action_utils]
  public requestOverFlowWithAction(component: object, widthRatio: number, heightRatio: number,
    duration: number, triggerAction: string, songId?: string): void {
    postCardAction(component, {
      action: FormCarAction.MESSAGE,
      abilityName: ENTRY_FORM_ABILITY,
      params: {
        message: 'requestOverflow',
        widthRatio: widthRatio,
        heightRatio: heightRatio,
        duration: duration,
        triggerAction: triggerAction,
        songId: songId || ''
      },
    });
  }
  // [EndExclude card_action_utils]
}

export default new ActionUtils();
// [End card_action_utils]