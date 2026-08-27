# Implementing the Wave Wheel Menu Function of Image Editing Software<a name="EN-US_TOPIC_0000002648360464"></a>

**Overview**

The wave wheel menu function is integrated based on the image editing demo, which can be obtained from  [https://gitcode.com/HarmonyOS_Samples/PixelMapImageEdit](https://gitcode.com/HarmonyOS_Samples/PixelMapImageEdit). 

The image editing demo decodes images to convert them into the PixelMap format and obtains and displays the information about the decoded original images. You can use PixelMap to implement image editing, including geometric transformations \(cropping, rotation, translation, zooming, and mirroring\) and color adjustment \(brightness, opacity, and saturation\). Once editing is complete, the image can be re-encoded and saved to the Gallery. 

On the image editing page, after the stylus is connected to the phone, the stylus switches to the writing mode. You can tap the stylus writing button to display the wave wheel menu.

**Preview**

| **Phone**                                 | **Bi-fold Phone**                                | **Tablet**                                  |
| ------------------------------------ |----------------------------------------| ------------------------------------- |
| ![](screenshots/device/phone_en.png) | ![](screenshots/device/foldable_en.png) | ![](screenshots/device/tablet_en.png) |


**How to Use**

1.  Tap the information icon on the top to view the original image information.
2.  Use the bottom tabs to switch between different editing features.
    -   **Cropping**: cropping in multiple proportions
    -   **Adjustment**: adjusting brightness, opacity, and saturation
    -   **Filter**: applying various filter effects
    -   **Translation**: moving the image horizontally or vertically
    -   **Zooming**: zooming in or out an image

3.  Preview the editing effect in real time.
4.  Tap the save icon to save the edited image.
5.  Tap the information button on the top of the image editing page to display the usage guide of the wave wheel menu.
6.  Tap the rightmost button on the top of the image editing page to display the settings page of the wave wheel menu. You can set the options and order of the wave wheel menu on the page.
7.  After the stylus is connected to the phone, the stylus switches to the writing mode on the image editing page. You can tap the writing button to display the wave wheel menu.

**Project Directory**

```
├──entry/src/main/ets
│  ├──common
│  │  └──constant
│  │     ├──CommonConstants.ets    // Common constants
│  │     └──WaveWheelConstant.ets  // Wave wheel menu constants
│  ├──entryability
│  │  └──EntryAbility.ets
│  ├──entrybackupability
│  │  └──EntryBackupAbility.ets
│  ├──pages
│  │  ├──Index.ets                // Entry page
│  │  ├──PictureEdit.ets          // Editing page
│  │  └──PixelMapManager.ets      // PixelMap instance
│  ├──types
│  │  └──CommonTypes.ets          // Common types
│  ├──utils
│  │  ├──AdjustUtil.ets           // Adjustment utility
│  │  ├──CropUtil.ets             // Cropping utility
│  │  ├──DecodeUtil.ets           // Decoding utility
│  │  ├──EditController.ets       // Editing controller
│  │  ├──Logger.ets               // Log utility
│  │  ├──MultiDeviceUtil.ets      // Multi-device adaptation
│  │  ├──NavigationTransitionUtils.ets // Navigation transition
│  │  ├──OpacityUtil.ets          // Opacity utility
│  │  └──StorageManager.ets       // Storage management
│  ├──view
│  │  ├──AdjustContentView.ets    // Adjustment component
│  │  ├──AlertDialog.ets          // Dialog
│  │  ├──ApplyFilterView.ets      // Filter component
│  │  ├──CropView.ets             // Cropping component
│  │  ├──FoldedDialog.ets         // Foldable screen dialog
│  │  ├──NoPermissionDialog.ets   // No permission dialog
│  │  ├──TranslateView.ets        // Translation component
│  │  ├──UnsavedDialog.ets        // Unsaved dialog
│  │  ├──WaveWheelSettingView.ets // Wave wheel menu setting
│  │  └──ZoomView.ets             // Zooming component
│  ├──viewModel           
│  │  ├──EditStateViewModel.ets   // Editing state model
│  │  ├──IconListViewModel.ets    // Icon model
│  │  ├──MessageItem.ets          // Message
│  │  ├──OptionViewModel.ets      // Operation enumeration
│  │  ├──RegionItem.ets           
│  │  ├──TaskViewModel.ets        // Task model
│  │  └──WindowMenuHelper.ets     // Window menu helper
│  └──workers
│     └──AdjustWork.ets           // Worker thread         
├──wavewheel/src/main/ets
│  ├──common
│  │  ├──Constants.ets            // Constants
│  │  └──FloatingWindowsManager.ets // Floating window management
│  ├──components
│  │  └──EntranceButton.ets       // Entry button component
│  ├──controllers
│  │  └──WaveWheelController.ets  // Wave wheel menu controller
│  ├──model
│  │  ├──EntranceButtonModel.ets  // Entry button model
│  │  └──Model.ets                // Model
│  ├──pages
│  │  └──WaveWheelPage.ets        // Wave wheel menu page
│  └──utils
│     ├──ApiChecker.ets           // API check
│     ├──BreakPointInfo.ets       // Breakpoint information
│     ├──Logger.ets               // Log utility
│     └──Style.ets                // Style
└──resources
```

**How to Implement**

1.  Image decoding: the process of decoding an archived image in supported formats into a unified PixelMap for image display or processing in applications or systems.
2.  Image information: displaying image information after decoding.
3.  Image editing: image editing using the decoded PixelMap, including cropping, rotation, color gamut adjustment, translation, and zooming.
4.  Image encoding: the process of encoding a PixelMap into an archived image in different formats \(only in JPEG, WebP, and PNG currently\) for subsequent processing, such as saving and transmission.
5.  Wave wheel menu: Use the SDK of the wave wheel menu to integrate the wave wheel menu.

**Required Permissions**

None

**Constraints**

1.  This sample is only supported on devices running standard systems, including bar-type phones, bi-fold devices, tri-fold devices, and tablets.
2.  The HarmonyOS version must be HarmonyOS 6.0.0 Release or later.
3.  The DevEco Studio version must be DevEco Studio 6.0.0 Release or later.
4.  The HarmonyOS SDK version must be API Version 20 or later.
5.  For details about the stylus and compatible models, see:
    -   List of stylus devices supported by Huawei phones.
    -   HUAWEI tablet/laptop models that support HUAWEI styluses.

