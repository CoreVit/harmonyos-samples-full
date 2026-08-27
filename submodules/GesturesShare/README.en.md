# Grabbing and Dropping Files and Links Using Share Kit

## Overview

This sample demonstrates how to use Share Kit to share files and App Linking URLs across devices, enabling direct navigation to the in-app video playback page. To achieve this, register a grab & drop event listener using the harmonyShare.on('gesturesShare') method, and use sharableTarget.share() within the callback to share files or URLs. This allows users to transfer content across devices by simply grabbing and dropping it.

## Effect

| phone                                            | foldable                                        | tablet                                         |
|--------------------------------------------------|-------------------------------------------------|------------------------------------------------|
| <img src="screenshots/device/phone_file_en.png"> | <img src="screenshots/device/fold_file_en.png"> | <img src="screenshots/device/pad_file_en.png"> |
| <img src="screenshots/device/phone_url_en.png">  | <img src="screenshots/device/fold_url_en.png">  | <img src="screenshots/device/pad_url_en.png">  |

## How to Use

1. Before running your project, configure App Linking and manually sign your application. For details, see [Using App Linking for App-to-App Redirection](https://developer.huawei.com/consumer/en/doc/harmonyos-guides/app-linking-startup).
2. Open the [ShareModel.ets](feature/gesturesshareshare/src/main/ets/model/ShareModel.ets) file, replace the content parameter in the share() method with a valid link, and change the host field of uris in the [module.json5](gesturessharesample/src/main/module.json5) file to a valid domain name.
3. Install and run the sample code on both device A and device B. Ensure that the screens are unlocked and turned on, and Huawei Share on both devices is enabled (enabled by default).
4. [Enable Grab & Drop on a device](https://developer.huawei.com/consumer/en/doc/harmonyos-guides/gestures-share-open).
5. On device A, go to the home page and tap the gesture share file button to access the file transfer page. Select a file and share it with device B via grab & drop.
6. On device A, go to the home page and tap the gesture share link button to access the link transfer page. Select a link and share it with device B via grab & drop. Device B will then launch the application directly and navigate to the video playback page.

## Project Directory

```
├──gesturessharecommon/src/main/ets 
│  ├──constants 
│  │  └──Constants.ets                           // constants 
│  ├──utils 
│  │  ├──BreakpointSystem.ets                    // Breakpoint system utility 
│  │  ├──FileUtil.ets                            // File processing utility 
│  │  ├──Logger.ets                              // Logger utility
│  │  ├──ResourceUtil                            // Resource utility
│  │  └──WindowUtils.ets                         // Window processing utility
│  └──resources                                  // Resources 
├──feature 
│  └──gesturesshareshare/src/main/ets 
│     ├──model 
│     │  ├──FileData.ets                         // File data model 
│     │  └──ShareModel.ets                       // Grab & Drop model 
│     ├──view 
│     │  ├──FileSharePageComponent.ets           // Page for file grab & drop 
│     │  └──LinkSharePageComponent.ets           // Page for link grab & drop 
│     └──resources                               // Resources 
├──gesturessharesample 
│  └──src/main/ets 
│     ├──entryability 
│     │  └──EntryAbility.ets                     // Entry ability 
│     ├──pages 
│     │  └──Index.ets                            // Home page 
│     └──resources                               // Resources 
└──service 
   └──index.html                                 // Web page for video playback, which needs to be deployed on the server
```

## How to Implement
* Register a grab & drop event listener using the harmonyShare.on('gesturesShare') method, and use sharableTarget.share() within the callback to share files or App Linking URLs. This allows users to transfer content across devices by simply grabbing and dropping it.
* Use App Linking to launch an application.

## Required Permissions

**N/A**

## Constraints

1. This sample is only supported on Huawei phones, tablets, and PCs/2-in-1 devices running standard systems.
2. The HarmonyOS version must be HarmonyOS 6.0.2 or later.
3. The DevEco Studio version must be DevEco Studio 6.0.2 or later.
4. The HarmonyOS SDK version must be HarmonyOS 6.0.2 SDK or later.