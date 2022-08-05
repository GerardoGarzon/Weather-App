//
//  ForecastManagerDelegate.swift
//  Clima
//
//  Created by Gerardo Garzon on 03/08/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

protocol ForecastManagerDelegate {
    func didUpdateForecast(_ weatherManager: ForecastManager, forecast: ForecastModel)
    
    func didFailWithErrorForecast(error: Error)
}
