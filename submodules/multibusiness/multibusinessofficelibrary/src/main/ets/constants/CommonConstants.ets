/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { CalendarItem } from '../model/CalendarItem';
import { NotesData } from '../model/NotesData';
import { TripData } from '../model/TripData';
import { ResourceUtils } from '../utils/ResourceUtils';

/*
 * Common constants for all features.
 */
export class CommonConstants {
  /*
   * AppStorage key prefix
   */
  public static readonly KEY_PREFIX_MAIN: string = 'businessOffice';
  /*
   * AppStorage key for main window
   */
  public static readonly KEY_MAIN_BREAKPOINT: string = CommonConstants.KEY_PREFIX_MAIN + 'BreakPoint';
  public static readonly KEY_MAIN_STATUS_BAR_HEIGHT: string = CommonConstants.KEY_PREFIX_MAIN + 'StatusBarHeight';
  public static readonly KEY_MAIN_NAV_INDICATOR_HEIGHT: string = CommonConstants.KEY_PREFIX_MAIN + 'NavIndicatorHeight';
  public static readonly KEY_MAIN_PATH_STACK: string = CommonConstants.KEY_PREFIX_MAIN + 'PathStack';
  public static readonly KEY_MAIN_UI_CONTEXT: string = CommonConstants.KEY_PREFIX_MAIN + 'UIContext';
  public static readonly KEY_MAIN_WINDOW_HEIGHT: string = CommonConstants.KEY_PREFIX_MAIN + 'WindowHeight';
  public static readonly KEY_MAIN_WINDOW_WIDTH: string = CommonConstants.KEY_PREFIX_MAIN + 'WindowWidth';
  /*
   * AppStorage key for note PathStack
   */
  public static readonly KEY_NOTES_PATH_STACK: string = 'notesPathStack';
  /*
   * AppStorage key for calendar PathStack
   */
  public static readonly KEY_CALENDAR_PATH_STACK: string = 'calendarPathStack';
  /*
   * Notes icon list.
   */
  public static readonly MEMO_LIST_ICON: Array<Resource> = [
    $r('sys.symbol.doc_plaintext'),
    $r('sys.symbol.star'),
    $r('sys.symbol.lock'),
    $r('sys.symbol.trash')
  ];
  /*
   * Notes list.
   */
  public static readonly MEMO_LIST: Array<ResourceStr> = [
    $r('app.string.memo_list0'),
    $r('app.string.memo_list1'),
    $r('app.string.memo_list2'),
    $r('app.string.memo_list3')
  ]
  /*
   * Notes number list.
   */
  public static readonly MEMO_LIST_NUMBER: Array<string> = ['18', '2', '1', '10'];
  /*
   * Folder icon list.
   */
  public static readonly FOLDER_LIST_ICON: Array<Resource> = [
    $r('app.media.ic_blank'),
    $r('app.media.ic_blue'),
    $r('app.media.ic_pink'),
    $r('app.media.ic_green'),
    $r('app.media.ic_purple')
  ];
  /*
   * Folder list.
   */
  public static readonly FOLDER_LIST: Array<ResourceStr> = [
    $r('app.string.folder_list0'),
    $r('app.string.folder_list1'),
    $r('app.string.folder_list2'),
    $r('app.string.folder_list3'),
    $r('app.string.folder_list4')
  ]
  /*
   * Folder list number.
   */
  public static readonly FOLDER_LIST_NUMBER: Array<string> = ['18', '2', '5', '7', '11'];
  /*
   * The week message on calendar page.
   */
  public static readonly WEEK_MESSAGE: Array<ResourceStr> = [
    $r('app.string.week_message0'),
    $r('app.string.week_message1'),
    $r('app.string.week_message2'),
    $r('app.string.week_message3'),
    $r('app.string.week_message4'),
    $r('app.string.week_message5'),
    $r('app.string.week_message6')
  ]
  /*
   * Grid column template.
   */
  public static readonly GRID_COLUMN_TEMPLATE: string = '1fr 1fr 1fr 1fr 1fr 1fr 1fr';
  /*
   * Grid row template.
   */
  public static readonly GRID_ROW_TEMPLATE: string = '1fr 1fr 1fr 1fr 1fr';
  /*
   * The calendar message.
   */
  public static readonly CALENDAR_TIME_MESSAGE: Array<CalendarItem | string> = [
    new CalendarItem('1',
      ResourceUtils.getStringArrayValueSync($r('app.strarray.september').id)[0], false),
    new CalendarItem('2',
      ResourceUtils.getStringArrayValueSync($r('app.strarray.september').id)[1], false),
    new CalendarItem('3',
      ResourceUtils.getStringArrayValueSync($r('app.strarray.september').id)[2], false),
    new CalendarItem('4',
      ResourceUtils.getStringArrayValueSync($r('app.strarray.september').id)[3], false),
    new CalendarItem('5',
      ResourceUtils.getStringArrayValueSync($r('app.strarray.september').id)[4], false),
    new CalendarItem('6',
      ResourceUtils.getStringArrayValueSync($r('app.strarray.september').id)[5], false),
    new CalendarItem('7',
      ResourceUtils.getStringArrayValueSync($r('app.strarray.september').id)[6], false),
    new CalendarItem('8',
      ResourceUtils.getStringArrayValueSync($r('app.strarray.september').id)[7], false),
    new CalendarItem('9',
      ResourceUtils.getStringArrayValueSync($r('app.strarray.september').id)[8], false),
    new CalendarItem('10',
      ResourceUtils.getStringArrayValueSync($r('app.strarray.september').id)[9], false),
    new CalendarItem('11',
      ResourceUtils.getStringArrayValueSync($r('app.strarray.september').id)[10], false),
    new CalendarItem('12',
      ResourceUtils.getStringArrayValueSync($r('app.strarray.september').id)[11], false, true),
    new CalendarItem('13',
      ResourceUtils.getStringArrayValueSync($r('app.strarray.september').id)[12], false),
    new CalendarItem('14',
      ResourceUtils.getStringArrayValueSync($r('app.strarray.september').id)[13], false),
    new CalendarItem('15',
      ResourceUtils.getStringArrayValueSync($r('app.strarray.september').id)[14], false),
    new CalendarItem('16',
      ResourceUtils.getStringArrayValueSync($r('app.strarray.september').id)[15], false, true),
    new CalendarItem('17',
      ResourceUtils.getStringArrayValueSync($r('app.strarray.september').id)[16], false),
    new CalendarItem('18',
      ResourceUtils.getStringArrayValueSync($r('app.strarray.september').id)[17], false),
    new CalendarItem('19',
      ResourceUtils.getStringArrayValueSync($r('app.strarray.september').id)[18], false),
    new CalendarItem('20',
      ResourceUtils.getStringArrayValueSync($r('app.strarray.september').id)[19], false),
    new CalendarItem('21',
      ResourceUtils.getStringArrayValueSync($r('app.strarray.september').id)[20], false),
    new CalendarItem('22',
      ResourceUtils.getStringArrayValueSync($r('app.strarray.september').id)[21], false, false),
    new CalendarItem('23',
      ResourceUtils.getStringArrayValueSync($r('app.strarray.september').id)[22], false),
    new CalendarItem('24',
      ResourceUtils.getStringArrayValueSync($r('app.strarray.september').id)[23], false),
    new CalendarItem('25',
      ResourceUtils.getStringArrayValueSync($r('app.strarray.september').id)[24], false, true),
    new CalendarItem('26',
      ResourceUtils.getStringArrayValueSync($r('app.strarray.september').id)[25], false),
    new CalendarItem('27',
      ResourceUtils.getStringArrayValueSync($r('app.strarray.september').id)[26], false),
    new CalendarItem('28',
      ResourceUtils.getStringArrayValueSync($r('app.strarray.september').id)[27], false),
    new CalendarItem('29',
      ResourceUtils.getStringArrayValueSync($r('app.strarray.september').id)[28], false),
    new CalendarItem('30',
      ResourceUtils.getStringArrayValueSync($r('app.strarray.september').id)[29], false),
    new CalendarItem('1',
      ResourceUtils.getStringArrayValueSync($r('app.strarray.september').id)[30], true),
    new CalendarItem('2',
      ResourceUtils.getStringArrayValueSync($r('app.strarray.september').id)[31], true),
    new CalendarItem('3',
      ResourceUtils.getStringArrayValueSync($r('app.strarray.september').id)[32], true),
    new CalendarItem('4',
      ResourceUtils.getStringArrayValueSync($r('app.strarray.september').id)[33], true),
    new CalendarItem('5',
      ResourceUtils.getStringArrayValueSync($r('app.strarray.september').id)[34], true)
  ];
  /*
   * The trip schedule.
   */
  public static readonly TRIP_SCHEDULE: Array<TripData> = [
    new TripData('08:00', '09:00', ResourceUtils.getStringSync($r('app.string.trip_schedule1').id),
      true),
    new TripData('08:00', '09:20', ResourceUtils.getStringSync($r('app.string.trip_schedule2').id),
      true, 'F1A3-F78G'),
    new TripData('11:00', '11:20', ResourceUtils.getStringSync($r('app.string.trip_schedule3').id),
      false, 'A3F4-2501'),
    new TripData('11:30', '12:00', ResourceUtils.getStringSync($r('app.string.trip_schedule4').id),
      false, 'A3F4-2501'),
    new TripData('14:00', '15:20', ResourceUtils.getStringSync($r('app.string.trip_schedule5').id),
      false, 'A5F4-2506')
  ];
  /*
   * The notes schedule.
   */
  public static readonly NOTES_SCHEDULE: Array<Array<NotesData>> = [
    [
      new NotesData('#E6BA0B', ResourceUtils.getStringSync($r('app.string.notes_schedule1').id),
        $r('app.string.notes_schedule2'), $r('app.string.notes_schedule3'), $r('app.media.notes_list1'),
        $r('sys.symbol.star')),
      new NotesData('#E64566', ResourceUtils.getStringSync($r('app.string.notes_schedule4').id),
        $r('app.string.notes_schedule2'), $r('app.string.notes_schedule5'), undefined, $r('sys.symbol.lock')),
      new NotesData('#64BB5C', ResourceUtils.getStringSync($r('app.string.notes_schedule6').id),
        $r('app.string.notes_schedule2'), $r('app.string.notes_schedule6'),
        $r('app.media.notes_list2'))
    ],
    [
      new NotesData('#AC49F5', ResourceUtils.getStringSync($r('app.string.notes_schedule7').id),
        $r('app.string.notes_schedule8'), $r('app.string.notes_schedule9'), undefined, $r('app.media.open_sidebar')),
      new NotesData('#46B1E3', 'Yesterday Once More', $r('app.string.notes_schedule10'), "When i was young I'd ...")
    ]
  ];
  /*
   * The full percentage of component.
   */
  public static readonly FULL_PERCENT: string = '100%';
  /*
   * Control button.
   */
  public static readonly CONTROL_BUTTON: number = 40;
  /*
 * Padding size 8.
 */
  public static readonly PADDING_8: number = 8;
  /*
  * Padding size 24.
  */
  public static readonly PADDING_24: number = 24;
  /*
  * Padding size 48.
  */
  public static readonly PADDING_54: number = 54;
  /*
  * Window Decor Size.
  */
  public static readonly WINDOW_DECOR_HEIGHT: number = 64;
  /*
* Window Decor Size.
*/
  public static readonly WINDOW_MIN_WIDTH: number = 350;
  /*
   * Calendar sideBar width.
   */
  public static readonly SIDEBAR_WIDTH: number = 240;
  public static readonly NOTES_NAV_BAR_WIDTH = 368;
  /*
   * Notes sideBar width.
   */
  public static readonly NOTES_SIDEBAR_WIDTH: number = 304;
  /*
   * Calendar content width.
   */
  public static readonly CALENDAR_CONTENT_WIDTH: number = 346;
  /*
   * Control button left.
   */
  public static readonly CONTROL_BUTTON_LEFT: number = 256;
  /*
   * Control button top.
   */
  public static readonly CONTROL_BUTTON_TOP: number = 44;
  /*
   * Control notes button top.
   */
  public static readonly CONTROL_NOTES_BUTTON_TOP: number = 12;
  /*
   * Common margin.
   */
  public static readonly COMMON_MARGIN: number = 16;
  /*
   * Common zero.
   */
  public static readonly COMMON_ZERO: number = 0;
  /*
   * Common one.
   */
  public static readonly COMMON_ONE: number = 1;
  /*
   * Common five.
   */
  public static readonly COMMON_FIVE: number = 5;
  /*
   * Common six.
   */
  public static readonly COMMON_SIX: number = 6;
  /*
   * Common seven.
   */
  public static readonly COMMON_SEVEN: number = 7;
  /*
   * Trip schedule view.
   */
  public static readonly TRIP_SCHEDULE_VIEW: Array<string> =
    ResourceUtils.getStringArrayValueSync($r('app.strarray.trip_schedule_view').id);
  /*
   * Notes list.
   */
  public static readonly NOTES_LIST: Array<string> =
    ResourceUtils.getStringArrayValueSync($r('app.strarray.notes_list').id);
  /*
   * Notes sidebar text list.
   */
  public static readonly NOTES_SIDE_BAR_TEXT: Array<ResourceStr> = [
    $r('app.string.notes_side_bar_text0'),
    $r('app.string.notes_side_bar_text1'),
    $r('app.string.notes_side_bar_text2'),
    $r('app.string.notes_side_bar_text3'),
    $r('app.string.notes_side_bar_text4'),
  ]
  /*
   * Common font weight 500.
   */
  public static readonly FONT_WEIGHT_500: number = 500;
  /*
   * Common font weight 400.
   */
  public static readonly FONT_WEIGHT_400: number = 400;
  /*
   * Trip list.
   */
  public static readonly TRIP_LIST: Array<number> = [1, 2];
  /*
   * Notes content title height.
   */
  public static readonly NOTES_TITLE_HEIGHT: number = 230;
  /*
   * Notes content title height on 2in1.
   */
  public static readonly NOTES_TITLE_2IN1: number = 120;
}

