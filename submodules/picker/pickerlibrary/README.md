## 实现选择和查看文件功能

### 介绍

应用实现了拉起文档编辑保存、拉起系统相册图片查看、拉起视频并播放的功能。

### 下载安装

使用ohpm安装依赖

```
ohpm install @ohos_samples/pickerlibrary
```

或者按需在模块中修改oh-package.json5

```
{
  "dependencies": {
     "@ohos_samples/pickerlibrary": "^1.0.0"
  }
}
```

### 使用说明

```
import { PickerComponent } from '@ohos_samples/pickerlibrary';
```
按需在文件中使用导出模块即可，其中PickerComponent是整个sample的入口页面。示例如下：
```
// Index.ets
import { PickerComponent } from '@ohos_samples/pickerlibrary';
Stack() {
    PickerComponent()
}

// EntryAbility.ets
import { PickerController } from '@ohos_samples/pickerlibrary';

onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        Logger.error(TAG, `Failed to load the content, err code: ${err.code}, message: ${err.message}`);
        return;
      }
      PickerController.initWindowConfig(windowStage);
    });
}
```