## 多设备分级导航栏

### 介绍

本示例基于自适应布局和响应式布局，实现多设备上的分级导航栏效果。

### 下载安装

使用ohpm安装依赖

```
ohpm install @ohos_samples/multinavbarlibrary
```

或者按需在模块中修改oh-package.json5

```
{
  "dependencies": {
     "@ohos_samples/multinavbarlibrary": "^1.0.0"
  }
}
```

### 使用说明

```
import { MultiNavBarComponent, NavBarController } from '@ohos_samples/multinavbarlibrary';
```
按需在文件中使用导出模块即可，其中MultiNavBarComponent是整个sample的入口页面组件。NavBarController封装了沉浸式、设备断点判断、避让区域计算等窗口能力。示例如下：
```
// Index.ets
import { MultiNavBarComponent } from '@ohos_samples/multinavbarlibrary';
Stack() {
  MultiNavBarComponent()
}

// EntryAbility.ets
import { NavBarController } from '@ohos_samples/multinavbarlibrary';
// onWindowStageCreate回调里的loadContent方法里初始化
NavBarController.initWindowConfig(windowStage);
```