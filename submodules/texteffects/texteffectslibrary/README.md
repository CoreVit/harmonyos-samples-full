## 文字特效合集

### 介绍

本示例基于Text组件及通用属性实现多种文字特效。帮助开发者在ArkTS原生页面开发中实现文字渐变、歌词滚动、文字倒影、跑马灯渐变等多种文字效果。

### 下载安装

使用ohpm安装依赖

```
ohpm install @ohos_samples/texteffectslibrary
```

或者按需在模块中修改oh-package.json5

```
{
  "dependencies": {
     "@ohos_samples/texteffectslibrary": "^1.0.0"
  }
}
```

### 使用说明

```
import { TextEffectsComponent, TextEffectsController } from '@ohos_samples/texteffectslibrary';
```
按需在文件中使用导出模块即可，其中TextEffectsComponent是整个sample的入口页面组件。启动应用，查看多种文字特效，包含文字渐变、歌词滚动、文字倒影、跑马灯渐变等效果。TextEffectsController初始化了沉浸式、设备断点判断、避让区域计算等窗口能力。示例如下：
```
// Index.ets
import { TextEffectsComponent } from '@ohos_samples/texteffectslibrary';
Stack() {
  TextEffectsComponent()
}

// EntryAbility.ets
import { TextEffectsController } from '@ohos_samples/texteffectslibrary';
// onWindowStageCreate回调里的loadContent方法里初始化
TextEffectsController.initWindowConfig(windowStage);
```