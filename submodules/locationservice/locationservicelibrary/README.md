## 基于位置服务获取设备定位信息

### 介绍

本示例通过@kit.LocationKit中的geoLocationManager实现获取缓存位置、获取当前位置功能。

### 下载安装

使用ohpm安装依赖

```
ohpm install locationservicelibrary
```

或者按需在模块中修改oh-package.json5

```
{
  "dependencies": {
     "locationservicelibrary": "^1.0.1"
  }
}
```

### 需要权限

权限已在Har包中定义

```
ohos.permission.LOCATION
```
```
ohos.permission.APPROXIMATELY_LOCATION
```
```
ohos.permission.GET_NETWORK_INFO
```


### 使用说明

LocationServiceComponent是UI组件入口，可以在页面中直接引用

```
import { LocationServiceComponent } from 'locationservicelibrary'

@Entry
@Component
struct Index {
  build() {
    Stack() {
      LocationServiceComponent()
    }
  }
}
```

LocationServiceController中定义了initWindowConfig方法，用于适配页面沉浸式、多设备布局

```
onWindowStageCreate(windowStage: window.WindowStage): void {
  // Main window is created, set main page for this ability
  hilog.info(0x0000, TAG, '%{public}s', 'Ability onWindowStageCreate');
  LocationServiceController.initWindowConfig(windowStage)
  windowStage.loadContent('pages/Index', (error: BusinessError) => {
    if (error.code) {
      hilog.error(0x0000, TAG, '%{public}s',
        `Failed to load the content. code: ${error.code}, message: ${error.message}`);
      return;
    }
    hilog.info(0x0000, TAG, '%{public}s', 'Succeeded in loading the content.');
  });
}
```