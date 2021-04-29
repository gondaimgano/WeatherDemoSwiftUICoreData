//
//  ExtensionHelper.swift
//  WeatherDemoSwiftUICoreData
//
//  Created by Gondai Mgano on 29/4/2021.
//  Copyright © 2021 Gondai Mgano. All rights reserved.
//

import Foundation


extension Int{
   func toDay()->String{
        let format = DateFormatter()
        let epochTime = TimeInterval(self)
        let date = Date(timeIntervalSince1970: epochTime)
         format.dateFormat = "EEEE"
          let day = format.string(from: date)
    return day
    }
    func toTime()->String{
           let format = DateFormatter()
           let epochTime = TimeInterval(self)
           let date = Date(timeIntervalSince1970: epochTime)
            format.dateFormat = "HH:mm"
             let day = format.string(from: date)
       return day
       }
    
}

extension Int64{
   func toDay()->String{
        let format = DateFormatter()
        let epochTime = TimeInterval(self)
        let date = Date(timeIntervalSince1970: epochTime)
         format.dateFormat = "EEEE"
          let day = format.string(from: date)
    return day
    }
    func toTime()->String{
         let format = DateFormatter()
         let epochTime = TimeInterval(self)
         let date = Date(timeIntervalSince1970: epochTime)
          format.dateFormat = "HH:mm"
           let day = format.string(from: date)
     return day
     }
}

extension Date{
    func toMedium()->String{
        let formatter2 = DateFormatter()
        formatter2.timeStyle = .medium
        return formatter2.string(from: self)
    }
}
