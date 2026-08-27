## 多设备新闻阅读

### 介绍

本示例基于自适应布局和响应式布局，实现一次开发，多端部署的新闻阅读页面。根据手机、折叠屏以及平板不同的设备尺寸实现对应页面。

### 下载安装

使用ohpm安装依赖

```
ohpm install @ohos_samples/multinewsreadlibrary
```

或者按需在模块中修改oh-package.json5

```
{
  "dependencies": {
     "@ohos_samples/multinewsreadlibrary": "^1.0.0"
  }
}
```

### 使用说明

```
import { MultiNewsReadComponent, NewsReadController } from '@ohos_samples/multinewsreadlibrary';
```
按需在文件中使用导出模块即可，其中MultiNewsReadComponent是整个sample的入口页面。NewsReadController初始化了沉浸式、设备断点判断、避让区域计算等窗口能力。示例如下：
```
// Index.ets
import { MultiNewsReadComponent } from '@ohos_samples/multinewsreadlibrary';
Stack() {
  MultiNewsReadComponent()
}

// EntryAbility.ets
import { NewsReadController } from '@ohos_samples/multinewsreadlibrary';
// onWindowStageCreate回调里的loadContent方法里初始化
NewsReadController.initWindowConfig(windowStage);
```