## 基于Share Kit实现碰一碰视频快速分享

### 介绍

本示例利用Share Kit，实现了快速跨设备分享在线视频链接并直接进入浏览器内播放的功能。通过harmonyShare.on()
方法注册碰一碰监听事件，并在回调中使用sharableTarget.share()方法分享在线视频链接，从而提供了一步直达的流畅用户体验。

### 下载安装

使用ohpm安装依赖

```
ohpm install @ohos_samples/knocksharelibrary
```

或者按需在模块中修改oh-package.json5

```
{
  "dependencies": {
     "@ohos_samples/knocksharelibrary": "^1.0.0"
  }
}
```

### 使用说明

```
import { KnockShareComponent, KnockShareController } from '@ohos_samples/knocksharelibrary';
```
按需在文件中使用导出模块即可，其中KnockShareComponent是整个sample的入口页面。示例如下：
```
// Index.ets
import { KnockShareComponent } from '@ohos_samples/knocksharelibrary';
Stack() {
  KnockShareComponent()
}
```