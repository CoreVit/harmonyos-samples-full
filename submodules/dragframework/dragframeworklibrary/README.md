## 实现组件的自定义拖拽

### 介绍


### 下载安装

使用ohpm安装依赖

```
ohpm install @ohos_samples/dragframeworklibrary
```

或者按需在模块中修改oh-package.json5

```
{
  "dependencies": {
     "@ohos_samples/dragframeworklibrary": "^1.0.0"
  }
}
```

### 使用说明

```
import { DragFrameworkComponent, DragFrameController } from '@ohos_samples/dragframeworklibrary';
```
按需在文件中使用导出模块即可，其中DragFrameworkComponent是整个sample的入口页面。示例如下：
```
// Index.ets
import { DragFrameworkComponent } from '@ohos_samples/dragframeworklibrary';
Stack() {
  DragFrameworkComponent()
}

// EntryAbility.ets
// onCreate回调里注册subscribeEvent
 onCreate(want: Want): void {
    DragFrameController.subscribeEvent(this.context, want);
  }
import { DragFrameController } from '@ohos_samples/dragframeworklibrary';
// onWindowStageCreate回调里的loadContent方法里初始化
DragFrameController.initWindowConfig(windowStage);
```