/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

export class LiveCommentModel {
  private static getStringSafe(context: Context, res: Resource): string {
    try {
      return context.resourceManager.getStringSync(res.id);
    } catch (error) {
      return '';
    }
  }

  public static getComments(context: Context): string[] {
    return [
      LiveCommentModel.getStringSafe(context, $r('app.string.LIVE_COMMENTS_LIST3')),
      LiveCommentModel.getStringSafe(context, $r('app.string.LIVE_COMMENTS_LIST2')),
      LiveCommentModel.getStringSafe(context, $r('app.string.LIVE_COMMENTS_LIST1')),
    ];
  }

}
