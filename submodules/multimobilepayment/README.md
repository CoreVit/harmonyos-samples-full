# 多设备移动支付界面

## 介绍

本示例基于界面级一多、功能级一多的相关能力，实现多设备上的移动支付场景典型页面。

## 效果图预览

|                           **手机**                           |                          **双折叠**                          |                        **Pura X**                         |
|:----------------------------------------------------------:|:---------------------------------------------------------:|:---------------------------------------------------------:|
| <img src="screenshots/mate.png" alt="Index" width="180" /> | <img src="screenshots/mateX.png" alt="Get" width="330" /> | <img src="screenshots/PuraX.png" alt="Get" width="160" /> |

|                           **平板**                           |                          **电脑**                          |                         **智能穿戴**                          |
|:----------------------------------------------------------:|:--------------------------------------------------------:|:---------------------------------------------------------:|
| <img src="screenshots/tablet.png" alt="Get" width="580" /> | <img src="screenshots/2in1.png" alt="Get" width="620" /> | <img src="screenshots/watch.png" alt="Get" width="120" /> |

## 使用说明

1. 进入应用首页，点击“扫一扫”，在类直板设备/智能穿戴上跳转扫一扫页面，其他设备上拉起弹窗。首次打开时向用户申请相机权限，申请成功后呈现预览流。
2. 点击“收付款”，在类直板设备/智能穿戴上跳转收付款页面，其他设备上拉起弹窗。

## 工程目录

```  
├──common
│  └──multimobilepaymentbase/src/main
│     ├──ets
│     │  ├──data                    
│     │  ├──db                                 
│     │  └──utils   
│     └──resources             
├──features
│  ├──multimobilepaymentpay/src/main
│  │  ├──ets
│  │  │  ├──view
│  │  │  └──viewmodel
│  │  └──resources
│  ├──multimobilepaymentrecommend/src/main
│  │  ├──ets
│  │  │  ├──model
│  │  │  ├──view
│  │  │  └──viewmodel
│  │  └──resources
│  └──multimobilepaymentscan/src/main
│     ├──ets
│     │  ├──model
│     │  ├──view
│     │  └──viewmodel
│     └──resources
└──products
   ├──default/src/main
   │  ├──ets
   │  │  ├──entryability
   │  │  ├──entrybackupability
   │  │  ├──model
   │  │  ├──pages
   │  │  ├──view
   │  │  └──viewmodel
   │  └──resources
   ├──pc/src/main
   │  ├──ets
   │  │  ├──model
   │  │  ├──pages
   │  │  ├──pcability
   │  │  ├──pcbackupability
   │  │  └──viewmodel
   │  └──resources
   └──watch/src/main
      ├──ets
      │  ├──model
      │  ├──pages
      │  ├──view
      │  ├──viewmodel
      │  ├──wearableability
      │  └──wearablebackupability
      └──resources

```

## 具体实现

1. 将工程目录按照products、features、common的三层架构进行组织。由于电脑、穿戴设备上的UI结构和手机、平板的差异较大，因此在products层创建三个hap包作为不同设备的应用入口，分别是default（手机、平板）、pc（电脑）和watch（智能穿戴）；
在features层实现推荐页（multimobilepaymentrecommend）、扫一扫（multimobilepaymentscan）和收付款（multimobilepaymentpay）三个业务模块，供products层调用；
在common层存放通用工具类和公共静态常量。
2. 入口：在default包中，通过HdsTabs组件作为根容器实现底部页签；在pc包中，通过HdsSideBar作为根容器实现侧边栏；在watch包中，使用Navigation组件作为根容器，便于后续进行页面路由。
3. 推荐模块：
    - **default、pc** : 自上而下分为顶部搜索区、快捷操作区、功能入口区和财富精选区：顶部搜索区通过自适应拉伸能力实现多端效果；快捷操作区通过占比能力实现；功能入口区和财富精选区均通过Grid组件结合断点实现。
    - **watch** : 使用ArcList组件实现弧形列表，给按钮添加onclick事件实现页面路由跳转。
4. 扫一扫模块：
    - **default、pc** : 页面整体通过半模态弹窗实现，设置其模式在sm断点下为全屏弹窗，在其他更大断点上为居中弹窗。使用Stack组件作为根容器，XComponent组件承载相机预览画面。申请相机权限成功后调用canIUse('SystemCapability.Multimedia.Scan.ScanBarcode')校验设备是否支持扫码，若支持，通过customScan进行相机扫描的初始化。
    - **watch** : 穿戴设备通常没有摄像头，使用其进行扫码不符合正常业务，故不支持扫码功能。
5. 收付款模块：
   - **default、pc** : 页面整体通过半模态弹窗实现，设置其模式在sm断点下为全屏弹窗，在其他更大断点上为居中弹窗。调用canIUse('SystemCapability.Multimedia.Scan.GenerateBarcode')和canIUse('SystemCapability.Multimedia.Scan.Core')，确保设备具备码图生成能力，然后通过generateBarcode.createBarcode()接口生成码图并保存为image.PixelMap对象，在页面中渲染。
   - **watch** : 使用NavDestination作为根容器，调用码图生成接口，生成逻辑与其他设备相同。

## 相关权限

1. 获取相机权限：ohos.permission.CAMERA。

## 依赖

不涉及

## 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：phone，tablet，PC/2in1，wearable。

2. HarmonyOS系统：HarmonyOS 6.0.2 Release及以上。

3. DevEco Studio版本：DevEco Studio 6.1.0 Release及以上。

4. HarmonyOS SDK版本：HarmonyOS 6.1.0 Release SDK及以上。