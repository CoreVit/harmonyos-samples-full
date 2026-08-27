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

import { FoodListConstants } from '../constants/FoodListConstants';

export class FoodDataList {
  private foodDataNumber: number = 16;
  private foodDataList: FoodData[] = [];

  constructor() {
    for (let index = 0; index < this.foodDataNumber; index++) {
      let i = index % 5;
      if (i >= FoodListConstants.FOOD_ITEM_IMAGE.length ||
        i >= FoodListConstants.FOOD_ITEM_NAME.length ||
        i >= FoodListConstants.FOOD_ITEM_RESERVATION.length ||
        i >= FoodListConstants.FOOD_ITEM_RATING.length ||
        i >= FoodListConstants.FOOD_ITEM_PRICE_PERSON.length ||
        i >= FoodListConstants.FOOD_ITEM_LOCATION_LABEL.length ||
        i >= FoodListConstants.FOOD_ITEM_DISTANCE.length ||
        i >= FoodListConstants.FOOD_ITEM_RAKING.length ||
        i >= FoodListConstants.FOOD_ITEM_PRICE.length ||
        i >= FoodListConstants.FOOD_ITEM_ORIGINAL_PRICE.length ||
        i >= FoodListConstants.FOOD_ITEM_RECOMMENDED.length) {
        continue;
      }
      this.foodDataList.push(new FoodData(
        FoodListConstants.FOOD_ITEM_IMAGE[i], FoodListConstants.FOOD_ITEM_NAME[i],
        FoodListConstants.FOOD_ITEM_RESERVATION[i], FoodListConstants.FOOD_ITEM_RATING[i],
        FoodListConstants.FOOD_ITEM_PRICE_PERSON[i], FoodListConstants.FOOD_ITEM_LOCATION_LABEL[i],
        FoodListConstants.FOOD_ITEM_DISTANCE[i], FoodListConstants.FOOD_ITEM_RAKING[i],
        FoodListConstants.FOOD_ITEM_PRICE[i], FoodListConstants.FOOD_ITEM_ORIGINAL_PRICE[i],
        FoodListConstants.FOOD_ITEM_RECOMMENDED[i]
      ))
    }
  }

  getFoodDataList(): FoodData[] {
    return this.foodDataList;
  }
}

export class FoodData {
  private image: Resource;
  private name: string;
  private reservation: boolean;
  private rating: number;
  private pricePerPerson: number;
  private location: string;
  private distance: string;
  private rankings: string[];
  private price: number;
  private originalPrice: number;
  private recommended: string;

  constructor(image: Resource, name: string, reservation: boolean, rating: number, pricePerPerson: number,
    location: string, distance: string, rankings: string[], price: number, originalPrice: number, recommended: string) {
    this.image = image;
    this.name = name;
    this.reservation = reservation;
    this.rating = rating;
    this.pricePerPerson = pricePerPerson;
    this.location = location;
    this.distance = distance;
    this.rankings = rankings;
    this.price = price;
    this.originalPrice = originalPrice;
    this.recommended = recommended;
  }

  getImage(): Resource {
    return this.image;
  }

  getName(): string {
    return this.name;
  }

  getReservation(): boolean {
    return this.reservation;
  }

  getRating(): number {
    return this.rating;
  }

  getPricePerPerson(): number {
    return this.pricePerPerson;
  }

  getLocation(): string {
    return this.location;
  }

  getDistance(): string {
    return this.distance;
  }

  getRankings(): string[] {
    return this.rankings;
  }

  getPrice(): number {
    return this.price;
  }

  getOriginalPrice(): number {
    return this.originalPrice;
  }

  getRecommended(): string {
    return this.recommended;
  }
}