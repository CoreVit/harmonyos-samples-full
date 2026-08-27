## 实现WaterFlow瀑布流布局功能

### 介绍

本示例为开发者展示使用WaterFlow瀑布流容器实现首页布局效果，包括使用sections实现混排布局、结合item实现滑动吸顶、多种组件混合排列等场景。

### 下载安装

使用ohpm安装依赖

```
ohpm install @ohos_samples/waterflowlibrary
```

或者按需在模块中修改oh-package.json5

```
{
  "dependencies": {
     "@ohos_samples/waterflowlibrary": "^1.0.0"
  }
}
```

### 使用说明

```
import { WaterFlowComponent } from '@ohos_samples/waterflowlibrary';
```
按需在文件中使用导出模块即可，其中WaterFlowComponent是整个sample的入口页面。示例如下：
```
// Index.ets
import { WaterFlowComponent } from '@ohos_samples/waterflowlibrary';
Stack() {
    WaterFlowComponent()
}

// EntryAbility.ets
import { WaterFlowController } from '@ohos_samples/waterflowlibrary';
onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        Logger.error(0x0000, TAG, `Failed to load the content, code: ${err.code}, message: ${err.message}}.`);
        return;
      }
      WaterFlowController.initWindowConfig(windowStage);
    });
}
```