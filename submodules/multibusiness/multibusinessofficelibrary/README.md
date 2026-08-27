## 多设备商务办公

### 介绍

本示例主要使用断点监听和sidebarContainer组件、navigation组件相结合的方式，实现了商务办公类差异化的多场景响应式变化效果。

### 下载安装

使用ohpm安装依赖

```
ohpm install @ohos_samples/multibusinessofficelibrary
```

或者按需在模块中修改oh-package.json5

```
{
  "dependencies": {
     "@ohos_samples/multibusinessofficelibrary": "^1.0.0"
  }
}
```

### 使用说明

```
import { MultiBusinessOfficeComponent, BusinessOfficeController } from '@ohos_samples/multibusinessofficelibrary';
```
按需在文件中使用导出模块即可，其中MultiBusinessOfficeComponent是整个sample的入口页面。点击备忘录或日历按钮，打开备忘录或日历实例页面。BusinessOfficeController封装了沉浸式、设备断点判断、避让区域计算等窗口能力。示例如下：
```
// Index.ets
import { MultiBusinessOfficeComponent } from '@ohos_samples/multibusinessofficelibrary';
Stack() {
  MultiBusinessOfficeComponent()
}

// EntryAbility.ets
import { BusinessOfficeController } from '@ohos_samples/multibusinessofficelibrary';
// onWindowStageCreate回调里的loadContent方法里初始化
BusinessOfficeController.initWindowConfig(windowStage);
```