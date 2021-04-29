//
//  LocationManager.swift
//  WeatherDemoSwiftUICoreData
//
//  Created by Gondai Mgano on 29/4/2021.
//  Copyright © 2021 Gondai Mgano. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData

class WeatherManager:NSObject, CLLocationManagerDelegate,ObservableObject {
  
    @Published var locationManager:CLLocationManager=CLLocationManager()
    @Published var dataList:[Forecast]=[]
    @Published var currentWeather:Weather?
    @Published var isConnected:Bool=true
    @Published var errorMessage = ""
   private var fetchForecastRequest:NSFetchRequest<Forecast>{
         
            let request:NSFetchRequest<Forecast> = Forecast.fetchRequest()
            let sortBy = NSSortDescriptor(key: "dt", ascending: true)
            request.sortDescriptors = [sortBy]
        
            //request.fetchLimit = 20
            return request
        }
    
    private var fetchWeatherRequest:NSFetchRequest<Weather>{
          
             let request:NSFetchRequest<Weather> = Weather.fetchRequest()
             let sortBy = NSSortDescriptor(key: "dateCreated", ascending: false)
             request.sortDescriptors = [sortBy]
         
             request.fetchLimit = 1
             return request
         }
    
    override init() {
        super.init()
        refreshWeather()
        refreshForcast()
        enableLocationServices()
    }
    
    private func refreshForcast(){
        if let data = try? DataController.shared.viewContext.fetch(self.fetchForecastRequest)
              {
               self.dataList = data
                print(self.dataList)
               }
    
    }
    private func refreshWeather(){
        if let data = try? DataController.shared.viewContext.fetch(self.fetchWeatherRequest){
            self.currentWeather = data.first
                //    print(data.first?.dateCreated)
        }
    }
    func enableLocationServices(){
            if (CLLocationManager.locationServicesEnabled())
            {
                locationManager = CLLocationManager()
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestAlwaysAuthorization()
                locationManager.startUpdatingLocation()
            }
        }
        
        
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         
            manager.stopUpdatingLocation()
            
            if let userLocation = locations.last {
            
   
                 
                 
                WeatherService.fetchCurrentWeather(lon:userLocation.coordinate.longitude,lat:userLocation.coordinate.latitude,units:.metric ){
                     data , error in
                    
                     if let data = data{
                        self.isConnected = true
                        let dateCreated = Date()
                        let toSave = Weather(context:DataController.shared.viewContext)
                        toSave.desc = data.weather?.first?.weatherDescription
                        toSave.main = data.weather?.first?.main
                        toSave.lat = data.coord?.lat ?? 0.0
                        toSave.lon = data.coord?.lon ?? 0.0
                        toSave.temp = data.main?.temp ?? 0.0
                        toSave.tempMax = data.main?.tempMax ?? 0.0
                        toSave.tempMin = data.main?.tempMin ?? 0.0
                        toSave.dateCreated = dateCreated
                        if let _ = try? DataController.shared.viewContext.save(){
                            self.refreshWeather()
                        }
                     }
                     if let error = error {
                        //print("=====****")
                        if let err = error.localizedDescription{
                       
                            self.errorMessage = err
                        self.isConnected = false
                        }
                     }
                 }
                
                WeatherService.fetchForecast(lon:userLocation.coordinate.longitude,lat:userLocation.coordinate.latitude,units:.metric  , cnt: 40){
                       data, error in
                    if let error = error {
                        
                         if let err = error.localizedDescription{
                                             
                                                  self.errorMessage = err
                                              self.isConnected = false
                                              }
                    }
                       if let data = data {
                        self.isConnected = true
                           if let dbdata =  try? DataController.shared.viewContext.fetch(self.fetchForecastRequest){
                               self.dataList = dbdata
                            self.dataList.forEach{ toDelete in
                                                          DataController.shared.viewContext.delete(toDelete)
                                                      }
                                                      try? DataController.shared.viewContext.save()
                           }
                          
                           data.list.forEach{
                               item in
                               let toSave = Forecast(context:DataController.shared.viewContext)
                               toSave.desc = item.weather.first?.weatherDescription
                               toSave.dt = Int64(item.dt)
                               toSave.dtTxt = item.dtTxt
                               toSave.temp = item.main.temp
                               toSave.tempMin = item.main.tempMin
                               toSave.tempMax = item.main.tempMax
                               
                           
                           }
                          if let _ =  try? DataController.shared.viewContext.save() {
                           self.refreshForcast()
                           }
                           
                       }
                   }

                
            
         }
                  
    }
}
