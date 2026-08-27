## 实现软键盘弹出功能

### 介绍

本示例展示了输入框分别在屏幕顶部和底部时软键盘弹出对页面布局的影响。

### 下载安装

使用ohpm安装依赖

```
ohpm install @ohos_samples/keyboardlibrary
```

或者按需在模块中修改oh-package.json5

```
{
  "dependencies": {
     "@ohos_samples/keyboardlibrary": "^1.0.0"
  }
}
```

### 使用说明

```
import { KeyboardComponent } from '@ohos_samples/keyboardlibrary';
```
按需在文件中使用导出模块即可，其中KeyboardComponent是整个sample的入口页面。示例如下：
```
// Index.ets
import { KeyboardComponent } from '@ohos_samples/keyboardlibrary';
Stack() {
    KeyboardComponent()
}

// EntryAbility.ets
import { KeyboardController } from '@ohos_samples/keyboardlibrary';
onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', `Failed to load the content, err code: ${err.code}, message: ${err.message}`);
        return;
      }
      KeyboardController.initWindowConfig(windowStage);
    });
}
```