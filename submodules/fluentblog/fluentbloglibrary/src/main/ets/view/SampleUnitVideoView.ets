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

import { Constants } from '../common/Constants';
import { BreakpointType, BreakpointTypeEnum } from '../utils/BreakpointSystem';

@Component
export default struct SampleUnitVideoView {
  @State videoCurTime: number = 0;
  @State sliderCurTime: number = 0;
  @StorageLink(Constants.KEY_PREFIX + 'CurrentBreakpoint') curBp: string = BreakpointTypeEnum.SM;
  @Consume('NavPathStack') pageStack: NavPathStack;
  controller: VideoController = new VideoController();
  durationTime: number = 0;
  durationStringTime: string = '00:00';
  currentStringTime: string = '00:00';
  flag: boolean = false;

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Video({
        src: $rawfile(Constants.VIDEO_NAME),
        previewUri: $r('app.media.video_cover'),
        controller: this.controller
      })
        .backgroundColor(Color.Transparent)
        .width(new BreakpointType({ sm: '100%', md: '70%', lg: '60%' }).getValue(this.curBp))
        .height(new BreakpointType({ sm: 200, md: 240, lg: 320 }).getValue(this.curBp))
        .controls(false)
        .autoPlay(false)
        .objectFit(ImageFit.Cover)
        .loop(false)
        .onUpdate((event) => {
          if (event) {
            this.videoCurTime = event.time;
            this.currentStringTime = this.changeSliderTime(this.videoCurTime);
          }
        })
        .onPrepared((event) => {
          this.prepared(event?.duration);
        })
        .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean) => {
          if (!isVisible) {
            this.controller.stop();
          } else {
            this.controller.start();
          }
        })
        .onFinish(() => {
          this.controller.start();
        })
        .onClick(() => {
          this.pageStack.pushPathByName('NewPlayPage', '');
        })
    }
  }

  prepared(duration: number) {
    this.durationTime = duration;
    let second: number = duration % 60;
    let min: number = Number.parseInt((duration / 60).toString());
    let head = min < 10 ? `0${min}` : min;
    let end = second < 10 ? `0${second}` : second;
    this.durationStringTime = `${head}':'${end}`;
    this.flag = true;
  }

  changeSliderTime(value: number): string {
    let second: number = value % 60;
    let min: number = Number.parseInt((value / 60).toString());
    let head = min < 10 ? `0${min}` : min;
    let end = second < 10 ? `0${second}` : second;
    let nowTime = `${head}':'${end}`;
    return nowTime;
  }
}