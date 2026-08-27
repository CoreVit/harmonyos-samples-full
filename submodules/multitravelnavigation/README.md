# 多设备地图导航界面

### 介绍

本示例主要使用Map Kit的相关能力实现多端上地图的首页、搜索地点、地点详情、路径规划及实况窗等典型场景。

### 效果预览

| 阔折叠（外屏） | 直板机 | 折叠屏（展开态） |
| --- | --- | --- |
| <img src="screenshots/device/purax/purax_home_outside.png" width="180" /> | <img src="screenshots/device/phone/home_half.png" width="180" /> | <img src="screenshots/device/fold/home_high.png" width="220" /> |
| **平板** | **电脑** |  |
| <img src="screenshots/device/tablet/home_high.png" width="300" /> | <img src="screenshots/device/pc/home.png" width="300" /> |  |

### 使用说明

1. 使用前请先参考指南配置AppGallery Connect并[开通地图服务](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/map-config-agc#开通地图服务)。若运行手机产品并需要体验实况窗，请同步申请Live View Kit（实况窗服务）相关权益，可参考[开发准备](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/liveview-preparations)。

2. 开发者需将项目的bundle name修改为自定义名称：

   ![bundleName](./screenshots/device/bundleName.png)

3. 确保设备处于联网状态并开启获取位置信息功能。首次打开应用时授予位置权限，应用会根据手机、折叠屏、平板、电脑等设备形态呈现不同布局。

4. 手机、折叠屏、平板等产品入口为`products/default`，包含地图导航和实况窗能力；电脑产品入口为`products/pc`，聚焦大屏地图导航体验，不包含实况窗能力。

5. 不同设备的面板形态不同：直板机以底部面板展示，支持低、中、高三档；折叠屏展开态和平板以悬浮面板展示，默认高档位，可拖动调整高度并点击地图控制显隐；Pura X外屏以Mini面板展示，仅支持中档和高档；电脑以左侧固定面板展示，不参与底部/悬浮面板档位切换。

6. 首页点击搜索框输入地点、地址或公交信息，提交后通过周边搜索接口获取附近相关地点列表。

7. 搜索结果会随设备面板形态适配展示：底部面板默认档位以横向列表展示，高档位以纵向列表展示；Mini面板默认收起为精简高度，高档位展开完整列表；悬浮面板和电脑侧边面板以纵向列表为主。点击输入框后侧取消按钮或系统返回键可返回首页。

8. 点击搜索结果进入地点详情页，可查看地点基础信息、推荐内容和底部操作按钮。底部按钮固定在详情面板底部，内容区域随面板高度滚动或展开。

9. 点击地点详情或搜索结果中的路线/导航按钮进入路线规划页面，默认交通方式为驾车，最多规划三条路线，默认展示第一种规划方案。

10. 路线规划结果会随面板形态适配展示：底部面板默认档位以横向列表展示，高档位以纵向列表展示，低档位只展示输入框区域；Mini面板不展示低档位；悬浮面板和电脑侧边面板保持更适合大屏的纵向浏览。点击不同路线可在地图上切换展示不同规划结果。

### 工程目录

```
├──commons                                // 公共能力层
│  └──multitravelbase                     // 公共基础模块
│     └──src
│        └──main
│           ├──ets
│           │  ├──constants               // 公共常量
│           │  ├──model                   // 跨模块共享状态和数据模型
│           │  └──utils                   // 日志、位置、窗口、地图场景、资源文本等公共工具
│           └──resources                  // 公共资源
├──features                               // 基础特性层
│  ├──mapcontainer                        // 地图容器模块
│  │  └──src
│  │     └──main
│  │        ├──ets
│  │        │  ├──model                   // 地图视口、边距等地图容器模型
│  │        │  ├──pages                   // 地图主界面页面入口
│  │        │  ├──view                    // 地图背板、面板容器、PC装饰工具栏等视图
│  │        │  └──viewmodel               // 地图主界面状态管理
│  │        └──resources                  // 地图容器资源
│  ├──maplive                             // 实况窗模块
│  │  └──src
│  │     └──main
│  │        ├──ets
│  │        │  ├──constants               // 实况窗常量
│  │        │  └──viewmodel               // 实况窗控制逻辑
│  │        └──resources                  // 实况窗资源
│  └──poiexplore                          // 兴趣点探索模块
│     └──src
│        └──main
│           ├──ets
│           │  ├──constants               // 兴趣点探索常量
│           │  ├──model                   // 首页展示、地点详情、搜索和路线规划数据模型
│           │  ├──view                    // 首页、搜索、详情、路线规划等视图
│           │  └──viewmodel               // 搜索、地点详情和路线规划视图模型
│           └──resources                  // 兴趣点探索资源
└──products                               // 产品定制层
   ├──default                             // 默认（手机/平板）产品
   │  └──src
   │     └──main
   │        ├──ets
   │        │  ├──defaultability          // 默认产品入口
   │        │  └──pages                   // 默认产品页面
   │        └──resources                  // 默认产品资源
   └──pc                                  // 电脑产品
      └──src
         └──main
            ├──ets
            │  ├──pages                   // 电脑产品页面
            │  └──pcability               // 电脑产品入口
            └──resources                  // 电脑产品资源

```

### 具体实现

1. 将工程目录按照`products`、`features`、`commons`三层架构进行组织。在`products`层提供`default`与`pc`两套产品源码：`default`面向直板机、折叠屏与平板等常见形态，包含地图导航和实况窗能力；`pc`面向电脑形态，采用左侧固定面板与电脑窗口装饰能力，不包含实况窗。在`features`层实现`mapcontainer`（地图容器与面板承载）、`poiexplore`（兴趣点，POI，Point of Interest，搜索、详情与路线规划）、`maplive`（实况窗/实况窗）等业务模块，供`products`层按需组合；在`commons`存放断点类型、地图状态、位置、窗口、地图场景、资源文本等通用能力。模块依赖关系见根目录`build-profile.json5`。

2. 地图容器（mapcontainer）模块：

- **地图主界面与产品差异**
  - `products/default`与`products/pc`分别在入口页面中组合`MapContainerPage`，通过`layoutMode`区分默认产品的叠加式地图面板与电脑产品的嵌入式侧边栏布局。代码位置：`products/default/src/main/ets/pages/Index.ets`、`products/pc/src/main/ets/pages/Index.ets`、`features/mapcontainer/src/main/ets/pages/MapContainerPage.ets`。

- **底部面板、悬浮面板、Mini面板与侧边固定面板**
  - `PopupPanel`根据宽高断点与`layoutMode`计算`PanelType`、`PanelMode`、面板高度、宽度、圆角和底部间距：直板机使用底部面板并支持低/中/高三档，折叠屏展开态和平板使用悬浮面板，Pura X外屏使用Mini面板，电脑使用`PanelType.None`对应侧边固定面板。`PanelInteractionController`与`PanelPositionController`负责面板显隐、拖拽调高和悬浮面板左右位置调整。代码位置：`features/mapcontainer/src/main/ets/viewmodel/panel/PopupPanel.ets`、`features/mapcontainer/src/main/ets/viewmodel/panel/PanelInteractionController.ets`、`features/mapcontainer/src/main/ets/viewmodel/panel/PanelPositionController.ets`。

- **地图背板、标记点与路线绘制**
  - `BaseMapView`承载Map Kit地图组件，负责地图初始化、定位按钮、地图点击和标记点点击事件；`MapContainerPageViewModel`根据`MapUiState`同步首页、搜索结果、地点详情和路线规划状态下的地图内容；`MapViewportCoordinator`统一计算地图边距、缩放控件避让和面板视口联动；`MapSceneUtil`封装地图清理、地点聚焦、搜索标记点和路线绘制等公共地图能力。代码位置：`features/mapcontainer/src/main/ets/view/BaseMapView.ets`、`features/mapcontainer/src/main/ets/viewmodel/MapContainerPageViewModel.ets`、`features/mapcontainer/src/main/ets/model/MapViewportCoordinator.ets`、`commons/multitravelbase/src/main/ets/utils/MapSceneUtil.ets`。

3. 兴趣点（POI）探索（poiexplore）模块：

- **首页面板与搜索入口**
  - 首页面板由`HomePanelView`组合搜索框、功能宫格、内容栏目和底部页签，在不同`PanelType`与`PanelMode`下控制内容显隐和滚动行为；`SearchBarView`负责搜索输入、提交搜索、打开搜索结果页，以及清空搜索状态。代码位置：`features/poiexplore/src/main/ets/view/home/HomePanelView.ets`、`features/poiexplore/src/main/ets/view/home/GridView.ets`、`features/poiexplore/src/main/ets/view/home/TabView.ets`、`features/poiexplore/src/main/ets/view/search/SearchBarView.ets`。

- **搜索结果列表与地图联动**
  - `SearchViewModel`负责获取当前位置、调用`SiteSearchRepository`完成周边文本搜索，并将搜索结果同步到`AppStorage`；`SearchResultListView`根据面板形态展示横向或纵向结果列表，点击结果后选中地点、聚焦地图并进入详情页。代码位置：`features/poiexplore/src/main/ets/viewmodel/SearchViewModel.ets`、`features/poiexplore/src/main/ets/model/repository/SiteSearchRepository.ets`、`features/poiexplore/src/main/ets/view/search/SearchResultListView.ets`。

- **地点详情与底部操作**
  - `SiteDetailView`展示地点基础信息、推荐内容、问答内容和底部操作按钮；内容区使用滚动区域承载，底部路线/导航按钮固定在详情面板底部。`SiteDetailPageViewModel`负责进入详情页时同步地图状态与地点聚焦。代码位置：`features/poiexplore/src/main/ets/view/detail/SiteDetailView.ets`、`features/poiexplore/src/main/ets/viewmodel/SiteDetailPageViewModel.ets`、`features/poiexplore/src/main/ets/model/data/SiteDetailData.ets`。

- **路线规划与路线列表**
  - `RoutePlanView`负责路线规划页外层状态、面板手势和返回逻辑；`RoutePlanContentView`承载起终点、交通方式Tab、路线摘要和路线详情列表；`RouteBottomActionsView`封装底部收藏、分享和开始导航操作；`RoutePlanViewModel`通过`RoutePlanningService`调用Map Kit路线规划能力并整理路线时长、距离和路段信息，地图容器根据返回的路线结果绘制路径。代码位置：`features/poiexplore/src/main/ets/view/route/RoutePlanView.ets`、`features/poiexplore/src/main/ets/view/route/RoutePlanContentView.ets`、`features/poiexplore/src/main/ets/view/route/RouteBottomActionsView.ets`、`features/poiexplore/src/main/ets/viewmodel/RoutePlanViewModel.ets`、`features/poiexplore/src/main/ets/model/service/RoutePlanningService.ets`。

4. 实况窗：

- **实况窗**
  - `RoutePlanView`在点击“开始导航”时启动实况窗/实况窗，退出路线规划页时停止实况窗，`products/default`在窗口销毁时兜底停止；`LiveViewController`封装Live View Kit的启动、更新、停止、可用性判断和点击WantAgent构建逻辑。代码位置：`features/poiexplore/src/main/ets/view/route/RoutePlanView.ets`、`products/default/src/main/ets/defaultability/DefaultAbility.ets`、`features/maplive/src/main/ets/viewmodel/LiveViewController.ets`、`features/maplive/src/main/ets/constants/LiveConstants.ets`。

5. 公共能力（multitravelbase）模块：

**公共状态、断点与资源工具**
`multitravelbase`提供`MapUiState`、`PanelMode`、`PanelType`、`SelectedSite`等跨模块共享状态和模型；`WidthBreakpointType`用于根据断点选择布局参数；`WindowUtil`与`WindowInfo`维护窗口、安全区和沉浸式信息；`LocationPermissionManager`、`LocationUtil`与`LocationStateAccessor`负责权限申请、定位获取与位置状态存储；`MapSceneUtil`负责地图清理、地点聚焦、标记点和路线绘制；`ResourceTextUtil`负责资源字符串读取和占位符替换；`AppStorageCleaner`用于根组件生命周期结束时清理跨页面存储状态。代码位置：`commons/multitravelbase/src/main/ets/model/MapUiState.ets`、`commons/multitravelbase/src/main/ets/model/PanelState.ets`、`commons/multitravelbase/src/main/ets/model/SelectedSite.ets`、`commons/multitravelbase/src/main/ets/utils/WidthBreakpointType.ets`、`commons/multitravelbase/src/main/ets/utils/WindowUtil.ets`、`commons/multitravelbase/src/main/ets/utils/LocationPermissionManager.ets`、`commons/multitravelbase/src/main/ets/utils/LocationUtil.ets`、`commons/multitravelbase/src/main/ets/utils/LocationStateAccessor.ets`、`commons/multitravelbase/src/main/ets/utils/MapSceneUtil.ets`、`commons/multitravelbase/src/main/ets/utils/ResourceTextUtil.ets`、`commons/multitravelbase/src/main/ets/utils/AppStorageCleaner.ets`。

### 相关权限

1. 获取位置权限：ohos.permission.APPROXIMATELY_LOCATION，ohos.permission.LOCATION。
2. 使用Map Kit能力需要参考[开通地图服务](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/map-config-agc#开通地图服务)。
3. 使用Live View Kit相关能力需要参考指南实况窗[开发准备](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/liveview-preparations)开通相关权益。

### 依赖

不涉及

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：直板机、双折叠（Mate X系列）、三折叠、阔折叠、平板、电脑。
2. HarmonyOS系统：HarmonyOS 6.0.2 Release及以上。
3. DevEco Studio版本：DevEco Studio 6.1.0 Release及以上。
4. HarmonyOS SDK版本：HarmonyOS 6.1.0 Release SDK及以上。
