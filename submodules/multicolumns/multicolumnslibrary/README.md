## 多设备分栏控件

### 介绍

本示例分别展示了多场景下，一多分栏控件的响应式变化效果。

本示例分别用到了SideBarContainer组件与Navigation组件，对应使用场景如下：

A+B+C：即SideBarContainer组件组合Navigation组件
A+C：SideBarContainer组件
B+C：Navigation组件

### 下载安装

使用ohpm安装依赖

```
ohpm install @ohos_samples/multicolumnslibrary
```

或者按需在模块中修改oh-package.json5

```
{
  "dependencies": {
     "@ohos_samples/multicolumnslibrary": "^1.0.0"
  }
}
```

### 使用说明

```
import { MultiColumnsView, MultiColumnController } from '@ohos_samples/multicolumnslibrary';
```
按需在文件中使用导出模块即可，其MultiColumnsView是整个sample的入口页面组件。MultiColumnController初始化了沉浸式、设备断点判断、避让区域计算等窗口能力。示例如下：
```
// Index.ets
import { MultiColumnsView } from '@ohos_samples/multicolumnslibrary';
Stack() {
  MultiColumnsView()
}

// EntryAbility.ets
import { MultiColumnController } from '@ohos_samples/multicolumnslibrary';
// onWindowStageCreate回调里的loadContent方法里初始化
MultiColumnController.initWindowConfig(windowStage);
```