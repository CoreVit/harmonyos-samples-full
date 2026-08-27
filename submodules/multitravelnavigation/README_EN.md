# Multi-Device Map Navigation UI

### Overview

This sample uses Map Kit capabilities to implement typical multi-device scenarios, including the map home page, location search, place details, route planning, and live captions.

### Preview

| Pura X outer screen | Bar phone | Foldable phone (expanded) |
| --- | --- | --- |
| <img src="screenshots/device_en/purax/home_half.png" width="180" /> | <img src="screenshots/device_en/phone/home_half.png" width="180" /> | <img src="screenshots/device_en/fold/home_high.png" width="220" /> |
| **Tablet** | **PC** |  |
| <img src="screenshots/device_en/tablet/home_high.png" width="300" /> | <img src="screenshots/device_en/pc/home.png" width="300" /> |  |

### How to Use

1. Before using this sample, configure AppGallery Connect and enable Map Kit services by referring to the [Enabling Map Kit](https://developer.huawei.com/consumer/en/doc/harmonyos-guides/map-config-agc#section16133115441516). To experience live captions on the phone product, apply for the required Live View Kit permissions as well, referring to [Preparations](https://developer.huawei.com/consumer/en/doc/harmonyos-guides/liveview-preparations).

2. Developers need to change the project's bundle name to a custom name:

   ![bundleName](./screenshots/device_en/bundleName.png)

3. Ensure that the device is connected to the Internet and location services are enabled. Grant the location permission when the app is launched for the first time. The app adapts its layout for bar phones, foldable phones, tablets, PCs, and other device forms.

4. The entry for phones, foldable phones, tablets, and similar products is `products/default`, which includes map navigation and live captions. The entry for PCs is `products/pc`, which focuses on the large-screen map navigation experience and does not include live captions.

5. Panel forms vary by device. A bar phone uses a bottom sheet with low, middle, and high levels. An expanded foldable phone or tablet uses a floating panel, which opens at the high level by default, supports dragging to adjust height, and can be shown or hidden by tapping the map. The Pura X outer screen uses a Mini panel that supports only the middle and high levels. A PC uses a fixed left sidebar and does not participate in bottom-sheet or floating-panel level switching.

6. On the home page, tap the search box, enter a place, address, or bus-related keyword, and submit it to obtain nearby places through the nearby search API.

7. Search results adapt to the panel form. In the bottom sheet, the default level uses a horizontal list and the high level uses a vertical list. In the Mini panel, the default state uses a compact height and the high level expands to show the full list. Floating panels and the PC sidebar mainly use a vertical list. Tap the cancel button next to the input box or use the system back button to return to the home page.

8. Tap a search result to enter the place detail page, where you can view basic place information, recommendations, and bottom action buttons. The bottom buttons are fixed at the bottom of the detail panel, and the content area scrolls or expands with the panel height.

9. Tap the route or navigation button on the place detail page or search result page to enter the route planning page. Driving is the default travel mode. Up to three routes can be planned, and the first route is displayed by default.

10. Route planning results adapt to the panel form. In the bottom sheet, the default level uses a horizontal list, the high level uses a vertical list, and the low level shows only the input area. The Mini panel does not show the low level. Floating panels and the PC sidebar keep a vertical browsing layout that better fits large screens. Tap different routes to switch the route displayed on the map.

### Project Directory

```
├──commons                                // Common capability layer
│  └──multitravelbase                     // Shared base module
│     └──src
│        └──main
│           ├──ets
│           │  ├──constants               // Common constants
│           │  ├──model                   // Shared cross-module states and data models
│           │  └──utils                   // Common utilities, including logging, location, window, map scene, and resource text helpers
│           └──resources                  // Common resources
├──features                               // Base feature layer
│  ├──mapcontainer                        // Map container module
│  │  └──src
│  │     └──main
│  │        ├──ets
│  │        │  ├──model                   // Map viewport and padding coordination model
│  │        │  ├──pages                   // Map main page entry
│  │        │  ├──view                    // Map base view, panel container, and PC decorative toolbar views
│  │        │  └──viewmodel               // Map main page state management
│  │        └──resources                  // Map container resources
│  ├──maplive                             // Live View / live caption module
│  │  └──src
│  │     └──main
│  │        ├──ets
│  │        │  ├──constants               // Live View / live caption constants
│  │        │  └──viewmodel               // Live View / live caption control logic
│  │        └──resources                  // Live View / live caption resources
│  └──poiexplore                          // POI exploration module
│     └──src
│        └──main
│           ├──ets
│           │  ├──constants               // POI exploration constants
│           │  ├──model                   // Home display, place detail, search, and route planning data models
│           │  ├──view                    // Home, search, detail, and route planning views
│           │  └──viewmodel               // View models for search, place details, and route planning
│           └──resources                  // POI exploration resources
└──products                               // Product customization layer
   ├──default                             // Default phone/tablet product
   │  └──src
   │     └──main
   │        ├──ets
   │        │  ├──defaultability          // Default product entry
   │        │  └──pages                   // Default product pages
   │        └──resources                  // Default product resources
   └──pc                                  // PC product
      └──src
         └──main
            ├──ets
            │  ├──pages                   // PC product pages
            │  └──pcability               // PC product entry
            └──resources                  // PC product resources

```

### Required Permissions

1. **ohos.permission.APPROXIMATELY_LOCATION** and **ohos.permission.LOCATION**: allow the app to obtain the device location.
2. To use Map Kit, configure AppGallery Connect and [Enabling Map Kit](https://developer.huawei.com/consumer/en/doc/harmonyos-guides/map-config-agc#section16133115441516) by referring to the guide.
3. To use Live View Kit capabilities, enable the required permissions by referring to the [Preparations](https://developer.huawei.com/consumer/en/doc/harmonyos-guides/liveview-preparations).

### Dependencies

N/A

### Constraints

1. This sample can run only on standard-system devices. Supported devices include bar phones, bi-fold phones (Mate X series), tri-fold phones, Pura X-style wide foldables, tablets, and PCs.
2. HarmonyOS version: HarmonyOS 6.0.2 Release or later.
3. DevEco Studio version: DevEco Studio 6.1.0 Release or later.
4. HarmonyOS SDK version: HarmonyOS 6.1.0 Release SDK or later.
