## 一次开发，多端部署-便捷生活

### 简介

本篇Sample基于自适应布局和响应式布局，实现一次开发，多端部署的便捷生活页面，并根据手机、折叠屏、平板以及2in1不同的设备尺寸实现对应页面。

### 下载安装

使用ohpm安装依赖

```
ohpm install @ohos_samples/multiconvenientlifelibrary
```

或者按需在模块中修改oh-package.json5

```
{
  "dependencies": {
     "@ohos_samples/multiconvenientlifelibrary": "^1.0.0"
  }
}
```

### 使用说明

```
import { ConvenientLifeComponent, ConvenientLifeController } from '@ohos_samples/multiconvenientlifelibrary';
```

按需在文件中使用导出模块即可，其中Home是整个sample的入口页面。示例如下：

```
// Index.ets
import { ConvenientLifeComponent } from '@ohos_samples/multiconvenientlifelibrary';
Stack() {
  ConvenientLifeComponent()
}

// EntryAbility.ets
import { ConvenientLifeController } from '@ohos_samples/multiconvenientlifelibrary';
ConvenientLifeController.initWindowConfig(windowStage);
```