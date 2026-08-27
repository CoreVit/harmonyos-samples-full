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

import { common } from '@kit.AbilityKit';
import { RouterParam, CommonConstants } from '../common/Constants';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';
import { ImageUtil } from '../utils/ImageUtil';
import Logger from '../utils/Logger';
import { WindowUtil } from '../utils/WindowUtil';

const TAG = '[KnockShareSample]';

@CustomDialog
struct TipDialog {
  public controller?: CustomDialogController;
  public onConfirm: () => void = () => {
  };

  build() {
    Column() {
      Row() {
        Text('提示')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .lineHeight(27)
          .fontColor('#000000')
      }
      .height(56)
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)

      Text('“碰一碰”当前仅支持手机端操作体验。')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .lineHeight(21)
        .fontColor('#000000')
      Row() {
        Text('知道了')
          .width('100%')
          .height(40)
          .fontColor('#0A59F7')
          .textAlign(TextAlign.Center)
          .onClick(() => {
            Logger.info(TAG, 'Button-clicking callback');
            this.onConfirm();
          })
      }
      .height(56)
      .width('100%')
      .margin({ top: $r('sys.float.padding_level4') })
      .padding({ left: $r('sys.float.padding_level8'), right: $r('sys.float.padding_level8') })
      .alignItems(VerticalAlign.Top)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .borderRadius(32)
    .backgroundColor('#ffffff')
  }
}

@Component
export struct KnockShareComponent {
  @StorageLink(CommonConstants.KEY_PREFIX + 'currentBreakpoint') curBp: string = BreakpointTypeEnum.SM;
  @StorageProp(CommonConstants.KEY_PREFIX + 'statusBarHeight') statusBarHeight: number = 0;
  @StorageLink(CommonConstants.KEY_PREFIX + 'videoIndex') videoIndex: number = -1;
  private pageStack: NavPathStack = new NavPathStack();
  private customDialogController: CustomDialogController | null = new CustomDialogController({
    builder: TipDialog({
      onConfirm: () => {
        this.customDialogController?.close();
      }
    }),
    cancel: () => {
    },
    onWillDismiss: (dismissDialogAction: DismissDialogAction) => {
      dismissDialogAction.dismiss()
    },
    alignment: DialogAlignment.Center,
    autoCancel: true,
    cornerRadius: 32,
    width: 328,
    height: 141,
  });

  aboutToAppear(): void {
    AppStorage.setOrCreate(CommonConstants.KEY_PREFIX + 'pageStack', this.pageStack);
    const context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
    ImageUtil.saveImage(context);
    WindowUtil.updateStatusBarColor(context, true);
    const needTip = AppStorage.get(CommonConstants.KEY_PREFIX + 'needTip') ?? false;
    if (needTip) {
      this.customDialogController?.open();
      AppStorage.delete(CommonConstants.KEY_PREFIX + 'needTip');
    }
  }

  @Builder
  VideoCard(image: Resource, index: number) {
    Column() {
      Image(image)
        .width('100%')
        .aspectRatio(16 / 9)
        .borderRadius(10)
      Column() {
        Text($r('app.string.local_video'))
          .fontSize(14)
          .lineHeight(21)
          .margin({
            bottom: $r('sys.float.padding_level1')
          })
          .width('100%')
          .fontColor('#FFFFFF')
        Text($r('app.string.local_video_describe'))
          .fontSize(12)
          .fontColor('#99FFFFFF')
          .width('100%')
          .textOverflow({ overflow: TextOverflow.Clip })
          .lineHeight(18)
      }
      .margin({ top: $r('sys.float.padding_level4') })
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
    }
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
    .width('100%')
    .margin({
      top: 9
    })
    .onClick(() => {
      let param: RouterParam = {
        videoIndex: index
      }
      this.pageStack.pushPath({ name: 'videoPlay', param: param })
    })
  }

  build() {
    Navigation(this.pageStack) {
      Column() {
        Row() {
          Text($r('app.string.title'))
            .fontSize($r('sys.float.Title_L'))
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Bold)
            .alignSelf(ItemAlign.Start)
        }
        .width('100%')
        .padding({
          left: new BreakpointType({
            sm: $r('sys.float.padding_level8'),
            md: $r('sys.float.padding_level12'),
            lg: $r('sys.float.padding_level16')
          }).getValue(this.curBp),
          right: $r('sys.float.padding_level0'),
          bottom: $r('sys.float.padding_level0'),
          top: 64 + this.statusBarHeight,
        })
        .alignItems(VerticalAlign.Bottom)

        Column() {
          GridRow({ columns: { sm: 2, md: 4, lg: 4 }, gutter: { x: { sm: 8, md: 12, lg: 16 }, y: 24 } }) {
            GridCol() {
              this.VideoCard($r('app.media.video_cover_0'), 0)
            }
            .width('100%')

            GridCol() {
              this.VideoCard($r('app.media.video_cover_3'), 1)
            }
            .width('100%')
          }
          .width('100%')
        }
        .alignItems(HorizontalAlign.Start)
        .padding({
          left: new BreakpointType({
            sm: $r('sys.float.padding_level8'),
            md: $r('sys.float.padding_level12'),
            lg: $r('sys.float.padding_level16')
          }).getValue(this.curBp),
          right: new BreakpointType({
            sm: $r('sys.float.padding_level8'),
            md: $r('sys.float.padding_level12'),
            lg: $r('sys.float.padding_level16')
          }).getValue(this.curBp),
        })
        .width('100%')
        .layoutWeight(1)
        .backgroundColor(Color.Black)
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.Black)
    }
    .hideToolBar(true)
    .mode(NavigationMode.Stack)
  }
}