//
//  WeatherManagerDelegate.swift
//  Clima
//
//  Created by Gerardo Garzon on 02/08/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    
    func didFailWithError(error: Error)
}
