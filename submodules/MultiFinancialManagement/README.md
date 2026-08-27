# 多设备银行理财界面

## 项目简介

基于一多能力，实现一次开发、多端部署的银行理财应用界面，覆盖了直板机、折叠屏、平板及电脑设备。同时，采用三层架构组织代码工程，结合自适应布局与响应式布局，构建了从首页、账户总览页、理财详情页到购买的核心理财体验。

## 效果预览

| 阔折叠外屏                                              | 直板机                                                | 折叠屏                                                   | 平板                                                  | 电脑                                                |
|----------------------------------------------------|----------------------------------------------------|-------------------------------------------------------|-----------------------------------------------------|---------------------------------------------------|
| <img src='screenshots/device/purax.png' width=320> | <img src='screenshots/device/phone.png' width=320> | <img src='screenshots/device/foldable.png' width=480> | <img src='screenshots/device/tablet.png' width=800> | <img src='screenshots/device/2in1.png' width=800> |

## 使用说明

1. 分别在直板机、双折叠（Mate X系列）、阔折叠、三折叠、平板、电脑设备中安装并打开应用，不同设备的应用页面通过响应式布局和自适应布局呈现不同的效果。
2. 点击首页中资产总览按钮跳转到账户总览页。
3. 首页/账户总览中点击某金融产品，跳转到理财详情页。
4. 在理财详情页点击底部购买按钮，显示支付组件。

## 工程目录

```
├──commons/financialbase                                     
│  └──src/main
│     ├──ets
│     │  ├──constants                         // 公共常量定义
│     │  └──utils                             // 工具类与窗口能力封装
│     └──resources                            // 公共资源
├──features                                   
│  ├──account                                 // 账户模块
│  │  └──src/main
│  │     ├──ets
│  │     │  ├──components                     // 账户模块页面组件
│  │     │  ├──constants                      // 账户模块常量
│  │     │  ├──model                          // 账户模块数据模型
│  │     │  └──viewmodel                      // 账户模块视图模型
│  │     └──resources                         // 账户模块资源
│  ├──investment                              // 投资模块
│  │  └──src/main
│  │     ├──ets
│  │     │  ├──components                     // 购买模块页面组件
│  │     │  ├──model                          // 购买模块数据模型
│  │     │  └──viewmodel                      // 投资模块视图模型
│  │     └──resources                         // 投资模块资源
│  ├──wealth                                  // 理财产品模块
│  │  └──src/main
│  │     ├──ets
│  │     │  ├──components                     // 产品与卖点展示组件
│  │     │  ├──model                          // 产品模块数据模型
│  │     │  └──viewmodel                      // 产品模块视图模型
│  │     └──resources                         // 产品模块资源
│  └──recommend                               // 推荐内容特性
│     └──src/main
│        ├──ets
│        │  ├──components                     // 推荐模块组件
│        │  ├──model                          // 推荐模块数据模型
│        │  └──viewmodel                      // 推荐模块视图模型
│        └──resources                         // 推荐模块资源
└──products                                    
   ├──default                                 // 手机/平板设备
   │  └──src/main
   │     ├──ets
   │     │  ├──entryability                   // 入口类
   │     │  ├──model                          // 数据模型
   │     │  ├──pages                          // 页面
   │     │  ├──view                           // 组件
   │     │  └──viewmodel                      // 视图模型
   │     └──resources                         // 资源文件
   └──pc                                      // 电脑设备
      └──src/main
         │  ├──model                          // 数据结构
         │  ├──pages                          // 页面
         │  ├──pcbackupability                // 数据备份与恢复扩展能力
         │  ├──view                           // 组件
         │  └──viewmodel                      // 视图模型
         └──resources                         // 资源文件
```

## 具体实现

1. 将工程目录按照products、features、commons的三层架构进行组织。由于电脑界面布局与其他设备差异较大，因此单独创建名为**pc**
   的hap包作为电脑设备的应用入口；直板机、双折叠（Mate X系列）、阔折叠、三折叠及平板设备上的界面布局整体相似，部分差异可以通过一多能力进行适配，为此创建名为
   **default**的hap包作为这些设备的应用入口。两端共用同一套业务特性模块，通过断点与布局策略控制页面在不同窗口尺寸下的结构变化。
2. 首页
    - 底部Tabs：移动端使用HdsTabs实现，通过barFloatingStyle属性为页签设置悬浮样式，确保移动端底部优先触达。电脑端使用侧边栏容器SideBarContainer实现。
    - 顶部栏：基于断点实现搜索区与工具按钮的自适应切换（小屏显示搜索图标，大屏显示搜索框），并根据断点调整内边距。
    - 主业务快捷区：基于断点变化动态调整左右内边距及布局样式，sm、md断点下，图标和文字纵向排布，lg及xl断点下切换为横向排布。
    - 业务宫格区：使用网格容器Grid实现，通过columnsTemplate属性，动态调整不同断点下的显示列数。
    - 消息卡片、银行卡信息、个人养老金：使用响应式布局的栅格系统GridRow/GridCol实现。
    - 财富精选：使用响应式布局的栅格系统GridRow/GridCol实现，断点变化同时调整列表数量和右侧扩展内容。
3. 账户总览页
    - 页面使用响应式布局的栅格系统GridRow/GridCol实现：小中屏按单列纵向滚动展示，大屏按“左侧账户概览 + 右侧详情区”分栏展示。
    - 页面标题栏采用HdsNavDestination沉浸式配置，通过titleBar属性为标题栏设置沉浸样式与动态模糊样式。
    - 内容区：多组件按断点调整展示与堆叠顺序。
4. 理财详情页：使用Stack组件控制页面组件的层级，保证标题栏始终显示在理财详情页最上层，底部操作栏显示在最下层。内容区使用滚动容器承载，边距、底栏宽度与按钮布局通过断点实时调整。
5. 购买页：购买交互采用“同页弹层 + 分栏路由”双模式：小屏通过bindSheet拉起半模态弹窗，大屏使用Navigation实现双栏效果。

## 相关权限

不涉及

## 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：直板机、双折叠（Mate X系列）、阔折叠、三折叠、平板、电脑。
2. HarmonyOS系统：HarmonyOS 6.0.2 Release及以上。
3. DevEco Studio版本：DevEco Studio 6.1.0 Release及以上。
4. HarmonyOS SDK版本：HarmonyOS 6.1.0 Release SDK及以上。
