//
//  Covid19Service.swift
//  Covid19Stats
//
//  Created by Gondai Mgano on 9/2/2021.
//  Copyright © 2021 Gondai Mgano. All rights reserved.
//

import Foundation

class WeatherService{
    class func fetchCurrentWeather(lon:Double,lat:Double,units:WeatherUnit, _ completionHandler:@escaping (CurrentWeatherResponse?, HTTPError?) -> Void){
        
        let task = URLSession.shared.dataTask(with: .getCurrentWeather(lon: lon, lat: lat, units: units.rawValue)){
            result in
            switch result{
            case .success(let data):
               // print(data)
                let response = try? JSONDecoder().decode(CurrentWeatherResponse.self, from:data)
                
                DispatchQueue.main.async {
                  completionHandler(response,nil)
                }
            case .failure(let error):
               // print(error)
                DispatchQueue.main.async {
                              completionHandler(nil,error)
                            }
            }
        }
        
        task.resume()
        
    }
    class func fetchForecast(lon:Double,lat:Double,units:WeatherUnit, cnt:Int, _ completionHandler:@escaping (ForcastWeatherResponse?, HTTPError?) -> Void){
        
        let task = URLSession.shared.dataTask(with: .getForcastLastDays(lon: lon, lat: lat, units: units.rawValue, cnt: cnt)){
            result in
            switch result{
            case .success(let data):
            
                let response = try? JSONDecoder().decode(ForcastWeatherResponse.self, from: data)
              // print(response)
                DispatchQueue.main.async {
                  completionHandler(response,nil)
                }
            case .failure(let error):
               // print(error)
                DispatchQueue.main.async {
                              completionHandler(nil,error)
                            }
            }
        }
        
        task.resume()
        
    }
}
