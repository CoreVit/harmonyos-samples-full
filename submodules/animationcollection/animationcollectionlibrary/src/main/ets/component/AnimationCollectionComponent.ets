import CommonConstants from '../common/CommonConstants';
import Constants from '../common/CommonConstants';
import { GlobalBuilderContext } from '../common/GlobalBuilderContext';
import { NavDestinationItem } from '../viewmodel/NavDestinationItem';
import { WindowUtil } from '../utils/WindowUtil';

@Component
export struct AnimationCollectionComponent {
  private navDestinationData: NavDestinationItem[] = Constants.navDestinationData;
  @Provide(CommonConstants.KEY_PREFIX_SYSTEM_NAVPATHSTACK) pageInfos: NavPathStack = new NavPathStack();
  @StorageProp(CommonConstants.KEY_PREFIX_BREAKPOINT) currentBreakpoint: string = 'md';

  @Builder
  PagesMap(name: string) {
    if ((GlobalBuilderContext.getContext().getObject(name)) !== undefined) {
      (GlobalBuilderContext.getContext().getObject(name) as WrappedBuilder<[string, number]>).builder(name, 0)
    }
  }

  aboutToAppear(): void {
    AppStorage.setOrCreate('listData', this.navDestinationData)
  }

  aboutToDisappear(): void {
    WindowUtil.unRegisterBreakPoint();
  }

  build() {
    Navigation(this.pageInfos) {
      Row() {
        Text($r('app.string.animation_collection'))
          .fontColor($r('sys.color.font_primary'))
          .width('100%')
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
      }
      .height(90)
      .padding({
        top: 56,
        left: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                                 $r('sys.float.padding_level12') :
                                                                                 $r('sys.float.padding_level16'),
        right: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                                  $r('sys.float.padding_level12') :
                                                                                  $r('sys.float.padding_level16')
      })
      .clip(true)
      .width('100%')
      .alignItems(VerticalAlign.Center)

      Column() {
        List() {
          ForEach(this.navDestinationData, (item: NavDestinationItem) => {
            ListItem() {
              Column() {
                Row() {
                  Text(item.detail)
                    .height(48)
                    .fontWeight(FontWeight.Medium)
                    .padding({ left: 12 })
                    .fontSize(16)
                    .fontColor($r('sys.color.font_primary'))
                  Blank()
                  Row()
                    .width(10)
                    .height(10)
                    .margin({ right: 20 })
                    .border({
                      width: {
                        top: 2,
                        right: 2
                      },
                      color: $r('sys.color.font_primary')
                    })
                    .rotate({ angle: 45 })
                }
                .width('100%')

                if ((this.currentBreakpoint === 'sm' && item.xsHasDivide) ||
                  (this.currentBreakpoint === 'md' && item.mdHasDivide)) {
                  Row()
                    .height(0.5)
                    .backgroundColor($r('sys.color.comp_divider'))
                    .width('93%')
                }

              }
              .onClick(() => {
                this.pageInfos.pushPathByName(item.name, '');
              })

            }
          }, (item: NavDestinationItem) => item.name)
        }
        .lanes(this.currentBreakpoint === 'sm' ? 1 : 2)
        .borderRadius(16)
        .backgroundColor($r('sys.color.comp_background_primary'))
      }
      .width('100%')
      .height('100%')
      .padding({
        top: this.currentBreakpoint === 'sm' ? 20 : 40,
        left: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                                 $r('sys.float.padding_level12') :
                                                                                 $r('sys.float.padding_level16'),
        right: this.currentBreakpoint === 'sm' ? $r('sys.float.padding_level8') : this.currentBreakpoint === 'md' ?
                                                                                  $r('sys.float.padding_level12') :
                                                                                  $r('sys.float.padding_level16'),
        bottom: 100
      })
    }
    .hideToolBar(true)
    .mode(NavigationMode.Stack)
    .navDestination(this.PagesMap)
    .backgroundColor($r('sys.color.background_secondary'))
  }
}
