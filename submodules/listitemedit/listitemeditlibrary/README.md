## 列表编辑效果

### 介绍

本示例基于List组件，实现待办事项管理、文件管理、备忘录的等场景列表编辑效果。

### 下载安装

使用ohpm安装依赖

```
ohpm install @ohos_samples/listitemeditlibrary
```

或者按需在模块中修改oh-package.json5

```
{
  "dependencies": {
     "@ohos_samples/listitemeditlibrary": "^1.0.0"
  }
}
```

### 使用说明

```
import { ListItemEditComponent } from '@ohos_samples/listitemeditlibrary';
```
按需在文件中使用导出模块即可，其中ListItemEditComponent是整个sample的入口页面。示例如下：
```
// Index.ets
import { ListItemEditComponent } from '@ohos_samples/listitemeditlibrary';
Stack() {
    ListItemEditComponent()
}

// EntryAbility.ets
import { ListItemEditController } from '@ohos_samples/listitemeditlibrary';
onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        Logger.error(TAG, `Failed to load the content, err code: ${err.code}, message: ${err.message}`);
        return;
      }
      ListItemEditController.initWindowConfig(windowStage);
    });
}
```