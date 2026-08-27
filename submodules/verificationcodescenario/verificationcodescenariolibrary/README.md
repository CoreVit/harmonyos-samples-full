## 验证码场景合集

### 介绍

本示例实现了5种验证码场景，基本涵盖了大部分应用的验证码场景。开发者可按需下载代码，实现自己应用的验证码场景。

### 下载安装

使用ohpm安装依赖

```
ohpm install @ohos_samples/verificationcodescenariolibrary
```

或者按需在模块中修改oh-package.json5

```
{
  "dependencies": {
     "@ohos_samples/verificationcodescenariolibrary": "^1.0.0"
  }
}
```

### 使用说明

```
import { VerificationCodeScenarioComponent, VerificationCodeController } from '@ohos_samples/verificationcodescenariolibrary';
```
按需在文件中使用导出模块即可，其中VerificationCodeScenarioComponent是整个sample的入口页面。
加载完成后显示首页的5个验证码实例，点击对应按钮，进入相应的验证码页面：
  1. 文本框显示光标：输入数字光标会移动到下一个文本框，同时下边框变色。
  2. 底部加横条：在输入框内输入6位数字。
  3. 背景颜色改变：输入数字后背景颜色改变。
  4. 选择验证码：按照提示文字的顺序点击图片上的文字，然后点击提交。
  5. 滑块验证码：点击滑块按钮向右滑动，直到将图片拼接完整时松手。

VerificationCodeController封装了沉浸式、设备断点判断、避让区域计算等窗口能力。示例如下：
```
// Index.ets
import { VerificationCodeScenarioComponent } from '@ohos_samples/verificationcodescenariolibrary';
Stack() {
  VerificationCodeScenarioComponent()
}

// EntryAbility.ets
import { VerificationCodeController } from '@ohos_samples/verificationcodescenariolibrary';
// onWindowStageCreate回调里的loadContent方法里初始化
VerificationCodeController.initWindowConfig(windowStage);
```