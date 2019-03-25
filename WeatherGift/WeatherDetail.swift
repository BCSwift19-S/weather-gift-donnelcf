//
//  WeatherDetail.swift
//  WeatherGift
//
//  Created by Christopher Donnelly on 3/17/19.
//  Copyright © 2019 Chris Donnelly. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherDetail: WeatherLocation {
    
    struct DailyForecast {
        var dailyMaxTemp: Double
        var dailyMinTemp: Double
        var dailyDate: Double
        var dailySummary: String
        var dailyIcon: String
       
    }
    
    struct HourlyForecast {
        var hourlyTime: Double
        var hourlyTemperature: Double
        var hourlyPrecipProb: Double
        var hourlyIcon: String
    }
    
    var currentTemp = "--"
    var currentSummary = ""
    var currentIcon = ""
    var currentTime = 0.0
    var timeZone = ""
    var dailyForecastArray = [DailyForecast]()
    var hourlyForecastArray = [HourlyForecast]()
    
    func getWeather(completed: @escaping () -> ()) {
        
    
        let weatherURL = urlBase + urlAPIKey + coordinates
        
        Alamofire.request(weatherURL).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let temperature = json["currently"]["temperature"].double {
                    print("temperature: \(temperature)")
                    let roundedTemp = String(format: "%3.f", temperature)
                    self.currentTemp = roundedTemp + "°"
                } else {
                    print("Could not return Temperature")
                }
                if let summary = json["daily"]["summary"].string {
                    self.currentSummary = summary
                } else {
                    print("Could not return Summary")
                }
                if let icon = json["currently"]["icon"].string {
                    self.currentIcon = icon
                } else {
                    print("Could not return Icon")
                }
                if let timeZone = json["timezone"].string {
                    self.timeZone = timeZone
                } else {
                    print("Could not return TimeZone")
                }
                if let time = json["currently"]["time"].double {
                    self.currentTime = time
                } else {
                    print("Could not return Time")
                }
                let dailyDataArray = json["daily"]["data"]
                self.dailyForecastArray = []
                let days = min(7, dailyDataArray.count-1)
                for day in 1...days {
                    let maxTemp = json["daily"]["data"][day]["temperatureHigh"].doubleValue
                    let minTemp = json["daily"]["data"][day]["temperatureLow"].doubleValue
                    let dateValue = json["daily"]["data"][day]["time"].doubleValue
                    let dailySummary = json["daily"]["data"][day]["summary"].stringValue
                    let icon = json["daily"]["data"][day]["icon"].stringValue
                    let newDailyForecast = DailyForecast(dailyMaxTemp: maxTemp, dailyMinTemp: minTemp, dailyDate: dateValue, dailySummary: dailySummary, dailyIcon: icon)
                    self.dailyForecastArray.append(newDailyForecast)
                }
                let hourlyDataArray = json["hourly"]["data"]
                self.hourlyForecastArray = []
                let hours = min(24, hourlyDataArray.count-1)
                for hour in 1...hours{
                    let hourlyTime = json["hourly"]["data"][hour]["time"].doubleValue
                    let hourlyTemperature = json["hourly"]["data"][hour]["temperature"].doubleValue
                    let hourlyPrecipProb = json["hourly"]["data"][hour]["precipProbability"].doubleValue
                    let hourlyIcon = json["hourly"]["data"][hour]["icon"].stringValue
                    let newHourlyForecast = HourlyForecast(hourlyTime: hourlyTime, hourlyTemperature: hourlyTemperature, hourlyPrecipProb: hourlyPrecipProb, hourlyIcon: hourlyIcon)
                    self.hourlyForecastArray.append(newHourlyForecast)
                }
                
                
            case .failure(let error):
                print(error)
            }
            completed()
        }
    }
}
