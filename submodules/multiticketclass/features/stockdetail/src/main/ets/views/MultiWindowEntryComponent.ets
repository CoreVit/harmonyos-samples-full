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
// [Start IMPORT]
import { MultiWindowEntryInAPP } from '@kit.UIDesignKit';
import { TextModifier } from '@kit.ArkUI';
import { Want } from '@kit.AbilityKit';
// [End IMPORT]

interface InspectorInfo {
  enabled?: boolean;
}

// [Start MultiComponent]
@Component
export struct MultiWindowEntryComponent {
  @Link textModifier: TextModifier;
  @Link want: Want;
  @State isShowMultiWindowEntry: boolean = false;
  // [StartExclude MultiComponent]
  // [Start SplitEnable]
  private timerId: number = -1;

  aboutToAppear(): void {
    this.checkMultiWindowEnabled();
  }

  aboutToDisappear(): void {
    if (this.timerId !== -1) {
      clearTimeout(this.timerId);
    }
  }

  private checkMultiWindowEnabled(): void {
    this.timerId = setTimeout(() => {
      const frameNode = this.getUIContext()?.getFrameNodeById('MultiWindowEntryInAPP');
      const inspectorInfo = JSON.stringify(frameNode?.getInspectorInfo() as InspectorInfo);
      if (inspectorInfo?.search('"enabled":true') && inspectorInfo?.search('"enabled":true') !== -1) {
        this.isShowMultiWindowEntry = true;
      } else {
        this.isShowMultiWindowEntry = false;
      }
    }) as number;
  }
  // [End SplitEnable]
  // [EndExclude MultiComponent]

  build() {
    // [Start MultiWindowEntryInApp]
    // [Start ButtonEnable]
    Row() {
      MultiWindowEntryInAPP({
        want: this.want,
        isShowSubtitle: false,
        multiWindowEntryInAPPStyle: {
          // [StartExclude ButtonEnable]
          iconOptions: {
            iconSize: 24,
            iconColor: $r('sys.color.font_primary'),
            iconWeight: FontWeight.Normal,
            backgroundColor: $r('sys.color.comp_background_tertiary')
          },
          subtitleOptions: {
            modifier: this.textModifier.fontColor($r('app.color.text_primary_color'))
          }
          // [EndExclude ButtonEnable]
        }
      })
        .id('MultiWindowEntryInAPP')
    }
    .visibility(this.isShowMultiWindowEntry ? Visibility.Visible : Visibility.None)
    // [End MultiWindowEntryInApp]
    // [End ButtonEnable]
  }
}
// [End MultiComponent]
