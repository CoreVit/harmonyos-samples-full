## 视频投播功能

### 介绍

本实例基于播控中心和系统投播实现完整的视频投播功能，包含投播和播控基础控制：设备切换、集数切换、音量增减、进度切换。

### 下载安装

使用ohpm安装依赖

```
ohpm install @ohos_samples/videocastlibrary
```

或者按需在模块中修改oh-package.json5

```
{
  "dependencies": {
     "@ohos_samples/videocastlibrary": "^1.0.1"
  }
}
```

### 使用说明

```
import { VideoCastComponent, VideoCastController } from '@ohos_samples/videocastlibrary';
```
按需在文件中使用导出模块即可，其中VideoCastComponent是整个sample的入口页面。进入页面可以看到视频列表，点击进入后可以看到播放的视频，支持选集、投播视频等能力。WindowUtil封装了沉浸式、设备断点判断、避让区域计算等窗口能力。示例如下：
```
// Index.ets
import { VideoCastComponent } from '@ohos_samples/videocastlibrary';
Stack() {
  VideoCastComponent()
}

// EntryAbility.ets
import { VideoCastController } from '@ohos_samples/videocastlibrary';
//onCreate()里初始化视频资源
VideoCastController.initVideo(this.context);
//onWindowStageCreate()的loadContent方法里初始化窗口
VideoCastController.initWindow(windowStage);
```