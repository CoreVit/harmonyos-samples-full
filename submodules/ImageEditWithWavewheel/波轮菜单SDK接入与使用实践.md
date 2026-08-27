# 波轮菜单SDK接入与使用实践

## 概述

波轮菜单（WaveWheel）是一种创新的交互组件，通过轻捏手写笔唤出环形菜单，为用户提供快捷操作入口。在图片编辑应用中，开发者可以通过波轮菜单快速切换裁剪、滤镜、调节等编辑模式，提升操作效率。

波轮菜单SDK提供了完整的波轮菜单功能封装，开发者只需简单的接入步骤即可在应用中集成波轮菜单功能。SDK的主要特性包括：

- **手写笔交互**：通过轻捏手写笔唤出菜单。
- **半模态子窗展示**：菜单以半模态子窗形式展示，不影响主界面。
- **多设备适配**：自动适配手机、折叠屏、平板等多种设备。
- **灵活配置**：支持动态配置菜单选项、图标、回调函数。
- **深色模式**：自动适配系统深色模式。

本文主要面向中级HarmonyOS开发者。在开始之前，建议已了解ArkTS语法基础、ArkUI组件开发、窗口管理基础，并准备好DevEco Studio 6.0.0及以上版本的开发环境。

本文主要内容如下：

1. **环境准备**：介绍系统要求、设备要求和手写笔适配
2. **SDK接入**：讲解SDK的初始化和基本配置
3. **菜单配置**：说明如何定义菜单选项和设置回调
4. **生命周期管理**：介绍SDK的启动和停止
5. **高级功能**：讲解菜单设置界面和深色模式适配
6. **常见问题**：解答接入过程中的常见问题

### 效果预览

| 手机                                         | 双折叠                                            | 平板                                          |
| ------------------------------------------ | ---------------------------------------------- | ------------------------------------------- |
| ![手机效果](./screenshots/device/phone_cn.png) | ![双折叠效果](./screenshots/device/foldable_cn.png) | ![平板效果](./screenshots/device/tablet_cn.png) |

## 环境准备

### 系统要求

波轮菜单SDK对系统环境有以下要求：

| 要求项           | 版本要求                           |
| ------------- | ------------------------------ |
| HarmonyOS系统   | HarmonyOS 6.0.0 Release及以上     |
| DevEco Studio | DevEco Studio 6.0.0 Release及以上 |
| HarmonyOS SDK | API 19及以上                      |

### 设备要求

波轮菜单功能依赖手写笔交互，需要确保设备支持手写笔功能。支持设备类型包括：

- 直板机
- 双折叠
- 三折叠
- 平板

### 手写笔适配

手写笔及适配机型请查看以下官方文档：

- [华为手机支持的手写笔设备清单](https://consumer.huawei.com/cn/support/content/zh-cn15869694/)
- [华为手写笔与平板/笔记本电脑适配清单](https://consumer.huawei.com/cn/support/content/zh-cn00737675/)

## SDK接入

### 场景描述

SDK接入主要包括导入SDK模块、获取控制器实例、初始化控制器三个步骤。控制器采用单例模式，确保全局唯一实例。

### 实现原理

WaveWheelController是SDK的核心控制器，负责管理菜单选项、处理手写笔事件、控制子窗生命周期。开发者通过控制器提供的API完成SDK的初始化、配置和使用。

关键API介绍：

- **getInstance()**：获取控制器单例实例
- **init(windowStage)**：初始化控制器，绑定WindowStage
- **start()**：启动手写笔事件监听
- **stop()**：停止手写笔事件监听

### 开发步骤

1. 导入SDK模块：在需要使用波轮菜单的文件中导入控制器和类型定义。

```arkts
import type { SimpleWaveWheelOption, WaveWheelCallback } from 'wavewheel';
import { WaveWheelController } from 'wavewheel';
```

2. 获取控制器实例：使用getInstance()方法获取全局唯一的控制器实例。

```arkts
let controller = WaveWheelController.getInstance();
```

3. 初始化控制器：在EntryAbility的onWindowStageCreate中初始化控制器，传入WindowStage参数。

```arkts
export default class EntryAbility extends UIAbility {
  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    // Initialize WaveWheel controller
    let controller = WaveWheelController.getInstance();
    controller.init(windowStage);
    
    // Set dark mode based on current configuration
    controller.setDarkMode(
      this.context.config.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK
    );
  }
}
```

4. 配置深色模式响应：在onConfigurationUpdate中更新深色模式状态。

```arkts
onConfigurationUpdate(newConfig: Configuration): void {
  WaveWheelController.getInstance()
    .setDarkMode(newConfig.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
}
```

## 菜单配置

### 场景描述

菜单配置包括定义菜单选项和设置回调函数两部分。菜单选项定义菜单的外观（图标、标题），回调函数定义菜单的行为（点击后执行的操作）。

### 实现原理

SDK使用SimpleWaveWheelOption定义菜单选项的基本属性，使用WaveWheelCallback定义菜单点击回调。通过setWaveWheelOptionsBySimple()方法将选项和回调关联起来。

数据结构介绍：

- **SimpleWaveWheelOption**：菜单选项定义，包含id、title、icon、enable等属性
- **WaveWheelCallback**：回调函数类型，参数为(id: string, x: number, y: number)

### 开发步骤

1. 定义菜单选项：创建SimpleWaveWheelOption数组，定义所有可用的菜单选项。

```arkts
export default class WaveWheelConstants {
  public static readonly waveWheelOptions: SimpleWaveWheelOption[] = [
    {
      id: 'crop',
      title: $r('app.string.wheel_crop'),
      icon: $r('app.media.wavewheel_crop'),
      useSysImg: false,
      enable: true
    },
    {
      id: 'brightness',
      title: $r('app.string.wheel_brightness'),
      icon: $r('app.media.wavewheel_brightness'),
      useSysImg: false,
      enable: true
    },
    {
      id: 'transparency',
      title: $r('app.string.wheel_transparency'),
      icon: $r('app.media.wavewheel_transparency'),
      useSysImg: false,
      enable: true
    }
  ];
}
```

2. 创建回调函数：为每个菜单选项创建对应的回调函数，定义点击后的行为。

```arkts
private createWaveWheelCallback(key: string, mode: EditMode): WaveWheelCallback {
  return (id: string, x: number, y: number) => {
    // Handle menu item click
    this.handleModeChange(mode);
  };
}
```

3. 设置菜单选项和回调：使用setWaveWheelOptionsBySimple()方法将选项和回调关联。

```arkts
private initWaveWheel(): void {
  // Create callback map
  const id2callback: Map<string, WaveWheelCallback> = new Map();
  
  // Set callbacks for each option
  id2callback.set('crop', this.createWaveWheelCallback('crop', EditMode.CROP_MODE));
  id2callback.set('brightness', this.createWaveWheelCallback('brightness', EditMode.ADJUST_MODE));
  id2callback.set('transparency', this.createWaveWheelCallback('transparency', EditMode.ADJUST_MODE));
  
  // Set options and callbacks to controller
  const totalOptions = this.wavewheelController.setWaveWheelOptionsBySimple(
    this.simpleWaveWheelOptions, 
    id2callback
  );
}
```

4. 设置空选项回调：当用户未配置任何菜单选项时，可以设置空选项回调进行提示。

```arkts
private emptyOptionCallback = (_: stylusInteraction.SqueezeEvent): void => {
  // Show dialog to guide user to configure options
  this.showEmptyOptionDialog();
};

private initWaveWheel(): void {
  // ... set options and callbacks
  this.wavewheelController.setEmptyOptionCallback(this.emptyOptionCallback);
}
```

## 生命周期管理

### 场景描述

SDK需要在合适的时机启动和停止手写笔事件监听。通常在页面显示时启动监听，在页面隐藏时停止监听。

### 实现原理

控制器通过start()方法启动手写笔事件监听，通过stop()方法停止监听。在页面生命周期中正确调用这两个方法，确保SDK正常工作。

### 开发步骤

1. 启动监听：在页面的aboutToAppear中调用start()方法。

```arkts
@Component
export struct PictureEdit {
  private wavewheelController: WaveWheelController = WaveWheelController.getInstance();
  
  aboutToAppear(): void {
    // Initialize wave wheel configuration
    this.initWaveWheel();
    // Start listening for stylus events
    this.wavewheelController.start();
  }
}
```

2. 停止监听：在页面的aboutToDisappear中调用stop()方法。

```arkts
aboutToDisappear(): void {
  // Stop listening for stylus events
  this.wavewheelController?.stop();
}
```

## 高级功能

### 菜单设置界面

**场景描述**

SDK支持运行时动态修改菜单选项，开发者可以提供设置界面让用户自定义菜单内容和顺序。

**实现原理**

使用@StorageLink装饰器将菜单选项与AppStorage同步，实现跨组件状态共享。设置界面修改选项后，通过AppStorage通知控制器更新菜单。

**开发步骤**

1. 使用@StorageLink同步菜单选项：在设置界面和主页面中使用相同的key同步选项数据。

```arkts
@Component
struct WaveWheelSettingView {
  @StorageLink('simpleWaveWheelOptions') simpleWaveWheelOptions: SimpleWaveWheelOption[] = [];
  
  // Modify options and sync to AppStorage
  saveOptions(): void {
    // Update simpleWaveWheelOptions array
    // Changes will automatically sync to AppStorage
  }
}
```

2. 在主页面监听选项变化：使用@StorageLink接收设置界面的修改。

```arkts
@Component
export struct PictureEdit {
  @StorageLink('simpleWaveWheelOptions') simpleWaveWheelOptions: SimpleWaveWheelOption[] = [];
  
  // Re-initialize wave wheel when options change
  initWaveWheel(): void {
    const id2callback: Map<string, WaveWheelCallback> = new Map();
    // ... setup callbacks
    this.wavewheelController.setWaveWheelOptionsBySimple(this.simpleWaveWheelOptions, id2callback);
  }
}
```

### 深色模式适配

**场景描述**

SDK支持深色模式自动适配，开发者需要在系统颜色模式变化时通知控制器更新。

**实现原理**

控制器提供setDarkMode()方法，开发者监听系统配置变化并调用该方法更新菜单样式。

**开发步骤**

1. 在EntryAbility中监听配置变化：在onConfigurationUpdate中调用setDarkMode()。

```arkts
onConfigurationUpdate(newConfig: Configuration): void {
  WaveWheelController.getInstance()
    .setDarkMode(newConfig.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
}
```

2. 初始化时设置当前模式：在控制器初始化后立即设置当前颜色模式。

```arkts
async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
  let controller = WaveWheelController.getInstance();
  controller.init(windowStage);
  
  // Set initial dark mode state
  controller.setDarkMode(
    this.context.config.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK
  );
}
```

## 常见问题

### 菜单无法显示

**问题描述**

轻捏手写笔后菜单没有显示，也没有任何错误提示。

**可能根因**

未正确初始化控制器或未调用start()方法启动事件监听。

**解决方案**

确保在EntryAbility中调用init()初始化控制器，并在页面aboutToAppear中调用start()启动监听。

```arkts
// In EntryAbility
controller.init(windowStage);

// In Page
aboutToAppear(): void {
  this.wavewheelController.start();
}
```

### 菜单选项不生效

**问题描述**

设置了菜单选项，但点击手写笔后菜单显示为空或选项不正确。

**可能根因**

未调用setWaveWheelOptionsBySimple()设置选项，或选项数组为空。

**解决方案**

在页面显示前调用setWaveWheelOptionsBySimple()设置菜单选项和回调。

```arkts
aboutToAppear(): void {
  this.initWaveWheel(); // Set options and callbacks
  this.wavewheelController.start();
}
```

### 手写笔无响应

**问题描述**

轻捏手写笔后没有唤出菜单，但其它手写笔功能正常。

**可能根因**

设备或手写笔不支持轻捏功能。

**解决方案**

检查设备和手写笔是否支持轻捏功能，参考官方手写笔适配清单确认兼容性。

### 深色模式不生效

**问题描述**

切换系统深色模式后，菜单样式没有更新。

**可能根因**

未在onConfigurationUpdate中调用setDarkMode()更新控制器状态。

**解决方案**

在EntryAbility的onConfigurationUpdate中监听颜色模式变化并更新控制器。

```arkts
onConfigurationUpdate(newConfig: Configuration): void {
  WaveWheelController.getInstance()
    .setDarkMode(newConfig.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
}
```

## 总结

本文详细介绍了波轮菜单SDK的接入和使用方法，包括环境准备、SDK初始化、菜单配置、生命周期管理、高级功能等内容。通过简单的接入步骤，开发者即可在应用中集成波轮菜单功能，提升用户操作效率。

核心接入步骤：

1. 导入SDK模块并获取控制器实例
2. 在EntryAbility中初始化控制器
3. 定义菜单选项和回调函数
4. 在页面生命周期中启动和停止监听
5. 监听系统配置变化更新深色模式

## 示例代码

完整示例代码请参考项目工程：[ImageEditWithWavewheel](https://gitcode.com/HarmonyOS_Samples/ImageEditWithWavewheel)

项目目录结构：

```
├──entry/src/main/ets
│  ├──common/constant
│  │  └──WaveWheelConstant.ets  // Wave wheel options definition
│  ├──entryability
│  │  └──EntryAbility.ets       // SDK initialization
│  ├──pages
│  │  └──PictureEdit.ets        // SDK usage in page
│  └──view
│     └──WaveWheelSettingView.ets // Settings UI
├──wavewheel                     // WaveWheel SDK
│  └──Index.ets                  // SDK entry
└──resources
```
