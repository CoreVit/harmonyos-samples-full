# Anti-peeping for Sensitive Information

## Overview

This sample leverages screen privacy protection and ArkUI state management to help you implement the functionality of hiding sensitive information when there are strangers peeping at the screen.

## Preview

| Phone Non-peeping State                                      | Fode Peeping State                                           |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="screenshots/phone/en/phone_hide.png" width="320"/> | <img src="screenshots/phone/en/fold_hide.png" width="560"/>  |
| <img src="screenshots/phone/en/phone_system_layer.png" width="320"/> | <img src="screenshots/phone/zh/fold_system_layer.png" width="560"/> |

## How to Use

1. Download the sample code and import it to DevEco Studio. Open `AppScope > app.json` and change the value of `bundleName` to your application name.

2. Apply for a profile with the ohos.permission.DLP_GET_HIDE_STATUS permission for the application corresponding to the `bundleName` in the first step by referring to [Configuring a Debug Signature](https://developer.huawei.com/consumer/en/doc/harmonyos-guides/ide-signing), and configure the corresponding signature information in the project.

3. After building and installing the application, go to `Settings > Privacy & security > Screen Privacy`, and turn on the switch.

4. When both the owner and non-owner view the screen, the number information on the screen is hidden. In other cases, the content is directly displayed.

5. If the privacy protection overlay option is enabled, the system privacy protection overlay page will pop up once when a peeping state is detected. Subsequent peeping states will not trigger the overlay again until you re-enter the settings page.

## Project Directory

```
├──entry/src/main/ets
│  ├──common
│  │  ├──models
│  │  │  └──ItemInfo.ets                // Service data class
│  │  └──CommonConstants.ets            // Common constants
│  ├──entryability
│  │  └──EntryAbility.ets               // Entry point class
│  ├──entrybackupability
│  │  └──EntryBackupAbility.ets         // Data backup and restoration
│  ├──pages
│  │  └──Index.ets                      // Home page
│  ├──utils
│  │  ├──AntiPeepUtils.ets              // Anti-peeping protection utility
│  │  ├──BreakpointSystem.ets           // breakpoint utils
│  │  ├──Logger.ets                     // Log utils
│  │  └──WindowUtil.ets                 // window utils
│  └──view
│     ├──CustomItemInfo.ets             // Item information
│     └──Titles.ets                     // Title information
└──entry/src/main/resources             // Static resources of the application
```

## How to Implement

1. Use the `Text` component to display UI text, and modify the content via the `@State` and `@ObjectLink` state variables.

2. During page display, call the `getDlpAntiPeepInfo` API to obtain the latest peeping state of the current device.

3. During page display, call the `dlpAntiPeep.on('dlpAntiPeep',callback)` callback API to obtain the latest peeping state of the current device in real time.

4. Based on the data returned in steps 2 and 3, update the variables modified by `@State` and `@ObjectLink` to hide and display sensitive content according to whether a peeping state is detected.

5. When a peeping state is detected, the system privacy protection overlay page will be triggered via the `setAntiPeepMaskLayer(windowId)` API to obscure the entire screen.

## Required Permissions

- `ohos.permission.DLP_GET_HIDE_STATUS`: allows an application to detect whether the screen is being viewed by others.

## Dependencies

- N/A

## Constraints

1. In this sample, the `Screen Privacy` option must be available in `Settings > Privacy & security`.

2. The HarmonyOS version must be HarmonyOS 6.0.2 Release or later.

3. The DevEco Studio version must be DevEco Studio 6.0.2 Release or later.

4. The HarmonyOS SDK version must be HarmonyOS 6.0.2 Release SDK or later. 