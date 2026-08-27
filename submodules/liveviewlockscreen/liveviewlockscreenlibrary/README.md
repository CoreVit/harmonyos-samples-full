# 锁屏沉浸实况窗

### 介绍

本示例主要使用LiveViewKit和公共事件功能，实现了锁屏沉浸实况窗的创建。

### 下载安装

使用ohpm安装依赖

```
ohpm install @ohos_samples/liveviewlockscreenlibrary
```

或者按需在模块中修改oh-package.json5

```
{
  "dependencies": {
     "@ohos_samples/liveviewlockscreenlibrary": "^1.0.0"
  }
}
```

### 使用说明

```
import { LiveViewLockScreenPage, BundleNameUtil, WindowUtil } from '@ohos_samples/liveviewlockscreenlibrary';
```

按需在文件中使用导出模块即可，其中IndexComponent是整个sample的入口页面，进入Sample后如果有实况窗和锁屏沉浸实况窗权限，会自动创建实况窗和锁屏沉浸实况窗LockScreenComponent；点击停止导航，会关闭实况窗和锁屏沉浸实况窗，点击继续导航，会重新创建实况窗和锁屏沉浸实况窗。LiveViewLockScreenController封装了获取包名的功能，已经沉浸式、设备断点判断、避让区域计算等窗口能力。示例如下：
```
// Index.ets
import { IndexComponent } from '@ohos_samples/liveviewlockscreenlibrary';
Stack() {
  IndexComponent()
}

// LockScreen.ets
import { LockScreenComponent } from '@ohos_samples/liveviewlockscreenlibrary';
Stack() {
  LockScreenComponent()
}

// EntryAbility.ets
import { LiveViewLockScreenController } from '@ohos_samples/liveviewlockscreenlibrary';
onCreate(): void {
  LiveViewLockScreenController.saveBundleName();
}
onWindowStageCreate(windowStage: window.WindowStage): void {
  windowStage.loadContent('pages/Index', (error) => {
    if (error.code) {
      hilog.error(0x0000, TAG, '%{public}s',
        `Failed to load the content. Cause code: ${error.code}, message: ${error.message}`);
      return;
    }
    LiveViewLockScreenController.initWindowConfig(windowStage);
    hilog.info(0x0000, TAG, '%{public}s', 'Succeeded in loading the content.');
  });
}

// LiveViewExtAbility.ets
import { LiveViewLockScreenController } from 'liveviewlockscreenlibrary';
onSessionCreate(_want: Want, session: UIExtensionContentSession): void {
  LiveViewLockScreenController.initLiveView(session);
  try {
      session.loadContent('pages/LockScreen');
    } catch (error) {
      hilog.error(0x0000, TAG, '%{public}s',
        `Session load content fail. code is ${(error as BusinessError).code} message is ${(error as BusinessError).message}`);
    }
}
onSessionDestroy(): void {
  LiveViewLockScreenController.destroyLLiveView();
}
```