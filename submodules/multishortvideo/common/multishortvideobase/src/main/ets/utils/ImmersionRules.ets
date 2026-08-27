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
import { ImmersionConstants } from './ImmersionConstants';
import { AdaptiveImmersionRule, ImmersionInfo } from './ImmersionManager';

export const DEFAULT_IMMERSION_RULES: AdaptiveImmersionRule[] = [
  {
    videoRatio: [[ImmersionConstants.VIDEO_ASPECT_RATIO_9_16o1, ImmersionConstants.VIDEO_ASPECT_RATIO_9_15o9]],
    windowWidthRange: [[320, 600]],
    windowRatioRange: [[ImmersionConstants.WINDOW_ASPECT_RATIO_9_10o8, ImmersionConstants.WINDOW_ASPECT_RATIO_9_9],
      [ImmersionConstants.WINDOW_ASPECT_RATIO_9_14o4, ImmersionConstants.WINDOW_ASPECT_RATIO_9_10o8]],
    immersionCalculationFunc: (videoSize: Size, windowSize: Size, bottomTabHeight: number,
      statusBarHeight: number) => {
      return commonFullImmersionCalculationFunc(videoSize, windowSize) as ImmersionInfo;
    }
  },
  {
    videoRatio: [[ImmersionConstants.VIDEO_ASPECT_RATIO_9_16o1, ImmersionConstants.VIDEO_ASPECT_RATIO_9_15o9]],
    windowWidthRange: [[320, 600]],
    windowRatioRange: [[ImmersionConstants.WINDOW_ASPECT_RATIO_9_18, ImmersionConstants.WINDOW_ASPECT_RATIO_9_14o4]],
    immersionCalculationFunc: (videoSize: Size, windowSize: Size, bottomTabHeight: number,
      statusBarHeight: number) => {
      const videoRatio = videoSize.width / videoSize.height;
      const windowWidth = windowSize.width;
      const windowHeight = windowSize.height;
      const windowRatio = windowSize.width / windowSize.height;

      if (videoRatio <= windowRatio) {
        return {
          videoSize: {
            width: windowWidth,
            height: windowWidth / windowRatio
          },
          videoPosition: {
            x: 0,
            y: -(windowWidth / windowRatio - windowHeight) / 2
          },
          immersionSetting: {
            isStatusBarImmersive: true,
            isBottomTabImmersive: true
          }
        } as ImmersionInfo;
      } else {
        return {
          videoSize: {
            width: windowHeight * videoRatio,
            height: windowHeight
          },
          videoPosition: {
            x: -(windowHeight * videoRatio - windowWidth) / 2,
            y: 0
          },
          immersionSetting: {
            isStatusBarImmersive: true,
            isBottomTabImmersive: true
          }
        } as ImmersionInfo;
      }
    }
  },
  {
    videoRatio: [[ImmersionConstants.VIDEO_ASPECT_RATIO_9_16o1, ImmersionConstants.VIDEO_ASPECT_RATIO_9_15o9]],
    windowWidthRange: [[320, 600]],
    windowRatioRange: [[ImmersionConstants.WINDOW_ASPECT_RATIO_9_20, ImmersionConstants.WINDOW_ASPECT_RATIO_9_18]],
    immersionCalculationFunc: (videoSize: Size, windowSize: Size, bottomTabHeight: number,
      statusBarHeight: number) => {
      const videoRatio = videoSize.width / videoSize.height;
      const windowWidth = windowSize.width;
      const windowHeight = windowSize.height;

      const restShowAreaHeight = windowHeight - bottomTabHeight;
      const restShowAreaWidth = windowWidth;

      const videoHeight = restShowAreaHeight;
      const videoWidth = videoHeight * videoRatio;

      return {
        videoSize: {
          width: videoWidth,
          height: videoHeight
        },
        videoPosition: {
          x: (restShowAreaWidth - videoWidth) / 2,
          y: 0
        },
        immersionSetting: {
          isStatusBarImmersive: true,
          isBottomTabImmersive: false
        }
      } as ImmersionInfo;
    }
  },
  {
    videoRatio: [[ImmersionConstants.VIDEO_ASPECT_RATIO_9_16o1, ImmersionConstants.VIDEO_ASPECT_RATIO_9_15o9]],
    windowWidthRange: [[320, 600]],
    windowRatioRange: [[0, ImmersionConstants.WINDOW_ASPECT_RATIO_9_20]],
    immersionCalculationFunc: (videoSize: Size, windowSize: Size, bottomTabHeight: number,
      statusBarHeight: number) => {
      const videoRatio = videoSize.width / videoSize.height;
      const windowWidth = windowSize.width;
      const windowHeight = windowSize.height;

      const restShowAreaHeight = windowHeight - bottomTabHeight - statusBarHeight;
      const restShowAreaWidth = windowWidth;

      const videoWidth = restShowAreaWidth * ImmersionConstants.VIDEO_STRETCH_ASPECT_RATIO_17o8_16;
      const videoHeight = videoWidth / videoRatio;
      return {
        videoSize: {
          width: videoWidth,
          height: videoHeight
        },
        videoPosition: {
          x: (windowWidth - videoWidth) / 2,
          y: statusBarHeight + (restShowAreaHeight - videoHeight) / 2
        },
        immersionSetting: {
          isStatusBarImmersive: false,
          isBottomTabImmersive: false
        }
      } as ImmersionInfo;
    }
  },
  {
    videoRatio: [[ImmersionConstants.VIDEO_ASPECT_RATIO_9_16o1, ImmersionConstants.VIDEO_ASPECT_RATIO_9_15o9]],
    windowWidthRange: [[320, Infinity]],
    windowRatioRange: [[ImmersionConstants.WINDOW_ASPECT_RATIO_9_10o8, Infinity]],
    immersionCalculationFunc: (videoSize: Size, windowSize: Size, bottomTabHeight: number,
      statusBarHeight: number) => {
      return commonFullImmersionCalculationFunc(videoSize, windowSize) as ImmersionInfo;
    }
  },
  {
    videoRatio: [[ImmersionConstants.VIDEO_ASPECT_RATIO_9_16o1, ImmersionConstants.VIDEO_ASPECT_RATIO_9_15o9]],
    windowWidthRange: [[600, Infinity]],
    windowRatioRange: [[0, ImmersionConstants.WINDOW_ASPECT_RATIO_9_10o8]],
    immersionCalculationFunc: (videoSize: Size, windowSize: Size, bottomTabHeight: number,
      statusBarHeight: number) => {
      return commonFullImmersionCalculationFunc(videoSize, windowSize) as ImmersionInfo;
    }
  },
  {
    videoRatio: [[0, ImmersionConstants.VIDEO_ASPECT_RATIO_9_16o1],
      [ImmersionConstants.VIDEO_ASPECT_RATIO_9_15o9, Infinity]],
    windowWidthRange: [[300, Infinity]],
    windowRatioRange: [[ImmersionConstants.WINDOW_ASPECT_RATIO_9_18, Infinity]],
    immersionCalculationFunc: (videoSize: Size, windowSize: Size, bottomTabHeight: number,
      statusBarHeight: number) => {
      const videoRatio = videoSize.width / videoSize.height;
      const windowWidth = windowSize.width;
      const windowHeight = windowSize.height;
      const windowRatio = windowSize.width / windowSize.height;

      if (videoRatio <= windowRatio) {
        return {
          videoSize: {
            width: windowHeight * videoRatio,
            height: windowHeight
          },
          videoPosition: {
            x: (windowWidth - windowHeight * videoRatio) / 2,
            y: 0
          },
          immersionSetting: {
            isStatusBarImmersive: true,
            isBottomTabImmersive: true
          }
        } as ImmersionInfo;
      } else {
        let offsetY = (windowHeight - windowWidth / videoRatio) / 2;
        return {
          videoSize: {
            width: windowWidth,
            height: windowWidth / videoRatio
          },
          videoPosition: {
            x: 0,
            y: offsetY
          },
          immersionSetting: {
            isStatusBarImmersive: statusBarHeight > offsetY,
            isBottomTabImmersive: offsetY + windowWidth / videoRatio + bottomTabHeight > windowHeight
          }
        } as ImmersionInfo;
      }
    }
  },
  {
    videoRatio: [[0, ImmersionConstants.VIDEO_ASPECT_RATIO_9_16o1],
      [ImmersionConstants.VIDEO_ASPECT_RATIO_9_15o9, Infinity]],
    windowWidthRange: [[300, Infinity]],
    windowRatioRange: [[ImmersionConstants.WINDOW_ASPECT_RATIO_9_20, ImmersionConstants.WINDOW_ASPECT_RATIO_9_18]],
    immersionCalculationFunc: (videoSize: Size, windowSize: Size, bottomTabHeight: number,
      statusBarHeight: number) => {
      const videoRatio = videoSize.width / videoSize.height;
      const windowWidth = windowSize.width;
      const windowHeight = windowSize.height;

      const restShowAreaHeight = windowHeight - bottomTabHeight;
      const restShowAreaWidth = windowWidth;
      const restShowAreaRatio = restShowAreaWidth / restShowAreaHeight;

      if (videoRatio <= restShowAreaRatio) {
        return {
          videoSize: {
            width: restShowAreaHeight * videoRatio,
            height: restShowAreaHeight
          },
          videoPosition: {
            x: (restShowAreaWidth - restShowAreaHeight * videoRatio) / 2,
            y: 0
          },
          immersionSetting: {
            isStatusBarImmersive: true,
            isBottomTabImmersive: false
          }
        } as ImmersionInfo;
      } else {
        return {
          videoSize: {
            width: restShowAreaWidth,
            height: restShowAreaWidth / videoRatio
          },
          videoPosition: {
            x: 0,
            y: (restShowAreaHeight - restShowAreaWidth / videoRatio) / 2
          },
          immersionSetting: {
            isStatusBarImmersive: (restShowAreaHeight - restShowAreaWidth / videoRatio) / 2 < statusBarHeight,
            isBottomTabImmersive: false
          }
        } as ImmersionInfo;
      }
    }
  },
  {
    videoRatio: [[0, ImmersionConstants.VIDEO_ASPECT_RATIO_9_16o1],
      [ImmersionConstants.VIDEO_ASPECT_RATIO_9_15o9, Infinity]],
    windowWidthRange: [[300, Infinity]],
    windowRatioRange: [[0, ImmersionConstants.WINDOW_ASPECT_RATIO_9_20]],
    immersionCalculationFunc: (videoSize: Size, windowSize: Size, bottomTabHeight: number,
      statusBarHeight: number) => {
      const videoRatio = videoSize.width / videoSize.height;
      const windowWidth = windowSize.width;
      const windowHeight = windowSize.height;

      const restShowAreaHeight = windowHeight - bottomTabHeight - statusBarHeight;
      const restShowAreaWidth = windowWidth;
      const restShowAreaRatio = restShowAreaWidth / restShowAreaHeight;

      if (videoRatio <= restShowAreaRatio) {
        return {
          videoSize: {
            width: restShowAreaHeight * videoRatio,
            height: restShowAreaHeight
          },
          videoPosition: {
            x: (restShowAreaWidth - restShowAreaHeight * videoRatio) / 2,
            y: statusBarHeight
          },
          immersionSetting: {
            isStatusBarImmersive: false,
            isBottomTabImmersive: false
          }
        } as ImmersionInfo;
      } else {
        return {
          videoSize: {
            width: restShowAreaWidth,
            height: restShowAreaWidth / videoRatio
          },
          videoPosition: {
            x: 0,
            y: (restShowAreaHeight - restShowAreaWidth / videoRatio) / 2
          },
          immersionSetting: {
            isStatusBarImmersive: false,
            isBottomTabImmersive: false
          }
        } as ImmersionInfo;
      }
    }
  },
]

function commonFullImmersionCalculationFunc(videoSize: Size, windowSize: Size): ImmersionInfo {
  const videoRatio = videoSize.width / videoSize.height;

  const videoHeight = windowSize.height;
  const videoWidth = videoHeight * videoRatio;
  return {
    videoSize: {
      width: videoWidth,
      height: videoHeight
    },
    videoPosition: {
      x: (windowSize.width - videoWidth) / 2,
      y: 0
    },
    immersionSetting: {
      isStatusBarImmersive: true,
      isBottomTabImmersive: true
    }
  } as ImmersionInfo;
}

export const DEFAULT_IMMERSION_CALCULATION_FUNC =
  (videoSize: Size, windowSize: Size, bottomTabHeight: number,
    statusBarHeight: number) => {
    const videoRatio = videoSize.width / videoSize.height;
    const windowHeight = windowSize.height;
    const windowWidth = windowSize.width;
    const windowRatio = windowSize.width / windowSize.height;

    if (videoRatio <= windowRatio) {
      return {
        videoSize: {
          width: windowHeight * videoRatio,
          height: windowHeight
        },
        videoPosition: {
          x: (windowWidth - windowHeight * videoRatio) / 2,
          y: 0
        },
        immersionSetting: {
          isStatusBarImmersive: true,
          isBottomTabImmersive: true
        }
      } as ImmersionInfo;
    } else {
      return {
        videoSize: {
          width: windowWidth,
          height: windowWidth / videoRatio
        },
        videoPosition: {
          x: 0,
          y: (windowHeight - windowWidth / videoRatio) / 2
        },
        immersionSetting: {
          isStatusBarImmersive: false,
          isBottomTabImmersive: false
        }
      } as ImmersionInfo;
    }
  }

