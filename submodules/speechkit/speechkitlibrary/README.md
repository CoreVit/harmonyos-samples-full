## Speech Kit

### 介绍

本示例模拟了在应用里，通过点击朗读听筒，跳转朗读控件播放面板并对文章进行朗读的场景。

### 下载安装

使用ohpm安装依赖

```
ohpm install @ohos_samples/speechkitlibrary
```

或者按需在模块中修改oh-package.json5

```
{
  "dependencies": {
     "@ohos_samples/speechkitlibrary": "^1.0.0"
  }
}
```

### 使用说明

```
import { SpeechKitComponent } from '@ohos_samples/speechkitlibrary';
```
按需在文件中使用导出模块即可，其中SpeechKitComponent是整个sample的入口页面。示例如下：
```
// Index.ets
import { SpeechKitComponent } from '@ohos_samples/speechkitlibrary';
Stack() {
    SpeechKitComponent()
}

// EntryAbility.ets
import { SpeechKitController } from '@ohos_samples/speechkitlibrary';
onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        Logger.error(TAG, `Failed to load the content, err code: ${err.code}, message: ${err.message}`);
        return;
      }
      SpeechKitController.initWindowConfig(windowStage);
    });
}
```