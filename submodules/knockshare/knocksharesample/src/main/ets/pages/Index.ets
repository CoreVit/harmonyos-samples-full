import { KnockShareComponent } from '@ohos_samples/knocksharelibrary';

@Entry
@Component
struct Index {
  @StorageLink('KnockShareSamplePageStack') pageStack: NavPathStack = new NavPathStack();

  build() {
    Stack() {
      KnockShareComponent()
    }
    .height('100%')
    .width('100%')
  }
}