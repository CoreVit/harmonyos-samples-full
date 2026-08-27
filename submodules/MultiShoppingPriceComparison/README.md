# 多设备购物比价界面

## 项目简介

本示例基于一次开发、多端部署能力，实现购物比价类应用的界面与流程，覆盖直板机、折叠屏、平板及电脑等多种设备形态。工程采用 **products（产品层）、features（特性层）、common/multishoppingbase（公共能力 HAR）** 三层架构组织代码，结合自适应布局与响应式布局，构建从首页推荐、分类浏览到商品详情、直播带货与支付半屏的完整体验。公共层提供断点工具、窗口与画中画、播放器等能力，供各特性模块复用。

## 效果预览

| 直板机                                                   | 双折叠                                                      | 平板                                                     |
|-------------------------------------------------------|----------------------------------------------------------|--------------------------------------------------------|
| <img src="screenshots/device/phone_zh.png" width=180> | <img src="screenshots/device/foldable_zh.png" width=330> | <img src="screenshots/device/tablet_zh.png" width=580> |

## 使用说明

1. 在直板机、折叠屏、平板或电脑上安装并打开本工程构建生成的应用。安装完成后打开应用，即可在不同设备与窗口尺寸下看到通过自适应与响应式布局呈现的购物首页、分类与商品详情等界面。

2. 打开应用后，在首页可浏览推荐区块、优惠与精选等内容；顶部区域结合断点展示 Tab 与搜索入口。在分类页可浏览分类 Banner 与商品列表。

3. 点击底部 **分类** 相关入口进入分类页。

4. 在分类页点击商品图，或通过首页等入口进入 **商品详情**：可查看轮播、价格、配置、优惠与用户评论等区块；在支持的设备上可通过标题栏菜单进入
   **分屏**，对比商品信息。

5. 在商品详情页底部可操作 **加购 / 购买** 等按钮：购买可弹出支付半屏（`PayCard` 等）；购物袋入口可查看与直播联动的购物袋列表。

6. 在商品详情中进入 **直播** 页面：可观看直播布局、评论与推荐商品列表；在支持的设备上点击关闭等操作可触发 **画中画**
   。在直播间可打开购物袋、发起购买流程。

7. 在 **PC 端产品**，直播页等场景会使用与手机端差异化的顶栏（如 `LiveHeaderPC`）与侧栏布局；具体交互以当前
   `LiveBroadCastPage` 等页面实现为准。

## 工程目录

```
├──common
│  └──multishoppingbase                                         // 公共能力层 HAR（断点、窗口、画中画、Tab 等）
│     └──src
│        └──main
│           └──ets
│              ├──constants
│              │  ├──BreakpointConstants.ets                    // 断点相关常量
│              │  └──CommonConstants.ets                        // 公共静态常量
│              ├──model
│              │  ├──CategoryHeaderModel.ets                    // 分类页头部数据
│              │  ├──HomeHeaderModel.ets                        // 首页头部 Tab 数据
│              │  ├──IndexTabItemModel.ets                      // 底部 Tab 单项模型
│              │  └──IndexTabsModel.ets                         // 底部 Tab 默认数据
│              ├──utils
│              │  ├──AbilityStorageKey.ets                      // 按 Ability 隔离的 AppStorage 键
│              │  ├──AvPlayerUtil.ets                           // AVPlayer 播放封装
│              │  ├──Logger.ets                                 // 日志工具
│              │  ├──PipWindowUtil.ets                          // 画中画工具
│              │  ├──WidthBreakpointType.ets                    // 断点取值工具
│              │  └──WindowUtil.ets                             // 窗口与系统栏工具
│              ├──view
│              │  ├──CategoryHeader.ets                         // 分类页头部
│              │  ├──HomeHeader.ets                             // 首页顶部 Tab 与搜索
│              │  └──IndexTabComponent.ets                      // 底部 Tab 单项组件
│              └──viewmodel
│                 ├──CategoryHeaderState.ets                    // 分类头部状态
│                 ├──HomeHeaderState.ets                        // 首页头部状态
│                 └──IndexTabsState.ets                         // 底部 Tab 状态
├──features                                                     // 基础特性层
│  ├──multishoppingrecommend                                    // 首页推荐与分类展示
│  │  └──src
│  │     └──main
│  │        └──ets
│  │           ├──components
│  │           │  ├──CategoryBanner.ets                         // 分类 Banner
│  │           │  ├──HomeDiscount.ets                           // 首页优惠区块
│  │           │  ├──HomePreferred.ets                          // 首页精选
│  │           │  ├──HomeRecommend.ets                          // 首页推荐容器
│  │           │  └──HomeRecommendCard.ets                      // 推荐卡片
│  │           ├──model
│  │           │  ├──CategoryBannerModel.ets                    // 分类 Banner 数据
│  │           │  ├──HomeDiscountModel.ets                      // 优惠数据
│  │           │  ├──HomePreferredModel.ets                     // 精选数据
│  │           │  └──RecommendedProductModel.ets                // 推荐商品数据
│  │           └──viewmodel
│  │              ├──CategoryBannerState.ets                    // 分类 Banner 状态
│  │              ├──HomeDiscountState.ets                      // 优惠状态
│  │              ├──HomePreferredState.ets                     // 精选状态
│  │              └──HomeRecommendCardState.ets                 // 推荐卡片状态
│  ├──multishoppingproduct                                      // 商品详情与列表
│  │  └──src
│  │     └──main
│  │        └──ets
│  │           ├──components
│  │           │  ├──MobilePhoneList.ets                        // 分类商品列表
│  │           │  ├──ProductCategory.ets                        // 商详分类区块
│  │           │  ├──ProductClassification.ets                  // 规格分类
│  │           │  ├──ProductConfig.ets                          // 配置信息
│  │           │  ├──ProductDetailContent.ets                   // 商详主体布局
│  │           │  ├──ProductDiscount.ets                        // 优惠信息
│  │           │  ├──ProductInfo.ets                            // 商品信息汇总
│  │           │  ├──ProductPrice.ets                           // 价格展示
│  │           │  ├──ProductSwiper.ets                          // 商详轮播
│  │           │  ├──ProductUtil.ets                            // 底部操作条
│  │           │  └──UserComments.ets                           // 用户评论
│  │           ├──model
│  │           │  ├──MobilePhoneListModel.ets                   // 列表数据
│  │           │  ├──ProductCategoryModel.ets                   // 分类数据
│  │           │  ├──ProductCategoryNavModel.ets                // 分类导航
│  │           │  ├──ProductInfoModel.ets                       // 商详文案与资源
│  │           │  └──ProductSwiperModel.ets                     // 轮播资源
│  │           └──viewmodel
│  │              ├──MobilePhoneListState.ets                   // 列表状态
│  │              ├──ProductCategoryState.ets                   // 分类状态
│  │              ├──ProductClassificationState.ets             // 规格状态
│  │              ├──ProductInfoState.ets                       // 商详状态
│  │              ├──ProductSwiperState.ets                     // 轮播状态
│  │              └──ProductUtilState.ets                       // 底部条文案状态
│  ├──multishoppinglive                                         // 直播
│  │  └──src
│  │     └──main
│  │        └──ets
│  │           ├──components
│  │           │  ├──LiveBroadCast.ets                          // 直播页容器
│  │           │  ├──LiveComment.ets                            // 直播评论列表
│  │           │  ├──LiveContent.ets                            // 直播视频区域
│  │           │  ├──LiveHeader.ets                             // 直播顶栏（移动端）
│  │           │  ├──LiveHeaderPC.ets                           // 直播顶栏（PC）
│  │           │  ├──LiveShopList.ets                           // 直播商品列表
│  │           │  └──LiveUtil.ets                               // 底部输入与操作
│  │           ├──model
│  │           │  ├──LiveCommentModel.ets                       // 评论数据
│  │           │  ├──LiveProduct.ets                            // 直播商品模型
│  │           │  └──LiveShopListModel.ets                      // 商品列表数据
│  │           └──viewmodel
│  │              ├──LiveCommentState.ets                       // 评论状态
│  │              └──LiveHeaderState.ets                        // 顶栏状态
│  └──multishoppingpay                                          // 购物袋与支付
│     └──src
│        └──main
│           └──ets
│              ├──components
│              │  ├──PayCard.ets                                // 支付半屏
│              │  ├──ShopBag.ets                                // 购物袋
│              │  ├──ShopBagHeader.ets                          // 购物袋头部
│              │  └──ShopList.ets                               // 购物袋商品列表
│              ├──model
│              │  ├──PayCardModel.ets                           // 支付相关数据
│              │  └──ShopBagModel.ets                           // 购物袋数据
│              └──viewmodel
│                 ├──PayCardViewModel.ets                       // 支付 UI 数据
│                 └──ShopBagViewModel.ets                       // 购物袋 UI 数据
└──products                                                     // 产品定制层
   ├──default                                                   // 默认（手机/折叠/平板等）产品
   │  └──src
   │     └──main
   │        └──ets
   │           ├──constants
   │           │  ├──CommonConstants.ets                        // 默认产品常量
   │           │  └──RouteConstants.ets                         // 路由名等常量
   │           ├──defaultability
   │           │  └──DefaultAbility.ets                         // 默认入口 Ability
   │           ├──defaultbackupability
   │           │  └──DefaultBackupAbility.ets                   // 备份扩展 Ability
   │           ├──pages
   │           │  ├──Category.ets                               // 分类页
   │           │  ├──Home.ets                                   // 首页
   │           │  ├──Index.ets                                  // 导航与根页面
   │           │  ├──LiveBroadCastPage.ets                      // 直播页（默认产品）
   │           │  ├──ProductDetail.ets                          // 商品详情页
   │           │  └──RootTabsPage.ets                           // 底部 Tab 容器
   │           └──shopsecondability
   │              └──ShopSecondAbility.ets                        // 分屏副窗入口 Ability
   └──pc                                                        // PC 端产品
      └──src
         └──main
            └──ets
               ├──pages
               │  ├──Category.ets                               // PC 分类页
               │  ├──Home.ets                                   // PC 首页
               │  ├──Index.ets                                  // PC 导航入口
               │  ├──LiveBroadCastPage.ets                      // PC 直播页
               │  ├──ProductDetail.ets                          // PC 商品详情
               │  └──RootTabsPage.ets                           // PC 底部 Tab
               ├──pcability
               │  └──PcAbility.ets                              // PC 入口 Ability
               ├──pcbackupability
               │  └──PcBackupAbility.ets                        // PC 备份扩展
               └──shopsecondability
                  └──ShopSecondAbility.ets                       // PC 分屏副窗入口 Ability
```

## 具体实现

1. 将工程目录按照 **products、features、common/multishoppingbase** 三层架构进行组织。在 **products** 层提供 **default** 与 **pc**
   两套产品源码：`default` 面向直板机、折叠屏与平板等常见形态；`pc` 面向电脑形态下的页面与入口差异（如直播顶栏
   `LiveHeaderPC`、侧栏宽度等）。在 **features** 层实现 **multishoppingrecommend**（首页与分类推荐）、**multishoppingproduct**
   （商品详情与列表）、**multishoppinglive**（直播）、**multishoppingpay**（购物袋与支付）等业务模块，供 products 层按需组合；在 **common** 存放断点工具、首页/分类头部与底部 Tab、窗口与画中画、播放器等通用能力。模块依赖关系见根目录
   `build-profile.json5`。

2. 首页与分类（**multishoppingrecommend** + **common**）模块：
    - **首页推荐与优惠区域**
        - 在直板机、折叠屏与平板等设备上：通过 `WidthBreakpointType`
          与栅格、列表等组件，在不同断点下调整间距、列数与区块高度，实现推荐卡片、优惠条等布局。
    - **顶部 Tab 与搜索、底栏 Tab**
        - 首页顶部 Tab
          与搜索区域由公共层组件承载，结合断点调整布局。
          。底部主导航由 `IndexTabComponent` 与 `IndexTabsState`
          等管理。
    - **分类页 Banner 与列表**
        - 分类页头部与 Banner 使用公共层 `CategoryHeader` 与特性层 `CategoryBanner`
          等组合。

3. 商品详情（**multishoppingproduct**）模块：
    - **商详布局与分栏**
        - 在直板机、折叠屏与平板等设备上：`ProductDetailContent` 使用 `Flex` 与 `Scroll` 等，在宽屏下将轮播与信息区横向排列，窄屏下纵向堆叠；底部
          `ProductUtil` 通过 `RelativeContainer`
          与断点规则贴近安全区。
    - **价格、配置、优惠与评论**
        - 各区块由独立组件与 `ProductInfoState`
          等状态类驱动展示文案与资源。

4. 购物袋与支付（**multishoppingpay**）模块：
    - **购物袋与商品列表**
        - `ShopBag` 与 `ShopList` 展示购物袋内容及优惠标签；头部使用 `ShopBagHeader`
          。
    - **支付半屏**
        - `PayCard` 与 `PayCardViewModel` 等实现规格选择与支付信息展示，由商品详情或直播页通过 `bindSheet`
          等方式拉起。

5. 直播（**multishoppinglive**）与公共播放/画中画：
    - **直播画面与评论、商品列表**
        - `LiveContent` 使用 `XComponent` 与 `AvPlayerUtil` 完成播放面绑定与控制；`LiveComment`、`LiveShopList`
          叠加在内容之上。
    - **画中画**
        - 在支持的设备上，直播页关闭等逻辑可调用 `PipWindowUtil` 进入画中画（与 `deviceInfo` 等条件配合，以
          `LiveBroadCastPage`
          实现为准）。
    - **PC 端直播页**
        - PC 产品在 `LiveBroadCastPage` 中组合 `LiveHeaderPC`
          与侧栏购物袋等，与默认产品页面形成差异。

## 相关权限

不涉及。

## 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：直板机、双折叠（Mate X系列）、平板、电脑。
2. HarmonyOS系统：HarmonyOS 6.0.0 Release及以上。
3. DevEco Studio版本：DevEco Studio 6.0.2 Release及以上。
4. HarmonyOS SDK版本：HarmonyOS 6.0.2 Release SDK及以上。
