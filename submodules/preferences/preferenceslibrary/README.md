## 首选项

### 介绍

本示例主要展示首选项功能的使用。

### 下载安装

使用ohpm安装依赖

```
ohpm install @ohos_samples/preferenceslibrary
```

或者按需在模块中修改oh-package.json5

```
{
  "dependencies": {
     "@ohos_samples/preferenceslibrary": "^1.0.1"
  }
}
```

### 使用说明

```
import { PreferencesComponent, PreferenceController } from '@ohos_samples/preferenceslibrary';
```
按需在文件中使用导出模块即可，其中PreferencesComponent是整个sample的入口组件，PreferenceControllery用来设置窗口初始化属性，包括沉浸式、断点 。示例如下：
```
// Page.ets
import { PreferencesComponent } from '@ohos_samples/preferenceslibrary';
Stack() {
  PreferencesComponent()
}

// EntryAbility.ets
import { PreferenceController } from '@ohos_samples/preferenceslibrary';
// onWindowStageCreate()的loadContent方法里初始化窗口
PreferenceController.initWindowConfig(windowStage);
```