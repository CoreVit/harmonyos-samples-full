/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { HashMap } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from '@stock/base';
import {
  EntryOhos,
  ILineDataSet,
  JArrayList,
  LineChartModel,
  LineData,
  LineDataSet,
  XAxis,
  XAxisPosition,
  YAxis,
  YAxisLabelPosition,
  ChartColorStop,
  Legend,
  Description
} from '@ohos/mpchart';
import { ChartAxisFormatter } from './ChartAxisFormatter';

const LIGHT_AXIS_LINE_COLOR = 0xFFFFFFFF;
const DARK_AXIS_LINE_COLOR = 0xFF3A3A3A;
const LIGHT_GRADIENT_FILL_COLOR = '#ECEEFB';
const DARK_GRADIENT_FILL_COLOR = '#1A1A2E';
const LIGHT_TEXT_COLOR = 0x99000000;
const DARK_TEXT_COLOR = 0xFFFFFFFF;

export class LinesChartModel {
  private  xAxis: XAxis | null = null;
  private leftAxis: YAxis | null = null;
  private rightAxis: YAxis | null = null;
  private lineData: LineData | null = null;
  private lineChartModel: LineChartModel = new LineChartModel();
  private maxValue: number = 0;
  private minValue: number = 0;

  public constructor() {
    this.lineData = this.initCurveData(45);
  }

  /**
   * Init data.
   *
   * @param count  Init data count.
   */
  private initCurveData(count: number): LineData {
    let values = this.initRandomValue(count);
    let gradientFillColor = new JArrayList<ChartColorStop>();
    gradientFillColor.add(['#ECEEFB', 1.0]);
    let dataSet = new JArrayList<ILineDataSet>();

    let set1 = new LineDataSet(values, '');
    set1.setDrawFilled(true);
    set1.setDrawValues(false);
    set1.setGradientFillColor(gradientFillColor);
    set1.setColorByColor(0x0A59F7);
    set1.setLineWidth(1)
    set1.setDrawCircles(false);
    set1.setDrawHorizontalHighlightIndicator(false)
    set1.setDrawVerticalHighlightIndicator(false)
    dataSet.add(set1);

    let other = this.initRandomValue(count);
    let set2 = new LineDataSet(other, '');
    set2.setDrawFilled(false);
    set2.setDrawValues(false);
    set2.setColorByColor(0xFE8F00);
    set2.setLineWidth(1)
    set2.setDrawCircles(false);
    dataSet.add(set2);

    return new LineData(dataSet)
  }

  /**
   * Generates random entry values for line chart data.
   * Creates a list of EntryOhos objects with random fluctuating values.
   * @param count Number of data points to generate (including the initial point).
   * @returns JArrayList<EntryOhos> List of entry objects for line chart.
   */
  initRandomValue(count: number): JArrayList<EntryOhos> {
    // Initialize values list with starting point at (0, 0)
    let values = new JArrayList<EntryOhos>();
    values.add(new EntryOhos(0, 0));
    let temp = 0;
    // Generate random fluctuating values: increase or decrease based on random calculation
    for (let i = 1; i < count; i++) {
      let val: number = Math.random() * 0.5;
      let calculated: number = Math.random() * 100;
      if (calculated > 50) {
        temp += val;
        values.add(new EntryOhos(i, temp));
      } else {
        temp -= val;
        values.add(new EntryOhos(i, temp));
      }
      // Track max and min values for axis range calculation
      if (this.maxValue < temp) {
        this.maxValue = temp;
      }
      if (this.minValue > temp) {
        this.minValue = temp;
      }
    }
    return values;
  }

  /**
   * Get LineChartModel.
   * @param isDarkMode - whether dark mode is enabled
   */
  getLineChartModel(isDarkMode?: boolean): LineChartModel {
    const axisLineColor = isDarkMode ? DARK_AXIS_LINE_COLOR : LIGHT_AXIS_LINE_COLOR;
    const gradientFillColor = isDarkMode ? DARK_GRADIENT_FILL_COLOR : LIGHT_GRADIENT_FILL_COLOR;
    const textColor = isDarkMode ? DARK_TEXT_COLOR : LIGHT_TEXT_COLOR;

    this.lineChartModel = new LineChartModel();
    this.xAxis = this.lineChartModel.getXAxis();
    if (this.xAxis) {
      this.xAxis.setLabelCount(3, true);
      this.xAxis.setPosition(XAxisPosition.BOTTOM);
      this.xAxis.setAxisMinimum(0);
      this.xAxis.setAxisMaximum(44);
      this.xAxis.setAvoidFirstLastClipping(true);
      this.xAxis.setDrawGridLines(false)
      let xMap: HashMap<number, string> = new HashMap();
      try {
        xMap.set(0, '09:30');
        xMap.set(22, '11:30 / 13:00');
        xMap.set(44, '15:00');
      } catch (error) {
        let err = error as BusinessError;
        Logger.error(`xAxis yMap set failed, error code=${err.code}, message=${err.message}`);
      }
      this.xAxis.setValueFormatter(new ChartAxisFormatter(xMap));
      this.xAxis.setAxisLineColor(axisLineColor);
      this.xAxis.setTextColor(textColor);
    }

    this.leftAxis = this.lineChartModel.getAxisLeft();
    if (this.leftAxis) {
      let maxy = Math.ceil(this.maxValue);
      let miny = Math.floor(this.minValue)
      this.leftAxis.setLabelCount(3, false);
      this.leftAxis.setPosition(YAxisLabelPosition.INSIDE_CHART);
      this.leftAxis.setSpaceTop(0);
      this.leftAxis.setAxisMaximum(maxy + 0.1);
      this.leftAxis.setAxisMinimum(miny - 0.1);
      this.leftAxis.setDrawGridLines(false);
      this.leftAxis.setDrawAxisLine(true);
      let yMap: HashMap<number, string> = new HashMap();
      try {
        yMap.set(miny, '18.01');
        yMap.set(0, '20.01');
        yMap.set(maxy, '22.01');
      } catch (error) {
        let err = error as BusinessError;
        Logger.error(`leftAxis yMap set failed, error code=${err.code}, message=${err.message}`);
      }
      this.leftAxis.setValueFormatter(new ChartAxisFormatter(yMap));
      this.leftAxis.setAxisLineColor(axisLineColor);
      this.leftAxis.setTextColor(textColor);
    }

    this.rightAxis = this.lineChartModel.getAxisRight();
    if (this.rightAxis) {
      let maxy = Math.ceil(this.maxValue);
      let miny = Math.floor(this.minValue)
      this.rightAxis.setPosition(YAxisLabelPosition.INSIDE_CHART);
      this.rightAxis.setDrawGridLines(false);
      this.rightAxis.setDrawAxisLine(false);
      this.rightAxis.setDrawLabels(false);
      this.rightAxis.setAxisMaximum(maxy + 0.1);
      this.rightAxis.setAxisMinimum(miny - 0.1);
      this.rightAxis.setAxisLineColor(axisLineColor);
    }

    let legend: Legend | null = this.lineChartModel.getLegend();
    if (legend) {
      legend.setEnabled(false);
    }
    let description: Description | null = this.lineChartModel.getDescription();
    if (description) {
      description.setEnabled(false);
    }

    this.lineChartModel.setMinOffset(2);
    this.lineChartModel.setHighlightPerLongPressEnabled(false);
    this.updateGradientFillColor(gradientFillColor);
    this.lineChartModel.setData(this.lineData);
    this.lineChartModel.setDragEnabled(true);
    this.lineChartModel.setScaleEnabled(false);
    return this.lineChartModel;
  }

  updateGradientFillColor(color: string): void {
    if (this.lineData) {
      let dataSet = this.lineData.getDataSets();
      for (let i = 0; i < dataSet.size(); i++) {
        let set = dataSet.get(i) as LineDataSet;
        if (set && set.isDrawFilledEnabled()) {
          let gradientFillColor = new JArrayList<ChartColorStop>();
          gradientFillColor.add([color, 1.0]);
          set.setGradientFillColor(gradientFillColor);
        }
      }
    }
  }
}