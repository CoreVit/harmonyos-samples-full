## 实现发布图片评论功能

### 介绍

本示例通过拉起系统相机实现发布图片评论，便于用户了解系统相机接口的调用方式。

### 下载安装

使用ohpm安装依赖

```
ohpm install @ohos_samples/imagecommentlibrary
```

或者按需在模块中修改oh-package.json5

```
{
  "dependencies": {
     "@ohos_samples/imagecommentlibrary": "^1.0.0"
  }
}
```

### 使用说明

```
import { ImageCommentComponent } from '@ohos_samples/imagecommentlibrary';
```
按需在文件中使用导出模块即可，其中ImageCommentComponent是整个sample的入口页面。示例如下：
```
// Index.ets
import { ImageCommentComponent } from '@ohos_samples/imagecommentlibrary';
Stack() {
    ImageCommentComponent()
}

// EntryAbility.ets
import { ImageCommentController } from '@ohos_samples/imagecommentlibrary';
onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        Logger.error(TAG, `Failed to load the content. Cause: ${JSON.stringify(err.message)}`);
        return;
      }
      ImageCommentController.initWindowConfig(windowStage);
    });
}
```