/*
 * Copyright (c) 2022-2025 Huawei Device Co., Ltd.
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

enum DialogError {
  ERR_TEMPLATE_WITHOUT = 'ERR_TEMPLATE_WITHOUT',
  ERR_TEMPLATE_ALREADY_EXIST = 'ERR_TEMPLATE_ALREADY_EXIST',
  ERR_TEMPLATE_TYPE_INCONSISTENCY = 'ERR_TEMPLATE_TYPE_INCONSISTENCY',
  PARAMETER_INCONSISTENCY = 'PARAMETER_INCONSISTENCY',
  CONTENT_PARAM_UNDEFINED = 'CONTENT_PARAM_UNDEFINED',
  NODE_ID_WITHOUT = 'NODE_ID_WITHOUT',
  NODE_ID_INCONSISTENCY = 'NODE_ID_INCONSISTENCY',
  TARGET_COMP_ID_EMPTY = 'TARGET_COMP_ID_EMPTY',
  TARGET_NODE_INVALID = 'TARGET_NODE_INVALID'
}

interface DialogErrorInfo {
  errorCode: number;
  errorMsg: string;
}

const DEFINED_ERROR: Record<DialogError, DialogErrorInfo> = {
  [DialogError.ERR_TEMPLATE_WITHOUT]: {
    errorCode: 50000001,
    errorMsg: 'The template with the name %s does not exist.'
  },
  [DialogError.ERR_TEMPLATE_ALREADY_EXIST]: {
    errorCode: 50000002,
    errorMsg: 'The template with the name %s already exist.'
  },
  [DialogError.ERR_TEMPLATE_TYPE_INCONSISTENCY]: {
    errorCode: 50000003,
    errorMsg: 'The template with the name %s is not %s dialog type.'
  },
  [DialogError.PARAMETER_INCONSISTENCY]: {
    errorCode: 60000001,
    errorMsg: 'The params and WrappedBuilder entries are inconsistent.'
  },
  [DialogError.CONTENT_PARAM_UNDEFINED]: {
    errorCode: 60000002,
    errorMsg: 'The WrappedBuilder entries is undefined.'
  },
  [DialogError.NODE_ID_WITHOUT]: {
    errorCode: 70000001,
    errorMsg: 'The Node with the id(%s) does not exist .'
  },
  [DialogError.NODE_ID_INCONSISTENCY]: {
    errorCode: 70000002,
    errorMsg: 'The id of the Node(%d) is the same as that of the Node(%d), id:(%s).'
  },
  [DialogError.TARGET_COMP_ID_EMPTY]: {
    errorCode: 80000001,
    errorMsg: 'The id of the target component is empty'
  },
  [DialogError.TARGET_NODE_INVALID]: {
    errorCode: 80000002,
    errorMsg: 'The id of the target component is invalid, id: (%s), node is not NavDestination or any ancestor is NavDestination'
  }
}

export { DialogError, DEFINED_ERROR, DialogErrorInfo };