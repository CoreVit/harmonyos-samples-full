import { textRecognition } from '@kit.CoreVisionKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { LengthMetrics } from '@kit.ArkUI';
import { CommonConstants } from '../constants/CommonConstants';
import { BreakpointType } from '../utils/BreakpointSystem';
import { TextRecognitionComponent } from './TextRecognitionComponent';
import Logger from '../utils/Logger';

@Component
export struct MainComponent {
  @Provide(CommonConstants.KEY_PREFIX_SYSTEM_PATHSTACK) pathStack: NavPathStack = new NavPathStack();
  @StorageProp(CommonConstants.KEY_PREFIX_BREAKPOINT) currentBp: WidthBreakpoint = WidthBreakpoint.WIDTH_SM;
  @StorageLink(CommonConstants.KEY_PREFIX_STATUS_BAR_HEIGHT) topStatusBarHeight: number = 0;
  @StorageLink(CommonConstants.KEY_PREFIX_NAVIGATOR_BAR_HEIGHT) navBarHeight: number = 0;

  @Builder
  PageMap(name: string) {
    if (name === 'textRecognition') {
      TextRecognitionComponent()
    }
  }

  async aboutToAppear(): Promise<void> {
    try {
      const initResult = await textRecognition.init();
      Logger.info('OCRDemo', `OCR service initialization result:${initResult}`);
    } catch (error) {
      Logger.error('OCRDemo', `OCR service initialization failed. cause:${error.message}`);
    }
  }

  async aboutToDisappear(): Promise<void> {
    await textRecognition.release();
    Logger.info('OCRDemo', 'OCR service released successfully');
  }

  build() {
    Column() {
      Navigation(this.pathStack) {
        Column() {
          Button($r('app.string.btn_recognize_title'), { stateEffect: true, type: ButtonType.Capsule })
            .width(this.currentBp == WidthBreakpoint.WIDTH_SM ? CommonConstants.FULL_PERCENT :
              CommonConstants.BTN_MAX_WIDTH)
            .height(CommonConstants.BTN_HEIGHT)
            .onClick(() => {
              this.selectImage();
            })
        }
        .width(CommonConstants.FULL_PERCENT)
        .height(CommonConstants.FULL_PERCENT)
        .justifyContent(FlexAlign.End)
        .padding({
          right: this.currentBp === WidthBreakpoint.WIDTH_SM ? $r('sys.float.padding_level8') :
            $r('sys.float.padding_level0'),
          left: this.currentBp === WidthBreakpoint.WIDTH_SM ? $r('sys.float.padding_level8') :
            $r('sys.float.padding_level0'),
          bottom: CommonConstants.BOTTOM_MARGIN
        })
      }
      .title($r('app.string.title'), {
        paddingStart: LengthMetrics.resource(new BreakpointType({
          sm: $r('sys.float.padding_level8'),
          md: $r('sys.float.padding_level12'),
          lg: $r('sys.float.padding_level16'),
          xl: $r('sys.float.padding_level16')
        }).getValue(this.currentBp))
      })
      .titleMode(NavigationTitleMode.Full)
      .mode(NavigationMode.Stack)
      .navDestination(this.PageMap)
    }
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .padding({
      top: this.topStatusBarHeight,
    })
  }

  private async selectImage() {
    let uri = await this.openPhoto();
    if (uri === undefined) {
      Logger.error('OCRDemo', 'Failed to get uri.');
      return;
    }
    this.pathStack.pushPath({
      name: 'textRecognition',
      param: uri
    });
  }

  private openPhoto(): Promise<string> {
    return new Promise<string>((resolve, reject) => {
      let photoPicker: photoAccessHelper.PhotoViewPicker = new photoAccessHelper.PhotoViewPicker();
      photoPicker.select({
        MIMEType: photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE,
        maxSelectNumber: 1
      }).then((res: photoAccessHelper.PhotoSelectResult) => {
        resolve(res.photoUris[0]);
      }).catch((err: BusinessError) => {
        Logger.error('OCRDemo', `Failed to get photo image uri. code：${err.code}，message：${err.message}`);
        reject('');
      })
    })
  }
}
