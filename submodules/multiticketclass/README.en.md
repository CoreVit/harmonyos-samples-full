# Multi-Device Stock Page

## Overview

This sample demonstrates how to develop a stock trading application that can be deployed across devices based on adaptive and responsive layouts. The application layout can adapt to different device types, such as Bar phone, Bi-fold phone(Mate X series), Widescreen foldable phone, Tri-fold phone, tablets and PC. It also supports the split-screen mode on large-screen foldable phones, Tri-fold phones(Mate X series), and tablets, facilitating users to compare stock details.

## Effect


This example is divided into two pages and two pop-up boxes. Since the breakpoints for the three-column layout and the tablet in landscape mode are both lg, in the effect preview page, only the effect diagram for the tablet device is displayed.

**Home page for selecting stocks:**


| Bar phone                                   | Foldable Screen (Unfolded)                             | Tablet                                           |
|-------------------------------------------------|--------------------------------------------------------|--------------------------------------------------|
| ![](screenshots/devices/home-page-phone.en.png) | ![](screenshots/devices/home-page-foldablescre.en.png) | ![](screenshots/devices/home-page-tablet.en.png) |

**Stock details page:**

| Bar phone                                     | Foldable Screen (Unfolded)                               | Tablet (Full Screen)                               |
|---------------------------------------------------|----------------------------------------------------------|----------------------------------------------------|
| ![](screenshots/devices/detail-page-phone.en.png) | ![](screenshots/devices/detail-page-foldablescre.en.png) | ![](screenshots/devices/detail-page-tablet.en.png) |

**Split-screen layout:**

| Bar phone | Foldable Screen (Unfolded)                                 | Tablet (Full Screen)                                |
|--------------|------------------------------------------------------------|-----------------------------------------------------|
| N/A          | ![](screenshots/devices/split-screen-foldablescre.en.png)  | ![](screenshots/devices/split-screen-tablet.en.png) |

**Stock purchase dialog:**

| Bar phone                                    | Foldable Screen (Unfolded)                             | Tablet                                           |
|-------------------------------------------------|--------------------------------------------------------|--------------------------------------------------|
| ![](screenshots/devices/stock-pop-phone.en.png) | ![](screenshots/devices/stock-pop-foldablescre.en.png) | ![](screenshots/devices/stock-pop-tablet.en.png) |

**Stock purchase confirmation dialog:**

| Bar phone                                          | Foldable Screen (Unfolded)                                    | Tablet                                                  |
|--------------------------------------------------------|---------------------------------------------------------------|---------------------------------------------------------|
| ![](screenshots/devices/stock-affirm-pop-phone.en.png) | ![](screenshots/devices/stock-affirm-pop-foldablescre.en.png) | ![](screenshots/devices/stock-affirm-pop-tablet.en.png) |

How to Use

* Home page
  1. On the home page, tap any stock to go to the stock details page.
* Stock details page
  1. Foldable screen (unfolded) or tablet: Tap the split-screen icon in the upper right corner of the screen to enter the split-screen mode.
  2. Tablet: On the right content area, tap the zoom icon in the upper left corner to enter the full-screen mode. You can tap the back icon in the upper left corner to exit the full-screen mode.
  3. Tap the **Go Trade** button in the lower part of the page. A stock purchase dialog is displayed. In the dialog, tap **Buy**. In the subsequent dialog that appears, tap **Confirm Purchase**.

## Project Directory

```
├──commons
│  └──base/src/main
│     ├──ets
│     │  ├──baseviews                     // Common view components
│     │  │  └──CommonView.ets
│     │  ├──models                        // Common data models
│     │  │  └──StockModel.ets
│     │  └──utils                         // Common utility classes
│     │     ├──AppConstants.ets           // Application constants
│     │     ├──BreakpointType.ets         // Breakpoint type
│     │     ├──Logger.ets                 // Log utility
│     │     └──WindowUtil.ets             // Window utility class
│     └──resources                        // Application resources
│        ├──base/element/color.json       // Light mode color resources
│        └──dark/element/color.json       // Dark mode color resources
├──features
│  ├──stockdeal/src/main
│  │  ├──ets
│  │  │  ├──chartmodels                   // Chart components
│  │  │  │  ├──BarChartView.ets           // Bar chart component
│  │  │  │  ├──ChartAxisFormatter.ets     // Chart axis data formatter
│  │  │  │  └──LineChartModel.ets         // Line chart component
│  │  │  ├──models                        // Stock deal data models
│  │  │  │  └──StockDealDataModel.ets
│  │  │  ├──viewmodels                    // Stock deal view models
│  │  │  │  └──StockDealViewModel.ets
│  │  │  └──views                         // Stock deal view components
│  │  │     ├──BuyPopUp.ets               // Stock purchase dialog
│  │  │     ├──RegularWayPopUp.ets        // Regular transaction dialog
│  │  │     ├──StockDealDetails.ets       // Stock deal details
│  │  │     ├──StockDealItem.ets          // Stock deal item
│  │  │     └──StockKLineChart.ets        // Stock K-line chart
│  │  └──resources                        // Application resources
│  ├──stockdetail/src/main
│  │  ├──ets
│  │  │  ├──models                        // Stock detail data models
│  │  │  │  └──DataModel.ets
│  │  │  ├──pages                         // Stock detail pages
│  │  │  │  └──StockDetailsPage.ets
│  │  │  ├──viewmodels                    // Stock detail view models
│  │  │  │  └──StockDetailViewModel.ets
│  │  │  └──views                         // Stock detail view components
│  │  │     ├──MultiWindowEntryComponent.ets  // Multi-window entry component
│  │  │     ├──StockDetailsInfo.ets       // Stock details information
│  │  │     ├──StockInFormList.ets        // Stock list component
│  │  │     ├──StockTable.ets             // Stock table component
│  │  │     └──TopTitleBar.ets            // Top title bar
│  │  └──resources                        // Application resources
│  └──stockmarket/src/main
│     ├──ets
│     │  ├──models                        // Stock market data models
│     │  │  └──StockDealDataModel.ets
│     │  ├──viewmodels                    // Stock market view models
│     │  │  └──StockMarketViewModel.ets
│     │  └──views                         // Stock market view components
│     │     └──StockMarketList.ets        // Stock market list
│     └──resources                        // Application resources
└──products
   ├──default/src/main
   │  ├──ets
   │  │  ├──entryability                  // Program entry
   │  │  │  └──EntryAbility.ets
   │  │  ├──entrybackupability            // Program backup entry
   │  │  │  └──EntryBackupAbility.ets
   │  │  ├──pages                         // Home page
   │  │  │  ├──Index.ets
   │  │  │  └──OptionPage.ets
   │  │  ├──splitScreenAbility            // Split screen ability
   │  │  │  └──SplitScreenAbility.ets
   │  │  └──splitScreenBackupAbility      // Split screen backup ability
   │  │     └──SplitScreenBackupAbility.ets
   │  └──resources                        // Application resources
   └──pc/src/main
      ├──ets
      │  ├──pages                         // PC pages
      │  │  ├──Index.ets                  // PC home page
      │  │  └──OptionPage.ets             // Option page
      │  ├──pcability                      // PC program entry
      │  │  └──PcAbility.ets
      │  └──pcbackupability                // PC program backup entry
      │     └──PcBackupAbility.ets
      └──resources                        // Application resources
```

## How to Implement

* By leveraging the multi-window interface provided by the MultiWindowEntryInAPP component within the application, an experience of multiple windows running concurrently within a single application is achieved.
* Based on different breakpoints or state changes, modify the mode attribute of the navigation to achieve the switching effect between single-column and three-column layouts.
* The column chart and line chart use the mpchart third-party library.
  

## Required Permissions

N/A

## Dependencies

* The column chart and line chart use the mpchart third-party library.

## Constraints

1. This sample is only supported on Bar phone, Bi-fold phone(Mate X series), Widescreen foldable phone, Tri-fold phone, Tablet and PC running standard systems.
2. The HarmonyOS version must be HarmonyOS 6.0.2 Release or later.
3. The DevEco Studio version must be DevEco Studio 6.0.2 Release or later.
4. The HarmonyOS SDK version must be HarmonyOS 6.0.2 Release SDK or later.
5. This sample enters the MultiWindowEntryInAPP component for use in multi-window mode (split-screen or full-screen). Currently, devices that support the MultiWindowEntryInAPP component for multi-window mode include: Mate X5, Mate X6, Mate XTs, MatePad Air 12-inch (2025), MatePad Pro 12.2-inch (2025), and MatePad Pro 13.2-inch (2025).
