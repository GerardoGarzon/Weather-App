//
//  WeatherModel.swift
//  Clima
//
//  Created by Gerardo Garzon on 02/08/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    let dateTime: Int
    
    init(conditionId: Int, cityName: String, temperature: Double, dateTime: Int = 1) {
        self.conditionId = conditionId
        self.cityName = cityName
        self.temperature = temperature
        self.dateTime = dateTime
    }
    
    var temperatureString: String {
        return String(format: "%.0f", temperature)
    }
    
    var conditionName: String {
        switch self.conditionId {
        case 200...299:
            return "cloud.bolt"
        case 300...399:
            return "cloud.drizzle"
        case 500...599:
            return "cloud.rain"
        case 600...699:
            return "cloud.snow"
        case 700...799:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "smoke"
        default:
            return "cloud"
        }
    }
}
