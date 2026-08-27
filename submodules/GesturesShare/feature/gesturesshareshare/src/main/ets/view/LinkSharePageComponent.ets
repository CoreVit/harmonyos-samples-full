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

// [Start LinkSharePage]
import { common } from '@kit.AbilityKit';
import { JSON } from '@kit.ArkTS';
import { HdsNavDestination } from '@kit.UIDesignKit';
import { BreakpointType, Constants } from 'gesturessharecommon';
import { FileData, ShareType, VIDEO_SOURCES } from '../model/FileData';
import { ShareModel } from '../model/ShareModel';

@Component
export struct LinkSharePageComponent {
  // [StartExclude LinkSharePage]
  @StorageLink(Constants.KEY_BREAKPOINT) currentBreakpoint: WidthBreakpoint = WidthBreakpoint.WIDTH_SM;
  @StorageLink(Constants.KEY_IS_LINK) isShareLink: boolean = false;
  @StorageLink(Constants.KEY_VIDEO_INDEX) @Watch('changeVideo') shareVideoIndex: number = 0;
  @StorageLink(Constants.KEY_STATUS_BAR_HEIGHT) statusBarHeight: number = 0;
  @StorageLink(Constants.KEY_NAV_INDICATOR_HEIGHT) navIndicatorHeight: number = 0;
  private videoController: VideoController = new VideoController();
  private context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
  private dataList: FileData[] = VIDEO_SOURCES;
  private shareModel: ShareModel | undefined = undefined;
  // [EndExclude LinkSharePage]
  // Current playing video index.
  @State currentVideoIndex: number = 0;
  @State url: ResourceStr = this.dataList.length > 0 ? $rawfile(this.dataList[0].url) : '';

  build() {
    HdsNavDestination() {
      Scroll() {
        Column() {
          // [StartExclude LinkSharePage]
          Column() {
            Video({
              controller: this.videoController,
              src: this.url,
              posterOptions: { showFirstFrame: true }
            })
              .constraintSize({
                maxHeight: '66%'
              })
              .width('100%')
              .aspectRatio(Constants.ASPECT_RATIO_16_9)
              .autoPlay(true)
              .controls(true)
          }
          .margin({
            top: Constants.WINDOW_NAV_HEIGHT
          })
          .backgroundColor($r('sys.color.black'))
          .width('100%')

          Column() {
            // [StartExclude LinkSharePage]
            Text(this.dataList[this.currentVideoIndex]?.name)
              .height($r('app.float.list_container_size'))
              .fontWeight(FontWeight.Medium)
              .fontSize($r('sys.float.Title_M'))
              .alignSelf(ItemAlign.Start)
            Text($r('app.string.play_list'))
              .height($r('app.float.list_container_size'))
              .fontWeight(FontWeight.Medium)
              .fontSize($r('sys.float.Body_L'))
              .alignSelf(ItemAlign.Start)
            // [EndExclude LinkSharePage]
            List({ space: Constants.PADDING_12 }) {
              ForEach(this.dataList, (item: FileData, index) => {
                ListItem() {
                  RelativeContainer() {
                    // [StartExclude LinkSharePage]
                    Text((item.index + 1).toString())
                      .width($r('app.float.list_text_size'))
                      .height($r('app.float.list_text_size'))
                      .fontSize($r('sys.float.Body_L'))
                      .textAlign(TextAlign.Center)
                    if (this.currentVideoIndex === index) {
                      SymbolGlyph($r('sys.symbol.rhythm'))
                        .fontSize($r('sys.float.Body_L'))
                        .alignRules({
                          bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
                          left: { anchor: '__container__', align: HorizontalAlign.Start },
                        })
                        .fontColor([$r('sys.color.interactive_focus')])
                        .offset({
                          x: $r('app.float.list_symbol_offset'),
                          y: $r('app.float.list_symbol_offset')
                        })
                    }
                    // [EndExclude LinkSharePage]
                  }
                  // [StartExclude LinkSharePage]
                  .width($r('app.float.list_text_size'))
                  .height($r('app.float.list_text_size'))
                  .borderWidth('1')
                  .backgroundColor(this.currentVideoIndex === index ? $r('sys.color.comp_emphasize_secondary') :
                    $r('sys.color.background_primary'))
                  .borderColor(this.currentVideoIndex === index ? $r('sys.color.interactive_focus') :
                    $r('sys.color.comp_border_color'))
                  .borderRadius($r('sys.float.corner_radius_level4'))
                  // [EndExclude LinkSharePage]
                  .onClick(() => {
                    this.currentVideoIndex = index;
                    this.shareModel = ShareModel.getInstance();
                    this.shareModel.setVideoIndex(this.currentVideoIndex);
                    this.videoController.reset();
                    this.url = $rawfile(item.url);
                  })
                }
                // [StartExclude LinkSharePage]
              }, (item: FileData, index: number) => index + JSON.stringify(item))
            }
            .listDirection(Axis.Horizontal)
            .height('auto')
            .width('100%')
          }
          .padding({
            left: new BreakpointType({
              sm: $r('sys.float.padding_level8'),
              md: $r('sys.float.padding_level12'),
              lg: $r('sys.float.padding_level16')
            }).getValue(this.currentBreakpoint),
            right: new BreakpointType({
              sm: $r('sys.float.padding_level8'),
              md: $r('sys.float.padding_level12'),
              lg: $r('sys.float.padding_level16')
            }).getValue(this.currentBreakpoint),
            top: $r('sys.float.padding_level8'),
            bottom: $r('sys.float.padding_level8')
          })
        }
      }
      .scrollBar(BarState.Off)
      // [EndExclude LinkSharePage]
    }
    // [StartExclude LinkSharePage]
    .titleBar({
      content: {
        title: {
          mainTitle: $r('app.string.gestures_share_link')
        }
      }
    })
    .padding({
      top: this.statusBarHeight,
      bottom: this.navIndicatorHeight
    })
    .backgroundColor($r('sys.color.container_modal_unfocus_background'))
    // [EndExclude LinkSharePage]
    .onShown(() => {
      // [StartExclude LinkSharePage]
      if (this.isShareLink) {
        this.isShareLink = false;
        this.currentVideoIndex = this.shareVideoIndex;
        if (this.currentVideoIndex >= 0 && this.currentVideoIndex < this.dataList.length) {
          this.url = $rawfile(this.dataList[this.currentVideoIndex].url);
        }
      }
      if (!canIUse('SystemCapability.Collaboration.SystemShare')) {
        return;
      }
      // [EndExclude LinkSharePage]
      this.shareModel = ShareModel.getInstance();
      this.shareModel?.immersiveListening(ShareType.LINK_SHARE);
    })
    .onHidden(() => {
      this.shareModel = ShareModel.getInstance();
      this.shareModel?.immersiveDisableListening();
    })
  }

  aboutToAppear(): void {
    this.shareModel?.immersiveDisableListening();
  }

  // [StartExclude LinkSharePage]
  changeVideo() {
    if (this.isShareLink) {
      this.isShareLink = false;
      this.currentVideoIndex = this.shareVideoIndex;
      this.shareModel = ShareModel.getInstance();
      this.shareModel.setVideoIndex(this.currentVideoIndex);
      if (this.currentVideoIndex >= 0 && this.currentVideoIndex < this.dataList.length) {
        this.url = $rawfile(this.dataList[this.currentVideoIndex].url);
      }
    }
  }
  // [EndExclude LinkSharePage]
}
// [End LinkSharePage]

@Builder
export function LinkSharePageComponentBuilder() {
  LinkSharePageComponent()
}