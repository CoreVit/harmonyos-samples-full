# 多设备股票类界面

## 介绍

本篇Sample基于自适应布局和响应式布局，实现一次开发，多端部署的股票交易应用。根据不同设备尺寸（如直板机、双折叠（Mate X系列）、阔折叠、三折叠、平板和电脑），实现了相应的页面布局。该Sample支持在双折叠（Mate X系列）、三折叠和平板设备上分屏显示，便于对比股票详情。

## 效果预览

本示例分为两个页面和两个弹框。鉴于三折叠与平板横向断点均为lg，在效果预览页面中，仅展示平板设备的效果示意图。

**自选首页**:

| 阔折叠                                 | 直板机                                          | 折叠屏（展开态）                           | 平板                        |
|-------------------------------------|----------------------------------------------|------------------------------------|-----------------------------------|
| ![](screenshots/devices/home-page-purax.png) | ![](screenshots/devices/home-page-phone.png) | ![](screenshots/devices/home-page-foldablescre.png) | ![](screenshots/devices/home-page-tablet.png) |

**股票详情页**:

| 阔折叠                                 | 直板机                                 | 折叠屏（展开态）                           | 平板（全屏）                             |
|-------------------------------------|------------------------------------|------------------------------------|------------------------------------|
| ![](screenshots/devices/detail-page-purax.png) | ![](screenshots/devices/detail-page-phone.png) | ![](screenshots/devices/detail-page-foldablescre.png) | ![](screenshots/devices/detail-page-tablet.png) |

**多股比价**:

|             | 折叠屏分屏-双股比价                                             | 折叠屏全景多窗-三股比价                                     |
|-------------|--------------------------------------------------------|--------------------------------------------------|
| 个股详情页-多股比价  | ![](screenshots/devices/split-screen-foldablescre.png) | ![](screenshots/devices/split-screen-tablet.png) |

**买入股票弹窗**:

| 直板机                                 | 折叠屏（展开态）                           | 平板                                  |
|------------------------------------|------------------------------------|-------------------------------------|
| ![](screenshots/devices/stock-pop-phone.png) | ![](screenshots/devices/stock-pop-foldablescre.png) | ![](screenshots/devices/stock-pop-tablet.png) |

**确认买入股票弹窗**:

| 直板机                                | 折叠屏（展开态）                           | 平板                                  |
|------------------------------------|------------------------------------|-------------------------------------|
| ![](screenshots/devices/stock-affirm-pop-phone.png) | ![](screenshots/devices/stock-affirm-pop-foldablescre.png) | ![](screenshots/devices/stock-affirm-pop-tablet.png) |

使用说明：

* 自选首页

  1. 自选页面，点击任意股票，跳转到股票详情页。

* 股票详情页

  1. 折叠屏（展开态）或平板：点击页面右上角的“分屏”图标，应用进入分屏模式；
  
  2. 平板：右侧“股票详情”页面，点击页面左上角的“放大”图标，股票详情页进入全屏。全屏下，点击页面左上角的“返回”图标，股票详情页退出全屏；
  
  3. 点击页面下方的“去交易”按钮，页面弹出“买入股票弹窗”。当前弹框，点击“买入”按钮，弹出“确认买入股票弹窗”。

## 工程目录

```
├──commons
│  └──base/src/main
│     ├──ets
│     │  ├──baseviews                     // 公共视图组件
│     │  │  └──CommonView.ets
│     │  ├──models                        // 公共数据模型
│     │  │  └──StockModel.ets
│     │  └──utils                         // 公共工具类
│     │     ├──AppConstants.ets           // 应用常量
│     │     ├──BreakpointType.ets         // 断点类型
│     │     ├──Logger.ets                 // 日志工具
│     │     └──WindowUtil.ets             // 窗口工具类
│     └──resources                        // 应用静态资源目录
│        ├──base/element/color.json       // 浅色模式颜色资源
│        └──dark/element/color.json       // 深色模式颜色资源
├──features
│  ├──stockdeal/src/main
│  │  ├──ets
│  │  │  ├──chartmodels                   // 图表组件
│  │  │  │  ├──BarChartView.ets           // 柱状图组件
│  │  │  │  ├──ChartAxisFormatter.ets     // 图表轴数据格式化
│  │  │  │  └──LineChartModel.ets         // 折线图组件
│  │  │  ├──models                        // 股票交易数据模型
│  │  │  │  └──StockDealDataModel.ets
│  │  │  ├──viewmodels                    // 股票交易视图模型
│  │  │  │  └──StockDealViewModel.ets
│  │  │  └──views                         // 股票交易视图组件
│  │  │     ├──BuyPopUp.ets               // 买入股票弹窗
│  │  │     ├──RegularWayPopUp.ets        // 常规交易弹窗
│  │  │     ├──StockDealDetails.ets       // 股票交易详情
│  │  │     ├──StockDealItem.ets          // 股票交易项
│  │  │     └──StockKLineChart.ets        // 股票K线图表
│  │  └──resources                        // 应用静态资源目录
│  ├──stockdetail/src/main
│  │  ├──ets
│  │  │  ├──models                        // 股票详情数据模型
│  │  │  │  └──DataModel.ets
│  │  │  ├──pages                         // 股票详情页
│  │  │  │  └──StockDetailsPage.ets
│  │  │  ├──viewmodels                    // 股票详情视图模型
│  │  │  │  └──StockDetailViewModel.ets
│  │  │  └──views                         // 股票详情视图组件
│  │  │     ├──MultiWindowEntryComponent.ets  // 多窗口入口组件
│  │  │     ├──StockDetailsInfo.ets       // 股票详情信息
│  │  │     ├──StockInFormList.ets        // 股票列表组件
│  │  │     ├──StockTable.ets             // 股票表格组件
│  │  │     └──TopTitleBar.ets            // 顶部标题栏
│  │  └──resources                        // 应用静态资源目录
│  └──stockmarket/src/main
│     ├──ets
│     │  ├──models                        // 股票市场数据模型
│     │  │  └──StockDealDataModel.ets
│     │  ├──viewmodels                    // 股票市场视图模型
│     │  │  └──StockMarketViewModel.ets
│     │  └──views                         // 股票市场视图组件
│     │     └──StockMarketList.ets        // 股票市场列表
│     └──resources                        // 应用静态资源目录
└──products
   ├──default/src/main
   │  ├──ets
   │  │  ├──entryability                  // 程序入口
   │  │  │  └──EntryAbility.ets
   │  │  ├──entrybackupability            // 程序备份入口
   │  │  │  └──EntryBackupAbility.ets
   │  │  ├──pages                         // 首页
   │  │  │  ├──Index.ets
   │  │  │  └──OptionPage.ets
   │  │  ├──splitScreenAbility            // 分屏能力
   │  │  │  └──SplitScreenAbility.ets
   │  │  └──splitScreenBackupAbility      // 分屏备份能力
   │  │     └──SplitScreenBackupAbility.ets
   │  └──resources                        // 应用静态资源目录
   └──pc/src/main
      ├──ets
      │  ├──pages                         // PC端页面
      │  │  ├──Index.ets                  // PC首页
      │  │  └──OptionPage.ets             // 选项页面
      │  ├──pcability                      // PC程序入口
      │  │  └──PcAbility.ets
      │  └──pcbackupability                // PC程序备份入口
      │     └──PcBackupAbility.ets
      └──resources                        // 应用静态资源目录
```

## 具体实现

* 通过应用内多窗组件MultiWindowEntryInAPP提供的单应用多窗口接口，实现一个应用多个窗口并行运行的体验。
* 根据不同断点或状态改变navigation的mode属性，实现单栏和三栏的切换效果。
* 柱状图和折线图使用mpchart三方库。

## 相关权限

不涉及。

## 依赖

* 柱状图和折线图使用mpchart三方库。

## 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：直板机、双折叠（Mate X系列）、阔折叠、三折叠、平板和电脑。

2. HarmonyOS系统：HarmonyOS 6.0.2 Release及以上。

3. DevEco Studio版本：DevEco Studio 6.0.2 Release及以上。

4. HarmonyOS SDK版本：HarmonyOS 6.0.2 Release SDK及以上。

5. 该Sample进入分屏/全景多窗使用的MultiWindowEntryInAPP组件，目前支持分屏/全景多窗（MultiWindowEntryInAPP组件）设备有： Mate X5、Mate X6、Mate XTs、MatePad Air 12英寸（2025）、MatePad Pro 12.2 英寸（2025）、MatePad Pro 13.2 英寸（2025）。

