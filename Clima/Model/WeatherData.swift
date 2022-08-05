//
//  WeatherData.swift
//  Clima
//
//  Created by Gerardo Garzon on 01/08/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct ForecastData: Codable {
    let list: [ForecastSingleData]
}

struct ForecastSingleData: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
}

struct Main: Codable{
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
}

struct Weather: Codable {
    let id: Int
}
