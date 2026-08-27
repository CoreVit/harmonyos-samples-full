## 基于Tabs组件实现常见导航样式

### 介绍

Tabs组件可以让用户能聚焦于当前显示的内容，对页面内容进行分类，提高页面空间利用率。本示例基于Tabs组件，为开发者提供不同场景下的导航样式，如：常见底部导航、舵式底部导航、可滑动+更多按钮样式、侧边导航等。

### 下载安装

使用ohpm安装依赖

```
ohpm install @ohos_samples/multitabnavigationlibrary
```

或者按需在模块中修改oh-package.json5

```
{
  "dependencies": {
     "@ohos_samples/multitabnavigationlibrary": "^1.0.0"
  }
}
```

### 使用说明

```
import { MultiTabNavigationComponent } from '@ohos_samples/multitabnavigationlibrary';
```

按需在文件中使用导出模块即可，其中MultiTabNavigationComponent是整个sample的入口页面。示例如下：

```
// Index.ets
import { MultiTabNavigationComponent } from '@ohos_samples/multitabnavigationlibrary';
Stack() {
    MultiTabNavigationComponent()
}

// EntryAbility.ets
import { MultiTabNavigationController } from '@ohos_samples/multitabnavigationlibrary';
onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        Logger.error(TAG, `Failed to load the content, err code: ${err.code}, message: ${err.message}`);
        return;
      }
      MultiTabNavigationController.initWindowConfig(windowStage);
    });
}
```