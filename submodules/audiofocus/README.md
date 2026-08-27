# 实现音频焦点管理功能

## 介绍

本示例基于AudioRender、AudioCapturer、AVPlayer以及CallServiceKit等能力，实现了视频播放、短视频播放，嵌入式短视频播放，音乐播放、短音播放、VoIP语言通话、静音播放和同应用多音频流播放场景。这些场景实现中重点突出了音频流类型选择、音频焦点中断事件处理、AudioSession自定义焦点策略以及AVSession后台播控。开发者可以使用设备上其它三方音频应用体验与本示例之间的音频冲突处理。

说明：移动端与电脑端的音频焦点在系统默认策略上存在差异。在移动端，默认策略为新应用播放时会中断或降低先前应用的音量，以避免同时大声播放。例如，用户在听音乐时打开短视频App，音乐将自动暂停或音量显著降低，确保短视频声音清晰。而在电脑端，默认策略允许多个应用的音频同时输出，音量叠加。例如，用户可以一边听音乐，一边观看游戏直播，通过调整不同窗口的音量来实现平衡。

## 效果图预览

| 直板机                                           | 折叠屏                                          | 平板                                              | 
|-----------------------------------------------|----------------------------------------------|-------------------------------------------------|
| <img src='./screenshots/phone.png' width=320> | <img src='./screenshots/fold.png' width=620> | <img src='./screenshots/tablet.png' width=1100> |


## 工程结构&模块类型

```
├───entry/src/main/ets
│   ├───common
│   │   ├───constants                                 // 常量
│   │   │   └───CommonConstans.ets                    // 公共常量页
│   │   └───util                                      // 工具
│   │       ├───AppRouter.ets                         // 路由方法
│   │       ├───AudioCapturerController.ets           // 音频捕获
│   │       ├───AudioRenderController.ets             // 音频渲染
│   │       ├───AVPlayerController.ets                // 视频播放
│   │       ├───AVSessionController.ets               // 视频会话
│   │       ├───GlobalContext.ets                     // Context
│   │       ├───Logger.ets                            // 日志
│   │       ├───MediaController.ets                   // 媒体通用方法
│   │       ├───PermissionUtil.ets                    // 权限管理
│   │       ├───PiPWindowController.ets               // 悬浮窗管理
│   │       ├───TimeUtils.ets                         // 时间处理
│   │       └───WindowUtil.ets                        // 窗口管理
│   ├───component
│   │   ├───CustomButton.ets                          // 按钮组件
│   │   └───SegmentButton.ets                         // 多段按钮组件
│   ├───entryability                        
│   │   ├───EntryAbility.ets                          // Ability的生命周期回调内容
│   │   ├───VoIPCallAbility.ets                       // VoIP通话Ability的生命周期回调内容
│   │   └───WindowAbility.ets                         // 窗口Ability的生命周期回调内容
│   ├───entrybackupability                  
│   │   └───EntryBackupAbility.ets                    // Ability的生命周期回调内容
│   └───pages
│       ├───audioScene
│       │   └───view                                             
│       │       └───AudioScene.ets                    // 视频播放场景   
│       ├───embeddedShortVideoScene                   // 嵌入式短视频场景
│       │   ├───model                                             
│       │   │   ├───BulletComment.ets                 // 评论
│       │   │   ├───CaptionFont.ets                   // 字幕   
│       │   │   ├───VideoInfo.ets                     // 视频数据
│       │   │   └───VideoParams.ets                   // 视频管理类   
│       │   ├───view                                             
│       │   │   ├───AVVolumePanelView.ets             // 音量视图
│       │   │   ├───BulletCommentView.ets             // 评论视图 
│       │   │   ├───CaptionFontView.ets               // 字幕视图  
│       │   │   ├───DetailPage.ets                    // 视频详情页面  
│       │   │   ├───EmbeddedShortVideoScene.ets       // 嵌入式短视频主页面  
│       │   │   ├───LanguageDialog.ets                // 语言切换弹框  
│       │   │   ├───ScaleDialog.ets                   // 缩放弹框  
│       │   │   ├───ScreenBrightnessView.ets          // 屏幕亮度视图  
│       │   │   └───SpeedDialog.ets                   // 倍数弹框 
│       │   └───viewModel               
│       │       ├───VideoDataSource.ets               // 视频懒加载数据结构                               
│       │       └───VideoItemDataList.ets             // 视频列表数据
│       ├───multiAudioStreamPlayScene                 // 多音频流场景
│       │   ├───view                                             
│       │   │   ├───AudioPlayItem.ets                 // 音频流组件 
│       │   │   └───MultiAudioStreamPlayScene.ets     // 多音频流场景入口     
│       │   └───viewModel                                              
│       │       └───AudioItem.ets                     // 音频流数据结构    
│       ├───mutePlaybackScene                         // 静音播放场景
│       │   └───view                          
│       │       ├───AudioRenderMutePlayback.ets       // 音频静音播放                     
│       │       ├───AVPlayerMutePlayback.ets          // 视频静音播放  
│       │       └───MutePlaybackScene.ets             // 静音播放             
│       ├───shortVideoScene                           // 工具
│       │   ├───model                                             
│       │   │   └───VideoData.ets                     // 短视频数据    
│       │   ├───view                                             
│       │   │   ├───LanguageDialog.ets                // 语言弹框  
│       │   │   ├───ShortVideoScene.ets               // 短视频场景主页面 
│       │   │   ├───SpeedDialog.ets                   // 倍数弹框
│       │   │   ├───VideoPlayer.ets                   // 播放页面 
│       │   │   └───VideoToolBar.ets                  // 播放工具栏      
│       │   └───viewModel               
│       │       ├───AVDataSource.ets                  // 短视频数据结构                                
│       │       └───DataModel.ets                     // 短视频数据列表    
│       ├───soundPoolScene                            
│       │   └───view                           
│       │       └───SoundPoolScene.ets                // soundpool场景     
│       ├───videoScene                                // 视频播放场景
│       │   └───view                           
│       │       └───VideoScene.ets                    // 视频播放场景主页面      
│       ├───voipScene                                 // voip通话场景
│       │   └───view        
│       │       ├───VoIPCallPage.ets                  // 通话页面                   
│       │       └───VoIPScene.ets                     // voip通话场景主页面     
│       └───Index.ets                                 // 首页
└───entry/src/main/resources                          // 资源目录          
```

## 相关权限

1. 后台任务权限：ohos.permission.KEEP_BACKGROUND_RUNNING

2. 麦克风使用权限：ohos.permission.MICROPHONE

## 模块依赖

不涉及

## 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：直板机、平板、电脑、双折叠、阔折叠、三折叠。
2. HarmonyOS系统：HarmonyOS 6.0.2 Release及以上。
3. DevEco Studio版本：DevEco Studio 6.0.2 Release及以上。
4. HarmonyOS SDK版本：HarmonyOS 6.0.2 Release SDK及以上。
