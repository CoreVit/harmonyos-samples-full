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

import { Constants } from '../commons/constants/Constants';
import { LowPriceView } from '../component/LowPriceView';

@Component
export struct LowPriceCalendarPage {
  build() {
    NavDestination() {
      GridRow({
        columns: {
          sm: Constants.COLUMN_SM,
          md: Constants.COLUMN_MD,
          lg: Constants.COLUMN_LG
        },
        direction: GridRowDirection.Row
      }) {
        GridCol({
          span: {
            sm: Constants.COLUMN_SM,
            md: Constants.COLUMN_MD,
            lg: Constants.COLUMN_LG
          }
        }) {
          Scroll() {
            LowPriceView()
          }
          .backgroundColor($r('sys.color.background_primary'))
          .scrollBar(BarState.Off)
          .width(Constants.FULL_WIDTH_PERCENT)
          .height(Constants.FULL_WIDTH_PERCENT)
        }
      }
    }
    .hideTitleBar(true)
  }
}