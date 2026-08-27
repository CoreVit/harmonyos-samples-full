## AI文档扫描

### 介绍

本示例展示了使用视觉类AI能力中的文档扫描能力。

本示例模拟了在应用里，跳转文档扫描控件，获取到扫描结果并展示出来。

需要使用文档扫描验证接口@hms.ai.DocumentScanner.d.ets。

### 下载安装

使用ohpm安装依赖

```
ohpm install @ohos_samples/documentscanlibrary
```

或者按需在模块中修改oh-package.json5

```
{
  "dependencies": {
     "@ohos_samples/documentscanlibrary": "^1.0.0"
  }
}
```

### 使用说明

```
import { MainPageComponent, DocScanController } from '@ohos_samples/documentscanlibrary';
```
按需在文件中使用导出模块即可，其中MainPageComponent是整个sample的入口页面。DocScanController初始化了沉浸式、设备断点判断、避让区域计算等窗口能力。示例如下：
```
// Index.ets
import { MainPageComponent } from '@ohos_samples/documentscanlibrary';
Stack() {
  MainPageComponent()
}

// EntryAbility.ets
import { DocScanController } from '@ohos_samples/documentscanlibrary';
// onWindowStageCreate回调里的loadContent方法里初始化
DocScanController.initWindowConfig(windowStage);
```