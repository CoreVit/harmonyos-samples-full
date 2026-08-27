# 锁屏沉浸实况窗

### 介绍

本示例主要通过设置组件的属性来控制屏幕刷新率，达到低功耗的目的，实现了文章和媒体文件浏览的功能。

### 下载安装

使用ohpm安装依赖

```
ohpm install @ohos_samples/fluentbloglibrary
```

或者按需在模块中修改oh-package.json5

```
{
  "dependencies": {
     "@ohos_samples/fluentbloglibrary": "^1.0.0"
  }
}
```

### 使用说明

```
import { FluentBlogComponent, FluentBlogController } from '@ohos_samples/fluentbloglibrary';
```

按需在文件中使用导出模块即可，其中FluentBlogComponent是整个sample的入口页面，进入Sample后可以浏览文字好媒体文件，点击视频可以进入视频播放页面。FluentBlogController封装了沉浸式、设备断点判断、避让区域计算等窗口能力。示例如下：
```
// Index.ets
import { FluentBlogComponent } from '@ohos_samples/fluentbloglibrary';
Stack() {
  FluentBlogComponent()
}

// EntryAbility.ets
import { FluentBlogController } from '@ohos_samples/fluentbloglibrary';
onWindowStageCreate(windowStage: window.WindowStage): void {
  windowStage.loadContent('pages/Index', (err, _) => {
    if (err.code) {
      hilog.error(0x0000, TAG, 'Failed to load the content. Cause:', err.message);
      return;
    }
    FluentBlogController.initWindowConfig(windowStage);
    hilog.info(0x0000, TAG, '%{public}s', 'Succeeded in loading the content');
  });
}
```