# 多设备短视频

## 项目简介

本示例基于一多能力，实现了一次开发、多端部署的短视频应用界面，覆盖手表、直板机、折叠屏、平板、电脑及智慧屏等多种设备形态。同时，采用三层架构组织代码工程，结合自适应布局与响应式布局，构建了从推荐页、评论页及个人作品页的短视频体验。

## 效果预览
手表运行效果图如下：

<img src='screenshots/device/wearable.png' width=150>

直板机运行效果图如下：

<img src='screenshots/device/phone.png' width=200>

折叠屏运行效果图如下：

<img src='screenshots/device/foldable.png' width=400>

平板运行效果图如下：

<img src='screenshots/device/tablet.png' width=600>

电脑运行效果图如下：

<img src='screenshots/device/2in1.png' width=600>

智慧屏运行效果图如下：

<img src='screenshots/device/tv.png' width=800>



## 使用说明

1. 在手机、平板上安装名称为**default**的hap包，在电脑上安装名称为**pc**的hap包，在智慧屏上安装名称为**tv**的hap包，在手表上安装名称为**wearable**的hap包。安装完成后打开应用，即可在不同设备上看到通过自适应和响应式布局呈现的差异化短视频界面。

2. 在各种形态设备上均可上下滑动体验不同尺寸视频在不同设备上的沉浸式适配效果。
3. 点击推荐页头像，在类直板机上会直接跳转新页面全窗口进入个人作品页，在折叠屏展开态、平板、电脑、智慧屏上均采用侧面分栏形式展示个人作品。
4. 点击“我的”页签，在任何设备上都会直接切换页面到个人作品页。
5. 点击推荐页评论，在类直板机上会从下方弹出半模态区域展示评论区，在折叠屏展开态、平板、电脑、智慧屏上均采用侧面分栏形式展示评论区。


## 工程目录

```
├── common                                                 // 公共能力层
│   └── multishortvideobase
│       └── src
│           └── main
│               ├── ets
│               │   ├── components
│               │   │   ├── MSVEmptyComponent.ets          // 空页面公共组件
│               │   │   ├── MSVTabs.ets                    // Tabs公共组件
│               │   │   └── MSVTextIcon.ets                // 图文公共组件
│               │   ├── constants
│               │   │   └── CommonConstants.ets            // 公共常量
│               │   ├── model
│               │   │   └── MSVDataModel.ets               // 公共数据模型
│               │   └── utils
│               │       ├── AdaptiveImmersion.ets          // 以下为沉浸式相关算法文件
│               │       ├── ImmersionConstants.ets               
│               │       ├── ImmersionManager.ets                 
│               │       ├── ImmersionRules.ets                   
│               │       ├── Logger.ets                     // 打印日志
│               │       ├── WidthBreakpointType.ets        // 断点工具类
│               │       └── WindowUtil.ets                 // 窗口工具类
│               └── resources
├── features                                               // 基础特性层
│   ├── multishortvideoadaptivevideo                       // 视频播放层
│   │   └── src
│   │       └── main
│   │           ├── ets
│   │           │   ├── model
│   │           │   │   └── AvDataSourceModel.ets          // 视频播放数据模型
│   │           │   ├── view
│   │           │   │   ├── AdaptiveAVPlayer.ets           // 视频播放核心文件
│   │           │   │   └── AdaptiveVideo.ets              // 视频播放及控件层
│   │           │   └── viewModel
│   │           │       └── AvDataSourceViewModel.ets      // 视频播放数据
│   │           └── resources                              // 视频播放资源文件
│   ├── multishortvideocomment                             // 评论区
│   │   └── src
│   │       └── main
│   │           ├── ets
│   │           │   ├── model
│   │           │   │   ├── CommentDataModel.ets           // 评论区数据模型
│   │           │   │   └── ReplyDataModel.ets             // 评论区楼中楼回复数据模型
│   │           │   ├── view
│   │           │   │   └── Comment.ets                    // 评论区核心业务
│   │           │   └── viewmodel
│   │           │       └── CommentViewModel.ets           // 评论区数据
│   │           └── resources                              // 评论区资源文件
│   └── multishortvideoindividual                          // 个人作品页
│       └── src
│           └── main
│               ├── ets
│               │   ├── components
│               │   │   ├── Builders.ets。                 
│               │   │   └── Individual.ets                 // 个人作品页
│               │   ├── model
│               │   │   └── WorksDataModel.ets             // 个人作品页数据模型
│               │   ├── view
│               │   │   ├── IndividualByRouter.ets         // 个人作品页路由
│               │   │   └── Works.ets                      // 个人作品页作品
│               │   └── viewmodel
│               │       ├── IndividualTabsViewModel.ets。  // 个人作品页数据
│               │       └── WorksViewModel.ets             // 作品数据
│               └── resources                              // 个人作品页资源文件
└── products                                               // 产品定制层
    ├── default                                            // 默认产品手机和平板
    │   └── src
    │       └── main
    │           ├── ets
    │           │   ├── components           
    │           │   │   ├── Builders.ets                   // 公共Builder
    │           │   │   └── SubTabsComponent.ets           // 子页签
    │           │   ├── defaultability
    │           │   │   └── MultiShortVideoDefaultAbility.ets
    │           │   ├── view
    │           │   │   ├── Index.ets                      // 主页
    │           │   │   └── SplitComment.ets               // 侧面板评论
    │           │   └── viewmodel
    │           │       ├── MainTabsViewModel.ets          // 主页签数据
    │           │       └── SubTabsViewModel.ets           // 子页签数据
    │           └── resources                              // 资源文件
    ├── pc                                                 // 电脑产品
    │   └── src
    │       └── main
    │           ├── ets
    │           │   ├── components
    │           │   │   └── Builders.ets                   // 公共Builder
    │           │   ├── model
    │           │   │   └── ContentParamsModel.ets         // 内容数据模型
    │           │   ├── pcability
    │           │   │   └── MultiShortVideoPcAbility.ets   // 默认入口
    │           │   ├── view
    │           │   │   ├── Index.ets                      // 主页
    │           │   │   └── SplitComment.ets               // 侧面板评论
    │           │   └── viewmodel
    │           │       └── MainTabsViewModel.ets          // 主页签数据
    │           └── resources                              // 资源文件
    ├── tv                                                 // 智慧屏产品
    │   └── src
    │       └── main
    │           ├── ets
    │           │   ├── components
    │           │   │   ├── Builders.ets                   // 公共Builder
    │           │   │   └── TvTabs.ets                     // 智慧屏Tabs
    │           │   ├── model
    │           │   │   └── ContentParamsModel.ets         // 内容数据模型
    │           │   ├── tvability
    │           │   │   └── MultiShortVideoTvAbility.ets   // 默认入口
    │           │   ├── view
    │           │   │   ├── Index.ets                      // 主页
    │           │   │   └── SplitComment.ets               // 侧面板评论
    │           │   └── viewmodel
    │           │       └── MainTabsViewModel.ets          // 主页签数据
    │           └── resources                              // 资源文件
    └── wearable                                           // 智慧穿戴产品
        └── src
            └── main
                ├── ets
                │   ├── components
                │   │   ├── Builders.ets                   // 公共Builder
                │   │   └── SubTabsComponent.ets           // 智慧屏Tabs
                │   ├── view
                │   │   └── Index.ets                      // 主页
                │   ├── viewmodel
                │   │   ├── MainTabsViewModel.ets          // 主页签数据
                │   │   └── SubTabsViewModel.ets           // 子页签数据
                │   ├── wearableability
                │   │   └── MultiShortVideoWearableAbility.ets
                └── resources                              // 资源文件
```

## 具体实现

1. 将工程目录按照products、features、common的三层架构进行组织。由于手机和平板、智慧屏、智能穿戴及电脑UI结构和交互逻辑有差异，因此在products层创建了四个hap包作为不同设备的应用入口，在features层实现视频播放、评论、个人作品三个业务模块，供products层统一调用；在common层存放通用工具类和公共静态常量。

2. 入口模块：
   四类产品首页设计有差异，需要在独立的入口中完成差异化处理，具体可打开products中的四个hap包查看。
    
3. 视频播放、评论区及个人作品模块：
    无论在何种设备上，均引用了features层的基础特性模块，其内部通过一多断点控制、栅格断点系统、ArkUI组件特性等实现多设备的差异化处理。

## 相关权限

不涉及。

## 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：手表、直板机、双折叠（Mate X系列）、三折叠、阔折叠、平板、电脑、智慧屏。
2. HarmonyOS系统：HarmonyOS 5.0.5 Release及以上。
3. DevEco Studio版本：DevEco Studio 6.0.2 Release及以上。
4. HarmonyOS SDK版本：HarmonyOS 6.0.2 Release SDK及以上。