# Audio Focus Management

## Overview

This sample demonstrates video playback, music playback, and VoIP voice call based on capabilities such as **AudioRender**, **AudioCapturer**, **AVPlayer**, and **CallServiceKit**. These use cases highlight the audio stream type selection, audio focus interrupt event processing, **AudioSession** custom focus strategies, and **AVSession** background playback control. You can use other third-party audio applications on the device to experience the handling of audio conflicts between the applications and this sample.

## Preview

| Home Page                                        | Video Playback Page                             | Music Playback Page                                |
|--------------------------------------------------|-------------------------------------------------|----------------------------------------------------|
| <img src='./screenshots/phone_en.png' width=320> | <img src='./screenshots/fold_en.png' width=620> | <img src='./screenshots/tablet_en.png' width=1100> |



## Project Directory

```
├───entry/src/main/ets
│   ├───common
│   │   ├───constants                                 // Constants
│   │   │   └───CommonConstans.ets                    // Common constans
│   │   └───util                                      // Util
│   │       ├───AppRouter.ets                         // AppRouter
│   │       ├───AudioCapturerController.ets           // Audio recording controller 
│   │       ├───AudioRenderController.ets             // Audio playback controller
│   │       ├───AVPlayerController.ets                // AVPlayer controller
│   │       ├───AVSessionController.ets               // AVSession controller
│   │       ├───GlobalContext.ets                     // Context
│   │       ├───Logger.ets                            // Log utility 
│   │       ├───MediaController.ets                   // Media controller interface
│   │       ├───PermissionUtil.ets                    // Permission
│   │       ├───PiPWindowController.ets               // PiPWindow controller
│   │       ├───TimeUtils.ets                         // Time utility
│   │       └───WindowUtil.ets                        // Window utility
│   ├───component
│   │   ├───CustomButton.ets                          // Custom button
│   │   └───SegmentButton.ets                         // Segment button
│   ├───entryability                        
│   │   ├───EntryAbility.ets                          // Entry ability lifecycle callbacks
│   │   ├───VoIPCallAbility.ets                       // VoIP call ability lifecycle callbacks
│   │   └───WindowAbility.ets                         // Window ability lifecycle callbacks
│   ├───entrybackupability                  
│   │   └───EntryBackupAbility.ets                    // EntryBackupAbility lifecycle callbacks
│   └───pages
│       ├───audioScene
│       │   └───view                                             
│       │       └───AudioScene.ets                    // Audio playback scene page   
│       ├───embeddedShortVideoScene                   // Embedded short video scenario
│       │   ├───model                                             
│       │   │   ├───BulletComment.ets                 // Comment
│       │   │   ├───CaptionFont.ets                   // Captions   
│       │   │   ├───VideoInfo.ets                     // Video data
│       │   │   └───VideoParams.ets                   // Video params   
│       │   ├───view                                             
│       │   │   ├───AVVolumePanelView.ets             // Volume viewer
│       │   │   ├───BulletCommentView.ets             // Comment viewer
│       │   │   ├───CaptionFontView.ets               // Caption viewer 
│       │   │   ├───DetailPage.ets                    // Video details
│       │   │   ├───EmbeddedShortVideoScene.ets       // Embedded short video home page  
│       │   │   ├───LanguageDialog.ets                // Language switching pop-up window 
│       │   │   ├───ScaleDialog.ets                   // Zoom pop-up window 
│       │   │   ├───ScreenBrightnessView.ets          // Screen brightness viewer 
│       │   │   └───SpeedDialog.ets                   // Speed pop-up window
│       │   └───viewModel               
│       │       ├───VideoDataSource.ets               // Data structure of lazy video loading                               
│       │       └───VideoItemDataList.ets             // Video list data
│       ├───multiAudioStreamPlayScene                 // Multi-audio stream scenario
│       │   ├───view                                             
│       │   │   ├───AudioPlayItem.ets                 // Audio streaming component 
│       │   │   └───MultiAudioStreamPlayScene.ets     // Entry for multi-audio stream scenario    
│       │   └───viewModel                                              
│       │       └───AudioItem.ets                     // Audio data stream structure    
│       ├───mutePlaybackScene                         // Mute playback scenario
│       │   └───view                          
│       │       ├───AudioRenderMutePlayback.ets       // Audio mute playback                     
│       │       ├───AVPlayerMutePlayback.ets          // Video mute playback   
│       │       └───MutePlaybackScene.ets             // Mute playback             
│       ├───shortVideoScene                           // Short video scenario
│       │   ├───model                                             
│       │   │   └───VideoData.ets                     // Short video data    
│       │   ├───view                                             
│       │   │   ├───LanguageDialog.ets                // Language pop-up window  
│       │   │   ├───ShortVideoScene.ets               // Short video scenario home page 
│       │   │   ├───SpeedDialog.ets                   // Speed pop-up window
│       │   │   ├───VideoPlayer.ets                   // Video play 
│       │   │   └───VideoToolBar.ets                  // Video toolbar      
│       │   └───viewModel               
│       │       ├───AVDataSource.ets                  // Short video data structure                           
│       │       └───DataModel.ets                     // Short video data list    
│       ├───soundPoolScene                            
│       │   └───view                           
│       │       └───SoundPoolScene.ets                // Soundpool scenario    
│       ├───videoScene                                // Video playback scenario
│       │   └───view                           
│       │       └───VideoScene.ets                    // Video playback scenario page      
│       ├───voipScene                                 // Voip call scenario
│       │   └───view        
│       │       ├───VoIPCallPage.ets                  // VoIP call page                   
│       │       └───VoIPScene.ets                     // VoIP call activation page     
│       └───Index.ets                                 // Home page
└───entry/src/main/resources                          // Resources   
```

## Required Permissions
1. **ohos.permission.KEEP_BACKGROUND_RUNNING**: Allows the application to run in the background.
2. **ohos.permission.MICROPHONE**: Allows the use of the microphone.
   
## Dependencies

N/A

## Constraints

1. This sample is only supports operation on standard systems. Supported devices: bar phone, tablet, computer, dual-fold, wide-fold, triple-fold.
2. The HarmonyOS version must be HarmonyOS 6.1.0 Release or later.
3. The DevEco Studio version must be DevEco Studio 6.1.0 Release or later.
4. The HarmonyOS SDK version must be HarmonyOS 6.1.0 Release SDK or later.

