## 列表项交换案例

### 介绍

本示例介绍了如何通过组合手势结合List组件，来实现对List组件中列表项的交换排序。

### 下载安装

使用ohpm安装依赖

```
ohpm install @ohos_samples/listexchangelibrary
```

或者按需在模块中修改oh-package.json5

```
{
  "dependencies": {
     "@ohos_samples/listexchangelibrary": "^1.0.0"
  }
}
```

### 使用说明

```
import { ListExchangeComponent } from '@ohos_samples/listexchangelibrary';
```
按需在文件中使用导出模块即可，其中ListExchangeComponent是整个sample的入口页面。示例如下：
```
// Index.ets
import { ListExchangeComponent } from '@ohos_samples/listexchangelibrary';
Stack() {
    ListExchangeComponent()
}

// EntryAbility.ets
import { ListExchangeController } from '@ohos_samples/gridhybridlibrary';
onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        Logger.error(TAG, `Failed to load the content, err code: ${err.code}, message: ${err.message}`);
        return;
      }
      ListExchangeController.initWindowConfig(windowStage);
    });
}
```