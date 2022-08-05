//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    var weatherManage = WeatherManager()
    var forecastManager = ForecastManager()
    let locationManager = CLLocationManager()

    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var forecastScrollView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forecastScrollView.spacing = 20
        
        searchTextField.delegate = self
        
        weatherManage.delegate = self
        forecastManager.delegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

// MARK: - LocationManager Delegate extension

extension WeatherViewController: CLLocationManagerDelegate {
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinates = locations.last?.coordinate {
            locationManager.stopUpdatingLocation()
            weatherManage.fetchWeather(lat: String(coordinates.latitude), lon: String(coordinates.longitude))
            forecastManager.fetchForecast(lat: String(coordinates.latitude), lon: String(coordinates.longitude))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

// MARK: - UITextField Delegate extension

extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cityName = textField.text {
            weatherManage.fetchWeather(cityName: cityName.replacingOccurrences(of: " ", with: "+"))
            forecastManager.fetchForecast(cityName: cityName.replacingOccurrences(of: " ", with: "+"))
        }
        
        searchTextField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
}

// MARK: - WeatherManager Delegate extension

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

// MARK: - Forecast Manager Delegate extension

extension WeatherViewController: ForecastManagerDelegate {
    func didUpdateForecast(_ weatherManager: ForecastManager, forecast: ForecastModel) {
        DispatchQueue.main.async {
            self.removeScrollElements()
            
            for element in forecast.arrayWeatherModel {
                let iconName = element.conditionName
                let temperature = element.temperatureString
                let date = element.dateTime
                
                self.createScrollViewElement(iconName: iconName, temperatureString: temperature, dateTime: date)
            }
        }
    }
    
    func didFailWithErrorForecast(error: Error) {
        print(error)
    }
    
    func createScrollViewElement(iconName: String, temperatureString: String, dateTime: Int) {
        let elementStack = UIStackView()
        elementStack.axis = .vertical
        elementStack.alignment = .center
        elementStack.distribution = .fillEqually
        
        let iconWeather: UIImageView = {
            let image = UIImageView()
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 75)
            image.image = UIImage(systemName: iconName, withConfiguration: largeConfig)
            image.contentMode = .scaleAspectFit
            
            image.tintColor = .init(named: "weatherColor")
            return image
        }()
        
        let temperatureLabelElement: UILabel = {
            let label = UILabel()
            label.text = "\(temperatureString) ºC"
            label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        
            label.textAlignment = .center
            
            return label
        }()
        
        let dateTimeLabel: UILabel = {
            let dateTimeText = UILabel()
            
            let givenTime = Date(timeIntervalSince1970: TimeInterval(dateTime))
            let dateFormatter = DateFormatter()
            
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "h:mm a"
            dateTimeText.textAlignment = .center
            dateTimeText.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            dateTimeText.text = dateFormatter.string(from: givenTime).capitalized
            
            return dateTimeText
        }()
        
        elementStack.addArrangedSubview(dateTimeLabel)
        elementStack.addArrangedSubview(iconWeather)
        elementStack.addArrangedSubview(temperatureLabelElement)
        
        self.forecastScrollView.addArrangedSubview(elementStack)
    }
    
    func removeScrollElements() {
        for view in forecastScrollView.subviews {
            view.removeFromSuperview()
        }
    }
}
