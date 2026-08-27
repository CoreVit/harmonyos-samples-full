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
import { POPUP_ANCHOR_ID } from './Consntant';

// make a reflect from DialogAlignment to Alignment
// DialogAlignment: Top, Center, Bottom, Default, TopStart, TopEnd, CenterStart, CenterEnd, BottomStart, BottomEnd
export const alignmentDic = [
  Alignment.Top,
  Alignment.Center,
  Alignment.Bottom,
  Alignment.Center,
  Alignment.TopStart,
  Alignment.TopEnd,
  Alignment.Start,
  Alignment.End,
  Alignment.BottomStart,
  Alignment.BottomEnd
];

export const popupAlignRuleDic: Record<DialogAlignment, AlignRuleOption> = {};

popupAlignRuleDic[Placement.Left] = {
  center: { anchor: POPUP_ANCHOR_ID, align: VerticalAlign.Center },
  right: { anchor: POPUP_ANCHOR_ID, align: HorizontalAlign.Start }
}
popupAlignRuleDic[Placement.LeftTop] = {
  top: { anchor: POPUP_ANCHOR_ID, align: VerticalAlign.Top },
  right: { anchor: POPUP_ANCHOR_ID, align: HorizontalAlign.Start }
}
popupAlignRuleDic[Placement.LeftBottom] = {
  bottom: { anchor: POPUP_ANCHOR_ID, align: VerticalAlign.Bottom },
  right: { anchor: POPUP_ANCHOR_ID, align: HorizontalAlign.Start }
}

popupAlignRuleDic[Placement.Right] = {
  center: { anchor: POPUP_ANCHOR_ID, align: VerticalAlign.Center },
  left: { anchor: POPUP_ANCHOR_ID, align: HorizontalAlign.End }
}
popupAlignRuleDic[Placement.RightTop] = {
  top: { anchor: POPUP_ANCHOR_ID, align: VerticalAlign.Top },
  left: { anchor: POPUP_ANCHOR_ID, align: HorizontalAlign.End }
}
popupAlignRuleDic[Placement.RightBottom] = {
  bottom: { anchor: POPUP_ANCHOR_ID, align: VerticalAlign.Bottom },
  left: { anchor: POPUP_ANCHOR_ID, align: HorizontalAlign.End }
}

popupAlignRuleDic[Placement.Bottom] = {
  middle: { anchor: POPUP_ANCHOR_ID, align: HorizontalAlign.Center },
  top: { anchor: POPUP_ANCHOR_ID, align: VerticalAlign.Bottom }
}
popupAlignRuleDic[Placement.BottomLeft] = {
  left: { anchor: POPUP_ANCHOR_ID, align: HorizontalAlign.Start },
  top: { anchor: POPUP_ANCHOR_ID, align: VerticalAlign.Bottom }
}
popupAlignRuleDic[Placement.BottomRight] = {
  right: { anchor: POPUP_ANCHOR_ID, align: HorizontalAlign.End },
  top: { anchor: POPUP_ANCHOR_ID, align: VerticalAlign.Bottom }
}

popupAlignRuleDic[Placement.Top] = {
  middle: { anchor: POPUP_ANCHOR_ID, align: HorizontalAlign.Center },
  bottom: { anchor: POPUP_ANCHOR_ID, align: VerticalAlign.Top }
}
popupAlignRuleDic[Placement.TopLeft] = {
  left: { anchor: POPUP_ANCHOR_ID, align: HorizontalAlign.Start },
  bottom: { anchor: POPUP_ANCHOR_ID, align: VerticalAlign.Top }
}
popupAlignRuleDic[Placement.TopRight] = {
  right: { anchor: POPUP_ANCHOR_ID, align: HorizontalAlign.End },
  bottom: { anchor: POPUP_ANCHOR_ID, align: VerticalAlign.Top }
}

export enum PopupRelativePosition {
  Top, Bottom, Left, Right
}

export const alignDirectionDic: Map<PopupRelativePosition, FlexDirection> = new Map();

alignDirectionDic[PopupRelativePosition.Top] = FlexDirection.Column;
alignDirectionDic[PopupRelativePosition.Bottom] = FlexDirection.ColumnReverse;
alignDirectionDic[PopupRelativePosition.Left] = FlexDirection.Row;
alignDirectionDic[PopupRelativePosition.Right] = FlexDirection.RowReverse;

export const popupRelativePositionDic: Record<DialogAlignment, PopupRelativePosition> = {};

popupRelativePositionDic[Placement.Left] = PopupRelativePosition.Left;
popupRelativePositionDic[Placement.LeftTop] = PopupRelativePosition.Left;
popupRelativePositionDic[Placement.LeftBottom] = PopupRelativePosition.Left;

popupRelativePositionDic[Placement.Right] = PopupRelativePosition.Right;
popupRelativePositionDic[Placement.RightTop] = PopupRelativePosition.Right;
popupRelativePositionDic[Placement.RightBottom] = PopupRelativePosition.Right;

popupRelativePositionDic[Placement.Bottom] = PopupRelativePosition.Bottom;
popupRelativePositionDic[Placement.BottomLeft] = PopupRelativePosition.Bottom;
popupRelativePositionDic[Placement.BottomRight] = PopupRelativePosition.Bottom;

popupRelativePositionDic[Placement.Top] = PopupRelativePosition.Top;
popupRelativePositionDic[Placement.TopLeft] = PopupRelativePosition.Top;
popupRelativePositionDic[Placement.TopRight] = PopupRelativePosition.Top;