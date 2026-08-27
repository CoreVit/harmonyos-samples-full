## 基于AudioRenderer的音频播控和多场景交互

### 介绍

本场景解决方案主要面向前台音频开发人员。指导开发者基于AudioRenderer开发音频播控功能。功能包括后台播放、和播控中心的交互、适配不同类型的焦点打断策略、切换路由发声设备、切换输出设备等基础音频常见功能。

### 下载安装

使用ohpm安装依赖

```
ohpm install @ohos_samples/audiointeractionlibrary
```

或者按需在模块中修改oh-package.json5

```
{
  "dependencies": {
     "@ohos_samples/audiointeractionlibrary": "^1.0.0"
  }
}
```

### 使用说明

```
import { AudioInteractionComponent, AudioInterController } from '@ohos_samples/audiointeractionlibrary';
```
按需在文件中使用导出模块即可，其中AudioInteractionComponent是整个sample的入口页面组件。AudioInterController封装了沉浸式、设备断点判断、避让区域计算等窗口能力。示例如下：
```
// Index.ets
import { AudioInteractionComponent } from '@ohos_samples/audiointeractionlibrary';
Stack() {
  AudioInteractionComponent()
}

// EntryAbility.ets
import { AudioInterController } from '@ohos_samples/audiointeractionlibrary';
// onWindowStageCreate回调里的loadContent方法里初始化
AudioInterController.initWindowConfig(windowStage);
```