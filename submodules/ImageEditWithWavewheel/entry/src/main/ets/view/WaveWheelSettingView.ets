/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import type { SimpleWaveWheelOption } from 'wavewheel';
import { TaskViewModel } from '../viewModel/TaskViewModel';
import type { WaveWheelTaskOption } from '../viewModel/TaskViewModel';
import storageManager from '../utils/StorageManager';
import { CommonConstants } from '../common/constant/CommonConstants';
import Logger from '../utils/Logger';
import { ConfigurationConstant } from '@kit.AbilityKit';
import type { BreakpointType } from '../utils/MultiDeviceUtil';
import { getValueByBreakpointSync } from '../utils/MultiDeviceUtil';

const TAG = `WaveWheelSettingView`;

const APP_STORAGE_KEY = CommonConstants.KEY_SIMPLE_WAVE_WHEEL_OPTIONS;

// Module-level temporary storage to retain unsaved modifications between bindSheet component destroy/recreate cycles
let tempNeedSaveOptions: WaveWheelTaskOption[] | null = null;
let tempAllOptions: WaveWheelTaskOption[] | null = null;

export function clearTempOptions(): void {
  tempNeedSaveOptions = null;
  tempAllOptions = null;
}
;

@Builder
export function WaveWheelSettingViewBuilder(onClose: () => void, onDirtyChanged?: (dirty: boolean) => void) {
  WaveWheelSettingView({ onClose: onClose, onDirtyChanged: onDirtyChanged });
}

// [Start define_struct_wavewheel_setting_view]
@Component
struct WaveWheelSettingView {
  // [StartExclude define_struct_wavewheel_setting_view]
  @State itemsPerRow: number = 4;
  // [EndExclude define_struct_wavewheel_setting_view]
  @StorageLink(APP_STORAGE_KEY) simpleWaveWheelOptions: SimpleWaveWheelOption[] =
    []; // Synchronize this variable on save. On initialization, read currently selected features from this variable.
  @State allOptions: WaveWheelTaskOption[] = []; // Stores all available options
  @State needSaveOptions: WaveWheelTaskOption[] = []; // Temporarily stores the user's current modifications
  @State draggedIndex: number = -1; // Tracks the index of the item being dragged during reordering
  // [End define_struct_wavewheel_setting_view]
  @StorageProp(CommonConstants.CURRENT_COLOR_MODE) currentColorMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT;
  @StorageProp(CommonConstants.BREAKPOINT_KEY) currentBreakpoint: BreakpointType = 'sm';
  scroller: Scroller = new Scroller();
  onClose?: () => void = undefined;
  onDirtyChanged?: (dirty: boolean) => void = undefined;
  private isDataModified: boolean = false;

  private reorderItems(from: number, to: number): void {
    if (from < 0 || from >= this.needSaveOptions.length || to < 0 || to >= this.needSaveOptions.length || from === to) {
      return;
    }
    const newOptions: WaveWheelTaskOption[] = [];
    for (let i = 0; i < this.needSaveOptions.length; i++) {
      newOptions.push(this.needSaveOptions[i]);
    }
    const temp = newOptions[from];
    newOptions[from] = newOptions[to];
    newOptions[to] = temp;
    this.needSaveOptions = newOptions;
    this.isDataModified = true;
    if (this.onDirtyChanged) {
      this.onDirtyChanged(true);
    }
  }

  resetOptions(): void {
    this.isDataModified = false;
    let allOptions = TaskViewModel.getInstance().getAllWaveWheelOptions();
    // Sync current selection state from AppStorage
    const selectedIds = this.simpleWaveWheelOptions.map(opt => opt.id);
    Logger.debug(TAG, `totalSelectIds=${selectedIds.length}`);
    let key2options: Map<string, WaveWheelTaskOption> = new Map();

    allOptions.forEach(item => {
      item.selected = selectedIds.includes(item.id);
      key2options.set(item.id, item);
    });
    this.allOptions = allOptions;

    let needSaveOptions: WaveWheelTaskOption[] = [];
    for (let i = 0; i < this.simpleWaveWheelOptions.length; ++i) {
      let option = key2options.get(this.simpleWaveWheelOptions[i].id);
      if (option !== undefined) {
        needSaveOptions.push(option);
      }
    }
    this.needSaveOptions = needSaveOptions;
  }

  aboutToAppear(): void {
    Logger.debug(TAG, `begin aboutToAppear`);
    if (tempNeedSaveOptions !== null && tempAllOptions !== null) {
      this.allOptions = tempAllOptions;
      this.needSaveOptions = tempNeedSaveOptions;
      tempNeedSaveOptions = null;
      tempAllOptions = null;
      this.isDataModified = true;
      if (this.onDirtyChanged) {
        this.onDirtyChanged(true);
      }
    } else {
      this.resetOptions();
      if (this.onDirtyChanged) {
        this.onDirtyChanged(false);
      }
    }
  }

  aboutToDisappear(): void {
    if (this.isDataModified) {
      tempNeedSaveOptions = this.needSaveOptions;
      tempAllOptions = this.allOptions;
    }
  }

  @Builder
  selectedChipBuilder(item: WaveWheelTaskOption) {
    Row() {
      if (item.useSysImg) {
        SymbolGlyph(item.icon)
          .width(16)
          .height(16)
          .fontSize(16)
          .fontColor([$r('sys.color.ohos_id_color_text_primary')])
          .margin({ left: 12 });
      } else {
        Image(item.icon)
          .width(16)
          .height(16)
          .margin({ left: 12 });
      }


      Text(item.title)
        .fontSize(14)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(400)
        .margin({ left: 4, right: 4 })
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.None });

      SymbolGlyph($r('sys.symbol.line_3_horizontal'))
        .width(12)
        .height(12)
        .fontSize(12)
        .fontColor([$r('sys.color.ohos_id_color_text_primary')])
        .margin({ right: 12 });
    }
    .height(28)
    .backgroundColor($r('sys.color.ohos_id_color_button_normal'))
    .borderRadius(16)
    .margin({ right: 12, bottom: 12 });
  }

  @Builder
  dragSelectedChipBuilder(item: WaveWheelTaskOption) {
    Row() {
      if (item.useSysImg) {
        SymbolGlyph(item.icon)
          .width(16)
          .height(16)
          .fontSize(16)
          .fontColor([$r('sys.color.ohos_id_color_text_primary')]);
      } else {
        Image(item.icon)
          .width(16)
          .height(16);
      }

      Text(item.title)
        .fontSize(14)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .layoutWeight(1)
        .fontWeight(400)
        .margin({ left: 4, right: 4 })
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis });

      SymbolGlyph($r('sys.symbol.line_3_horizontal'))
        .width(12)
        .height(12)
        .fontSize(12)
        .fontColor([$r('sys.color.ohos_id_color_text_primary')]);
    }
    .width(140)
    .height(32)
    .padding({
      left: 8,
      right: 8,
      top: 4,
      bottom: 4
    })
    .backgroundColor($r('sys.color.ohos_id_color_button_normal'))
    .borderRadius(16);
  }

  @Builder
  allChipBuilder(item: WaveWheelTaskOption) {
    Row() {
      if (item.useSysImg) {
        SymbolGlyph(item.icon)
          .width(16)
          .height(16)
          .fontSize(16)
          .fontColor(item.selected ? [$r('sys.color.ohos_id_color_text_primary_contrary')] :
            [$r('sys.color.ohos_id_color_text_primary')])
          .margin({ left: 12 });
      } else {
        WithTheme(
          {
            colorMode: item.selected ? ThemeColorMode.DARK :
              (this.currentColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT ? ThemeColorMode.LIGHT :
                ThemeColorMode.DARK)
          }) {
          Image(item.icon)
            .width(16)
            .height(16)
            .margin({ left: 12 });
        };
      }


      Text(item.title)
        .fontSize(14)
        .fontWeight(400)
        .fontColor(item.selected ? $r('sys.color.ohos_id_color_text_primary_contrary') :
          $r('sys.color.ohos_id_color_text_primary'))
        .margin({ left: 4, right: 4 })
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Clip });

      if (item.selected) {
        SymbolGlyph($r('sys.symbol.checkmark'))
          .width(14)
          .height(14)
          .fontSize(14)
          .fontColor([$r('sys.color.ohos_id_color_text_primary_contrary')])
          .margin({ right: 12 });
      } else {
        SymbolGlyph($r('sys.symbol.plus'))
          .width(14)
          .height(14)
          .fontSize(14)
          .fontColor([$r('sys.color.ohos_id_color_text_primary')])
          .margin({ right: 12 });

      }
    }
    .borderRadius(16)
    .height(28)
    .backgroundColor(
      item.selected ? $r('sys.color.ohos_id_color_emphasize') : $r('sys.color.ohos_id_color_button_normal'))
    .margin({ right: 12, bottom: 16 })
    .opacity(this.getChipOpacity(item))
    .onClick(() => {
      if (!item.selected) {
        const currentSelected = this.allOptions.filter((i: WaveWheelTaskOption) => i.selected).length;
        if (currentSelected >= 4) {
          try {
            this.getUIContext().getPromptAction().showToast({
              message: $r('app.string.max_four_features'),
              duration: 2000
            });
          } catch (error) {
            const err: BusinessError = error as BusinessError;
            Logger.error(TAG, `fail to showToast error ${err.code}: ${err.message}`);
          }
          return;
        }
      }
      const isCanceling = item.selected;

      // Create new array to trigger UI update - do not use spread operator
      const newAllOptions: WaveWheelTaskOption[] = [];
      for (let i = 0; i < this.allOptions.length; i++) {
        const opt = this.allOptions[i];
        if (opt.id === item.id) {
          // Create a new object with explicit type
          let updatedOpt: WaveWheelTaskOption = {
            id: opt.id,
            title: opt.title,
            icon: opt.icon,
            useSysImg: opt.useSysImg,
            enable: opt.enable,
            selected: !item.selected
          };
          newAllOptions.push(updatedOpt);
        } else {
          newAllOptions.push(opt);
        }
      }
      this.allOptions = newAllOptions;

      if (isCanceling) {
        const index = this.needSaveOptions.findIndex(opt => opt.id === item.id);
        if (index !== -1) {
          const newNeedSaveOptions: WaveWheelTaskOption[] = [];
          for (let i = 0; i < this.needSaveOptions.length; i++) {
            if (i !== index) {
              newNeedSaveOptions.push(this.needSaveOptions[i]);
            }
          }
          this.needSaveOptions = newNeedSaveOptions;
        }
      } else {
        const newNeedSaveOptions: WaveWheelTaskOption[] = [];
        for (let i = 0; i < this.needSaveOptions.length; i++) {
          newNeedSaveOptions.push(this.needSaveOptions[i]);
        }
        let itemToAdd: WaveWheelTaskOption = {
          id: item.id,
          title: item.title,
          icon: item.icon,
          useSysImg: item.useSysImg,
          enable: item.enable,
          selected: true
        };
        newNeedSaveOptions.push(itemToAdd);
        this.needSaveOptions = newNeedSaveOptions;
      }
      if (this.onDirtyChanged) {
        this.isDataModified = true;
        this.onDirtyChanged(true);
      }
    });
  }

  private getChipOpacity(item: WaveWheelTaskOption): number {
    const currentSelectedCount = this.allOptions.filter((i: WaveWheelTaskOption) => i.selected).length;
    const shouldBeDisabled = !item.selected && currentSelectedCount >= 4;
    return shouldBeDisabled ? 0.4 : 1;
  }

  private async onSave(): Promise<void> {
    tempNeedSaveOptions = null;
    tempAllOptions = null;
    this.isDataModified = false;
    // Update TaskViewModel
    const selectedIds = this.needSaveOptions
      .map(item => item.id);

    // Save to persistent storage
    await storageManager.saveSelectedIds(selectedIds);
    Logger.info(TAG, `onSave needSavelen=${this.needSaveOptions.length}`);
    // Sync to AppStorage
    this.simpleWaveWheelOptions = this.needSaveOptions
      .map(item => {
        return {
          id: item.id,
          title: item.title,
          icon: item.icon,
          useSysImg: item.useSysImg,
          enable: item.enable
        } as SimpleWaveWheelOption;
      });
    Logger.info(TAG, `onSave simpleWaveWheelOptions=${this.simpleWaveWheelOptions.length}`);

    if (this.onDirtyChanged) {
      this.onDirtyChanged(false);
    }
    ;
    try {
      this.getUIContext().getPromptAction().showToast({
        message: $r('app.string.saved_use_stylus'),
        duration: 2000
      });
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Logger.error(TAG, `showToast fail error ${err.code}: ${err.message}`);
    }

    // Close the dialog
    if (this.onClose) {
      this.onClose();
    }
  }

  private onCancel(): void {
    tempNeedSaveOptions = null;
    tempAllOptions = null;
    this.isDataModified = false;
    this.resetOptions();
    if (this.onDirtyChanged) {
      this.onDirtyChanged(false);
    }
    // Close the dialog
    if (this.onClose) {
      this.onClose();
    }
  }

  build() {
    RelativeContainer() {
      Column({ space: 0 }) {
        Column() {
          Text($r('app.string.selected_features_drag_hint'))
            .fontSize(14)
            .fontWeight(500)
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            .width('100%')
            .padding({
              left: 16,
              right: 16,
              top: 28,
              bottom: 16
            });

          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
            ForEach(this.needSaveOptions.filter((item: WaveWheelTaskOption) => item.selected),
              (item: WaveWheelTaskOption, index: number) => {
                Stack() {
                  this.selectedChipBuilder(item);
                }
                .onDragStart((_: DragEvent, __: string) => {
                  this.draggedIndex = index;
                  return this.dragSelectedChipBuilder(item);
                })
                .onDrop((_: DragEvent, __: string) => {
                  if (this.draggedIndex >= 0 && this.draggedIndex < this.needSaveOptions.length &&
                    index >= 0 && index < this.needSaveOptions.length &&
                    this.draggedIndex !== index) {
                    this.reorderItems(this.draggedIndex, index);
                  }
                  this.draggedIndex = -1;
                })
                .onDragEnd(() => {
                  this.draggedIndex = -1;
                });
              }, (item: WaveWheelTaskOption) => item.id);
          }
          .width('90%')
          .margin({ bottom: 12 });
        }
        .width('100%');

        Divider()
          .strokeWidth(1)
          .color(Color.Gray)
          .margin({ left: 16, right: 16 });

        Column() {
          Text($r('app.string.all_features'))
            .fontSize(14)
            .fontWeight(500)
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            .width('100%')
            .padding({
              left: 16,
              right: 16,
              top: 36,
              bottom: 16
            });

          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
            ForEach(this.allOptions, (item: WaveWheelTaskOption) => {
              this.allChipBuilder(item);
            });
          }
          .width('100%')
          .padding({ left: 16, right: 16 });
        }
        .width('100%');
      } // [Column]
      .width('100%')
      .layoutWeight(1)
      .borderRadius(16); // [End of Column]


      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
        Button($r('app.string.cancel'), { buttonStyle: ButtonStyleMode.EMPHASIZED, role: ButtonRole.NORMAL })
          .width(getValueByBreakpointSync<number>({ sm: 158, lg: 218 }, this.currentBreakpoint as BreakpointType))
          .height(40)
          .backgroundColor(
            this.currentColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ? 'rgba(255, 255, 255, 0.1)' :
              'rgba(0, 0, 0, 0.05)')
          .fontColor($r('app.color.font_color_blue'))
          .fontSize(16)
          .fontWeight(500)
          .borderRadius(20)
          .onClick(() => {
            this.onCancel();
          });
        Divider()
          .vertical(true)
          .strokeWidth(0.5)
          .height(24)
          .color('rgba(0, 0, 0, 0.05)')
          .margin({ left: 12, right: 12 });
        Button($r('app.string.save'), { buttonStyle: ButtonStyleMode.EMPHASIZED, role: ButtonRole.NORMAL })
          .width(getValueByBreakpointSync<number>({ sm: 158, lg: 218 }, this.currentBreakpoint as BreakpointType))
          .height(40)
          .backgroundColor($r('app.color.button_color_blue'))
          .fontColor(Color.White)
          .fontSize(16)
          .fontWeight(500)
          .borderRadius(20)
          .onClick(async () => {
            Logger.info(TAG, `onSave before onsave needSavelen=${this.needSaveOptions.length}`);
            await this.onSave();
          });
      } // [Flex]
      .height(40)
      .margin({
        top: 0,
        bottom: 40,
        left: 16,
        right: 16
      })
      .alignRules({
        'bottom': { anchor: '__container__', align: VerticalAlign.Bottom }
      })
      .offset({
        x: 0,
        y: 0,
      }); // [End of Flex]
    } // [Column]
    .width('100%')
    .height('100%')
    .padding({
      bottom: 30
    });
  } // [End of build]
}
