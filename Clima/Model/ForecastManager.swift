//
//  ForecastManager.swift
//  Clima
//
//  Created by Gerardo Garzon on 03/08/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct ForecastManager {
    private let weatherURL: String = "https://api.openweathermap.org"
    private let apiKey: String = "84413fd54725744961f5d3b8a4f96740"
    private let apiVersion: String = "2.5"
    
    var delegate: ForecastManagerDelegate?
    
    func fetchForecast(cityName: String) {
        let queryString = "appid=\(apiKey)&units=metric&q=\(cityName)&cnt=6"
        let urlString = "\(weatherURL)/data/\(apiVersion)/forecast?\(queryString)"
        
        performRequest(with: urlString)
    }
    
    func fetchForecast(lat: String, lon: String) {
        let queryString = "appid=\(apiKey)&units=metric&lat=\(lat)&lon=\(lon)&cnt=6"
        let urlString = "\(weatherURL)/data/\(apiVersion)/forecast?\(queryString)"
        
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        // Create a URL
        if let url = URL(string: urlString) {
            // Create a URL Session
            let session = URLSession(configuration: .default)
            
            // Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithErrorForecast(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let forecast = self.parseJSON(safeData) {
                        self.delegate?.didUpdateForecast(self, forecast: forecast)
                    }
                }
            }
            
            // Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ forecastData: Data) -> ForecastModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(ForecastData.self, from: forecastData)
            var arrayModels: [WeatherModel] = []
            
            for weather in decodedData.list {
                let id = weather.weather[0].id
                let temp = weather.main.temp
                let name = ""
                let date = weather.dt
                
                let weatherModel = WeatherModel(conditionId: id, cityName: name, temperature: temp, dateTime: date)
                
                arrayModels.append(weatherModel)
            }
            
            let forecast = ForecastModel(arrayWeatherModel: arrayModels)
            
            return forecast
        } catch {
            self.delegate?.didFailWithErrorForecast(error: error)
            return nil
        }
    }
}
