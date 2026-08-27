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

export class Constants {
  public static readonly FULL_WIDTH: string = '100%';
  public static readonly FULL_HEIGHT: string = '100%';
  public static readonly LIST_HEIGHT: number[] = [48, 56, 46];
  public static readonly BORDER_WIDTH: number = 0.5;
  public static readonly FOLD_IMAGE_RATE: number = 1.2;
  public static readonly TABLE_IMAGE_RATE: number = 1.5;
  public static readonly IMAGE_HEIGHT = 192;
  public static readonly COLUMN_HEIGHT = 175;
  public static readonly IMAGE_HEIGHT_LARGE = 225;
  public static readonly SPACE_8 = 8;
  public static readonly LINE_HEIGHT = 22;
  /**
   * AppStorage key
   */
  public static readonly KEY_PREFIX: string = 'dragFrame';
  public static readonly KEY_BREAKPOINT: string = Constants.KEY_PREFIX + 'BreakPoint';
  public static readonly KEY_STATUS_BAR_HEIGHT: string = Constants.KEY_PREFIX + 'StatusBarHeight';
  public static readonly KEY_NAV_INDICATOR_HEIGHT: string = Constants.KEY_PREFIX + 'NavIndicatorHeight';
  public static readonly KEY_PATH_STACK: string = Constants.KEY_PREFIX + 'PathStack';
  public static readonly KEY_UI_CONTEXT: string = Constants.KEY_PREFIX + 'UIContext';
  public static readonly ROUTES: Route =
    {
      child: [
        {
          name: $r('app.string.image_title'),
          route: 'ImageDrag'
        },
        {
          name: $r('app.string.hyperlink_title'),
          route: 'HyperLinkDrag'
        },
        {
          name: $r('app.string.rich_editor_title'),
          route: 'RichEditorDrag'
        },
        {
          name: $r('app.string.text_input_title'),
          route: 'TextInputDrag'
        },
        {
          name: $r('app.string.textarea_title'),
          route: 'TextAreaDrag'
        },
        {
          name: $r('app.string.list_title'),
          route: 'ListDrag'
        },
        {
          name: $r('app.string.background_title'),
          route: 'BackgroundCustomization'
        },
        {
          name: $r('app.string.watermark_title'),
          route: 'WatermarkAdded'
        },
        {
          name: $r('app.string.ai_recognition_title'),
          route: 'AIRecognition'
        }
      ]
    }
}

export interface Route {
  child: Array<ChildRoute>;
}

export interface ChildRoute {
  name: ResourceStr;
  route: string;
}