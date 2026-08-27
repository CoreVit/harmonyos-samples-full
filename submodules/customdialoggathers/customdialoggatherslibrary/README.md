## 实现多种自定义弹窗的效果

### 介绍

本示例通过CustomDialog、bindContentCover、bindSheet等接口，实现多种样式的弹窗。帮助开发者掌握自定义弹窗开发的步骤，灵活的实现自己业务需要用到的弹窗场景。

### 下载安装

使用ohpm安装依赖

```
ohpm install @ohos_samples/customdialoggatherslibrary
```

或者按需在模块中修改oh-package.json5

```
{
  "dependencies": {
     "@ohos_samples/customdialoggatherslibrary": "^1.0.0"
  }
}
```

### 使用说明

```
import { CustomDialogGathersComponent } from '@ohos_samples/customdialoggatherslibrary';
```
按需在文件中使用导出模块即可，其中CustomDialogGathersComponent是整个sample的入口页面。示例如下：
```
// Index.ets
import { CustomDialogGathersComponent } from '@ohos_samples/customdialoggatherslibrary';
Stack() {
    CustomDialogGathersComponent()
}

// EntryAbility.ets
import { CustomDialogGathersController } from '@ohos_samples/customdialoggatherslibrary';
onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/Index', (err, data) => {
      if (err.code) {
        Logger.error(TAG, `Failed to load the content, err code: ${err.code}, message: ${err.message}`);
        return;
      }
      CustomDialogGathersController.initWindowConfig(windowStage);
    });
}
```