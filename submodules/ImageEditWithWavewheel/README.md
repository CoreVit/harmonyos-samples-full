# 实现修图软件的波轮菜单功能

## 项目简介
在图片编辑Demo的基础上集成波轮菜单功能，图片编辑Demo来源: [https://gitcode.com/HarmonyOS_Samples/PixelMapImageEdit](https://gitcode.com/HarmonyOS_Samples/PixelMapImageEdit)。

图片编辑的Demo是通过图片解码将图片转换为PixelMap格式，获取并展示解码后的原图信息。基于PixelMap实现图片编辑功能，包括几何变换(裁剪、旋转、平移、缩放、镜像)和颜色调整(亮度、透明度、饱和度）等功能。完成编辑后，可将图片重新编码并保存至图库。

在图片编辑页面，通过手写笔连接手机后，手写笔切换到书写模式，点击手写笔的书写键即可弹窗波轮菜单。

## 效果预览

| **手机**                                 | **双折叠**                                | **平板**                                  |
| ------------------------------------ |----------------------------------------| ------------------------------------- |
| ![](screenshots/device/phone_cn.png) | ![](screenshots/device/foldable_cn.png) | ![](screenshots/device/tablet_cn.png) |

## 使用说明

1. 点击顶部信息按钮，查看原图信息。
2. 使用底部标签页切换不同的编辑功能：
   - **裁剪**：支持多种比例裁剪
   - **调节**：调整图片亮度、透明度、饱和度
   - **滤镜**：应用各种滤镜效果
   - **平移**：水平和垂直移动图片
   - **缩放**：放大或缩小图片
3. 实时预览编辑效果。
4. 点击保存按钮保存编辑后的图片。
5. 点击图片编辑页面的顶部的信息按钮，弹出来波轮菜单使用指南。
6. 点击图片编辑页面的顶部的最右侧按钮，弹出来波轮菜单的设置页面，可以在页面内设置波轮菜单选项和顺序。
7. 手写笔连接上手机后，在图片编辑页面，手写笔切换到书写模式，点击书写键，即可呼出波轮菜单。

## 工程目录

```
├──entry/src/main/ets
│  ├──common
│  │  └──constant
│  │     ├──CommonConstants.ets    // 常量
│  │     └──WaveWheelConstant.ets  // 波轮菜单常量
│  ├──entryability
│  │  └──EntryAbility.ets
│  ├──entrybackupability
│  │  └──EntryBackupAbility.ets
│  ├──pages
│  │  ├──Index.ets                // 入口页面
│  │  ├──PictureEdit.ets          // 编辑页面
│  │  └──PixelMapManager.ets      // PixelMap实例
│  ├──types
│  │  └──CommonTypes.ets          // 通用类型
│  ├──utils
│  │  ├──AdjustUtil.ets           // 调节utils
│  │  ├──CropUtil.ets             // 裁剪utils
│  │  ├──DecodeUtil.ets           // 解码utils
│  │  ├──EditController.ets       // 编辑控制器
│  │  ├──Logger.ets               // 日志utils
│  │  ├──MultiDeviceUtil.ets      // 多设备适配
│  │  ├──NavigationTransitionUtils.ets // 导航过渡
│  │  ├──OpacityUtil.ets          // 透明utils
│  │  └──StorageManager.ets       // 存储管理
│  ├──view
│  │  ├──AdjustContentView.ets    // 调节组件
│  │  ├──AlertDialog.ets          // 弹窗
│  │  ├──ApplyFilterView.ets      // 滤镜组件
│  │  ├──CropView.ets             // 裁剪组件
│  │  ├──FoldedDialog.ets         // 折叠屏弹窗
│  │  ├──NoPermissionDialog.ets   // 无权限弹窗
│  │  ├──TranslateView.ets        // 平移组件
│  │  ├──UnsavedDialog.ets        // 未保存弹窗
│  │  ├──WaveWheelSettingView.ets // 波轮菜单设置
│  │  └──ZoomView.ets             // 缩放组件
│  ├──viewModel           
│  │  ├──EditStateViewModel.ets   // 编辑状态Model
│  │  ├──IconListViewModel.ets    // icon Model
│  │  ├──MessageItem.ets          // 消息
│  │  ├──OptionViewModel.ets      // 操作枚举
│  │  ├──RegionItem.ets           
│  │  ├──TaskViewModel.ets        // 任务Model
│  │  └──WindowMenuHelper.ets     // 窗口菜单辅助
│  └──workers
│     └──AdjustWork.ets           // 工作线程
├──wavewheel/src/main/ets
│  ├──common
│  │  ├──Constants.ets            // 常量
│  │  └──FloatingWindowsManager.ets // 悬浮窗管理
│  ├──components
│  │  └──EntranceButton.ets       // 入口按钮组件
│  ├──controllers
│  │  └──WaveWheelController.ets  // 波轮菜单控制器
│  ├──model
│  │  ├──EntranceButtonModel.ets  // 入口按钮Model
│  │  └──Model.ets                // Model
│  ├──pages
│  │  └──WaveWheelPage.ets        // 波轮菜单页面
│  └──utils
│     ├──ApiChecker.ets           // API检查
│     ├──BreakPointInfo.ets       // 断点信息
│     ├──Logger.ets               // 日志utils
│     └──Style.ets                // 样式
└──resources
```

## 具体实现

1. 图片解码：图片解码指将所支持恪式的存档图片解码成统一的PixelMap，以便在应用或系统中进行图片显示或图片处理。
2. 图片信息：获取解码后的图片信息展示。
3. 图片编辑：使用解码的PixelMap图片编辑图片，实现包含裁剪、旋转、色域调节、平移、缩放等功能。
4. 图片编码：图片编码指将PixelMap编码成不同格式的存档图片（当前仅支持打包为JPEG、WebP和png格式），用于后续处理，如保存、传输等。
5. 波轮菜单：使用波轮菜单的SDK完成波轮菜单的集成。

## 相关权限

不涉及

## 约束与限制

1. 本示例仅支持在标准系统上运行，支持设备：直板机、双折叠、三折叠、平板。
2. HarmonyOS系统：HarmonyOS 6.0.0 Release及以上。
3. DevEco Studio版本：DevEco Studio 6.0.0 Release及以上。
4. HarmonyOS SDK版本：API 20 及以上。
5. 手写笔及适配机型请查看：
   - 华为手机支持的手写笔设备清单：[https://consumer.huawei.com/cn/support/content/zh-cn15869694/](https://consumer.huawei.com/cn/support/content/zh-cn15869694/)
   - 华为手写笔与平板/笔记本电脑适配清单：[https://consumer.huawei.com/cn/support/content/zh-cn00737675/](https://consumer.huawei.com/cn/support/content/zh-cn00737675/)