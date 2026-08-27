## web页面瞬开

### 介绍

本示例基于预渲染技术，实现了点击后Web页面瞬间打开的效果，无需额外加载过程，减少用户等待时长，提高了用户体验。

### 下载安装

使用ohpm安装依赖

```
ohpm install @ohos_samples/webprerenderlibrary
```

或者按需在模块中修改oh-package.json5

```
{
  "dependencies": {
     "@ohos_samples/webprerenderlibrary": "^1.0.0"
  }
}
```

### 使用说明

```
import { WebPreRenderComponent, WebPrerenderController } from '@ohos_samples/webprerenderlibrary';
```
按需在文件中使用导出模块即可，其中WWebPreRenderComponent是整个sample的入口页面组件。WebPrerenderController初始化沉浸式、设备断点判断、避让区域计算等窗口能力。示例如下：
```
// Index.ets
import { WebPreRenderComponent } from '@ohos_samples/webprerenderlibrary';
Stack() {
  WebPreRenderComponent()
}

// EntryAbility.ets
import { WebPrerenderController } from '@ohos_samples/webprerenderlibrary';
// onWindowStageCreate回调里的loadContent方法里初始化
WebPrerenderController.initWindowConfig(windowStage, this);
```