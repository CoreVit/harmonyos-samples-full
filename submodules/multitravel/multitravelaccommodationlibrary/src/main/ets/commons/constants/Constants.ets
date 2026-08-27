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

import { CalendarItem } from '../../model/CalendarItem';
import { HotelRoomItem } from '../../model/HotelRoomItem';
import { SearchTicketBarItem } from '../../model/SearchTicketBarItem';
import { SearchTicketDateItem } from '../../model/SearchTicketDateItem';
import { TicketItem } from '../../model/TicketItem';

export class Constants {
  /*
   * The number of columns for SM device.
   */
  public static readonly COLUMN_SM: number = 4;
  /*
   * The number of columns for MD device.
   */
  public static readonly COLUMN_MD: number = 8;
  /*
   * The number of columns for LG device.
   */
  public static readonly COLUMN_LG: number = 12;
  /*
   * The number of min margin top.
   */
  public static readonly MIN_MARIN_TOP: number = 225;
  /*
   * The full percentage of component.
   */
  public static readonly FULL_WIDTH_PERCENT: string = '100%';
  /*
   * Index page padding top size.
   */
  public static readonly PADDING_TOP_INDEX: number = 64;
  /*
   * Calendar width 40.
   */
  public static readonly CALENDAR_WIDTH: number = 40;
  /*
   * Index page padding bottom size.
   */
  public static readonly PADDING_BOTTOM_INDEX: number = 16;
  /*
   * The ninety five percent of the components.
   */
  public static readonly NINETY_FIVE_PERCENT: string = '95%';
  /*
   * The ninety-one percent of the components.
   */
  public static readonly NINETY_ONE_PERCENT: string = '91%';
  /*
   * The ninety percent of the components.
   */
  public static readonly NINETY_PERCENT: string = '90%';
  /*
   * The one hundred fifty percent.
   */
  public static readonly ONE_HUNDRED_FIFTY_PERCENT: string = '150%';
  /*
   * The sixty percent.
   */
  public static readonly SIXTY_PERCENT: string = '60%';
  /*
   * The card two width
   */
  public static readonly CARD_TWO_WIDTH: string = '59.1%';
  /*
   * The fifty-five percent.
   */
  public static readonly FIFTY_FIVE_PERCENT: string = '55%';
  /*
   * The fifty percent.
   */
  public static readonly FIFTY_PERCENT: string = '50%';
  /*
   * The forty percent.
   */
  public static readonly FORTY_PERCENT: string = '40%';
  /*
   * The sixty percent.
   */
  public static readonly CARD_ONE_WIDTH: string = '38.4%';
  /*
   * The thirty percent.
   */
  public static readonly THIRTY_PERCENT: string = '30%';
  /*
   * The twenty-five percent.
   */
  public static readonly TWENTY_FIVE_PERCENT: string = '25%';
  /*
   * The twenty-two percent.
   */
  public static readonly TWENTY_TWO_PERCENT: string = '22.2%';
  /*
   * The five percent.
   */
  public static readonly FIVE_PERCENT: string = '5%';
  /*
   * The four percent.
   */
  public static readonly STAR_WIDTH: string = '4.4%';
  /*
   * Common font weight.
   */
  public static readonly FONT_WEIGHT_700: number = 700;
  /*
   * Common font weight.
   */
  public static readonly FONT_WEIGHT_500: number = 500;
  /*
   * Common font weight.
   */
  public static readonly FONT_WEIGHT_400: number = 400;
  /*
   * Common font weight.
   */
  public static readonly FONT_WEIGHT_200: number = 200;
  /*
   * Start time.
   */
  public static readonly START_TIME: number = -1;
  /*
   * Max time.
   */
  public static readonly MAX_TIME: number = 100;
  /*
   * Opacity 0.15
   */
  public static readonly OPACITY_FIFTEEN_PERCENT: number = 0.15;
  /*
   * Opacity 0.9
   */
  public static readonly OPACITY_NINETY_PERCENT: number = 0.9;
  /*
   * Opacity 0.8
   */
  public static readonly OPACITY_EIGHTY_PERCENT: number = 0.8;
  /*
   * Opacity 0.6
   */
  public static readonly OPACITY_SIXTY_PERCENT: number = 0.6;
  /*
   * Opacity 0.5
   */
  public static readonly OPACITY_FIFTY_PERCENT: number = 0.5;
  /*
   * Opacity 0.4
   */
  public static readonly OPACITY_FORTY_PERCENT: number = 0.4;
  /*
   * Opacity 1
   */
  public static readonly OPACITY_FULL_PERCENT: number = 1;
  /*
   * Number 1
   */
  public static readonly NUMBER_ONE: number = 1;
  /*
   * Number 2
   */
  public static readonly NUMBER_TWO: number = 2;
  /*
   * Number 3
   */
  public static readonly NUMBER_THREE: number = 3;
  /*
   * Number 4
   */
  public static readonly NUMBER_FOUR: number = 4;
  /*
   * Number 5
   */
  public static readonly NUMBER_FIVE: number = 5;
  /*
   * Number 6
   */
  public static readonly NUMBER_SIX: number = 6;
  /*
   * Number 7
   */
  public static readonly NUMBER_SEVEN: number = 7;
  /*
   * Number 11
   */
  public static readonly NUMBER_ELEVEN: number = 11;
  /*
   * Number 28
   */
  public static readonly NUMBER_TWENTY_EIGHT: number = 28;
  /*
   * Number 31
   */
  public static readonly NUMBER_THIRTY_ONE: number = 31;
  /*
   * Number 60
   */
  public static readonly NUMBER_SIXTY: number = 60;
  /*
   * Number 15
   */
  public static readonly NUMBER_FIFTEEN: number = 15;
  /*
   * Number 0.
   */
  public static readonly NUMBER_ZERO: number = 0;
  /*
   * Number 100.
   */
  public static readonly NUMBER_ONE_HUNDRED: number = 100;
  /*
   * Number 1000
   */
  public static readonly NUMBER_THOUSAND: number = 1000;
  /*
   * Empty string
   */
  public static readonly EMPTY_STRING: string = '';
  /*
   * Grid column template.
   */
  public static readonly GRID_COLUMN_TEMPLATE: string = '1fr 1fr 1fr 1fr 1fr 1fr 1fr';
  /*
   * Auto height.
   */
  public static readonly AUTO_HEIGHT: string = 'auto';
  /*
   * The url of hotel detail page.
   */
  public static readonly HOTEL_DETAIL_PAGE_URL: string = 'HotelDetailsPage';
  /*
   * The url of search ticket page.
   */
  public static readonly SEARCH_TICKET_PAGE_URL: string = 'SearchTicketPage';
  /*
   * The url of lower price Calendar page.
   */
  public static readonly LOW_PRICE_CALENDAR_URL: string = 'LowPriceCalendarPage';
  /*
   * Hotel Name.
   */
  public static readonly HOTEL_NAME: Resource = $r('app.string.hotel_name');
  /*
   * Hotel message six
   */
  public static readonly HOTEL_MESSAGE_SIX: Resource = $r('app.string.hotel_message_six');
  /*
   * Hotel message nine
   */
  public static readonly HOTEL_MESSAGE_NINE: Resource = $r('app.string.hotel_message_nine');
  /*
   * Room message three.
   */
  public static readonly ROOM_MESSAGE_THREE: Resource = $r('app.string.room_message_three');
  /*
   * Money flag.
   */
  public static readonly MONEY: string = '￥';
  /*
   * Start flag.
   */
  public static readonly START: Resource = $r('app.string.at_least');
  /*
   * Journey information.
   */
  public static readonly JOURNEY: Resource = $r('app.string.journey');
  /*
   * AppStorage key
   */
  public static readonly KEY_PREFIX: string = 'travelAcc';
  public static readonly KEY_BREAKPOINT: string = Constants.KEY_PREFIX + 'BreakPoint';
  public static readonly KEY_STATUS_BAR_HEIGHT: string = Constants.KEY_PREFIX + 'StatusBarHeight';
  public static readonly KEY_NAV_INDICATOR_HEIGHT: string = Constants.KEY_PREFIX + 'NavIndicatorHeight';
  public static readonly KEY_PATH_STACK: string = Constants.KEY_PREFIX + 'PathStack';
  public static readonly KEY_UI_CONTEXT: string = Constants.KEY_PREFIX + 'UIContext';
  /*
   * Room button message.
   */
  public static readonly ROOM_BUTTON_MESSAGES: Resource[] = [
    $r('app.string.room_button_message_one'),
    $r('app.string.room_button_message_two'),
    $r('app.string.room_button_message_three'),
    $r('app.string.room_button_message_four'),
    $r('app.string.room_button_message_five'),
    $r('app.string.room_button_message_six'),
    $r('app.string.room_button_message_seven'),
    $r('app.string.room_button_message_eight'),
    $r('app.string.room_button_message_nine'),
    $r('app.string.room_button_message_ten'),
    $r('app.string.room_button_message_eleven'),
  ];
  /*
   * Hotel Room Informations.
   */
  public static readonly HOTEL_ROOMS_MESSAGES: Array<HotelRoomItem> = [
    new HotelRoomItem($r('app.media.roomOne'), $r('app.string.room_type_one'), 1,
      $r('app.string.room_information_one'), 2, $r('app.string.room_services'), '¥2038', '¥1884', true),
    new HotelRoomItem($r('app.media.roomTwo'), $r('app.string.room_type_two'), 2,
      $r('app.string.room_information_two'), 2, $r('app.string.room_services'), '¥2680', '¥2400', true),
    new HotelRoomItem($r('app.media.roomThree'), $r('app.string.room_type_three'), 3,
      $r('app.string.room_information_three'), 2, $r('app.string.room_services'), '¥2680', '¥2400', false),
    new HotelRoomItem($r('app.media.roomFour'), $r('app.string.room_type_four'), 4,
      $r('app.string.room_information_four'), 2, $r('app.string.room_services'), '¥4890', '¥4800', false),
    new HotelRoomItem($r('app.media.roomFive'), $r('app.string.room_type_five'), 5,
      $r('app.string.room_information_five'), 2, $r('app.string.room_services'), '¥5597', '¥5547', false)
  ];
  /*
   * Hotel Picture Informations.
   */
  public static readonly HOTEL_PICTURE_MESSAGE: Array<Resource> = [
    $r('app.media.hotelPadone'), $r('app.media.hotelPadtwo'),
    $r('app.media.hotelPadthree'), $r('app.media.hotelPadfour'),
    $r('app.media.hotelPadfive')
  ];
  /*
   * Navigation bar information on the ticket search page.
   */
  public static readonly SEARCH_BAR_MESSAGE: Array<SearchTicketBarItem> = [
    new SearchTicketBarItem($r('sys.symbol.funnel'), $r('app.string.filter'), $r('app.media.sift_select')),
    new SearchTicketBarItem($r('sys.symbol.stopwatch'), $r('app.string.shortest_time'),
      $r('app.media.stopwatch_select')),
    new SearchTicketBarItem($r('sys.symbol.time_inerval'), $r('app.string.earliest_departure'),
      $r('app.media.history_select')),
    new SearchTicketBarItem($r('sys.symbol.yuansign_arrow_2_squarepath'), $r('app.string.the_cheapest'),
      $r('app.media.cheap_select')),
    new SearchTicketBarItem($r('sys.symbol.cart'), $r('app.string.reservation_order'), $r('app.media.shop_select'))
  ];
  /*
   * The date message on search ticket page.
   */
  public static readonly SEARCH_DATE_MESSAGE: Array<SearchTicketDateItem> = [
    new SearchTicketDateItem($r('app.string.Today'), '01.22'),
    new SearchTicketDateItem($r('app.string.Friday'), '01.23'),
    new SearchTicketDateItem($r('app.string.Saturday'), '01.24'),
    new SearchTicketDateItem($r('app.string.Sunday'), '01.25'),
    new SearchTicketDateItem($r('app.string.Monday'), '01.26'),
    new SearchTicketDateItem($r('app.string.Tuesday'), '01.27'),
    new SearchTicketDateItem($r('app.string.Wednesday'), '01.28')
  ];
  /*
   * The Button message on search ticket page.
   */
  public static readonly SEARCH_ADDRESS_BUTTON_MESSAGE: Array<Resource> =
    [$r('app.string.Beijing_South'), $r('app.string.Beijing'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.Shanghai')];
  /*
   * The ticket informations.
   */
  public static readonly TICKET_MESSAGE: Array<TicketItem> = [
    new TicketItem('01.22', '23:48', '21:18', $r('app.string.Beijing_South'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '4h18m', 662, 0, 0, 0),
    new TicketItem('01.22', '12:03', '21:18', $r('app.string.Beijing_South'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.Railway'), 'T113', '4h20m', 548, 2, 2, 0),
    new TicketItem('01.22', '01:02', '21:18', $r('app.string.Beijing_South'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.high_speed'), 'G113', '3h14m', 648, 2, 2, 0),
    new TicketItem('01.22', '01:01', '21:18', $r('app.string.Beijing_South'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '3h46m', 328, 2, 2, 0),
    new TicketItem('01.22', '09:00', '21:18', $r('app.string.Beijing'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '2h12m', 168, 2, 2, 0),
    new TicketItem('01.22', '16:00', '21:18', $r('app.string.Beijing_South'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '5h38m', 618, 0, 0, 0),
    new TicketItem('01.22', '14:03', '21:18', $r('app.string.Beijing_South'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.Railway'), 'T113', '4h17m', 514, 2, 2, 0),
    new TicketItem('01.22', '13:02', '21:18', $r('app.string.Beijing_South'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.high_speed'), 'G113', '4h16m', 647, 2, 2, 0),
    new TicketItem('01.22', '07:01', '21:18', $r('app.string.Beijing_South'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '3h20m', 344, 2, 2, 0),
    new TicketItem('01.22', '06:00', '21:18', $r('app.string.Beijing'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '3h37m', 369, 2, 2, 0),
    new TicketItem('01.22', '13:00', '21:18', $r('app.string.Beijing'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '2h18m', 114, 2, 2, 0),
    new TicketItem('01.23', '17:00', '21:18', $r('app.string.Beijing'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '4h18m', 662, 2, 2, 0),
    new TicketItem('01.23', '17:00', '21:18', $r('app.string.Beijing'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '4h18m', 662, 2, 2, 0),
    new TicketItem('01.23', '17:00', '21:18', $r('app.string.Beijing'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '4h18m', 662, 2, 2, 0),
    new TicketItem('01.23', '17:00', '21:18', $r('app.string.Beijing_South'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '4h18m', 662, 2, 2, 0),
    new TicketItem('01.23', '17:00', '21:18', $r('app.string.Beijing'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '4h18m', 662, 2, 2, 0),
    new TicketItem('01.23', '17:00', '21:18', $r('app.string.Beijing'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '4h18m', 662, 2, 2, 0),
    new TicketItem('01.24', '17:00', '21:18', $r('app.string.Beijing'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '4h18m', 662, 2, 2, 0),
    new TicketItem('01.24', '17:00', '21:18', $r('app.string.Beijing_South'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '4h18m', 662, 2, 2, 0),
    new TicketItem('01.24', '17:00', '21:18', $r('app.string.Beijing'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '4h18m', 662, 2, 2, 0),
    new TicketItem('01.24', '17:00', '21:18', $r('app.string.Beijing'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '4h18m', 662, 2, 2, 0),
    new TicketItem('01.24', '17:00', '21:18', $r('app.string.Beijing_South'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '4h18m', 662, 2, 2, 0),
    new TicketItem('01.24', '17:00', '21:18', $r('app.string.Beijing_South'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '4h18m', 662, 2, 2, 0),
    new TicketItem('01.25', '17:00', '21:18', $r('app.string.Beijing_South'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '4h18m', 662, 0, 0, 0),
    new TicketItem('01.25', '17:00', '21:18', $r('app.string.Beijing_South'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '4h18m', 662, 0, 0, 0),
    new TicketItem('01.25', '17:00', '21:18', $r('app.string.Beijing_South'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '4h18m', 662, 0, 0, 0),
    new TicketItem('01.25', '17:00', '21:18', $r('app.string.Beijing_South'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '4h18m', 662, 0, 0, 0),
    new TicketItem('01.25', '17:00', '21:18', $r('app.string.Beijing_South'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '4h18m', 662, 0, 0, 0),
    new TicketItem('01.26', '17:00', '21:18', $r('app.string.Beijing_South'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '4h18m', 662, 2, 2, 0),
    new TicketItem('01.26', '17:00', '21:18', $r('app.string.Beijing_South'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '4h18m', 662, 2, 2, 0),
    new TicketItem('01.26', '17:00', '21:18', $r('app.string.Beijing_South'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '4h18m', 662, 2, 2, 0),
    new TicketItem('01.26', '17:00', '21:18', $r('app.string.Beijing_South'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '4h18m', 662, 2, 2, 0),
    new TicketItem('01.26', '17:00', '21:18', $r('app.string.Beijing_South'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '4h18m', 662, 2, 2, 0),
    new TicketItem('01.27', '17:00', '21:18', $r('app.string.Beijing_South'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '4h18m', 662, 2, 2, 0),
    new TicketItem('01.27', '17:00', '21:18', $r('app.string.Beijing_South'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '4h18m', 662, 2, 2, 0),
    new TicketItem('01.27', '17:00', '21:18', $r('app.string.Beijing_South'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '4h18m', 662, 2, 2, 0),
    new TicketItem('01.27', '17:00', '21:18', $r('app.string.Beijing_South'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '4h18m', 662, 2, 2, 0),
    new TicketItem('01.27', '17:00', '21:18', $r('app.string.Beijing_South'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '4h18m', 662, 2, 2, 0),
    new TicketItem('01.27', '17:00', '21:18', $r('app.string.Beijing_South'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '4h18m', 662, 2, 2, 0),
    new TicketItem('01.27', '17:00', '21:18', $r('app.string.Beijing_South'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '4h18m', 662, 2, 2, 0),
    new TicketItem('01.27', '17:00', '21:18', $r('app.string.Beijing_South'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '4h18m', 662, 2, 2, 0),
    new TicketItem('01.28', '17:00', '21:18', $r('app.string.Beijing_South'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '4h18m', 662, 2, 2, 0),
    new TicketItem('01.28', '17:00', '21:18', $r('app.string.Beijing_South'), $r('app.string.Shanghai_Hongqiao'),
      $r('app.string.train'), 'K113', '4h18m', 662, 2, 2, 0),
  ];
  /*
   * The bar message on search ticket page.
   */
  public static readonly SEARCH_TICKET_BAR: Array<Resource> = [
    $r('app.string.direct'), $r('app.string.Transfer')
  ];
  /*
   * The calendar message.
   */
  public static readonly CALENDAR_TIME_MESSAGE: Array<Array<CalendarItem>> = [
    [
      new CalendarItem('', '', false, true), new CalendarItem('1', '', false, true),
      new CalendarItem('2', '', false, true), new CalendarItem('3', '', false, true),
      new CalendarItem('4', '', false, true), new CalendarItem('5', '', false, true),
      new CalendarItem('6', '', false, true), new CalendarItem('7', '', false, true),
      new CalendarItem('8', '', false, true), new CalendarItem('9', '', false, true),
      new CalendarItem('10', '', false, true), new CalendarItem('11', '', false, true),
      new CalendarItem('12', '', false, true), new CalendarItem('13', '', false, true),
      new CalendarItem('14', '', false, true), new CalendarItem('15', '', false, true),
      new CalendarItem('16', '', false, true), new CalendarItem('17', '', false, true),
      new CalendarItem('18', '', false, true), new CalendarItem('19', '', false, true),
      new CalendarItem('20', '', false, true), new CalendarItem('21', '', false, true),
      new CalendarItem('22', '￥2063', false, false, true), new CalendarItem('23', '￥2063', false),
      new CalendarItem('24', '￥2063', false), new CalendarItem('25', '￥2063', false),
      new CalendarItem('26', '￥2063', false), new CalendarItem('27', '￥2063', false),
      new CalendarItem('28', '￥2063', false), new CalendarItem('29', '￥1965', true),
      new CalendarItem('30', '￥1965', true), new CalendarItem('31', '￥1965', true),
      new CalendarItem('', '', false), new CalendarItem('', '', false), new CalendarItem('', '', false),
    ],
    [
      new CalendarItem('', '', false), new CalendarItem('', '', false), new CalendarItem('', '', false),
      new CalendarItem('', '', false), new CalendarItem('1', '￥2063', false), new CalendarItem('2', '￥2063', false),
      new CalendarItem('3', '￥2063', false), new CalendarItem('4', '￥2063', false),
      new CalendarItem('5', '￥2063', false), new CalendarItem('6', '￥2063', false),
      new CalendarItem('7', '￥2063', false), new CalendarItem('8', '￥2063', false),
      new CalendarItem('9', '￥2063', false), new CalendarItem('10', '￥2063', false),
      new CalendarItem('11', '￥2063', false), new CalendarItem('12', '￥2063', false),
      new CalendarItem('13', '￥2063', false), new CalendarItem('14', '￥2063', false),
      new CalendarItem('15', '￥2063', false), new CalendarItem('16', '￥2063', false),
      new CalendarItem('17', '￥2063', false), new CalendarItem('18', '￥2063', false),
      new CalendarItem('19', '￥2063', false), new CalendarItem('20', '￥2063', false),
      new CalendarItem('21', '￥2063', false), new CalendarItem('22', '￥2063', false),
      new CalendarItem('23', '￥2063', false), new CalendarItem('24', '￥2063', false),
      new CalendarItem('25', '￥2063', false), new CalendarItem('26', '￥2063', false),
      new CalendarItem('27', '￥2063', false), new CalendarItem('28', '￥2063', false),
      new CalendarItem('29', '￥2063', false), new CalendarItem('', '', false), new CalendarItem('', '', false),
    ]
  ];
  /*
   * The week message on calendar page.
   */
  public static readonly WEEK_MESSAGE: Array<Resource> =
    [$r('app.string.Calendar_Sunday'), $r('app.string.Calendar_Monday'), $r('app.string.Calendar_Tuesday'),
      $r('app.string.Calendar_Wednesday'), $r('app.string.Calendar_Thursday'), $r('app.string.Calendar_Friday'),
      $r('app.string.Calendar_Saturday')
    ];
  /*
   * The sift condition.
   */
  public static readonly FILTERING_CRITERIA: Array<Resource> =
    [$r('app.string.only_railway'), $r('app.string.only_train'), $r('app.string.view_available')];
}