## 基于Grid的嵌套混合布局

### 介绍

本示例主要实现了Grid组件和List组件以及Swiper组件的嵌套混合布局。

### 下载安装

使用ohpm安装依赖

```
ohpm install @ohos_samples/gridhybridlibrary
```

或者按需在模块中修改oh-package.json5

```
{
  "dependencies": {
     "@ohos_samples/gridhybridlibrary": "^1.0.0"
  }
}
```

### 使用说明

```
import { GridHybridComponent } from '@ohos_samples/gridhybridlibrary';
```
按需在文件中使用导出模块即可，其中GridHybridComponent是整个sample的入口页面。示例如下：
```
// Index.ets
import { GridHybridComponent } from '@ohos_samples/gridhybridlibrary';
Stack() {
    GridHybridComponent()
}

// EntryAbility.ets
import { GridHybridController } from '@ohos_samples/gridhybridlibrary';
onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        Logger.error(TAG, `Failed to load the content, code: ${err.code}, message: ${err.message}}.`);
        return;
      }
      GridHybridController.initWindowConfig(windowStage);
    });
}
```