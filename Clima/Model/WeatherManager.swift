//
//  WeatherManager.swift
//  Clima
//
//  Created by Gerardo Garzon on 01/08/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    
    private let weatherURL: String = "https://api.openweathermap.org"
    private let apiKey: String = "84413fd54725744961f5d3b8a4f96740"
    private let apiVersion: String = "2.5"
    
    var delegate: WeatherManagerDelegate? 
    
    func fetchWeather(cityName: String) {
        let queryString = "appid=\(apiKey)&units=metric&q=\(cityName)"
        let urlString = "\(weatherURL)/data/\(apiVersion)/weather?\(queryString)"
        
        performRequest(with: urlString)
    }
    
    func fetchWeather(lat: String, lon: String) {
        let queryString = "appid=\(apiKey)&units=metric&lat=\(lat)&lon=\(lon)"
        let urlString = "\(weatherURL)/data/\(apiVersion)/weather?\(queryString)"
        
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
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            // Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            return weather
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
