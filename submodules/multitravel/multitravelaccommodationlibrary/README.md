## 多设备旅行订票界面

### 介绍

本示例主要使用栅格布局和List组件相结合的方式，实现了旅行住宿差异化的多场景响应式变化效果。

### 下载安装

使用ohpm安装依赖

```
ohpm install @ohos_samples/multitravelaccommodationlibrary
```

或者按需在模块中修改oh-package.json5

```
{
  "dependencies": {
     "@ohos_samples/multitravelaccommodationlibrary": "^1.0.1"
  }
}
```

### 使用说明

```
import { TravelAccommodationComponent, TravelAccController } from '@ohos_samples/multitravelaccommodationlibrary';
```

按需在文件中使用导出模块即可，其中TravelAccommodationComponent是整个sample的入口页面。点击酒店详情页及低价日历按钮，会跳转至酒店详情页；点击查询车票页，跳转至车票页面。TravelAccController初始化了沉浸式、设备断点判断、避让区域计算等窗口能力。示例如下：

```
// Index.ets
import { TravelAccommodationComponent } from '@ohos_samples/multitravelaccommodationlibrary';
Stack() {
  TravelAccommodationComponent()
}

// EntryAbility.ets
import { TravelAccController } from '@ohos_samples/multitravelaccommodationlibrary';
// onWindowStageCreate回调里的loadContent方法里初始化
TravelAccController.initWindowConfig(windowStage);
```